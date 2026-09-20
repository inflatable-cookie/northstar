---
title: g03.021 — Converge terminal closeout authority
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-20
updated: 2026-09-20
base_required: pushed-main
roadmap: docs/roadmaps/g03/021-converge-terminal-closeout-authority.md
queue_dispatch: northstar-queue
queue_approval: "Tom approved g03.021 as the next g03 lane and directed dispatch on 2026-09-20 after relaying Queue's g01.019 dependency ask."
queue:
  capability: complex
  skipPRReview: false
  notifyOriginOnCloseout: true
---

## What This Thread Was Doing

Converging terminal closeout authority in the installed lifecycle adapter, so a
required `task.closeout` publishes one lifecycle authority instead of leaving a
second one beside it.

## Why It Matters

Queue's `g01.019` is approved planning but blocked on this adapter revision.
Today the adapter can detect the duplicate-status-header class and can write a
task file that already carries a generated block, but nothing removes the
superseded `Status:` marker and the closeout hook never runs the currentness
check. Market's `g05.064`/`g05.065` closed out cleanly on a clean `main` and
still left two authorities behind. Fixing the adapter is what makes the Queue
lane dispatchable; no consumer repair holds while closeout can reintroduce the
defect.

## Current State

- Northstar `main` is clean at the planning commit containing this handoff. The
  canonical card is `docs/roadmaps/g03/021-converge-terminal-closeout-authority.md`;
  it owns the outcome, decisions, owned paths, work and oracle, and this handoff
  does not restate them.
- Read before editing: Queue Spec 006 at `759cf2d`
  (`docs/specs/006-terminal-closeout-projection-convergence.md` in the Queue
  repository), the lifecycle reference
  (`skills/northstar/references/lifecycle/README.md`), contract 001, and the
  `g03.007`, `g03.010` and `g03.012` cards.
- The installed closeout publication is already one commit and already includes
  the task path as a projection target whenever that file carries a generated
  lifecycle block. `handleCloseout` in
  `skills/northstar/scripts/lifecycle-queue-hook.ts` never references the
  currentness audit, which lives in `lifecycle-core.ts` as
  `auditCurrentnessText`/`auditCurrentness` and reports `duplicate-status-header`.
- Dispatched alongside this lane: consumer manifest migrations in other
  repositories, each owning only its own `.paseo/queue.json`, with no shared
  mutable or closeout surface. Closeout surfaces for this lane are the card's
  reserved list.
- Model capability: complex-capable pool selected by standard automatic routing.
  Frontier-worker justification: none; Queue Spec 006 already fixes the
  boundary.
- Required sibling worktree links: none.

## Boundaries

- Own only the card's declared paths. The adapter keeps owning marker syntax,
  the matching rule and the ownership test; Queue keeps parsing nothing.
- Do not edit Queue, any consumer repository, or an already-red consumer's
  history; do not roll the generation; do not touch release or CI surfaces.
- Do not weaken exact changed-path or allowed-path publication, and do not
  reinterpret an in-flight Queue occurrence under a new runner.
- If the refusal set cannot be distinguished from human prose, stop and return
  the lane to Chatterbox instead of guessing at a matching rule.

## Important Context

- Convergence is removal, not restatement. The generated projection is the sole
  mechanical currentness, so the superseded marker goes. That is already
  Northstar doctrine; this lane makes closeout enforce it instead of leaving it
  to a later repair task.
- Refusal beats removal: an ambiguous status-looking line, a symlinked or
  non-regular task path, an undeclared path, or a changed planning blob refuses
  before byte changes or commit intent.
- Replay stays byte-stable. The same event against a terminal record is a
  no-diff replay with no second marker or changed path.
- The prospective check runs over the complete prospective projection before the
  hook returns `ok`; a red result blocks closeout with the bounded
  file/section/task/reason diagnostics.
- Queue pins the accepted revision, so the closeout evidence should name the
  commit and the installed interface identity it resolves from.

## Suggested Next Move

Start in core with the marker rule: one shared exported definition of the exact
`Status:` header shape the audit already attributes to a lifecycle-managed task
path, plus the bounded ownership test. Then wire convergence and the prospective
check into the closeout path, and add the refusal and replay fixtures before
touching the lifecycle reference.

## Completion Protocol

- Prove the card's oracle: one synthetic commit out with a clean
  `lifecycle:run audit-currentness`; byte-stable replay; two sequential
  closeouts after a repair stay clean; every refusal case blocks publication.
- Run the focused lifecycle-core and lifecycle-adoption self-tests, then
  `effigy qa`, then `git diff --check`, keeping v1-v3 event and manifest
  compatibility green.
- Commit only the declared paths, push one non-draft PR, and report
  `ready_for_review` through the authenticated Queue callback. Independent
  review uses another provider/model identity.
- Do not merge, refresh the installed skill, touch Queue or consumers, or publish
  a release. After closeout, the accepted commit and its installed interface
  identity go to the Queue Chatterbox for `g01.019`; that handoff is Chatterbox's
  step, not a further task here.
