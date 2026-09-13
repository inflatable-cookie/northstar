---
kind: northstar-handoff
title: "g03.012 — Enforce sole-source lifecycle currentness"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-13
updated: 2026-09-13
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Tom said 'Go for it' on 2026-09-13 after Silo g01.071 proved the lifecycle rollout retained stale Ready/frontier prose and a consumed-handoff backlink."
queue:
  capability: complex
  skipPRReview: false
---

## What This Thread Was Doing

Chatterbox checked whether the portfolio bookkeeping simplification had removed
agent-written closeout state. Silo `g01.071` proved that canonical JSON and
generated projections can say complete while legacy task and front-door prose
still say ready.

## Why It Matters

Agents still encounter contradictory planning authority and ask for manual
documentation repair. That defeats the main purpose of hook-owned closeout and
can also leave broken links when the hook consumes a transient handoff.

## Current State

- Canonical task: [`g03.012`](../roadmaps/g03/012-enforce-sole-source-lifecycle-currentness.md).
- `g03.011` is complete at `99bbc94`; Northstar is otherwise in
  `planning_required`.
- The current lifecycle record and generated blocks are correct. The failure is
  unremoved prose outside those blocks and insufficient adoption validation.
- Silo is evidence only. This worker does not edit it or any other consumer.
- Queue origin receives attention only if normal recovery exhausts; routine
  progress and closeout notifications remain disabled.

## Boundaries

Fix Northstar's lifecycle authority, checker, fixtures, starter/doctrine, and
bounded portfolio repair route. Do not edit Queue, Effigy, consumer repositories,
live Queue data, releases, CI, or Paseo threads/workspaces.

## Important Context

Do not solve this by attempting broad natural-language rewriting. Detect exact
mechanical duplicates on the paths Northstar already owns, preserve semantic
history, and make handoff deletion fail atomically when an exact durable backlink
would be broken.

## Suggested Next Move

Start with the three Silo-shaped negative fixtures, then tighten the audit and
closeout guard. Correct Northstar's own stale currentness as the real consumer
proof and publish a reusable dry-run-first portfolio repair route.

## Completion Protocol

Open one non-draft PR from the Queue workspace and report the exact clean head.
Independent review must run the task's focused lifecycle/currentness oracles,
docs QA, complete QA, and installed-skill parity. After merge, the configured
Effigy-hosted hook alone publishes the terminal record, refreshes projections,
and consumes this unreferenced handoff.
