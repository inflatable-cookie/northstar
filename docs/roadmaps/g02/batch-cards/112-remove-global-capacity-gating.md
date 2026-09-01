# 112 - Remove Global Capacity Gating

Status: complete
Owner: repo maintainers
Created: 2026-09-01
Master roadmap: `g02.044`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/roadmaps/g02/044-remove-global-capacity-gating.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Auto-start next card: no

## Objective

Replace the false global-capacity scheduler with lane-local transport and
provider routing semantics across Northstar's reusable orchestrator surfaces.

## Scope

- update architecture, working rules, reusable doctrine, and operator guidance;
- update the installable orchestrator mode and concise top-level outcome;
- update copy-ready consumer contract and protocol-kernel wording where it
  binds or routes parallel scheduling;
- replace deterministic assertions for first-refusal, queue, freed-slot, and
  capacity-limit prose with positive and negative checks for the seven oracle
  scenarios;
- preserve historical logs and handoffs as evidence of the superseded rule;
- write closeout evidence and reconcile roadmap/front-door state.

Out of scope: Paseo changes, profile edits, hard-coded providers or models,
mid-run agent migration, duplicate replacement workers, or weaker serial and
review gates.

## Ready-State Checks

- [x] the operator confirmed Paseo can run as many threads as needed;
- [x] the defect is reproduced in live dogfood: a provider spend cap reduced
  unrelated orchestrator activity and stopped a ready Market lane;
- [x] spec 026 settles lane-local provider failure and identity preservation;
- [x] the implementation surfaces and seven falsification scenarios are bounded;
- [x] no active Northstar worker or PR owns this correction.

## Acceptance Criteria

- [x] every safe ready lane launches without a global thread-count limit;
- [x] provider/model/profile refusal affects only that route and lane;
- [x] a suitable alternative profile is tried without changing worker class;
- [x] no-fit state pauses one lane while unrelated ready lanes continue;
- [x] ambiguous transport state preserves returned identities and prevents a
  duplicate retry;
- [x] dependency, shared-surface, authority, and merge-order gates stay intact;
- [x] old first-refusal/global-queue/freed-slot wording is absent from live
  reusable surfaces and guarded by deterministic negative assertions;
- [x] doctrine, copy-ready contracts, skill source, operator docs, and installed
  payload agree;
- [x] repository QA and isolated skill-install parity pass.

## Review Oracle

Use milestone `g02.044`. Exercise all seven scenario rows against final wording
and deterministic checks. The reviewer must be able to distinguish transport
identity ambiguity, provider-route unavailability, and a real serial dependency.

## Evidence Required

- before/after inventory of live global-capacity and freed-slot language;
- seven-row scenario matrix with positive and negative proof;
- explicit proof that day-to-day unavailability does not spend a frontier worker;
- changed-surface parity inventory;
- `effigy check:command-skills`, isolated `effigy check:skill-install`,
  `effigy qa:docs`, `effigy qa`, and `git diff --check` results;
- closeout log and reviewable PR exact head.

## Stop Conditions

- any scheduling or authority choice remains unresolved;
- correct behavior needs a hard-coded provider, profile, quota, or worker count;
- the change weakens a real dependency or review boundary;
- a current worker owns overlapping protocol surfaces;
- validation changes the plan.

## Next Task

Complete. PR 17 merged at `e5e8060`; the corrected 127-file skill payload is
installed and all other active `Orchestrator`-labelled workspaces were notified.
