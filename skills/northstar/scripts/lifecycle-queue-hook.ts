// Northstar repository hook adapter for Queue's generic repository events.
//
// Queue sends one closed `paseo.queue.event.v1` JSON object on stdin. This
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
// The closeout publication is exactly one integration commit: the terminal
// record, the regenerated declared projections, and the removal of the exact
// submitted instruction handoff. The handoff is a pinned transport artifact,
// not permanent evidence: the hook deletes only the exact committed path whose
// working-tree bytes still hash to the pinned blob digest, after the terminal
// receipt exists. A changed, missing, symlinked, or otherwise ambiguous
// handoff fails closed before any byte changes; Git retains the blob and the
// record's handoff evidence retains its identity. A repeated event is a
// no-diff replay.
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
  LifecycleError,
  applyEnvelope,
  canonicalJson,
  containRepoPath,
  digestBytes,
  discoverRepoRoot,
  parseTaskIdentity,
  readGenerationClosure,
  readProjectionConfig,
  readRecord,
  reduce,
  validateAgainstSchemaFile,
  verifyRecordIntegrity,
  type ReduceContext,
} from "./lifecycle-core.ts";

const RESULT_SCHEMA = "paseo.queue.hook-result.v1";
const EVENT_SCHEMA = "paseo.queue.event.v1";
const EVENT_TIMESTAMP_RE = /^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{3})?Z$/;
const GIT_ID_RE = /^[0-9a-f]{40}$|^[0-9a-f]{64}$/;
const TASK_PATH_RE = /^docs\/roadmaps\/g([0-9]{2})\/([0-9]{3})-[a-z0-9]+(?:-[a-z0-9]+)*\.md$/;
const TASK_LABEL_RE = /g[0-9]{2}\.[0-9]{3}/g;
const MANIFEST_MAX_BYTES = 64 * 1024;
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
  const manifestPath = path.join(repoRoot, ".paseo", "queue.json");
  if (!fs.existsSync(manifestPath)) refuse("control manifest .paseo/queue.json is missing from the integration worktree");
  const bytes = fs.readFileSync(manifestPath);
  if (bytes.length > MANIFEST_MAX_BYTES) refuse("control manifest exceeds the 64 KiB cap");
  let manifest: Record<string, any>;
  try {
    manifest = JSON.parse(bytes.toString("utf8"));
  } catch {
    refuse("control manifest is not valid JSON");
  }
  try {
    validateAgainstSchemaFile(manifest, path.join(SCHEMA_DIR, "queue-control.schema.json"));
  } catch (err) {
    if (err instanceof LifecycleError) refuse("control manifest is not a valid paseo.queue.control.v1 document: " + err.message);
    throw err;
  }
  const hooks = manifest.hooks as Record<string, any>[];
  const ids = new Set(hooks.map((hook) => hook.id));
  if (ids.size !== hooks.length) refuse("control manifest has duplicate hook ids");
  for (const hook of hooks) {
    if (hook.mode === "read_only" && (hook.allowedPaths as string[]).length > 0) refuse("read_only hook " + hook.id + " may not declare allowed paths");
    if (hook.mode === "read_only" && hook.commitSubject !== null && hook.commitSubject !== undefined) refuse("read_only hook " + hook.id + " may not declare a commit subject");
    if (hook.mode === "integration_write" && (hook.commitSubject === null || hook.commitSubject === undefined)) refuse("integration_write hook " + hook.id + " requires a commit subject");
    if ((hook.events as string[]).includes("task.pre_dispatch") && hook.mode !== "read_only") refuse("task.pre_dispatch accepts only read_only hooks");
    for (const allowed of hook.allowedPaths as string[]) {
      const normalized = allowed.endsWith("/")
        ? normalizeRepoRelative(allowed.slice(0, -1), "allowed path") + "/"
        : normalizeRepoRelative(allowed, "allowed path");
      if (normalized === ".git" || normalized.startsWith(".git/") || normalized === ".paseo" || normalized === ".paseo/hooks" || normalized.startsWith(".paseo/hooks/") || normalized === ".paseo/queue.json") {
        refuse("reserved path may not be declared in allowedPaths: " + allowed);
      }
    }
  }
  const binding = hooks.find((hook) => hook.id === event.hookId);
  if (binding === undefined) refuse("hook id " + event.hookId + " is not declared in the control manifest");
  if (!(binding.events as string[]).includes(event.event)) refuse("hook " + event.hookId + " does not bind event " + event.event);
  return {
    mode: binding.mode,
    allowedPaths: (binding.allowedPaths as string[]).map((allowed) =>
      allowed.endsWith("/") ? normalizeRepoRelative(allowed.slice(0, -1), "allowed path") + "/" : normalizeRepoRelative(allowed, "allowed path")),
    commitSubject: binding.commitSubject ?? null,
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

  // Candidates are roadmap links in the handoff whose link text is a task id.
  const candidates = new Map<string, string>();
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
  if (Buffer.byteLength(JSON.stringify(result.metadata), "utf8") > METADATA_MAX_BYTES) malfunction("hook metadata exceeds 32 KiB");
  process.stdout.write(canonicalJson(result) + "\n");
}

