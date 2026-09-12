# Mechanical lifecycle state

Status: open; design exploration
Owner: Northstar Chatterbox
Source: operator discussion, 2026-09-12

## Problem

Northstar still spends capable-agent effort rewriting lifecycle facts across a
task, generation runway, front doors, evidence text, handoff disposition, and
spec state. Closeout is the clearest example. Most facts already exist in Git,
the provider, validation output, or the queue; prose projection adds cost,
latency, and drift.

The replacement must preserve semantic planning, portable operation, exact-head
evidence, and safe generation compaction. It must also let independent PR lanes
merge without sharing a bookkeeping file.

## Boundary

Keep human-authored Markdown for meaning:

- outcome and user value;
- architecture and contracts;
- task scope, decisions, acceptance, stop conditions, and UI brief;
- operator-owned priority and semantic next-task choices;
- material limitations that need judgment.

Move deterministic lifecycle facts to structured state:

- task state and transition time;
- dependencies and approved frontier membership;
- dispatch, worker, workspace, PR, review, exact-head, merge, and sync identity;
- validation receipts;
- block, pause, retry, supersession, and cancellation disposition;
- handoff consumption;
- closeout completeness and eligible next tasks;
- generation closure and compaction eligibility.

A tool may compute eligible work. It must not invent priority, architecture, a
next semantic lane, or whether unique meaning is safe to discard.

## Storage options

### One repository ledger

One JSON file is easy to query and validate, but every task and merge edits the
same path. It creates a permanent merge hotspot, makes stale writes easy, and
couples unrelated generations. Reject as the canonical write model.

### One mutable state file per task

`gNN.NNN` gets one JSON state file. Different tasks do not conflict, and a
compare-and-swap version can reject stale writes to the same task. Git history
provides an audit trail. This is the simplest viable model, but concurrent
writes from separate checkouts can still fork from the same version and are
detected only when they meet.

### Immutable transition fragments

Each accepted transition writes a uniquely named JSON fragment. Independent
tasks and independent events merge cleanly. A deterministic reducer builds the
current task and generation view. This preserves provenance and makes retry
idempotency explicit, but increases file count and requires fork/conflict
validation plus generation compaction.

### Queue-backed live state

Northstar Queue already implements most of the required live lifecycle engine:
versioned tasks, dependencies, role runs, coordinator generations, callbacks,
idempotent receipts, exact-head review, merge reconciliation, retries,
supersession, and closeout. Its SQLite store gives the transactional behavior
that a Git-backed script would otherwise have to rebuild badly.

Queue state cannot be Northstar's only authority. It belongs to one Paseo
installation, contains operational detail that should not be copied into Git,
and is unavailable to manual or alternative orchestrators. Treat Queue as the
first live adapter to a provider-neutral Northstar lifecycle contract.

## Tentative recommendation

Use two tiers rather than a second lifecycle engine:

1. Queue, or another orchestrator, owns live transactional execution.
2. Northstar owns a portable lifecycle interchange contract, terminal receipts,
   validation, and deterministic repository projections.

Bind every Queue task to a canonical Northstar task ID and path. Do not infer
`gNN.NNN` from the handoff name, branch, workspace, or prompt. At
authority-changing points, the adapter passes a versioned payload to the
Northstar lifecycle command. The happy-path closeout payload records accepted
implementation and review heads, merge and synchronized-main identities,
validation, handoff disposition, and final task state.

Store one compact receipt per task rather than copying Queue's complete event
stream into Git:

```text
.northstar/lifecycle/v1/
  tasks/g03.004.json
  generations/g03.json       # optional derived projection
```

The task receipt should carry:

- schema version, canonical task ID and path;
- receipt version, state, actor, and source (`manual`, Queue, provider, CI);
- planning authority commit;
- implementation, review, merge, and synchronized-main identities;
- idempotency key and creation time;
- validation evidence and handoff disposition;
- durable limitation, block, cancellation, or supersession when applicable.

Queue keeps high-volume operational events in its live store. Git keeps the
portable facts needed to understand and verify the result after Queue is gone.
Optional transition receipts may preserve durable nonterminal dispositions or
support manual operation, but they are not the default write shape.

The Northstar command rejects stale receipt versions, duplicate idempotency
keys with different content, illegal transitions, review/head mismatch, merge
without accepted exact-head review, and closeout without merge and validation
evidence. A manual adapter must emit the same payload as Queue.

## Concurrency and merge shape

- Workers do not edit global front doors or lifecycle state in their PRs.
- Queue's task version, coordinator generation, callback receipts, and role-run
  ownership protect live execution. Northstar should reuse those guarantees,
  not reproduce them in Rhai.
