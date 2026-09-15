# g03.018 — Consume closed-generation lifecycle fragments

Owner: repo maintainers
Created: 2026-09-15
Governing refs: contract 001, lifecycle maintenance, lifecycle reference
Depends on: `g03.017` complete at `c156c10`
UI classification: none

## Outcome

Once explicit closure authority covers a generation, its compact receipt
becomes the live machine record and the covered per-task lifecycle JSON files
are removed. Queue closeout catches up every eligible historical generation in
the same isolated integration write, while standalone maintenance can perform
the same deterministic operation without Queue.

## Ready-State Rubric

- [x] The growth source is measured: 207 task fragments across 31 local
  projects, about 948 KiB, with closed generations retaining their fragments.
- [x] Existing closure records and generation receipts provide the authority
  and compact replacement shape.
- [x] Queue's existing closeout event and lifecycle path allowance can publish
  the change without learning Northstar structure.
- [x] Replay, interrupted cleanup, locking, and refusal behavior are explicit.
- [x] Open and `planning_required` generations are outside deletion authority.
- [x] UI classification is `none`.

## Decisions

- Keep pruning in Northstar's portable lifecycle core. Effigy resolves and
  executes the installed skill; Queue remains a generic event runner.
- Treat a committed `generations/gNN.closure.json` with disposition `closed` as
  the only deletion authority. Catch-up cannot close a generation or infer
  closure from terminal tasks, an exhausted runway, or `planning_required`.
- Make `generations/gNN.json` the durable live machine tombstone. It retains
  the canonical terminal summaries, source task-set digest, and closure digest;
  Git history retains the detailed deleted task records.
- With a full task-fragment set and no receipt, verify every record and the
  closure-pinned digest, write the canonical receipt, then delete exactly the
  covered fragments.
- With a valid receipt and remaining fragments, verify every fragment against
  its receipt entry before deleting it. This is the crash-safe catch-up path.
- With a valid receipt and no fragments, return unchanged. A partial set without
  a valid receipt, a conflicting receipt, stale closure, nonterminal record, or
  malformed or escaping path fails before mutation.
- Discover eligible closed generations in lexical order. One invocation may
  consume several generations and reports every receipt creation and deletion
  in deterministic `changed_paths` order.
- Run catch-up during `task.closeout` inside the existing isolated integration
  write, so a current closeout and historical pruning publish in one commit.
  Use the lifecycle core's common-directory lock and atomic writes for the
  standalone route as well.
- Teach record loaders, projections, audit, digest, and replay paths to accept
  valid compact receipts wherever closed-generation state is relevant. Active
  generation behavior continues to use individual task records.
- Do not shard an active generation. Current portfolio size does not justify a
  second storage scheme.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready; one Northstar core and adapter lane.
- **Owned mutable paths:** lifecycle core, Queue hook adapter, lifecycle schemas
  and reference doctrine under `skills/northstar/**`; focused fixtures and
  structural checks; reusable lifecycle maintenance text; this task and g03
  indexes.
- **Reserved closeout surfaces:** g03.018 lifecycle record, generated
  projections, submitted-handoff deletion, eligible generation receipts, and
  exact covered task-fragment deletions belong to the repository hook.
- **Worker:** automatic general pool; independent exact-head review required.
- **Oracle gate:** not required. The operator settled ownership, catch-up, and
  deletion authority; the work is mechanical with exact positive and refusal
  fixtures.
- **Excluded:** Queue source or event changes, consumer-repository rollout,
  active-generation sharding, automatic closure or rollover, deletion from open
  or `planning_required` generations, Git history rewriting, release/CI work,
  and any Paseo thread or workspace disposition.

## Work

1. Define and validate the generation-receipt shape as a first-class lifecycle
   artifact, including exact task-entry matching and closure provenance.
2. Replace receipt-only `compact` behavior with locked, replay-safe receipt
   publication plus exact covered-fragment consumption.
3. Add deterministic discovery and catch-up for every eligible closed
   generation.
4. Invoke catch-up from hook-owned closeout and include all lifecycle mutations
   in its result and single integration commit.
5. Update standalone maintenance and lifecycle loading paths for pruned closed
   generations without changing active-generation behavior.
6. Add focused fixtures, then run lifecycle checks, docs QA, full QA, skill
   validation, installed-parity checks, and `git diff --check`.

## Acceptance and review oracle

- A closed generation with its exact full terminal fragment set produces one
  canonical receipt and deletes exactly those fragments.
- Replaying after all fragments are gone returns unchanged with identical
  receipt bytes.
- A valid receipt plus a partial set of exact remaining fragments deletes the
  remainder safely; a partial set without a valid receipt refuses.
- A stale closure digest, nonterminal record, conflicting or malformed receipt,
  symlink, or path escape refuses before any write or deletion.
- Open and `planning_required` generations are byte-for-byte untouched.
- Several eligible historical generations compact in lexical order and one
  Queue closeout publishes the current task transition plus catch-up in one
  integration commit with exact `changed_paths`.
- Repositories with no closure records retain their current behavior.
- Standalone and Queue-adapter paths produce the same receipt bytes and
  deletions. Git history still contains every removed detailed record.

## Stop conditions

Stop if pruning requires Queue to understand Northstar paths, invents closure,
deletes a record not exactly covered by a validated receipt or closure, loses
replay safety, rewrites Git history, changes a consumer repository, or disposes
of any thread or workspace.

## Evidence

The current reducer writes compact receipts but never consumes the task JSON
they replace. Across the local portfolio, 31 repositories retain 207 task
fragments totalling about 948 KiB; the largest repositories hold 63 and 36
fragments. The size is modest, but the growth is unbounded and every closed
generation keeps duplicate live machine state.

Existing manifests already permit `.northstar/lifecycle/` mutations during
`task.closeout`. The missing work is entirely within Northstar's installed
lifecycle implementation and can catch up old eligible generations the next
time a repository closes a task or runs authorized lifecycle maintenance.

## Next task

After closeout and global skill refresh, observe catch-up on natural project
closeouts before considering portfolio-wide maintenance. No automatic rollout
or successor is approved.
