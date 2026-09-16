// Bounded migration of an existing conforming Queue control manifest from the
// v3 reviewed-head binding to the v4 prospective-merge default.
//
// This command is deliberately narrow. It owns exactly one file and exactly
// two values: the manifest schema (`paseo.queue.control.v3` ->
// `paseo.queue.control.v4`) and the single required read-only `task.pre_merge`
// target (`reviewed_head` -> `prospective_merge`). It refuses any manifest
// shape that would require interpretation, never touches Git, never stages or
// commits, and never reaches into the consumer's planning surfaces.
//
// Dry-run is the default. `--write` applies the already-proved edit through a
// same-directory temporary file and atomic rename, then re-reads and verifies
// the result. An already-migrated v4 manifest is an idempotent no-op.
//
// The command supplies evidence; it does not own Git or planning.

import { spawnSync } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import {
  LifecycleError,
  canonicalJson,
  digestBytes,
  discoverRepoRoot,
  writeFileAtomic,
} from "./lifecycle-core.ts";
import {
  MANIFEST_MAX_BYTES,
  MANIFEST_REL,
  ManifestError,
  parseControlManifest,
  type ControlHook,
  type LoadedControlManifest,
} from "./lifecycle-manifest.ts";

export const SCHEMA_V3 = "paseo.queue.control.v3";
export const SCHEMA_V4 = "paseo.queue.control.v4";
export const TARGET_REVIEWED_HEAD = "reviewed_head";
export const TARGET_PROSPECTIVE_MERGE = "prospective_merge";

// The frozen transport the adopted manifest pins. The migration may only edit
// a manifest whose every hook already carries this exact runner program; a
// custom runner id or argv is a shape the command cannot interpret.
export const FROZEN_HOOK_ARGV = ["skill", "run", "northstar/queue:hook", "--stdio", "passthrough"];

export interface QueueManifestChange {
  path: string;
  field: string;
  from: string;
  to: string;
}

export interface QueueManifestMigration {
  status: "dry_run" | "applied" | "unchanged";
  command: "lifecycle/migrate-premerge";
  manifest: string;
  schema_before: string;
  schema_after: string;
  pre_merge_hook: string;
  pre_merge_target_before: string;
  pre_merge_target_after: string;
  changes: QueueManifestChange[];
  changed_paths: string[];
  pending_paths: string[];
  digest_before: string;
  digest_after: string;
  commit_action: { required: boolean; paths: string[] };
}

function fail(code: string, message: string): never {
  throw new LifecycleError(code, message);
}

function check(condition: unknown, code: string, message: string): asserts condition {
  if (!condition) fail(code, message);
}

function parseManifest(text: string): LoadedControlManifest {
  try {
    return parseControlManifest(text);
  } catch (err) {
    if (err instanceof ManifestError) throw new LifecycleError(err.code, err.message);
    throw err;
  }
}

function countOccurrences(text: string, token: string): number {
  let count = 0;
  let index = text.indexOf(token);
  while (index !== -1) {
    count += 1;
    index = text.indexOf(token, index + token.length);
  }
  return count;
}

// The migration reads committed configuration, so an uncommitted manifest is a
// divergent input: the bytes on disk are not the bytes Queue will execute.
function assertCommittedClean(repoRoot: string, relative: string): void {
  const tracked = spawnSync("git", ["ls-files", "--error-unmatch", "--", relative], { cwd: repoRoot, encoding: "utf8" });
  if (tracked.status !== 0) fail("manifest-untracked", "control manifest is not committed to Git: " + relative);
  const dirty = spawnSync("git", ["status", "--porcelain", "--untracked-files=no", "--", relative], { cwd: repoRoot, encoding: "utf8" });
  if (dirty.status !== 0) fail("manifest-dirty", "could not read Git status for " + relative);
  check(String(dirty.stdout).trim() === "", "manifest-dirty", "control manifest has uncommitted changes: " + relative);
}

