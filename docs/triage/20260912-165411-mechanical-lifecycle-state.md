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

### SQLite or external queue state

SQLite gives local transactions but is poor Git material and does not merge.
The queue database handles live concurrency well but cannot be Northstar's only
portable authority. Either may be a cache or orchestration projection, not the
repository contract.

## Tentative recommendation

Use immutable per-task transition fragments with a deterministic derived index.
Treat the repository as an event log at the mechanical boundary:

```text
.northstar/lifecycle/v1/
  tasks/g03.004/
    01-ready-<id>.json
    02-dispatched-<id>.json
    03-implementation-<id>.json
    04-review-<id>.json
    05-merged-<id>.json
    06-closed-<id>.json
  generations/g03.json
```

Names above are illustrative. Use a monotonic transition sequence plus a UUID
or content digest; timestamps alone do not establish order.

Each fragment should carry:

- schema version, task and generation ID, transition type, event ID;
- prior state and expected prior event/digest;
- actor role and source (`manual`, Queue, provider, CI);
- planning authority commit;
- task-specific identities required by the transition;
- idempotency key and creation time;
- evidence links or digests;
- explicit reason for blocking or non-happy-path disposition.

The reducer rejects missing predecessors, duplicate idempotency keys with
different content, illegal transitions, forks from one prior event, review/head
mismatch, merge without accepted exact-head review, and closeout without merge
and validation evidence.

## Concurrency and merge shape

- Workers do not edit global front doors or lifecycle state in their PRs.
- Each task has one active ownership lease. Different tasks may progress in
  parallel; the same task may not have competing writers.
- Lifecycle commands use an expected prior digest. A local lock plus atomic
  write protects one checkout; the digest and repository validator protect
  against cross-checkout forks.
- Unique fragments avoid content conflicts across tasks. If two writers fork
  one task, both files can merge physically but validation fails semantically
  until one receives an explicit disposition.
- Code PRs can merge without waiting for prose closeout. The integrator records
  merged facts on synchronized `main`, either after each merge or as one batch
  for several already-merged lanes.
- A global currentness index is generated from fragments. Workers never edit it.
  Prefer computing it on demand; if a human-readable projection is committed,
  one integration writer regenerates it after merges and it remains derived,
  never canonical.
- Closing a generation reduces its validated fragments into one compact summary
  with source digests, then removes the expanded event set under the existing
  preservation oracle.

Git provider merges are still serialized at the commit boundary. This design
removes artificial lane serialization caused by shared documentation paths; it
does not pretend simultaneous mutations of `main` exist.

## Lifecycle command surface

An installed Northstar task, invoked through Effigy, should expose bounded
operations such as:

```text
northstar/lifecycle status
northstar/lifecycle verify
northstar/lifecycle ready
northstar/lifecycle dispatch
northstar/lifecycle implementation
northstar/lifecycle review
northstar/lifecycle merged
northstar/lifecycle block|resume|supersede|cancel
northstar/lifecycle close
northstar/lifecycle frontier
northstar/lifecycle compact-generation
northstar/lifecycle render
```

Exact command grammar is not settled. Repository wiring may provide a short
`effigy northstar:lifecycle ...` selector; the installed-skill fallback can use
Effigy's existing `--repo` route.

Rhai is suitable for task wiring, validation, and simple projections. Atomic
writes, locking, canonical JSON, idempotency, and Git/provider identity may
justify a small portable implementation behind the Effigy task. Do not choose
the language before a spike proves the required filesystem and concurrency
behavior.

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
2. Freeze the state machine, schemas, actor trust, and conflict rules.
3. Build a read-only reducer over fixtures and compare its output with current
   Northstar closeouts.
4. Spike atomic fragment creation and cross-worktree fork detection in Rhai and
   one small alternative implementation.
5. Shadow one natural task: keep current Markdown authority while generating
   structured events and comparing the derived result.
6. Run the two-concurrent-PR oracle.
7. Only after parity, switch lifecycle status authority and remove manual
   projections together.
8. Prove generation roll-up before making the mechanism a reusable default.

## Open decisions

- Whether browse-only GitHub status justifies committed generated projections.
- Whether transition fragments are canonical evidence or a rebuildable record
  derived from Git/provider/Queue facts.
- Which actors may assert review, merge, cancellation, and operator decisions.
- Whether the first version supports both sequential and parallel generations.
- How much provider evidence is copied versus linked and hash-bound.
- Whether exceptional human limitations remain in the task Markdown or receive
  a typed annotation fragment.

This note is planning intake only. Do not implement or migrate lifecycle state
until the model and proof plan are confirmed.
