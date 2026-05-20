# 001 - Working Rules

Status: active
Owner: repo maintainers
Updated: 2026-05-19
Depends on: docs/architecture/system-architecture.md
Authority owners: repo maintainers
Affects: bundle-docs, template-bundle, skills, docs, scripts

## Problem

Northstar needs a tighter execution grammar, but splitting every standing rule
into a separate contract makes the surface noisier than it needs to be for a
single-repo planning lane like this one.

## Contract

### Delivery grammar

- Material work should follow this chain:
  `vision -> research/specs -> architecture + contracts -> roadmap milestone -> execution -> evidence -> closeout`.
- Use a separate contract only when a stable seam, authority boundary, or
  reusable rule surface genuinely needs one.
- Use a master spec when a goal spans multiple meaningful batches, changes
  user-facing behavior, or introduces non-trivial operational policy.
- A ready batch card must define scope, exact steps, governing refs, acceptance
  criteria, validation, evidence requirements, stop conditions, and whether
  auto-continuation is allowed.
- When planning is required for a material lane, do not stop at one next card.
  Compile a bounded runway that makes the higher-level owner, the next few
  meaningful batches or milestones, and the next planning checkpoint explicit.
- In a strict lane, a bare `continue` should resolve through the previous
  closeout's `Next Task`, which should normally point at the current ready card
  or an explicit stop/reassessment step.
- When planning is needed and the next direction is still materially
  ambiguous, stop and ask for operator intent instead of inventing the next
  lane or batch.
- Specs are provisional. Before material implementation runs, durable
  structural outcomes should be promoted into architecture and durable
  behavioral or policy rules should be promoted into contracts.
- Keep `docs/specs/` tidy over time: retain active or still-useful planning
  history, but archive or remove stale specs once promoted canonical surfaces
  already carry the truth and the lane is no longer active.
- Treat specs and batch-card lanes as having explicit lifecycle states:
  `active`, `retired-in-place`, and `archived`.
- Use `retired-in-place` only as a short-lived holding state when a recently
  closed planning artifact still needs to remain near active work for
  traceability.
- Move closed planning artifacts to `docs/specs/archive/` when they still merit
  preservation but no longer belong in the active specs surface.
- Keep the archive lean and traceable. Do not treat archived specs as canonical
  execution authority once architecture and contracts carry the truth.

### Execution guardrail pack

- Prefer real integrated behavior over mockups, placeholders, or token
  scaffolding.
- Prefer simplicity over decorative or architectural complexity that the
  governing refs do not require.
- Prefer end-to-end follow-through over convenient partial closure when a batch
  promised a working path.
- Prefer explicit incompleteness over implied completion when a path is still
  scaffolded or unproven.
- Treat disconnected gesture work as incomplete unless the batch was explicitly
  scoped as a bounded substrate-only step.

### Refactoring and release maturity

- **Before v1.0:** do not add compatibility aliases, shims, re-export layers,
  deprecated stubs, or silent fallbacks to keep obsolete paths working. Prefer
  direct migrations: update call sites and remove superseded surfaces in the
  same batch unless the operator directs a different shape.
- **Breaking changes:** when a refactor would break callers, contracts, or
  documented behavior, stop and raise it with the operator with a short impact
  summary and options. Do not unilaterally add a compatibility layer to avoid
  that conversation.
- **At v1.0 maturity and beyond:** default stance is maintaining expected
  functionality for stable, user-visible, or externally depended behavior.
  Deprecation windows, adapters, or other compatibility work may be required;
  still coordinate material breaks with the operator, but do not treat "delete
  the old path in one batch" as the automatic default when it would abandon
  supported behavior without an explicit decision.

### Ready-state rubric

- Full doctrine enumerations for batch-card fields and card-level readiness live
  in [`bundle-docs/sections/07-delivery-framework-and-autonomy.md`](../../bundle-docs/sections/07-delivery-framework-and-autonomy.md)
  under **Batch card rule** and **Ready-state rubric**. This subsection stays the
  compact binding surface for the northstar repo.
