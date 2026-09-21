// Northstar repository hook adapter for Queue's generic repository events.
//
// Queue sends one closed `paseo.queue.event.v1`, `paseo.queue.event.v2`, or
// `paseo.queue.event.v3` JSON object on stdin. This
// adapter validates it against the committed frozen contract schema,
// reconstructs the exact Northstar task and planning identity from committed
// evidence, maps the supported generic events onto the same canonical
// transition envelopes the standalone adapter submits, and emits exactly one
// closed `paseo.queue.hook-result.v1` object on stdout.
//
// Queue metadata stays opaque and additive. Queue never learns Northstar
// paths, task IDs, commands, or Markdown structure: this file lives in the
// Northstar skill and parses only Northstar's own committed artifacts.
//
// Evidence honesty rules: provider facts (PR, review, validation) are
// recorded at `adapter_attested` exactly as Queue's gates accepted them; only
// Git-provable facts (blob identity, merge ancestry, synchronized
// integration base) are recorded `locally_verified`. Nothing upgrades an
// attestation. The bootstrap case reduces the canonical sequence from the
// reconstructed ready planning identity with derived stable event IDs; it
// never claims earlier live tracking. A repeated event is a no-diff replay.
//
// The reviewed-head pre-merge gate is read-only: it binds the pinned
// instruction artifact to the exact accepted PR head and runs the shared
// backlink resolver before merge, so a routine durable backlink returns to the
// retained worker through the ordinary PR revision loop. It changes no bytes.
//
// The closeout publication is exactly one integration commit: the terminal
// record, the regenerated declared projections, the removal of the exact
// submitted instruction handoff, and the convergence of the superseded
// adapter-owned `Status:` marker on the exact lifecycle-managed task path, so
// the repository ends with one lifecycle authority instead of two. The handoff
// is a pinned transport artifact,
// not permanent evidence: the hook deletes only the exact committed path whose
// working-tree bytes still hash to the pinned blob digest, after the terminal
// receipt exists. A changed, missing, symlinked, or otherwise ambiguous
// handoff fails closed before any byte changes; tracked durable Markdown that
// still links to the exact handoff refuses through the same shared resolver,
// so deletion never
// strands a backlink. Marker convergence refuses the same way: a symlinked or
// non-regular task path, a working-tree task file whose human-owned bytes no
// longer match the pinned planning blob outside its generated lifecycle
// block, an undeclared task path, or a status-looking line the
// shared core ownership test cannot attribute to the adapter's marker class
// blocks closeout before any byte changes. Before returning ok, the hook
// audits the complete prospective projection — every declared target
// regenerated over the final record set plus the converged task file — and a
// red currentness result blocks closeout with the exact file/section/task/
// reason findings. Git retains the blob and the record's handoff evidence
// retains its identity. A repeated event is a no-diff replay.
//
// The adapter never stages, commits, or pushes; Queue owns validated
// integration publication.

import { spawnSync } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";
import {
  BEGIN_PREFIX,
  ENVELOPE_SCHEMA,
  END_SENTINEL,
  LifecycleError,
  applyClosedGenerationCatchUp,
  applyEnvelope,
  auditCurrentness,
  auditCurrentnessText,
  buildProjectionStates,
  canonicalJson,
  convergeStatusMarkers,
  containRepoPath,
  digestBytes,
  discoverRepoRoot,
  generatedBlocks,
  generationStateOf,
  listStateRecords,
  parseTaskIdentity,
  planClosedGenerationCatchUp,
  readGenerationClosure,
  readProjectionConfig,
  readRecord,
  reduce,
  renderProjectionBlock,
  renderProjectionInto,
  scanStatusMarkers,
  stripGeneratedBlocks,
  validateAgainstSchemaFile,
  verifyRecordIntegrity,
  type CurrentnessViolation,
  type GenerationCompactionPlan,
  type ReduceContext,
} from "./lifecycle-core.ts";
import {
  BacklinkError,
  guardHandoffBacklinks,
} from "./lifecycle-backlink.ts";
import {
  ManifestError,
  loadControlManifest,
  type LoadedControlManifest,
} from "./lifecycle-manifest.ts";

const RESULT_SCHEMA = "paseo.queue.hook-result.v1";
const EVENT_SCHEMA = "paseo.queue.event.v1";
const EVENT_SCHEMA_V2 = "paseo.queue.event.v2";
const EVENT_SCHEMA_V3 = "paseo.queue.event.v3";
const EVENT_SCHEMAS: Record<string, string> = {
  [EVENT_SCHEMA]: "queue-event.schema.json",
  [EVENT_SCHEMA_V2]: "queue-event-v2.schema.json",
  [EVENT_SCHEMA_V3]: "queue-event-v3.schema.json",
};
const EVENT_TIMESTAMP_RE = /^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{3})?Z$/;
const GIT_ID_RE = /^[0-9a-f]{40}$|^[0-9a-f]{64}$/;
const CANDIDATE_ID_RE = /^[0-9a-f]{40}$/;
const TASK_PATH_RE = /^docs\/roadmaps\/g([0-9]{2})\/([0-9]{3})-[a-z0-9]+(?:-[a-z0-9]+)*\.md$/;
const TASK_LABEL_RE = /g[0-9]{2}\.[0-9]{3}/g;
const METADATA_MAX_BYTES = 32 * 1024;
const SUBJECT_BUDGET = 90; // manifest maxBytes 100 minus the "lifecycle " prefix
const RECORD_DIR = ".northstar/lifecycle/v1";
const TARGETS_CONFIG = RECORD_DIR + "/projection-targets.json";
const STAGE_ORDER = ["dispatch", "implementation", "review", "merge", "closeout"];

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const SCHEMA_DIR = path.resolve(SCRIPT_DIR, "..", "references", "lifecycle");

class HookOutcome extends Error {
  outcome: "blocked" | "failed";
  constructor(outcome: "blocked" | "failed", summary: string) {
    super(summary);
    this.name = "HookOutcome";
    this.outcome = outcome;
  }
}

function refuse(summary: string): never {
  throw new HookOutcome("blocked", summary);
}

function malfunction(summary: string): never {
  throw new HookOutcome("failed", summary);
}

// ---------------------------------------------------------------------------
// Git and repository helpers (no shell, literal argv only)
// ---------------------------------------------------------------------------

function git(args: string[], repoRoot: string): string {
  const result = spawnSync("git", args, { cwd: repoRoot, encoding: "utf8" });
  if (result.status !== 0) malfunction("git " + args.join(" ") + " failed: " + String(result.stderr || result.stdout).trim());
  return String(result.stdout).trim();
}

function gitOk(args: string[], repoRoot: string): boolean {
  return spawnSync("git", args, { cwd: repoRoot }).status === 0;
}

function gitBlob(repoRoot: string, commit: string, filePath: string): Buffer {
  const result = spawnSync("git", ["cat-file", "blob", commit + ":" + filePath], { cwd: repoRoot });
  if (result.status !== 0) refuse("blob " + filePath + " does not exist at commit " + commit);
  return result.stdout;
}

// A record path's committed bytes at HEAD, or null when HEAD does not carry
// the path.
function gitHeadBytes(repoRoot: string, filePath: string): string | null {
  const result = spawnSync("git", ["show", "HEAD:" + filePath], { cwd: repoRoot, encoding: "utf8" });
  return result.status === 0 ? String(result.stdout) : null;
}

function commitExists(repoRoot: string, id: string): boolean {
  return gitOk(["rev-parse", "--verify", "--quiet", id + "^{commit}"], repoRoot);
}

function isAncestor(repoRoot: string, ancestor: string, descendant: string): boolean {
  const result = spawnSync("git", ["merge-base", "--is-ancestor", ancestor, descendant], { cwd: repoRoot });
  if (result.status === 0) return true;
  if (result.status === 1) return false;
  malfunction("git merge-base failed for " + ancestor + " " + descendant);
}

// ---------------------------------------------------------------------------
// Closed manifest binding
// ---------------------------------------------------------------------------

interface ManifestBinding {
  mode: "read_only" | "integration_write";
  target: "integration_base" | "reviewed_head" | "prospective_merge";
  allowedPaths: string[];
  commitSubject: { prefix: string; maxBytes: number } | null;
}

