---
kind: northstar-handoff
title: "g03.015 — Bound aggregate backlink scanning"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-14
updated: 2026-09-14
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Tom approved planning and dispatch for the Bovine closeout repair; g03.014's retained retry exposed the next finite scan bound."
queue:
  capability: general
  skipPRReview: false
  notifyOriginOnCloseout: false
---

## What This Thread Was Doing

The g03.014 repair removed Node's default process-output ceiling, then the same
Bovine closeout reached Northstar's older 5,000-Markdown-file refusal.

## Why It Matters

Bovine's 18,190 tracked Markdown files are legitimate and total only 37.52 MiB.
The count-only guard blocks a finite, practical scan and leaves an already
merged task in Closing.

## Current State

- Canonical task: [g03.015](../roadmaps/g03/015-bound-aggregate-backlink-scan.md).
- Northstar main includes completed g03.014 at `a8af8d4`.
- Bovine task `9c2ca547-5156-4b72-860d-1cff4c4c764a` remains held on closeout
  event `9c491d831ad4b1965c8925e89aef7a04b32bddb1d94fdc79`, attempt 3.
- Its clean synchronized repository contains 18,190 tracked Markdown files,
  39,344,682 aggregate bytes, maximum file size 194,658 bytes.

## Boundaries

Change generic finite traversal bounds, focused fixtures, and matching doctrine
only. Do not edit consumers, exclude named paths, partially scan, bypass hooks,
change Queue/Effigy, release anything, or touch Paseo threads/workspaces.

## Important Context

Use the settled combined limits: 25,000 tracked Markdown files, 64 MiB aggregate
Markdown bytes, existing 4 MiB per-file bytes, and existing 4 MiB Git-listing
transport. Preflight sizes before content reads and preserve atomic refusal.

## Suggested Next Move

Adjust the fixture harness so Bovine-shaped aggregate success is cheap and
deterministic, then replace the count-only guard and retain every overflow and
exact-link control.

## Completion Protocol

Open one non-draft PR from the Queue workspace. Run lifecycle adoption/core
checks, docs QA, full QA, installed parity, and `git diff --check`. Independent
review must verify all four finite bounds, preflight atomicity, and no path
special cases. After merge, the Northstar repository hook publishes g03.015.
Chatterbox then updates the global skill and retries the exact retained Bovine
hook; the worker performs no consumer mutation.
