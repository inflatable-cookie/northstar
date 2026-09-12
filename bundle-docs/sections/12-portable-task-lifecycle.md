# 12 - Portable Task Lifecycle

Status: active
Updated: 2026-09-12

## Purpose

Give mechanical task state one portable home so closeout stops rewriting facts
that Git, review systems, validation, and orchestration already know. The
contract must work with only the installed skill present.

## Boundary

Semantic planning stays in Markdown: outcome, scope, decisions, acceptance,
stop conditions, execution policy, and UI brief. A versioned per-task JSON
record owns portable mechanical state and delivery evidence. Generated Markdown
blocks are derived views. JSON is canonical when the two disagree.

The lifecycle core is provider-neutral. It may be driven by the standalone
adapter or, later, by a declared orchestration hook. Equivalent facts must
reduce to the same terminal receipt in both modes. The core does not schedule,
dispatch, review, merge, or choose work.

## State model

Task status is one of `planned`, `ready`, `active`, `blocked`, `complete`,
`cancelled`, or `superseded`. Execution stage is `none`, `dispatch`,
`implementation`, `review`, `merge`, or `closeout`. Status answers whether a
task may or did proceed. Stage locates active or blocked work. Terminal
statuses use `none`. Adapter phrases never become a second status vocabulary.

## Artifact set

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json
```

One record per task. Git history preserves prior bodies. The record keeps a
compact applied-event list for idempotency, not a copy of runtime heartbeats or
retries.

## Writes

Authority-changing transitions use exact task and planning identity, stable
event IDs, revision/digest compare-and-swap, canonical JSON, a Git-common-
directory lock, and atomic replacement. Identical retries are no-ops. Stale,
conflicting, dirty, escaping, or interrupted writes fail without changing prior
bytes. Workers and reviewers never write lifecycle state; an integration owner
or declared hook applies it.

## Rendering

Generated blocks use stable sentinels, a schema version, a source digest, fixed
columns, and canonical ordering. Human text outside the sentinels is preserved
exactly. Re-rendering an unchanged receipt set produces no diff.

## Adoption

Adopt records and generated blocks only after the standalone core passes its
own oracle. Keep semantic priority human-owned. Return `planning_required` when
authority does not settle the next move instead of selecting work.

Records begin at the adoption boundary; earlier closed tasks keep their Git
and provider evidence, and no adapter fabricates receipts for them.

## Optional Queue driver

A repository may declare `.paseo/queue.json` using Queue's frozen generic
contracts so Queue events drive the same reducer through a thin repository
hook. Queue stays document-system agnostic: it transports opaque events,
executes a pinned committed launcher without a shell, validates the closed
result, and owns staging, commit, push, and uncertain-effect reconciliation.
It never learns Northstar paths, task IDs, commands, or Markdown.

The hook adapter translates generic events into the same canonical
transition envelopes the standalone adapter submits, preserves evidence
levels exactly (provider facts attested, Git facts locally verified), and
reduces a terminal receipt equivalent to the standalone path from equivalent
facts. A repeated event is a no-diff replay. Required hooks that fail or
diverge hold the transition visibly instead of silently degrading.

Equivalent standalone and hook executions must produce the same portable
digest. Two permanent closeout routes are forbidden: hand-maintained status
fields retire together with their callers once generated projections carry
them.
