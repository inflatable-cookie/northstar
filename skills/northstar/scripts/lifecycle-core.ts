// Provider-neutral Northstar portable task lifecycle core.
//
// This is the callable standalone runtime: canonical JSON identity, portable
// per-task records, one legal-transition reducer, digest-addressed
// idempotency, a Git-common-directory lock with revision/digest
// compare-and-swap, atomic replacement, and deterministic Markdown
// projections.
//
// It contains no Paseo, Queue, network, daemon, database, or Northstar source
// dependency. The installed skill runs it directly; Effigy is an optional
// adapter. Queue repository hooks are deliberately deferred to a later lane:
// they submit the same transition envelope this core already accepts.
//
// JSON is canonical. Markdown projections are derived. The core never stages,
// commits, pushes, merges, dispatches, reviews, or selects work.

import { createHash, randomUUID } from "node:crypto";
import { spawn, spawnSync } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

// ---------------------------------------------------------------------------
// Frozen vocabulary and framing
// ---------------------------------------------------------------------------

export const RECORD_SCHEMA = "northstar.lifecycle.task-record.v1";
export const ENVELOPE_SCHEMA = "northstar.lifecycle.transition.v1";
export const PROJECTION_SCHEMA = "northstar.lifecycle.projection.v2";
export const GENERATION_RECEIPT_SCHEMA = "northstar.lifecycle.generation-receipt.v1";
export const GENERATION_CLOSURE_SCHEMA = "northstar.lifecycle.generation-closure.v1";
export const FRONTIER_SCHEMA = "northstar.lifecycle.frontier.v2";
export const PROJECTION_TARGETS_SCHEMA = "northstar.lifecycle.projection-targets.v2";

export const STATUSES = ["planned", "ready", "active", "blocked", "complete", "cancelled", "superseded"] as const;
export const STAGES = ["none", "dispatch", "implementation", "review", "merge", "closeout"] as const;

// Generation disposition is open or closed and changes only through an
// explicit committed closure record; complete is never a generation label.
export const DISPOSITIONS = ["open", "closed"] as const;

// Derived runway state of one generation, with deterministic precedence for
// mixed records: live work outranks dispatchable work, which outranks a
// declared blocker, which outranks unstarted plans. planning_required is the
// exhausted state: no nonterminal approved work remains, so the open
// generation asks planning for its next decision instead of implying closure.
export const RUNWAY_STATES = ["planning_required", "planned", "blocked", "ready", "active"] as const;
export const RUNWAY_PRECEDENCE = ["active", "ready", "blocked", "planned"] as const;
export const TERMINAL_STATUSES = new Set(["complete", "cancelled", "superseded"]);
export const EVIDENCE_LEVELS = ["locally_verified", "adapter_attested", "operator_authorized"] as const;
export const TRANSITIONS = ["plan", "ready", "start", "advance_stage", "block", "resume", "complete", "cancel", "supersede"] as const;

// Advance_stage is the only movement verb. Its legal edges are monotonic
// except for the declared revision move review -> implementation, which
// invalidates the review that no longer covers the head.
export const ADVANCE_EDGES: Record<string, string[]> = {
  none: [],
  dispatch: ["implementation"],
  implementation: ["review"],
  review: ["merge", "implementation"],
  merge: ["closeout"],
  closeout: [],
};

// Provider-only evidence slots the core cannot verify locally.
const PROVIDER_ONLY_SLOTS = new Set(["pr", "review"]);
const GIT_ID_RE = /^[0-9a-f]{40}$|^[0-9a-f]{64}$/;
const DIGEST_RE = /^sha256:[0-9a-f]{64}$/;
const TASK_ID_RE = /^g[0-9]{2}\.[0-9]{3}$/;
const TASK_PATH_RE = /^docs\/roadmaps\/g([0-9]{2})\/([0-9]{3})-([a-z0-9]+(?:-[a-z0-9]+)*)\.md$/;
const TIMESTAMP_RE = /^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{3})?Z$/;
const EVENT_ID_RE = /^[A-Za-z0-9._:-]{8,128}$/;

export const BEGIN_PREFIX = "<!-- northstar:lifecycle:begin";
export const END_SENTINEL = "<!-- northstar:lifecycle:end -->";

const GENERATION_RE = /^g[0-9]{2}$/;
export const TARGETS_CONFIG_REL = ".northstar/lifecycle/v1/projection-targets.json";

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const SCHEMA_DIR = path.resolve(SCRIPT_DIR, "..", "references", "lifecycle");
const LIFECYCLE_REL = path.join(".northstar", "lifecycle", "v1");

export class LifecycleError extends Error {
  code: string;
  constructor(code: string, message: string) {
    super(message);
    this.name = "LifecycleError";
    this.code = code;
  }
}

function fail(code: string, message: string): never {
  throw new LifecycleError(code, message);
}

function check(condition: unknown, code: string, message: string): asserts condition {
  if (!condition) fail(code, message);
}

// ---------------------------------------------------------------------------
// Canonical JSON and digest framing (frozen)
// ---------------------------------------------------------------------------

function sortedValue(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(sortedValue);
  if (value !== null && typeof value === "object") {
    const out: Record<string, unknown> = {};
    for (const key of Object.keys(value as Record<string, unknown>).sort()) {
      const entry = (value as Record<string, unknown>)[key];
      if (entry !== undefined) out[key] = sortedValue(entry);
    }
    return out;
  }
  return value;
}

export function canonicalJson(value: unknown): string {
  return JSON.stringify(sortedValue(value));
}

export function sha256Hex(bytes: Buffer | string): string {
  return createHash("sha256").update(bytes).digest("hex");
}

export function digestOf(value: unknown): string {
  return "sha256:" + sha256Hex(Buffer.from(canonicalJson(value), "utf8"));
}

export function digestBytes(bytes: Buffer): string {
  return "sha256:" + sha256Hex(bytes);
}

function deepEqual(a: unknown, b: unknown): boolean {
  return canonicalJson(a) === canonicalJson(b);
}

// ---------------------------------------------------------------------------
// Bounded Draft 2020-12 validator (supported-keyword whitelist, fail closed)
// ---------------------------------------------------------------------------

const SUPPORTED_KEYWORDS = new Set([
  "$schema", "$id", "title", "description", "$defs", "type", "const", "enum",
  "pattern", "minLength", "maxLength", "minimum", "maximum", "required",
  "properties", "additionalProperties", "items", "minItems", "maxItems",
  "uniqueItems", "oneOf", "anyOf", "allOf", "$ref",
]);

const schemaCache = new Map<string, Record<string, unknown>>();

function loadJsonFile(file: string): Record<string, unknown> {
  const cached = schemaCache.get(file);
  if (cached) return cached;
  const parsed = JSON.parse(fs.readFileSync(file, "utf8"));
  check(parsed !== null && typeof parsed === "object" && !Array.isArray(parsed), "schema", "schema is not an object: " + file);
  schemaCache.set(file, parsed as Record<string, unknown>);
  return parsed as Record<string, unknown>;
}

function walkPointer(doc: unknown, pointer: string): unknown {
  let cursor: unknown = doc;
  for (const raw of pointer.split("/")) {
    if (raw === "") continue;
    const token = raw.replace(/~1/g, "/").replace(/~0/g, "~");
    check(cursor !== null && typeof cursor === "object" && !Array.isArray(cursor), "schema", "schema pointer does not resolve: " + pointer);
    cursor = (cursor as Record<string, unknown>)[token];
    check(cursor !== undefined, "schema", "schema pointer does not resolve: " + pointer);
  }
  return cursor;
}

function typeMatches(instance: unknown, expected: string): boolean {
  switch (expected) {
    case "object": return instance !== null && typeof instance === "object" && !Array.isArray(instance);
    case "array": return Array.isArray(instance);
    case "string": return typeof instance === "string";
    case "integer": return typeof instance === "number" && Number.isInteger(instance);
    case "number": return typeof instance === "number";
    case "boolean": return typeof instance === "boolean";
    case "null": return instance === null;
    default: fail("schema", "unsupported schema type: " + expected);
  }
}

function validateNode(instance: unknown, schema: Record<string, unknown>, root: Record<string, unknown>, schemaDir: string, at: string): void {
  for (const key of Object.keys(schema)) {
    check(SUPPORTED_KEYWORDS.has(key), "schema", at + " uses unsupported schema keyword: " + key);
  }
  if (typeof schema.$ref === "string") {
    const hashIndex = schema.$ref.indexOf("#");
    const filePart = hashIndex === -1 ? schema.$ref : schema.$ref.slice(0, hashIndex);
    const pointer = hashIndex === -1 ? "" : schema.$ref.slice(hashIndex + 1);
    let nextRoot = root;
    let nextDir = schemaDir;
    if (filePart) {
      const nextPath = path.resolve(schemaDir, filePart);
      nextRoot = loadJsonFile(nextPath);
      nextDir = path.dirname(nextPath);
    }
    const target = pointer ? walkPointer(nextRoot, pointer) : nextRoot;
    check(target !== null && typeof target === "object" && !Array.isArray(target), "schema", at + " $ref does not resolve to a schema");
    return validateNode(instance, target as Record<string, unknown>, nextRoot, nextDir, at);
  }
  if (schema.type !== undefined) {
    const expected = schema.type;
    if (Array.isArray(expected)) {
      check(expected.some((t) => typeMatches(instance, String(t))), "schema", at + " has wrong type");
    } else {
      check(typeMatches(instance, String(expected)), "schema", at + " has wrong type");
    }
  }
  if (schema.const !== undefined) {
    check(deepEqual(instance, schema.const), "schema", at + " does not match const");
  }
  if (Array.isArray(schema.enum)) {
    check(schema.enum.some((e) => deepEqual(instance, e)), "schema", at + " is not an allowed enum value");
  }
  if (typeof instance === "string") {
    if (typeof schema.pattern === "string") {
      check(new RegExp(schema.pattern).test(instance), "schema", at + " does not match pattern " + schema.pattern);
    }
    if (typeof schema.minLength === "number") {
      check(instance.length >= schema.minLength, "schema", at + " is shorter than minLength");
    }
    if (typeof schema.maxLength === "number") {
      check(instance.length <= schema.maxLength, "schema", at + " is longer than maxLength");
    }
  }
  if (typeof instance === "number") {
    if (typeof schema.minimum === "number") check(instance >= schema.minimum, "schema", at + " is below minimum");
    if (typeof schema.maximum === "number") check(instance <= schema.maximum, "schema", at + " is above maximum");
  }
  if (Array.isArray(instance)) {
    if (typeof schema.minItems === "number") check(instance.length >= schema.minItems, "schema", at + " has too few items");
    if (typeof schema.maxItems === "number") check(instance.length <= schema.maxItems, "schema", at + " has too many items");
    if (schema.uniqueItems === true) {
      const seen = new Set(instance.map((v) => canonicalJson(v)));
      check(seen.size === instance.length, "schema", at + " has duplicate items");
    }
    if (schema.items !== undefined) {
      const itemSchema = schema.items as Record<string, unknown>;
      instance.forEach((element, index) => validateNode(element, itemSchema, root, schemaDir, at + "[" + index + "]"));
    }
  }
  if (instance !== null && typeof instance === "object" && !Array.isArray(instance)) {
    const obj = instance as Record<string, unknown>;
    if (Array.isArray(schema.required)) {
      for (const key of schema.required) {
        check(Object.prototype.hasOwnProperty.call(obj, key), "schema", at + " missing required field: " + key);
      }
    }
    const properties = (schema.properties as Record<string, Record<string, unknown>> | undefined) ?? {};
    for (const key of Object.keys(obj)) {
      if (Object.prototype.hasOwnProperty.call(properties, key)) {
        validateNode(obj[key], properties[key], root, schemaDir, at + "." + key);
      } else if (schema.additionalProperties === false) {
        fail("schema", at + " contains forbidden additional property: " + key);
      } else if (schema.additionalProperties !== undefined && typeof schema.additionalProperties === "object") {
        validateNode(obj[key], schema.additionalProperties as Record<string, unknown>, root, schemaDir, at + "." + key);
      }
    }
  }
  if (Array.isArray(schema.oneOf)) {
    let matches = 0;
    for (const branch of schema.oneOf as Record<string, unknown>[]) {
      try {
        validateNode(instance, branch, root, schemaDir, at);
        matches += 1;
      } catch (err) {
        if (!(err instanceof LifecycleError)) throw err;
      }
    }
    check(matches === 1, "schema", at + " must match exactly one oneOf branch (matched " + matches + ")");
  }
  if (Array.isArray(schema.anyOf)) {
    let matches = 0;
    for (const branch of schema.anyOf as Record<string, unknown>[]) {
      try {
        validateNode(instance, branch, root, schemaDir, at);
        matches += 1;
      } catch (err) {
        if (!(err instanceof LifecycleError)) throw err;
      }
    }
    check(matches >= 1, "schema", at + " must match at least one anyOf branch");
  }
  if (Array.isArray(schema.allOf)) {
    for (const branch of schema.allOf as Record<string, unknown>[]) {
      validateNode(instance, branch, root, schemaDir, at);
    }
  }
}

export function validateAgainstSchemaFile(instance: unknown, schemaFile: string): void {
  const root = loadJsonFile(schemaFile);
  validateNode(instance, root, root, path.dirname(schemaFile), path.basename(schemaFile));
}

function schemaPath(name: string): string {
  return path.join(SCHEMA_DIR, name);
}

export function validateEnvelope(envelope: unknown): void {
  validateAgainstSchemaFile(envelope, schemaPath("transition-envelope.schema.json"));
}

export function validateRecord(record: unknown): void {
  validateAgainstSchemaFile(record, schemaPath("task-record.schema.json"));
}

export function validateProjection(projection: unknown): void {
  validateAgainstSchemaFile(projection, schemaPath("projection.schema.json"));
}

export function validateGenerationClosure(closure: unknown): void {
  validateAgainstSchemaFile(closure, schemaPath("generation-closure.schema.json"));
}

export function validateGenerationReceipt(receipt: unknown): void {
  validateAgainstSchemaFile(receipt, schemaPath("generation-receipt.schema.json"));
}

// ---------------------------------------------------------------------------
// Identity, record shape, and digests
// ---------------------------------------------------------------------------

export interface TaskIdentity {
  taskId: string;
  taskPath: string;
  generation: string;
}

export function parseTaskIdentity(taskId: unknown, taskPath: unknown, generation: unknown): TaskIdentity {
  check(typeof taskId === "string" && TASK_ID_RE.test(taskId), "identity", "invalid task id: " + String(taskId));
  check(typeof taskPath === "string" && TASK_PATH_RE.test(taskPath), "identity", "invalid task path: " + String(taskPath));
  const match = TASK_PATH_RE.exec(taskPath as string)!;
  const fromPath = "g" + match[1] + "." + match[2];
  check(fromPath === taskId, "identity", "task id " + taskId + " does not match path " + taskPath);
  check(generation === "g" + match[1], "identity", "generation " + String(generation) + " does not match path " + taskPath);
  return { taskId: taskId as string, taskPath: taskPath as string, generation: generation as string };
}

export function taskIdForPath(taskPath: string): string {
  const match = TASK_PATH_RE.exec(taskPath);
  check(match !== null, "identity", "invalid task path: " + taskPath);
  return "g" + match![1] + "." + match![2];
}

// Portable digest excludes adapter metadata and the runtime idempotency log so
// equivalent facts from different adapters reduce to the same receipt.
export function portableDigest(record: Record<string, unknown>): string {
  const portable: Record<string, unknown> = {};
  for (const key of Object.keys(record)) {
    if (key === "digest" || key === "portable_digest" || key === "adapter" || key === "applied_events") continue;
    portable[key] = record[key];
  }
  return digestOf(portable);
}

export function recordDigest(record: Record<string, unknown>): string {
  const body: Record<string, unknown> = {};
  for (const key of Object.keys(record)) {
    if (key === "digest") continue;
    body[key] = record[key];
  }
  return digestOf(body);
}

function finalizeRecord(record: Record<string, unknown>): Record<string, unknown> {
  record.portable_digest = portableDigest(record);
  record.digest = recordDigest(record);
  return record;
}

export function verifyRecordIntegrity(record: Record<string, unknown>): void {
  validateRecord(record);
  const expectedDigest = recordDigest(record);
  check(record.digest === expectedDigest, "record-digest", "record digest mismatch for " + record.task_id);
  const expectedPortable = portableDigest(record);
  check(record.portable_digest === expectedPortable, "record-digest", "portable digest mismatch for " + record.task_id);
  if (TERMINAL_STATUSES.has(record.status as string)) {
    check(record.stage === "none", "record-state", "terminal status " + record.status + " must use stage none");
  }
}

// ---------------------------------------------------------------------------
// Reducer
// ---------------------------------------------------------------------------

export interface ReduceContext {
  dependencies?: Record<string, string>;
  verifyCommit?: (gitId: string) => boolean;
  isAncestor?: (ancestor: string, descendant: string) => boolean;
}

export interface ReduceResult {
  record: Record<string, unknown>;
  replay: boolean;
}

export function transitionEdge(
  current: Record<string, unknown> | null,
  transition: string,
  targetStage?: string,
): { status: string; stage: string } {
  check((TRANSITIONS as readonly string[]).includes(transition), "transition", "unknown transition: " + transition);
  if (transition === "plan") {
    check(current === null, "transition", "plan requires no existing record");
    return { status: "planned", stage: "none" };
  }
  check(current !== null, "no-record", "no lifecycle record exists for this task");
  const status = current!.status as string;
  const stage = current!.stage as string;
  switch (transition) {
    case "ready":
      check(status === "planned" && stage === "none", "transition", "ready requires planned/none, found " + status + "/" + stage);
      return { status: "ready", stage: "none" };
    case "start":
      check(status === "ready" && stage === "none", "transition", "start requires ready/none, found " + status + "/" + stage);
      return { status: "active", stage: "dispatch" };
    case "advance_stage": {
      check(status === "active", "transition", "advance_stage requires an active record, found " + status);
      const allowed = ADVANCE_EDGES[stage] ?? [];
      check(typeof targetStage === "string" && allowed.includes(targetStage),
        "transition", "illegal stage move " + stage + " -> " + String(targetStage));
      return { status: "active", stage: targetStage as string };
    }
    case "block":
      check(status === "planned" || status === "ready" || status === "active", "transition", "block requires planned, ready, or active, found " + status);
      return { status: "blocked", stage: typeof targetStage === "string" ? targetStage : stage };
    case "resume":
      check(status === "blocked", "transition", "resume requires a blocked record, found " + status);
      return {
        status: String((current!.block as Record<string, unknown>).resume_status),
        stage: typeof targetStage === "string" ? targetStage : String((current!.block as Record<string, unknown>).resume_stage),
      };
    case "complete":
      check(status === "active" && stage === "closeout", "transition", "complete requires active/closeout, found " + status + "/" + stage);
      return { status: "complete", stage: "none" };
    case "cancel":
      check(["planned", "ready", "active", "blocked"].includes(status), "transition", "cancel requires a non-terminal record, found " + status);
      return { status: "cancelled", stage: "none" };
    case "supersede":
      check(["planned", "ready", "active", "blocked"].includes(status), "transition", "supersede requires a non-terminal record, found " + status);
      return { status: "superseded", stage: "none" };
    default:
      return fail("transition", "unknown transition: " + transition);
  }
}

function resolvedPolicy(current: Record<string, unknown> | null, envelope: Record<string, unknown>): Record<string, unknown> {
  if (envelope.policy !== undefined) return envelope.policy as Record<string, unknown>;
  if (current && current.delivery_policy) return current.delivery_policy as Record<string, unknown>;
  return { mode: "standard" };
}

function requireAuthorization(policy: Record<string, unknown>, evidence: Record<string, unknown>, at: string): void {
  if (policy.mode === "standard" || policy.mode === undefined) return;
  const ref = policy.authorization_ref;
  check(typeof ref === "string" && ref.length > 0, "policy", at + ": " + String(policy.mode) + " policy requires an exact authorization_ref");
  const authorization = evidence.authorization as Record<string, unknown> | undefined;
  check(authorization !== undefined, "policy", at + ": " + String(policy.mode) + " policy requires operator_authorized authorization evidence");
  check(authorization!.level === "operator_authorized", "policy", at + ": authorization evidence must be operator_authorized, found " + String(authorization!.level));
  check(authorization!.ref === ref, "policy", at + ": authorization ref " + String(authorization!.ref) + " does not match declared " + String(ref));
}

function checkEvidenceLevels(evidence: Record<string, unknown>, ctx: ReduceContext): void {
  for (const slot of Object.keys(evidence)) {
    const entry = evidence[slot] as Record<string, unknown>;
    if (entry.level !== "locally_verified") continue;
    check(!PROVIDER_ONLY_SLOTS.has(slot), "evidence-level",
      "core cannot locally verify provider-attested " + slot + " evidence; declare adapter_attested");
    const gitFields = ["head_commit", "merge_commit", "synchronized_main_commit"];
    for (const field of gitFields) {
      const value = entry[field];
      if (typeof value !== "string") continue;
      check(typeof ctx.verifyCommit === "function", "evidence-level",
        "locally_verified " + slot + "." + field + " requires Git object verification");
      check(ctx.verifyCommit!(value), "evidence-level", "locally_verified git object does not exist: " + value);
    }
  }
}

function assertDependenciesReady(dependencies: unknown, ctx: ReduceContext): void {
  if (!Array.isArray(dependencies)) return;
  for (const dep of dependencies) {
    const status = ctx.dependencies?.[String(dep)];
    check(status !== undefined, "dependency", "dependency " + String(dep) + " has no resolvable status");
    check(status === "complete" || status === "superseded", "dependency", "dependency " + String(dep) + " is " + status + ", not complete");
  }
}

function acceptedReview(evidence: Record<string, unknown>, head: string): boolean {
  const review = evidence.review as Record<string, unknown> | undefined;
  return review !== undefined && review.verdict === "approved" && review.head_commit === head;
}

function checkCompletionEvidence(record: Record<string, unknown>, ctx: ReduceContext): void {
  const evidence = record.evidence as Record<string, unknown>;
  const merge = evidence.merge as Record<string, unknown> | undefined;
  check(merge !== undefined, "completion", "completion requires merge evidence");
  check(GIT_ID_RE.test(String(merge!.merge_commit ?? "")), "completion", "merge evidence requires merge_commit");
  check(GIT_ID_RE.test(String(merge!.head_commit ?? "")), "completion", "merge evidence requires head_commit");
  check(merge!.base === "main", "completion", "merge evidence base must be main");
  check(merge!.merge_method === "merge" || merge!.merge_method === "squash" || merge!.merge_method === "rebase",
    "completion", "merge evidence requires merge_method");

  if (merge!.merge_method === "merge" && merge!.level === "locally_verified") {
    check(typeof ctx.isAncestor === "function", "completion", "locally_verified merge ancestry requires a Git verifier");
    check(ctx.isAncestor!(String(merge!.head_commit), String(merge!.merge_commit)), "completion",
      "merge_commit " + String(merge!.merge_commit) + " does not contain reviewed head " + String(merge!.head_commit));
  }

  const integration = evidence.integration as Record<string, unknown> | undefined;
  check(integration !== undefined, "completion", "completion requires synchronized-main integration evidence");
  const syncCommit = String(integration!.synchronized_main_commit ?? "");
  check(GIT_ID_RE.test(syncCommit), "completion", "integration evidence requires synchronized_main_commit");
  // Synchronized main must contain the merge commit. Main may lawfully advance
  // between the merge and closeout (interleaved publications, closeout
  // Markdown), so ancestry — not equality — is the durable local proof. A
  // locally_verified entry is proved by Git ancestry here; an attested entry
  // stays attested and is never upgraded.
  if (integration!.level === "locally_verified") {
    check(typeof ctx.isAncestor === "function", "completion", "locally_verified integration ancestry requires a Git verifier");
    check(ctx.isAncestor!(String(merge!.merge_commit), syncCommit), "completion",
      "synchronized main " + syncCommit + " does not contain the merge commit " + String(merge!.merge_commit));
  }

  const validation = evidence.validation as Record<string, unknown> | undefined;
  check(validation !== undefined, "completion", "completion requires validation evidence");
  check(validation!.passed === true, "completion", "completion requires passing validation evidence");
  check(validation!.head_commit === merge!.head_commit || validation!.head_commit === merge!.merge_commit,
    "completion", "validation evidence is from an unrelated head: " + String(validation!.head_commit));

  const handoff = evidence.handoff as Record<string, unknown> | undefined;
  check(handoff !== undefined, "completion", "completion requires closeout handoff evidence");

  const policy = record.delivery_policy as Record<string, unknown>;
  if (policy.mode === "standard") {
    const pr = evidence.pr as Record<string, unknown> | undefined;
    check(pr !== undefined, "completion", "standard delivery requires PR evidence");
    check(pr!.head_commit === merge!.head_commit, "completion",
      "PR head " + String(pr!.head_commit) + " does not match merged head " + String(merge!.head_commit));
    check(acceptedReview(evidence, String(merge!.head_commit)), "completion",
      "completion requires an accepted review at the exact merged head " + String(merge!.head_commit));
  } else {
    requireAuthorization(policy, evidence, "completion");
  }
}

