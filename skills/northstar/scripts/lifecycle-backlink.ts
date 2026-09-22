// One import-safe, bounded resolver for the transient-handoff backlink
// invariant.
//
// A lifecycle-managed task consumes its submitted instruction handoff at
// closeout: the handoff is pinned transport, not permanent evidence. Deleting
// it must never strand durable Markdown. This module proves that invariant
// exactly, and both Queue gates call it so the proof cannot drift: the
// pre-merge gate runs it at the accepted reviewed head before merge, and the
// closeout guard runs it at the integration base as defence in depth.
//
// The scan is structural, bounded, and deliberately fail-closed: tracked
// `.md` files only, standard Markdown links (bare, angle-bracketed, titled, or
// reference-style resolved through their definitions) plus `<autolinks>`,
// relative and rooted targets resolved against the linking file, external
// URLs and the handoff itself ignored, generated projection blocks stripped.
// Code contexts are not distinguished: a link-shaped example also blocks, so
// no container misclassification can strand a durable backlink. Only an exact
// local target blocks; similarly named files never do.
//
// The module has no side effects at import time and imports no provider,
// Queue, daemon, or network module. It throws BacklinkError, which carries the
// same `blocked`/`failed` outcome the hook result contract uses, so a caller
// can translate it without re-deriving the summary.

import { spawnSync } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import { BEGIN_PREFIX, END_SENTINEL } from "./lifecycle-core.ts";

export class BacklinkError extends Error {
  outcome: "blocked" | "failed";
  constructor(outcome: "blocked" | "failed", summary: string) {
    super(summary);
    this.name = "BacklinkError";
    this.outcome = outcome;
  }
}

function refuse(summary: string): never {
  throw new BacklinkError("blocked", summary);
}

function malfunction(summary: string): never {
  throw new BacklinkError("failed", summary);
}

