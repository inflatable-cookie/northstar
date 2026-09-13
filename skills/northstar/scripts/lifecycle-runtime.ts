// Deterministic source-to-runtime build and parity oracle for the committed
// Northstar Queue hook runtime.
//
// The canonical lifecycle implementation lives in this skill: the reducer,
// the Queue hook adapter, the lifecycle schemas, and the launcher template.
// Queue executes only repository-committed bytes, so a repository that
// declares the hook commits a byte-identical copy of that whole closure under
// its own hooks directory. `copy` writes or refreshes that payload and `check`
// fails on any missing, extra, or differing byte in code or schema. Copies are
// generated, never hand-maintained: there is one implementation.
//
// The closure is derived, not hand-listed: every committed
// `references/lifecycle/*.schema.json` joins it automatically, so a new schema
// cannot be forgotten while the parity check still passes.

import { createHash } from "node:crypto";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

const RUNTIME_SCHEMA = "northstar.lifecycle.hook-runtime.v1";
const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url));
const SKILL_ROOT = path.resolve(SCRIPT_DIR, "..");
const LAUNCHER_NAME = "northstar-lifecycle";
const LAUNCHER_SOURCE = path.join(SKILL_ROOT, "assets", "templates", "lifecycle-hook-launcher.sh");
const RUNTIME_DIR = "northstar-lifecycle.runtime";
const DEFAULT_HOOKS_DIR = ".paseo/hooks";

class RuntimeError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "RuntimeError";
  }
}

function sha256(bytes: Buffer): string {
  return "sha256:" + createHash("sha256").update(bytes).digest("hex");
}

interface ClosureFile {
  relative: string;
  source: string;
}

// The complete transitive runtime closure the launcher can execute.
export function runtimeClosure(): ClosureFile[] {
  const files: ClosureFile[] = [
    { relative: LAUNCHER_NAME, source: LAUNCHER_SOURCE },
    {
      relative: RUNTIME_DIR + "/scripts/lifecycle-core.ts",
      source: path.join(SKILL_ROOT, "scripts", "lifecycle-core.ts"),
    },
    {
      relative: RUNTIME_DIR + "/scripts/lifecycle-queue-hook.ts",
      source: path.join(SKILL_ROOT, "scripts", "lifecycle-queue-hook.ts"),
    },
  ];
  const schemaDir = path.join(SKILL_ROOT, "references", "lifecycle");
  for (const name of fs.readdirSync(schemaDir).sort()) {
    if (!name.endsWith(".schema.json")) continue;
    files.push({
      relative: RUNTIME_DIR + "/references/lifecycle/" + name,
      source: path.join(schemaDir, name),
    });
  }
  return files;
}

function toPosix(relative: string): string {
  return relative.split(path.sep).join("/");
}

function listFiles(root: string): string[] {
  if (!fs.existsSync(root)) return [];
  const out: string[] = [];
  const walk = (dir: string, prefix: string): void => {
    const entries = fs.readdirSync(dir, { withFileTypes: true }).sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0));
    for (const entry of entries) {
      const full = path.join(dir, entry.name);
      const relative = toPosix(prefix === "" ? entry.name : path.join(prefix, entry.name));
      if (entry.isDirectory()) walk(full, relative);
      else out.push(relative);
    }
  };
  walk(root, "");
  return out;
}

function symlinkInPath(root: string, relative: string): string | null {
  let cursor = root;
  for (const part of relative.split("/")) {
    cursor = path.join(cursor, part);
    let stat: fs.Stats;
    try {
      stat = fs.lstatSync(cursor);
    } catch {
      return null;
    }
    if (stat.isSymbolicLink()) return cursor;
  }
  return null;
}

function hookPaths(hooksDir: string): { hooksDir: string; runtimeDir: string; launcher: string } {
  const resolved = path.resolve(hooksDir);
  return {
    hooksDir: resolved,
    runtimeDir: path.join(resolved, RUNTIME_DIR),
    launcher: path.join(resolved, LAUNCHER_NAME),
  };
}

function closureManifest(): { path: string; digest: string }[] {
  return runtimeClosure().map((file) => ({
    path: file.relative,
    digest: sha256(fs.readFileSync(file.source)),
  }));
}