- Treat `ready` as a constrained execution state, not a placeholder label.
- A card is ready only when:
  - its objective is bounded enough to complete without fresh planning
    decisions
  - its governing refs point at current canonical surfaces
  - its scope boundaries, acceptance criteria, validation, evidence
    requirements, and stop conditions are explicit
  - no unresolved planning gap still governs the card's scope
  - no unresolved intent checkpoint still governs the card's scope
- A short auto-continuation chain is ready only when:
  - each card in the chain is individually ready
  - the cards belong to the same active roadmap/spec lane
  - the order is explicit and the next transition is already represented in
    file state
  - the chain stays inside the project's autonomy envelope
- A lane is planning-coherent only when:
  - the current roadmap/spec surfaces name the higher-level owner of the lane
  - the next likely batches or milestone handoff are visible beyond the
    immediate ready card
  - the next planning checkpoint is explicit rather than deferred until the
    current card finishes

### Continuation envelope

- Treat auto-continuation as a bounded envelope, not an open-ended permission.
- A continuation envelope must make explicit:
  - which next card may auto-start
  - how many already-defined ready cards remain in-bounds
  - what proof must pass before each transition stays valid
- The continuation envelope may stay active only while:
  - the completed card's evidence gate passed
  - the next card is already defined and still marked ready
  - the governing refs still match the live lane
  - no stop signal has been triggered
- If any part of that envelope is no longer explicit in file state, treat
  continuation as exhausted rather than implied.

### Lane budget and pause signals

- Treat lane budget as the lane-level answer to whether a run should keep
  spending autonomy budget even when another card is technically in-bounds.
- A lane-level budget should make explicit:
  - whether the current card is the end of the budgeted run
  - whether another operator decision is required before more autonomy is spent
  - which compact pause signal explains a clean stop
- Low context or normal thread compaction is not a pause signal. Treat it as a
  normal runtime event and let the same thread continue when the lane is still
  active.
- Use these pause-signal categories when a run stops cleanly:
  - `budget-exhausted`
  - `stop-signal-fired`
  - `lane-complete`
  - `handoff-required`
- Pause signals do not weaken hard stop conditions. They explain why a run
  stopped once the stop or budget boundary has been reached.

### Definition of done

Work in this repo is not done unless:

- the intended behavior or documentation change exists for real, not as a
  placeholder, mockup, or token partial implementation
- dependent references and planning surfaces are updated coherently
- required validation commands were actually run
- the relevant spec, batch card, roadmap milestone, and log state reflects the
  current truth
- unresolved blockers or limits are named explicitly instead of hidden inside a
  completion claim
- one clear next task remains unless the lane is genuinely complete
- that next task is explicit enough that a later bare `continue` does not need
  a recap prompt to find the correct next move

### Operator-facing reporting

- Closeout summaries should be written for operator comprehension first, not as
  a protocol dump.
- Lead with:
  - what was actually achieved
  - what the current lane state is now
  - what happens next
- Compress validation and protocol bookkeeping into short secondary detail.
- Mention roadmap/card/log ids only when they clarify the current state, not as
  the main story.
- Do not make the operator reconstruct the actual outcome from a list of file
  updates, card numbers, or validation commands.
- A good default closeout shape is:
  - outcome in plain language
  - current lane state
  - validation, only if it failed or materially affects confidence
  - concise next move
- Treat that as an end-of-turn closeout shape, not a structure that every
  short in-thread message must repeat.

### Compression policy

- Use glue-light writing where token economy matters more than polished prose.
- Internal execution surfaces should default to compressed, information-dense
  language:
  - agent chat responses
  - batch cards
  - roadmap milestones
  - logs
  - working rules and similar internal contracts
