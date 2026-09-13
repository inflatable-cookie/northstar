# g03.009 Separate Planning Required from Generation Closure

Owner: repo maintainers
Created: 2026-09-13
Governing refs: contract 001, bundle section 03, bundle section 12
Depends on: `g03.008` complete at `305700c`
UI classification: none

## Outcome

An open generation whose current tasks are all terminal enters
`planning_required`. It does not become complete, closed, compactable, or ready
for rollover by inference. Generation closure remains a separate deliberate
decision that records the boundary, preserves unresolved meaning, and alone
authorizes compaction or the next generation.

## Ready-State Rubric

- [x] `g03.008` closed through the repository-pinned hook runtime and consumed
      its exact handoff.
- [x] The lifecycle reducer already returns `planning_required` for an empty
      ready frontier, but projections do not expose generation/runway state.
- [x] The current compaction function accepts any all-terminal record set,
      without proof that the generation was deliberately closed.
- [x] The active generation is the live example: every adopted task is
      terminal while `g03` remains the correct planning era.
- [x] Scope, state boundary, rollover authority, and self-hosting oracle are
      explicit.
- [x] UI classification is `none`.

## Decisions

- Keep two separate axes. Generation disposition is `open` or `closed` and
  changes only through explicit planning. Runway state is mechanically derived
  from task records. `complete` is never a generation disposition.
- An open generation with no nonterminal approved work is
  `planning_required`. This state asks Chatterbox to extend the same generation
  or make a reasoned rollover decision; it does not prefer either outcome.
- Nonterminal records must not collapse into `planning_required`: ready,
  active, and blocked work stays visible under an exact bounded vocabulary.
  Define deterministic precedence for parallel records and prove it.
- Generated roadmap projections expose the active generation and its derived
  runway state. Human prose owns generation intent and rollover judgment; it
  must not duplicate mutable task/runway status.
- All-terminal tasks are necessary but insufficient for closure. Compaction
  must require explicit, repository-verifiable closure authority and refuse an
  open `planning_required` generation.
- A rollover may close the current generation only after the existing
  preservation oracle passes. Exhaustion, task count, Queue completion, or a
  quiet frontier cannot trigger it automatically.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one lifecycle
  semantics lane, no concurrent sibling and no automatic successor.
- **Completion:** implementation and independent exact-head review pass; PR
  merges; this task's repository-pinned closeout hook publishes its terminal
  record and projections; the resulting `g03` front door says
  `planning_required` while the generation index still keeps `g03` open; no
  `g04`, generation closure, compaction receipt, closeout agent, or closeout
  workspace is created.
- **Owned mutable paths:** lifecycle core, adapter, runtime build/parity,
  schemas, references, focused fixtures and checks under
  `skills/northstar/**`; matching runtime payload, doctrine, and templates
  under `.paseo/hooks/**`, `bundle-docs/**`, and `template-bundle/**`;
  lifecycle projection configuration; contract 001; active roadmap and front
  doors; focused repo-contract checks.
- **Reserved closeout surfaces:** `.northstar/lifecycle/v1/tasks/g03.009.json`,
  declared generated projection blocks, and deletion of this task's exact
  submitted handoff belong exclusively to the required Queue hook after merge.
- **Worker:** automatic adequate complex implementation pool; reviewer must use
  an independent provider/model identity.
- **Serial edges:** this is the only Northstar writer lane. Do not dispatch a
  successor until the live projection is reconciled.
- **Excluded:** Queue source or database changes; automatic task selection;
  automatic rollover; opening `g04`; compacting `g03`; retroactive lifecycle
  records; consumer rollout; UI, CI, release, or destructive thread/workspace
  changes.
- **Escalation:** Chatterbox owns the exact closure-authority representation if
  existing repository evidence cannot express it without ambiguity. Queue
  recovery owns mechanical hook reconciliation.

## Work

1. Define one closed machine vocabulary for generation disposition and derived
   runway state. Specify precedence when records are mixed, including parallel
   ready, active, blocked, planned, and terminal tasks.
2. Extend deterministic projections so current front doors show the active
   generation's runway state. Upgrade schema/config versions cleanly, bind the
   state into the source digest, scope it to the declared active generation,
   and preserve narrative outside the generated sentinel.
3. Make promotion/adoption and rollover instructions declare the active
   generation explicitly. Planning a new task in the same generation must move
   the derived runway out of `planning_required` through the lifecycle path,
   without a hand-edited status mirror.
4. Strengthen generation compaction so terminal tasks alone cannot authorize
   it. Require exact repository closure evidence and reject missing, stale,
   mismatched, ambiguous, or still-open authority before producing a receipt or
   deleting expanded sources.
5. Remove wording, templates, checks, and examples that treat an exhausted
   runway as a completed generation or imply immediate rollover. Reserve
   `closed` for the explicit rollover/closure boundary.
6. Update the repository-pinned runtime payload through its deterministic
   build/parity path. Preserve installed standalone behavior and Queue's
   document-agnostic event contract.
7. Prove this task live. After merge, make no manual integration edit: the
   closeout hook must leave `g03` open and project `planning_required` while
   consuming only this task's exact handoff.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| Exhaustion requests planning | Every task is terminal and the generation becomes `complete` or selects `g04` | Golden projection shows open `g03` with runway `planning_required` and no invented task |
| Closure is deliberate | `compact --generation g03` succeeds merely because every record is terminal | Negative requires exact explicit closure authority before any receipt or source change |
| Live work stays visible | One blocked or active task is reported as an empty planning frontier | Mixed-state table proves deterministic ready/active/blocked/planned/terminal handling |
| State has one meaning | Front doors use `active`, `complete`, and `closed` interchangeably for generation and task state | Schemas, glossary, templates, and checks enforce separate disposition and runway vocabularies |
| Projection is deterministic | Target order, record order, or replay changes generation state or bytes | Versioned schema, scoped source digest, permutation, repeat-render, and drift tests |
| Rollover stays semantic | Hook or reducer decides that enough tasks have landed and opens the next generation | No automatic successor; explicit rollover evidence and preservation checks remain required |
| Queue remains generic | Queue receives generation states or Northstar rollover rules | Queue source diff is empty; repository runtime owns all mapping and projection logic |
| Self-hosted result is honest | This task reaches done but g03 is shown closed, complete, or still executing | Queue/Git/hook evidence shows one publication, open `g03`, `planning_required`, consumed handoff, and no closeout agent/workspace |

## Stop conditions

Stop if the change requires Queue to understand generations, infers semantic
closure from task records, compacts an open generation, rewrites old receipts,
opens `g04`, or needs a manual integration edit after merge. Keep a failed
required hook visible and repair the same event; do not launch a closeout agent.

## Evidence

At `305700c`, records `g03.006` through `g03.008` are terminal and the generated
blocks list only completed tasks. The generation index still correctly names
`g03` as active, but the projection does not state that further planning is
required. `frontierOf` already returns `planning_required` when no ready task
exists. `compactGeneration` currently checks only that scoped task records are
terminal, so it cannot distinguish an exhausted open generation from one that
was explicitly closed.

## Next task

None. After the live proof leaves `g03` in `planning_required`, return to
Chatterbox to extend `g03` or decide whether a genuine rollover boundary exists.