- Different tasks write different receipt paths. A receipt update uses an
  expected prior version or digest; same-task stale writes fail.
- Code PRs can merge without waiting for prose closeout. The integrator records
  merged facts on synchronized `main`, either after each merge or as one batch
  for several already-merged lanes.
- A global currentness index is generated from task receipts. Workers never edit it.
  Prefer computing it on demand; if a human-readable projection is committed,
  one integration writer regenerates it after merges and it remains derived,
  never canonical.
- Closing a generation reduces its validated receipts into one compact summary
  with source digests under the existing preservation oracle.

Git provider merges are still serialized at the commit boundary. This design
removes artificial lane serialization caused by shared documentation paths; it
does not pretend simultaneous mutations of `main` exist.

## Lifecycle command surface

An installed Northstar task, invoked through Effigy, should expose a small
adapter and projection surface such as:

```text
northstar/lifecycle status
northstar/lifecycle verify
northstar/lifecycle apply-receipt <payload>
northstar/lifecycle close <payload>
northstar/lifecycle frontier
northstar/lifecycle compact-generation
northstar/lifecycle render
```

Exact command grammar is not settled. Repository wiring may provide a short
`effigy northstar:lifecycle ...` selector; the installed-skill fallback can use
Effigy's existing `--repo` route.

Queue should call this surface after merge and synchronized-main verification.
Manual workflows call it with the same schema. Rhai is suitable for task wiring,
validation, and simple projections; a small portable implementation may still
be justified for canonical JSON and atomic receipt writes. It must not become a
parallel scheduler, callback store, or orchestration state machine.

## Use cases to prove

1. Sequential task from ready through merge and closeout.
2. Two independent ready tasks implemented and reviewed concurrently, merged in
   either order, then closed without a shared-file conflict.
3. Two tasks sharing one reserved integration surface, with explicit serial
   merge or post-merge integration ownership.
4. Worker revision and re-review on a new exact head.
5. Failed validation, blocked worker, resume, and idempotent repeated callback.
6. Abandoned, superseded, and cancelled work with retained provenance.
7. External/manual worker and PR with no Queue installation.
8. External merge observed after stale local state.
9. Stale writer and same-task fork rejection across two worktrees.
10. Chatterbox changes frontier or priority while implementation is active.
11. No next approved task: closeout returns `planning_required` without
    inventing work.
12. Generation closure, preservation check, fragment roll-up, and repeat
    compaction with no churn.
13. Dirty integration checkout, missing provider identity, and partial provider
    outage without silent state advancement.
14. Migration from current Markdown status without losing historical evidence.

## Front-door consequence

If structured state becomes canonical for lifecycle facts, current Markdown
front doors should stop repeating hand-maintained status. Keep their semantic
runway and links, then either:

- render a clearly marked derived block from the lifecycle index; or
- make `northstar/lifecycle status` the live status view and keep Markdown free
  of volatile state.

The first is friendlier on GitHub but retains generated commits. The second is
cleaner but weakens browse-only visibility. This decision needs a prototype and
operator preference.

## Adoption path

1. Inventory every current lifecycle write and classify it as semantic,
   mechanical, derived, or exceptional evidence.
2. Map Queue's task, event, review, merge, and closeout fields onto the smallest
   provider-neutral receipt schema.
3. Freeze the receipt schema, actor trust, idempotency, and conflict rules.
4. Build a read-only validator/projector over fixtures and compare its output
   with current Northstar closeouts.
5. Add a Queue reference adapter and a manual adapter that produce identical
   receipts.
6. Shadow one natural task: keep current Markdown authority while generating a
   terminal receipt and comparing the derived result.
7. Run the two-concurrent-PR oracle.
8. Only after parity, switch lifecycle status authority and remove manual
   projections together.
9. Prove generation roll-up before making the mechanism a reusable default.

## Open decisions

- Whether browse-only GitHub status justifies committed generated projections.
- Whether the Queue adapter invokes the Northstar command directly on
  synchronized `main` or hands an authenticated receipt to an integration run.
- Which nonterminal dispositions merit portable receipts before final closeout.
- Which actors may assert review, merge, cancellation, and operator decisions.
- Whether the first version supports both sequential and parallel generations.
- How much provider evidence is copied versus linked and hash-bound.
- Whether exceptional human limitations remain in the task Markdown or receive
  a typed annotation fragment.

This note is planning intake only. Do not implement or migrate lifecycle state
until the model and proof plan are confirmed.
