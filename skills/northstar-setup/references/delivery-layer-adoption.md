# Delivery Layer Adoption

Use this reference when the repo being set up should adopt the stricter
delivery layer, not just the baseline Northstar docs shape.

The stricter mode is a standard docs spine, not a custom expansion.

## Baseline Mode Is Enough When

Stay on the baseline spine when the repo mainly needs:

- clear vision, architecture, contracts, roadmaps, and logs
- healthy active-lane routing
- shorter bounded runs that do not need card-by-card continuation state
- operator-guided work where roadmap and log state are enough

Do not treat baseline mode as a failure. It is a valid Northstar posture when a
repo does not need the fuller execution layer.

## Lane-First Stricter Adoption

In a mature baseline repo, stricter adoption does not have to begin as a full
repo-wide rewrite.

Use lane-first stricter adoption when:

- one active lane needs longer autonomous runs than roadmap-only mode expresses
  cleanly
- the repo's baseline spine is otherwise healthy
- the missing execution state is local to one active lane rather than a
  repo-wide planning failure

For that shape, add only the minimum stricter surfaces needed for the active
lane:

- `docs/specs/README.md`
- `docs/specs/batch-cards/README.md`
- one active master spec for the lane
- one or more active batch cards for the current bounded chain

Do not backfill closed history just to make the lane-first posture look
symmetrical. Start from the active lane and let broader adoption follow only if
the repo truly needs it.

If the repo is a thin workspace with a nested docs-authority repo, lane-first
or full stricter adoption should usually happen inside that authority repo.
Keep the workspace root as orchestration-only unless it really owns planning.

Treat lane-first adoption as the practical entry point. If the project is meant
to live under the full strict Northstar doctrine, plan the broader migration
deliberately after the active lane proves the stricter surface works.

## Full Strict Compliance Target

For projects that are intended to live under the strict doctrine, full strict
compliance should mean:

- the stricter docs spine is present as a standing project surface
- active material lanes use specs and batch cards as the execution unit
- product guardrails, working rules, and contract indexing are explicit and
  current
- closeout, currentness, and spec-hygiene expectations are part of normal work
  rather than exceptional cleanup

Do not call a project fully compliant just because one lane proved the stricter
surface in isolation.

## Migration Phases

Use this progression for mature projects moving toward full strict compliance:

1. baseline posture
2. lane-first stricter adoption
3. expanding strict coverage across new material lanes
4. full strict compliance as the project default

Use explicit checkpoints between phases. Mixed posture is acceptable during
migration, but it should be treated as temporary migration state, not the
desired steady state.

## Audit The Current Posture

Before changing a mature repo, classify it explicitly.

Record:

- current posture:
  `baseline`, `lane-first stricter adoption`, `expanding strict coverage`, or
  `full strict compliance`
- which checkpoints are already satisfied
- which gaps block the next migration phase
- whether mixed posture is still a deliberate migration state or has become
  drift

At minimum, audit these checkpoints:

- the standard docs spine is installed and current
- product guardrails, contract indexing, and working rules are explicit where
  the strict model expects them
- active material lanes use specs and batch cards where the fuller execution
  layer is being claimed
- promotion into architecture and contracts is explicit before roadmap
  execution depends on settled outcomes
- closeout, currentness, and spec hygiene are normal maintenance rather than
  rescue cleanup

Do not call a repo fully compliant because one stricter lane exists. Audit the
project-level posture, not only the best-looking slice.

## Rollout Tracking Pattern

Track migration inside the repo's normal planning spine.

Use:

- one active migration master spec
- one active roadmap milestone
- normal batch logs for completed tranches

That migration spec should name:

- the current posture
- satisfied checkpoints
- blocking gaps
- the current tranche
- the next tranche
- the evidence needed to close the current tranche
- the remaining project-level upgrades before full strict compliance can be
  claimed

Do not invent a detached tracker or governance board for this. If the project
is moving to full strict compliance, the migration should be readable from its
normal docs surfaces.

## Adopt The Delivery Layer When

Default to the stricter mode when one or more of these are true:

- the project is expected to run for a long time with many agent sessions
- the project spans multiple repos, packages, or authority surfaces
- user-facing work is complex enough that mockups or token partials are a real
  risk
- the operator wants longer autonomous runs with fewer manual "continue"
  prompts
- the repo should carry continuation-envelope, lane-budget, and pause-signal
  state explicitly in file state
- the project has already shown drift between planning and real execution

## Install These Surfaces

For stricter projects, install or create:

- `docs/architecture/product-guardrails.md`
- `docs/contracts/contract-index.md`
- `docs/contracts/001-working-rules.md` derived from
  `template-bundle/contracts/001-working-rules-template.md`
- `docs/specs/README.md`
- `docs/specs/archive/README.md`
- `docs/specs/batch-cards/README.md`
- `docs/specs/templates/master-spec-template.md`
- `docs/specs/templates/batch-card-template.md`

For projects on the path to full strict compliance, the broader migration
should eventually make these project-level surfaces normal rather than
lane-local exceptions.

Then make sure the docs front doors and the active planning lane explain:

- specs are provisional
- architecture records realized structure
- contracts remain the hard-definition surface
- roadmap execution should rely on architecture/contracts once promotion is due
- batch cards are the stricter execution unit when a change needs
  paint-by-numbers delivery
- specs may be archived or removed once the lane is closed and the promoted
  canonical surfaces make them unnecessary
- the archive surface exists so closed planning artifacts have a clear home
  outside the active specs tree
- the repo should treat spec hygiene as normal maintenance so `docs/specs/`
  stays focused on active planning rather than turning into a stale archive
- the execution guardrail pack rejects fake completion, unnecessary complexity,
  and shallow follow-through by default
- when planning is needed and the way forward is still materially ambiguous,
  the thread should ask for operator intent instead of inventing the next lane
  or batch
- if the project uses a nested docs-authority repo, that repo is the canonical
  home for the strict surfaces and native docs validation

The consumer-repo autonomy proof showed why this matters:

- roadmap-only repos can still route active work cleanly
- the fuller combined autonomy model is much harder to express without
  `docs/specs/` and batch cards
- in a mature baseline repo, that stricter layer may be needed only for one
  active lane at first
- if longer hands-off runs are an explicit goal, install the stricter layer on
  purpose instead of expecting roadmap-only mode to behave like it
- where full strict compliance is the target, use lane-first adoption to enter
  the stricter model cleanly and then complete the broader migration

## Guardrails

- Do not install the delivery layer mechanically on tiny or obvious repos that
  do not need it.
- Do not skip the delivery layer on complex or failure-prone repos just to keep
  the initial surface smaller.
- Do not let setup leave `specs/` present without also explaining the promotion
  rule.
- Do not install the stricter spine partially; if it is warranted, make the
  working-rules and batch-card surfaces explicit.
- Do not leave a project indefinitely in mixed posture once the stricter
  surface has already been proven and the project is meant to reach full
  strict compliance.
- Do not treat nested docs-authority repos like bespoke migrations when they
  already cleanly own the planning contract.
