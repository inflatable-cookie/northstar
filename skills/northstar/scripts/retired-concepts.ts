#!/usr/bin/env bun
// Retired-concepts check: fails when a concept listed in
// docs/knowledge/retired.toml still appears in the working tree (tracked or
// new files; ignored files and unstaged deletions don't count).
//
// Usage: bun run retired-concepts.ts [--repo <path>] [--retired <file>] [--json]
// --retired audits against a list outside the repository, for example while
// preparing a migration before docs/knowledge/retired.toml exists.
// Exit: 0 clean, 1 findings, 2 usage or configuration error.

import { spawnSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { join, resolve } from "node:path";

const RETIRED_FILE = "docs/knowledge/retired.toml";

type Entry = {
  id: string;
  retired?: string;
  replacement?: string;
  owner?: string;
  terms?: string[];
  paths?: string[];
  config_keys?: string[];
  allow?: string[];
};

type Finding = {
  id: string;
  kind: "term" | "path" | "config_key" | "tracked_path";
  needle: string;
  file: string;
  line?: number;
  text?: string;
};

function fail(message: string): never {
  console.error(`retired-concepts: ${message}`);
  process.exit(2);
}

function parseArgs(argv: string[]) {
  let repo = process.cwd();
  let json = false;
  let retired: string | undefined;
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === "--repo") repo = argv[++i] ?? fail("--repo needs a path");
    else if (arg === "--retired") retired = argv[++i] ?? fail("--retired needs a file");
    else if (arg === "--json") json = true;
    else fail(`unknown argument ${arg}`);
  }
  return { repo: resolve(repo), json, retired: retired ? resolve(retired) : undefined };
}

function git(repo: string, args: string[]) {
  return spawnSync("git", args, { cwd: repo, encoding: "utf8", maxBuffer: 64 * 1024 * 1024 });
}

// An `allow` entry matches an exact file or, with a trailing slash, everything
// under a directory. `*` matches within one path segment
// (`scripts/*-census/`), and `**` matches across segments
// (`syllabus/**/calibration/`).
function allowed(file: string, allow: string[]): boolean {
  return allow.some((pattern) => {
    const dir = pattern.endsWith("/");
    const body = pattern
      .split("**")
      .map((part) => part.split("*").map((p) => p.replace(/[.+?^${}()|[\]\\]/g, "\\$&")).join("[^/]*"))
      .join(".*");
    return new RegExp("^" + body + (dir ? "" : "(/|$)")).test(file);
  });
}

function grep(repo: string, needle: string): { file: string; line: number; text: string }[] {
  // --untracked also searches new files; files deleted but not yet staged are
  // absent from the working tree, so they can't match.
  const result = git(repo, ["grep", "--untracked", "-n", "-I", "-i", "-F", "--no-color", "-e", needle, "--", "."]);
  if (result.status === 1) return [];
  if (result.status !== 0) fail(`git grep failed for ${JSON.stringify(needle)}: ${result.stderr.trim()}`);
  return result.stdout
    .split("\n")
    .filter(Boolean)
    .map((row) => {
      const first = row.indexOf(":");
      const second = row.indexOf(":", first + 1);
      return { file: row.slice(0, first), line: Number(row.slice(first + 1, second)), text: row.slice(second + 1).trim().slice(0, 200) };
    });
}

function main() {
  const { repo, json, retired } = parseArgs(process.argv.slice(2));
  if (git(repo, ["rev-parse", "--is-inside-work-tree"]).status !== 0) fail(`${repo} is not a Git checkout`);
  const file = retired ?? join(repo, RETIRED_FILE);
  if (!existsSync(file)) {
    if (json) console.log(JSON.stringify({ status: "ok", entries: 0, findings: [] }));
    else console.log(`retired-concepts: no ${RETIRED_FILE}; nothing to check`);
    return;
  }
  let parsed: { retired?: Entry[]; frozen?: string[] };
  try {
    parsed = Bun.TOML.parse(readFileSync(file, "utf8")) as { retired?: Entry[]; frozen?: string[] };
  } catch (error) {
    fail(`${file} is not valid TOML: ${(error as Error).message}`);
  }
  const entries = parsed.retired ?? [];
  // The working tree as it is: tracked and new files that exist on disk, so the
  // check gives the same answer before and after a migration is staged.
  const tracked = git(repo, ["ls-files", "-z", "--cached", "--others", "--exclude-standard"])
    .stdout.split("\0")
    .filter((f) => f && existsSync(join(repo, f)));
  const findings: Finding[] = [];
  const seen = new Set<string>();

  for (const entry of entries) {
    if (!entry.id) fail(`an entry in ${file} has no id`);
    // The retired list and the owning file name the concept on purpose.
    // Frozen artefacts (top-level `frozen`) are never rewritten, so they are
    // exempt from every retirement.
    const allow = [RETIRED_FILE, ...(entry.owner ? [entry.owner] : []), ...(entry.allow ?? []), ...(parsed.frozen ?? [])];
    const add = (finding: Finding) => {
      const key = `${finding.id}|${finding.file}|${finding.line ?? ""}|${finding.needle}`;
      if (!seen.has(key) && !allowed(finding.file, allow)) {
        seen.add(key);
        findings.push(finding);
      }
    };
    // A permalink pinned to a commit (…/blob/<sha>/…) is a Git-history pointer.
    const permalink = (text: string, needle: string) =>
      new RegExp("/blob/[0-9a-f]{7,40}/[^\\s)]*" + needle.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"), "i").test(text);
    const add2 = (f: Finding) => { if (!(f.text && permalink(f.text, f.needle.replace(/\/$/, "")))) add(f); };
    for (const term of entry.terms ?? []) for (const hit of grep(repo, term)) add2({ id: entry.id, kind: "term", needle: term, ...hit });
    for (const key of entry.config_keys ?? []) for (const hit of grep(repo, key)) add2({ id: entry.id, kind: "config_key", needle: key, ...hit });
    for (const path of entry.paths ?? []) {
      // A trailing slash names a directory, so text matches keep the slash and
      // `src/media/` does not match `src/media-locator.ts`. Without one, the
      // path names a file and matches exactly.
      const prefix = path.replace(/\/$/, "");
      const isDir = path.endsWith("/");
      for (const t of tracked) if (t === prefix || (isDir && t.startsWith(prefix + "/"))) add({ id: entry.id, kind: "tracked_path", needle: path, file: t });
      for (const hit of grep(repo, path)) add2({ id: entry.id, kind: "path", needle: path, ...hit });
    }
  }

  if (json) {
    console.log(JSON.stringify({ status: findings.length ? "violations" : "ok", entries: entries.length, findings }, null, 2));
  } else if (findings.length === 0) {
    console.log(`retired-concepts: OK (${entries.length} retired concept${entries.length === 1 ? "" : "s"})`);
  } else {
    console.log(`retired-concepts: ${findings.length} live reference${findings.length === 1 ? "" : "s"} to retired concepts`);
    for (const f of findings) {
      const where = f.line ? `${f.file}:${f.line}` : f.file;
      console.log(`  [${f.id}] ${f.kind} "${f.needle}" at ${where}${f.text ? ` — ${f.text}` : ""}`);
    }
  }
  process.exit(findings.length ? 1 : 0);
}

main();
