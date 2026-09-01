# 115 - Diversify Model Routing Across Runs

Status: complete; merged through PR 20 at `08ad810`
Owner: repo maintainers
Created: 2026-09-01
Updated: 2026-09-01
Master roadmap: `g02.047`
Governing refs: `docs/roadmaps/g02/047-diversify-model-routing-across-runs.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`
Auto-start next card: no

## Objective

Replace one-profile concentration with provider-neutral, cheapest-adequate,
recent-use-aware routing across workers, delegates, and fresh orchestrators.

## Scope

- update orchestrator model routing and dispatch selection to build adequate
  pools, prefer the cheapest adequate tier, and vary recent provider/model use;
- apply the rule to ordinary, mechanical, material, frontier, planning-delegate,
  and fresh-orchestrator dispatches;
- keep explicit operator override and lane-local failure/recovery;
- propagate compact meaning to skill outcome, handoff guidance, doctrine,
  operator guidance, protocol kernel, and copy-ready working rules;
- add focused positive and negative assertions for all ten milestone oracle rows;
- prove installed parity and close roadmap/front-door/log state;
- open a reviewable PR and stop for exact-head review.

Out of scope: provider billing APIs, account top-ups, a persistent usage ledger,
hard-coded local profiles/models/prices, changing active agents in place, or
weakening review and validation.

## Ready-State Checks

- [x] the operator explicitly requested diversified model use across workers
  and orchestrators;
- [x] PR 19 merged card 114 at `b99d19c`, clearing the shared protocol surfaces;
- [x] architecture, working rules, and spec 026 now settle the pool, cost-tier,
  recent-use, override, and lane-local boundaries;
- [x] the promoted triage note has been removed from the temporary buffer;
- [x] no other worker owns the model-routing, orchestrator, doctrine, template,
  or closeout surfaces.

## Acceptance Criteria

- [x] all ten milestone oracle rows have focused proof;
- [x] eligible profiles are filtered for adequacy before cost or rotation;
- [x] cheapest adequate tier and least-recent provider/model selection replace
  repeated best-fit defaulting;
- [x] recent-agent history is optional and bounded current-run memory works;
- [x] fresh orchestrators and planning delegates use diversified pools;
- [x] most settled material work may use small workers under strong review;
- [x] frontier worker selection requires the residual-reasoning explanation and
  rotates within its adequate pool;
- [x] explicit operator choice wins and refusals remain lane-local;
- [x] no persistent usage ledger or local profile/model/cost value enters the
  reusable payload;
- [x] source/install parity, docs QA, full QA, and `git diff --check` pass;
- [x] the PR records its exact tested head and limits.

## Evidence Required

- before/after routing inventory;
- ten scenario outcomes with expected failures;
- focused searches for stale single-default/frontier-always wording and local
  provider/model/cost values;
- `effigy check:command-skills`, isolated `effigy check:skill-install`,
  `effigy qa:docs`, `effigy qa`, and `git diff --check`;
- closeout log, reviewable PR, and exact tested head.

## Stop Conditions

- adequacy or cost tier cannot be resolved from current adapter surfaces;
- implementation requires durable cross-thread usage storage;
- rotation can override explicit operator selection;
- assertions would restore broad editorial validation rather than target the
  routing contract;
- validation changes the plan.

## Completion Notes

- Orchestrator mode, doctrine `07`, the copy-ready working rules, the skill
  outcome, operator guidance, the protocol kernel, and the handoff contract now
  state one rule: build the adequate pool per role, prefer the cheapest
  adequate tier, then vary provider/model identity before reusing a recent
  route. Adapter history is optional; current-run route memory is the
  fallback; no durable ledger or local provider/model/price value exists.
- The rule covers ordinary, mechanical, settled-material, frontier,
  planning-delegate, and fresh-orchestrator dispatches; frontier selection
  requires the residual-reasoning explanation and rotates within its own pool.
- New `check:model-routing` falsifies all ten milestone oracle rows: positive
  per-surface assertions, negative scans for stale same-class/best-fit
  wording and local model/price values, and parity markers shared by the live
  and copy-ready contracts. The checker fails the pre-change tree and injected
  violations by named oracle row.
- No runtime usage service, local model catalogue, persistent ledger, or
  weakened review/validation gate was added.

## Next Task

This card is closed. PR 20 merged at `08ad810` after accepted exact-head review.
Spec 034 remains separate and not ready.
