---
kind: northstar-handoff
title: "g03.019 — Accept prospective-merge Queue events"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Tom explicitly authorized this urgent Northstar compatibility dependency with 'Go for it' through the Queue Chatterbox on 2026-09-15."
queue:
  capability: general
  skipPRReview: false
  notifyOriginOnCloseout: false
---

## What This Thread Was Doing

Queue g01.031 added the accepted `prospective_merge` pre-merge target. Its first
live Bovine run failed closed because Northstar's canonical and installed hook
know only event v1/v2 and control v1-v3. Tom authorized the smallest
Northstar-owned protocol compatibility task.

## Why It Matters

Bovine g03.029 is otherwise accepted and stable, but cannot merge until the
repository policy hook can validate Queue's v3 candidate payload. A partial
event-only fix would immediately fail on the corresponding v4 binding, so both
closed mirrors and their correlation belong in this lane.

## Current State

- Canonical task: [`g03.019`](../roadmaps/g03/019-accept-prospective-merge-queue-events.md).
- Required pushed planning base: `64bf87a6275a67bc354ed22acd53be63e042398f`.
- Accepted provider contract: Queue main `4443185`, Spec 015 and its
  `shared/hooks.ts` event-v3/control-v4 definitions.
- Retained canary: Queue task `4e30ee69-fd4f-4e84-a94e-3cc9a7beff6f`, Bovine
  PR #840, reviewed head `a7cf961b880282626fd8c3738ebefcb5d1ffbf30`.
- The canary is `needs_attention` with no active run or merge intent. Do not
  touch it from this workspace.

## Boundaries

Own Northstar's frozen Queue schema mirrors, lifecycle hook parser and
target-specific pre-merge checks, focused fixtures, reusable reference text,
and task-owned closeout surfaces. Do not edit Queue or Bovine, weaken backlink
policy, change lifecycle transitions, alter old schema bytes, publish releases,
or dispose of any thread or workspace.

## Important Context

Preserve the reviewed-head path exactly. The new prospective path runs from a
Queue-owned candidate checkout: its HEAD and tree must match the declared
candidate, repository base must match `integrationBase`, delivery head must
match `reviewedHead`, and the candidate parents must be base then head. Reuse
the existing pinned-instruction and backlink resolver after those proofs.

## Suggested Next Move

Read the canonical task and Queue's pinned Spec 015/schema implementation. Add
the strict v3/v4 mirrors first, then extend the binding and pre-merge target
checks with positive and refusal fixtures. Keep the shared policy result and
read-only behavior unchanged.

## Completion Protocol

Use the Queue-provided workspace and branch. Confirm it contains the exact
planning base and has no unrelated changes before editing. Report any mismatch
through Queue without resetting, cleaning, deleting, or replacing work. Commit
and push only on the assigned branch, then open one non-draft PR to `main`.

Run focused lifecycle adoption and hook checks, `effigy qa`, `effigy qa:docs`,
skill validation, isolated installed-parity/update proof, and `git diff
--check`. Report the exact pushed head, PR and validation through the
authenticated Queue callback, then stop at `ready_for_review`. Independent
exact-head review, merge and hook closeout stay Queue-owned. The live global
skill refresh, parity proof, and retry of the exact retained Bovine task happen
only after merge; preserve every Bovine identity until then.