- Public-facing or explanatory surfaces should keep normal prose:
  - user-facing documentation
  - marketing or onboarding copy
  - tutorial or teaching material
  - architecture or vision prose when richer explanation is part of the job
- Compression should remove filler, repetition, and ceremonial transitions, not
  meaning.
- Prefer short bullets, fragments, symbols, and dense phrasing when the result
  stays clear to an informed operator.
- Do not force broken language when it harms comprehension or traceability.

### Closeout pattern

- Closeout is an ordered sequence, not a generic reminder to update docs.
- For a meaningful completed batch or stopping point:
  - update the current batch card status and completion notes first
  - update the active roadmap milestone if progress, readiness, or the next
    batch changed
  - refresh any front-door or currentness surfaces that still name the active
    lane, current ready card, or recent evidence chain
  - write the batch log with evidence, validation actually run, and unresolved
    blockers or limits
  - record whether the continuation envelope still holds or whether a stop
    signal exhausted it
  - record the lane budget state and the pause signal when the run is not
    simply continuing in-bounds
  - update or create a handoff only when another thread truly needs to take
    over or the user explicitly asks for one
  - leave one explicit next task in the highest-authority active surface that
    still governs the lane
- If the next work is not ready, say so explicitly in closeout rather than
  implying continuation.
- Do not declare the lane complete or create a handoff merely because context
  is low or the runtime may compact the thread. If the same thread can keep
  going after compaction, normal closeout plus `Next Task` is the correct path.
- In the operator-facing summary for that closeout, state the achieved change
  and the lane state before listing protocol artifacts or validation commands.

### Execution autonomy

- When a thread has a ready runway of cards, the default behavior is to
  continue through them without pausing for operator acknowledgment at every
  boundary.
- Baseline roadmap-only repos can still support healthy routing and shorter
  bounded runs, but the fuller continuation-envelope, lane-budget, and
  pause-signal model should be treated as a stricter `specs/` plus batch-card
  capability.
- Auto-continuation is allowed only when:
  - the next card is already defined and marked ready
  - the cards belong to the same active roadmap/spec lane
  - the governing refs still match the work
  - the prior card's evidence gate passed
  - the remaining continuation envelope is explicit in file state
  - no stop condition below has been triggered
- In a strict lane, a later bare `continue` should normally be enough because
  the prior closeout already named the next task and the current ready card.
- That should not collapse the lane into one-card improvisation. Planning work
  should leave enough runway that execution can see the broader lane shape and
  the next planning checkpoint without reopening strategy from scratch after
  every card.
- If a thread still needs a giant continuation prompt in ordinary use, treat
  that as a repo-surface or local-agent-contract failure worth tightening.
- Context compaction is compatible with that model. It should not be treated as
  a handoff-required boundary when the same thread can continue from the prior
  `Next Task`.
- Default upper bound for one uninterrupted run:
  - up to 3 consecutive ready batch cards
  - or roughly 90 minutes of focused work
  - whichever limit is hit first
- When that upper bound is reached cleanly, use `budget-exhausted` instead of
  implying that a hard stop condition fired.

### Automation runtime policy

- Prefer `effigy` when it already covers the repo operation.
- When repo-owned script logic is still needed, default to `TypeScript` run
  with `bun`.
- Use `bash` only for thin glue or compatibility boundaries that Effigy or
  Bun/TypeScript cannot own cleanly.
- Use `python` or another runtime only when a concrete technical requirement
  justifies it.

### Generation posture

- Treat roadmap generations as substantial sequencing eras, not tiny buckets of
  one or two milestone files.
- In long-running repos, expect one generation to hold many milestones before a
  new generation is useful.
- Treat roughly 20 to 40 milestones as the normal scale of a healthy
  generation before rollover is even worth discussing.
- Roll to a new generation only when the sequencing baseline itself needs a
  reset, not merely because one lane or batch closed quickly.
