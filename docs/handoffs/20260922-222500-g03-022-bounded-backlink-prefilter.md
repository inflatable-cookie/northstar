---
title: g03.022 — Scale the handoff backlink guard past corpus-size bounds
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-22
updated: 2026-09-22
base_required: pushed-main
roadmap: docs/roadmaps/g03/022-bounded-backlink-prefilter.md
queue_dispatch: northstar-queue
queue_approval: "Tom approved g03.022 on 2026-09-22 ('Go for it') through the Bovine Chatterbox; the Northstar Chatterbox is closed."
queue:
  capability: complex
  skipPRReview: false
  notifyOriginOnCloseout: true
---

## What This Thread Was Doing

Making the lifecycle handoff backlink guard scale with the files that mention a
handoff, not with the whole Markdown corpus.

## Why It Matters

The guard runs at pre-merge and closeout for every Queue task. It lists every
tracked file and reads every Markdown file. Bovine blocked merges at the 64 MiB
aggregate bound on 2026-09-22 (`fa510fd` raised it to 128 MiB). Bovine is at
21,073 Markdown files of a 25,000 bound, and its `git ls-files` listing is
2.4 MB of a 4 MiB bound. It will pass 100,000 files. Each bound is a merge
outage for every consumer that crosses it.

## Current State

`findHandoffBacklinks` in `skills/northstar/scripts/lifecycle-backlink.ts`
runs `git ls-files -z`, filters `.md`, enforces file, listing, per-file and
aggregate bounds, then parses every file for inline, autolink and
reference-style links resolving to the handoff path. Hook-generated blocks are
stripped first. `scripts/tests/lifecycle-adoption/self-test.sh` asserts the hook
carries no second parser or bounds.

## Boundaries

Implement the roadmap card's Work list only. Same results on every existing
fixture; same refusal wording at both gates. No Queue, consumer or CI edits.

## Important Context

The prefilter is sound only if every resolvable link form carries the handoff
basename literally. Where it may not (escaped characters), fall back to the full
scan for that handoff. Keep bounds on the hit set so a pathological hit set
still refuses. UI Design Brief: not applicable.

## Suggested Next Move

Read `lifecycle-backlink.ts` and its fixtures, then write the equivalence
fixtures before changing the scan.

## Completion Protocol

Confirm the queue worktree. Merge current `main` before editing. Run the
lifecycle self-tests. One non-draft PR. Independent review. Report the install
step for the installed skill.