// Accepts only the canonical adopted shape: every hook carries the frozen
// trusted-runner transport and exactly one hook binds the required read-only
// `task.pre_merge` event. The static loader has already enforced the closed
// target set, delivery, mode, and event correlation rules.
function adoptedPreMergeHook(loaded: LoadedControlManifest): ControlHook {
  check(loaded.schemaName === SCHEMA_V3 || loaded.schemaName === SCHEMA_V4, "manifest-schema",
    "control manifest declares " + JSON.stringify(loaded.schemaName) + "; only " + SCHEMA_V3 + " migrates to " + SCHEMA_V4);
  const preMergeHooks = loaded.hooks.filter((hook) => hook.events.includes("task.pre_merge"));
  check(preMergeHooks.length === 1, "manifest-shape",
    "control manifest must bind exactly one task.pre_merge hook; found " + preMergeHooks.length);
  const preMerge = preMergeHooks[0]!;
  for (const hook of loaded.hooks) {
    check(hook.program.kind === "trusted_runner", "manifest-program",
      "hook " + hook.id + " does not use the trusted-runner program shape");
    check(hook.program.runner === "effigy", "manifest-program",
      "hook " + hook.id + " does not select the Effigy trusted runner");
    check(canonicalJson(hook.program.argv ?? []) === canonicalJson(FROZEN_HOOK_ARGV), "manifest-program",
      "hook " + hook.id + " does not carry the frozen Queue hook argv");
  }
  return preMerge;
}

function unchangedResult(manifest: string, schema: string, preMerge: ControlHook, digest: string): QueueManifestMigration {
  return {
    status: "unchanged",
    command: "lifecycle/migrate-premerge",
    manifest,
    schema_before: schema,
    schema_after: schema,
    pre_merge_hook: preMerge.id,
    pre_merge_target_before: preMerge.target,
    pre_merge_target_after: preMerge.target,
    changes: [],
    changed_paths: [],
    pending_paths: [],
    digest_before: digest,
    digest_after: digest,
    commit_action: { required: false, paths: [] },
  };
}

export function migrateQueuePremerge(options: { repoRoot: string; write?: boolean }): QueueManifestMigration {
  const repoRoot = options.repoRoot;
  const write = options.write === true;
  const manifestAbs = path.join(repoRoot, MANIFEST_REL);

  let stat: fs.Stats;
  try {
    stat = fs.lstatSync(manifestAbs);
  } catch {
    return fail("manifest-missing", MANIFEST_REL + " is missing; there is no manifest to migrate");
  }
  if (stat.isSymbolicLink()) fail("manifest-symlink", MANIFEST_REL + " is a symlink; refusing to migrate through a symlink");
  if (!stat.isFile()) fail("manifest-shape", MANIFEST_REL + " is not a regular file");

  const bytes = fs.readFileSync(manifestAbs);
  if (bytes.length > MANIFEST_MAX_BYTES) fail("manifest-size", "control manifest exceeds the 64 KiB cap");

  const text = bytes.toString("utf8");
  const loaded = parseManifest(text);
  const preMerge = adoptedPreMergeHook(loaded);
  const digestBefore = digestBytes(bytes);

  if (loaded.schemaName === SCHEMA_V4) {
    // An already-conforming v4 manifest is an idempotent no-op: no byte is
    // written, so an uncommitted working copy is not a divergent input here.
    if (preMerge.target === TARGET_PROSPECTIVE_MERGE) {
      return unchangedResult(MANIFEST_REL, SCHEMA_V4, preMerge, digestBefore);
    }
    fail("manifest-shape",
      "control manifest is already " + SCHEMA_V4 + " but its task.pre_merge hook targets " + preMerge.target
      + "; refusing a partial migration");
  }

  assertCommittedClean(repoRoot, MANIFEST_REL);

  check(preMerge.target === TARGET_REVIEWED_HEAD, "manifest-shape",
    "control manifest is " + SCHEMA_V3 + " but its task.pre_merge hook targets " + preMerge.target
    + "; only " + TARGET_REVIEWED_HEAD + " migrates");

  // The two literal tokens are replaced in place so every other byte is
  // preserved. Exactly one occurrence of each is required: more than one would
  // mean the edit has to guess which value belongs to the pre-merge binding.
  const schemaToken = '"' + SCHEMA_V3 + '"';
  const targetToken = '"' + TARGET_REVIEWED_HEAD + '"';
  check(countOccurrences(text, schemaToken) === 1, "manifest-shape",
    "control manifest does not carry exactly one " + schemaToken + " token; refusing an ambiguous edit");
  check(countOccurrences(text, targetToken) === 1, "manifest-shape",
    "control manifest does not carry exactly one " + targetToken + " token; refusing an ambiguous edit");

  const nextText = text.replace(schemaToken, '"' + SCHEMA_V4 + '"').replace(targetToken, '"' + TARGET_PROSPECTIVE_MERGE + '"');
  check(nextText !== text, "manifest-shape", "migration produced no change");

  // Validate the migrated bytes against the frozen v4 grammar and the same
  // binding cross-rules before anything can be written, then prove the edit
  // changed exactly those two values.
  const nextLoaded = parseManifest(nextText);
  check(nextLoaded.schemaName === SCHEMA_V4, "manifest-shape", "migrated manifest does not declare " + SCHEMA_V4);
  const nextPreMerge = adoptedPreMergeHook(nextLoaded);
  check(nextPreMerge.id === preMerge.id, "manifest-shape", "migrated manifest changed the pre-merge hook identity");
  check(nextPreMerge.target === TARGET_PROSPECTIVE_MERGE, "manifest-shape",
    "migrated manifest does not target " + TARGET_PROSPECTIVE_MERGE);
  const expected = JSON.parse(text) as Record<string, any>;
  expected.schema = SCHEMA_V4;
  (expected.hooks as Record<string, any>[]).find((hook) => hook.id === preMerge.id)!.target = TARGET_PROSPECTIVE_MERGE;
  check(canonicalJson(JSON.parse(nextText)) === canonicalJson(expected), "manifest-shape",
    "migration would change bytes beyond the schema and pre-merge target values");

  const digestAfter = digestBytes(Buffer.from(nextText, "utf8"));
  const changes: QueueManifestChange[] = [
    { path: MANIFEST_REL, field: "schema", from: SCHEMA_V3, to: SCHEMA_V4 },
    { path: MANIFEST_REL, field: "hooks[" + preMerge.id + "].target", from: TARGET_REVIEWED_HEAD, to: TARGET_PROSPECTIVE_MERGE },
  ];

  if (!write) {
    return {
      status: "dry_run",
      command: "lifecycle/migrate-premerge",
      manifest: MANIFEST_REL,
      schema_before: SCHEMA_V3,
      schema_after: SCHEMA_V4,
      pre_merge_hook: preMerge.id,
      pre_merge_target_before: TARGET_REVIEWED_HEAD,
      pre_merge_target_after: TARGET_PROSPECTIVE_MERGE,
      changes,
      changed_paths: [],
      pending_paths: [MANIFEST_REL],
      digest_before: digestBefore,
      digest_after: digestAfter,
      commit_action: { required: true, paths: [MANIFEST_REL] },
    };
  }

  writeFileAtomic(manifestAbs, nextText);
  const written = fs.readFileSync(manifestAbs);
  check(written.equals(Buffer.from(nextText, "utf8")), "manifest-write", "migrated manifest bytes do not match the validated result");
  return {
    status: "applied",
    command: "lifecycle/migrate-premerge",
    manifest: MANIFEST_REL,
    schema_before: SCHEMA_V3,
    schema_after: SCHEMA_V4,
    pre_merge_hook: preMerge.id,
    pre_merge_target_before: TARGET_REVIEWED_HEAD,
    pre_merge_target_after: TARGET_PROSPECTIVE_MERGE,
    changes,
    changed_paths: [MANIFEST_REL],
    pending_paths: [MANIFEST_REL],
    digest_before: digestBefore,
    digest_after: digestAfter,
    commit_action: { required: true, paths: [MANIFEST_REL] },
  };
}