- Finishing a batch, suite, or lane of roadmaps does **not** close the
  generation. After one batch closes, compile or continue the next batch inside
  the same generation.
- Treat rollover as full generation closeout:
  - every roadmap in the old generation must be explicitly closed, superseded,
    or moved to backlog
  - the roadmap front doors must reflect that closed state before the next
    generation opens
  - stale specs from the closing generation must be archived or removed from
    `docs/specs/` so the new generation does not inherit old lane debris. Batch
    cards stay with their generation under `docs/roadmaps/gNN/batch-cards/` and
    do not need separate archiving.
- If those closeout conditions are not satisfied, repair the current generation
  instead of opening a new one.

### Strict-compliance audit and rollout

- When a mature repo is moving toward full strict compliance, keep that
  migration inside the normal planning spine.
- Use one active migration spec to record:
  - current posture
  - satisfied checkpoints
  - blocking gaps
  - whether mixed posture is still valid migration state or has become drift
  - current tranche
  - next tranche
  - the evidence needed to close the current tranche
- Use one active roadmap milestone to sequence the migration batches.
- Use normal batch logs to prove completed migration tranches.
- Do not invent a detached governance tracker for this.

### Currentness surfaces

- Keep the repo's front-door currentness surfaces aligned to the active lane:
  - `docs/README.md`
  - `docs/roadmaps/README.md`
  - `docs/roadmaps/generation-index.md`
  - `docs/roadmaps/gNN/README.md` for the active generation
  - `docs/contracts/contract-index.md`
  - `docs/logs/README.md`
- Refresh those surfaces whenever the active milestone, generation, or recent
  evidence chain changes materially.
- When currentness drift repeats enough to become predictable, add lightweight
  deterministic checks instead of relying only on manual cleanup.
- `docs/README.md` may surface one active spec alongside the active roadmap,
  but only when that spec still materially governs the next planning or
  execution decisions for the current lane.
- `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, and the
  active `docs/roadmaps/gNN/README.md` should each point to one active
  milestone, not a list of competing "current" lanes.
- `docs/logs/README.md` should keep a bounded recent-evidence window, usually
  the most recent 5 active-lane logs plus any still-governing rollover or
  decision log needed to explain the current state.
- Use a dedicated currentness-triage log only when currentness cleanup is
  itself the batch, or when multiple stale front-door/evidence surfaces need a
  short explicit cleanup record beyond ordinary batch closeout.

### Stop conditions

Execution must stop when:

- a planning gap or contradiction appears
- operator intent or prioritization is still unresolved across multiple
  plausible planning directions
- user-facing design ambiguity exceeds the product guardrails
- validation fails in a way that changes the plan
- required access, dependency, or authority is missing
- the work no longer matches the current master spec or roadmap intent
- the current batch card is exhausted and the next one is not already ready
- the remaining continuation envelope is missing, contradicted, or no longer
  justified in file state

## Validation

- `docs/specs/archive/001-northstar-delivery-layer.md` exists and matches these rules.
- at least one live batch card exists and is tied to an active roadmap
  milestone
- `effigy qa`
- `effigy qa:docs`

## Migration Notes

This repo is running in a compact contract mode. The live delivery layer is
still strict, but the standing rules are intentionally consolidated into one
working-rules contract until separate seam contracts become necessary.

## Roadmap Impact

- `g01.001`
- later batches that promote the live repo pilot into the bundle and skills
- `g02.001`
- `g02.002`
- `g02.003`
- `g02.004`
- `g02.005`
- `g02.006`
- `g02.007`
- `g02.008`
- `g02.009`
- `g02.010`

## Planning Notes

This contract closes the repo's immediate planning gap around how material work
should execute while keeping the active surface smaller and more focused than a
split contract stack.

## Next Task

Use `g02.010` to test the stricter delivery-layer adoption threshold against a
real active consumer-repo lane while continuing to rely on these working rules
as the live execution grammar.