function checkStageEvidence(edge: { status: string; stage: string }, currentStage: string, evidence: Record<string, unknown>, policy: Record<string, unknown>, ctx: ReduceContext): void {
  if (edge.status !== "active") return;
  if (currentStage === "implementation" && edge.stage === "review") {
    const pr = evidence.pr as Record<string, unknown> | undefined;
    check(pr !== undefined, "stage-evidence", "entering review requires PR evidence");
    check(GIT_ID_RE.test(String(pr!.head_commit ?? "")), "stage-evidence", "PR evidence requires head_commit");
  }
  if (currentStage === "review" && edge.stage === "merge") {
    const merge = evidence.merge as Record<string, unknown> | undefined;
    check(merge !== undefined, "stage-evidence", "entering merge requires merge evidence");
    if (policy.mode === "standard") {
      check(acceptedReview(evidence, String(merge!.head_commit)), "stage-evidence",
        "entering merge requires an accepted review at head " + String(merge!.head_commit));
    } else {
      requireAuthorization(policy, evidence, "entering merge");
    }
  }
  if (currentStage === "merge" && edge.stage === "closeout") {
    const merge = evidence.merge as Record<string, unknown> | undefined;
    check(merge !== undefined, "stage-evidence", "entering closeout requires merge evidence");
  }
}

export function reduce(envelope: Record<string, unknown>, current: Record<string, unknown> | null, ctx: ReduceContext = {}): ReduceResult {
  validateEnvelope(envelope);
  const identity = parseTaskIdentity(envelope.task_id, envelope.task_path, envelope.generation);
  const contentDigest = digestOf(envelope);

  if (current !== null) {
    verifyRecordIntegrity(current);
    check(current.task_id === identity.taskId, "identity", "envelope task id does not match record");
    check(current.task_path === identity.taskPath, "identity", "envelope task path does not match record");
    check(current.generation === identity.generation, "identity", "envelope generation does not match record");
    const planning = current.planning as Record<string, unknown>;
    const incoming = envelope.planning as Record<string, unknown>;
    check(planning.commit === incoming.commit && planning.task_blob_digest === incoming.task_blob_digest,
      "planning-identity", "planning identity changed for " + identity.taskId);
    const prior = (current.applied_events as Record<string, unknown>[]).find((event) => event.event_id === envelope.event_id);
    if (prior) {
      if (prior.content_digest === contentDigest) return { record: current, replay: true };
      return fail("event-conflict", "event id " + String(envelope.event_id) + " was already applied with different content");
    }
    const expected = envelope.expected as Record<string, unknown>;
    check(expected.revision === current.revision, "cas", "stale revision: expected " + String(expected.revision) + ", current " + String(current.revision));
    check(expected.digest === current.digest, "cas", "stale digest: expected " + String(expected.digest) + ", current " + String(current.digest));
  } else {
    check(envelope.transition === "plan", "no-record", "no lifecycle record exists for " + identity.taskId);
    const expected = envelope.expected as Record<string, unknown>;
    check(expected.revision === 0 && expected.digest === null, "cas", "creation requires expected revision 0 and null digest");
  }

  const currentStage = current === null ? "none" : String(current.stage);
  const edge = transitionEdge(current, String(envelope.transition), envelope.target_stage as string | undefined);
  const policy = resolvedPolicy(current, envelope);
  const evidence: Record<string, unknown> = { ...((current?.evidence as Record<string, unknown>) ?? {}), ...((envelope.evidence as Record<string, unknown>) ?? {}) };

  checkEvidenceLevels(evidence, ctx);
  requireAuthorization(policy, evidence, "policy");
  checkStageEvidence(edge, currentStage, evidence, policy, ctx);

  const dependencies = current === null
    ? ((envelope.dependencies as string[] | undefined) ?? [])
    : ((current.dependencies as string[]) ?? []);
  check(!(dependencies as string[]).includes(identity.taskId), "dependency", "task cannot depend on itself");
  if (edge.status === "ready") assertDependenciesReady(dependencies, ctx);

  // Revision move review -> implementation invalidates the superseded review.
  if (edge.status === "active" && currentStage === "review" && edge.stage === "implementation") {
    check(typeof envelope.reason === "string" && envelope.reason.length > 0, "transition", "review revision requires a reason");
    for (const slot of ["review", "merge", "integration", "validation"]) delete evidence[slot];
  }

  if (edge.status === "blocked") {
    check(typeof envelope.reason === "string" && envelope.reason.length > 0, "transition", "block requires a typed reason");
  }
  if (edge.status === "cancelled" || edge.status === "superseded") {
    check(typeof envelope.reason === "string" && envelope.reason.length > 0, "transition", String(envelope.transition) + " requires a reason");
  }
  if (envelope.transition === "supersede") {
    check(typeof envelope.superseded_by === "string" && envelope.superseded_by.length > 0, "transition", "supersede requires superseded_by");
  }

  const revision = current === null ? 1 : Number(current.revision) + 1;
  const next: Record<string, unknown> = {
    schema_version: RECORD_SCHEMA,
    task_id: identity.taskId,
    task_path: identity.taskPath,
    generation: identity.generation,
    planning: envelope.planning,
    revision,
    status: edge.status,
    stage: edge.stage,
    dependencies,
    delivery_policy: policy,
    evidence,
    applied_events: [
      ...((current?.applied_events as Record<string, unknown>[]) ?? []),
      { event_id: envelope.event_id, content_digest: contentDigest, transition: envelope.transition, revision },
    ],
    adapter: { name: String((envelope.source as Record<string, unknown>).adapter), ...(((envelope.source as Record<string, unknown>).instance !== undefined) ? { instance: String((envelope.source as Record<string, unknown>).instance) } : {}) },
    updated_at: envelope.event_time,
  };
  if (edge.status === "blocked") {
    const priorStatus = current === null ? "planned" : String(current.status);
    const priorStage = currentStage;
    next.block = {
      reason_code: typeof envelope.reason_code === "string" ? envelope.reason_code : "declared",
      reason: envelope.reason,
      prior_status: priorStatus,
      prior_stage: priorStage,
      resume_status: priorStatus === "blocked" ? "active" : priorStatus,
      resume_stage: typeof envelope.target_stage === "string" ? envelope.target_stage : priorStage,
      blocked_at: envelope.event_time,
    };
  }

  if (edge.status === "complete") checkCompletionEvidence(next, ctx);

  return { record: finalizeRecord(next), replay: false };
}

// ---------------------------------------------------------------------------
// Generation disposition and derived runway state
// ---------------------------------------------------------------------------

export interface GenerationState {
  generation: string;
  disposition: string;
  runway: string;
}

// One closed machine vocabulary for the derived runway state. Nonterminal
// records never collapse into planning_required: the precedence list keeps
// parallel ready, active, blocked, and planned work separately visible.
export function runwayOf(records: Record<string, unknown>[]): string {
  const present = new Set<string>();
  for (const record of records) {
    const status = String(record.status);
    check((STATUSES as readonly string[]).includes(status), "runway", "unknown task status: " + status);
    if (!TERMINAL_STATUSES.has(status)) present.add(status);
  }
  for (const state of RUNWAY_PRECEDENCE) {
    if (present.has(state)) return state;
  }
  return "planning_required";
}

export function generationClosurePath(repoRoot: string, generation: string): string {
  check(typeof generation === "string" && GENERATION_RE.test(generation), "identity", "invalid generation: " + String(generation));
  return path.join(lifecycleRoot(repoRoot), "generations", generation + ".closure.json");
}

// Closure authority is exact and repository-verifiable: the committed record
// must carry this generation and validate against the closure schema.
// Absence of the file is the open disposition, never an error here.
export function verifyGenerationClosure(closure: Record<string, unknown>, generation: string): void {
  validateGenerationClosure(closure);
  check(closure.generation === generation, "generation-closure",
    "closure record names generation " + String(closure.generation) + ", expected " + generation);
}

export function readGenerationClosure(repoRoot: string, generation: string): Record<string, unknown> | null {
  const file = generationClosurePath(repoRoot, generation);
  if (!fs.existsSync(file)) return null;
  let parsed: unknown;
  try {
    parsed = JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    return fail("closure-parse", "generation closure record is not valid JSON: " + file);
  }
  check(parsed !== null && typeof parsed === "object" && !Array.isArray(parsed), "closure-parse", "generation closure record is not an object: " + file);
  const closure = parsed as Record<string, unknown>;
  verifyGenerationClosure(closure, generation);
  return closure;
}

export function generationStateOf(records: Record<string, unknown>[], generation: string, closure: Record<string, unknown> | null): GenerationState {
  check(typeof generation === "string" && GENERATION_RE.test(generation), "identity", "invalid generation: " + String(generation));
  let disposition = "open";
  if (closure !== null) {
    verifyGenerationClosure(closure, generation);
    disposition = String(closure.disposition);
  }
  const scoped = records.filter((record) => record.generation === generation);
  const runway = runwayOf(scoped);
  if (disposition === "closed") {
    const offender = scoped.find((record) => !TERMINAL_STATUSES.has(String(record.status)));
    check(offender === undefined, "generation-closed",
      "generation " + generation + " is closed but " + String(offender?.task_id ?? "(unknown)") + " is " + String(offender?.status ?? "nonterminal"));
  }
  return { generation, disposition, runway };
}

// ---------------------------------------------------------------------------
// Deterministic Markdown projections
// ---------------------------------------------------------------------------

export interface ProjectionEntry {
  task_id: string;
  status: string;
  stage: string;
  revision: number;
  record_digest: string;
}

export function projectionEntries(records: Record<string, unknown>[]): ProjectionEntry[] {
  return records
    .map((record) => ({
      task_id: String(record.task_id),
      status: String(record.status),
      stage: String(record.stage),
      revision: Number(record.revision),
      record_digest: String(record.digest),
    }))
    .sort((a, b) => (a.task_id < b.task_id ? -1 : a.task_id > b.task_id ? 1 : 0));
}

// The projection binds each declared active generation's state and the
// scoped entry set into one source digest. The singular form keeps the exact
// historical object shape (and therefore byte-identical rendered blocks); the
// parallel form renders one generation row per active generation in stable
// lexical order, with task records grouped by generation and task id.
export function buildProjectionStates(records: Record<string, unknown>[], declaredStates: GenerationState[]): Record<string, unknown> {
  check(Array.isArray(declaredStates) && declaredStates.length > 0, "projection",
    "projection requires at least one declared active generation");
  const states = [...declaredStates].sort((a, b) => (a.generation < b.generation ? -1 : a.generation > b.generation ? 1 : 0));
  check(new Set(states.map((state) => state.generation)).size === states.length, "projection",
    "projection received duplicate generation states");
  const activeSet = new Set(states.map((state) => state.generation));
  const entries = projectionEntries(records.filter((record) => activeSet.has(String(record.generation))));
  if (states.length === 1) {
    const state = states[0]!;
    const projection = {
      schema_version: PROJECTION_SCHEMA,
      generation: state.generation,
      disposition: state.disposition,
      runway_state: state.runway,
      source_digest: digestOf({ disposition: state.disposition, entries, generation: state.generation, runway_state: state.runway }),
      entries,
    };
    validateProjection(projection);
    return projection;
  }
  const generations = states.map((state) => ({ generation: state.generation, disposition: state.disposition, runway_state: state.runway }));
  const projection = {
    schema_version: PROJECTION_SCHEMA,
    generations,
    source_digest: digestOf({ entries, generations }),
    entries,
  };
  validateProjection(projection);
  return projection;
}

export function buildProjection(records: Record<string, unknown>[], state: GenerationState): Record<string, unknown> {
  return buildProjectionStates(records, [state]);
}

export function renderProjectionBlock(projection: Record<string, unknown>): string {
  validateProjection(projection);
  const entries = projection.entries as ProjectionEntry[];
  const stateRows = projection.generations !== undefined
    ? (projection.generations as { generation: string; disposition: string; runway_state: string }[])
      .map((row) => "| " + row.generation + " | " + row.disposition + " | " + row.runway_state + " |")
    : ["| " + String(projection.generation) + " | " + String(projection.disposition) + " | " + String(projection.runway_state) + " |"];
  const lines = [
    BEGIN_PREFIX + " schema=" + PROJECTION_SCHEMA + " digest=" + String(projection.source_digest) + " -->",
    "| Generation | Disposition | Runway state |",
    "| --- | --- | --- |",
    ...stateRows,
    "| Task | Status | Stage | Revision | Record digest |",
    "| --- | --- | --- | --- | --- |",
  ];
  for (const entry of entries) {
    lines.push("| " + entry.task_id + " | " + entry.status + " | " + entry.stage + " | " + entry.revision + " | " + entry.record_digest + " |");
  }
  lines.push(END_SENTINEL);
  return lines.join("\n");
}

function findProjectionRange(text: string): { start: number; end: number } | null {
  const startIndex = text.indexOf(BEGIN_PREFIX);
  if (startIndex === -1) return null;
  const endIndex = text.indexOf(END_SENTINEL, startIndex);
  if (endIndex === -1) return null;
  return { start: startIndex, end: endIndex + END_SENTINEL.length };
}

export function renderProjectionInto(text: string, projection: Record<string, unknown>): { text: string; changed: boolean; block: string } {
  const block = renderProjectionBlock(projection);
  const normalized = text.replace(/\r\n/g, "\n");
  const range = findProjectionRange(normalized);
  if (range) {
    const next = normalized.slice(0, range.start) + block + normalized.slice(range.end);
    return { text: next, changed: next !== normalized, block };
  }
  const base = normalized.length === 0 ? "" : normalized.endsWith("\n") ? normalized : normalized + "\n";
  const next = base + block + "\n";
  return { text: next, changed: next !== normalized, block };
}

export function verifyProjectionText(text: string, records: Record<string, unknown>[], state: GenerationState | GenerationState[]): void {
  const projection = buildProjectionStates(records, Array.isArray(state) ? state : [state]);
  const expected = renderProjectionBlock(projection);
  const range = findProjectionRange(text.replace(/\r\n/g, "\n"));
  check(range !== null, "projection-drift", "generated lifecycle block is missing");
  const actual = text.replace(/\r\n/g, "\n").slice(range!.start, range!.end);
  check(actual === expected, "projection-drift", "generated lifecycle block drifted from the canonical records");
}

// ---------------------------------------------------------------------------
// Standalone adapter: repository discovery, lock, CAS, atomic write
// ---------------------------------------------------------------------------

export interface ProjectionConfig {
  schema_version: string;
  targets: string[];
  // Singular declared form. Present exactly when the config used the
  // `active_generation` key, so doctrine and tooling can tell which spelling
  // the repository committed.
  active_generation?: string;
  // Normalized active-generation set, in lexical order, for both forms. This
  // is the membership authority: a task transition is valid only when its
  // generation is in this set.
  active_generations: string[];
}

// Read and validate the repository-declared projection configuration. The v2
// config declares its active generations with exactly one of the singular
// `active_generation` key or the plural `active_generations` key; the plural
// form is a non-empty, lexically sorted, duplicate-free list of gNN
// generations. Mixed, missing, unsorted, empty, or duplicated declarations
// fail closed. The plural form records an already-authorized repository mode;
// it never grants parallel planning authority by itself — the repository's
// roadmap mode must authorize the set. Returns null when the config is
// absent; callers decide whether that is lawful for their surface.
export function readProjectionConfig(repoRoot: string): ProjectionConfig | null {
  const configPath = path.join(repoRoot, TARGETS_CONFIG_REL);
  if (!fs.existsSync(configPath)) return null;
  let parsed: unknown;
  try {
    parsed = JSON.parse(fs.readFileSync(configPath, "utf8"));
  } catch {
    return fail("projection-config", "projection targets config is not valid JSON: " + TARGETS_CONFIG_REL);
  }
  check(parsed !== null && typeof parsed === "object" && !Array.isArray(parsed), "projection-config", "projection targets config is not an object");
  const config = parsed as Record<string, unknown>;
  check(config.schema_version === PROJECTION_TARGETS_SCHEMA,
    "projection-config", "projection targets config has an unsupported schema_version: " + String(config.schema_version) + " (expected " + PROJECTION_TARGETS_SCHEMA + " with an active_generation or active_generations declaration)");
  const declared = config.targets;
  check(Array.isArray(declared) && declared.length <= 64 && declared.every((t) => typeof t === "string" && t.length > 0),
    "projection-config", "projection targets config must carry at most 64 non-empty target paths");
  check(new Set(declared as string[]).size === (declared as string[]).length, "projection-config", "projection targets config has duplicate entries");
  const hasSingular = Object.prototype.hasOwnProperty.call(config, "active_generation");
  const hasPlural = Object.prototype.hasOwnProperty.call(config, "active_generations");
  check(hasSingular !== hasPlural, "projection-config",
    "projection targets config must declare exactly one of active_generation or active_generations, found " +
    (hasSingular && hasPlural ? "both keys" : "neither key"));
  let generations: string[];
  if (hasSingular) {
    check(typeof config.active_generation === "string" && GENERATION_RE.test(config.active_generation),
      "projection-config", "projection targets config must declare the active generation as gNN");
    generations = [config.active_generation as string];
  } else {
    const list = config.active_generations;
    check(Array.isArray(list) && list.length > 0 && list.length <= 16,
      "projection-config", "projection targets config must declare active_generations as 1-16 gNN generations");
    check((list as unknown[]).every((g) => typeof g === "string" && GENERATION_RE.test(g)),
      "projection-config", "projection targets config must declare every active generation as gNN");
    const sorted = [...(list as string[])].sort();
    check(canonicalJson(list) === canonicalJson(sorted), "projection-config",
      "projection targets config must declare active_generations in lexical order; sorting is never silent");
    check(new Set(list as string[]).size === (list as string[]).length, "projection-config",
      "projection targets config declares duplicate active generations");
    generations = list as string[];
  }
  return {
    schema_version: PROJECTION_TARGETS_SCHEMA,
    targets: (declared as string[]).map((target) => containRepoPath(repoRoot, target)),
    ...(hasSingular ? { active_generation: generations[0] } : {}),
    active_generations: generations,
  };
}

export function requireProjectionConfig(repoRoot: string): ProjectionConfig {
  const config = readProjectionConfig(repoRoot);
  check(config !== null, "projection-config",
    TARGETS_CONFIG_REL + " is missing; rendering lifecycle state requires the declared active generation");
  return config as ProjectionConfig;
}

function git(args: string[], cwd: string): string {
  const result = spawnSync("git", args, { cwd, encoding: "utf8" });
  if (result.status !== 0) {
    fail("git", "git " + args.join(" ") + " failed: " + String(result.stderr || result.stdout).trim());
  }
  return String(result.stdout).trim();
}

function gitBytes(args: string[], cwd: string): Buffer {
  const result = spawnSync("git", args, { cwd });
  if (result.status !== 0) {
    fail("git", "git " + args.join(" ") + " failed: " + String(result.stderr).trim());
  }
  return result.stdout;
}

export function discoverRepoRoot(start: string): string {
  const root = git(["rev-parse", "--show-toplevel"], start);
  check(root.length > 0, "repo", "could not discover a Git repository root from " + start);
  return fs.realpathSync(root);
}

export function gitCommonDir(repoRoot: string): string {
  const dir = git(["rev-parse", "--git-common-dir"], repoRoot);
  return path.isAbsolute(dir) ? dir : path.resolve(repoRoot, dir);
}

export function lifecycleRoot(repoRoot: string): string {
  return path.join(repoRoot, LIFECYCLE_REL);
}

export function recordFilePath(repoRoot: string, taskId: string): string {
  check(TASK_ID_RE.test(taskId), "identity", "invalid task id: " + taskId);
  return path.join(lifecycleRoot(repoRoot), "tasks", taskId + ".json");
}

export function assertContained(repoRoot: string, relative: string): string {
  check(typeof relative === "string" && relative.length > 0, "containment", "empty path");
  check(!path.isAbsolute(relative), "containment", "absolute path is not allowed: " + relative);
  const resolved = path.resolve(repoRoot, relative);
  const rootWithSep = repoRoot.endsWith(path.sep) ? repoRoot : repoRoot + path.sep;
  check(resolved === repoRoot || resolved.startsWith(rootWithSep), "containment", "path escapes repository root: " + relative);
  return resolved;
}

// Normalize an explicit caller-supplied path (relative or absolute) to a
// repository-relative path and refuse any escape. Used by the explicit-path
// render/compact commands and by adapter-supplied projection targets so an
// absolute spelling cannot bypass the relative-path check.
export function containRepoPath(repoRoot: string, value: string): string {
  check(typeof value === "string" && value.length > 0, "containment", "empty path");
  const absolute = path.isAbsolute(value) ? path.normalize(value) : path.resolve(repoRoot, value);
  const relative = path.relative(repoRoot, absolute);
  check(relative.length > 0 && !relative.startsWith("..") && !path.isAbsolute(relative),
    "containment", "path escapes repository root: " + value);
  return relative.split(path.sep).join("/");
}

// Follows symlinks on the nearest existing ancestor so a symlinked lifecycle
// directory cannot redirect records outside the repository.
export function assertRealContained(repoRoot: string, target: string): void {
  const rootReal = fs.existsSync(repoRoot) ? fs.realpathSync(repoRoot) : repoRoot;
  let cursor = target;
  while (!fs.existsSync(cursor)) {
    const parent = path.dirname(cursor);
    if (parent === cursor) break;
    cursor = parent;
  }
  const real = fs.realpathSync(cursor);
  const rootWithSep = rootReal.endsWith(path.sep) ? rootReal : rootReal + path.sep;
  check(real === rootReal || real.startsWith(rootWithSep), "containment", "resolved path escapes repository root: " + target);
}

export function readRecord(repoRoot: string, taskId: string): Record<string, unknown> | null {
  const file = recordFilePath(repoRoot, taskId);
  if (!fs.existsSync(file)) return null;
  let parsed: unknown;
  try {
    parsed = JSON.parse(fs.readFileSync(file, "utf8"));
  } catch (err) {
    return fail("record-parse", "record is not valid JSON: " + file);
  }
  check(parsed !== null && typeof parsed === "object" && !Array.isArray(parsed), "record-parse", "record is not an object: " + file);
  return parsed as Record<string, unknown>;
}

export function listRecords(repoRoot: string): Record<string, unknown>[] {
  const dir = path.join(lifecycleRoot(repoRoot), "tasks");
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir)
    .filter((name) => name.endsWith(".json") && !name.startsWith("."))
    .sort()
    .map((name) => JSON.parse(fs.readFileSync(path.join(dir, name), "utf8")) as Record<string, unknown>);
}

