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

// The projection is scoped to the declared active generation: the state line
// and the entry set describe exactly that generation, and the source digest
// binds the state and entries together so neither can drift from the other.
export function buildProjection(records: Record<string, unknown>[], state: GenerationState): Record<string, unknown> {
  const entries = projectionEntries(records.filter((record) => record.generation === state.generation));
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

export function renderProjectionBlock(projection: Record<string, unknown>): string {
  validateProjection(projection);
  const entries = projection.entries as ProjectionEntry[];
  const lines = [
    BEGIN_PREFIX + " schema=" + PROJECTION_SCHEMA + " digest=" + String(projection.source_digest) + " -->",
    "| Generation | Disposition | Runway state |",
    "| --- | --- | --- |",
    "| " + String(projection.generation) + " | " + String(projection.disposition) + " | " + String(projection.runway_state) + " |",
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

export function verifyProjectionText(text: string, records: Record<string, unknown>[], state: GenerationState): void {
  const projection = buildProjection(records, state);
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
  active_generation: string;
}

// Read and validate the repository-declared projection configuration. The v2
// config names the active generation, so every projection surface derives its
// state from one declared source instead of guessing from record presence.
// Returns null when the config is absent; callers decide whether that is
// lawful for their surface.
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
    "projection-config", "projection targets config has an unsupported schema_version: " + String(config.schema_version) + " (expected " + PROJECTION_TARGETS_SCHEMA + " with an active_generation)");
  const declared = config.targets;
  check(Array.isArray(declared) && declared.length <= 64 && declared.every((t) => typeof t === "string" && t.length > 0),
    "projection-config", "projection targets config must carry at most 64 non-empty target paths");
  check(new Set(declared as string[]).size === (declared as string[]).length, "projection-config", "projection targets config has duplicate entries");
  check(typeof config.active_generation === "string" && GENERATION_RE.test(config.active_generation),
    "projection-config", "projection targets config must declare the active generation as gNN");
  return {
    schema_version: PROJECTION_TARGETS_SCHEMA,
    targets: (declared as string[]).map((target) => containRepoPath(repoRoot, target)),
    active_generation: config.active_generation as string,
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

function writeFileAtomic(finalPath: string, data: string): void {
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
  // Test seam: the atomic writer is injectable so interruption behavior can be
  // exercised without weakening the production path.
  writeFile?: (finalPath: string, data: string) => void;
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
      for (const record of listRecords(repoRoot)) statuses[String(record.task_id)] = String(record.status);
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

  // Rendering projections requires the declared active generation; record-only
  // writes stay lawful in repositories that have not declared one.
  const config = targetPaths.length > 0 ? requireProjectionConfig(repoRoot) : null;

  const file = recordFilePath(repoRoot, identity.taskId);
  assertRealContained(repoRoot, path.dirname(file));
  let result: ApplyResult | null = null;
  withLifecycleLock(repoRoot, () => {
    const current = readRecord(repoRoot, identity.taskId);
    assertRecordPathClean(repoRoot, file);
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
    (options.writeFile ?? writeFileAtomic)(file, canonicalJson(reduced.record) + "\n");
    const changed = [path.relative(repoRoot, file)];
    const records = listRecords(repoRoot);
    const state = config === null ? null : generationStateOf(records, config.active_generation, readGenerationClosure(repoRoot, config.active_generation));
    const projection = state === null ? null : buildProjection(records, state);
    for (const targetAbs of targetPaths) {
      const existing = fs.existsSync(targetAbs) ? fs.readFileSync(targetAbs, "utf8") : "";
      const projected = renderProjectionInto(existing, projection!);
      if (projected.changed) {
        writeFileAtomic(targetAbs, projected.text);
        changed.push(path.relative(repoRoot, targetAbs));
      }
    }
    changed.sort();
    result = {
      status: "applied",
      task_id: identity.taskId,
      revision: Number(reduced.record.revision),
      digest: String(reduced.record.digest),
      portable_digest: String(reduced.record.portable_digest),
      changed_paths: changed,
      commit_action: { required: true, paths: changed },
    };
  });
  return result as unknown as ApplyResult;
}

// Read-only modes

export function frontierOf(records: Record<string, unknown>[], generation?: string): Record<string, unknown> {
  const scoped = generation === undefined ? records : records.filter((record) => record.generation === generation);
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
  if (target && fs.existsSync(target)) {
    try {
      const config = requireProjectionConfig(repoRoot);
      const closure = readGenerationClosure(repoRoot, config.active_generation);
      const state = generationStateOf(records, config.active_generation, closure);
      verifyProjectionText(fs.readFileSync(target, "utf8"), records, state);
    } catch (err) {
      problems.push((err as Error).message);
    }
  }
  return { status: problems.length === 0 ? "ok" : "drift", problems, record_count: records.length };
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
    const compactReplay = runCliRaw(["compact", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03", "--out", receiptOutRel]);
    check(compactReplay.status === 0 && String(JSON.parse(compactReplay.stdout).status) === "unchanged", "oracle", "compaction replay rewrote bytes");
    fs.writeFileSync(path.join(repo, closureRel), canonicalJson({ ...oracleClosure, tasks_digest: digestOf("stale-set") }) + "\n");
    cliFailHere("stale closure authority refuses compaction", ["compact", "--records", ".northstar/lifecycle/v1/tasks", "--generation", "g03", "--out", receiptOutRel], "stale or mismatched");
    ok("compaction consumes exact closure authority and replays without churn");

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
        const generation = config === null ? null : generationStateOf(records, config.active_generation, readGenerationClosure(repoRoot, config.active_generation));
        printJson({ status: "ok", records, generation, frontier: frontierOf(records, config?.active_generation) });
        return;
      }
      case "frontier": {
        const repoRoot = resolveRepoRoot(flags);
        const records = listRecords(repoRoot);
        const config = readProjectionConfig(repoRoot);
        check(config !== null || records.length === 0, "projection-config",
          TARGETS_CONFIG_REL + " is missing; lifecycle records exist but no active generation is declared");
        printJson(frontierOf(records, config?.active_generation));
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
        const state = generationStateOf(records, config.active_generation, readGenerationClosure(repoRoot, config.active_generation));
        const projection = buildProjection(records, state);
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
        printJson({ generation: flags.generation, tasks_digest: generationTasksDigest(records, flags.generation as string) });
        return;
      }
      case "compact": {
        check(typeof flags.records === "string" && typeof flags.generation === "string" && typeof flags.out === "string", "usage", "compact requires --records, --generation, and --out");
        const repoRoot = resolveRepoRoot(flags);
        const recordsDir = containRepoPath(repoRoot, flags.records as string);
        const out = containRepoPath(repoRoot, flags.out as string);
        const recordsAbs = path.resolve(repoRoot, recordsDir);
        check(fs.existsSync(recordsAbs) && fs.statSync(recordsAbs).isDirectory(), "containment", "records directory is missing or not a directory: " + recordsDir);
        assertRealContained(repoRoot, recordsAbs);
        const records = fs.readdirSync(recordsAbs).filter((name) => name.endsWith(".json")).sort()
          .map((name) => JSON.parse(fs.readFileSync(path.join(recordsAbs, name), "utf8")) as Record<string, unknown>);
        for (const record of records) verifyRecordIntegrity(record);
        const closurePath = generationClosurePath(repoRoot, flags.generation as string);
        const closure = readGenerationClosure(repoRoot, flags.generation as string);
        check(closure !== null, "compaction",
          "generation " + flags.generation + " has no closure record at " + path.relative(repoRoot, closurePath) + "; terminal records alone are not closure authority");
        const receipt = compactGeneration(records, flags.generation as string, closure as Record<string, unknown>);
        const outAbs = path.resolve(repoRoot, out);
        assertRealContained(repoRoot, fs.existsSync(outAbs) ? outAbs : path.dirname(outAbs));
        const bytes = canonicalJson(receipt) + "\n";
        const changed = !fs.existsSync(outAbs) || fs.readFileSync(outAbs, "utf8") !== bytes;
        if (changed) writeFileAtomic(outAbs, bytes);
        printJson({ status: changed ? "applied" : "unchanged", generation: flags.generation, changed_paths: changed ? [out] : [] });
        return;
      }
      default:
        printJson({
          status: "error",
          message: "usage: lifecycle-core.ts <oracle|schema-check|status|frontier|verify|apply|render|tasks-digest|compact> [flags]",
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
