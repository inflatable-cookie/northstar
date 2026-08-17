# 029 - Northstar Long-Horizon Planning

Status: active
Owner: repo maintainers
Created: 2026-08-17
Updated: 2026-08-17
Depends on: g02.026, g02.027
Vision tags: `long-horizon-planning`, `strategic-runway`, `multi-horizon`, `northstar-atlas`
Governing refs: `bundle-docs/protocol-kernel.md`, `docs/vision/`, `docs/architecture/`, `docs/contracts/001-working-rules.md`
Route target: `skills/northstar/references/modes/atlas.md`

## Problem

Northstar can review whether an existing plan is coherent and can compile
contract-approved milestones, but it does not yet provide one question-led route
for shaping the long-horizon strategic form of a significant project, product,
platform, or portfolio.

Without that route, planning can stop at a useful readiness audit or jump from
high-level intent directly to near-term roadmap work. The missing layer is a
durable connection between long-horizon direction, strategic constraints,
architecture, contracts, generation runways, and meaningful roadmap horizons.

## Goal

Provide a Northstar-native, plan-only Atlas route that helps an operator shape a
coherent multi-horizon runway without copying external skill names, creating a
waterfall, or granting execution authority.

## Non-goals

- replacing vision, architecture, contracts, specs, or roadmaps;
- deciding strategic direction on the operator's behalf;
- generating every future milestone or implementation card;
- auditing current planning only — that remains `planning-readiness-review`;
- compiling near-term milestones from already-settled surfaces — that remains
  `compile-roadmaps`;
- editing production code, starting workers/worktrees, preparing PRs, or merging;
- selecting or managing consumer dogfood runs.

## Route contract

Atlas is a user-guided discovery route before it is a strategy-synthesis route.
It begins by identifying the target, scale, and strategic question without
answering the question on the operator's behalf. It reads the available
canonical surfaces for context, vocabulary, constraints, and contradictions,
then asks a small first-principles question set.

The first Atlas turn must stop at a discovery checkpoint. It must not invent a
destination, preferred horizon model, strategic bets, or runway merely because
repository evidence is incomplete. If the operator does not yet know the aim,
Atlas should guide first-principles thinking or route to pre-execution discovery;
it should not manufacture a plausible strategy.

After the operator supplies or confirms enough direction, Atlas separates:

- direction and strategic constraints from realization details;
- operator-stated direction from agent-generated options;
- existing evidence from recommendations;
- operator-owned decisions from repository-answerable facts;
- durable horizons from short-term task queues;
- accepted uncertainty from missing planning.

Only then may the route produce a bounded horizon model containing:

- destination and long-horizon outcomes;
- strategic constraints, non-goals, and rollover conditions;
- meaningful horizons or phases with outcomes and unlocks;
- strategic bets, dependencies, irreversible choices, and sequencing;
- open operator decisions and accepted uncertainty;
- a coarse generation runway and next meaningful milestone transitions;
- promotion destinations across vision, architecture, contracts, specs, research,
  logs, and roadmaps;
- exactly one recommended next route.

Atlas asks breadth-first strategy questions only after resolving facts the
repository can answer. It recomputes after evidence or operator responses and
stops when the model is coherent enough for promotion, an operator decision is
required, or a narrower route is correct.

## Boundary with adjacent routes

| Route | Purpose |
| --- | --- |
| Atlas | Shape long-horizon strategic direction and multi-horizon runway |
| Planning readiness review | Test whether existing planning is coherent enough to continue |
| Pre-execution discovery | Resolve bounded destination decisions and readiness frontiers |
| Architecture refocus | Review one active code seam or subsystem for structural improvement |
| Compile roadmaps | Turn settled canonical planning into meaningful milestone roadmaps |
| Orchestrator | Carry approved planning into a separate worker/PR loop |

Atlas may recommend any adjacent route, but it must not silently become one.

## Promotion and authority

The default Atlas pass is read-only. If the operator explicitly authorizes a
bounded recording or promotion step, outcomes go to their canonical owners:

- long-horizon outcomes and strategic constraints → `docs/vision/`;
- accepted system shape and invariants → `docs/architecture/`;
- durable authority and behavioural rules → `docs/contracts/`;
- provisional realization strategy → `docs/specs/`;
- time-ordered horizons and milestone sequencing → `docs/roadmaps/`;
- evidence and decision history → `docs/logs/` or linked canonical records.

No Atlas output overrides operator-owned decisions or executes from an uncleared
planning gap.

## Acceptance criteria

- [x] a dedicated Atlas mode exists and is distinct from planning readiness;
- [x] the mode names the long-horizon scale test and canonical required reads;
- [x] the mode defines a discovery-first checkpoint before strategic synthesis;
- [x] the mode explicitly requires first-principles guidance when the operator
      does not yet know the project's aim;
- [x] the mode produces a horizon model rather than a currentness report once
      operator direction is sufficiently grounded;
- [x] the mode defines promotion destinations and adjacent-route boundaries;
- [x] the mode is plan-only and operator-owned;
- [ ] an existing-project run demonstrates that Atlas asks before prescribing;
- [ ] an operator confirms that the output is strategic rather than a roadmap
      review, implementation plan, or agent-authored strategy;
- [x] the route is covered by a thin explicit slash adapter;
- [x] the route has deterministic contract and distribution checks.

## Stop conditions

- stop if the request is small enough for ordinary planning;
- stop if the destination or strategic question is not identifiable;
- route to recovery if canonical state is stale or contradictory;
- route to discovery if destination intent or operator-owned decisions remain
  materially unresolved;
- route to architecture refocus when implementation seams disagree with intended
  shape;
- route to roadmap compilation when strategy is coherent and only milestones
  remain;
- stop if the horizon model becomes a speculative feature waterfall.

## Current implementation state

The Atlas mode contract is present at
`skills/northstar/references/modes/atlas.md`, routed through the Northstar
router, and exposed by a thin `/northstar-atlas` adapter. Northstar itself has
provided a provisional large-scale validation scenario. Operator confirmation
and a non-Northstar scenario remain open before the route is treated as fully
validated.