export const BACKLINK_SCAN_MAX_FILES = 25_000;
export const BACKLINK_SCAN_MAX_LISTING_BYTES = 4 * 1024 * 1024;
export const BACKLINK_SCAN_MAX_AGGREGATE_BYTES = 128 * 1024 * 1024;
export const BACKLINK_SCAN_MAX_BYTES = 4 * 1024 * 1024;
const MARKDOWN_LINK_RE = /\[[^\]]*\]\(\s*(?:<([^<>\s]+)>|([^\s)]+))(?:\s+[^)]*)?\)/g;
const AUTOLINK_RE = /<([^<>\s]+)>/g;
const EXTERNAL_TARGET_RE = /^[a-zA-Z][a-zA-Z0-9+.-]*:/;
const REFERENCE_DEF_RE = /^[ ]{0,3}\[([^\]\n]+)\]:[ \t]*(?:<([^<>\n]+)>|(\S+))/gm;
const REF_FULL_RE = /\[([^\]\n]+)\]\[([^\]\n]*)\]/g;
const REF_COLLAPSED_RE = /\[([^\]\n]+)\]\[\]/g;
const REF_SHORTCUT_RE = /(?<!!)\[([^\]\n]+)\](?!\(|\[)/g;

function stripHookGeneratedBlocks(text: string): string {
  let output = "";
  let rest = text.replace(/\r\n/g, "\n");
  for (;;) {
    const start = rest.indexOf(BEGIN_PREFIX);
    if (start === -1) {
      output += rest;
      return output;
    }
    const endScheme = rest.indexOf(END_SENTINEL, start);
    if (endScheme === -1) {
      output += rest;
      return output;
    }
    output += rest.slice(0, start);
    rest = rest.slice(endScheme + END_SENTINEL.length);
  }
}

function resolveLinkTarget(sourceRel: string, rawTarget: string): string | null {
  let target = rawTarget.trim();
  const hash = target.indexOf("#");
  if (hash !== -1) target = target.slice(0, hash);
  if (target === "") return null;
  if (EXTERNAL_TARGET_RE.test(target)) return null;
  try {
    target = decodeURIComponent(target);
  } catch {
    // Keep the raw spelling when it is not valid percent-encoding.
  }
  const normalized = target.startsWith("/")
    ? path.posix.normalize(target.slice(1))
    : path.posix.normalize(path.posix.join(path.posix.dirname(sourceRel), target));
  if (normalized === "" || normalized === "." || normalized.startsWith("..")) return null;
  return normalized;
}

function boundedProcessText(value: unknown): string {
  const text = String(value ?? "").trim();
  return text.length <= 512 ? text : text.slice(0, 512) + "...";
}

function processEvidence(result: ReturnType<typeof spawnSync>): string {
  const evidence: string[] = [];
  const error = result.error as (Error & { code?: string }) | undefined;
  if (error) {
    const identity = error.code ?? error.name ?? "unknown error";
    const detail = boundedProcessText(error.message);
    evidence.push("error " + identity + (detail ? " (" + detail + ")" : ""));
  }
  if (result.signal !== null) evidence.push("signal " + String(result.signal));
  if (result.status === null) evidence.push("status null");
  else if (result.status !== 0) evidence.push("exit status " + String(result.status));
  const stderr = boundedProcessText(result.stderr);
  if (stderr) evidence.push("stderr " + stderr);
  return evidence.join("; ");
}

function trackedMarkdownMatches(repoRoot: string, args: string[], noMatchIsOk: boolean): string[] {
  const listed = spawnSync("git", args, { cwd: repoRoot, maxBuffer: BACKLINK_SCAN_MAX_LISTING_BYTES });
  if (listed.error || listed.signal !== null || (listed.status !== 0 && !(noMatchIsOk && listed.status === 1))) {
    malfunction("git " + args[0] + " failed: " + (processEvidence(listed) || "abnormal process termination"));
  }
  const listingBytes = Buffer.isBuffer(listed.stdout)
    ? listed.stdout.byteLength
    : Buffer.byteLength(String(listed.stdout ?? ""), "utf8");
  if (listingBytes > BACKLINK_SCAN_MAX_LISTING_BYTES) {
    refuse("backlink scan tracked-file listing exceeds its " + BACKLINK_SCAN_MAX_LISTING_BYTES + "-byte bound; refusing the handoff guard");
  }
  return String(listed.stdout).split("\0").filter((name) => name.length > 0 && name.endsWith(".md"));
}

function encodedBasenamePattern(basename: string): string {
  return Array.from(basename, (character) => {
    const literal = character.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    const encoded = Buffer.from(character).toString("hex").replace(/[a-f]/g, (hex) => "[" + hex + hex.toUpperCase() + "]");
    return "(" + literal + "|%" + encoded + ")";
  }).join("");
}

// Every tracked Markdown file linking to the exact handoff path, sorted. The
// handoff file itself never counts as a backlink candidate. A literal basename
// prefilter keeps normal scans proportional to its hits; unusual basenames use
// the bounded full scan because their spelling may be escaped in link targets.
// Bounds fail closed on the candidate set before any byte changes.
export function findHandoffBacklinks(repoRoot: string, handoffRel: string): string[] {
  const basename = path.posix.basename(handoffRel);
  const literalBasename = /^[A-Za-z0-9._-]+$/.test(basename);
  // resolveLinkTarget decodes percent escapes, including escapes of safe ASCII.
  // The second Git search keeps those links in the candidate set.
  const tracked = literalBasename
    ? [...new Set([
      ...trackedMarkdownMatches(repoRoot, ["grep", "-l", "-z", "-F", "-e", basename, "--", "*.md"], true),
      ...trackedMarkdownMatches(repoRoot, ["grep", "-l", "-z", "-E", "-e", encodedBasenamePattern(basename), "--", "*.md"], true),
    ])]
    : trackedMarkdownMatches(repoRoot, ["ls-files", "-z", "--", "*.md"], false);
  if (Buffer.byteLength(tracked.join("\0"), "utf8") > BACKLINK_SCAN_MAX_LISTING_BYTES) {
    refuse("backlink scan tracked-file listing exceeds its " + BACKLINK_SCAN_MAX_LISTING_BYTES + "-byte bound; refusing the handoff guard");
  }
  if (tracked.length > BACKLINK_SCAN_MAX_FILES) {
    refuse("backlink scan exceeds its " + BACKLINK_SCAN_MAX_FILES + "-file bound; refusing the handoff guard");
  }
  const candidates: Array<{ sourceRel: string; absolute: string }> = [];
  let aggregateBytes = 0;
  for (const sourceRel of tracked.sort()) {
    if (sourceRel === handoffRel) continue;
    const absolute = path.join(repoRoot, sourceRel);
    let stats: fs.Stats;
    try {
      stats = fs.lstatSync(absolute);
    } catch {
      continue;
    }
    if (!stats.isFile()) continue;
    if (stats.size > BACKLINK_SCAN_MAX_BYTES) {
      refuse("backlink scan found an oversized Markdown file " + sourceRel + "; refusing the handoff guard");
    }
    if (aggregateBytes > BACKLINK_SCAN_MAX_AGGREGATE_BYTES - stats.size) {
      refuse("backlink scan aggregate Markdown size exceeds its " + BACKLINK_SCAN_MAX_AGGREGATE_BYTES + "-byte bound; refusing the handoff guard");
    }
    aggregateBytes += stats.size;
    candidates.push({ sourceRel, absolute });
  }
  const backlinks: string[] = [];
  for (const { sourceRel, absolute } of candidates) {
    const bare = stripHookGeneratedBlocks(fs.readFileSync(absolute, "utf8"));
    const targets = new Set<string>();
    for (const pattern of [MARKDOWN_LINK_RE, AUTOLINK_RE]) {
      pattern.lastIndex = 0;
      let match: RegExpExecArray | null;
      while ((match = pattern.exec(bare)) !== null) {
        const target = match[1] ?? match[2];
        if (target !== undefined) targets.add(target);
      }
    }
    // Reference-style links resolve through their definitions: full
    // `[text][label]`, collapsed `[text][]`, and shortcut `[text]` forms share
    const definitions = new Map<string, string>();
    REFERENCE_DEF_RE.lastIndex = 0;
    let def: RegExpExecArray | null;
    while ((def = REFERENCE_DEF_RE.exec(bare)) !== null) {
      const target = def[2] ?? def[3];
      // CommonMark reference labels are case-insensitive with collapsed
      // internal whitespace.
      if (target !== undefined) definitions.set(def[1].trim().replace(/\s+/g, " ").toLowerCase(), target);
    }
    const usage = bare.replace(REFERENCE_DEF_RE, "");
    const useLabel = (label: string): void => {
      const target = definitions.get(label.trim().replace(/\s+/g, " ").toLowerCase());
      if (target !== undefined) targets.add(target);
    };
    REF_FULL_RE.lastIndex = 0;
    let ref: RegExpExecArray | null;
    while ((ref = REF_FULL_RE.exec(usage)) !== null) useLabel(ref[2] === "" ? ref[1] : ref[2]);
    REF_COLLAPSED_RE.lastIndex = 0;
    while ((ref = REF_COLLAPSED_RE.exec(usage)) !== null) useLabel(ref[1]);
    REF_SHORTCUT_RE.lastIndex = 0;
    while ((ref = REF_SHORTCUT_RE.exec(usage)) !== null) useLabel(ref[1]);
    for (const raw of targets) {
      if (resolveLinkTarget(sourceRel, raw) === handoffRel) {
        backlinks.push(sourceRel);
        break;
      }
    }
  }
  return backlinks;
}

// Refuse when tracked durable Markdown still links to the exact handoff. Both
// the pre-merge gate and the closeout guard call this one function with the
// same pinned path, so the resulting refusal summary is identical at either
// gate.
export function guardHandoffBacklinks(repoRoot: string, handoffRel: string): void {
  const backlinks = findHandoffBacklinks(repoRoot, handoffRel);
  if (backlinks.length > 0) {
    refuse("durable Markdown still links to the submitted handoff " + handoffRel + ": " + backlinks.join(", ") + "; remove the backlink before the handoff is consumed");
  }
}
