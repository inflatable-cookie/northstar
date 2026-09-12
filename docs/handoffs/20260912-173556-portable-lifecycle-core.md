---
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
base_required: pushed-main
title: Implement g03.005 portable lifecycle core
queue_dispatch: northstar-queue
queue_approval: "Operator said 'Go for it' in the originating Chatterbox after approving canonical g03.005 planning on 2026-09-12."
queue:
  capability: complex
---

## What This Thread Was Doing

We designed a mechanical task-lifecycle layer that removes routine agent-written
bookkeeping without making Northstar depend on Paseo Queue. The settled design
keeps semantic planning in Markdown, puts portable mechanical state in
per-task JSON, and renders deterministic machine-readable Markdown views.

This worker lane implements the provider-neutral core and standalone path in
[`g03.005`](../roadmaps/g03/005-portable-lifecycle-core.md). Queue hooks and live
repository migration come later.

## Why It Matters

Closeout currently spends capable-agent effort copying facts already known to
Git, review systems, validation, or orchestration state. A safe standalone core
lets scripts perform that work consistently. The same contract will later let
Queue add its database and recovery benefits through generic repository hooks
without either product importing the other.

## Current State

- Planning base: `3469e41c04971cdb8e5cc1ad9bc264ebf5d2cadf` on pushed `main`.
- Active spec: [`040-portable-task-lifecycle.md`](../specs/040-portable-task-lifecycle.md).
- Ready task: [`g03.005`](../roadmaps/g03/005-portable-lifecycle-core.md), the
  sole approved frontier.
- Earlier `g03.001` through `g03.004` tasks are complete.
- No concurrent sibling lane is approved. Queue repository work is serial after
  this contract freeze and belongs to that repository's planning authority.
- Worker capability: automatic adequate `complex` pool. Frontier-profile
  justification: none; no by-request profile is required.
- Required sibling worktree links: none.

## Boundaries

- Implement only the Northstar core, standalone adapter, renderer, reusable
  doctrine, starter guidance, fixtures, and validation wiring owned by
  `g03.005`.
- Do not edit the Queue repository, add `.paseo/queue.json`, migrate this
  repository's live status authority, or retire the current closeout process.
- Do not stage or edit reserved architecture, contract, spec, roadmap,
  front-door, or closeout surfaces. The integration closeout owns them.
- Do not add automatic Git staging, commits, pushes, dispatch, review, merge,
  task selection, remote webhooks, daemon state, or a shared task ledger.
- Do not edit `.github/workflows/`, perform a release, rewrite history, or add a
  compatibility route around superseded behavior.
- Stop on any condition named in the task or spec instead of weakening the
  portability, evidence, or atomicity boundary.

## Important Context

- The durable architecture and behavior are already promoted in
  [`system-architecture.md`](../architecture/system-architecture.md) and
  [`contract 001`](../contracts/001-working-rules.md). Spec 040 owns exact
  schema, transition, projection, standalone-write, and later hook boundaries.
- Keep task status separate from execution stage. Adapter phases and Queue
  terminology cannot enter the portable status vocabulary.
- Evidence must retain its actual level: locally verified, adapter-attested, or
  operator-authorized. Never upgrade an attestation into independent or
  cryptographic proof.
- JSON is canonical. Markdown projections use stable sentinels, fixed grammar,
  canonical ordering, source digests, normalized bytes, and exact preservation
  of human-owned text outside generated blocks.
- The installed skill must run without Paseo, Queue, network access, or the
  Northstar source checkout. Follow the repository's TypeScript/Bun automation
  default unless a concrete constraint justifies another runtime.
- Use separate per-task paths, Git-common-directory locking, revision/digest
  compare-and-swap, temporary-file flush and atomic rename. A failed operation
  preserves prior bytes.
- The task's acceptance table is the review oracle. Deterministic checks prove
  structure and state behavior; they do not grant semantic acceptance.

## Suggested Next Move

Start with the task and spec, then inspect the existing installed-skill
catalogue, JSON-schema checks, language-package lifecycle CAS implementation,
and fixture conventions for reusable patterns. Define the schemas and failing
transition/atomicity fixtures before filling in the reducer and renderer. Keep
the public surface narrow and machine-readable.

## Completion Protocol

### Worker and PR flow

Use the launcher-provided worktree after the worker-mode preflight. Reconfirm
that its starting `HEAD` contains this exact handoff and that the planning base
is an ancestor. Implement the complete `g03.005` scope, run a semantic
adversarial pass against every acceptance row, commit the coherent change, push
the queue-owned branch, and open a non-draft PR against `main`.

Report `ready_for_review` through the supplied Northstar Queue callback with the
PR number and a self-contained summary. Stop after the callback is accepted.
Do not create a reviewer, merge, update Queue state manually, or perform
integration closeout.

### Validation and evidence

Run the focused lifecycle fixtures first, then source/install parity,
`effigy qa:docs`, `effigy qa`, and `git diff --check` on the final exact head.
The PR description should link spec 040 and `g03.005`, state the observable
standalone behavior, and name any genuine limitation without implying that
Queue integration or live authority migration shipped.

The independent reviewer will review the exact PR head against the task's full
oracle. Queue owns merge, synchronized-main verification, and the existing
manual closeout. After merge, the lane returns to Chatterbox; no successor is
authorized automatically.
