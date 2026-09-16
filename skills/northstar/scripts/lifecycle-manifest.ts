// Shared strict loader for the repository-declared Queue control manifest.
//
// One parser serves both the Queue hook adapter and the bounded v3 -> v4
// migration command. The manifest schema name selects the frozen contract
// mirror, and the binding cross-rules the JSON schema cannot express — unique
// hook ids, read-only restrictions, integration-write commit subjects, and the
// target/event correlation — are enforced here exactly once. Queue stays
// document-system agnostic: only the frozen shape is inspected, and no program
// transport detail enters lifecycle state.
//
// Import-safe module: no process entry point, no side effects.

import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";
import {
  LifecycleError,
  validateAgainstSchemaFile,
} from "./lifecycle-core.ts";

export const MANIFEST_REL = ".paseo/queue.json";
export const MANIFEST_MAX_BYTES = 64 * 1024;

export const CONTROL_SCHEMAS: Record<string, string> = {
  "paseo.queue.control.v1": "queue-control.schema.json",
  "paseo.queue.control.v2": "queue-control-v2.schema.json",
  "paseo.queue.control.v3": "queue-control-v3.schema.json",
  "paseo.queue.control.v4": "queue-control-v4.schema.json",
};

export type ControlTarget = "integration_base" | "reviewed_head" | "prospective_merge";

export interface ControlProgram {
  kind: "repository" | "trusted_runner";
  executable?: string;
  runner?: string;
  argv?: string[];
}

export interface ControlHook {
  id: string;
  events: string[];
  mode: "read_only" | "integration_write";
  delivery: "required" | "advisory";
  target: ControlTarget;
  program: ControlProgram;
  timeoutMs: number;
  maxOutputBytes: number;
  allowedPaths: string[];
  commitSubject: { prefix: string; maxBytes: number } | null;
}

export interface LoadedControlManifest {
  schemaName: string;
  hooks: ControlHook[];
}

// A manifest refusal keeps its own error type so the hook can map it to a
// blocked result while the migration command reports it as a typed error. The
// message text is the shared contract; the code only names the refusal class.
export class ManifestError extends Error {
  code: string;
  constructor(code: string, message: string) {
    super(message);
    this.name = "ManifestError";
    this.code = code;
  }
}

function refuse(code: string, message: string): never {
  throw new ManifestError(code, message);
}

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const SCHEMA_DIR = path.resolve(SCRIPT_DIR, "..", "references", "lifecycle");

function normalizeRepoRelative(value: string, what: string): string {
  if (value.startsWith("/") || value.includes("\\")) refuse("manifest-shape", what + " must be repository-relative POSIX syntax: " + value);
  const segments = value.split("/");
  if (segments.some((segment) => segment === "" || segment === "." || segment === "..")) {
    refuse("manifest-shape", what + " contains an empty, dot, or parent segment: " + value);
  }
  return value;
}

