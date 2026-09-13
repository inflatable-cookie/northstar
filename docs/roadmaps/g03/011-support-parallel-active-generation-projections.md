# g03.011 Support Parallel Active-Generation Projections

Owner: repo maintainers
Created: 2026-09-13
Governing refs: contract 001, bundle section 12, lifecycle schemas
Depends on: `g03.010` complete at `36dc197`
UI classification: none

## Outcome

Northstar's portable lifecycle configuration represents a repository's declared
generation mode honestly. Sequential consumers retain one `active_generation`;
parallel consumers may declare an ordered, duplicate-free `active_generations`
set. Queue remains unaware of either shape.

## Ready-State Rubric

- [x] Underlay is a real parallel-mode consumer with active `g11` and `g12`.
- [x] The current projection-target schema accepts only one active generation.
- [x] The operator approved lifecycle rollout to every Northstar project.
- [x] Compatibility, ordering, rendering, transition, and negative controls are
      explicit.
- [x] UI classification is `none`.

## Decisions

- Keep `northstar.lifecycle.projection-targets.v2`. Accept exactly one of
  `active_generation` or `active_generations`; the plural form is a non-empty,
  lexically sorted, duplicate-free list.
- Treat either form as one normalized active-generation set internally. A task
  transition is valid only when its generation is in that set.
- Render one generation row per active generation in stable lexical order. Task
  records remain grouped and sorted by generation and task ID.
- Keep the singular starter template and all existing consumer files byte-valid.
  Add a parallel-mode example to reusable doctrine; do not migrate sequential
  consumers to the plural form.
- Keep rollover and generation closure human-owned. This task adds
  representation only; it does not authorize multiple generations in a
  sequential repository.
- Queue, Effigy, and consumer product repositories stay unchanged. Underlay
  adoption follows as a separate Queue task after this task closes.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one Northstar core lane.
- **Completion:** implementation and independent exact-head review pass; PR
  merges; the existing Effigy-hosted closeout hook publishes terminal state and
  consumes this handoff.
- **Owned mutable paths:** lifecycle core, schemas, references, focused fixtures
  and tests, starter doctrine where the sequential default must stay explicit,
  and concise task/front-door updates.
- **Reserved closeout surfaces:** `.northstar/lifecycle/v1/tasks/g03.011.json`,
  generated projection blocks, and deletion of this handoff belong to the Queue
  hook after merge.
- **Worker:** automatic adequate complex implementation pool; reviewer must use
  an independent provider/model identity.
- **Serial edges:** Underlay lifecycle adoption waits for this task's terminal
  proof. Other sequential consumer rollouts are independent.
- **Excluded:** Queue or Effigy source; Underlay source or docs; automatic
  rollover/closure/compaction; product behavior; UI, CI, release, or
  thread/workspace mutation.
- **Escalation:** stop if parallel support requires Queue to know Northstar
  generations, changes existing singular consumer meaning, or cannot reject
  ambiguous mixed configuration.

## Work

1. Extend projection-target validation with the exclusive singular/plural union
   and strict plural ordering, uniqueness, and path/current-generation checks.
2. Normalize both forms for transition admission, frontier derivation,
   projection rendering, hook bootstrap/closeout, and standalone commands.
3. Render every active generation deterministically without changing existing
   singular output bytes.
4. Add focused positive proofs for two independent active generations and
   negative proofs for both keys, empty/unsorted/duplicate sets, an undeclared
   task generation, and sequential starter drift.
5. Update reusable lifecycle doctrine with the parallel form and its boundary.
   Keep the copy-ready default singular.
6. Validate with the lifecycle oracle, lifecycle adoption suite, docs QA, and
   repository QA. Let the required hook own closeout after merge.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| Existing consumers remain valid | A current singular config needs editing | Full singular fixture and starter parity remain green |
| Parallel membership is explicit | A task from `g13` enters a `g11`/`g12` repository | Transition and hook refuse a generation outside the normalized set |
| Configuration is unambiguous | Both singular and plural keys are accepted | Schema/core reject mixed keys before mutation |
| Output is deterministic | Array order changes projection bytes | Unsorted input is rejected; rendering is stable and fixture-proven |
| Queue stays generic | Queue schema or plugin parses active generations | Queue repository diff is empty; only Northstar consumes the field |
| Mode authority stays in repo docs | Plural config silently enables parallel planning | Doctrine requires the repository's roadmap mode to authorize the set |
| Closeout remains atomic | Parallel rendering writes only one generation or partial targets | Hook fixture publishes the task record and complete projections in one result |

## Stop conditions

Stop if the solution needs a Queue contract change, a second lifecycle store,
automatic generation selection, silent array sorting, acceptance of both config
keys, or migration of sequential consumers.

## Evidence

Underlay's committed roadmap front doors declare parallel mode with `g11` and
`g12` active. The current v2 projection-target schema and lifecycle core expose a
single `active_generation`, so choosing either would publish false repository
state. The portable rollout is otherwise ready.

## Next Task

After terminal closeout, dispatch Underlay's configuration-only adoption task
against the accepted plural contract. Do not alter Underlay's product lanes.
