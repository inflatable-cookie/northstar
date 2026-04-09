# 07 Delivery Framework and Autonomy

Status: active
Updated: 2026-04-08

## Why this section matters now

Northstar's planning spine is useful, but complex projects still drift when
agents can treat roadmap milestones as loose suggestions rather than tightly
defined delivery paths. The recurring failure mode is not only bad planning. It
is weak execution grammar: mockups pass as completion, UI complexity grows
without product need, partial work is treated as done, and operators have to
keep typing "continue" just to maintain momentum.

This section defines the delivery layer that sits underneath planning and makes
autonomy safer. The goal is to reduce improvisation after planning is complete
and make long agent runs possible without special prompting.

## Scope

Define the delivery artifacts, autonomy rules, and anti-failure guardrails that
turn approved planning into constrained execution.

This section governs:

- product guardrails
- definition of done
- execution autonomy policy
- master specs
- batch cards
- deviation and stop rules

It does not replace vision, specs, architecture, contracts, roadmaps,
research, or logs. It tightens what must happen between roadmap intent and
claimed completion.

## Delivery chain

For material work, the expected chain is:

`vision -> research/specs -> architecture + contracts -> roadmap milestone -> execution -> evidence -> closeout`

Specs are the planning layer here, not the final authority. Once a change is
accepted, its durable outcomes should be promoted into architecture/contracts
before roadmap execution relies on them.

## Canonical delivery artifacts

Projects using the stricter mode should carry these artifacts:

- `docs/architecture/product-guardrails.md`
- `docs/specs/NNN-<slug>.md` for master specs
- `docs/specs/batch-cards/NNN-<slug>.md` for execution cards
- `docs/contracts/NNN-<slug>.md` only when a separate contract surface is worth
  the extra split

Use them as follows:

- `product-guardrails.md`
  locks simplicity, UX direction, anti-fake-work rules, and constraints that
  should apply across multiple milestones
- master specs
  define the provisional realization plan for a goal or epic before its durable
  outcomes are promoted
- batch cards
  define the exact execution unit an agent may work through without making fresh
  planning decisions
- separate contracts
  are reserved for durable seams, authority boundaries, or other rules that
  need to stand apart from architecture/specs

For many projects, definition of done and execution autonomy can live in a
compact working-rules artifact rather than as multiple separate contracts.

## Product guardrails rule

Every project should define a small set of cross-cutting rules that make bad
default behavior harder.

At minimum, product guardrails should explicitly cover:

- simplicity expectations for operator experience and UI
- anti-placeholder rules
- anti-mockup rules
- complexity caps or design constraints where relevant
- what should be treated as a stop condition rather than "good enough for now"

## Execution guardrail pack

For autonomy-sensitive projects, the guardrail pack should make five things
explicit:

- real over representational
  - do not stop at mockups, placeholders, or token scaffolding if the batch was
    supposed to land working behavior
- simplicity over flourish
  - do not add UI or interaction complexity unless the product need is explicit
    in the governing refs
- integration over isolated gesture work
  - partial seams, fake adapters, and disconnected surfaces do not count as
    completion for an end-to-end batch
- follow-through over convenient stopping points
  - when a batch promises a realized user or operator path, carry the work to
    the contract-valid end state or mark it incomplete
- explicit incompleteness over implied closure
  - if the remaining path is still scaffolded, mocked, or unproven, record that
    limit instead of claiming the milestone is effectively done

## Definition of done rule

Completion should be evidence-based, not prose-based.

Work should not be marked done unless:

- the intended behavior exists for real, not as a mockup or placeholder
- dependent files and references are updated coherently
- required validation was actually run
- the relevant roadmap/spec/card state was updated
- a batch log or equivalent evidence exists
- the next task is clear

## Closeout pattern

Closeout should be an ordered sequence, not a loose reminder to "update the
docs."

For a meaningful completed batch or stopping point, the minimum closeout order
is:

1. update the current batch card so its status and completion notes reflect the
   truth
2. update the active roadmap milestone if the batch changed milestone progress,
   readiness, or the next batch
3. write the batch log with the evidence, validation actually run, and any
   unresolved blockers or limits
4. update or create a handoff only when another thread really needs to take
   over
5. leave one explicit next task in the highest-authority active surface that
   still governs the lane

