---
kind: northstar-handoff
title: "g03.018 — Consume closed-generation lifecycle fragments"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Operator approved the mechanical lifecycle pruning design and dispatch with 'Go for it' on 2026-09-15."
queue:
  capability: general
  skipPRReview: false
  notifyOriginOnCloseout: false
---

## What This Thread Was Doing

Chatterbox traced unbounded `.northstar/lifecycle/v1/tasks/` growth to the
current `compact` command: it writes a generation receipt but retains every
covered task fragment. The operator approved task `g03.018` to make receipt
publication consume those fragments and to catch up older closed generations
through normal Queue closeout.

## Why It Matters

Closed generations currently keep two live machine representations. The task
makes the compact receipt the bounded current representation while preserving
detailed records in Git history and refusing deletion without exact committed
closure authority.

## Current State

- Canonical task: [`g03.018`](../roadmaps/g03/018-consume-closed-generation-lifecycle-fragments.md).
- Planning base: pushed `main` at `db8dac5` or its exact full commit.
- The lane is ready with no prerequisite Queue task and no concurrent
  Northstar implementation sibling.
- Existing `compact` verifies a closure-pinned task digest and writes a receipt,
  but it neither deletes covered fragments nor replays after they are gone.
- Existing `task.closeout` already owns isolated integration writes and permits
  `.northstar/lifecycle/` changes. Queue source and event contracts need no
  change.

## Boundaries

Own only the lifecycle core, Queue hook adapter, lifecycle schemas and reusable
reference text, focused checks, and task-owned closeout surfaces named in the
dispatch manifest. Do not edit Queue, consumer repositories, active-generation
storage, closure/rollover policy, release/CI files, or Paseo threads and
workspaces. Do not delete any record from an open or `planning_required`
generation or rewrite Git history.

## Important Context

The critical edge is interrupted cleanup. A valid existing receipt plus exact
remaining covered fragments must finish safely; a partial fragment set without
a valid receipt must fail closed. Receipt-only replay must be unchanged. Keep
standalone execution locked and atomic, and let one Queue closeout publish its
current transition plus every eligible historical catch-up mutation in one
commit. Preserve deterministic lexical ordering and exact `changed_paths`.

## Suggested Next Move

Read the task and governing lifecycle reference, inspect the existing compaction
and closeout paths, then implement the smallest shared primitive that satisfies
the task's positive, replay, interrupted-cleanup, and refusal fixtures. Avoid a
second compaction implementation in the Queue adapter.

## Completion Protocol

Use the Queue-provided workspace and branch. Before editing, confirm the
workspace is the assigned checkout, its base contains the required planning
commit, and unrelated changes are absent; report a mismatch through Queue
without resetting, cleaning, deleting, or replacing existing work. Keep commits
on the assigned branch, push it, and open one non-draft PR to `main` from that
exact branch.

Run the focused lifecycle checks during implementation, then `effigy qa`,
`effigy qa:docs`, skill validation and parity checks required by the task, plus
`git diff --check`. Report the exact pushed head, PR, validation, and any
pre-existing failure through the authenticated Queue callback. Stop after
`ready_for_review`; independent exact-head review, merge, installed-skill
refresh, and hook-owned closeout remain Queue-owned.