// ---------------------------------------------------------------------------
// Command entry point
// ---------------------------------------------------------------------------

interface CliOptions {
  repoRoot: string;
  write: boolean;
}

export function parseCliOptions(args: string[], cwd: string): CliOptions {
  let repo: string | null = null;
  let write = false;
  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i]!;
    if (arg === "--write") {
      write = true;
    } else if (arg === "--dry-run") {
      write = false;
    } else if (arg === "--repo") {
      const value = args[i + 1];
      if (value === undefined || value.startsWith("--")) fail("usage", "--repo requires a path");
      repo = value;
      i += 1;
    } else {
      fail("usage", "unknown argument " + JSON.stringify(arg));
    }
  }
  const start = repo === null ? cwd : (path.isAbsolute(repo) ? repo : path.resolve(cwd, repo));
  return { repoRoot: discoverRepoRoot(start), write };
}

async function main(): Promise<void> {
  const result = migrateQueuePremerge(parseCliOptions(process.argv.slice(2), process.cwd()));
  console.log(JSON.stringify(result, null, 2));
}

if (import.meta.main) {
  main().catch((err) => {
    if (err instanceof LifecycleError) {
      console.log(JSON.stringify({ status: "error", code: err.code, message: err.message }, null, 2));
      process.exitCode = err.code === "usage" ? 2 : 1;
      return;
    }
    console.log(JSON.stringify({ status: "error", code: "internal", message: (err as Error).message }, null, 2));
    process.exitCode = 1;
  });
}
