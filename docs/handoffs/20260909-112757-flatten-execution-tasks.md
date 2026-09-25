---
kind: northstar-handoff
title: "Flatten Northstar execution tasks"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: complete
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Operator proposed the flattening and confirmed the resulting design with 'Spot on' on 2026-09-09."
queue:
  capability: general
  skipPRReview: false
---

## What This Thread Was Doing

The operator observed that agents execute batch cards directly while roadmap
milestones mostly duplicate their state. Chatterbox confirmed a direct
pre-1.0 flattening: the generation README remains the roadmap and each
`gNN.NNN` file becomes one executable Northstar task.

## Why It Matters

One execution level should make planning, queue dispatch, closeout, and
generation compaction easier to follow. The change must retain the safety and
evidence carried by cards rather than achieving simplicity by weakening the
task contract.

## Current State

- Canonical task: `g03.003` ([g03 roll-up](../roadmaps/archive/g03.md)).
- Governing contract: [`001`](../contracts/001-working-rules.md), approved
  flattened execution-task model.
- The worker/PR loop is complete. PR #42 was accepted at exact head
  `184937dbb24e3c7eadbd3daa74cc56ff3ba90496` and merged as
  `92f3720576f8bd28b767768011aff8f6507b760a`.
- `g03.002` and `g03.003` are complete; the integration `main` checkout is
  synchronized and no execution successor is approved.
- This is the only approved lane. No concurrent sibling or continuation task.
- Worker profile: automatic adequate implementation pool, general capability;
  frontier-worker justification: none.
- Required sibling worktree links: none.
- Owned and reserved paths are defined by the task dispatch manifest.

## Boundaries

Keep `docs/roadmaps/` and generation IDs. Do not rename the tree to
`docs/tasks/`, modify the Paseo queue plugin, rewrite historical roll-ups, add
compatibility aliases, touch workflows/releases, migrate consumer repositories,
or combine unrelated mode consolidation.

## Important Context

“Task” has three deliberately separate meanings: the committed Northstar
`gNN.NNN` file owns planning; Paseo's queue task transports its handoff; an
Effigy task is a runnable command selector. Current cards 130–133 contain
delivery evidence that must move into tasks 001–002 before deletion. The user
wants less documentation structure, so avoid replacing the removed wrapper
with another permanent layer.

## Suggested Next Move

No further worker action is needed. Return to Chatterbox for the next planning
checkpoint; no successor is approved.

## Completion Protocol

Task `g03.003` completed through PR #42, independent exact-head review,
merge-sync, and synchronized-main closeout. The task and roadmap surfaces now
retain the canonical outcome and evidence. No continuation envelope remains;
queue orchestration owns the final task disposition.

There is no continuation envelope after `g03.003`. The next task is an explicit
Chatterbox planning checkpoint.
