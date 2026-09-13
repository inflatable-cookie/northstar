---
title: g03.009 — Separate planning required from generation closure
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-13
updated: 2026-09-13
base_required: pushed-main
roadmap: docs/roadmaps/g03/009-separate-planning-required-from-generation-closure.md
queue_dispatch: northstar-queue
queue_approval: "Tom explicitly requested that completing the current work put a generation into planning_required rather than complete or implied rollover on 2026-09-13."
queue:
  capability: complex
  skipPRReview: false
---

## What This Thread Was Doing

Implement [`g03.009`](../roadmaps/g03/009-separate-planning-required-from-generation-closure.md):
separate an exhausted runway from deliberate generation closure throughout the
lifecycle, projections, compaction gate, doctrine, and starter.

## Why It Matters

Finishing the currently planned tasks only means Northstar needs another
planning decision. Treating that moment as generation completion pushes agents
toward unnecessary rollover and lets the compactor accept a generation that is
still the correct sequencing era.

## Current State

- Repository: `/Users/tom/Dev/projects/northstar`.
- Canonical task: [`g03.009`](../roadmaps/g03/009-separate-planning-required-from-generation-closure.md),
  the sole approved frontier.
- `g03.008` is done through the repository-pinned hook runtime at `305700c`;
  its exact handoff is absent and no closeout agent/workspace was created.
- The active generation is `g03`. Its adopted task records are terminal, but
  no rollover decision exists and `g03` must remain open.
- The reducer has a `planning_required` frontier result. Generated Markdown
  omits it, and compaction currently treats terminal records as sufficient
  closure evidence.
- Worker capability: automatic `complex` pool. Independent review must use a
  distinct provider/model identity.
- Required sibling worktree links: none.

## Boundaries

Implement the complete `g03.009` task. Preserve human ownership of roadmap
intent and rollover, deterministic machine-owned task/runway state, standalone
Northstar operation, and Queue's generic boundary.

Do not edit Queue source or database state, open `g04`, compact `g03`, choose or
invent the next task, fabricate old records, migrate consumer repositories, add
UI, edit CI, release, force-push, or remove any thread or workspace. Do not
perform manual post-merge closeout edits; the required hook owns the terminal
record, projections, and exact handoff deletion.

## Important Context

- Treat generation disposition and runway state as separate axes. `complete`
  must not remain an available generation label.
- `planning_required` is the expected state when all approved work is terminal;
  it keeps the same generation open and routes the decision to Chatterbox.
- Compaction is destructive lifecycle maintenance. It must consume explicit
  closure authority, not infer it from an empty frontier.
- The runtime is now copied under the repository hook path. Update it only
  through `skills/northstar/scripts/lifecycle-runtime.ts` and keep dogfood,
  starter, and canonical bytes in parity.
- This task's own closeout is the natural live proof: after publication `g03`
  remains open and its generated runway state is `planning_required`.

## Suggested Next Move

Start with the state table and closure authority. Freeze exact precedence and
the compaction negative before changing projection bytes or prose. Then update
the versioned schema/runtime payload and use the active `g03` closeout as the
end-to-end oracle.

## Completion Protocol

Use the launcher-provided worktree and verify its clean Queue-owned branch
before editing. Implement every work and oracle row in `g03.009`. Run focused
lifecycle state, projection, permutation, compaction-authority, runtime parity,
standalone consumer, and self-hosting checks; then `effigy qa:docs`,
`effigy qa`, `effigy check:posture-advisory`, and `git diff --check`.

Commit only authorized paths, push the Queue-owned branch, open one non-draft
PR against `main`, and report `ready_for_review` through the supplied
authenticated Queue callback with the PR number and exact clean head. Stop
after acceptance. Do not merge, edit integration main, or write closeout
evidence. Queue owns independent review, merge, synchronized-main
reconciliation, and the required hook publication.
