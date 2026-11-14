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
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve, posix } from "node:path";

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
  return spawnSync("git", args, { cwd: repo, encoding: "utf8", maxBuffer: 256 * 1024 * 1024 });
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

// A needle with no whitespace that contains "/" or "." names a path. It matches
// case-sensitively and only at a path boundary, so `PAPERCUTS.md` doesn't match
// `024-papercuts.md` and `docs/plan.md` doesn't match `old-docs/plan.md`.
const isPathLike = (needle: string) => !/\s/.test(needle) && /[/.]/.test(needle);

function atPathBoundary(text: string, needle: string): boolean {
  for (let i = text.indexOf(needle); i !== -1; i = text.indexOf(needle, i + 1)) {
    if (i === 0 || !/[A-Za-z0-9_.-]/.test(text[i - 1])) return true;
  }
  return false;
}

type Hit = { file: string; line: number; text: string };

// One search for every needle at once. `git grep -f` takes all the needles as
// patterns and returns each matching line once; the needles that a line
// contains are then worked out in memory. A search per needle meant hundreds of
// full-tree passes. Matching is unchanged: ordinary terms ignore case; a needle
// that names a path matches case-sensitively and only at a path boundary.
// --untracked also searches new files; files deleted but not yet staged are
// absent from the working tree, so they can't match.
function grepAll(repo: string, needles: string[]): Map<string, Hit[]> {
  const index = new Map<string, Hit[]>(needles.map((needle) => [needle, []]));
  const groups = [
    { ignoreCase: true, list: needles.filter((needle) => !isPathLike(needle)) },
    { ignoreCase: false, list: needles.filter(isPathLike) },
  ];
  const dir = mkdtempSync(join(tmpdir(), "retired-concepts-"));
  try {
    for (const { ignoreCase, list } of groups) {
      if (list.length === 0) continue;
      const patterns = join(dir, ignoreCase ? "terms.txt" : "paths.txt");
      writeFileSync(patterns, list.join("\n") + "\n");
      const result = git(repo, ["grep", "--untracked", "-n", "-I", ...(ignoreCase ? ["-i"] : []), "-F", "--no-color", "-f", patterns, "--", "."]);
      if (result.status === 1) continue;
      if (result.status !== 0) fail(`git grep failed: ${result.stderr.trim()}`);
      const lowered = ignoreCase ? list.map((needle) => needle.toLowerCase()) : list;
      for (const row of result.stdout.split("\n").filter(Boolean)) {
        const first = row.indexOf(":");
        const second = row.indexOf(":", first + 1);
        const file = row.slice(0, first);
        const line = Number(row.slice(first + 1, second));
        const full = row.slice(second + 1);
        const haystack = ignoreCase ? full.toLowerCase() : full;
        list.forEach((needle, i) => {
          if (!haystack.includes(lowered[i])) return;
          if (!ignoreCase && !atPathBoundary(full, needle)) return;
          index.get(needle)!.push({ file, line, text: full.trim().slice(0, 200) });
        });
      }
    }
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
  return index;
}

// A file inside a retired path's parent directory can name it relatively:
// `plan.md` in docs/AGENTS.md, or `../plan.md` in docs/knowledge/x.md, both mean
// docs/plan.md. Search Markdown under each ancestor directory for the path's
// tail and keep only occurrences that resolve to the retired path. Markdown only:
// config files resolve paths from wherever their command runs, not from the
// file's directory. A history pointer written as `name.md` (Git history) is
// allowed, as adopt.md recommends.
// One Markdown search for every retired path's tails; each hit is then checked
// against the directories it must sit under.
function relativeAll(repo: string, retiredPaths: string[]): Map<string, Hit[]> {
  type Combo = { path: string; level: number; dir: string; tail: string; target: string; isDir: boolean };
  const combos: Combo[] = [];
  for (const retiredPath of new Set(retiredPaths)) {
    const isDir = retiredPath.endsWith("/");
    const target = retiredPath.replace(/\/$/, "");
    const parts = target.split("/");
    for (let level = 1; level < parts.length; level++) {
      combos.push({ path: retiredPath, level, dir: parts.slice(0, level).join("/"), tail: parts.slice(level).join("/") + (isDir ? "/" : ""), target, isDir });
    }
  }
  const byPath = new Map<string, Hit[]>();
  if (combos.length === 0) return byPath;
  const found = new Map<Combo, Hit[]>(combos.map((combo) => [combo, []]));
  const tails = [...new Set(combos.map((combo) => combo.tail))];
  const dir = mkdtempSync(join(tmpdir(), "retired-concepts-"));
  try {
    const patterns = join(dir, "tails.txt");
    writeFileSync(patterns, tails.join("\n") + "\n");
    const result = git(repo, ["grep", "--untracked", "-n", "-I", "-F", "--no-color", "-f", patterns, "--", ":(glob)**/*.md"]);
    if (result.status !== 0 && result.status !== 1) fail(`git grep failed: ${result.stderr.trim()}`);
    for (const row of result.status === 1 ? [] : result.stdout.split("\n").filter(Boolean)) {
      const first = row.indexOf(":");
      const second = row.indexOf(":", first + 1);
      const file = row.slice(0, first);
      const text = row.slice(second + 1);
      for (const combo of combos) {
        if (!file.startsWith(combo.dir + "/") || !text.includes(combo.tail)) continue;
        if (relativePointer(file, text, combo.tail, combo.target)) {
          found.get(combo)!.push({ file, line: Number(row.slice(first + 1, second)), text: text.trim().slice(0, 200) });
        }
      }
    }
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
  for (const combo of combos) byPath.set(combo.path, [...(byPath.get(combo.path) ?? []), ...found.get(combo)!]);
  return byPath;
}

// Does `text`, in `file`, name the retired `target` relatively through `tail`?
function relativePointer(file: string, text: string, tail: string, target: string): boolean {
  for (let at = text.indexOf(tail); at !== -1; at = text.indexOf(tail, at + 1)) {
    let start = at;
    while (text.slice(start - 3, start) === "../") start -= 3;
    if (text.slice(start - 2, start) === "./") start -= 2;
    // Preceded by a path segment means another path (or the root form,
    // which the ordinary search already reports).
    if (start > 0 && /[A-Za-z0-9_.\/-]/.test(text[start - 1])) continue;
    // The pointer marker follows the whole path, which for a directory
    // retirement runs past the tail (`roadmaps/g02/x.md` (Git history)).
    const end = at + tail.length + (text.slice(at + tail.length).match(/^[^\s`)\]]*/)?.[0].length ?? 0);
    const after = text.slice(end);
    if (/^`? \((in )?Git history\)/.test(after)) continue;
    const resolved = posix.normalize(posix.join(posix.dirname(file), text.slice(start, at + tail.length))).replace(/\/$/, "");
    if (resolved === target) return true;
  }
  return false;
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
  const needles = new Set<string>();
  const retiredPaths: string[] = [];
  for (const entry of entries) {
    for (const needle of [...(entry.terms ?? []), ...(entry.config_keys ?? []), ...(entry.paths ?? [])]) needles.add(needle);
    retiredPaths.push(...(entry.paths ?? []));
  }
  const hits = grepAll(repo, [...needles]);
  const relative = relativeAll(repo, retiredPaths);

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
    for (const term of entry.terms ?? []) for (const hit of hits.get(term) ?? []) add2({ id: entry.id, kind: "term", needle: term, ...hit });
    for (const key of entry.config_keys ?? []) for (const hit of hits.get(key) ?? []) add2({ id: entry.id, kind: "config_key", needle: key, ...hit });
    for (const path of entry.paths ?? []) {
      // A trailing slash names a directory, so text matches keep the slash and
      // `src/media/` does not match `src/media-locator.ts`. Without one, the
      // path names a file and matches exactly.
      const prefix = path.replace(/\/$/, "");
      const isDir = path.endsWith("/");
      for (const t of tracked) if (t === prefix || (isDir && t.startsWith(prefix + "/"))) add({ id: entry.id, kind: "tracked_path", needle: path, file: t });
      for (const hit of hits.get(path) ?? []) add2({ id: entry.id, kind: "path", needle: path, ...hit });
      for (const hit of relative.get(path) ?? []) add2({ id: entry.id, kind: "path", needle: path, ...hit });
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
