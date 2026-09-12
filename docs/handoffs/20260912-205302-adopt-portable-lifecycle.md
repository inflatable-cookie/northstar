---
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
base_required: pushed-main
title: Implement g03.006 portable lifecycle adoption
queue_dispatch: northstar-queue
queue_approval: "Tom explicitly said 'Authorised' after g03.006 became the sole ready frontier on 2026-09-12."
queue:
  capability: complex
---

## What This Thread Was Doing

Northstar shipped the provider-neutral lifecycle core in `g03.005`, then waited
for Queue to expose a document-system-agnostic repository hook boundary. Queue
contract v1 is now merged, installed, and available. This lane adopts the
portable records and projections, adds Northstar's thin hook adapter and starter
manifest, proves both execution paths agree, and earns the mechanical closeout
cutover described by [`g03.006`](../roadmaps/g03/006-adopt-portable-lifecycle.md).

## Why It Matters

Agents still spend time copying delivery facts into task files, indexes, and
front doors. Northstar now has the reducer and Queue now has generic hooks, but
the two are not connected. This lane makes the standalone path useful in real
repositories and lets Queue drive the same state machine without either product
depending on the other's internal document structure.

## Current State

- Required starting head: `5687e91a7e1f2206a5d8457c6ba7222829b84575`
  on pushed `main`.
- Active spec: [`040-portable-task-lifecycle.md`](../specs/040-portable-task-lifecycle.md).
- Ready task: [`g03.006`](../roadmaps/g03/006-adopt-portable-lifecycle.md), the
  sole approved frontier.
- Queue prerequisite: task `3ca4a65b-dfde-4d2d-85c1-df4ccb68ea4a`, accepted
  head `0f9b1bb34eb441dbecac8f741e60a66562c69d07`, merge
  `7da4eeba73c4f1ce7d8c7967acd6e11fbf83c7f6`.
- Queue contract schemas are `paseo.queue.control.v1`,
  `paseo.queue.event.v1`, and `paseo.queue.hook-result.v1`. Events are
  `task.pre_dispatch`, `task.blocked`, `task.cancelled`, and `task.closeout`.
- Queue was installed from clean main at
  `2c528543b00147556acd4a5ed74b3784d0fee056`; the plugin log records a
  successful reload after that commit.
- No concurrent Northstar lane or automatic successor is approved. Worker
  capability is the automatic adequate `complex` pool; no frontier profile is
  required. Required sibling worktree links: none.

## Boundaries

- Implement the complete `g03.006` scope in Northstar only. Do not edit the
  Queue repository or its database, task state, settings, profiles, limits,
  subscriptions, threads, or workspaces.
- Preserve Queue's generic contract. Northstar may parse its own committed
  handoff and task, but Queue must not gain Northstar paths, IDs, commands,
  Markdown grammar, or lifecycle vocabulary.
- Do not reconstruct `g03.001` through `g03.005` as lifecycle records. The live
  adoption boundary begins with `g03.006`.
- Do not let the worker or reviewer write live lifecycle records or generated
  currentness blocks. The merged required `task.closeout` hook owns the shadow
  write under Queue's integration turn.
- Do not retire semantic planning, outcome, acceptance, limitation, priority,
  or continuation prose. Remove only fields displaced by canonical JSON and
  deterministic generated blocks after parity passes.
- Do not add a shared ledger, Queue-specific statuses, shell interpolation,
  remote webhooks, automatic semantic task selection, CI changes, releases,
  history rewrites, or compatibility aliases that preserve two permanent
  closeout routes.
- Treat the task's stop conditions as real. If Queue event v1 cannot support an
  honest terminal receipt, or this task cannot safely prove its own cutover,
  complete only the independently valid adapter/equivalence portion and return
  the exact gap to Chatterbox for one bounded cutover task.

## Important Context

- The existing core is in `skills/northstar/scripts/lifecycle-core.ts`; its
  Draft 2020-12 schemas live under `skills/northstar/references/lifecycle/`.
  The `g03.005` review noted that explicit-path `render` and `compact` do not
  re-check containment. Repair that before live adoption.
- Queue reads `.paseo/queue.json` from the exact clean integration commit,
  directly executes a pinned regular executable with literal argv, and owns
  validation, staging, commit, push, and uncertain-effect reconciliation. The
  hook must only edit and report declared paths.
- Queue emits `task.closeout` after merge, synchronized-main verification, and
  accepted legacy closeout evidence, before marking the task done. Its delivery
  object supplies PR identity, reviewed head, an adapter-attested verification
  summary, merge commit, integration commit, and closeout summary. Preserve
  their actual evidence levels. The hook event position may attest that Queue's
  gates passed; it does not make provider facts locally verified.
- This task is the bootstrap case: no repository hook existed at pre-dispatch.
  The closeout adapter may deterministically reduce the canonical sequence from
  the ready planning identity to a terminal record using derived stable event
  IDs, but it must not fabricate transient observations or claim earlier live
  tracking.
- The live `task.closeout` binding should be required and integration-write once
  the implementation oracle passes. The current task's legacy closeout runs
  first and is the one-time shadow source; the hook then publishes the portable
  record and generated projections. A failed or divergent hook must hold the
  task visibly for diagnosis rather than silently declaring cutover.
- Portable equivalence means the same canonical portable fields and
  `portable_digest`. Isolated source-adapter metadata and durable idempotency
  event IDs may differ.
- Keep human text outside generated sentinels byte-exact. Currentness views may
  lag live Queue activity, but they must never claim unproved review, merge, or
  completion.

### UI Design Brief

Not applicable; this lane has no user interface.

## Suggested Next Move

Start by reading spec 040, `g03.006`, the existing lifecycle core/oracle, and
Queue contract 005/spec 001 at the exact installed revision. Write failing
containment, multi-target, adapter, bootstrap-closeout, and terminal-equivalence
fixtures before adding the hook adapter or manifest. Prove the generic event
contains enough evidence at the preserved levels before changing closeout
doctrine.

## Completion Protocol

### Worker and PR flow

Use the launcher-provided worktree after normal worker preflight. Reconfirm the
starting head contains this exact handoff and that the planning base is an
ancestor. Implement the full task oracle, run an adversarial semantic pass,
commit the coherent change, push the Queue-owned branch, and open one non-draft
PR against `main`.

Report `ready_for_review` through the supplied Queue callback with the PR number
and exact head. Stop after the callback is accepted. Do not create a reviewer,
merge, reload plugins or installed skills, mutate Queue state manually, or
perform integration closeout. Queue owns independent review, merge,
synchronized-main verification, legacy closeout, and the declared closeout
hook.

### Validation and evidence

Run the focused lifecycle/adoption/equivalence fixtures first, including an
isolated installed consumer and a non-Queue standalone path. Then run source /
installed parity, `effigy qa:docs`, `effigy qa`, and `git diff --check` on the
final exact head. The independent reviewer must apply every `g03.006` oracle
row, inspect the executable manifest boundary, and verify the PR does not claim
live cutover before the required shadow hook publishes matching evidence.

After merge, the integration closeout must keep the current task's one-time
manual closeout evidence, allow the required generic hook to publish the
`g03.006` lifecycle record and declared projections, verify the published
portable digest and repeat no-diff behavior, then record either successful
cutover or the exact bounded successor needed. No automatic successor is
authorized.
