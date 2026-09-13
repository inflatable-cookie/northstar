---
title: g03.008 — Pin Queue hook runtime
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-13
updated: 2026-09-13
base_required: pushed-main
roadmap: docs/roadmaps/g03/008-pin-queue-hook-runtime.md
queue_dispatch: northstar-queue
queue_approval: "Corrective continuation of Tom's authorization to finish the hook-only closeout cutover; g03.007 reached Queue done but missed its explicit handoff-consumption acceptance row because the pinned launcher invoked stale global code."
queue:
  capability: complex
  skipPRReview: false
---

## What This Thread Was Doing

Implement [`g03.008`](../roadmaps/g03/008-pin-queue-hook-runtime.md): make the
Queue lifecycle executable close over repository-committed runtime bytes, then
repeat the self-hosted closeout proof with this task.

## Why It Matters

`g03.007` proved Queue's hook-only terminal transition but exposed a false
pinning boundary. The committed launcher resolved the mutable global Northstar
installation, so it ran old adapter code and left the submitted handoff in the
tree. A repository commit cannot be an execution oracle while implementation
bytes come from outside that checkout.

## Current State

- Repository: `/Users/tom/Dev/projects/northstar`.
- Canonical task: [`g03.008`](../roadmaps/g03/008-pin-queue-hook-runtime.md), the
  sole approved frontier.
- `g03.007` is terminal in Queue and its published hook event is immutable.
  Preserve its lifecycle JSON and receipt.
- The exact stranded handoff is
  `docs/handoffs/20260912-235520-finish-hook-owned-closeout.md`.
- Queue's required integration-write `task.closeout` hook remains the sole
  closeout authority. This task must close through it.
- Worker capability: automatic `complex` pool. Independent review must use a
  distinct provider/model identity.
- Required sibling worktree links: none.

## Boundaries

Implement the complete `g03.008` task. Keep standalone Northstar first-class,
Queue document-agnostic, published `g03.007` evidence immutable, and all live
hook implementation/schema bytes inside the synchronized repository checkout.

Do not edit Queue source or database state, update the global skill as the
repair, replay or rewrite `g03.007`, invent terminal evidence, migrate consumer
repositories, add UI, edit CI, release, force-push, or remove any thread or
workspace. Do not perform manual post-merge closeout edits; the required hook
owns this task's terminal publication and exact handoff deletion.

## Important Context

- `.paseo/hooks/northstar-lifecycle` is pinned by Queue but currently searches
  `$HOME/.agents/skills/northstar` and `$HOME/.pi/agent/skills/northstar`.
- The source adapter added exact handoff consumption in `g03.007`; the installed
  adapter did not contain that change. Pinning only the launcher blob is
  therefore insufficient.
- The copy-ready starter must work in repositories that do not contain the
  Northstar source tree. Carry or generate a complete committed runtime payload
  and reject drift from the canonical source.
- Remove the known `g03.007` handoff in the implementation PR with an honest
  limitation note. The fresh oracle is this task's own hook-only closeout.

## Suggested Next Move

Map the adapter's transitive runtime closure first: core module, validation
schemas, launcher, and Bun assumptions. Choose the smallest committed capsule
or deterministic build that works in both this repository and a copy-only
consumer, then add stale-global and parity negatives before changing doctrine.

## Completion Protocol

Use the launcher-provided worktree and verify its clean Queue-owned branch
before editing. Implement every work and oracle row in `g03.008`. Run focused
runtime-closure, stale-global, starter-copy, lifecycle equivalence, handoff
containment, and installed-consumer checks; then `effigy qa:docs`, `effigy qa`,
`effigy check:posture-advisory`, and `git diff --check`.

Commit only authorized paths, push the Queue-owned branch, open one non-draft
PR against `main`, and report `ready_for_review` through the supplied
authenticated Queue callback with the PR number and exact clean head. Stop
after acceptance. Do not merge, install skills globally, edit integration main,
or write closeout evidence. Queue owns independent review, merge,
synchronized-main reconciliation, and the required hook publication.