function normalizeRepoRelative(value: string, what: string): string {
  if (value.startsWith("/") || value.includes("\\")) refuse(what + " must be repository-relative POSIX syntax: " + value);
  const segments = value.split("/");
  if (segments.some((segment) => segment === "" || segment === "." || segment === "..")) {
    refuse(what + " contains an empty, dot, or parent segment: " + value);
  }
  return value;
}

function loadBinding(repoRoot: string, event: Record<string, any>): ManifestBinding {
  // The shared import-safe loader is the only manifest parser: the hook and
  // the migration command must agree on the accepted frozen shape, including
  // the binding cross-rules the JSON schema cannot express.
  let loaded: LoadedControlManifest;
  try {
    loaded = loadControlManifest(repoRoot);
  } catch (err) {
    if (err instanceof ManifestError) refuse(err.message);
    throw err;
  }
  const binding = loaded.hooks.find((hook) => hook.id === event.hookId);
  if (binding === undefined) refuse("hook id " + event.hookId + " is not declared in the control manifest");
  if (!binding.events.includes(event.event)) refuse("hook " + event.hookId + " does not bind event " + event.event);
  return {
    mode: binding.mode,
    target: binding.target,
    allowedPaths: binding.allowedPaths,
    commitSubject: binding.commitSubject,
  };
}

function pathIsAllowed(relative: string, allowedPaths: string[]): boolean {
  return allowedPaths.some((entry) => (entry.endsWith("/") ? relative.startsWith(entry) : relative === entry));
}

// ---------------------------------------------------------------------------
// Northstar identity reconstruction from committed evidence
// ---------------------------------------------------------------------------

interface NorthstarIdentity {
  taskId: string;
  taskPath: string;
  generation: string;
  planningCommit: string;
  planningBlobDigest: string;
}