// Parses one already-read manifest text and enforces the frozen grammar plus
// every binding cross-rule. Throws ManifestError for any refusal.
export function parseControlManifest(text: string): LoadedControlManifest {
  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    refuse("manifest-json", "control manifest is not valid JSON");
  }
  if (parsed === null || typeof parsed !== "object" || Array.isArray(parsed)) {
    refuse("manifest-json", "control manifest is not a JSON object");
  }
  const manifest = parsed as Record<string, any>;
  // The manifest schema name selects the frozen contract mirror. v1 keeps its
  // repository-executable grammar for existing consumers; v2 adds the closed
  // program union with trusted-runner programs; v3 adds one closed target so a
  // hook can run at the reviewed head before merge; v4 extends that closed
  // target set with prospective_merge so a hook can run in the Queue-owned
  // candidate checkout before merge. The program itself stays opaque here:
  // Queue resolves and executes it, and no program transport detail enters
  // lifecycle state.
  const schemaName = String(manifest.schema ?? "");
  const schemaFile = CONTROL_SCHEMAS[schemaName] ?? null;
  if (schemaFile === null) refuse("manifest-schema", "control manifest declares unsupported schema " + JSON.stringify(schemaName));
  try {
    validateAgainstSchemaFile(manifest, path.join(SCHEMA_DIR, schemaFile));
  } catch (err) {
    if (err instanceof LifecycleError) refuse("manifest-schema", "control manifest is not a valid " + schemaName + " document: " + err.message);
    throw err;
  }
  const rawHooks = manifest.hooks as Record<string, any>[];
  const ids = new Set(rawHooks.map((hook) => hook.id));
  if (ids.size !== rawHooks.length) refuse("manifest-shape", "control manifest has duplicate hook ids");
  const hooks: ControlHook[] = [];
  for (const hook of rawHooks) {
    const events = hook.events as string[];
    const reviewedHead = events.includes("task.pre_merge");
    if (hook.mode === "read_only" && (hook.allowedPaths as string[]).length > 0) refuse("manifest-shape", "read_only hook " + hook.id + " may not declare allowed paths");
    if (hook.mode === "read_only" && hook.commitSubject !== null && hook.commitSubject !== undefined) refuse("manifest-shape", "read_only hook " + hook.id + " may not declare a commit subject");
    if (hook.mode === "integration_write" && (hook.commitSubject === null || hook.commitSubject === undefined)) refuse("manifest-shape", "integration_write hook " + hook.id + " requires a commit subject");
    if (events.includes("task.pre_dispatch") && hook.mode !== "read_only") refuse("manifest-shape", "task.pre_dispatch accepts only read_only hooks");
    if ("target" in hook) {
      if (reviewedHead && hook.target !== "reviewed_head" && hook.target !== "prospective_merge") refuse("manifest-shape", "task.pre_merge requires target reviewed_head or prospective_merge on hook " + hook.id);
      if (!reviewedHead && hook.target !== "integration_base") refuse("manifest-shape", "only task.pre_merge may target the reviewed head on hook " + hook.id);
      if (hook.target === "prospective_merge" && schemaName !== "paseo.queue.control.v4") refuse("manifest-schema", "target prospective_merge requires control schema paseo.queue.control.v4 on hook " + hook.id);
    }
    if (reviewedHead) {
      if (events.length !== 1) refuse("manifest-shape", "task.pre_merge must be the only event on hook " + hook.id);
      if (hook.mode !== "read_only") refuse("manifest-shape", "task.pre_merge accepts only read_only hooks");
      if (hook.delivery !== "required") refuse("manifest-shape", "task.pre_merge requires required delivery");
    }
    const allowedPaths: string[] = [];
    for (const allowed of hook.allowedPaths as string[]) {
      const normalized = allowed.endsWith("/")
        ? normalizeRepoRelative(allowed.slice(0, -1), "allowed path") + "/"
        : normalizeRepoRelative(allowed, "allowed path");
      if (normalized === ".git" || normalized.startsWith(".git/") || normalized === ".paseo" || normalized === ".paseo/hooks" || normalized.startsWith(".paseo/hooks/") || normalized === ".paseo/queue.json") {
        refuse("manifest-shape", "reserved path may not be declared in allowedPaths: " + allowed);
      }
      allowedPaths.push(normalized);
    }
    hooks.push({
      id: String(hook.id),
      events: events.map((event) => String(event)),
      mode: hook.mode,
      delivery: hook.delivery,
      target: ("target" in hook && hook.target ? hook.target : "integration_base") as ControlTarget,
      program: hook.program as ControlProgram,
      timeoutMs: Number(hook.timeoutMs),
      maxOutputBytes: Number(hook.maxOutputBytes),
      allowedPaths,
      commitSubject: (hook.commitSubject ?? null) as ControlHook["commitSubject"],
    });
  }
  return { schemaName, hooks };
}

// Reads and validates the committed control manifest at the repository root.
export function loadControlManifest(repoRoot: string): LoadedControlManifest {
  const manifestPath = path.join(repoRoot, MANIFEST_REL);
  if (!fs.existsSync(manifestPath)) refuse("manifest-missing", "control manifest .paseo/queue.json is missing from the integration worktree");
  const bytes = fs.readFileSync(manifestPath);
  if (bytes.length > MANIFEST_MAX_BYTES) refuse("manifest-size", "control manifest exceeds the 64 KiB cap");
  return parseControlManifest(bytes.toString("utf8"));
}
