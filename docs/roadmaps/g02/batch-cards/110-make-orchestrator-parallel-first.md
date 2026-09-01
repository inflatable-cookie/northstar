# 110 - Make Orchestrator Scheduling Parallel-First

Status: complete
Owner: repo maintainers
Created: 2026-09-01
Master roadmap: `g02.042`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/roadmaps/g02/042-make-orchestrator-parallel-first.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Auto-start next card: no

## Objective

Promote the settled parallel-first scheduling rule through Northstar's reusable
orchestrator surfaces so independent ready workers launch by default rather than
only after an explicit operator request.

## Scope

- update architecture, working rules, reusable doctrine, and operator guidance;
- update the installable orchestrator mode and its concise top-level outcome;
- update the worker-handoff template where concurrency/integration ownership
  needs to be explicit;
- update copy-ready consumer contract surfaces that bind orchestrator behavior;
- add deterministic source/install and scenario checks where the current checks
  would otherwise miss a regression;
- write closeout evidence and reconcile roadmap/front-door state.

Out of scope: provider-specific worker limits, a new scheduler daemon, Paseo
product changes, worker implementation code, parallel documentation projection,
or weakening planning/review/merge gates.

## Ready-State Checks

- [x] the operator selected parallel-first scheduling as the default;
- [x] the existing permissive wording and serial failure mode are identified;
- [x] dependency, shared-surface, issue-fix, capacity, and exact-head boundaries
  are settled in spec 026 and milestone 042;
- [x] implementation surfaces and validation are bounded;
- [x] no active worker or PR owns this protocol change.

## Acceptance Criteria

- [x] planning identifies a dependency graph and current ready frontier;
- [x] the orchestrator dispatches all safe ready lanes up to available capacity
  without asking the operator to request parallelism;
- [x] a control plane without a capacity signal launches in priority order until
  explicit refusal, preserves created lane state, and retries queued work after
  a finish notification; manual dispatch publishes all selected handoffs;
- [x] it refills capacity and continues unrelated planning/review work while
  workers run;
- [x] it records exact reasons for serial/queued lanes and never serializes
  unrelated work around one blocked edge;
- [x] same-repo mutable and closeout surfaces are partitioned or integrated by a
  named orchestrator step;
- [x] issue-fix and exact-head review/merge boundaries remain intact;
- [x] doctrine, copy-ready contracts, skill source, handoff template, operator
  docs, and installed payload agree;
- [x] repository QA and isolated skill-install parity pass.

## Review Oracle

Use milestone `g02.042`. Exercise all seven scenarios against the final wording
and any deterministic checker. A reviewer must be able to tell which lanes
launch now, which wait, why they wait, and what happens when capacity frees.

## Evidence Required

- before/after inventory of permissive `offer parallel` wording;
- scenario matrix covering independent, dependent, shared-closeout, capacity-
  refill, unsurfaced-capacity, coherent issue-fix, and same-repo merge-order
  cases;
- changed-surface parity inventory;
- `effigy check:command-skills`, `effigy check:skill-install`,
  `effigy qa:docs`, `effigy qa`, and `git diff --check` results;
- closeout log and reviewable PR exact head.

## Stop Conditions

- any unresolved scheduling or authority choice remains;
- correct behavior needs a hard-coded profile, model, provider, or worker count;
- safe implementation needs shared worker writes or a second briefing surface;
- a current parallelism owner overlaps this card;
- validation changes the plan.

## Next Task

The card is executed and the PR is open on
`worker/make-orchestrator-parallel-first`. Evidence is in
`docs/logs/2026-09/01-101853-make-orchestrator-parallel-first.md`. The orchestrator
reviews the exact head and merges; the worker does not.