If the lane is stopping because the next work is not ready, the closeout should
say that explicitly rather than pretending the sequence naturally continues.

## Master spec rule

Use a master spec when a goal:

- spans more than one meaningful batch
- changes user-facing behavior
- introduces new contracts or operational policy
- requires non-trivial rollout, migration, or validation planning
- affects more than one repo, package, or authority surface

The master spec should define:

- the problem
- target operating model
- goals and non-goals
- artifact set and dependencies
- phased delivery plan
- validation strategy
- stop conditions and open questions

Before execution of material implementation work, the spec should no longer be
the only place that durable structure or behavior is defined.

## Batch card rule

Batch cards are the paint-by-numbers execution unit.

Every ready batch card should define:

- exact objective
- governing spec, roadmap, and other authority refs
- scope boundaries
- ordered implementation steps
- acceptance criteria
- validation commands
- evidence required for closure
- stop conditions
- whether the next card may auto-start

If a batch card still requires material product or system decisions, it is not
ready.

## Ready-state rubric

Treat `ready` as a real execution state, not a hopeful label.

A single batch card is ready only when all of the following are true:

- the card status is explicitly `ready`
- the objective is bounded enough to finish without fresh design or planning
  decisions
- the governing refs point at current canonical surfaces rather than only
  provisional planning notes
- scope boundaries and stop conditions are explicit
- acceptance criteria, validation, and evidence requirements are explicit
- no unresolved planning gap still governs the card's scope
- the next task points either to the next ready card or to the correct stop or
  promotion step

A short autonomous chain is ready only when:

- each card in the chain is individually ready
- the cards all belong to the same active roadmap/spec lane
- the card order is explicit
- each handoff between cards is already represented in file state rather than
  depending on fresh judgment
- auto-start is allowed on each transition that should continue without
  operator intervention
- the chain stays inside the project's autonomy envelope

If any of these checks fail, the work is not ready for hands-off execution.

## Autonomy support levels

Northstar supports more than one useful operating mode.

- baseline roadmap mode
  - a repo using the baseline spine can still support healthy active-lane
    routing, clear milestone sequencing, and shorter bounded runs driven by
    roadmap, contract, and log surfaces
- lane-first stricter mode
  - a mature baseline repo may add `docs/specs/` and batch cards for one active
    lane when that lane needs explicit continuation-envelope, lane-budget, and
    pause-signal state without forcing a repo-wide rewrite first
- stricter delivery mode
  - a repo that broadly wants the fuller paint-by-numbers execution layer
    should adopt `docs/specs/` and batch cards as a standing surface

Lane-first stricter adoption is the migration entry point, not the long-term
doctrinal destination. When a project is expected to live under the strict
Northstar framework, the intended end state is full stricter compliance across
the project rather than a permanent mixed posture.

Do not over-promise autonomy from a roadmap-only repo. The baseline spine can
be valid and productive, but it is not the same thing as the stricter
paint-by-numbers execution layer.

Do not install the stricter layer mechanically either. Use it when longer
hands-off runs, tighter anti-drift guardrails, or more explicit execution state
are actually needed. In a mature baseline repo, prefer lane-first adoption
before a full repo-wide rewrite when the need is local to one active lane.

## Full strict compliance

For projects that are meant to live under the strict Northstar framework, full
strict compliance should mean all of the following are true:

- the project carries the stricter docs spine as a normal working surface, not
  only on one provisional lane
- active material work is governed through specs and batch cards rather than
  roadmap prose alone
- architecture and contracts are current enough that roadmap execution is
  compiled from canonical surfaces rather than inferred later
- product guardrails, working rules, and closeout expectations are explicit and
  used in normal execution
- currentness surfaces, spec hygiene, and archive posture are maintained as
  routine work rather than occasional cleanup

Treat this as a project-level operating state, not just the presence of a few
files.

## Migration phases

Mature projects moving to full strict compliance should usually pass through
these phases:

1. baseline posture
   - the repo has the baseline spine and coherent active-lane routing
2. lane-first stricter adoption
   - one active lane uses specs and batch cards to prove the stricter surface
     works in the real project
3. expanding strict coverage
   - the stricter spine becomes the default for new material lanes and the
     standing project surfaces are upgraded accordingly
