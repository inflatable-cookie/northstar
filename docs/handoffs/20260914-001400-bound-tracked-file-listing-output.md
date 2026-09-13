---
kind: northstar-handoff
title: "g03.014 — Bound tracked-file listing output"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-14
updated: 2026-09-14
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Tom approved Plan and dispatch on 2026-09-14 after the Bovine closeout ENOBUFS defect was reproduced."
queue:
  capability: general
  skipPRReview: false
  notifyOriginOnCloseout: false
---

## What This Thread Was Doing

The portfolio closeout repair cleared Monkey and Poodle, then Bovine exposed a
separate bound in the same tracked-Markdown backlink scan.

## Why It Matters

Bovine's merged task cannot publish its terminal lifecycle record because the
hook relies on Node's default 1 MiB synchronous-process output buffer. Git and
the repository are healthy; repeating the same hook cannot succeed.

## Current State

- Canonical task: [g03.014](../roadmaps/g03/014-bound-tracked-file-listing-output.md).
- Northstar main includes completed g03.013 at `dcef5df`.
- Bovine task `9c2ca547-5156-4b72-860d-1cff4c4c764a` remains held on its exact
  closeout occurrence and retains all accepted merge/synchronization evidence.
- Monkey and Poodle have completed after the g03.013 installed-skill refresh.

## Boundaries

Change bounded tracked-file discovery, focused fixtures, and matching doctrine
only. Do not edit consumers, bypass hooks, weaken backlink refusal, change
Queue/Effigy, release anything, or touch Paseo threads/workspaces.

## Important Context

Reproduction in the clean Bovine repository: plain `git ls-files -z` exits 0
with 1,797,383 bytes. The current hook call returns status null, SIGTERM,
`ENOBUFS`, 1,114,112 captured stdout bytes, and empty stderr. Add a finite
explicit listing cap, retain the 5,000 Markdown-file and 4 MiB per-file caps,
and surface abnormal process evidence before mutation.

## Suggested Next Move

Start with a fixture whose tracked listing exceeds 1 MiB so the current hook
fails with `ENOBUFS`, then fix the bounded spawn and retain overflow and atomic
refusal controls.

## Completion Protocol

Open one non-draft PR from the Queue workspace. Run lifecycle adoption/core
checks, docs QA, full QA, installed parity, and `git diff --check`. Independent
review must verify the exact head, finite listing cap, Bovine-size success,
overflow refusal, diagnostic, and preserved downstream bounds. After merge,
the Northstar repository hook publishes g03.014. Chatterbox then updates the
global skill and retries the exact retained Bovine hook; the worker performs no
consumer mutation.