export function writeFileAtomic(finalPath: string, data: string): void {
  const dir = path.dirname(finalPath);
  fs.mkdirSync(dir, { recursive: true });
  const tmp = path.join(dir, ".tmp-" + process.pid + "-" + randomUUID() + ".json");
  const fd = fs.openSync(tmp, "w", 0o644);
  try {
    fs.writeSync(fd, data);
    fs.fsyncSync(fd);
  } finally {
    fs.closeSync(fd);
  }
  fs.renameSync(tmp, finalPath);
}

function processAlive(pid: number): boolean {
  try {
    process.kill(pid, 0);
    return true;
  } catch (err) {
    return (err as NodeJS.ErrnoException).code === "EPERM";
  }
}

function withLifecycleLock(repoRoot: string, action: () => void): void {
  const common = gitCommonDir(repoRoot);
  fs.mkdirSync(common, { recursive: true });
  const lock = path.join(common, "northstar-lifecycle.lock");
  let acquired = false;
  let retriedStale = false;
  while (!acquired) {
    try {
      const fd = fs.openSync(lock, "wx");
      fs.writeSync(fd, String(process.pid));
      fs.closeSync(fd);
      acquired = true;
    } catch (err) {
      if ((err as NodeJS.ErrnoException).code !== "EEXIST") throw err;
      let owner = -1;
      try {
        owner = Number.parseInt(fs.readFileSync(lock, "utf8").trim(), 10);
      } catch {
        owner = -1;
      }
      if (owner > 0 && !processAlive(owner) && !retriedStale) {
        retriedStale = true;
        fs.rmSync(lock, { force: true });
        continue;
      }
      fail("lock", "lifecycle lock is held by " + (owner > 0 ? "pid " + owner : "an unknown writer"));
    }
  }
  try {
    action();
  } finally {
    fs.rmSync(lock, { force: true });
  }
}

function assertBranch(repoRoot: string, branch: string): void {
  const result = spawnSync("git", ["symbolic-ref", "--short", "-q", "HEAD"], { cwd: repoRoot, encoding: "utf8" });
  const current = String(result.stdout).trim();
  check(current === branch, "branch", "authority-changing writes require branch " + branch + ", found " + (current || "(detached)"));
}

function assertRecordPathClean(repoRoot: string, file: string): void {
  const relative = path.relative(repoRoot, file);
  const tracked = spawnSync("git", ["ls-files", "--error-unmatch", "--", relative], { cwd: repoRoot, encoding: "utf8" });
  if (tracked.status !== 0) return;
  const dirty = spawnSync("git", ["status", "--porcelain", "--untracked-files=no", "--", relative], { cwd: repoRoot, encoding: "utf8" });
  check(String(dirty.stdout).trim() === "", "dirty", "record path has uncommitted changes: " + relative);
}

export interface ApplyOptions {
  repoRoot: string;
  envelope: Record<string, unknown>;
  branch?: string;
  // Repository-declared projection targets. Every target is containment- and
  // symlink-checked before any mutation, then regenerated inside the record
  // write lock. Exact changed paths are returned; nothing is staged.
  targets?: string[];
  // Test seam: the atomic writer is injectable so interruption behavior can
  // be exercised without weakening the production path.
  writeFile?: (finalPath: string, data: string) => void;
  // Terminal-closeout marker convergence: remove adapter-owned `Status:`
  // marker lines from the exact task file inside this same locked write, so
  // the terminal record and the converged task file are one byte transaction.
  // Ambiguous status-looking prose fails closed before any byte changes.
  convergeTaskStatus?: boolean;
  // Chain-scoped record hygiene: the queued closeout hook asserts the record
  // state once per chain against the committed record (see the hook's chain
  // check), so its envelopes after the first legitimately see the record
  // dirty with their own previous write. Default false keeps the strict
  // dirty-owned-path refusal for every ordinary caller, standalone or not.
  skipRecordHygiene?: boolean;
}

export interface ApplyResult {
  status: "applied" | "replayed";
  task_id: string;
  revision: number;
  digest: string;
  portable_digest: string;
  changed_paths: string[];
  commit_action: { required: boolean; paths: string[] };
}

export function applyEnvelope(options: ApplyOptions): ApplyResult {
  const repoRoot = options.repoRoot;
  const envelope = options.envelope;
  validateEnvelope(envelope);
  const identity = parseTaskIdentity(envelope.task_id, envelope.task_path, envelope.generation);
  assertContained(repoRoot, identity.taskPath);
  const branch = options.branch ?? "main";
  assertBranch(repoRoot, branch);

  // Validate every declared target before anything else: one bad target must
  // fail closed ahead of any verification or mutation.
  const targetPaths: string[] = [];
  for (const target of options.targets ?? []) {
    const contained = containRepoPath(repoRoot, target);
    const absolute = path.resolve(repoRoot, contained);
    assertRealContained(repoRoot, fs.existsSync(absolute) ? absolute : path.dirname(absolute));
    targetPaths.push(absolute);
  }

  const planning = envelope.planning as Record<string, unknown>;
  const commit = String(planning.commit);
  const resolvedResult = spawnSync("git", ["rev-parse", "--verify", commit + "^{commit}"], { cwd: repoRoot, encoding: "utf8" });
  check(resolvedResult.status === 0, "planning-identity", "planning commit is not a resolvable Git commit: " + commit);
  const resolvedCommit = String(resolvedResult.stdout).trim();
  const blobResult = spawnSync("git", ["cat-file", "blob", resolvedCommit + ":" + identity.taskPath], { cwd: repoRoot });
  check(blobResult.status === 0, "planning-identity", "planning commit " + resolvedCommit + " does not contain " + identity.taskPath);
  const blobDigest = digestBytes(blobResult.stdout);
  check(blobDigest === planning.task_blob_digest, "planning-identity",
    "task blob digest mismatch at " + resolvedCommit + ": " + blobDigest);

  const ctx: ReduceContext = {
    dependencies: (() => {
      const statuses: Record<string, string> = {};
      for (const record of listStateRecords(repoRoot)) statuses[String(record.task_id)] = String(record.status);
      return statuses;
    })(),
    verifyCommit: (gitId: string) => spawnSync("git", ["rev-parse", "--verify", gitId + "^{commit}"], { cwd: repoRoot }).status === 0,
    isAncestor: (ancestor: string, descendant: string) => {
      const result = spawnSync("git", ["merge-base", "--is-ancestor", ancestor, descendant], { cwd: repoRoot });
      if (result.status === 0) return true;
      if (result.status === 1) return false;
      fail("git", "git merge-base failed for " + ancestor + " " + descendant);
    },
  };

  // A closed generation is terminal history: every envelope against its tasks
  // refuses, so exhausted-runway records can never be resurrected or retracted
  // through the lifecycle path.
  const taskClosure = readGenerationClosure(repoRoot, identity.generation);
  check(taskClosure === null || taskClosure.disposition !== "closed", "generation-closed",
    "generation " + identity.generation + " is closed by " + generationClosurePath(repoRoot, identity.generation).replace(repoRoot + path.sep, "") + "; its task records are sealed");

  // The declared active-generation set is the membership authority: a task
  // transition is valid only when its generation is in the normalized set.
  // Rendering projections requires a declared set; record-only writes stay
  // lawful in repositories that have not declared one.
  const config = readProjectionConfig(repoRoot);
  if (config !== null && !config.active_generations.includes(identity.generation)) {
    fail("projection-config",
      "generation " + identity.generation + " is not in the declared active-generation set (" + config.active_generations.join(", ") + ")");
  }
  if (targetPaths.length > 0) {
    check(config !== null, "projection-config",
      TARGETS_CONFIG_REL + " is missing; rendering lifecycle state requires a declared active-generation set");
  }

  const file = recordFilePath(repoRoot, identity.taskId);
  assertRealContained(repoRoot, path.dirname(file));
  let result: ApplyResult | null = null;
  withLifecycleLock(repoRoot, () => {
    const current = readRecord(repoRoot, identity.taskId);
    if (options.skipRecordHygiene !== true) assertRecordPathClean(repoRoot, file);
    const reduced = reduce(envelope, current, ctx);
    if (reduced.replay) {
      result = {
        status: "replayed",
        task_id: identity.taskId,
        revision: Number(reduced.record.revision),
        digest: String(reduced.record.digest),
        portable_digest: String(reduced.record.portable_digest),
        changed_paths: [],
        commit_action: { required: false, paths: [] },
      };
      return;
    }
    verifyRecordIntegrity(reduced.record);
    // Marker convergence runs before the record write so an ambiguous
    // status-looking line fails closed with zero bytes written.
    let taskConverged = false;
    if (options.convergeTaskStatus === true) {
      const taskAbs = assertContained(repoRoot, identity.taskPath);
      assertRealContained(repoRoot, taskAbs);
      let taskStats: fs.Stats | null = null;
      try {
        taskStats = fs.lstatSync(taskAbs);
      } catch {
        taskStats = null;
      }
      check(taskStats === null || !taskStats.isSymbolicLink(), "task-path",
        "task path " + identity.taskPath + " is a symlink; refusing marker convergence");
      check(taskStats === null || taskStats.isFile(), "task-path",
        "task path " + identity.taskPath + " is not a regular file");
      if (taskStats !== null) {
        const existing = fs.readFileSync(taskAbs, "utf8");
        const converged = convergeStatusMarkers(existing);
        if (converged.ambiguous.length > 0) {
          fail("ambiguous-status-marker",
            "task path " + identity.taskPath + " carries a status-looking line in section \"" +
              converged.ambiguous[0]!.section + "\" that could be human prose; refusing marker convergence");
        }
        if (converged.removed > 0) {
          writeFileAtomic(taskAbs, converged.text);
          taskConverged = true;
        }
      }
    }
    (options.writeFile ?? writeFileAtomic)(file, canonicalJson(reduced.record) + "\n");
    const changed = [path.relative(repoRoot, file)];
    if (taskConverged) changed.push(identity.taskPath);
    const records = listRecords(repoRoot);
    let projection: Record<string, unknown> | null = null;
    if (config !== null) {
      const states = config.active_generations.map((generation) =>
        generationStateOf(records, generation, readGenerationClosure(repoRoot, generation)));
      projection = buildProjectionStates(records, states);
    }
    for (const targetAbs of targetPaths) {
      const existing = fs.existsSync(targetAbs) ? fs.readFileSync(targetAbs, "utf8") : "";
      const projected = renderProjectionInto(existing, projection!);
      if (projected.changed) {
        writeFileAtomic(targetAbs, projected.text);
        changed.push(path.relative(repoRoot, targetAbs));
      }
    }
    changed.sort();
    const uniqueChanged = [...new Set(changed)].sort();
    result = {
      status: "applied",
      task_id: identity.taskId,
      revision: Number(reduced.record.revision),
      digest: String(reduced.record.digest),
      portable_digest: String(reduced.record.portable_digest),
      changed_paths: uniqueChanged,
      commit_action: { required: true, paths: uniqueChanged },
    };
  });
  return result as unknown as ApplyResult;
}

// Read-only modes

export function frontierOf(records: Record<string, unknown>[], generation?: string | string[]): Record<string, unknown> {
  const scope = generation === undefined
    ? undefined
    : new Set(Array.isArray(generation) ? generation.map(String) : [String(generation)]);
  const scoped = scope === undefined ? records : records.filter((record) => scope.has(String(record.generation)));
  const eligible = scoped
    .filter((record) => record.status === "ready")
    .map((record) => String(record.task_id))
    .sort();
  return {
    schema_version: FRONTIER_SCHEMA,
    status: runwayOf(scoped),
    eligible,
  };
}

export function verifyRepo(repoRoot: string, target?: string): Record<string, unknown> {
  const records = listRecords(repoRoot);
  const problems: string[] = [];
  for (const record of records) {
    try {
      verifyRecordIntegrity(record);
    } catch (err) {
      problems.push((err as Error).message);
    }
  }
  // A compacted closed generation is a first-class live artifact: a malformed
  // receipt or one whose closure provenance no longer holds is drift exactly
  // like a malformed task record.
  try {
    for (const { generation, receipt } of listGenerationReceipts(repoRoot)) {
      try {
        const closure = readGenerationClosure(repoRoot, generation);
        if (closure === null) {
          problems.push("generation " + generation + " has a receipt but no closure record");
          continue;
        }
        verifyReceiptProvenance(receipt, generation, closure);
      } catch (err) {
        problems.push((err as Error).message);
      }
    }
  } catch (err) {
    problems.push((err as Error).message);
  }
  if (target && fs.existsSync(target)) {
    try {
      const config = requireProjectionConfig(repoRoot);
      const states = config.active_generations.map((generation) =>
        generationStateOf(records, generation, readGenerationClosure(repoRoot, generation)));
      verifyProjectionText(fs.readFileSync(target, "utf8"), records, states);
    } catch (err) {
      problems.push((err as Error).message);
    }
  }
  return { status: problems.length === 0 ? "ok" : "drift", problems, record_count: records.length };
}

// ---------------------------------------------------------------------------
// Sole-source currentness audit
// ---------------------------------------------------------------------------

// One duplicate mechanical currentness finding. `file` is the
// repository-relative posix path, `section` the enclosing Markdown heading (or
// `header` before the first heading, or `table` for a Next-task table column),
// `task` the lifecycle-managed task ID whose mutable state was repeated, and
// `reason` one of `duplicate-status-header`, `stale-frontier`,
// `stale-next-task-column`, or `missing-task-file`.
export interface CurrentnessViolation {
  file: string;
  section: string;
  task: string;
  reason: string;
}

const TASK_ID_SCAN_RE = /g[0-9]{2}\.[0-9]{3}(?![0-9])/g;
// The one shared `Status:` marker rule: the exact header-line shape the
// currentness audit attributes to a lifecycle-managed task path. Detection
// (audit), removal (terminal-closeout convergence) and the ownership test all
// test this one regex, so they can never disagree about what counts as a
// status marker.
export const STATUS_HEADER_LINE_RE = /^Status:[ \t]*\S.*$/;
// Headings that claim live currentness: a Next-task pointer, a frontier, or
// the current lane. History-shaped headings are exempt (see below).
const CURRENTNESS_HEADING_RE = /^(next\s*task|frontier|current\s+(lane|work|task|state)|ready\s+frontier|active\s+lane)\b/i;
// Headings that stay human-owned even when they name a terminal task:
// retrospective history, evidence, and coarse goal-sequencing intent.
const EXEMPT_HEADING_RE = /(history|retrospective|retrospect|evidence|limitation|log|runway|watchlist|archive|roll-?up|previously|past\s+work)/i;
const NEXT_TASK_COLUMN_RE = /^\s*next\s*task\s*$/i;
// Headings that mark a retrospective subtree at any depth: history, evidence,
// logs, and archives stay human-owned even for nested tables. The Generation
// Runway and the watchlist are live sequencing surfaces, so their Next-task
const RETROSPECTIVE_HEADING_RE = /(history|retrospective|retrospect|evidence|limitation|\blog\b|archive|roll-?up|previously|past\s+work)/i;

// True when the outline chain above `index` passes through a retrospective
// heading: pop to the parent on every same-or-higher heading so only real
// ancestors count, never earlier siblings.
function underRetrospective(headings: Array<{ heading: string; level: number; start: number }>, index: number): boolean {
  const stack: Array<{ heading: string; level: number }> = [];
  for (const h of headings) {
    if (h.start >= index) break;
    while (stack.length > 0 && stack[stack.length - 1].level >= h.level) stack.pop();
    stack.push({ heading: h.heading, level: h.level });
  }
  return stack.some((h) => RETROSPECTIVE_HEADING_RE.test(h.heading));
}

// Remove every generated projection block so only human-owned bytes remain.
// Unclosed begin sentinels are left in place: a broken block is a projection
// failure that verify/report already own. Shared by the currentness audit and
// by closeout's task-path mutation check, which compares planning identity
// over exactly these bytes — an earlier lifecycle write that regenerated a
// task file's generated block is lawful, an edit outside the sentinels is
// not.
export function stripGeneratedBlocks(text: string): string {
  const normalized = text.replace(/\r\n/g, "\n");
  let output = "";
  let rest = normalized;
  for (;;) {
    const range = findProjectionRange(rest);
    if (range === null) {
      output += rest;
      return output;
    }
    output += rest.slice(0, range.start);
    rest = rest.slice(range.end);
  }
}