4. full strict compliance
   - mixed-mode operation is no longer the norm and active work runs under the
     strict delivery layer by default

Projects should not remain in phase 2 or 3 indefinitely without an explicit
reason. Once the stricter surface is proven and the project is meant to live
there, mixed posture should be treated as migration debt rather than a stable
operating model.

## Migration checkpoints

Before a project claims full strict compliance, the minimum checkpoints should
be true:

- the stricter spine is present at project level, not only in a one-off lane
- at least the active material lanes use specs and batch cards as the execution
  unit
- product guardrails, working rules, and contract indexing are explicit and
  current
- roadmap milestones point at canonical architecture/contracts and ready cards
  rather than relying on prose-only next steps
- logs and handoffs reflect the closeout sequence and execution state expected
  by the strict doctrine
- closed planning artifacts are archived or retired cleanly enough that
  `docs/specs/` still reflects live planning

## Autonomy rule

Autonomy should be pre-authorized through artifacts, not recreated by operator
intervention.

An agent may continue across consecutive ready batch cards only when all of the
following are true:

- the cards belong to the same active spec/roadmap lane
- the governing architecture/contracts exist
- the prior card's evidence gate passed
- the execution policy for the project allows auto-continuation
- no stop condition has been triggered

Operators should not need to keep sending "continue" when the next ready card
is already defined and permitted.

## Stop conditions

Execution must stop and return to planning or operator review when:

- a required contract is missing or contradictory
- a batch reveals a planning gap
- user-facing design ambiguity exceeds the product guardrails
- validation fails in a way that changes the plan
- required access, dependency, or repo authority is missing
- the work no longer matches the current master spec or roadmap intent

## Deviation protocol

When work deviates from the planned path:

1. stop execution on the affected card
2. record the deviation in the active card/spec/log flow
3. decide whether the issue is:
   - a card rewrite
   - a spec rewrite
   - a contract change
   - a roadmap recompile
4. resume only after the execution path is valid again

## Strict-compliance audit and rollout

For mature projects moving toward full strict compliance, Northstar should make
the migration operational rather than rhetorical.

The audit surface should make these questions explicit:

- what posture the project is currently in:
  `baseline`, `lane-first stricter adoption`, `expanding strict coverage`, or
  `full strict compliance`
- which strict-compliance checkpoints are already satisfied
- which gaps still block the next migration phase
- whether mixed posture is still deliberate migration state or has drifted into
  unowned inconsistency

The rollout surface should make these questions explicit:

- what the current migration tranche is
- what the next migration tranche is
- what evidence proves the current tranche is complete
- which project-level surfaces still need to change before full strict
  compliance can be claimed

Keep that migration state inside the normal planning spine:

- use one active migration master spec to carry the audit posture, checkpoint
  state, blocking gaps, and tranche plan
- use one active roadmap milestone to sequence the migration work
- use batch logs to prove completed tranches and rollout decisions

Do not invent a separate governance board or detached tracker for this. Strict
compliance migration should live in the same docs surfaces that already govern
the repo.

## Automation posture

The framework should work as much as possible without special phrasing from the
operator.

That means the installable skills should eventually behave like this:

- `northstar-setup`
  installs the guardrail pack by default for stricter projects
- `northstar-plan`
  produces specs and batch cards when needed, then promotes settled outcomes
  into architecture/contracts before roadmap execution
- `northstar-recover`
  repairs specs, architecture, contracts, and roadmaps when execution drifts
- `northstar-research`
  promotes findings into specs, architecture, and contracts
- `northstar-handoff`
  carries forward the active spec, canonical refs, current card, and remaining
  autonomy envelope

The aim is fewer special instructions in conversation and more behavior driven
by the repo's own planning surfaces.

## Dependencies

- Vision defines longer-term goals and constraints.
- Specs define provisional realization strategy for material goals.
- Architecture defines realized system shape and invariants.
- Contracts define enforced boundaries and execution rules.
- Batch cards define the exact execution unit.
- Roadmaps sequence the cards into milestone lanes.
- Logs prove what was completed and why.

## Next task

Keep the strict-compliance audit and rollout surface compact: one active
migration spec, one active roadmap milestone, and batch logs that prove each
completed tranche.
