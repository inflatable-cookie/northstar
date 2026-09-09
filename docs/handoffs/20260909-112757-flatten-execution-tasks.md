---
kind: northstar-handoff
title: "Flatten Northstar execution tasks"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
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

- Canonical task: [`g03.003`](../roadmaps/g03/003-flatten-execution-tasks.md).
- Governing contract: [`001`](../contracts/001-working-rules.md), approved
  flattened execution-task model.
- Planning is ready on pushed `main`; `g03.002` is complete.
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

Start from synchronized `main`, read task `g03.003` and its governing contract,
then inventory every active caller of roadmap milestones, batch cards, and
`batch-cards/`. Freeze the deletion/evidence map before editing. Implement the
coherent migration and validate the resulting single-level consumer shape.

## Completion Protocol

Follow task `g03.003` for scope, acceptance, validation, stop conditions, and
closeout. Work in the launcher-provided non-main worktree after the worker
startup preflight. Open one PR, leave the workspace and branch clean, and
report the PR plus exact head to queue orchestration. An independent reviewer
must accept that exact head before merge. Queue orchestration owns review,
merge, synchronized-main reconciliation, task/front-door closeout, handoff
disposition, and final status. Pause on a task stop condition and return the
complete blocker through the queue; do not ask the operator from the worker.

There is no continuation envelope after `g03.003`. The next task is an explicit
Chatterbox planning checkpoint.