function enclosingHeading(text: string, index: number): { heading: string; level: number; lineStart: number } | null {
  const before = text.slice(0, index);
  const lines = before.split("\n");
  for (let i = lines.length - 1; i >= 0; i -= 1) {
    const match = /^(#{1,6})\s+(.*?)\s*$/.exec(lines[i]);
    if (match) {
      const offset = lines.slice(0, i).join("\n").length + (i === 0 ? 0 : 1);
      return { heading: match[2].trim(), level: match[1].length, lineStart: offset };
    }
  }
  return null;
}

// A section runs to the next heading of the same or higher level. Nested
// subsections belong to their parent: a terminal task named under a `###
// Detail` inside `## Next Task` is still live-currentness prose.
function sectionEnd(text: string, from: number, level: number): number {
  const headingRe = /^(#{1,6})\s+/gm;
  headingRe.lastIndex = from;
  let match: RegExpExecArray | null;
  while ((match = headingRe.exec(text)) !== null) {
    if (match[1].length <= level) return match.index;
  }
  return text.length;
}

function terminalIds(text: string, terminal: Set<string>): string[] {
  const found = new Set<string>();
  for (const match of text.matchAll(TASK_ID_SCAN_RE)) {
    if (terminal.has(match[0])) found.add(match[0]);
  }
  return [...found].sort();
}

// Pure structural audit over caller-supplied file text. `files` maps
// repository-relative posix paths to full file content, `records` carries at
// least `task_id`, `status`, and `task_path`, and `targets` lists the declared
// projection targets. Detection is exact and bounded: a hand-maintained
// `Status:` header on a lifecycle-managed task path or declared target, a
// terminal task ID inside a live-currentness section (nested subsections
// belong to their parent) outside generated blocks, or a terminal task ID
// inside a Next-task table column. The Generation Runway is a live sequencing
// surface, so its Next-task column is audited; a table is history only under
// a retrospective outline ancestor. Goal history (`complete as gNN.NNN`),
// retrospective sections and tables, and prose about nonterminal tasks never
// flag.
export function auditCurrentnessText(
  files: Record<string, string>,
  records: Array<Record<string, unknown>>,
  targets: string[],
): CurrentnessViolation[] {
  const terminal = new Set<string>();
  const taskPathOf = new Map<string, string>();
  for (const record of records) {
    const id = String(record.task_id ?? "");
    if (!TASK_ID_RE.test(id)) continue;
    if (TERMINAL_STATUSES.has(String(record.status ?? ""))) terminal.add(id);
    if (typeof record.task_path === "string" && record.task_path.length > 0) taskPathOf.set(id, record.task_path);
  }
  const violations: CurrentnessViolation[] = [];
  const push = (file: string, section: string, task: string, reason: string): void => {
    if (!violations.some((v) => v.file === file && v.section === section && v.task === task && v.reason === reason)) {
      violations.push({ file, section, task, reason });
    }
  };

  // 1. Lifecycle-managed task paths carry no hand-maintained Status header.
  for (const [id, taskPath] of taskPathOf) {
    const content = files[taskPath];
    if (content === undefined) {
      push(taskPath, "-", id, "missing-task-file");
      continue;
    }
    const bare = stripGeneratedBlocks(content);
    const lines = bare.split("\n");
    for (let i = 0; i < lines.length; i += 1) {
      if (STATUS_HEADER_LINE_RE.test(lines[i])) {
        const offset = lines.slice(0, i).join("\n").length + (i === 0 ? 0 : 1);
        const enclosing = enclosingHeading(bare, offset);
        push(taskPath, enclosing === null ? "header" : enclosing.heading, id, "duplicate-status-header");
        break;
      }
    }
  }

  // 2. Declared projection targets carry no hand-maintained Status header and
  // no live-currentness section or Next-task column naming a terminal task.
  for (const target of targets) {
    const content = files[target];
    if (content === undefined) continue;
    const bare = stripGeneratedBlocks(content);
    const lines = bare.split("\n");
    for (let i = 0; i < lines.length; i += 1) {
      if (STATUS_HEADER_LINE_RE.test(lines[i])) {
        const offset = lines.slice(0, i).join("\n").length + (i === 0 ? 0 : 1);
        const enclosing = enclosingHeading(bare, offset);
        // A target-level Status header duplicates generation currentness owned
        // by the generated block; it names no single task, so task stays empty.
        push(target, enclosing === null ? "header" : enclosing.heading, "", "duplicate-status-header");
        break;
      }
    }
    // Live-currentness sections naming a terminal task.
    const headingRe = /^(#{1,6})\s+(.*?)\s*$/gm;
    let heading: RegExpExecArray | null;
    const headings: Array<{ heading: string; level: number; start: number; bodyStart: number }> = [];
    while ((heading = headingRe.exec(bare)) !== null) {
      headings.push({ heading: heading[2].trim(), level: heading[1].length, start: heading.index, bodyStart: heading.index + heading[0].length });
    }
    for (let h = 0; h < headings.length; h += 1) {
      const current = headings[h];
      if (!CURRENTNESS_HEADING_RE.test(current.heading) || EXEMPT_HEADING_RE.test(current.heading)) continue;
      const end = sectionEnd(bare, current.bodyStart, current.level);
      const body = bare.slice(current.bodyStart, end);
      for (const id of terminalIds(body, terminal)) {
        push(target, current.heading, id, "stale-frontier");
      }
    }
    // Next-task table columns naming a terminal task. Goal/state history
    // cells in other columns stay legal. A table is history only under a
    // retrospective ancestor: the Generation Runway is a live sequencing
    // surface, so its Next-task column is audited even though the heading
    // contains runway, while a table under `## History > ### Prior
    // sequencing` stays exempt at any depth.
    for (let i = 0; i < lines.length; i += 1) {
      const cells = lines[i].split("|").map((cell) => cell.trim());
      if (cells.length < 3 || cells[0] !== "" || cells[cells.length - 1] !== "") continue;
      const inner = cells.slice(1, -1);
      if (!inner.some((cell) => NEXT_TASK_COLUMN_RE.test(cell))) continue;
      const column = inner.findIndex((cell) => NEXT_TASK_COLUMN_RE.test(cell));
      if (i + 1 < lines.length && /^\|[\s:|-]+\|$/.test(lines[i + 1].trim())) i += 1;
      const tableOffset = lines.slice(0, i).join("\n").length + 1;
      if (underRetrospective(headings, tableOffset)) continue;
      const tableHeading = enclosingHeading(bare, tableOffset);
      const section = tableHeading === null ? "table" : "table: " + tableHeading.heading;
      for (let r = i + 1; r < lines.length; r += 1) {
        const rowCells = lines[r].split("|").map((cell) => cell.trim());
        if (rowCells.length < 3 || rowCells[0] !== "" || rowCells[rowCells.length - 1] !== "") break;
        const rowInner = rowCells.slice(1, -1);
        if (column >= rowInner.length) break;
        for (const id of terminalIds(rowInner[column], terminal)) {
          push(target, section, id, "stale-next-task-column");
        }
      }
    }
  }
  violations.sort((a, b) =>
    a.file < b.file ? -1 : a.file > b.file ? 1 :
    a.section < b.section ? -1 : a.section > b.section ? 1 :
    a.task < b.task ? -1 : a.task > b.task ? 1 :
    a.reason < b.reason ? -1 : a.reason > b.reason ? 1 : 0);
  return violations;
}

// Repository-backed audit: lifecycle records plus declared projection
// targets, read from disk. Missing record task files are reported; missing
// declared targets stay owned by render/verify.
export function auditCurrentness(repoRoot: string): { status: string; violations: CurrentnessViolation[] } {
  const records = listStateRecords(repoRoot);
  const config = readProjectionConfig(repoRoot);
  check(config !== null || records.length === 0, "projection-config",
    TARGETS_CONFIG_REL + " is missing; lifecycle records exist but no active generation is declared");
  const targets = config === null ? [] : config.targets;
  const wanted = new Set<string>();
  for (const record of records) {
    if (typeof record.task_path === "string") wanted.add(record.task_path);
  }
  for (const target of targets) wanted.add(target);
  const files: Record<string, string> = {};
  for (const relative of wanted) {
    const absolute = path.resolve(repoRoot, relative);
    if (!fs.existsSync(absolute) || !fs.statSync(absolute).isFile()) continue;
    assertRealContained(repoRoot, absolute);
    const bytes = fs.readFileSync(absolute, "utf8");
    check(bytes.length <= 1024 * 1024, "audit", "audit target exceeds the 1 MiB read bound: " + relative);
    files[relative] = bytes;
  }
  const violations = auditCurrentnessText(files, records, targets);
  return { status: violations.length === 0 ? "ok" : "violations", violations };
}

// ---------------------------------------------------------------------------
// Terminal-closeout marker convergence
// ---------------------------------------------------------------------------

// One `Status:` marker line located in a lifecycle-managed task file.
// `start`/`end` bound the exact line bytes including the trailing newline in
// the original text, `line` is the matched line text, and `section` names the
// enclosing heading (or `header` before any heading) for bounded refusal
// diagnostics.
export interface StatusMarkerLocation {
  start: number;
  end: number;
  line: string;
  section: string;
}

export interface StatusMarkerScan {
  owned: StatusMarkerLocation[];
  ambiguous: StatusMarkerLocation[];
}

// Locate every `Status:` marker line in one task file, outside generated
// projection blocks, with one bounded ownership test. A line matching the
// shared STATUS_HEADER_LINE_RE rule is adapter-owned — mechanically removable
// at terminal closeout — only when it sits in the file's leading header
// region before the first level-2..6 heading and outside fenced code. (The
// rule is line-start anchored, so indented code-block lines never match it
// and are prose by construction.) Anywhere else the identical line could be
// human prose, so the location is ambiguous and the caller refuses instead of
// removing. Bytes inside a generated block are the projection's own and are
// never scanned.
export function scanStatusMarkers(text: string): StatusMarkerScan {
  const owned: StatusMarkerLocation[] = [];
  const ambiguous: StatusMarkerLocation[] = [];
  const blocks: Array<{ start: number; end: number }> = [];
  let rest = text;
  let consumed = 0;
  for (;;) {
    const range = findProjectionRange(rest);
    if (range === null) break;
    blocks.push({ start: consumed + range.start, end: consumed + range.end });
    consumed += range.end;
    rest = rest.slice(range.end);
  }
  const inBlock = (offset: number): boolean =>
    blocks.some((block) => offset >= block.start && offset < block.end);
  let cursor = 0;
  let inFence = false;
  let fenceRun = "";
  let inLeadingRegion = true;
  let lastHeading: string | null = null;
  while (cursor < text.length) {
    const newline = text.indexOf("\n", cursor);
    const lineEnd = newline === -1 ? text.length : newline + 1;
    const rawLine = text.slice(cursor, newline === -1 ? text.length : newline);
    const line = rawLine.replace(/\r$/, "");
    if (!inBlock(cursor)) {
      const fence = /^ {0,3}(`{3,}|~{3,})/.exec(line);
      if (fence !== null) {
        const run = fence[1]!;
        if (!inFence) {
          inFence = true;
          fenceRun = run;
        } else if (run[0] === fenceRun[0] && run.length >= fenceRun.length) {
          inFence = false;
          fenceRun = "";
        }
      } else {
        const heading = /^(#{1,6})\s+(.*?)\s*$/.exec(line);
        if (heading !== null) {
          if (heading[1]!.length >= 2) inLeadingRegion = false;
          lastHeading = heading[2]!.trim();
        } else if (STATUS_HEADER_LINE_RE.test(line)) {
          const location: StatusMarkerLocation = {
            start: cursor,
            end: lineEnd,
            line,
            section: lastHeading === null ? "header" : lastHeading,
          };
          if (inLeadingRegion && !inFence) owned.push(location);
          else ambiguous.push(location);
        }
      }
    }
    cursor = lineEnd;
  }
  return { owned, ambiguous };
}

export interface StatusMarkerConvergence {
  text: string;
  removed: number;
  ambiguous: StatusMarkerLocation[];
}

// Remove every adapter-owned `Status:` marker line from one task file and
// leave every other byte identical. An ambiguous status-looking line never
// modifies the text: the returned convergence reports it and the caller
// refuses the closeout instead of removing possible human prose.
export function convergeStatusMarkers(text: string): StatusMarkerConvergence {
  const scan = scanStatusMarkers(text);
  if (scan.ambiguous.length > 0) return { text, removed: 0, ambiguous: scan.ambiguous };
  let next = text;
  for (let i = scan.owned.length - 1; i >= 0; i -= 1) {
    const marker = scan.owned[i]!;
    next = next.slice(0, marker.start) + next.slice(marker.end);
  }
  return { text: next, removed: scan.owned.length, ambiguous: [] };
}

// The exact terminal task summary set a closure record pins. Closure authoring
// and compaction compute this digest the same way, so stale or mismatched
// authority cannot pass.
export function terminalTaskSummaries(records: Record<string, unknown>[], generation: string): Record<string, unknown>[] {
  const scoped = records.filter((record) => record.generation === generation);
  check(scoped.length > 0, "compaction", "no records for generation " + generation);
  for (const record of scoped) {
    check(TERMINAL_STATUSES.has(String(record.status)), "compaction",
      "generation " + generation + " is not closed: " + String(record.task_id) + " is " + String(record.status));
  }
  return scoped
    .map((record) => ({
      task_id: String(record.task_id),
      revision: Number(record.revision),
      digest: String(record.digest),
      status: String(record.status),
      merge_commit: ((record.evidence as Record<string, unknown> | undefined)?.merge as Record<string, unknown> | undefined)?.merge_commit ?? null,
    }))
    .sort((a, b) => (a.task_id < b.task_id ? -1 : a.task_id > b.task_id ? 1 : 0));
}

export function generationTasksDigest(records: Record<string, unknown>[], generation: string): string {
  return digestOf(terminalTaskSummaries(records, generation));
}

// Compaction is destructive lifecycle maintenance, so terminal records are
// necessary but never sufficient: the caller must supply the generation's
// committed closure record, and it must be closed, name this generation, and
// pin the exact terminal set being reduced. Missing, open, stale, mismatched,
// or ambiguous authority refuses before any receipt exists.
export function compactGeneration(records: Record<string, unknown>[], generation: string, closure: Record<string, unknown>): Record<string, unknown> {
  verifyGenerationClosure(closure, generation);
  check(closure.disposition === "closed", "compaction",
    "generation " + generation + " closure record is not closed; an open generation is not compactable");
  const tasks = terminalTaskSummaries(records, generation);
  const tasksDigest = digestOf(tasks);
  check(closure.tasks_digest === tasksDigest, "compaction",
    "closure authority is stale or mismatched: tasks digest " + String(closure.tasks_digest) + " does not cover the current terminal records (" + tasksDigest + ")");
  return {
    schema_version: GENERATION_RECEIPT_SCHEMA,
    generation,
    source_digest: tasksDigest,
    closure_digest: digestOf(closure),
    tasks,
  };
}

// ---------------------------------------------------------------------------
// Closed-generation receipt publication and fragment consumption
// ---------------------------------------------------------------------------

// One planned compaction: the canonical receipt bytes to publish and the exact
// fragments that receipt covers. The plan is read-only; it refuses missing,
// open, stale, conflicting, or malformed authority before a single byte is
// written or deleted.
export interface GenerationCompactionPlan {
  generation: string;
  receiptPath: string;
  receiptRelative: string;
  receipt: Record<string, unknown>;
  receiptBytes: string;
  receiptChanged: boolean;
  deletions: Array<{ absolute: string; relative: string }>;
}

export interface ClosedGenerationOutcome {
  status: "applied" | "unchanged";
  generation: string;
  receipt_created: boolean;
  deleted: string[];
  changed_paths: string[];
}

export interface ClosedGenerationCatchUpResult {
  status: "applied" | "unchanged";
  generations: string[];
  receipt_created: string[];
  deleted: string[];
  changed_paths: string[];
}

export function generationReceiptPath(repoRoot: string, generation: string): string {
  check(typeof generation === "string" && GENERATION_RE.test(generation), "identity", "invalid generation: " + String(generation));
  return path.join(lifecycleRoot(repoRoot), "generations", generation + ".json");
}

function fragmentGenerationOf(name: string): string | null {
  const match = /^(g[0-9]{2})\.[0-9]{3}\.json$/.exec(name);
  return match === null ? null : match[1]!;
}

function fragmentSummary(record: Record<string, unknown>): Record<string, unknown> {
  return {
    task_id: String(record.task_id),
    revision: Number(record.revision),
    digest: String(record.digest),
    status: String(record.status),
    merge_commit: ((record.evidence as Record<string, unknown> | undefined)?.merge as Record<string, unknown> | undefined)?.merge_commit ?? null,
  };
}

function readReceiptFile(file: string, relative: string): { receipt: Record<string, unknown>; bytes: string } | null {
  if (!fs.existsSync(file)) return null;
  const stats = fs.lstatSync(file);
  check(!stats.isSymbolicLink(), "receipt", "generation receipt " + relative + " is a symlink; refusing an ambiguous read");
  check(stats.isFile(), "receipt", "generation receipt " + relative + " is not a regular file");
  const bytes = fs.readFileSync(file, "utf8");
  let parsed: unknown;
  try {
    parsed = JSON.parse(bytes);
  } catch {
    return fail("receipt", "generation receipt is not valid JSON: " + relative);
  }
  try {
    validateGenerationReceipt(parsed);
  } catch (err) {
    if (err instanceof LifecycleError) return fail("receipt", "generation receipt " + relative + " is malformed: " + err.message);
    throw err;
  }
  return { receipt: parsed as Record<string, unknown>, bytes };
}

// A receipt is valid only beside the exact closure record it named. Any drift
// in closure authority invalidates it; a conflicting receipt refuses before
// deletion rather than trusting a stale tombstone.
function verifyReceiptProvenance(receipt: Record<string, unknown>, generation: string, closure: Record<string, unknown>): void {
  check(receipt.generation === generation, "receipt",
    "generation receipt names " + String(receipt.generation) + ", expected " + generation);
  check(receipt.source_digest === closure.tasks_digest, "compaction",
    "closure authority is stale or mismatched: receipt source digest " + String(receipt.source_digest) +
    " does not cover the current closure tasks digest " + String(closure.tasks_digest));
  check(receipt.closure_digest === digestOf(closure), "compaction",
    "closure authority is stale or mismatched: receipt closure digest " + String(receipt.closure_digest) +
    " does not match the committed closure record");
}

// Plan one closed generation without mutating anything. Full fragment set and
// no receipt writes the canonical receipt then deletes exactly those
// fragments; a valid receipt plus remaining exact fragments deletes only the
// remainder (the crash-safe catch-up path); a valid receipt with no fragments
// is already complete.
export function planGenerationCompaction(options: {
  repoRoot: string;
  generation: string;
  recordsDir: string;
  receiptPath: string;
}): GenerationCompactionPlan {
  const repoRoot = options.repoRoot;
  const generation = options.generation;
  check(typeof generation === "string" && GENERATION_RE.test(generation), "identity", "invalid generation: " + String(generation));

  const recordsAbs = options.recordsDir;
  const recordsRelative = path.relative(repoRoot, recordsAbs).split(path.sep).join("/");
  assertContained(repoRoot, recordsRelative);
  assertRealContained(repoRoot, recordsAbs);
  if (fs.existsSync(recordsAbs)) {
    check(fs.statSync(recordsAbs).isDirectory(), "containment", "records path is not a directory: " + recordsRelative);
  }

  const receiptAbs = options.receiptPath;
  const receiptRelative = path.relative(repoRoot, receiptAbs).split(path.sep).join("/");
  assertContained(repoRoot, receiptRelative);
  assertRealContained(repoRoot, fs.existsSync(receiptAbs) ? receiptAbs : path.dirname(receiptAbs));

  const closure = readGenerationClosure(repoRoot, generation);
  check(closure !== null, "compaction",
    "generation " + generation + " has no closure record at " + generationClosurePath(repoRoot, generation).replace(repoRoot + path.sep, "") +
    "; terminal records alone are not closure authority");
  check(closure!.disposition === "closed", "compaction",
    "generation " + generation + " closure record is not closed; an open generation is not compactable");

  const fragmentNames = fs.existsSync(recordsAbs)
    ? fs.readdirSync(recordsAbs)
      .filter((name) => name.endsWith(".json") && !name.startsWith(".") && fragmentGenerationOf(name) === generation)
      .sort()
    : [];
  const fragments = fragmentNames.map((name) => {
    const absolute = path.join(recordsAbs, name);
    const stats = fs.lstatSync(absolute);
    check(!stats.isSymbolicLink(), "compaction", "fragment " + name + " is a symlink; refusing an ambiguous deletion");
    check(stats.isFile(), "compaction", "fragment " + name + " is not a regular file; refusing an ambiguous deletion");
    let parsed: unknown;
    try {
      parsed = JSON.parse(fs.readFileSync(absolute, "utf8"));
    } catch {
      return fail("record-parse", "record is not valid JSON: " + absolute);
    }
    check(parsed !== null && typeof parsed === "object" && !Array.isArray(parsed), "record-parse", "record is not an object: " + absolute);
    const record = parsed as Record<string, unknown>;
    verifyRecordIntegrity(record);
    check(String(record.generation) === generation, "compaction", "fragment " + name + " does not belong to generation " + generation);
    return { absolute, relative: path.relative(repoRoot, absolute).split(path.sep).join("/"), record };
  });
  const deletions = fragments.map((fragment) => ({ absolute: fragment.absolute, relative: fragment.relative }));

  const existing = readReceiptFile(receiptAbs, receiptRelative);
  if (existing !== null) {
    verifyReceiptProvenance(existing.receipt, generation, closure!);
    const entries = new Map((existing.receipt.tasks as Record<string, unknown>[]).map((entry) => [String(entry.task_id), entry]));
    for (const fragment of fragments) {
      const summary = fragmentSummary(fragment.record);
      const entry = entries.get(String(summary.task_id));
      check(entry !== undefined, "receipt",
        "fragment " + fragment.relative + " is not covered by the existing receipt for " + generation);
      check(deepEqual(summary, entry), "receipt",
        "fragment " + fragment.relative + " does not match its receipt entry; refusing an ambiguous deletion");
    }
    // An existing receipt is already byte-authoritative: replay must never
    // rewrite it, so only the remaining covered fragments are consumed.
    return {
      generation,
      receiptPath: receiptAbs,
      receiptRelative,
      receipt: existing.receipt,
      receiptBytes: existing.bytes,
      receiptChanged: false,
      deletions,
    };
  }

  check(fragments.length > 0, "compaction",
    "generation " + generation + " has no task fragments and no receipt; refusing to invent a compacted record");
  const receipt = compactGeneration(fragments.map((fragment) => fragment.record), generation, closure!);
  validateGenerationReceipt(receipt);
  return {
    generation,
    receiptPath: receiptAbs,
    receiptRelative,
    receipt,
    receiptBytes: canonicalJson(receipt) + "\n",
    receiptChanged: true,
    deletions,
  };
}

function applyCompactionPlans(plans: GenerationCompactionPlan[]): ClosedGenerationOutcome[] {
  return plans.map((plan) => {
    const changedPaths: string[] = [];
    if (plan.receiptChanged) {
      // The receipt is durable before any covered fragment disappears; an
      // interruption between the two leaves a valid receipt plus remaining
      // exact fragments, which the next replay finishes safely.
      writeFileAtomic(plan.receiptPath, plan.receiptBytes);
      changedPaths.push(plan.receiptRelative);
    }
    for (const deletion of plan.deletions) {
      const stats = fs.lstatSync(deletion.absolute);
      check(!stats.isSymbolicLink() && stats.isFile(), "compaction",
        "fragment " + deletion.relative + " changed shape before deletion; refusing an ambiguous write");
      fs.unlinkSync(deletion.absolute);
      changedPaths.push(deletion.relative);
    }
    return {
      status: changedPaths.length > 0 ? "applied" : "unchanged",
      generation: plan.generation,
      receipt_created: plan.receiptChanged,
      deleted: plan.deletions.map((deletion) => deletion.relative),
      changed_paths: [...new Set(changedPaths)].sort(),
    };
  });
}

// Every committed closure record with disposition closed, in lexical order.
// Absence of a closure record is the open disposition, never an error here.
export function discoverClosedGenerations(repoRoot: string): string[] {
  const dir = path.join(lifecycleRoot(repoRoot), "generations");
  if (!fs.existsSync(dir)) return [];
  const candidates = fs.readdirSync(dir)
    .filter((name) => /^g[0-9]{2}\.closure\.json$/.test(name))
    .map((name) => name.slice(0, 3))
    .sort();
  return candidates.filter((generation) => {
    const closure = readGenerationClosure(repoRoot, generation);
    return closure !== null && closure.disposition === "closed";
  });
}

// Consume one explicit closed generation through the canonical lifecycle
// paths. Refuses when the generation has no closed closure record.
export function consumeClosedGeneration(options: {
  repoRoot: string;
  generation: string;
  recordsDir?: string;
  receiptPath?: string;
  branch?: string;
}): ClosedGenerationOutcome {
  const repoRoot = options.repoRoot;
  const recordsDir = options.recordsDir ?? path.join(lifecycleRoot(repoRoot), "tasks");
  const receiptPath = options.receiptPath ?? generationReceiptPath(repoRoot, options.generation);
  if (options.branch !== undefined) assertBranch(repoRoot, options.branch);
  const plan = planGenerationCompaction({ repoRoot, generation: options.generation, recordsDir, receiptPath });
  let outcome: ClosedGenerationOutcome | null = null;
  withLifecycleLock(repoRoot, () => {
    outcome = applyCompactionPlans([plan])[0]!;
  });
  return outcome as unknown as ClosedGenerationOutcome;
}

// Plan every eligible historical generation in lexical order, read-only. One
// inconsistent generation refuses the whole invocation before any byte
// changes; the returned plans are the exact receipts and deletions the locked
// write pass will apply.
export function planClosedGenerationCatchUp(options: {
  repoRoot: string;
  generations?: string[];
  recordsDir?: string;
  receiptsDir?: string;
  branch?: string;
}): GenerationCompactionPlan[] {
  const repoRoot = options.repoRoot;
  const recordsDir = options.recordsDir ?? path.join(lifecycleRoot(repoRoot), "tasks");
  const receiptsDir = options.receiptsDir ?? path.join(lifecycleRoot(repoRoot), "generations");
  const generations = [...new Set(options.generations ?? discoverClosedGenerations(repoRoot))].sort();
  if (options.branch !== undefined) assertBranch(repoRoot, options.branch);
  return generations.map((generation) => planGenerationCompaction({
    repoRoot,
    generation,
    recordsDir,
    receiptPath: path.join(receiptsDir, generation + ".json"),
  }));
}

// Apply a read-only catch-up plan under one lifecycle lock in deterministic
// lexical order and report every receipt creation and exact deletion.
export function applyClosedGenerationCatchUp(repoRoot: string, plans: GenerationCompactionPlan[]): ClosedGenerationCatchUpResult {
  let outcomes: ClosedGenerationOutcome[] = [];
  withLifecycleLock(repoRoot, () => {
    outcomes = applyCompactionPlans(plans);
  });
  const changedPaths = outcomes.flatMap((outcome) => outcome.changed_paths);
  return {
    status: changedPaths.length > 0 ? "applied" : "unchanged",
    generations: outcomes.map((outcome) => outcome.generation),
    receipt_created: outcomes.filter((outcome) => outcome.receipt_created).map((outcome) => outcome.generation),
    deleted: outcomes.flatMap((outcome) => outcome.deleted),
    changed_paths: [...new Set(changedPaths)].sort(),
  };
}

// Catch up every eligible historical generation in lexical order. All
// generations are planned read-only before the locked write pass, so one
// inconsistent generation refuses the whole invocation before any byte
// changes, and the returned changed paths are deterministic and exact.
export function consumeClosedGenerations(options: {
  repoRoot: string;
  generations?: string[];
  recordsDir?: string;
  receiptsDir?: string;
  branch?: string;
}): ClosedGenerationCatchUpResult {
  return applyClosedGenerationCatchUp(options.repoRoot, planClosedGenerationCatchUp(options));
}

// Receipt-derived terminal records let dependency resolution, currentness
// audit, and any other closed-generation state reader see a compacted
// generation without resurrecting a per-task fragment. Active generations keep
// using their individual records.
export function listGenerationReceipts(repoRoot: string): Array<{ generation: string; receipt: Record<string, unknown> }> {
  const dir = path.join(lifecycleRoot(repoRoot), "generations");
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir)
    .filter((name) => /^g[0-9]{2}\.json$/.test(name))
    .sort()
    .map((name) => {
      const generation = name.slice(0, 3);
      const relative = path.relative(repoRoot, path.join(dir, name)).split(path.sep).join("/");
      const loaded = readReceiptFile(path.join(dir, name), relative);
      return { generation, receipt: loaded!.receipt };
    });
}

// A receipt entry has no task path or stage; the synthetic record carries only
// the fields a closed-generation reader may lawfully use.
export function receiptStateRecords(repoRoot: string): Record<string, unknown>[] {
  const out: Record<string, unknown>[] = [];
  for (const { generation, receipt } of listGenerationReceipts(repoRoot)) {
    for (const entry of receipt.tasks as Record<string, unknown>[]) {
      out.push({
        task_id: String(entry.task_id),
        generation,
        status: String(entry.status),
        stage: "none",
        revision: Number(entry.revision),
        digest: String(entry.digest),
      });
    }
  }
  return out;
}

export function listStateRecords(repoRoot: string): Record<string, unknown>[] {
  const records = listRecords(repoRoot);
  const seen = new Set(records.map((record) => String(record.task_id)));
  const merged = [...records];
  for (const synthetic of receiptStateRecords(repoRoot)) {
    if (!seen.has(String(synthetic.task_id))) {
      seen.add(String(synthetic.task_id));
      merged.push(synthetic);
    }
  }
  return merged;
}

// ---------------------------------------------------------------------------
// Static portability scan
// ---------------------------------------------------------------------------

export function forbiddenImportSpecifiers(source: string): string[] {
  const specifiers: string[] = [];
  const patterns = [
    /^\s*import\s[^;]*?from\s+"([^"]+)"/gm,
    /^\s*import\s+"([^"]+)"/gm,
    /require\(\s*"([^"]+)"\s*\)/g,
  ];
  for (const pattern of patterns) {
    let match: RegExpExecArray | null;
    while ((match = pattern.exec(source)) !== null) specifiers.push(match[1]);
  }
  return specifiers.filter((specifier) => /paseo|queue|node:http|node:https|node:net|node:dns|undici/i.test(specifier));
}

// ---------------------------------------------------------------------------
// Oracle
// ---------------------------------------------------------------------------

const PLANNING_COMMIT = "0".repeat(40);

function oracleEnvelope(overrides: Record<string, unknown>): Record<string, unknown> {
  const taskId = String(overrides.task_id ?? "g03.005");
  const match = /^g([0-9]{2})\.([0-9]{3})$/.exec(taskId)!;
  const base: Record<string, unknown> = {
    schema_version: ENVELOPE_SCHEMA,
    event_id: "event-" + String(overrides.event_id ?? Math.random().toString(36).slice(2, 12)),
    task_id: taskId,
    task_path: "docs/roadmaps/g" + match[1] + "/" + match[2] + "-portable-lifecycle-core.md",
    generation: "g" + match[1],
    expected: { revision: 0, digest: null },
    transition: "plan",
    event_time: "2026-09-12T12:00:00.000Z",
    actor: "oracle",
    source: { adapter: "standalone" },
    planning: { commit: PLANNING_COMMIT, task_blob_digest: digestOf("task-blob") },
  };
  return { ...base, ...overrides };
}

async function runOracle(): Promise<number> {
  let count = 0;
  const ok = (name: string) => {
    count += 1;
    console.log("ok " + count + " - " + name);
  };
  const expectFail = (name: string, fn: () => unknown, match?: string) => {
    let message = "";
    let failed = false;
    try {
      fn();
    } catch (err) {
      failed = true;
      message = (err as Error).message;
    }
    if (!failed) throw new Error(name + ": expected failure but the call succeeded");
    if (match && !message.includes(match)) throw new Error(name + ": failure '" + message + "' does not include '" + match + "'");
    ok(name);
  };

  // 1. Exhaustive transition matrix against an independent table.
  const expectedLegal = (status: string, stage: string, transition: string, target: string): boolean => {
    if (transition === "plan") return false; // with an existing record plan is illegal
    if (transition === "ready") return status === "planned" && stage === "none";
    if (transition === "start") return status === "ready" && stage === "none";
    if (transition === "block") return ["planned", "ready", "active"].includes(status);
    if (transition === "resume") return status === "blocked";
    if (transition === "complete") return status === "active" && stage === "closeout";
    if (transition === "cancel" || transition === "supersede") return ["planned", "ready", "active", "blocked"].includes(status);
    if (transition === "advance_stage") {
      if (status !== "active") return false;
      const edges: Record<string, string[]> = { none: [], dispatch: ["implementation"], implementation: ["review"], review: ["merge", "implementation"], merge: ["closeout"], closeout: [] };
      return (edges[stage] ?? []).includes(target);
    }
    return false;
  };
  let matrixMismatches = 0;
  for (const status of STATUSES) {
    for (const stage of STAGES) {
      for (const transition of TRANSITIONS) {
        for (const target of STAGES) {
          const current: Record<string, unknown> = {
            status, stage,
            block: { resume_status: "active", resume_stage: "implementation" },
          };
          let actual = true;
          try {
            transitionEdge(current, transition, target);
          } catch {
            actual = false;
          }
          if (actual !== expectedLegal(status, stage, transition, target)) matrixMismatches += 1;
        }
      }
    }
  }
  check(matrixMismatches === 0, "oracle", "transition matrix has " + matrixMismatches + " mismatches");
  ok("exhaustive status/stage transition matrix");

  // 2. Canonical JSON and digest stability.
  check(digestOf({ b: 1, a: [2, 3] }) === digestOf({ a: [2, 3], b: 1 }), "oracle", "canonical digest is key-order dependent");
  ok("canonical JSON digest is key-order independent");

  // 3. Plan -> complete reducer path with evidence binding.
  const plan = oracleEnvelope({ event_id: "oracle-plan-0001" });
  const planResult = reduce(plan, null, {});
  check(planResult.record.status === "planned" && planResult.record.stage === "none", "oracle", "plan did not produce planned/none");
  ok("plan produces planned/none");

  const replay = reduce(plan, planResult.record, {});
  check(replay.replay === true && replay.record.digest === planResult.record.digest, "oracle", "identical retry did not replay");
  ok("identical event retry returns the recorded revision and digest");

  const conflict = oracleEnvelope({ event_id: "oracle-plan-0001", actor: "different-actor" });
  expectFail("event-id reuse with different content fails", () => reduce(conflict, planResult.record, {}), "already applied");

  const stale = oracleEnvelope({ event_id: "oracle-plan-0002", transition: "ready", expected: { revision: 0, digest: null } });
  expectFail("stale revision write fails", () => reduce(stale, planResult.record, {}), "stale revision");

  // 4. Schema conformance of emitted records; mutated instance fails.
  validateRecord(planResult.record);
  ok("emitted record validates against the Draft 2020-12 record schema");
  const mutated = JSON.parse(JSON.stringify(planResult.record));
  mutated.status = "invented";
  expectFail("schema rejects an invented status", () => validateRecord(mutated));

  // 5. Evidence-level fidelity.
  let active = reduce(plan, null, {}).record;
  active = reduce(oracleEnvelope({ event_id: "oracle-ready-0001", transition: "ready", expected: { revision: 1, digest: active.digest } }), active, {}).record;
  active = reduce(oracleEnvelope({ event_id: "oracle-start-0001", transition: "start", expected: { revision: 2, digest: active.digest } }), active, {}).record;
  active = reduce(oracleEnvelope({ event_id: "oracle-impl-0001", transition: "advance_stage", target_stage: "implementation", expected: { revision: 3, digest: active.digest } }), active, {}).record;
  const attestedEnvelope = oracleEnvelope({
    event_id: "oracle-evidence-0001",
    transition: "advance_stage",
    target_stage: "review",
    expected: { revision: 4, digest: active.digest },
    evidence: { pr: { level: "adapter_attested", source: "github", actor: "bot", method: "pr_state", recorded_at: "2026-09-12T12:00:01.000Z", head_commit: "a".repeat(40), pr_number: 7 } },
  });
  const inReview = reduce(attestedEnvelope, active, {}).record;
  check((inReview.evidence as Record<string, unknown>).pr !== undefined, "oracle", "adapter attestation was dropped");
  ok("adapter_attested evidence is preserved at its declared level");

  expectFail("locally_verified provider evidence fails closed", () => {
    const forged = oracleEnvelope({
      event_id: "oracle-forged-0001",
      transition: "advance_stage",
      target_stage: "review",
      expected: { revision: 4, digest: active.digest },
      evidence: { review: { level: "locally_verified", source: "github", actor: "bot", method: "review_state", recorded_at: "2026-09-12T12:00:02.000Z", verdict: "approved", head_commit: "a".repeat(40) } },
    });
    reduce(forged, active, { verifyCommit: () => true });
  }, "cannot locally verify");

  // 6. Evidence binds to delivery (pure reducer negatives).
  const mergeHead = "b".repeat(40);
  const mergeCommit = "c".repeat(40);
  const reviewAtOtherHead = {
    level: "adapter_attested", source: "github", actor: "reviewer", method: "review", recorded_at: "2026-09-12T12:00:03.000Z",
    verdict: "approved", head_commit: "d".repeat(40), pr_number: 7,
  };
  const goodReview = { ...reviewAtOtherHead, head_commit: mergeHead };
  const prEntry = { level: "adapter_attested", source: "github", actor: "bot", method: "pr_state", recorded_at: "2026-09-12T12:00:01.000Z", head_commit: mergeHead, pr_number: 7 };
  const mergeEntry = { level: "adapter_attested", source: "github", actor: "bot", method: "merge", recorded_at: "2026-09-12T12:00:04.000Z", merge_commit: mergeCommit, head_commit: mergeHead, base: "main", merge_method: "merge" };

  const reviewRecord = reduce(oracleEnvelope({
    event_id: "oracle-review-0001", transition: "advance_stage", target_stage: "review",
    expected: { revision: 4, digest: active.digest }, evidence: { pr: prEntry },
  }), active, {}).record;

  expectFail("merge requires an accepted review at the exact head", () => {
    reduce(oracleEnvelope({
      event_id: "oracle-merge-bad-0001", transition: "advance_stage", target_stage: "merge",
      expected: { revision: 5, digest: reviewRecord.digest }, evidence: { merge: mergeEntry, review: reviewAtOtherHead },
    }), reviewRecord, {});
  }, "accepted review at head");

  const mergeRecord = reduce(oracleEnvelope({
    event_id: "oracle-merge-0001", transition: "advance_stage", target_stage: "merge",
    expected: { revision: 5, digest: reviewRecord.digest }, evidence: { merge: mergeEntry, review: goodReview },
  }), reviewRecord, {}).record;

  // Review revision returns active work to implementation and invalidates the
  // review that no longer covers the head.
  const reviewWithVerdict = reduce(oracleEnvelope({
    event_id: "oracle-revise-base", transition: "advance_stage", target_stage: "review",
    expected: { revision: 4, digest: active.digest }, evidence: { pr: prEntry, review: goodReview },
  }), active, {}).record;
  const revised = reduce(oracleEnvelope({
    event_id: "oracle-revise-0001", transition: "advance_stage", target_stage: "implementation",
    reason: "author revised after review", expected: { revision: 5, digest: reviewWithVerdict.digest },
  }), reviewWithVerdict, {}).record;
  check(revised.stage === "implementation" && (revised.evidence as Record<string, unknown>).review === undefined, "oracle", "review revision did not invalidate the stale review");
  ok("review revision returns to implementation and invalidates the stale review");

  const closeoutRecord = reduce(oracleEnvelope({
    event_id: "oracle-closeout-0001", transition: "advance_stage", target_stage: "closeout",
    expected: { revision: 6, digest: mergeRecord.digest }, evidence: { merge: mergeEntry },
  }), mergeRecord, {}).record;

  const completionEvidence: Record<string, unknown> = {
    merge: mergeEntry,
    integration: { level: "locally_verified", source: "git", actor: "oracle", method: "synchronized_main", recorded_at: "2026-09-12T12:00:05.000Z", synchronized_main_commit: mergeCommit },
    validation: { level: "adapter_attested", source: "effigy", actor: "oracle", method: "qa", recorded_at: "2026-09-12T12:00:06.000Z", passed: true, head_commit: mergeHead, command: "effigy qa" },
    handoff: { level: "adapter_attested", source: "docs", actor: "oracle", method: "handoff", recorded_at: "2026-09-12T12:00:07.000Z", ref: "docs/handoffs/example.md" },
    pr: prEntry,
    review: goodReview,
  };
  const completeEnvelope = (overrides: Record<string, unknown>) => {
    const { evidence: evidenceOverride, ...other } = overrides;
    return oracleEnvelope({
      event_id: "oracle-complete-0001",
      transition: "complete",
      expected: { revision: 7, digest: closeoutRecord.digest },
      ...other,
      evidence: { ...completionEvidence, ...((evidenceOverride as Record<string, unknown>) ?? {}) },
    });
  };

  // A chain-aware ancestry verifier: the reviewed head is contained by the
  // merge commit, which is contained by itself and an advanced main.
  const descendantCommit = "1".repeat(40);
  const chainAncestor = (ancestor: string, descendant: string): boolean =>
    (ancestor === mergeHead && (descendant === mergeCommit || descendant === descendantCommit)) ||
    (ancestor === mergeCommit && (descendant === mergeCommit || descendant === descendantCommit));

  const completed = reduce(completeEnvelope({}), closeoutRecord, { verifyCommit: () => true, isAncestor: chainAncestor });
  check(completed.record.status === "complete" && completed.record.stage === "none", "oracle", "complete did not reach terminal state");
  verifyRecordIntegrity(completed.record);
  ok("complete requires and records merge, synchronized main, validation, and closeout evidence");

  // Synchronized main lawfully advances past the merge commit (interleaved
  // publications, closeout Markdown); ancestry is the durable local proof.
  const advancedMain = reduce(completeEnvelope({
    event_id: "oracle-complete-advanced-main",
    evidence: { integration: { level: "locally_verified", source: "git", actor: "oracle", method: "synchronized_main", recorded_at: "2026-09-12T12:00:05.000Z", synchronized_main_commit: descendantCommit } },
  }), closeoutRecord, { verifyCommit: () => true, isAncestor: chainAncestor });
  check(advancedMain.record.status === "complete", "oracle", "completion rejected a synchronized main containing the merge commit");
  ok("completion accepts a synchronized main that contains the merge commit");

  expectFail("completion rejects validation from an unrelated head", () => {
    reduce(completeEnvelope({
      event_id: "oracle-complete-bad-head",
      evidence: {
        validation: { level: "adapter_attested", source: "effigy", actor: "oracle", method: "qa", recorded_at: "2026-09-12T12:00:06.000Z", passed: true, head_commit: "e".repeat(40), command: "effigy qa" },
      },
    }), closeoutRecord, { verifyCommit: () => true, isAncestor: () => true });
  }, "unrelated head");

  expectFail("completion rejects merge ancestry that excludes the reviewed head", () => {
    reduce(completeEnvelope({
      event_id: "oracle-complete-bad-ancestry",
      evidence: { merge: { ...mergeEntry, level: "locally_verified" } },
    }), closeoutRecord, { verifyCommit: () => true, isAncestor: () => false });
  }, "does not contain reviewed head");

  expectFail("completion rejects an unsynchronized main", () => {
    reduce(completeEnvelope({
      event_id: "oracle-complete-bad-main",
      evidence: { integration: { level: "locally_verified", source: "git", actor: "oracle", method: "synchronized_main", recorded_at: "2026-09-12T12:00:05.000Z", synchronized_main_commit: "f".repeat(40) } },
    }), closeoutRecord, { verifyCommit: () => true, isAncestor: chainAncestor });
  }, "does not contain the merge commit");

  expectFail("advancing to merge without any review fails closed", () => {
    reduce(oracleEnvelope({
      event_id: "oracle-merge-noreview-0001", transition: "advance_stage", target_stage: "merge",
      expected: { revision: 5, digest: reviewRecord.digest }, evidence: { merge: mergeEntry },
    }), reviewRecord, {});
  }, "accepted review");

  // Review skip requires exact operator authorization.
  const reviewSkipPlan = oracleEnvelope({
    event_id: "oracle-skip-plan-0001",
    policy: { mode: "review_skip", authorization_ref: "operator:2026-09-12:approve-skip" },
    evidence: { authorization: { level: "operator_authorized", source: "operator", actor: "operator", method: "authorization", recorded_at: "2026-09-12T12:00:00.000Z", ref: "operator:2026-09-12:approve-skip" } },
  });
  const skipRecord = reduce(reviewSkipPlan, null, {}).record;
  expectFail("review_skip without authorization fails closed", () => {
    reduce(oracleEnvelope({ event_id: "oracle-skip-bad-0001", policy: { mode: "review_skip", authorization_ref: "operator:missing" } }), null, {});
  }, "authorization evidence");
  ok("review_skip policy requires an exact operator authorization ref");
  let skip = skipRecord;
  skip = reduce(oracleEnvelope({ event_id: "oracle-skip-ready", transition: "ready", expected: { revision: 1, digest: skip.digest } }), skip, {}).record;
  skip = reduce(oracleEnvelope({ event_id: "oracle-skip-start", transition: "start", expected: { revision: 2, digest: skip.digest } }), skip, {}).record;
  skip = reduce(oracleEnvelope({ event_id: "oracle-skip-impl", transition: "advance_stage", target_stage: "implementation", expected: { revision: 3, digest: skip.digest } }), skip, {}).record;
  skip = reduce(oracleEnvelope({ event_id: "oracle-skip-review", transition: "advance_stage", target_stage: "review", expected: { revision: 4, digest: skip.digest }, evidence: { pr: prEntry } }), skip, {}).record;
  skip = reduce(oracleEnvelope({ event_id: "oracle-skip-merge", transition: "advance_stage", target_stage: "merge", expected: { revision: 5, digest: skip.digest }, evidence: { merge: mergeEntry } }), skip, {}).record;
  skip = reduce(oracleEnvelope({ event_id: "oracle-skip-closeout", transition: "advance_stage", target_stage: "closeout", expected: { revision: 6, digest: skip.digest }, evidence: { merge: mergeEntry } }), skip, {}).record;
  const skipComplete = reduce(oracleEnvelope({
    event_id: "oracle-skip-complete", transition: "complete", expected: { revision: 7, digest: skip.digest },
    evidence: {
      merge: mergeEntry,
      integration: { level: "locally_verified", source: "git", actor: "oracle", method: "synchronized_main", recorded_at: "2026-09-12T12:00:05.000Z", synchronized_main_commit: mergeCommit },
      validation: { level: "adapter_attested", source: "effigy", actor: "oracle", method: "qa", recorded_at: "2026-09-12T12:00:06.000Z", passed: true, head_commit: mergeHead, command: "effigy qa" },
      handoff: { level: "adapter_attested", source: "docs", actor: "oracle", method: "handoff", recorded_at: "2026-09-12T12:00:07.000Z", ref: "docs/handoffs/example.md" },
    },
  }), skip, { verifyCommit: () => true, isAncestor: () => true });
  check(skipComplete.record.status === "complete", "oracle", "authorized review_skip did not complete");
  ok("authorized review_skip completes without a review");

  // 7. Block, resume, cancel, supersede, and planning_required.
  let blocked = reduce(oracleEnvelope({ event_id: "oracle-block-0001", transition: "block", reason: "waiting on upstream", reason_code: "upstream", expected: { revision: 4, digest: active.digest } }), active, {}).record;
  check(blocked.status === "blocked" && (blocked.block as Record<string, unknown>).prior_stage === "implementation", "oracle", "block did not capture prior state");
  blocked = reduce(oracleEnvelope({ event_id: "oracle-resume-0001", transition: "resume", expected: { revision: 5, digest: blocked.digest } }), blocked, {}).record;
  check(blocked.status === "active" && blocked.stage === "implementation", "oracle", "resume did not restore the prior stage");
  ok("block/resume restores the prior status and stage");

  const cancelled = reduce(oracleEnvelope({ event_id: "oracle-cancel-0001", transition: "cancel", reason: "no longer needed", expected: { revision: 4, digest: active.digest } }), active, {}).record;
  check(cancelled.status === "cancelled" && cancelled.stage === "none", "oracle", "cancel did not reach terminal none");
  ok("cancel reaches a terminal disposition");

  expectFail("resume without a block fails", () => reduce(oracleEnvelope({ event_id: "oracle-resume-bad", transition: "resume", expected: { revision: 4, digest: active.digest } }), active, {}), "blocked");

  check(frontierOf([planResult.record]).status === "planned", "oracle", "frontier collapsed planned work into planning_required");
  const readyRecord = reduce(oracleEnvelope({ event_id: "oracle-ready-0002", transition: "ready", expected: { revision: 1, digest: planResult.record.digest } }), planResult.record, {}).record;
  check(frontierOf([readyRecord]).status === "ready" && canonicalJson(frontierOf([readyRecord]).eligible) === canonicalJson([readyRecord.task_id]), "oracle", "frontier did not surface a ready task");
  ok("frontier reports the derived runway state and never invents eligible work");

  // 7b. One closed vocabulary: derived runway state and generation disposition.
  // Exhaustive subset proof: every combination of task statuses reduces to the
  // declared precedence, and no nonterminal mix ever collapses into
  // planning_required.
  const runwayStatusMembers = ["planned", "ready", "active", "blocked", "complete", "cancelled", "superseded"] as const;
  const expectedRunway = (subset: Set<string>): string => {
    for (const state of RUNWAY_PRECEDENCE) {
      if (subset.has(state)) return state;
    }
    return "planning_required";
  };
  let runwayMismatches = 0;
  let nonterminalCollapsed = 0;
  for (let mask = 0; mask < (1 << runwayStatusMembers.length); mask += 1) {
    const subset = new Set<string>();
    runwayStatusMembers.forEach((status, bit) => {
      if (mask & (1 << bit)) subset.add(status);
    });
    const records = [...subset].map((status, index) => ({
      task_id: "g03.0" + String(index),
      generation: "g03",
      status,
    }));
    const actual = runwayOf(records);
    if (actual !== expectedRunway(subset)) runwayMismatches += 1;
    const hasNonterminal = [...subset].some((status) => !TERMINAL_STATUSES.has(status));
    if (hasNonterminal && actual === "planning_required") nonterminalCollapsed += 1;
  }
  check(runwayMismatches === 0, "oracle", "runway precedence has " + runwayMismatches + " mismatches");
  check(nonterminalCollapsed === 0, "oracle", "a nonterminal mix collapsed into planning_required");
  ok("runway precedence is deterministic across all " + (1 << runwayStatusMembers.length) + " status subsets");
  check(frontierOf([{ task_id: "g03.001", generation: "g03", status: "blocked" }]).status === "blocked",
    "oracle", "frontier hid a blocked generation behind planning_required");
  check(frontierOf([{ task_id: "g03.001", generation: "g03", status: "planned" }]).status === "planned",
    "oracle", "frontier hid planned work behind planning_required");
  check(frontierOf([{ task_id: "g03.001", generation: "g03", status: "active" }], "g03").status === "active",
    "oracle", "frontier hid live work behind planning_required");
  ok("frontier exposes ready, active, blocked, and planned work without collapsing states");

  // Disposition is its own axis: absence of the closure record is open, and
  // complete is never a generation label.
  const openState = generationStateOf([], "g03", null);
  check(openState.disposition === "open" && openState.runway === "planning_required", "oracle", "an absent closure record did not default to open");
  const closureOf = (records: Record<string, unknown>[], overrides: Record<string, unknown> = {}): Record<string, unknown> => ({
    schema_version: GENERATION_CLOSURE_SCHEMA,
    generation: "g03",
    disposition: "closed",
    reason: "rollover boundary reached after preservation oracle",
    tasks_digest: generationTasksDigest(records, "g03"),
    closed_at: "2026-09-13T12:00:00.000Z",
    ...overrides,
  });
  const terminalFixture = [
    { task_id: "g03.001", generation: "g03", status: "complete", revision: 2, digest: digestOf("a"), evidence: {} },
    { task_id: "g03.002", generation: "g03", status: "superseded", revision: 4, digest: digestOf("b"), evidence: {} },
  ];
  const closedState = generationStateOf(terminalFixture, "g03", closureOf(terminalFixture));
  check(closedState.disposition === "closed" && closedState.runway === "planning_required", "oracle", "closed terminal generation did not reduce to planning_required runway");
  ok("generation disposition stays open by default and closed only by explicit closure record");

  expectFail("closure record for another generation is ambiguous authority", () => {
    generationStateOf(terminalFixture, "g04", closureOf(terminalFixture));
  }, "expected g04");
  expectFail("invalid closure record fails its schema", () => {
    generationStateOf(terminalFixture, "g03", closureOf(terminalFixture, { disposition: "sealed" }));
  }, "disposition");
  expectFail("a closed generation with live records is incoherent", () => {
    generationStateOf([...terminalFixture, { task_id: "g03.003", generation: "g03", status: "active", revision: 1, digest: digestOf("c"), evidence: {} }], "g03", closureOf(terminalFixture));
  }, "is closed but g03.003 is active");
  ok("closure authority is generation-bound, schema-checked, and refuses open records");

  // Compaction consumes explicit closure authority; terminal records alone
  // never authorize it.
  const receiptFresh = compactGeneration(terminalFixture, "g03", closureOf(terminalFixture));
  const receiptFreshB = compactGeneration([...terminalFixture].reverse(), "g03", closureOf(terminalFixture));
  check(canonicalJson(receiptFresh) === canonicalJson(receiptFreshB), "oracle", "compaction is order-dependent");
  check(receiptFresh.source_digest === closureOf(terminalFixture).tasks_digest, "oracle", "receipt digest did not match the closure-pinned tasks digest");
  check(typeof receiptFresh.closure_digest === "string" && receiptFresh.closure_digest.startsWith("sha256:"), "oracle", "receipt lost its closure provenance");
  expectFail("all-terminal records without closure authority do not compact", () => {
    compactGeneration(terminalFixture, "g03", null as unknown as Record<string, unknown>);
  });
  expectFail("an open closure record is not compaction authority", () => {
    compactGeneration(terminalFixture, "g03", closureOf(terminalFixture, { disposition: "open" }));
  }, "is not compactable");
  expectFail("stale closure authority refuses compaction", () => {
    compactGeneration(terminalFixture, "g03", closureOf(terminalFixture, { tasks_digest: digestOf("stale-set") }));
  }, "stale or mismatched");
  expectFail("a nonterminal record refuses the tasks digest itself", () => {
    generationTasksDigest([...terminalFixture, { task_id: "g03.003", generation: "g03", status: "active", revision: 1, digest: digestOf("c"), evidence: {} }], "g03");
  }, "is not closed: g03.003 is active");
  ok("compaction requires closed, fresh, generation-exact closure authority");

  // 8. Deterministic projection and human-text preservation.
  const secondPlan = oracleEnvelope({ task_id: "g03.006", task_path: "docs/roadmaps/g03/006-portable-lifecycle-core.md", event_id: "oracle-plan-0002-plan", planning: { commit: PLANNING_COMMIT, task_blob_digest: digestOf("other-blob") } });
  const secondRecord = reduce(secondPlan, null, {}).record;
  const projectionState = generationStateOf([completed.record, secondRecord], "g03", null);
  check(projectionState.runway === "planned", "oracle", "mixed terminal+planned records did not project planned runway");
  const projectionA = buildProjection([completed.record, secondRecord], projectionState);
  const projectionB = buildProjection([secondRecord, completed.record], generationStateOf([secondRecord, completed.record], "g03", null));
  check(canonicalJson(projectionA) === canonicalJson(projectionB), "oracle", "projection depends on input order");
  check(projectionA.runway_state === "planned" && projectionA.disposition === "open" && projectionA.generation === "g03", "oracle", "projection lost its generation state axes");
  ok("projection ordering is canonical regardless of input order");

  // The source digest binds the state: a runway or disposition change is a
  // byte change, and foreign-generation records never enter the projection.
  const exhaustedState = generationStateOf([completed.record], "g03", null);
  const projectionExhausted = buildProjection([completed.record], exhaustedState);
  check(projectionExhausted.source_digest !== projectionA.source_digest, "oracle", "runway change did not move the projection digest");
  const g04Record = { ...completed.record, task_id: "g04.001", generation: "g04" };
  check(buildProjection([completed.record, secondRecord, g04Record], projectionState).entries.length === 2,
    "oracle", "projection leaked records from outside the active generation");
  const readyProbe = buildProjection([completed.record, secondRecord], { generation: "g03", disposition: "open", runway: "ready" });
  check(readyProbe.source_digest !== projectionA.source_digest, "oracle", "an invented runway did not change the digest");
  ok("projection binds generation state into the source digest and scopes entries to the active generation");

  check(recordFilePath("/tmp/repo", "g03.005") !== recordFilePath("/tmp/repo", "g03.006"), "oracle", "two tasks share one record path");
  expectFail("projection schema rejects an invented status", () => validateProjection({
    schema_version: PROJECTION_SCHEMA,
    generation: "g03",
    disposition: "open",
    runway_state: "planned",
    source_digest: projectionA.source_digest,
    entries: [{ task_id: "g03.005", status: "invented", stage: "none", revision: 1, record_digest: digestOf("x") }],
  }));
  expectFail("projection schema rejects a generation-complete label", () => validateProjection({
    schema_version: PROJECTION_SCHEMA,
    generation: "g03",
    disposition: "complete",
    runway_state: "planning_required",
    source_digest: projectionA.source_digest,
    entries: [],
  }));
  ok("parallel tasks write separate record paths and share no receipt path");

  const humanText = "# Task\n\nHuman narrative before.\n\n## Notes\nKeep me exactly.\n";
  const firstRender = renderProjectionInto(humanText, projectionA);
  check(firstRender.changed === true, "oracle", "first render reported no change");
  check(firstRender.text.startsWith(humanText), "oracle", "render discarded human text before the block");
  check(firstRender.text.includes("| g03 | open | planned |"), "oracle", "render lost the generation state line");
  const secondRender = renderProjectionInto(firstRender.text, projectionA);
  check(secondRender.changed === false && secondRender.text === firstRender.text, "oracle", "repeat render changed bytes");
  ok("repeat render is a byte-stable no-op that preserves human text");

  verifyProjectionText(firstRender.text, [completed.record, secondRecord], projectionState);
  const drifted = firstRender.text.replace("| complete |", "| active |");
  expectFail("hand-edited generated content fails verification", () => verifyProjectionText(drifted, [completed.record, secondRecord], projectionState), "drift");
  const driftedState = firstRender.text.replace("| g03 | open | planned |", "| g03 | complete | planning_required |");
  expectFail("a hand-edited generation state line fails verification", () => verifyProjectionText(driftedState, [completed.record, secondRecord], projectionState), "drift");
  const outsideEdit = firstRender.text + "\nAnother human paragraph.\n";
  verifyProjectionText(outsideEdit, [completed.record, secondRecord], projectionState);
  ok("narrative outside the sentinels stays human-owned");

  // 9. Portable digest isolates adapter metadata.
  const adapterA = reduce(oracleEnvelope({ event_id: "oracle-adapter-a", source: { adapter: "standalone" } }), null, {}).record;
  const adapterB = reduce(oracleEnvelope({ event_id: "oracle-adapter-b", source: { adapter: "queue-hook" } }), null, {}).record;
  check(adapterA.portable_digest === adapterB.portable_digest, "oracle", "adapter metadata leaked into the portable receipt");
  check(adapterA.digest !== adapterB.digest, "oracle", "adapter metadata is not isolated from the full record digest");
  ok("equivalent facts from different adapters share a portable receipt");

  // 10. Git-backed standalone lifecycle with lock, CAS, and atomicity.
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "northstar-lifecycle-oracle-"));
  try {
    const repo = path.join(tmp, "repo");
    fs.mkdirSync(repo, { recursive: true });
    const run = (args: string[]) => {
      const result = spawnSync("git", args, { cwd: repo, encoding: "utf8" });
      if (result.status !== 0) throw new Error("git " + args.join(" ") + " failed: " + result.stderr);
      return String(result.stdout).trim();
    };
    run(["init", "-q", "-b", "main"]);
    run(["config", "user.email", "oracle@example.invalid"]);
    run(["config", "user.name", "Oracle"]);

    const taskPath = "docs/roadmaps/g03/005-portable-lifecycle-core.md";
    fs.mkdirSync(path.join(repo, "docs/roadmaps/g03"), { recursive: true });
    fs.writeFileSync(path.join(repo, taskPath), "# Portable Lifecycle Core\n\nHuman narrative.\n");
    fs.mkdirSync(path.join(repo, ".northstar/lifecycle/v1"), { recursive: true });
    fs.writeFileSync(path.join(repo, ".northstar/lifecycle/v1/projection-targets.json"), canonicalJson({
      schema_version: PROJECTION_TARGETS_SCHEMA,
      targets: [] as string[],
      active_generation: "g03",
    }) + "\n");
    run(["add", "-A"]);
    run(["commit", "-q", "-m", "plan task"]);
    const planningCommit = run(["rev-parse", "HEAD"]);
    const taskBlobDigest = digestBytes(fs.readFileSync(path.join(repo, taskPath)));

    run(["checkout", "-q", "-b", "feature"]);
    fs.writeFileSync(path.join(repo, "work.txt"), "work\n");
    run(["add", "-A"]);
    run(["commit", "-q", "-m", "feature work"]);
    const featureHead = run(["rev-parse", "HEAD"]);
    run(["checkout", "-q", "main"]);
    run(["merge", "-q", "--no-ff", "feature", "-m", "merge feature"]);
    const mergeCommit = run(["rev-parse", "HEAD"]);
    void featureHead;

    const baseEnv = (overrides: Record<string, unknown>) => {
      const merged = { ...overrides };
      const env: Record<string, unknown> = oracleEnvelope({
        planning: { commit: planningCommit, task_blob_digest: taskBlobDigest },
        ...merged,
      });
      return env;
    };

    const repoRecord = () => readRecord(repo, "g03.005")!;
    const expectedOf = () => ({ revision: Number(repoRecord().revision), digest: String(repoRecord().digest) });
    const commitRecord = () => {
      if (run(["status", "--porcelain"]).trim() === "") return;
      run(["add", "-A"]);
      run(["commit", "-q", "-m", "lifecycle record"]);
    };
    const step = (envelope: Record<string, unknown>) => {
      const applied = applyEnvelope({ repoRoot: repo, envelope });
      commitRecord();
      return applied;
    };

    const escapeTarget = path.join(tmp, "escape-target");
    fs.mkdirSync(escapeTarget, { recursive: true });
    fs.renameSync(path.join(repo, ".northstar"), path.join(tmp, "northstar-real"));
    fs.symlinkSync(escapeTarget, path.join(repo, ".northstar"));
    expectFail("symlinked record directory escape is rejected", () => {
      applyEnvelope({ repoRoot: repo, envelope: baseEnv({ event_id: "standalone-symlink-0001" }) });
    }, "escapes repository root");
    fs.rmSync(path.join(repo, ".northstar"));
    fs.renameSync(path.join(tmp, "northstar-real"), path.join(repo, ".northstar"));
    ok("symlinked lifecycle directory cannot redirect records outside the repository");

    const planApply = step(baseEnv({ event_id: "standalone-plan-0001" }));    check(planApply.status === "applied" && planApply.revision === 1, "oracle", "standalone plan did not apply");
    check(planApply.changed_paths[0] === ".northstar/lifecycle/v1/tasks/g03.005.json", "oracle", "unexpected record path: " + planApply.changed_paths[0]);
    ok("standalone apply writes one task-local record path");

    const replayApply = step(baseEnv({ event_id: "standalone-plan-0001" }));
    check(replayApply.status === "replayed" && replayApply.changed_paths.length === 0, "oracle", "standalone replay rewrote bytes");
    ok("standalone replay is a no-op that preserves the recorded revision");

    const staleEnvelope = baseEnv({ event_id: "standalone-ready-stale", transition: "ready", expected: { revision: 0, digest: null } });
    expectFail("standalone stale writer is rejected", () => step(staleEnvelope), "stale revision");

    expectFail("standalone planning identity mismatch is rejected", () => {
      step(baseEnv({ event_id: "standalone-planning-bad", expected: expectedOf(), planning: { commit: planningCommit, task_blob_digest: digestOf("wrong") } }));
    }, "task blob digest mismatch");

    expectFail("standalone path escape is rejected", () => assertContained(repo, "../escape.md"), "escapes repository root");
    expectFail("standalone absolute path is rejected", () => assertContained(repo, "/etc/passwd"), "absolute path");
    expectFail("standalone task/path mismatch is rejected", () => parseTaskIdentity("g03.999", taskPath, "g03"), "does not match path");

    const readyApply = step(baseEnv({ event_id: "standalone-ready-0001", transition: "ready", expected: expectedOf() }));
    check(readyApply.status === "applied", "oracle", "standalone ready failed");

    // Dirty owned path is rejected.
    const recordFile = path.join(repo, ".northstar/lifecycle/v1/tasks/g03.005.json");
    fs.writeFileSync(recordFile, fs.readFileSync(recordFile, "utf8") + "\n");
    expectFail("dirty owned path is rejected", () => {
      step(baseEnv({ event_id: "standalone-start-dirty", transition: "start", expected: { revision: 2, digest: String(repoRecord().digest) } }));
    }, "uncommitted changes");
    run(["checkout", "-q", "--", ".northstar/lifecycle/v1/tasks/g03.005.json"]);
    ok("dirty owned path preserves prior bytes");

    // Lock contention and stale-lock recovery.
    const lockPath = path.join(gitCommonDir(repo), "northstar-lifecycle.lock");
    fs.writeFileSync(lockPath, String(process.pid));
    expectFail("held lock blocks the write", () => {
      step(baseEnv({ event_id: "standalone-start-locked", transition: "start", expected: expectedOf() }));
    }, "lock is held");
    fs.writeFileSync(lockPath, "2147483647");
    const startApply = step(baseEnv({ event_id: "standalone-start-0001", transition: "start", expected: expectedOf() }));
    check(startApply.status === "applied", "oracle", "stale lock was not recovered");
    ok("stale lock is recovered exactly once");

    // Interrupted write preserves prior bytes.
    const beforeInterrupt = fs.readFileSync(recordFile, "utf8");
    expectFail("interrupted write fails without mutating the record", () => {
      applyEnvelope({
        repoRoot: repo,
        envelope: baseEnv({ event_id: "standalone-advance-interrupted", transition: "advance_stage", target_stage: "implementation", expected: expectedOf() }),
        writeFile: (finalPath: string, data: string) => {
          const dir = path.dirname(finalPath);
          const tmp = path.join(dir, ".tmp-interrupted.json");
          const fd = fs.openSync(tmp, "w");
          fs.writeSync(fd, data);
          fs.fsyncSync(fd);
          fs.closeSync(fd);
          throw new Error("simulated interrupted write");
        },
      });
    }, "simulated interrupted write");
    check(fs.readFileSync(recordFile, "utf8") === beforeInterrupt, "oracle", "interrupted write changed prior bytes");
    fs.rmSync(path.join(path.dirname(recordFile), ".tmp-interrupted.json"), { force: true });
    ok("interrupted write preserves prior bytes and leaves no partial record");

    // Two concurrent writers: exactly one advances, the other loses the CAS.
    const envFileA = path.join(tmp, "env-a.json");
    const envFileB = path.join(tmp, "env-b.json");
    fs.writeFileSync(envFileA, canonicalJson(baseEnv({ event_id: "standalone-race-a", transition: "advance_stage", target_stage: "implementation", expected: expectedOf() })));
    fs.writeFileSync(envFileB, canonicalJson(baseEnv({ event_id: "standalone-race-b", transition: "advance_stage", target_stage: "implementation", expected: expectedOf() })));
    const script = fileURLToPath(import.meta.url);
    const runCli = (envFile: string) => new Promise<number>((resolve) => {
      const child = spawn(process.execPath, ["run", script, "apply", "--repo", repo, "--envelope", envFile], { stdio: "ignore" });
      child.on("exit", (code) => resolve(code ?? 1));
    });
    const raceCodes = await Promise.all([runCli(envFileA), runCli(envFileB)]);
    const raceSuccesses = raceCodes.filter((code) => code === 0).length;
    check(raceSuccesses === 1, "oracle", "concurrent writers produced " + raceSuccesses + " successes");
    verifyRecordIntegrity(readRecord(repo, "g03.005")!);
    commitRecord();
    ok("concurrent writers serialize and the loser preserves prior bytes");

    // Continue the standalone task to completion with real Git ancestry.
    // The reviewed head is the feature commit; the merge commit contains it.
    const prEntry2 = { level: "adapter_attested", source: "github", actor: "bot", method: "pr_state", recorded_at: "2026-09-12T13:00:00.000Z", head_commit: featureHead, pr_number: 9 };
    const reviewEntry2 = { level: "adapter_attested", source: "github", actor: "reviewer", method: "review", recorded_at: "2026-09-12T13:00:01.000Z", verdict: "approved", head_commit: featureHead, pr_number: 9 };
    const mergeEntry2 = { level: "locally_verified", source: "git", actor: "oracle", method: "merge", recorded_at: "2026-09-12T13:00:02.000Z", merge_commit: mergeCommit, head_commit: featureHead, base: "main", merge_method: "merge" };
    step(baseEnv({ event_id: "standalone-review-0001", transition: "advance_stage", target_stage: "review", expected: expectedOf(), evidence: { pr: prEntry2 } }));
    step(baseEnv({ event_id: "standalone-merge-0001", transition: "advance_stage", target_stage: "merge", expected: expectedOf(), evidence: { merge: mergeEntry2, review: reviewEntry2 } }));
    step(baseEnv({ event_id: "standalone-closeout-0001", transition: "advance_stage", target_stage: "closeout", expected: expectedOf(), evidence: { merge: mergeEntry2 } }));
    const repoComplete = step(baseEnv({
      event_id: "standalone-complete-0001",
      transition: "complete",
      expected: expectedOf(),
      evidence: {
        pr: prEntry2,
        review: reviewEntry2,
        merge: mergeEntry2,
        integration: { level: "locally_verified", source: "git", actor: "oracle", method: "synchronized_main", recorded_at: "2026-09-12T13:00:03.000Z", synchronized_main_commit: mergeCommit },
        validation: { level: "adapter_attested", source: "effigy", actor: "oracle", method: "qa", recorded_at: "2026-09-12T13:00:04.000Z", passed: true, head_commit: featureHead, command: "effigy qa" },
        handoff: { level: "adapter_attested", source: "docs", actor: "oracle", method: "handoff", recorded_at: "2026-09-12T13:00:05.000Z", ref: "docs/handoffs/example.md" },
      },
    }));
    check(repoComplete.status === "applied", "oracle", "standalone completion failed");
    check(String(repoRecord().status) === "complete", "oracle", "standalone record is not complete");
    ok("installed-skill core completes a legal lifecycle against a real Git repository");

    // Render + verify + compact through the standalone surfaces.
    const targetFile = path.join(repo, taskPath);
    const scriptPath = fileURLToPath(import.meta.url);
    const runCliRaw = (args: string[]) => spawnSync(process.execPath, ["run", scriptPath, ...args], { cwd: repo, encoding: "utf8" });
    const cliFailHere = (name: string, args: string[], match: string) => {
      const result = runCliRaw(args);
      check(result.status !== 0, "oracle", name + ": CLI unexpectedly succeeded");
      check(String(result.stdout).includes(match), "oracle", name + ": output missed '" + match + "': " + result.stdout);
    };
    const repoRecordsAtClose = listRecords(repo);
    const fixtureState = () => generationStateOf(listRecords(repo), "g03", readGenerationClosure(repo, "g03"));
    const repoStateAtClose = fixtureState();
    check(repoStateAtClose.disposition === "open" && repoStateAtClose.runway === "planning_required", "oracle", "an exhausted open generation did not derive planning_required");
    const projection = buildProjection(repoRecordsAtClose, repoStateAtClose);
    const rendered = renderProjectionInto(fs.readFileSync(targetFile, "utf8"), projection);
    fs.writeFileSync(targetFile, rendered.text);
    check(rendered.text.includes("| g03 | open | planning_required |"), "oracle", "rendered block did not name the planning_required runway");
    check(verifyRepo(repo, targetFile).status === "ok", "oracle", "verify reported drift after a clean render");
    ok("standalone verify accepts a freshly rendered planning_required projection");

    // Compaction consumes explicit closure authority through the core and the
    // CLI; terminal records alone refuse.
    const closureRel = ".northstar/lifecycle/v1/generations/g03.closure.json";
    const receiptOutRel = ".northstar/lifecycle/v1/generations/g03.json";
    const tasksDigest = generationTasksDigest(repoRecordsAtClose, "g03");
    const oracleClosure: Record<string, unknown> = {
      schema_version: GENERATION_CLOSURE_SCHEMA,
      generation: "g03",
      disposition: "closed",
      reason: "oracle rollover boundary after the preservation oracle",
      tasks_digest: tasksDigest,
      closed_at: "2026-09-12T13:30:00.000Z",
    };
    const receiptA = compactGeneration(repoRecordsAtClose, "g03", oracleClosure);
    const receiptB = compactGeneration([...repoRecordsAtClose].reverse(), "g03", oracleClosure);
    check(canonicalJson(receiptA) === canonicalJson(receiptB), "oracle", "compaction is order-dependent");
    check(receiptA.source_digest === tasksDigest, "oracle", "receipt digest did not bind the closure-pinned tasks digest");
    ok("generation compaction is deterministic with no churn");

    cliFailHere("compaction without closure authority is refused", ["compact", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03", "--out", receiptOutRel], "closure record");
    check(!fs.existsSync(path.join(repo, receiptOutRel)), "oracle", "refused compaction still produced a receipt");
    const digestRun = runCliRaw(["tasks-digest", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03"]);
    check(digestRun.status === 0, "oracle", "tasks-digest failed: " + digestRun.stdout);
    check(String(JSON.parse(digestRun.stdout).tasks_digest) === tasksDigest, "oracle", "CLI tasks digest drifted from the core digest");
    fs.mkdirSync(path.join(repo, ".northstar/lifecycle/v1/generations"), { recursive: true });
    fs.writeFileSync(path.join(repo, closureRel), canonicalJson(oracleClosure) + "\n");
    const compactRun = runCliRaw(["compact", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03", "--out", receiptOutRel]);
    check(compactRun.status === 0, "oracle", "authorized compaction failed: " + compactRun.stdout);
    check(String(JSON.parse(fs.readFileSync(path.join(repo, receiptOutRel), "utf8")).source_digest) === tasksDigest, "oracle", "receipt did not record the closure-pinned digest");
    const compactChanged = [...(JSON.parse(compactRun.stdout).changed_paths as string[])].sort();
    const fragmentRel = ".northstar/lifecycle/v1/tasks/g03.005.json";
    check(canonicalJson(compactChanged) === canonicalJson([receiptOutRel, fragmentRel].sort()), "oracle", "compaction did not report the receipt and exact fragment deletion: " + compactChanged.join(","));
    check(!fs.existsSync(path.join(repo, fragmentRel)), "oracle", "compaction left a covered fragment behind");
    const receiptBytesAtClose = fs.readFileSync(path.join(repo, receiptOutRel), "utf8");
    const compactReplay = runCliRaw(["compact", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03", "--out", receiptOutRel]);
    check(compactReplay.status === 0 && String(JSON.parse(compactReplay.stdout).status) === "unchanged", "oracle", "compaction replay rewrote bytes");
    check(fs.readFileSync(path.join(repo, receiptOutRel), "utf8") === receiptBytesAtClose, "oracle", "receipt-only replay changed receipt bytes");
    fs.writeFileSync(path.join(repo, closureRel), canonicalJson({ ...oracleClosure, tasks_digest: digestOf("stale-set") }) + "\n");
    cliFailHere("stale closure authority refuses compaction", ["compact", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03", "--out", receiptOutRel], "stale or mismatched");
    ok("compaction consumes exact closure authority, deletes covered fragments, and replays without churn");

    // Closed-generation catch-up: discovery, exact deletions, interrupted
    // cleanup, and every refusal shape, against a dedicated Git fixture.
    const catchupRepo = path.join(tmp, "catchup-repo");
    fs.mkdirSync(catchupRepo, { recursive: true });
    const gitIn = (dir: string, args: string[]): string => {
      const result = spawnSync("git", args, { cwd: dir, encoding: "utf8" });
      if (result.status !== 0) throw new Error("git " + args.join(" ") + " failed: " + result.stderr);
      return String(result.stdout).trim();
    };
    gitIn(catchupRepo, ["init", "-q", "-b", "main"]);
    gitIn(catchupRepo, ["config", "user.email", "oracle@example.invalid"]);
    gitIn(catchupRepo, ["config", "user.name", "Oracle"]);
    const catchupTasksRel = ".northstar/lifecycle/v1/tasks";
    const catchupGenerationsRel = ".northstar/lifecycle/v1/generations";
    const catchupTasks = path.join(catchupRepo, catchupTasksRel);
    const catchupGenerations = path.join(catchupRepo, catchupGenerationsRel);
    fs.mkdirSync(catchupTasks, { recursive: true });
    fs.mkdirSync(catchupGenerations, { recursive: true });

    // A genuine terminal record per task, reduced through the same reducer the
    // rest of the oracle uses, so integrity verification has real bytes.
    const terminalRecordFixture = (taskId: string): Record<string, unknown> => {
      const prefix = "fix-" + taskId.replace(".", "-");
      const env = (over: Record<string, unknown>) => oracleEnvelope({ task_id: taskId, ...over });
      let rec = reduce(env({ event_id: prefix + "-plan" }), null, {}).record;
      rec = reduce(env({ event_id: prefix + "-ready", transition: "ready", expected: { revision: 1, digest: rec.digest } }), rec, {}).record;
      rec = reduce(env({ event_id: prefix + "-start", transition: "start", expected: { revision: 2, digest: rec.digest } }), rec, {}).record;
      rec = reduce(env({ event_id: prefix + "-impl", transition: "advance_stage", target_stage: "implementation", expected: { revision: 3, digest: rec.digest } }), rec, {}).record;
      rec = reduce(env({ event_id: prefix + "-review", transition: "advance_stage", target_stage: "review", expected: { revision: 4, digest: rec.digest }, evidence: { pr: prEntry } }), rec, {}).record;
      rec = reduce(env({ event_id: prefix + "-merge", transition: "advance_stage", target_stage: "merge", expected: { revision: 5, digest: rec.digest }, evidence: { merge: mergeEntry, review: goodReview } }), rec, {}).record;
      rec = reduce(env({ event_id: prefix + "-closeout", transition: "advance_stage", target_stage: "closeout", expected: { revision: 6, digest: rec.digest }, evidence: { merge: mergeEntry } }), rec, {}).record;
      rec = reduce(env({ event_id: prefix + "-complete", transition: "complete", expected: { revision: 7, digest: rec.digest }, evidence: completionEvidence }), rec, { verifyCommit: () => true, isAncestor: chainAncestor }).record;
      verifyRecordIntegrity(rec);
      return rec;
    };
    const writeFragment = (record: Record<string, unknown>): void => {
      fs.writeFileSync(path.join(catchupTasks, String(record.task_id) + ".json"), canonicalJson(record) + "\n");
    };
    const closureFixture = (generation: string, records: Record<string, unknown>[]): Record<string, unknown> => ({
      schema_version: GENERATION_CLOSURE_SCHEMA,
      generation,
      disposition: "closed",
      reason: "oracle fixture rollover boundary",
      tasks_digest: digestOf(terminalTaskSummaries(records, generation)),
      closed_at: "2026-09-15T16:00:00.000Z",
    });
    const writeClosure = (generation: string, records: Record<string, unknown>[]): Record<string, unknown> => {
      const closure = closureFixture(generation, records);
      fs.writeFileSync(path.join(catchupGenerations, generation + ".closure.json"), canonicalJson(closure) + "\n");
      return closure;
    };

    // Positive path plus deterministic lexical discovery and open untouched.
    const g01Records = [terminalRecordFixture("g01.001"), terminalRecordFixture("g01.002")];
    const g02Records = [terminalRecordFixture("g02.001")];
    const g03OpenRecord = terminalRecordFixture("g03.001");
    for (const record of [...g01Records, ...g02Records, g03OpenRecord]) writeFragment(record);
    const g01Closure = writeClosure("g01", g01Records);
    writeClosure("g02", g02Records);
    const g03OpenBefore = fs.readFileSync(path.join(catchupTasks, "g03.001.json"), "utf8");
    check(canonicalJson(discoverClosedGenerations(catchupRepo)) === canonicalJson(["g01", "g02"]), "oracle", "closed-generation discovery is not exact lexical order");
    const catchUpA = consumeClosedGenerations({ repoRoot: catchupRepo });
    check(catchUpA.status === "applied" && canonicalJson(catchUpA.generations) === canonicalJson(["g01", "g02"]), "oracle", "catch-up did not consume both closed generations");
    const expectedCatchUpPaths = [
      catchupGenerationsRel + "/g01.json",
      catchupGenerationsRel + "/g02.json",
      catchupTasksRel + "/g01.001.json",
      catchupTasksRel + "/g01.002.json",
      catchupTasksRel + "/g02.001.json",
    ].sort();
    check(canonicalJson(catchUpA.changed_paths) === canonicalJson(expectedCatchUpPaths), "oracle", "catch-up changed paths are not exact and deterministic: " + catchUpA.changed_paths.join(","));
    for (const name of ["g01.001.json", "g01.002.json", "g02.001.json"]) {
      check(!fs.existsSync(path.join(catchupTasks, name)), "oracle", "catch-up left a covered fragment: " + name);
    }
    check(fs.readFileSync(path.join(catchupTasks, "g03.001.json"), "utf8") === g03OpenBefore, "oracle", "an open generation was touched by catch-up");
    const g01Receipt = JSON.parse(fs.readFileSync(path.join(catchupGenerations, "g01.json"), "utf8"));
    validateGenerationReceipt(g01Receipt);
    check(canonicalJson(g01Receipt) === canonicalJson(compactGeneration(g01Records, "g01", g01Closure)), "oracle", "standalone compaction bytes drifted from the catch-up receipt");
    const g01ReceiptBytes = fs.readFileSync(path.join(catchupGenerations, "g01.json"), "utf8");
    const stateIds = new Set(receiptStateRecords(catchupRepo).map((record) => String(record.task_id)));
    check(stateIds.has("g01.001") && stateIds.has("g02.001"), "oracle", "receipt-derived records did not expose compacted terminal tasks");
    const receiptAudit = auditCurrentnessText(
      { "docs/roadmaps/g03/README.md": "# g03\n\n## Next Task\n\nContinue with `g01.001` now.\n" },
      listStateRecords(catchupRepo),
      ["docs/roadmaps/g03/README.md"],
    );
    check(receiptAudit.some((violation) => violation.task === "g01.001" && violation.reason === "stale-frontier"),
      "oracle", "currentness audit ignored a receipt-derived terminal task: " + canonicalJson(receiptAudit));
    const catchUpReplay = consumeClosedGenerations({ repoRoot: catchupRepo });
    check(catchUpReplay.status === "unchanged" && catchUpReplay.changed_paths.length === 0, "oracle", "catch-up replay was not a no-op");
    check(fs.readFileSync(path.join(catchupGenerations, "g01.json"), "utf8") === g01ReceiptBytes, "oracle", "catch-up replay rewrote a receipt");
    const digestFromReceipt = spawnSync(process.execPath, ["run", fileURLToPath(import.meta.url), "tasks-digest", "--repo", catchupRepo, "--records", catchupTasksRel, "--generation", "g01"], { encoding: "utf8" });
    check(digestFromReceipt.status === 0 && String(JSON.parse(digestFromReceipt.stdout).tasks_digest) === g01Closure.tasks_digest, "oracle", "tasks-digest did not read the receipt after pruning: " + digestFromReceipt.stdout);
    ok("catch-up consumes closed generations in lexical order and leaves open generations untouched");

    // Interrupted cleanup: a valid receipt plus remaining exact fragments
    // finishes the deletion without rewriting the receipt.
    const g05Records = [terminalRecordFixture("g05.001"), terminalRecordFixture("g05.002")];
    for (const record of g05Records) writeFragment(record);
    writeClosure("g05", g05Records);
    const g05First = consumeClosedGeneration({ repoRoot: catchupRepo, generation: "g05" });
    check(g05First.status === "applied" && g05First.deleted.length === 2, "oracle", "first compaction did not consume both g05 fragments");
    const g05ReceiptBytes = fs.readFileSync(path.join(catchupGenerations, "g05.json"), "utf8");
    writeFragment(g05Records[1]!);
    const g05Second = consumeClosedGenerations({ repoRoot: catchupRepo, generations: ["g05"] });
    check(g05Second.status === "applied" && canonicalJson(g05Second.deleted) === canonicalJson([catchupTasksRel + "/g05.002.json"]), "oracle", "interrupted cleanup did not finish the remaining fragment");
    check(!fs.existsSync(path.join(catchupTasks, "g05.002.json")), "oracle", "interrupted cleanup left the remaining fragment");
    check(fs.readFileSync(path.join(catchupGenerations, "g05.json"), "utf8") === g05ReceiptBytes, "oracle", "interrupted cleanup rewrote the receipt");
    ok("a valid receipt plus remaining exact fragments finishes cleanup safely");

    // Refusals: partial set without a receipt, nonterminal record, malformed
    // receipt, conflicting provenance, symlink, and path escape.
    const g06Records = [terminalRecordFixture("g06.001"), terminalRecordFixture("g06.002")];
    writeFragment(g06Records[0]!);
    writeClosure("g06", g06Records);
    expectFail("a partial fragment set without a receipt refuses", () =>
      consumeClosedGenerations({ repoRoot: catchupRepo, generations: ["g06"] }), "stale or mismatched");
    check(!fs.existsSync(path.join(catchupGenerations, "g06.json")) && fs.existsSync(path.join(catchupTasks, "g06.001.json")), "oracle", "refused partial set mutated lifecycle state");

    const g07Terminal = terminalRecordFixture("g07.001");
    writeFragment(g07Terminal);
    writeFragment(reduce(oracleEnvelope({ task_id: "g07.002", event_id: "fix-g07-002-plan" }), null, {}).record);
    writeClosure("g07", [g07Terminal]);
    expectFail("a nonterminal fragment refuses", () =>
      consumeClosedGenerations({ repoRoot: catchupRepo, generations: ["g07"] }), "is not closed");
    check(!fs.existsSync(path.join(catchupGenerations, "g07.json")), "oracle", "refused nonterminal set produced a receipt");

    const g08Records = [terminalRecordFixture("g08.001")];
    writeFragment(g08Records[0]!);
    writeClosure("g08", g08Records);
    fs.writeFileSync(path.join(catchupGenerations, "g08.json"), canonicalJson({ schema_version: GENERATION_RECEIPT_SCHEMA, generation: "g08" }) + "\n");
    expectFail("a malformed receipt refuses", () =>
      consumeClosedGenerations({ repoRoot: catchupRepo, generations: ["g08"] }), "malformed");
    check(fs.existsSync(path.join(catchupTasks, "g08.001.json")), "oracle", "refused malformed receipt deleted a fragment");

    const g09Records = [terminalRecordFixture("g09.001")];
    writeFragment(g09Records[0]!);
    const g09Closure = writeClosure("g09", g09Records);
    const g09Receipt = { ...compactGeneration(g09Records, "g09", g09Closure), closure_digest: digestOf({ ...g09Closure, reason: "a different boundary" }) };
    fs.writeFileSync(path.join(catchupGenerations, "g09.json"), canonicalJson(g09Receipt) + "\n");
    expectFail("a conflicting receipt refuses against current closure authority", () =>
      consumeClosedGenerations({ repoRoot: catchupRepo, generations: ["g09"] }), "stale or mismatched");
    check(fs.existsSync(path.join(catchupTasks, "g09.001.json")), "oracle", "refused conflicting receipt deleted a fragment");

    const g10Records = [terminalRecordFixture("g10.001")];
    writeFragment(g10Records[0]!);
    writeClosure("g10", g10Records);
    const g10Target = path.join(tmp, "outside-fragment.json");
    fs.writeFileSync(g10Target, canonicalJson(g10Records[0]) + "\n");
    fs.symlinkSync(g10Target, path.join(catchupTasks, "g10.002.json"));
    expectFail("a symlinked fragment refuses", () =>
      consumeClosedGenerations({ repoRoot: catchupRepo, generations: ["g10"] }), "symlink");
    check(fs.existsSync(path.join(catchupTasks, "g10.002.json")) || fs.lstatSync(path.join(catchupTasks, "g10.002.json")).isSymbolicLink(), "oracle", "refused symlinked fragment was deleted");

    expectFail("an escaping records directory refuses", () => planGenerationCompaction({
      repoRoot: catchupRepo,
      generation: "g01",
      recordsDir: path.join(tmp, "outside-records"),
      receiptPath: path.join(catchupGenerations, "g01.json"),
    }), "escapes repository root");
    ok("partial, nonterminal, malformed, conflicting, symlinked, and escaping inputs refuse before mutation");

    // verify treats receipt provenance as structural state: a valid receipt is
    // clean, and a receipt without its closure authority is explicit drift.
    fs.rmSync(path.join(catchupGenerations, "g08.json"));
    fs.rmSync(path.join(catchupGenerations, "g09.json"));
    check(verifyRepo(catchupRepo).status === "ok", "oracle", "verify reported drift for valid receipts: " + canonicalJson(verifyRepo(catchupRepo).problems));
    const g05ClosureFile = path.join(catchupGenerations, "g05.closure.json");
    const g05ClosureBytes = fs.readFileSync(g05ClosureFile, "utf8");
    fs.rmSync(g05ClosureFile);
    const driftReport = verifyRepo(catchupRepo);
    check(driftReport.status === "drift" && driftReport.problems.some((problem) => problem.includes("no closure record")),
      "oracle", "verify did not report a receipt without closure authority: " + canonicalJson(driftReport));
    fs.writeFileSync(g05ClosureFile, g05ClosureBytes);
    ok("verify validates compact receipts and reports lost closure provenance as drift");

    // A closed generation seals its task records against every transition;
    // removing the closure record reopens the generation.
    fs.rmSync(path.join(repo, receiptOutRel), { force: true });
    fs.writeFileSync(path.join(repo, closureRel), canonicalJson(oracleClosure) + "\n");
    expectFail("a transition into a closed generation fails sealed", () => {
      applyEnvelope({ repoRoot: repo, envelope: baseEnv({ event_id: "standalone-sealed-0001" }) });
    }, "records are sealed");
    check(fs.existsSync(path.join(repo, closureRel)) && !fs.existsSync(path.join(repo, receiptOutRel)), "oracle", "sealed refusal mutated lifecycle state");
    fs.rmSync(path.join(repo, closureRel));
    fs.rmSync(path.join(repo, receiptOutRel), { force: true });
    ok("a closed generation seals its task records; absence of the closure record is open");

    // Selected projection regeneration happens inside the same locked write.
    const secondTaskPath = "docs/roadmaps/g03/007-second-task.md";
    fs.writeFileSync(path.join(repo, secondTaskPath), "# Second Task\n\nHuman narrative.\n");
    run(["add", "-A"]);
    run(["commit", "-q", "-m", "plan second task"]);
    const secondCommit = run(["rev-parse", "HEAD"]);
    const secondBlob = digestBytes(fs.readFileSync(path.join(repo, secondTaskPath)));
    const targetRel = "docs/roadmaps/README.md";
    const targetAbs = path.join(repo, targetRel);
    fs.writeFileSync(targetAbs, "# Roadmaps\n\nHuman text stays.\n");
    const secondApply = applyEnvelope({
      repoRoot: repo,
      targets: [targetRel],
      envelope: {
        schema_version: ENVELOPE_SCHEMA,
        event_id: "standalone-plan-0002",
        task_id: "g03.007",
        task_path: secondTaskPath,
        generation: "g03",
        expected: { revision: 0, digest: null },
        transition: "plan",
        event_time: "2026-09-12T14:00:00.000Z",
        actor: "oracle",
        source: { adapter: "standalone" },
        planning: { commit: secondCommit, task_blob_digest: secondBlob },
      },
    });
    check(secondApply.changed_paths.includes(".northstar/lifecycle/v1/tasks/g03.007.json") && secondApply.changed_paths.includes(targetRel),
      "oracle", "apply did not return the record and the selected projection");
    const renderedTarget = fs.readFileSync(targetAbs, "utf8");
    check(renderedTarget.includes(BEGIN_PREFIX) && renderedTarget.includes("g03.007") && renderedTarget.includes("Human text stays."),
      "oracle", "selected projection was not regenerated or lost human text");
    verifyProjectionText(renderedTarget, listRecords(repo), fixtureState());
    ok("apply regenerates a selected projection atomically with the record");

    // Multi-target projections: every target is validated before any mutation,
    // regenerated inside the record lock, and reported as exact changed paths.
    const multiTargets = ["docs/multi-a.md", "docs/nested/multi-b.md"];
    fs.mkdirSync(path.join(repo, "docs/nested"), { recursive: true });
    fs.writeFileSync(path.join(repo, "docs/multi-a.md"), "# Multi A\n\nHuman text stays.\n");
    fs.writeFileSync(path.join(repo, "docs/nested/multi-b.md"), "# Multi B\n\nKeep me.\n");
    const multiTaskPath = "docs/roadmaps/g03/008-multi-target-task.md";
    fs.writeFileSync(path.join(repo, multiTaskPath), "# Multi Target Task\n\nHuman narrative.\n");
    run(["add", "-A"]);
    run(["commit", "-q", "-m", "plan multi-target task"]);
    const multiCommit = run(["rev-parse", "HEAD"]);
    const multiEnvelope = {
      schema_version: ENVELOPE_SCHEMA,
      event_id: "standalone-plan-0003",
      task_id: "g03.008",
      task_path: multiTaskPath,
      generation: "g03",
      expected: { revision: 0, digest: null },
      transition: "plan",
      event_time: "2026-09-12T15:00:00.000Z",
      actor: "oracle",
      source: { adapter: "standalone" },
      planning: { commit: multiCommit, task_blob_digest: digestBytes(fs.readFileSync(path.join(repo, multiTaskPath))) },
    };
    const multiApply = applyEnvelope({ repoRoot: repo, envelope: multiEnvelope, targets: multiTargets });
    check(multiApply.changed_paths.length === 3, "oracle", "multi-target apply did not report all changed paths: " + multiApply.changed_paths.join(","));
    check(canonicalJson(multiApply.changed_paths) === canonicalJson([...multiApply.changed_paths].sort()), "oracle", "multi-target changed paths are not sorted");
    for (const rel of multiTargets) {
      const text = fs.readFileSync(path.join(repo, rel), "utf8");
      check(text.includes("g03.008"), "oracle", "multi-target projection missing the new task in " + rel);
      check(text.includes(rel.endsWith("multi-a.md") ? "Human text stays." : "Keep me."), "oracle", "multi-target lost human text in " + rel);
      verifyProjectionText(text, listRecords(repo), fixtureState());
    }
    ok("multi-target apply validates and renders every declared target");

    // One invalid target must prevent all mutation, including the record.
    const beforeBad = fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8");
    const recordCountBefore = listRecords(repo).length;
    expectFail("escaping multi-target fails before any write", () => {
      applyEnvelope({
        repoRoot: repo,
        targets: ["docs/multi-a.md", "../escape.md"],
        envelope: {
          schema_version: ENVELOPE_SCHEMA,
          event_id: "standalone-plan-0004",
          task_id: "g03.009",
          task_path: "docs/roadmaps/g03/009-escape-task.md",
          generation: "g03",
          expected: { revision: 0, digest: null },
          transition: "plan",
          event_time: "2026-09-12T15:01:00.000Z",
          actor: "oracle",
          source: { adapter: "standalone" },
          planning: { commit: secondCommit, task_blob_digest: digestOf("unresolvable") },
        },
      });
    }, "escapes repository root");
    check(listRecords(repo).length === recordCountBefore, "oracle", "rejected multi-target still wrote a record");
    check(fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8") === beforeBad, "oracle", "rejected multi-target still mutated a target");
    ok("invalid multi-target declaration leaves the repository byte-identical");

    // Explicit-path render/compact containment: escaping or symlinked paths
    // must fail closed without writing. (runCliRaw is defined above; every
    // invocation here executes the same committed source.)
    const cliFail = (name: string, args: string[], match: string) => {
      const result = runCliRaw(args);
      check(result.status !== 0, "oracle", name + ": CLI unexpectedly succeeded");
      check(String(result.stdout).includes(match), "oracle", name + ": output missed '" + match + "': " + result.stdout);
    };
    cliFail("render rejects an escaping records dir", ["render", "--records", "../../etc", "--target", "docs/multi-a.md"], "escapes repository root");
    cliFail("render rejects an escaping target", ["render", "--records", ".northstar/lifecycle/v1/tasks", "--target", "../../outside.md"], "escapes repository root");
    cliFail("compact rejects an escaping output", ["compact", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03", "--out", "../../outside.json"], "escapes repository root");
    const outsideDir = path.join(tmp, "outside-records");
    fs.mkdirSync(outsideDir, { recursive: true });
    fs.symlinkSync(outsideDir, path.join(repo, "symlinked-records"));
    cliFail("render rejects a symlinked records dir", ["render", "--records", "symlinked-records", "--target", "docs/multi-a.md"], "escapes repository root");
    fs.rmSync(path.join(repo, "symlinked-records"));
    ok("explicit-path render and compact re-check containment");

    // A clean explicit-path render still works against the declared paths and
    // carries the generation state line.
    const cleanRender = runCliRaw(["render", "--records", ".northstar/lifecycle/v1/tasks", "--target", "docs/multi-a.md"]);
    check(cleanRender.status === 0, "oracle", "contained render failed: " + cleanRender.stdout);
    check(fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8").includes("| g03 | open |"), "oracle", "contained render lost the generation state line");
    ok("contained explicit-path render succeeds inside the repository");

    // 10b. Parallel active-generation membership: strict singular/plural union,
    // deterministic multi-row rendering, and refusal of out-of-set generations.
    const configRel = ".northstar/lifecycle/v1/projection-targets.json";
    const configAbs = path.join(repo, configRel);
    const singularConfigBytes = fs.readFileSync(configAbs, "utf8");
    const pluralConfig = { schema_version: PROJECTION_TARGETS_SCHEMA, targets: [] as string[], active_generations: ["g03", "g04"] };
    const restorePluralConfig = () => fs.writeFileSync(configAbs, canonicalJson(pluralConfig) + "\n");

    const g04TaskPath = "docs/roadmaps/g04/010-parallel-task.md";
    fs.mkdirSync(path.join(repo, "docs/roadmaps/g04"), { recursive: true });
    fs.writeFileSync(path.join(repo, g04TaskPath), "# Parallel Task\n\nHuman narrative.\n");
    run(["add", "-A"]);
    run(["commit", "-q", "-m", "plan g04 parallel task"]);
    const g04Commit = run(["rev-parse", "HEAD"]);
    const g04PlanEnv = baseEnv({
      event_id: "standalone-plan-g04-0001",
      task_id: "g04.010",
      task_path: g04TaskPath,
      generation: "g04",
      expected: { revision: 0, digest: null },
      planning: { commit: g04Commit, task_blob_digest: digestBytes(fs.readFileSync(path.join(repo, g04TaskPath))) },
    });

    // The singular declaration is still committed: g04 is outside the set and
    // refuses before any byte changes, with and without render targets.
    const targetBeforeRefusal = fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8");
    expectFail("out-of-set generation transition with targets is refused", () => {
      applyEnvelope({ repoRoot: repo, targets: ["docs/multi-a.md"], envelope: g04PlanEnv });
    }, "not in the declared active-generation set");
    expectFail("out-of-set generation record-only transition is refused", () => {
      applyEnvelope({ repoRoot: repo, envelope: g04PlanEnv });
    }, "not in the declared active-generation set");
    check(!fs.existsSync(path.join(repo, ".northstar/lifecycle/v1/tasks/g04.010.json")), "oracle", "refused out-of-set transition still wrote a record");
    check(fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8") === targetBeforeRefusal, "oracle", "refused out-of-set transition still mutated a target");
    ok("membership refusal keeps an out-of-set generation out of the projection");

    // Declaring the parallel set admits both generations and renders one row
    // per active generation in lexical order.
    fs.writeFileSync(configAbs, canonicalJson(pluralConfig) + "\n");
    run(["add", "-A"]);
    run(["commit", "-q", "-m", "declare parallel active generations"]);
    const recordsBeforePlural = listRecords(repo);
    const singularBefore = fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8");
    const g04Apply = applyEnvelope({ repoRoot: repo, envelope: g04PlanEnv, targets: ["docs/multi-a.md"] });
    check(g04Apply.status === "applied", "oracle", "parallel-set g04 plan was refused: " + JSON.stringify(g04Apply));
    const pluralRendered = fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8");
    check(pluralRendered.includes("| g03 | open | planned |"), "oracle", "parallel render lost the g03 state row");
    check(pluralRendered.includes("| g04 | open | planned |"), "oracle", "parallel render lost the g04 state row");
    check(pluralRendered.indexOf("| g03 | open | planned |") < pluralRendered.indexOf("| g04 | open | planned |"), "oracle", "parallel state rows are not in lexical order");
    check(pluralRendered.includes("| g04.010 | planned | none |"), "oracle", "parallel render lost the g04 entry");
    check(pluralRendered.includes("| g03.007 |") && pluralRendered.indexOf("| g03.007 |") < pluralRendered.indexOf("| g04.010 |"), "oracle", "parallel entries are not grouped by generation and task id");
    check(pluralRendered.includes("Human text stays."), "oracle", "parallel render lost human text");
    const verifyRun = runCliRaw(["verify", "--target", "docs/multi-a.md"]);
    check(verifyRun.status === 0, "oracle", "parallel verify reported drift: " + verifyRun.stdout);
    const replayRender = runCliRaw(["render", "--records", ".northstar/lifecycle/v1/tasks", "--target", "docs/multi-a.md"]);
    check(replayRender.status === 0 && String(JSON.parse(replayRender.stdout).status) === "unchanged", "oracle", "parallel replay render changed bytes: " + replayRender.stdout);
    ok("parallel declarations render one lexical row per active generation deterministically");

    // Configuration union negatives: every malformed declaration fails closed
    // before any mutation, then restores the committed plural declaration.
    const expectConfigRefused = (name: string, variant: Record<string, unknown>, match: string) => {
      fs.writeFileSync(configAbs, canonicalJson(variant) + "\n");
      cliFailHere(name, ["render", "--records", ".northstar/lifecycle/v1/tasks", "--target", "docs/multi-a.md"], match);
      restorePluralConfig();
    };
    expectConfigRefused("both singular and plural keys are refused",
      { schema_version: PROJECTION_TARGETS_SCHEMA, targets: [], active_generation: "g03", active_generations: ["g03", "g04"] }, "exactly one");
    expectConfigRefused("neither key is refused",
      { schema_version: PROJECTION_TARGETS_SCHEMA, targets: [] }, "neither key");
    expectConfigRefused("an empty parallel set is refused",
      { schema_version: PROJECTION_TARGETS_SCHEMA, targets: [], active_generations: [] }, "1-16 gNN generations");
    expectConfigRefused("an unsorted parallel set is refused without silent sorting",
      { schema_version: PROJECTION_TARGETS_SCHEMA, targets: [], active_generations: ["g04", "g03"] }, "lexical order");
    expectConfigRefused("a duplicate parallel set is refused",
      { schema_version: PROJECTION_TARGETS_SCHEMA, targets: [], active_generations: ["g03", "g03", "g04"] }, "duplicate active generations");
    ok("configuration union negatives fail closed before any byte changes");

    // Projection schema negatives: the singular and parallel shapes are
    // mutually exclusive, and the parallel rows are closed objects.
    const g04Record = { ...secondRecord, task_id: "g04.010", generation: "g04" };
    const parallelStateA = [
      generationStateOf(recordsBeforePlural, "g03", null),
      generationStateOf(recordsBeforePlural, "g04", null),
    ];
    const parallelStateB = [...parallelStateA].reverse();
    const parallelProjectionA = buildProjectionStates([...recordsBeforePlural, g04Record], parallelStateA);
    const parallelProjectionB = buildProjectionStates([...recordsBeforePlural, g04Record], parallelStateB);
    check(canonicalJson(parallelProjectionA) === canonicalJson(parallelProjectionB), "oracle", "parallel projection depends on state order");
    check(Array.isArray(parallelProjectionA.generations) && parallelProjectionA.generation === undefined, "oracle", "parallel projection kept singular keys");
    check(canonicalJson(parallelProjectionA.generations) === canonicalJson([
      { generation: "g03", disposition: "open", runway_state: "planned" },
      { generation: "g04", disposition: "open", runway_state: "planning_required" },
    ]), "oracle", "parallel rows lost their state axes");
    expectFail("projection schema rejects mixed singular and parallel rows", () => validateProjection({
      schema_version: PROJECTION_SCHEMA,
      generation: "g03",
      disposition: "open",
      runway_state: "planned",
      generations: [{ generation: "g04", disposition: "open", runway_state: "planned" }],
      source_digest: parallelProjectionA.source_digest,
      entries: [],
    }));
    expectFail("projection schema rejects a parallel row with an invented disposition", () => validateProjection({
      schema_version: PROJECTION_SCHEMA,
      generations: [{ generation: "g04", disposition: "sealed", runway_state: "planned" }],
      source_digest: parallelProjectionA.source_digest,
      entries: [],
    }));
    expectFail("projection schema rejects an empty parallel row set", () => validateProjection({
      schema_version: PROJECTION_SCHEMA,
      generations: [],
      source_digest: parallelProjectionA.source_digest,
      entries: [],
    }));
    ok("parallel projection shape is schema-checked and mutually exclusive with the singular shape");

    // Existing singular output bytes: restoring the singular declaration
    // re-renders the exact pre-parallel block, including its digest.
    fs.writeFileSync(configAbs, singularConfigBytes);
    const backToSingular = runCliRaw(["render", "--records", ".northstar/lifecycle/v1/tasks", "--target", "docs/multi-a.md"]);
    check(backToSingular.status === 0, "oracle", "singular render after parallel mode failed: " + backToSingular.stdout);
    const singularAfter = fs.readFileSync(path.join(repo, "docs/multi-a.md"), "utf8");
    check(singularAfter === singularBefore, "oracle", "singular projection bytes changed across a parallel declaration");
    check(!singularAfter.includes("g04.010"), "oracle", "singular render leaked out-of-set records");
    restorePluralConfig();
    ok("singular output bytes survive a parallel declaration unchanged");

    // 10c. Sole-source currentness audit: Silo-shaped duplicates fail with
    // exact file, section, task, and reason; cutover shapes pass.
    const auditRecords = [
      { task_id: "g03.011", generation: "g03", status: "complete", task_path: "docs/roadmaps/g03/011-task.md" },
      { task_id: "g03.012", generation: "g03", status: "ready", task_path: "docs/roadmaps/g03/012-task.md" },
    ];
    const staleTask = "# g03.011\n\nStatus: Ready\n\nHuman outcome stays.\n";
    const cutoverTask = "# g03.011\n\nHuman outcome stays.\n";
    const staleDoor = "# g03\n\n## Next Task\n\nContinue with `g03.011` now.\n";
    const readyDoor = "# g03\n\n## Next Task\n\nContinue with `g03.012` now.\n";
    const historyDoor = "# g03\n\n## History\n\nCompleted `g03.011` at `99bbc94`.\n";
    const goalTable = "# g03\n\n## Generation Runway\n\n| Goal | State | Next Task |\n| --- | --- | --- |\n| Parallel projections. | complete as `g03.011` | exact portfolio repair |\n";
    const retroTable = "# g03\n\n## History\n\n### Prior sequencing\n\n| Goal | State | Next Task |\n| --- | --- | --- |\n| Old lane. | complete as `g03.011` | continued with `g03.011` |\n";
    const staleTable = "# g03\n\n## Goals\n\n| Goal | State | Next Task |\n| --- | --- | --- |\n| Parallel projections. | ready as `g03.011` | continue with `g03.011` |\n";
    const runwayStaleTable = "# g03\n\n## Generation Runway\n\n| Goal | State | Next Task |\n| --- | --- | --- |\n| Shipped projections. | complete as `g03.011` | continue with `g03.011` |\n";
    const liveTask = "# g03.012\n\nHuman outcome stays.\n";
    const staleFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": staleTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": staleDoor },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(staleFindings.some((v) => v.file === "docs/roadmaps/g03/011-task.md" && v.task === "g03.011" && v.reason === "duplicate-status-header"),
      "oracle", "audit accepted a terminal record beside Status: Ready");
    check(staleFindings.some((v) => v.file === "docs/roadmaps/g03/README.md" && v.section === "Next Task" && v.task === "g03.011" && v.reason === "stale-frontier"),
      "oracle", "audit accepted a Next Task section naming a terminal task");
    const tableFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": staleTable },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(tableFindings.some((v) => v.task === "g03.011" && v.reason === "stale-next-task-column"),
      "oracle", "audit accepted a Next-task column naming a terminal task");
    const runwayFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": runwayStaleTable },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(runwayFindings.some((v) => v.task === "g03.011" && v.reason === "stale-next-task-column"),
      "oracle", "audit exempted a Generation Runway Next-task column naming a terminal task");
    const retroFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": retroTable },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(retroFindings.length === 0, "oracle", "audit rejected a retrospective History table: " + canonicalJson(retroFindings));
    const backlogTable = "# g03\n\n## Backlog\n\n| Goal | State | Next Task |\n| --- | --- | --- |\n| Old idea. | deferred | continue with `g03.011` |\n";
    const backlogFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": backlogTable },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(backlogFindings.some((v) => v.task === "g03.011" && v.reason === "stale-next-task-column"),
      "oracle", "audit exempted a live Backlog table through the log substring");
    const nestedDoor = "# g03\n\n## Next Task\n\nLane intro.\n\n### Detail\n\nContinue with `g03.011` now.\n";
    const nestedFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": nestedDoor },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(nestedFindings.some((v) => v.section === "Next Task" && v.task === "g03.011" && v.reason === "stale-frontier"),
      "oracle", "audit let a nested subsection evade stale-frontier detection");
    const cleanFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": readyDoor },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(cleanFindings.length === 0, "oracle", "audit rejected the cutover shape: " + canonicalJson(cleanFindings));
    const historyFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": historyDoor + "\n" + goalTable },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(historyFindings.length === 0, "oracle", "audit mistook retrospective history for currentness: " + canonicalJson(historyFindings));
    const boundaryFindings = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": "# g03\n\n## Next Task\n\nSee g03.0110 for details.\n" },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(boundaryFindings.length === 0, "oracle", "audit matched a task id inside a longer token: " + canonicalJson(boundaryFindings));
    const blockHidingStale = BEGIN_PREFIX + " schema=northstar.lifecycle.projection.v2 digest=sha256:" + "0".repeat(64) + " -->\nStatus: complete\n\n## Next Task\n\nContinue with `g03.011`.\n" + END_SENTINEL + "\n";
    const blockExempt = auditCurrentnessText(
      { "docs/roadmaps/g03/011-task.md": cutoverTask, "docs/roadmaps/g03/012-task.md": liveTask, "docs/roadmaps/g03/README.md": "# g03\n\nHuman intent stays.\n" + blockHidingStale },
      auditRecords, ["docs/roadmaps/g03/README.md"]);
    check(blockExempt.length === 0, "oracle", "audit flagged generated-block content: " + canonicalJson(blockExempt));
    ok("currentness audit rejects Silo-shaped duplicates and accepts the cutover");

    // 10d. Terminal-closeout marker convergence: one shared rule owns the
    // marker shape, the bounded ownership test refuses human prose, and
    // removal leaves every other byte identical.
    check(STATUS_HEADER_LINE_RE.test("Status: Ready") && STATUS_HEADER_LINE_RE.test("Status:Ready"),
      "oracle", "marker rule rejected the shared header shape");
    check(!STATUS_HEADER_LINE_RE.test("status: Ready") && !STATUS_HEADER_LINE_RE.test("Status:"),
      "oracle", "marker rule matched a non-marker line");
    const markerBody = "# g03.021 — Task\n\nStatus: Ready after g03.020\nOwner: fixture\n\n## Outcome\n\nHuman outcome stays.\n";
    const ownedScan = scanStatusMarkers(markerBody);
    check(ownedScan.owned.length === 1 && ownedScan.owned[0]!.section === "g03.021 — Task" && ownedScan.ambiguous.length === 0,
      "oracle", "leading pre-terminal marker was not attributed to the adapter");
    const markerConverged = convergeStatusMarkers(markerBody);
    check(markerConverged.removed === 1 &&
      markerConverged.text === "# g03.021 — Task\n\nOwner: fixture\n\n## Outcome\n\nHuman outcome stays.\n",
      "oracle", "marker convergence changed bytes outside the exact marker line");
    const topMarker = convergeStatusMarkers("Status: Ready\n\n# t\n\n## Outcome\n");
    check(topMarker.removed === 1 && topMarker.text === "\n# t\n\n## Outcome\n",
      "oracle", "marker before the title heading was not owned");
    const sectionMarker = "# t\n\n## Outcome\n\nStatus: Ready\n";
    const sectionScan = scanStatusMarkers(sectionMarker);
    check(sectionScan.owned.length === 0 && sectionScan.ambiguous.length === 1 && sectionScan.ambiguous[0]!.section === "Outcome",
      "oracle", "status-looking prose under a section heading was treated as adapter-owned");
    check(convergeStatusMarkers(sectionMarker).text === sectionMarker,
      "oracle", "an ambiguous marker was modified instead of refused");
    const fencedMarker = "# t\n\nExample:\n\n```md\nStatus: Ready\n```\n";
    check(scanStatusMarkers(fencedMarker).ambiguous.length === 1,
      "oracle", "a status-looking line inside a fenced code block was treated as adapter-owned");
    const indentedMarker = "# t\n\n    Status: Ready\n";
    const indentedScan = scanStatusMarkers(indentedMarker);
    check(indentedScan.owned.length === 0 && indentedScan.ambiguous.length === 0,
      "oracle", "the line-start-anchored marker rule matched an indented code line");
    const blockMarker = "# t\n\n" + BEGIN_PREFIX + " schema=northstar.lifecycle.projection.v2 digest=sha256:" + "0".repeat(64) + " -->\nStatus: complete\n" + END_SENTINEL + "\n";
    const blockScan = scanStatusMarkers(blockMarker);
    check(blockScan.owned.length === 0 && blockScan.ambiguous.length === 0,
      "oracle", "marker scan touched generated-block bytes");
    const multiMarker = "# t\n\nStatus: Ready\nOwner: fixture\nStatus: Ready again\n";
    check(convergeStatusMarkers(multiMarker).removed === 2,
      "oracle", "convergence removed only one owned marker");
    ok("marker convergence owns the leading header region and refuses ambiguous prose");

    // 10e. The exact byte drift a first generated-block insertion introduces:
    // the renderer writes `<bytes><block>\n`, adding one newline first when
    // the file lacked a final newline. This is the only task-file difference
    // the closeout planning-identity check lawfully accepts.
    const insertState = generationStateOf([], "g03", null);
    const insertProjection = buildProjectionStates([], [insertState]);
    const insertionBase = "# g03.021\n\nStatus: Ready\nOwner: fixture";
    const insertionWithNl = insertionBase + "\n";
    check(stripGeneratedBlocks(renderProjectionInto(insertionWithNl, insertProjection).text) === insertionWithNl + "\n",
      "oracle", "block insertion into a newline-terminated file drifted beyond one appended newline");
    check(stripGeneratedBlocks(renderProjectionInto(insertionBase, insertProjection).text) === insertionBase + "\n\n",
      "oracle", "block insertion into a file without a final newline drifted beyond the lawful separator");
    ok("block-insertion byte drift is exactly the appended separator");

    // 11. Static portability scan of this very source file.
    const ownSource = fs.readFileSync(fileURLToPath(import.meta.url), "utf8");
    const forbidden = forbiddenImportSpecifiers(ownSource);
    check(forbidden.length === 0, "oracle", "core imports provider/network modules: " + forbidden.join(", "));
    ok("core imports no Paseo, Queue, daemon, or network module");

    void run;
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  console.log("# " + count + " lifecycle-core checks passed");
  return 0;
}

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

function parseFlags(args: string[]): { flags: Record<string, string | true>; rest: string[] } {
  const flags: Record<string, string | true> = {};
  const rest: string[] = [];
  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];
    if (arg.startsWith("--")) {
      const key = arg.slice(2);
      const next = args[i + 1];
      if (next !== undefined && !next.startsWith("--")) {
        flags[key] = next;
        i += 1;
      } else {
        flags[key] = true;
      }
    } else {
      rest.push(arg);
    }
  }
  return { flags, rest };
}

function resolveRepoRoot(flags: Record<string, string | true>): string {
  const start = typeof flags.repo === "string" ? flags.repo : process.cwd();
  return discoverRepoRoot(start);
}

// Projection targets arrive as repeatable --target values. parseFlags only
// keeps the last one, so targets are also collected from the raw argument
// list and must each pass explicit-path containment at apply time.
function collectTargets(flags: Record<string, string | true>, rest: string[]): string[] {
  const targets: string[] = [];
  for (let i = 0; i < rest.length; i += 1) {
    if (rest[i] === "--target" && typeof rest[i + 1] === "string") {
      targets.push(rest[i + 1] as string);
      i += 1;
    }
  }
  if (typeof flags.target === "string" && !targets.includes(flags.target)) targets.push(flags.target);
  return targets;
}

function readEnvelopeInput(value: string | true | undefined): Record<string, unknown> {
  check(typeof value === "string", "usage", "apply requires --envelope <file|->");
  const text = value === "-" ? fs.readFileSync(0, "utf8") : fs.readFileSync(value, "utf8");
  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    return fail("envelope-parse", "transition envelope is not valid JSON");
  }
  return parsed as Record<string, unknown>;
}

function printJson(value: unknown): void {
  console.log(JSON.stringify(value, null, 2));
}

async function main(): Promise<void> {
  const [command, ...rest] = process.argv.slice(2);
  const { flags } = parseFlags(rest);
  try {
    switch (command) {
      case "oracle": {
        process.exitCode = await runOracle();
        return;
      }
      case "schema-check": {
        check(typeof flags.schema === "string" && typeof flags.instance === "string", "usage", "schema-check requires --schema and --instance");
        validateAgainstSchemaFile(JSON.parse(fs.readFileSync(flags.instance as string, "utf8")), flags.schema as string);
        printJson({ status: "ok" });
        return;
      }
      case "status": {
        const repoRoot = resolveRepoRoot(flags);
        const records = listRecords(repoRoot);
        const config = readProjectionConfig(repoRoot);
        check(config !== null || records.length === 0, "projection-config",
          TARGETS_CONFIG_REL + " is missing; lifecycle records exist but no active generation is declared");
        const generations = config === null ? [] : config.active_generations.map((generation) =>
          generationStateOf(records, generation, readGenerationClosure(repoRoot, generation)));
        printJson({
          status: "ok",
          records,
          generation: generations.length === 1 ? generations[0] : null,
          generations,
          frontier: frontierOf(records, config?.active_generations),
        });
        return;
      }
      case "audit-currentness": {
        const repoRoot = resolveRepoRoot(flags);
        const result = auditCurrentness(repoRoot);
        printJson(result);
        if (result.status !== "ok") process.exitCode = 1;
        return;
      }
      case "frontier": {
        const repoRoot = resolveRepoRoot(flags);
        const records = listRecords(repoRoot);
        const config = readProjectionConfig(repoRoot);
        check(config !== null || records.length === 0, "projection-config",
          TARGETS_CONFIG_REL + " is missing; lifecycle records exist but no active generation is declared");
        printJson(frontierOf(records, config?.active_generations));
        return;
      }
      case "verify": {
        const repoRoot = resolveRepoRoot(flags);
        const target = typeof flags.target === "string" ? flags.target : undefined;
        const result = verifyRepo(repoRoot, target);
        printJson(result);
        if (result.status !== "ok") process.exitCode = 1;
        return;
      }
      case "apply": {
        const repoRoot = resolveRepoRoot(flags);
        const envelope = readEnvelopeInput(flags.envelope);
        const targetList = collectTargets(flags, rest);
        const result = applyEnvelope({ repoRoot, envelope, branch: typeof flags.branch === "string" ? flags.branch : undefined, targets: targetList });
        printJson(result);
        return;
      }
      case "render": {
        check(typeof flags.records === "string" && typeof flags.target === "string", "usage", "render requires --records <dir> and --target <file>");
        const repoRoot = resolveRepoRoot(flags);
        const recordsDir = containRepoPath(repoRoot, flags.records as string);
        const target = containRepoPath(repoRoot, flags.target as string);
        const recordsAbs = path.resolve(repoRoot, recordsDir);
        check(fs.existsSync(recordsAbs) && fs.statSync(recordsAbs).isDirectory(), "containment", "records directory is missing or not a directory: " + recordsDir);
        assertRealContained(repoRoot, recordsAbs);
        const records = fs.readdirSync(recordsAbs).filter((name) => name.endsWith(".json")).sort()
          .map((name) => JSON.parse(fs.readFileSync(path.join(recordsAbs, name), "utf8")) as Record<string, unknown>);
        for (const record of records) verifyRecordIntegrity(record);
        const targetAbs = path.resolve(repoRoot, target);
        assertRealContained(repoRoot, fs.existsSync(targetAbs) ? targetAbs : path.dirname(targetAbs));
        const existing = fs.existsSync(targetAbs) ? fs.readFileSync(targetAbs, "utf8") : "";
        const config = requireProjectionConfig(repoRoot);
        const states = config.active_generations.map((generation) =>
          generationStateOf(records, generation, readGenerationClosure(repoRoot, generation)));
        const projection = buildProjectionStates(records, states);
        const result = renderProjectionInto(existing, projection);
        if (result.changed) writeFileAtomic(targetAbs, result.text);
        printJson({ status: result.changed ? "applied" : "unchanged", task_id: "projection", revision: 0, digest: String(projection.source_digest), changed_paths: result.changed ? [target] : [] });
        return;
      }
      case "tasks-digest": {
        check(typeof flags.records === "string" && typeof flags.generation === "string", "usage", "tasks-digest requires --records <dir> and --generation <gNN>");
        const repoRoot = resolveRepoRoot(flags);
        const recordsDir = containRepoPath(repoRoot, flags.records as string);
        const recordsAbs = path.resolve(repoRoot, recordsDir);
        check(fs.existsSync(recordsAbs) && fs.statSync(recordsAbs).isDirectory(), "containment", "records directory is missing or not a directory: " + recordsDir);
        assertRealContained(repoRoot, recordsAbs);
        const records = fs.readdirSync(recordsAbs).filter((name) => name.endsWith(".json")).sort()
          .map((name) => JSON.parse(fs.readFileSync(path.join(recordsAbs, name), "utf8")) as Record<string, unknown>);
        for (const record of records) verifyRecordIntegrity(record);
        const scoped = records.filter((record) => record.generation === flags.generation);
        // A compacted closed generation has no fragments left; its receipt is
        // the canonical source of the same digest, so closure authoring and
        // later audit read one stable value across the pruning boundary.
        if (scoped.length === 0) {
          const receiptPath = generationReceiptPath(repoRoot, flags.generation as string);
          const loaded = readReceiptFile(receiptPath, path.relative(repoRoot, receiptPath).split(path.sep).join("/"));
          check(loaded !== null, "compaction",
            "generation " + flags.generation + " has no task fragments and no receipt to derive a tasks digest from");
          const closure = readGenerationClosure(repoRoot, flags.generation as string);
          check(closure !== null, "compaction",
            "generation " + flags.generation + " has a receipt but no closure record to verify it against");
          verifyReceiptProvenance(loaded!.receipt, flags.generation as string, closure as Record<string, unknown>);
          printJson({ generation: flags.generation, tasks_digest: loaded!.receipt.source_digest, source: "receipt" });
          return;
        }
        printJson({ generation: flags.generation, tasks_digest: generationTasksDigest(records, flags.generation as string), source: "fragments" });
        return;
      }
      case "compact": {
        check(typeof flags.records === "string" && typeof flags.generation === "string" && typeof flags.out === "string", "usage", "compact requires --records, --generation, and --out");
        const repoRoot = resolveRepoRoot(flags);
        const recordsDir = containRepoPath(repoRoot, flags.records as string);
        const out = containRepoPath(repoRoot, flags.out as string);
        const outcome = consumeClosedGeneration({
          repoRoot,
          generation: flags.generation as string,
          recordsDir: path.resolve(repoRoot, recordsDir),
          receiptPath: path.resolve(repoRoot, out),
        });
        printJson({
          status: outcome.status,
          generation: outcome.generation,
          receipt_created: outcome.receipt_created,
          deleted: outcome.deleted,
          changed_paths: outcome.changed_paths,
        });
        return;
      }
      case "catch-up": {
        const repoRoot = resolveRepoRoot(flags);
        const result = consumeClosedGenerations({ repoRoot });
        printJson(result);
        return;
      }
      default:
        printJson({
          status: "error",
          message: "usage: lifecycle-core.ts <oracle|schema-check|status|frontier|verify|audit-currentness|apply|render|tasks-digest|compact|catch-up> [flags]",
        });
        process.exitCode = 2;
    }
  } catch (err) {
    if (err instanceof LifecycleError) {
      printJson({ status: "error", code: err.code, message: err.message });
      process.exitCode = 1;
      return;
    }
    throw err;
  }
}

if (import.meta.main) {
  main().catch((err) => {
    printJson({ status: "error", code: "internal", message: (err as Error).message });
    process.exitCode = 1;
  });
}