function copy(hooksDir: string, json: boolean): number {
  const { hooksDir: root, runtimeDir, launcher } = hookPaths(hooksDir);
  const closure = runtimeClosure();
  const expected = new Set(closure.map((file) => file.relative));

  for (const file of closure) {
    const target = path.join(root, file.relative);
    const symlink = symlinkInPath(root, file.relative);
    if (symlink !== null) throw new RuntimeError("refusing to write through symlink: " + symlink);
    fs.mkdirSync(path.dirname(target), { recursive: true });
    fs.writeFileSync(target, fs.readFileSync(file.source));
  }
  fs.chmodSync(launcher, 0o755);

  // Prune bytes the closure no longer owns so a stale generated file cannot
  // linger as executable implementation.
  for (const relative of listFiles(runtimeDir)) {
    if (expected.has(RUNTIME_DIR + "/" + relative)) continue;
    fs.rmSync(path.join(runtimeDir, relative), { force: true });
  }
  const pruneEmpty = (dir: string): void => {
    if (!fs.existsSync(dir)) return;
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      if (entry.isDirectory()) pruneEmpty(path.join(dir, entry.name));
    }
    if (dir !== runtimeDir && fs.readdirSync(dir).length === 0) fs.rmdirSync(dir);
  };
  pruneEmpty(runtimeDir);

  if (json) {
    process.stdout.write(
      JSON.stringify({ schema: RUNTIME_SCHEMA, status: "copied", hooksDir: root, files: closureManifest() }, null, 2) + "\n",
    );
  } else {
    process.stdout.write("lifecycle hook runtime copied: " + String(closure.length) + " files under " + root + "\n");
  }
  return 0;
}

function check(hooksDir: string, json: boolean): number {
  const { hooksDir: root, runtimeDir, launcher } = hookPaths(hooksDir);
  const closure = runtimeClosure();
  const problems: string[] = [];
  const expected = new Set(closure.map((file) => file.relative));

  for (const file of closure) {
    const target = path.join(root, file.relative);
    const symlink = symlinkInPath(root, file.relative);
    if (symlink !== null) {
      problems.push("symlink: " + toPosix(path.relative(root, symlink)));
      continue;
    }
    if (!fs.existsSync(target)) {
      problems.push("missing: " + file.relative);
      continue;
    }
    const wanted = sha256(fs.readFileSync(file.source));
    const actual = sha256(fs.readFileSync(target));
    if (wanted !== actual) problems.push("differs: " + file.relative + " (canonical " + wanted + ", committed " + actual + ")");
  }

  if (fs.existsSync(runtimeDir)) {
    if (fs.lstatSync(runtimeDir).isSymbolicLink()) {
      problems.push("symlink: " + RUNTIME_DIR);
    } else {
      for (const relative of listFiles(runtimeDir)) {
        if (!expected.has(RUNTIME_DIR + "/" + relative)) problems.push("unexpected: " + RUNTIME_DIR + "/" + relative);
      }
    }
  }

  if (fs.existsSync(launcher) && !fs.lstatSync(launcher).isSymbolicLink()) {
    if ((fs.statSync(launcher).mode & 0o111) === 0) problems.push("not executable: " + LAUNCHER_NAME);
  }

  if (problems.length > 0) {
    if (json) {
      process.stdout.write(JSON.stringify({ schema: RUNTIME_SCHEMA, status: "drift", hooksDir: root, problems }, null, 2) + "\n");
    } else {
      for (const problem of problems) process.stderr.write("lifecycle hook runtime drift: " + problem + "\n");
    }
    return 1;
  }

  if (json) {
    process.stdout.write(
      JSON.stringify({ schema: RUNTIME_SCHEMA, status: "ok", hooksDir: root, files: closureManifest() }, null, 2) + "\n",
    );
  } else {
    process.stdout.write("lifecycle hook runtime parity: OK (" + String(closure.length) + " files under " + root + ")\n");
  }
  return 0;
}

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

function main(): number {
  const [command, ...rest] = process.argv.slice(2);
  const { flags } = parseFlags(rest);
  const hooksDir = typeof flags.hooks === "string" ? flags.hooks : DEFAULT_HOOKS_DIR;
  const json = flags.json === true || flags.format === "json";
  try {
    switch (command) {
      case "closure":
        process.stdout.write(
          JSON.stringify({ schema: RUNTIME_SCHEMA, files: closureManifest() }, null, 2) + "\n",
        );
        return 0;
      case "copy":
        return copy(hooksDir, json);
      case "check":
        return check(hooksDir, json);
      default:
        process.stderr.write(
          "usage: lifecycle-runtime.ts <closure|copy|check> [--hooks <dir>] [--json]\n",
        );
        return 2;
    }
  } catch (err) {
    if (err instanceof RuntimeError) {
      process.stderr.write("lifecycle hook runtime: " + err.message + "\n");
      return 1;
    }
    throw err;
  }
}

process.exitCode = main();