// ---------------------------------------------------------------------------
// Event handlers
// ---------------------------------------------------------------------------

function listRecordsSafe(repoRoot: string): Record<string, unknown>[] {
  const dir = path.join(repoRoot, RECORD_DIR, "tasks");
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir)
    .filter((name) => name.endsWith(".json") && !name.startsWith("."))
    .sort()
    .map((name) => JSON.parse(fs.readFileSync(path.join(dir, name), "utf8")) as Record<string, unknown>);
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
  // The v2 config is the single declared source of the active generation; a
  // missing or v1 config refuses here exactly as it does in the core, so the
  // hook never renders a projection whose generation state was guessed.
  const config = readProjectionConfig(repoRoot);
  if (config === null) refuse("projection targets config " + TARGETS_CONFIG + " is missing; it must declare the targets and the active generation");
  readGenerationClosure(repoRoot, config.active_generation);
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
): void {
  // Read-only runs validate without writing, so the allowedPaths gate for
  // computed writes does not apply; containment still holds.
  const targets = projectionTargets(repoRoot, identity, binding, binding.mode === "integration_write");
  if (binding.mode === "read_only") {
    const finalRecord = prePass(envelopes, current, reduceContext(repoRoot));
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

  const changedPaths: string[] = [];
  let replayed = true;
  for (const envelope of envelopes) {
    const applied = applyEnvelope({ repoRoot, envelope, branch: String(event.repository.baseBranch), targets });
    changedPaths.push(...applied.changed_paths);
    if (applied.status === "applied") replayed = false;
  }
  // The deletion runs only after the terminal record and projections are on
  // disk; a refusal anywhere above left the checkout untouched.
  consumeHandoff(consumable, changedPaths);
  const uniqueChanged = [...new Set(changedPaths)].sort();
  for (const changedPath of uniqueChanged) {
    if (!pathIsAllowed(changedPath, binding.allowedPaths)) refuse("computed change " + changedPath + " is outside the manifest allowedPaths");
  }
  const suffix = uniqueChanged.length > 0 ? subjectSuffix(identity, verb) : null;
  emit(String(event.eventId), "ok",
    (replayed ? "replayed without changes: " : "applied: ") + identity.taskId + " " + verb +
    " at revision " + String(finalRecord.revision) + " (" + String(finalRecord.portable_digest).slice(0, 19) + ")" +
    (consumable !== null ? "; consumed handoff " + consumable.relativePath : ""),
    {
      task_id: identity.taskId,
      revision: Number(finalRecord.revision),
      digest: String(finalRecord.digest),
      portable_digest: String(finalRecord.portable_digest),
      replayed,
      handoff_consumed: consumable !== null,
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

function handleCloseout(repoRoot: string, event: Record<string, any>, binding: ManifestBinding): void {
  const identity = reconstructIdentity(repoRoot, event);
  const current = readRecord(repoRoot, identity.taskId);
  if (current !== null && String(current.status) === "complete") {
    // Explicit idempotent rule: the terminal record exists, so a still-present
    // exact handoff is leftover transport from an earlier publication and its
    // consumption is a no-diff cleanup. A changed or ambiguous file still
    // refuses; absence is the normal replay shape.
    const consumable = binding.mode === "integration_write"
      ? prepareHandoffConsumption(repoRoot, event, binding, true)
      : null;
    const changedPaths: string[] = [];
    consumeHandoff(consumable, changedPaths);
    const uniqueChanged = [...new Set(changedPaths)].sort();
    emit(String(event.eventId), "ok",
      "lifecycle record for " + identity.taskId + " is already complete; no changes",
      { task_id: identity.taskId, replayed: true, portable_digest: String(current.portable_digest), handoff_consumed: consumable !== null },
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
  applyMapped(repoRoot, event, binding, identity, envelopes, current, "terminal record", consumable);
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
    validateAgainstSchemaFile(event, path.join(SCHEMA_DIR, "queue-event.schema.json"));
  } catch (err) {
    if (err instanceof LifecycleError) malfunction("event is not a valid " + EVENT_SCHEMA + " document: " + err.message);
    throw err;
  }

  // Queue sets these non-secret variables per execution; a mismatch means the
  // stdin payload and the execution environment disagree.
  if (process.env.PASEO_QUEUE_EVENT_ID !== String(event.eventId)) refuse("PASEO_QUEUE_EVENT_ID does not match the event payload");
  if (process.env.PASEO_QUEUE_EVENT_SCHEMA !== EVENT_SCHEMA) refuse("PASEO_QUEUE_EVENT_SCHEMA is not " + EVENT_SCHEMA);

  const repoRoot = discoverRepoRoot(String(event.repository.root));
  const binding = loadBinding(repoRoot, event);

  switch (String(event.event)) {
    case "task.pre_dispatch":
      handlePreDispatch(repoRoot, event);
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
  if (err instanceof LifecycleError) {
    emit(eventId, "failed", err.message, {}, [], null);
    return;
  }
  process.stderr.write("northstar lifecycle hook crashed: " + String((err as Error)?.message ?? err) + "\n");
  process.exitCode = 1;
});