function reconstructIdentity(repoRoot: string, event: Record<string, any>): NorthstarIdentity {
  const instruction = event.task.instruction;
  if (instruction === null || instruction === undefined) refuse("event carries no committed instruction artifact");
  const instructionPath = normalizeRepoRelative(String(instruction.path), "instruction path");
  const instructionCommit = String(instruction.commit);
  const blob = gitBlob(repoRoot, instructionCommit, instructionPath);
  const blobDigest = digestBytes(blob);
  if (blobDigest !== instruction.digest) refuse("instruction artifact digest mismatch at " + instructionCommit + ":" + instructionPath);

  const text = blob.toString("utf8");
  const frontmatterEnd = text.indexOf("\n---", 1);
  const frontmatter = text.startsWith("---\n") ? text.slice(0, frontmatterEnd === -1 ? text.length : frontmatterEnd) : "";
  if (!frontmatter.includes("kind: northstar-handoff")) refuse("instruction artifact is not a Northstar handoff");

  // Candidates may be declared by the handoff's machine-readable `roadmap:`
  // field or by roadmap links whose link text is a task id. The frontmatter
  // form is the canonical handoff shape; links remain useful in prose.
  const candidates = new Map<string, string>();
  const roadmapField = /^roadmap:\s*([^\s#]+)\s*$/m.exec(frontmatter);
  if (roadmapField !== null) {
    const taskPath = normalizeRepoRelative(roadmapField[1]!, "roadmap path");
    const pathMatch = TASK_PATH_RE.exec(taskPath);
    if (pathMatch === null) refuse("handoff roadmap field is not a Northstar task path: " + taskPath);
    candidates.set("g" + pathMatch[1] + "." + pathMatch[2], taskPath);
  }
  const linkRe = /\[`?(g[0-9]{2}\.[0-9]{3})`?\]\(([^)\s]+)\)/g;
  let match: RegExpExecArray | null;
  while ((match = linkRe.exec(text)) !== null) {
    const target = match[2];
    if (!target.startsWith("..")) continue;
    const resolved = path.posix.normalize(path.posix.join(path.posix.dirname(instructionPath), target));
    if (!TASK_PATH_RE.test(resolved)) continue;
    if (!candidates.has(match[1])) candidates.set(match[1], resolved);
  }
  if (candidates.size === 0) refuse("handoff does not reference a Northstar roadmap task");

  // Prefer the candidate whose task id the Queue title names; fall back to a
  // unique candidate. Refuse ambiguity instead of guessing.
  const titleIds = new Set(String(event.task.title ?? "").match(TASK_LABEL_RE) ?? []);
  const titled = [...candidates.keys()].filter((id) => titleIds.has(id));
  let chosen: string;
  if (titled.length === 1) chosen = titled[0]!;
  else if (candidates.size === 1) chosen = [...candidates.keys()][0]!;
  else refuse("cannot uniquely determine the Northstar task identity from the handoff and title");

  const taskPath = candidates.get(chosen)!;
  const generation = "g" + TASK_PATH_RE.exec(taskPath)![1];
  parseTaskIdentity(chosen, taskPath, generation);

  // The planning identity is the most recent commit that touched the task
  // path, reachable from the pinned instruction commit. Both the planning
  // commit and the task blob digest are locally verified Git facts.
  const log = spawnSync("git", ["log", "-1", "--format=%H", instructionCommit, "--", taskPath], { cwd: repoRoot, encoding: "utf8" });
  if (log.status !== 0) malfunction("git log failed for " + taskPath);
  const planningCommit = String(log.stdout).trim();
  if (!GIT_ID_RE.test(planningCommit)) refuse("task path " + taskPath + " has no committed history at the instruction commit");
  const planningBlob = gitBlob(repoRoot, planningCommit, taskPath);
  return {
    taskId: chosen,
    taskPath,
    generation,
    planningCommit,
    planningBlobDigest: digestBytes(planningBlob),
  };
}

// ---------------------------------------------------------------------------
// Delivery evidence at preserved levels
// ---------------------------------------------------------------------------

function requireGitId(value: unknown, what: string): string {
  if (typeof value !== "string" || !GIT_ID_RE.test(value)) refuse("delivery object does not carry a usable " + what);
  return value;
}

function buildCloseoutEvidence(repoRoot: string, event: Record<string, any>, instructionPath: string): Record<string, unknown> {
  const occurredAt = String(event.occurredAt);
  if (!EVENT_TIMESTAMP_RE.test(occurredAt)) refuse("event time " + occurredAt + " is not lifecycle-compatible");
  const delivery = event.delivery;
  const head = requireGitId(delivery.head, "reviewed head");
  const mergeCommit = requireGitId(delivery.mergeCommit, "merge commit");
  const integrationCommit = requireGitId(delivery.integrationCommit, "integration commit");
  if (typeof delivery.prNumber !== "number") refuse("delivery object lacks a PR number for standard delivery");
  if (typeof delivery.review !== "string" || delivery.review.length === 0) refuse("delivery object lacks the accepted review identity");

  if (!commitExists(repoRoot, head)) refuse("reviewed head " + head + " is not present locally");
  if (!commitExists(repoRoot, mergeCommit)) refuse("merge commit " + mergeCommit + " is not present locally");
  if (!isAncestor(repoRoot, head, mergeCommit)) {
    refuse("merge commit " + mergeCommit + " does not contain the reviewed head in its ancestry; refusing to invent a merge method");
  }
  const headCommit = String(git(["rev-parse", "HEAD"], repoRoot));
  if (headCommit !== String(event.repository.baseCommit)) refuse("integration run is not at the declared base commit");
  if (headCommit !== integrationCommit) refuse("integration commit " + integrationCommit + " is not the checked-out base " + headCommit);

  const baseBranch = String(event.repository.baseBranch);
  return {
    // Provider facts stay attested: the hook position attests that Queue's
    // gates passed; it does not make provider state locally verified.
    pr: {
      level: "adapter_attested", source: "queue", actor: "queue", method: "delivery_object", recorded_at: occurredAt,
      head_commit: head, pr_number: delivery.prNumber,
      ...(typeof delivery.prUrl === "string" && delivery.prUrl.length > 0 ? { provider_ref: delivery.prUrl } : {}),
    },
    review: {
      level: "adapter_attested", source: "queue", actor: "queue", method: "delivery_object", recorded_at: occurredAt,
      verdict: "approved", head_commit: head, review_id: delivery.review,
    },
    // Git-provable facts are locally verified here.
    merge: {
      level: "locally_verified", source: "git", actor: "queue-hook", method: "merge_ancestry", recorded_at: occurredAt,
      merge_commit: mergeCommit, head_commit: head, base: baseBranch, merge_method: "merge",
    },
    integration: {
      level: "locally_verified", source: "git", actor: "queue-hook", method: "synchronized_main", recorded_at: occurredAt,
      synchronized_main_commit: integrationCommit,
    },
    validation: {
      level: "adapter_attested", source: "queue", actor: "queue", method: "verification_summary", recorded_at: occurredAt,
      passed: true, head_commit: head,
    },
    handoff: {
      level: "locally_verified", source: "docs", actor: "queue-hook", method: "instruction_blob_digest", recorded_at: occurredAt,
      ref: instructionPath,
    },
  };
}

// ---------------------------------------------------------------------------
// Envelope construction
// ---------------------------------------------------------------------------

function derivedEventId(eventId: string, seq: number, transition: string): string {
  const hash = digestBytes(Buffer.from(eventId, "utf8")).slice("sha256:".length, "sha256:".length + 32);
  const id = "queue-" + hash + "-" + String(seq).padStart(2, "0") + "-" + transition;
  if (id.length > 128) refuse("derived event id exceeds the lifecycle id budget");
  return id;
}

function baseEnvelope(identity: NorthstarIdentity, event: Record<string, any>, seq: number, transition: string, expected: { revision: number; digest: string | null }): Record<string, unknown> {
  return {
    schema_version: ENVELOPE_SCHEMA,
    event_id: derivedEventId(String(event.eventId), seq, transition),
    task_id: identity.taskId,
    task_path: identity.taskPath,
    generation: identity.generation,
    expected,
    transition,
    event_time: String(event.occurredAt),
    actor: "queue-hook",
    source: { adapter: "queue-hook", instance: String(event.task.id) },
    planning: { commit: identity.planningCommit, task_blob_digest: identity.planningBlobDigest },
  };
}

// Minimal legal sequence from the current committed state to a terminal
// receipt. Stage evidence attaches only where the reducer demands it.
function buildCloseoutEnvelopes(identity: NorthstarIdentity, event: Record<string, any>, evidence: Record<string, unknown>, current: Record<string, unknown> | null): Record<string, unknown>[] {
  const envelopes: Record<string, unknown>[] = [];
  let seq = 0;
  const push = (transition: string, extra: Record<string, unknown> = {}) => {
    seq += 1;
    envelopes.push({ ...baseEnvelope(identity, event, seq, transition, { revision: 0, digest: null }), ...extra });
  };

  let status = current === null ? "none" : String(current.status);
  let stage = current === null ? "none" : String(current.stage);
  if (status === "blocked") {
    push("resume");
    const block = current!.block as Record<string, unknown>;
    status = String(block.resume_status);
    stage = String(block.resume_stage);
  }
  if (status === "none") {
    push("plan");
    status = "planned";
  }
  if (status === "planned") {
    push("ready");
    status = "ready";
  }
  if (status === "ready") {
    push("start");
    status = "active";
    stage = "dispatch";
  }
  if (status === "active") {
    const upcoming = STAGE_ORDER.slice(STAGE_ORDER.indexOf(stage) + 1);
    for (const target of upcoming) {
      if (target === "review") push("advance_stage", { target_stage: "review", evidence: { pr: evidence.pr } });
      else if (target === "merge") push("advance_stage", { target_stage: "merge", evidence: { merge: evidence.merge, review: evidence.review } });
      else if (target === "closeout") push("advance_stage", { target_stage: "closeout", evidence: { merge: evidence.merge } });
      else push("advance_stage", { target_stage: target });
    }
    push("complete", { evidence });
  }
  return envelopes;
}

// ---------------------------------------------------------------------------
// Result plumbing
// ---------------------------------------------------------------------------

function bounded(text: string, maxBytes: number): string {
  const truncated = Buffer.from(text, "utf8").subarray(0, maxBytes).toString("utf8");
  return truncated.length > 0 ? truncated : "hook summary";
}

// The currentness audit reports whole file, section and task strings, which can
// be arbitrarily long in a large repository. The summary already carries the
// bounded human-readable detail, so metadata carries at most a truncated copy
// plus the true count. Keeping this bounded by construction is what stops a red
// audit from becoming a hook malfunction that no retry can clear.
const METADATA_VIOLATION_LIMIT = 8;
const METADATA_VIOLATION_FIELD_BYTES = 256;

function boundedViolations(violations: CurrentnessViolation[]): Record<string, unknown>[] {
  return violations.slice(0, METADATA_VIOLATION_LIMIT).map((violation) => ({
    file: bounded(violation.file, METADATA_VIOLATION_FIELD_BYTES),
    section: bounded(violation.section, METADATA_VIOLATION_FIELD_BYTES),
    task: bounded(violation.task, METADATA_VIOLATION_FIELD_BYTES),
    reason: violation.reason,
  }));
}

function currentnessMetadata(violations: CurrentnessViolation[], extra: Record<string, unknown>): Record<string, unknown> {
  return {
    ...extra,
    currentness_violations: boundedViolations(violations),
    currentness_violation_count: violations.length,
    currentness_violations_truncated: violations.length > METADATA_VIOLATION_LIMIT,
  };
}

function emit(eventId: string, outcome: "ok" | "blocked" | "failed", summary: string, metadata: Record<string, unknown>, changedPaths: string[], commitSubjectSuffix: string | null): void {
  const result = {
    schema: RESULT_SCHEMA,
    eventId: eventId.length > 0 ? eventId : "unknown",
    outcome,
    summary: bounded(summary, 4000),
    metadata,
    changedPaths: [...new Set(changedPaths)].sort(),
    commitSubjectSuffix,
  };
  try {
    validateAgainstSchemaFile(result, path.join(SCHEMA_DIR, "queue-result.schema.json"));
  } catch (err) {
    if (err instanceof LifecycleError) malfunction("hook result failed its own schema: " + err.message);
    throw err;
  }
  // Metadata is bounded by construction for the known-unbounded currentness
  // detail. This guard is the last-resort invariant: an unforeseen oversized
  // payload degrades to a correlation stub instead of a malfunction the caller
  // cannot retry past.
  if (Buffer.byteLength(JSON.stringify(result.metadata), "utf8") > METADATA_MAX_BYTES) {
    const stub: Record<string, unknown> = { metadata_truncated: true, metadata_limit_bytes: METADATA_MAX_BYTES };
    const taskId = (metadata as Record<string, unknown>).task_id;
    if (typeof taskId === "string") stub.task_id = taskId;
    result.metadata = stub;
  }
  process.stdout.write(canonicalJson(result) + "\n");
}

// ---------------------------------------------------------------------------
// Event handlers
// ---------------------------------------------------------------------------

function listRecordsSafe(repoRoot: string): Record<string, unknown>[] {
  // Closed-generation state is a valid compact receipt once its fragments are
  // consumed, so dependency resolution reads both shapes. Active generations
  // continue to resolve from their individual records.
  return listStateRecords(repoRoot);
}

function reduceContext(repoRoot: string): ReduceContext {
  const statuses: Record<string, string> = {};
  for (const record of listRecordsSafe(repoRoot)) statuses[String(record.task_id)] = String(record.status);
  return {
    dependencies: statuses,
    verifyCommit: (id: string) => commitExists(repoRoot, id),
    isAncestor: (ancestor: string, descendant: string) => isAncestor(repoRoot, ancestor, descendant),
  };
}

// Pre-pass the whole envelope chain through the pure reducer so any refusal
// happens before a single byte changes. The write pass then replays the same
// chain through the standalone adapter's locked CAS writer, which re-chains
// expected revisions from the real records.
function prePass(envelopes: Record<string, unknown>[], current: Record<string, unknown> | null, ctx: ReduceContext): Record<string, unknown> {
  let running = current;
  for (const envelope of envelopes) {
    envelope.expected = running === null
      ? { revision: 0, digest: null }
      : { revision: Number(running.revision), digest: String(running.digest) };
    running = reduce(envelope, running, ctx).record;
  }
  if (running !== null) verifyRecordIntegrity(running);
  return running as Record<string, unknown>;
}

function projectionTargets(repoRoot: string, identity: NorthstarIdentity, binding: ManifestBinding, enforceAllowed: boolean): string[] {
  // The v2 config is the single declared source of the active-generation set
  // (singular or parallel form); a missing or v1 config refuses here exactly
  // as it does in the core, so the hook never renders a projection whose
  // generation state was guessed. Every declared active generation is
  // closure-checked before any byte changes.
  const config = (() => {
    try {
      return readProjectionConfig(repoRoot);
    } catch (err) {
      // A malformed repository declaration is a repository defect, not a hook
      // malfunction: refuse it as blocked with the validator's exact message.
      if (err instanceof LifecycleError) refuse(err.message);
      throw err;
    }
  })();
  if (config === null) refuse("projection targets config " + TARGETS_CONFIG + " is missing; it must declare the targets and the active generation(s)");
  for (const generation of config.active_generations) {
    readGenerationClosure(repoRoot, generation);
  }
  // The declared set is the membership authority: a transition whose
  // generation is outside it refuses before any byte changes.
  if (!config.active_generations.includes(identity.generation)) {
    refuse("generation " + identity.generation + " is not in the declared active-generation set (" + config.active_generations.join(", ") + ")");
  }
  const targets: string[] = [];
  for (const declaredTarget of config.targets) {
    if (enforceAllowed && !pathIsAllowed(declaredTarget, binding.allowedPaths)) {
      refuse("projection target " + declaredTarget + " is not declared in the manifest allowedPaths");
    }
    targets.push(declaredTarget);
  }
  // A task file opts into currentness by already carrying a generated block.
  const taskAbs = path.join(repoRoot, identity.taskPath);
  if (fs.existsSync(taskAbs) && fs.readFileSync(taskAbs, "utf8").includes(BEGIN_PREFIX)) {
    if (enforceAllowed && !pathIsAllowed(identity.taskPath, binding.allowedPaths)) {
      refuse("task projection target " + identity.taskPath + " is not declared in the manifest allowedPaths");
    }
    targets.push(identity.taskPath);
  }
  return [...new Set(targets)];
}

function applyMapped(
  repoRoot: string,
  event: Record<string, any>,
  binding: ManifestBinding,
  identity: NorthstarIdentity,
  envelopes: Record<string, unknown>[],
  current: Record<string, unknown> | null,
  verb: string,
  consumable: ConsumableHandoff | null = null,
  catchUpClosedGenerations = false,
  convergence: StatusConvergence | null = null,
  prospectiveCurrentness = false,
): void {
  // Read-only runs validate without writing, so the allowedPaths gate for
  // computed writes does not apply; containment still holds.
  const targets = projectionTargets(repoRoot, identity, binding, binding.mode === "integration_write");
  if (binding.mode === "read_only") {
    const finalRecord = prePass(envelopes, current, reduceContext(repoRoot));
    if (prospectiveCurrentness) {
      const violations = prospectiveViolations(repoRoot, identity, finalRecord, convergence, targets);
      if (violations.length > 0) {
        emit(String(event.eventId), "blocked",
          "read-only closeout validation for " + identity.taskId + ": the prospective projection is not current: " + currentnessDetail(violations),
          currentnessMetadata(violations, { task_id: identity.taskId, mode: "read_only" }),
          [], null);
        return;
      }
    }
    emit(String(event.eventId), "ok",
      "read-only validation passed for " + identity.taskId + "; no bytes changed",
      { task_id: identity.taskId, mode: "read_only", validated: true, final_revision: Number(finalRecord.revision) },
      [], null);
    return;
  }
  const recordPath = containRepoPath(repoRoot, RECORD_DIR + "/tasks/" + identity.taskId + ".json");
  if (!pathIsAllowed(recordPath, binding.allowedPaths)) refuse("lifecycle record path is not declared in the manifest allowedPaths");

  // Pure pre-pass: refuse before any byte changes.
  const finalRecord = prePass(envelopes, current, reduceContext(repoRoot));

  // Chain-scoped record hygiene: a queued publication commits once at the
  // end, so envelopes after the first legitimately see the record dirty with
  // their own previous write. The strict per-envelope refusal stays in the
  // core for every ordinary caller. A record HEAD has never carried is a
  // prior standalone write being published for the first time; the envelope
  // CAS binds this chain to those exact bytes. A tracked record with a
  // different working-tree state, however, is tolerated only when it is an
  // exact state of THIS envelope chain — our own write, or the recoverable
  // leftover of an interrupted run of the same chain. Anything else,
  // including an independently modified canonical record, refuses before any
  // byte changes.
  const recordRelative = recordPath;
  const recordAbsolute = path.join(repoRoot, recordRelative);
  let diskBytes: string | null = null;
  if (fs.existsSync(recordAbsolute)) diskBytes = fs.readFileSync(recordAbsolute, "utf8");
  const committedBytes = gitHeadBytes(repoRoot, recordRelative);
  if (diskBytes !== committedBytes) {
    const tracked = spawnSync("git", ["ls-files", "--error-unmatch", "--", recordRelative], { cwd: repoRoot, encoding: "utf8" }).status === 0;
    if (tracked) {
      const ctx = reduceContext(repoRoot);
      const states: string[] = [committedBytes ?? ""];
      let running: Record<string, unknown> | null = committedBytes === null ? null : JSON.parse(committedBytes);
      for (const envelope of envelopes) {
        const chained = { ...envelope, expected: running === null ? { revision: 0, digest: null } : { revision: Number(running.revision), digest: String(running.digest) } };
        running = reduce(chained, running, ctx).record;
        states.push(canonicalJson(running) + "\n");
      }
      if (diskBytes === null || states.indexOf(diskBytes) <= 0) {
        refuse("record path " + recordRelative + " has uncommitted changes outside this closeout chain");
      }
    }
  }

  // The catch-up is planned read-only before the first write, so a repository
  // defect in any eligible closed generation refuses the whole closeout with
  // the checkout untouched, exactly like the envelope pre-pass.
  let catchUpPlan: GenerationCompactionPlan[] = [];
  if (catchUpClosedGenerations) catchUpPlan = planClosedGenerationCatchUp({ repoRoot });

  // Terminal closeout audits the complete prospective projection before the
  // first byte changes: a red currentness result refuses with the checkout
  // untouched instead of publishing a red repository.
  if (prospectiveCurrentness) {
    const violations = prospectiveViolations(repoRoot, identity, finalRecord, convergence, targets);
    if (violations.length > 0) {
      emit(String(event.eventId), "blocked",
        "closeout blocked for " + identity.taskId + ": the prospective projection is not current: " + currentnessDetail(violations),
        currentnessMetadata(violations, { task_id: identity.taskId }),
        [], null);
      return;
    }
  }

  const changedPaths: string[] = [];
  let replayed = true;
  for (const envelope of envelopes) {
    const applied = applyEnvelope({ repoRoot, envelope, branch: String(event.repository.baseBranch), targets, convergeTaskStatus: convergence !== null, skipRecordHygiene: true });
    changedPaths.push(...applied.changed_paths);
    if (applied.status === "applied") replayed = false;
  }
  // The deletion runs only after the terminal record and projections are on
  // disk; a refusal anywhere above left the checkout untouched.
  consumeHandoff(consumable, changedPaths);
  // Closeout also catches up every eligible historical closed generation in
  // the same integration write. The catch-up was planned read-only before the
  // first write, so an inconsistent generation refused before any byte
  // changed; its exact receipt and deletion paths join this result.
  let catchUpGenerations: string[] = [];
  let catchUpDeletions = 0;
  if (catchUpClosedGenerations) {
    const catchUp = applyClosedGenerationCatchUp(repoRoot, catchUpPlan);
    changedPaths.push(...catchUp.changed_paths);
    catchUpGenerations = catchUp.receipt_created;
    catchUpDeletions = catchUp.deleted.length;
  }
  const uniqueChanged = [...new Set(changedPaths)].sort();
  for (const changedPath of uniqueChanged) {
    if (!pathIsAllowed(changedPath, binding.allowedPaths)) refuse("computed change " + changedPath + " is outside the manifest allowedPaths");
  }

  // Ground-truth gate: the working tree is now the complete prospective
  // projection Queue would commit, so the same currentness audit runs over it
  // before the hook returns ok. A red result here means the pre-write
  // simulation and the published tree disagree; the closeout is held either
  // way.
  if (prospectiveCurrentness) {
    const finalAudit = (() => {
      try {
        return auditCurrentness(repoRoot);
      } catch (err) {
        if (err instanceof LifecycleError) refuse(err.message);
        throw err;
      }
    })();
    if (finalAudit.violations.length > 0) {
      emit(String(event.eventId), "blocked",
        "closeout blocked for " + identity.taskId + ": the published tree is not current: " + currentnessDetail(finalAudit.violations),
        currentnessMetadata(finalAudit.violations, { task_id: identity.taskId }),
        uniqueChanged, null);
      return;
    }
  }

  const suffix = uniqueChanged.length > 0 ? subjectSuffix(identity, verb) : null;
  emit(String(event.eventId), "ok",
    (replayed ? "replayed without changes: " : "applied: ") + identity.taskId + " " + verb +
    " at revision " + String(finalRecord.revision) + " (" + String(finalRecord.portable_digest).slice(0, 19) + ")" +
    (consumable !== null ? "; consumed handoff " + consumable.relativePath : "") +
    (convergence !== null ? "; converged task status marker" : "") +
    (catchUpGenerations.length > 0 ? "; compacted " + catchUpGenerations.join(", ") : ""),
    {
      task_id: identity.taskId,
      revision: Number(finalRecord.revision),
      digest: String(finalRecord.digest),
      portable_digest: String(finalRecord.portable_digest),
      replayed,
      handoff_consumed: consumable !== null,
      status_marker_converged: convergence !== null,
      generations_compacted: catchUpGenerations,
      fragments_consumed: catchUpDeletions,
    },
    uniqueChanged, suffix);
}

function subjectSuffix(identity: NorthstarIdentity, verb: string): string {
  const suffix = identity.taskId + " " + verb;
  if (suffix.length > SUBJECT_BUDGET) refuse("commit subject suffix exceeds the manifest budget");
  return suffix;
}

function blockedReason(event: Record<string, any>, fallback: string): string {
  const parts = [String(event.delivery?.summary ?? ""), String(event.task?.title ?? "")]
    .filter((part) => part.length > 0);
  return bounded(parts.join(" — ") || fallback, 500);
}

function handlePreDispatch(repoRoot: string, event: Record<string, any>): void {
  const identity = reconstructIdentity(repoRoot, event);
  const current = readRecord(repoRoot, identity.taskId);
  if (current !== null) {
    verifyRecordIntegrity(current);
    const planning = current.planning as Record<string, unknown>;
    if (planning.commit !== identity.planningCommit || planning.task_blob_digest !== identity.planningBlobDigest) {
      refuse("existing lifecycle record for " + identity.taskId + " carries a different planning identity than the committed task history");
    }
  }
  emit(String(event.eventId), "ok",
    "pre-dispatch gate verified instruction artifact and planning identity for " + identity.taskId,
    { task_id: identity.taskId, task_path: identity.taskPath, planning_commit: identity.planningCommit, record_exists: current !== null, mode: "read_only" },
    [], null);
}

// The pre-merge gate runs read-only at the exact accepted reviewed head. It
// binds the pinned instruction artifact to that head, then runs the same
// shared resolver closeout uses, so a durable Markdown backlink returns to the
// retained worker through the ordinary PR revision loop instead of surfacing
// after merge. It changes no bytes: no record, no projection, no index, no
// HEAD. A refusal carries no changed paths and no commit subject, which is the
// signal Queue routes as the next semantic revision finding.
function handlePreMerge(repoRoot: string, event: Record<string, any>, binding: ManifestBinding): void {
  if (binding.mode !== "read_only") malfunction("task.pre_merge binding is not read_only");
  if (binding.target === "prospective_merge") {
    handleProspectiveMerge(repoRoot, event, binding);
    return;
  }
  if (binding.target !== "reviewed_head") malfunction("task.pre_merge binding does not target the reviewed head");
  const repository = event.repository as Record<string, unknown>;
  if (repository.target !== "reviewed_head") malfunction("task.pre_merge event does not target the reviewed head");
  if (event.task.instruction === null || event.task.instruction === undefined) refuse("task.pre_merge requires the pinned instruction artifact");
  const identity = reconstructIdentity(repoRoot, event);
  const instructionPath = normalizeRepoRelative(String(event.task.instruction.path), "instruction path");
  const reviewedHead = String(repository.baseCommit);
  const head = String(git(["rev-parse", "HEAD"], repoRoot));
  if (head !== reviewedHead) malfunction("retained workspace HEAD " + head + " is not the declared reviewed head " + reviewedHead);
  const deliveryHead = event.delivery.head;
  if (deliveryHead !== null && deliveryHead !== undefined && String(deliveryHead) !== reviewedHead) {
    malfunction("delivery head " + String(deliveryHead) + " is not the declared reviewed head " + reviewedHead);
  }
  verifyReviewedHeadHandoff(repoRoot, event, instructionPath, reviewedHead);
  guardHandoffBacklinks(repoRoot, instructionPath);
  emit(String(event.eventId), "ok",
    "pre-merge gate found no durable Markdown backlink to " + instructionPath + " for " + identity.taskId,
    { task_id: identity.taskId, task_path: identity.taskPath, handoff: instructionPath, reviewed_head: reviewedHead, mode: "read_only", backlinks: 0 },
    [], null);
}

function requireCandidateId(value: unknown, what: string): string {
  if (typeof value !== "string" || !CANDIDATE_ID_RE.test(value)) refuse("merge candidate does not carry a usable 40-hex " + what);
  return value;
}

// The prospective-merge gate runs read-only in the Queue-owned candidate
// checkout. It proves the declared candidate identity locally — checkout HEAD
// and tree equal the candidate commit and tree, the repository base equals
// the integration base, the delivery head equals the reviewed head, and the
// candidate's two parents are base then head — then reuses the same pinned
// instruction proof and shared backlink resolver as the reviewed-head gate.
// It changes no bytes: no record, no projection, no index, no HEAD. A refusal
// carries no changed paths and no commit subject, which is the signal Queue
// routes as the next semantic revision finding.
function handleProspectiveMerge(repoRoot: string, event: Record<string, any>, binding: ManifestBinding): void {
  if (binding.mode !== "read_only") malfunction("task.pre_merge binding is not read_only");
  if (String(event.schema) !== EVENT_SCHEMA_V3) refuse("prospective_merge requires event schema " + EVENT_SCHEMA_V3);
  const repository = event.repository as Record<string, unknown>;
  if (repository.target !== "prospective_merge") malfunction("task.pre_merge event does not target prospective_merge");
  if (event.task.instruction === null || event.task.instruction === undefined) refuse("task.pre_merge requires the pinned instruction artifact");
  const candidate = repository.mergeCandidate as Record<string, unknown> | null | undefined;
  if (candidate === null || candidate === undefined || typeof candidate !== "object") refuse("prospective_merge requires the closed mergeCandidate");
  const integrationBase = requireCandidateId(candidate.integrationBase, "integration base");
  const reviewedHead = requireCandidateId(candidate.reviewedHead, "reviewed head");
  const candidateCommit = requireCandidateId(candidate.commit, "candidate commit");
  const candidateTree = requireCandidateId(candidate.tree, "candidate tree");
  if (!commitExists(repoRoot, candidateCommit)) refuse("candidate commit " + candidateCommit + " is not present locally");
  const identity = reconstructIdentity(repoRoot, event);
  const instructionPath = normalizeRepoRelative(String(event.task.instruction.path), "instruction path");
  const head = String(git(["rev-parse", "HEAD"], repoRoot));
  if (head !== candidateCommit) malfunction("candidate checkout HEAD " + head + " is not the declared candidate commit " + candidateCommit);
  const tree = String(git(["rev-parse", "HEAD^{tree}"], repoRoot));
  if (tree !== candidateTree) malfunction("candidate checkout tree " + tree + " is not the declared candidate tree " + candidateTree);
  if (String(repository.baseCommit) !== integrationBase) malfunction("repository base " + String(repository.baseCommit) + " is not the declared integration base " + integrationBase);
  const deliveryHead = event.delivery.head;
  if (deliveryHead === null || deliveryHead === undefined) refuse("prospective_merge requires the delivery head");
  if (String(deliveryHead) !== reviewedHead) {
    malfunction("delivery head " + String(deliveryHead) + " is not the declared reviewed head " + reviewedHead);
  }
  const parents = String(git(["log", "-1", "--format=%P", candidateCommit], repoRoot)).split(" ").filter((parent) => parent.length > 0);
  if (parents.length !== 2 || parents[0] !== integrationBase || parents[1] !== reviewedHead) {
    refuse("candidate commit " + candidateCommit + " does not carry the integration base and reviewed head as its parents in order");
  }
  verifyReviewedHeadHandoff(repoRoot, event, instructionPath, candidateCommit);
  guardHandoffBacklinks(repoRoot, instructionPath);
  emit(String(event.eventId), "ok",
    "prospective-merge gate found no durable Markdown backlink to " + instructionPath + " for " + identity.taskId,
    { task_id: identity.taskId, task_path: identity.taskPath, handoff: instructionPath, target: "prospective_merge", candidate_commit: candidateCommit, candidate_tree: candidateTree, integration_base: integrationBase, reviewed_head: reviewedHead, mode: "read_only", backlinks: 0 },
    [], null);
}

function handleBlocked(repoRoot: string, event: Record<string, any>, binding: ManifestBinding): void {
  const identity = reconstructIdentity(repoRoot, event);
  const current = readRecord(repoRoot, identity.taskId);
  if (current === null) {
    emit(String(event.eventId), "ok",
      "no lifecycle record for " + identity.taskId + "; durable block state remains in Queue only",
      { task_id: identity.taskId, skipped: "no_record" }, [], null);
    return;
  }
  if (String(current.status) === "blocked") {
    emit(String(event.eventId), "ok", "record for " + identity.taskId + " is already blocked",
      { task_id: identity.taskId, skipped: "already_blocked" }, [], null);
    return;
  }
  if (["complete", "cancelled", "superseded"].includes(String(current.status))) {
    emit(String(event.eventId), "ok", "record for " + identity.taskId + " is already terminal",
      { task_id: identity.taskId, skipped: "already_terminal" }, [], null);
    return;
  }
  const envelope = {
    ...baseEnvelope(identity, event, 1, "block", { revision: Number(current.revision), digest: String(current.digest) }),
    reason_code: "queue_reported",
    reason: blockedReason(event, "queue reported a blocked task"),
  };
  applyMapped(repoRoot, event, binding, identity, [envelope], current, "blocked");
}

function handleCancelled(repoRoot: string, event: Record<string, any>, binding: ManifestBinding): void {
  const identity = reconstructIdentity(repoRoot, event);
  const current = readRecord(repoRoot, identity.taskId);
  if (current === null) {
    emit(String(event.eventId), "ok",
      "no lifecycle record for " + identity.taskId + "; durable cancellation remains in Queue only",
      { task_id: identity.taskId, skipped: "no_record" }, [], null);
    return;
  }
  if (["complete", "cancelled", "superseded"].includes(String(current.status))) {
    emit(String(event.eventId), "ok", "record for " + identity.taskId + " is already terminal",
      { task_id: identity.taskId, skipped: "already_terminal" }, [], null);
    return;
  }
  const envelope = {
    ...baseEnvelope(identity, event, 1, "cancel", { revision: Number(current.revision), digest: String(current.digest) }),
    reason: blockedReason(event, "queue reported cancellation"),
  };
  applyMapped(repoRoot, event, binding, identity, [envelope], current, "cancelled");
}

// ---------------------------------------------------------------------------
// Exact handoff consumption
// ---------------------------------------------------------------------------

interface ConsumableHandoff {
  relativePath: string;
  absolutePath: string;
}
// Verify, before any byte changes, that the exact submitted handoff can be
// consumed at publication time. The event pins the instruction path, commit,
// and blob digest; the integration checkout must still carry that exact file.
// Missing is lawful only under the explicit idempotent replay rule (the
// terminal record already exists and an earlier publication consumed the
// file), which the caller declares with allowMissing.
function prepareHandoffConsumption(repoRoot: string, event: Record<string, any>, binding: ManifestBinding, allowMissing: boolean): ConsumableHandoff | null {
  const instruction = event.task.instruction;
  if (instruction === null || instruction === undefined) return null;
  const relativePath = normalizeRepoRelative(String(instruction.path), "instruction path");
  const absolutePath = path.join(repoRoot, relativePath);
  let stats: fs.Stats;
  try {
    stats = fs.lstatSync(absolutePath);
  } catch {
    if (allowMissing) return null;
    refuse("submitted handoff " + relativePath + " is missing from the integration checkout");
  }
  if (stats.isSymbolicLink()) refuse("submitted handoff " + relativePath + " is a symlink; refusing an ambiguous deletion");
  if (!stats.isFile()) refuse("submitted handoff " + relativePath + " is not a regular file");
  const digest = digestBytes(fs.readFileSync(absolutePath));
  if (digest !== String(instruction.digest)) {
    refuse("submitted handoff " + relativePath + " changed since its pinned instruction blob (" + digest + " != " + String(instruction.digest) + ")");
  }
  if (!pathIsAllowed(relativePath, binding.allowedPaths)) {
    refuse("submitted handoff " + relativePath + " is not declared in the manifest allowedPaths");
  }
  return { relativePath, absolutePath };
}

function consumeHandoff(consumable: ConsumableHandoff | null, changedPaths: string[]): void {
  if (consumable === null) return;
  fs.unlinkSync(consumable.absolutePath);
  changedPaths.push(consumable.relativePath);
}

// Prove, read-only, that the reviewed head still carries the exact pinned
// handoff. The pre-merge gate reads the blob at the declared reviewed head
// rather than the working tree, so the proof does not depend on checkout
// cleanliness; a missing or changed artifact refuses before the resolver runs.
function verifyReviewedHeadHandoff(repoRoot: string, event: Record<string, any>, handoffRel: string, reviewedHead: string): void {
  const blob = gitBlob(repoRoot, reviewedHead, handoffRel);
  const digest = digestBytes(blob);
  if (digest !== String(event.task.instruction.digest)) {
    refuse("submitted handoff " + handoffRel + " at the reviewed head " + reviewedHead + " changed since its pinned instruction blob (" + digest + " != " + String(event.task.instruction.digest) + ")");
  }
}

// A null consumable deletes nothing, so the shared backlink guard (the same
// resolver the pre-merge gate runs) does not apply.
function guardConsumableBacklinks(repoRoot: string, consumable: ConsumableHandoff | null): void {
  if (consumable === null) return;
  guardHandoffBacklinks(repoRoot, consumable.relativePath);
}

// ---------------------------------------------------------------------------
// Terminal status-marker convergence
// ---------------------------------------------------------------------------

interface StatusConvergence {
  relativePath: string;
  absolutePath: string;
  nextText: string;
  removed: number;
}

// The canonical generated block for the current lifecycle records, or null
// when the repository declares no projection configuration. Block provenance
// compares committed task-file blocks against this render, so a block is
// adapter-owned only when it is the exact deterministic projection of the
// records the repository actually carries.
function canonicalProjectionBlock(repoRoot: string): string | null {
  const config = (() => {
    try {
      return readProjectionConfig(repoRoot);
    } catch (err) {
      if (err instanceof LifecycleError) refuse(err.message);
      throw err;
    }
  })();
  if (config === null) return null;
  const records = listStateRecords(repoRoot);
  const states = config.active_generations.map((generation) =>
    generationStateOf(records, generation, readGenerationClosure(repoRoot, generation)));
  return renderProjectionBlock(buildProjectionStates(records, states));
}

// Whether the working-tree task file still carries the pinned planning
// bytes. The caller pins the tree to HEAD first, so committed state is what
// is compared: over the audit's own generated-block stripping, exactly, with
// one lawful difference — a first generated-block insertion, where the
// renderer writes `<bytes><block>\n` (adding one newline first when the file
// lacked a final newline). Stripping the block therefore leaves exactly one
// trailing newline — two in that no-final-newline case — and any other
// outside-block byte difference, including any other trailing-newline drift,
// is an unreported edit.
function proseIdentityMatches(blobText: string, committedText: string): boolean {
  const blobProse = stripGeneratedBlocks(blobText);
  const committedProse = stripGeneratedBlocks(committedText);
  if (committedProse === blobProse) return true;
  const committed = committedText.replace(/\r\n/g, "\n");
  const blockAtEnd = committed.endsWith(END_SENTINEL + "\n") || committed.endsWith(END_SENTINEL);
  if (!blockAtEnd) return false;
  const blob = blobText.replace(/\r\n/g, "\n");
  if (blob.endsWith("\n")) return committedProse === blobProse + "\n";
  return committedProse === blobProse + "\n\n";
}

// Prepare, read-only, the removal of the superseded adapter-owned `Status:`
// marker on the exact lifecycle-managed task path, so terminal closeout
// publishes one lifecycle authority instead of leaving a second one beside
// the generated projection. Refusal beats removal: the task path must be a
// regular non-symlink file declared in the manifest allowedPaths before any
// marker byte changes, and every status-looking line must be attributable to
// the adapter's marker class through the shared core ownership test. Before
// an accepted publication the integration checkout must carry the task file
// exactly as HEAD committed it, and the committed human-owned planning bytes
// must still match the pinned planning blob over the audit's own block
// stripping — an earlier lifecycle write that regenerated the block is the
// one lawful difference; on the replay cleanup path each marker line removed
// must exist, byte for byte and section for section, in the pinned planning
// blob. Anything else refuses with bounded diagnostics. A task file with no
// marker plans nothing; a missing task file plans nothing and the currentness
// audit owns that finding.
function prepareStatusConvergence(repoRoot: string, identity: NorthstarIdentity, binding: ManifestBinding, published: boolean): StatusConvergence | null {
  const relativePath = identity.taskPath;
  const absolutePath = path.join(repoRoot, containRepoPath(repoRoot, relativePath));
  let stats: fs.Stats;
  try {
    stats = fs.lstatSync(absolutePath);
  } catch {
    return null;
  }
  if (stats.isSymbolicLink()) refuse("task path " + relativePath + " is a symlink; refusing an ambiguous marker convergence");
  if (!stats.isFile()) refuse("task path " + relativePath + " is not a regular file");
  const bytes = fs.readFileSync(absolutePath);
  const treeText = bytes.toString("utf8");
  const scan = scanStatusMarkers(treeText);
  if (scan.ambiguous.length > 0) {
    const first = scan.ambiguous[0]!;
    refuse("status-looking line in " + relativePath + " under section \"" + first.section +
      "\" cannot be attributed to the adapter's Status marker; refusing rather than removing possible human prose");
  }
  // One generated authority per task file: every per-block check below
  // validates blocks independently, identical blocks pass them all, the
  // block-stripped prose comparison erases the difference, the audit strips
  // both, and the closeout render replaces only the first range — so a
  // second block would publish a second generated authority. The expected
  // shape is exactly one complete generated block, or none before the task
  // file opts in; renderProjectionInto replaces that one range in place.
  const taskBlocks = generatedBlocks(treeText);
  if (taskBlocks.length > 1) {
    refuse("task path " + relativePath + " carries " + taskBlocks.length + " generated lifecycle blocks; a task file publishes one generated authority and an extra block is a second one");
  }
  if (published) {
    // Replay cleanup may remove a leftover marker only from a task file that
    // is byte-identical to HEAD: the publication's own convergence output is
    // the one lawful uncommitted difference, and it carries no marker, so a
    // leftover marker with any other uncommitted byte beside it is an
    // unreported mutation, not a no-diff cleanup.
    if (scan.owned.length > 0) {
      const headText = gitHeadBytes(repoRoot, relativePath);
      if (headText === null || treeText !== headText) {
        refuse("task path " + relativePath + " has uncommitted changes outside this publication's convergence; refusing an unreported task-file mutation");
      }
      const blobText = gitBlob(repoRoot, identity.planningCommit, relativePath).toString("utf8");
      const pinnedScan = scanStatusMarkers(blobText);
      for (const marker of scan.owned) {
        if (!pinnedScan.owned.some((pinned) => pinned.line === marker.line && pinned.section === marker.section)) {
          refuse("task path " + relativePath + " carries a Status marker its pinned planning blob does not own; refusing an unreported task-file mutation");
        }
      }
    }
  } else {
    // Fresh publication: the integration checkout must carry the task file
    // exactly as HEAD committed it. Every lawful task-file write — including
    // a lifecycle write that regenerated the generated projection block — is
    // committed before closeout runs, so any uncommitted difference here is
    // an unreported mutation, inside the block sentinels or out. This is what
    // keeps a hand-edited block interior from passing the block-stripped
    // identity comparison below and being silently overwritten by the
    // closeout render.
    const headBytes = gitHeadBytes(repoRoot, relativePath);
    if (headBytes === null || headBytes !== treeText) {
      refuse("task path " + relativePath + " has uncommitted changes in the integration checkout; refusing an unreported task-file mutation");
    }
    // Every generated block in the committed file must be adapter-owned:
    // byte-identical to the pinned planning blob's own block, or exactly the
    // canonical projection of the current lifecycle records. A committed
    // forged or altered block is not lawful adapter state, however equal the
    // block-stripped prose looks.
    if (generatedBlocks(headBytes).length > 0) {
      const blobBlocks = generatedBlocks(gitBlob(repoRoot, identity.planningCommit, relativePath).toString("utf8"));
      const canonical = canonicalProjectionBlock(repoRoot);
      for (const block of generatedBlocks(headBytes)) {
        if (blobBlocks.includes(block)) continue;
        if (canonical !== null && block === canonical) continue;
        refuse("task path " + relativePath + " carries a generated lifecycle block that is neither its pinned planning blob's block nor the canonical projection of the current lifecycle records; refusing an unreported task-file mutation");
      }
    }
    // The committed human-authored planning bytes must still be exact: a
    // committed lifecycle write that regenerated the generated projection
    // block is the one lawful difference from the pinned planning blob; any
    // committed edit outside the sentinels is an unreported mutation.
    const blobText = gitBlob(repoRoot, identity.planningCommit, relativePath).toString("utf8");
    if (!proseIdentityMatches(blobText, headBytes)) {
      refuse("task path " + relativePath + " changed outside its generated lifecycle block since its pinned planning blob; refusing an unreported task-file mutation");
    }
  }
  if (scan.owned.length === 0) return null;
  if (!pathIsAllowed(relativePath, binding.allowedPaths)) {
    refuse("task path " + relativePath + " carries a superseded Status marker but is not declared in the manifest allowedPaths");
  }
  return { relativePath, absolutePath, nextText: convergeStatusMarkers(treeText).text, removed: scan.owned.length };
}

// Apply a planned convergence as part of the closeout write phase, after the
// terminal record and projections exist on disk.
function applyStatusConvergence(convergence: StatusConvergence | null, changedPaths: string[]): void {
  if (convergence === null) return;
  fs.writeFileSync(convergence.absolutePath, convergence.nextText);
  changedPaths.push(convergence.relativePath);
}

function declaredTargets(repoRoot: string): string[] {
  try {
    const config = readProjectionConfig(repoRoot);
    return config === null ? [] : [...config.targets];
  } catch (err) {
    if (err instanceof LifecycleError) refuse(err.message);
    throw err;
  }
}

// The complete prospective projection: every declared target regenerated over
// the final record set, plus the task file with the planned marker convergence
// applied. Audited with the same pure structural audit the standalone
// currentness command runs, so a red result carries the exact
// file/section/task/reason diagnostics without guessing.
function prospectiveViolations(
  repoRoot: string,
  identity: NorthstarIdentity,
  finalRecord: Record<string, unknown>,
  convergence: StatusConvergence | null,
  targets: string[],
): CurrentnessViolation[] {
  const config = (() => {
    try {
      return readProjectionConfig(repoRoot);
    } catch (err) {
      if (err instanceof LifecycleError) refuse(err.message);
      throw err;
    }
  })();
  const merged = listStateRecords(repoRoot)
    .filter((record) => String(record.task_id) !== identity.taskId)
    .concat([finalRecord]);
  const wanted = new Set<string>(targets);
  for (const record of merged) {
    if (typeof record.task_path === "string" && record.task_path.length > 0) wanted.add(String(record.task_path));
  }
  const states = config === null ? [] : config.active_generations.map((generation) =>
    generationStateOf(merged, generation, readGenerationClosure(repoRoot, generation)));
  const files: Record<string, string> = {};
  for (const relative of wanted) {
    const absolute = path.join(repoRoot, relative);
    let stats: fs.Stats;
    try {
      stats = fs.lstatSync(absolute);
    } catch {
      continue;
    }
    if (stats.isSymbolicLink() || !stats.isFile()) continue;
    let text = fs.readFileSync(absolute, "utf8");
    if (text.length > 1024 * 1024) continue; // the repository audit owns the read-bound refusal
    if (config !== null && targets.includes(relative)) {
      text = renderProjectionInto(text, buildProjectionStates(merged, states)).text;
    }
    if (relative === identity.taskPath && convergence !== null) text = convergence.nextText;
    files[relative] = text;
  }
  return auditCurrentnessText(files, merged, targets);
}

function currentnessDetail(violations: CurrentnessViolation[]): string {
  const details = violations.slice(0, 8).map((v) =>
    v.file + " [" + v.section + "] task " + (v.task.length > 0 ? v.task : "-") + ": " + v.reason);
  const suffix = violations.length > 8 ? "; +" + (violations.length - 8) + " more" : "";
  return details.join("; ") + suffix;
}

function handleCloseout(repoRoot: string, event: Record<string, any>, binding: ManifestBinding): void {
  const identity = reconstructIdentity(repoRoot, event);
  const current = readRecord(repoRoot, identity.taskId);
  if (current !== null && String(current.status) === "complete") {
    // Explicit idempotent rule: the terminal record exists, so a still-present
    // exact handoff is leftover transport from an earlier publication and its
    // consumption is a no-diff cleanup. A leftover superseded status marker is
    // the same class of leftover publication byte. A changed or ambiguous file
    // still refuses; absence is the normal replay shape.
    const consumable = binding.mode === "integration_write"
      ? prepareHandoffConsumption(repoRoot, event, binding, true)
      : null;
    const convergence = prepareStatusConvergence(repoRoot, identity, binding, true);
    guardConsumableBacklinks(repoRoot, consumable);
    // The replay leaves at most those two no-diff cleanups, so the complete
    // prospective projection is audited before either is consumed; a red
    // currentness result refuses with the checkout untouched.
    const violations = prospectiveViolations(repoRoot, identity, current, convergence, declaredTargets(repoRoot));
    if (violations.length > 0) {
      emit(String(event.eventId), "blocked",
        "closeout replay blocked for " + identity.taskId + ": the prospective projection is not current: " + currentnessDetail(violations),
        currentnessMetadata(violations, { task_id: identity.taskId, replayed: true }),
        [], null);
      return;
    }
    const changedPaths: string[] = [];
    consumeHandoff(consumable, changedPaths);
    if (binding.mode === "integration_write") applyStatusConvergence(convergence, changedPaths);
    const uniqueChanged = [...new Set(changedPaths)].sort();
    for (const changedPath of uniqueChanged) {
      if (!pathIsAllowed(changedPath, binding.allowedPaths)) refuse("computed change " + changedPath + " is outside the manifest allowedPaths");
    }
    emit(String(event.eventId), "ok",
      "lifecycle record for " + identity.taskId + " is already complete" +
        (uniqueChanged.length > 0 ? "; consumed leftover publication bytes as a no-diff cleanup" : "; no changes"),
      { task_id: identity.taskId, replayed: true, portable_digest: String(current.portable_digest), handoff_consumed: consumable !== null, status_marker_converged: convergence !== null },
      uniqueChanged, uniqueChanged.length > 0 ? subjectSuffix(identity, "terminal record") : null);
    return;
  }
  if (current !== null && ["cancelled", "superseded"].includes(String(current.status))) {
    refuse("lifecycle record for " + identity.taskId + " is " + String(current.status) + " but Queue reports a merged closeout");
  }

  const instructionPath = normalizeRepoRelative(String(event.task.instruction.path), "instruction path");
  const evidence = buildCloseoutEvidence(repoRoot, event, instructionPath);
  const envelopes = buildCloseoutEnvelopes(identity, event, evidence, current);
  // Missing-at-base fails closed for a non-terminal record: the hook deletes
  // only the exact pinned file it verified, never a guessed path.
  const consumable = binding.mode === "integration_write"
    ? prepareHandoffConsumption(repoRoot, event, binding, false)
    : null;
  const convergence = prepareStatusConvergence(repoRoot, identity, binding, false);
  guardConsumableBacklinks(repoRoot, consumable);
  applyMapped(repoRoot, event, binding, identity, envelopes, current, "terminal record", consumable, true, convergence, true);
}

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

async function main(): Promise<void> {
  let input: string;
  try {
    input = fs.readFileSync(0, "utf8");
  } catch {
    malfunction("hook could not read the event from stdin");
  }
  let event: Record<string, any>;
  try {
    event = JSON.parse(input);
  } catch {
    malfunction("event input is not valid JSON");
  }
  try {
    const eventSchemaName = String(event.schema ?? "");
    const eventSchemaFile = EVENT_SCHEMAS[eventSchemaName] ?? null;
    if (eventSchemaFile === null) malfunction("event declares unsupported schema " + JSON.stringify(eventSchemaName));
    validateAgainstSchemaFile(event, path.join(SCHEMA_DIR, eventSchemaFile));
  } catch (err) {
    if (err instanceof LifecycleError) malfunction("event is not a valid " + String(event.schema) + " document: " + err.message);
    throw err;
  }

  // Queue sets these non-secret variables per execution; a mismatch means the
  // stdin payload and the execution environment disagree.
  if (process.env.PASEO_QUEUE_EVENT_ID !== String(event.eventId)) refuse("PASEO_QUEUE_EVENT_ID does not match the event payload");
  if (process.env.PASEO_QUEUE_EVENT_SCHEMA !== String(event.schema)) refuse("PASEO_QUEUE_EVENT_SCHEMA is not " + String(event.schema));

  const repoRoot = discoverRepoRoot(String(event.repository.root));
  const binding = loadBinding(repoRoot, event);

  switch (String(event.event)) {
    case "task.pre_dispatch":
      handlePreDispatch(repoRoot, event);
      return;
    case "task.pre_merge":
      handlePreMerge(repoRoot, event, binding);
      return;
    case "task.blocked":
      handleBlocked(repoRoot, event, binding);
      return;
    case "task.cancelled":
      handleCancelled(repoRoot, event, binding);
      return;
    case "task.closeout":
      handleCloseout(repoRoot, event, binding);
      return;
    default:
      refuse("unsupported event " + String(event.event));
  }
}

main().catch((err) => {
  const eventId = process.env.PASEO_QUEUE_EVENT_ID ?? "";
  if (err instanceof HookOutcome) {
    emit(eventId, err.outcome, err.message, {}, [], null);
    return;
  }
  if (err instanceof BacklinkError) {
    emit(eventId, err.outcome, err.message, {}, [], null);
    return;
  }
  if (err instanceof LifecycleError) {
    emit(eventId, "failed", err.message, {}, [], null);
    return;
  }
  process.stderr.write("northstar lifecycle hook crashed: " + String((err as Error)?.message ?? err) + "\n");
  process.exitCode = 1;
});
