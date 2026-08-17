# Atlas Route Validation — Northstar Strategic Horizon

Status: provisional evidence
Date: 2026-08-17
Route: `skills/northstar/references/modes/atlas.md`
Scenario: Northstar itself, treated as a multi-generation planning system rather than a single implementation task
Operator confirmation: pending

## Scope

Validate whether Atlas produces strategic horizon synthesis at a larger scale
than the existing planning-readiness review.

The scenario is intentionally Northstar itself because its vision, docs spine,
architecture, contracts, generation runway, active roadmap, and operator-owned
consumer evidence form a real cross-surface planning system.

## Evidence read

- `docs/vision/001-northstar-delivery-vision.md`
- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/contracts/001-working-rules.md`
- `docs/roadmaps/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/g02/README.md`
- `docs/specs/027-northstar-native-pre-execution-discovery.md`
- `docs/specs/028-agent-instruction-surface-optimization.md`
- `bundle-docs/protocol-kernel.md`

## Atlas output

### Destination and horizon

Northstar's long-horizon destination is an operator-controlled planning and
execution grammar that lets agents run complex software projects inside real
planning, produce integrated outcomes, and require substantially less thread
babysitting.

This is larger than the next route or generation: it spans the reusable docs
spine, installable skill surface, delivery contracts, bounded autonomy model,
external proof, and eventual multi-project adoption.

### Strategic direction

The direction is to make planning state durable and authoritative while keeping
the public agent surface small, readable, provider-neutral, and copy-ready.
The core constraint is bounded autonomy: agents may continue only inside
explicit planning, readiness, authority, evidence, and closeout boundaries.

### Current shape

The current architecture already separates doctrine (`bundle-docs`), adoption
artifact (`template-bundle`), behavior (`skills`), live development planning
(`docs`), and validation (`scripts` plus Effigy). The working-rules contract
sets the delivery grammar and generation runway model. `g02` is the active
external-proof and execution-hardening generation, with goals covering setup,
nested authority, posture, bounded autonomy, context reduction, and bundle
consolidation.

The state is strategically coherent enough to continue, but the runway has two
important tensions:

1. the current generation next-task text remains focused on operator-supplied
   instruction-surface dogfooding feedback;
2. the new long-horizon planning capability is not yet represented in the
   generation runway as an accepted strategic goal, so its status must remain
   provisional until the operator confirms it earns that place.

### Horizon model

| Horizon | Outcome | Depends on | Unlocks |
| --- | --- | --- | --- |
| H1 — route and surface coherence | Northstar has a small, explicit, low-context public surface whose routes distinguish discovery, readiness, Atlas, planning, and execution | Router/mode contracts, skill distribution, deterministic checks, operator validation | Reliable use of Northstar for materially ambiguous and long-horizon planning |
| H2 — external-proof adoption | Downstream projects can adopt the docs spine, classify posture, preserve nested authority, and run bounded autonomous lanes without hand adaptation | H1, setup/adoption contracts, consumer evidence supplied by the operator, delivery-layer contracts | Repeatable multi-project operation with less thread babysitting |
| H3 — durable complex-project operation | Operators can run substantial projects through coherent vision, architecture, contracts, specs, roadmaps, workers, evidence, and closeout with bounded autonomy | H2, continued external proof, promotion discipline, reliable worker/PR boundary, reduced instruction overhead | A reusable project operating system rather than a collection of planning utilities |

These are strategic outcomes, not a precomputed list of future milestones.

### Strategic bets and dependencies

- **Durable repository state over private conversation:** the repository remains
  the authority boundary for planning, execution, evidence, and closeout.
- **One routed skill tree over many public skills:** explicit commands may improve
  discoverability, but canonical procedure remains centralized.
- **Bounded autonomy over unconstrained continuation:** ready cards, lane
  budgets, pause signals, and operator-authorized merge boundaries are part of
  the product's trust model.
- **Operator-owned external evidence:** downstream dogfooding is not another
  Northstar orchestration lane; feedback enters as evidence supplied by the
  operator.
- **Promotion before execution:** research and provisional specs must become
  architecture/contracts before roadmaps or workers rely on them.

The main dependency is trust: route quality, surface portability, and delivery
boundaries must be proven together. Optimizing prompt size without preserving
authority would damage the destination rather than advance it.

### Non-goals and accepted uncertainty

- Atlas does not decide Northstar's product strategy for the operator.
- Atlas does not replace the readiness review or compile every future roadmap.
- The exact boundary between one generation and the next remains an operator
  decision.
- The amount of strategic planning needed by consumer repositories is not yet
  established; Northstar should not impose Atlas where a bounded readiness review
  is enough.
- The usefulness of Atlas on a non-Northstar large-scale project remains to be
  tested.

### Promotion map

- destination and target operating model → `docs/vision/`;
- authority and system boundaries → `docs/architecture/`;
- autonomy and operator boundaries → `docs/contracts/`;
- Atlas route behavior → `docs/specs/029-northstar-long-horizon-planning.md` and
  `skills/northstar/references/modes/atlas.md`;
- route rollout and validation → `docs/roadmaps/g02/028-add-northstar-long-horizon-planning.md`;
- this evidence → the present log.

### Recommended next route

Run Atlas once against a large non-Northstar project or portfolio supplied by the
operator. Compare whether it synthesizes horizons, bets, dependencies,
non-goals, and accepted uncertainty rather than merely auditing existing docs.
Then either promote Atlas to an explicit slash command or revise its contract.

## Assessment

This scenario demonstrates a meaningful scale difference from
`planning-readiness-review`: Atlas produced a destination, multi-horizon model,
strategic bets, dependencies, and promotion map. It did not collapse into a
currentness report or a task queue.

The evidence is sufficient to continue shaping the route, but not sufficient to
claim final validation. Operator confirmation and a non-Northstar scenario
remain open before treating `/northstar-atlas` as a stable public command.
