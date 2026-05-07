# 08 Specs and Promotion

Status: active
Updated: 2026-04-09

## Why this section matters now

Specs are useful, but only when they have a clear job. If they are allowed to
define the same durable truths as architecture and contracts, Northstar gains
another planning surface without gaining clarity.

This section defines specs as provisional planning artifacts. They are used to
shape a change before it is settled, then the durable outcomes are promoted into
architecture and contracts before execution proceeds.

## Scope

Define when specs should exist, what they should contain, and how their outputs
must be promoted into canonical surfaces.

This section governs:

- master specs
- batch cards
- promotion from specs into architecture and contracts
- the boundary between provisional planning and canonical execution authority

It does not replace vision, architecture, contracts, roadmaps, or logs.

## Official flow

The intended Northstar flow is:

`vision -> research/specs -> architecture + contracts -> roadmaps -> execution -> logs`

Use specs while a change is still being shaped.
Use architecture and contracts once the design is accepted and implementation is
ready to proceed.

## What specs are for

Specs are for:

- working through a non-trivial change before it is settled
- defining realization phases for a large goal
- breaking a complex plan into batch cards
- exposing open questions, stop conditions, and validation needs before the
  change hardens

Specs are not the main place to define durable system shape or durable
behavioral rules.

## What architecture is for

Architecture is the durable description of the realized system shape.

Architecture should answer:

- what exists
- what owns what
- how data and authority flow
- what invariants the system preserves

Once a structural decision is accepted, it belongs in architecture, not only in
the spec that discovered it.

## What contracts are for

Contracts are the hard-definition surface.

Contracts should define:

- behavior
- interfaces
- policies
- failure semantics
- completion or operational rules when they need durable enforcement

Once a behavioral rule is accepted and execution depends on it, it belongs in a
contract rather than only in the planning spec that proposed it.

## Promotion rule

Before execution starts on a material change:

- durable structural decisions discovered in specs must be promoted into
  architecture
- durable behavioral or policy rules discovered in specs must be promoted into
  contracts
- roadmap milestones must reference the canonical architecture/contracts
  surfaces, not rely only on the spec

Specs may still be referenced as planning history, but they should not remain
the sole authority once the design is settled.

## Spec hygiene rule

Keep `docs/specs/` tidy as the project grows so the folder mostly reflects
active planning rather than every plan the repo has ever produced.

Apply this rule:

- keep specs that still govern an active lane or still provide useful planning
  history for near-term work
- archive or remove specs once the lane is closed and the promoted
  architecture/contracts already carry the durable truth
- do not let `docs/specs/` become a graveyard of stale plans that competes with
  canonical surfaces for attention
- treat spec cleanup as part of normal closeout and recovery work, not only as
  an occasional cleanup drive
- before roadmap generation rollover, purge stale generation-specific specs and
  batch cards from the active specs tree so the next generation does not open
  on inherited planning debris

## Spec lifecycle rule

Treat specs and batch-card lanes as having explicit lifecycle states:

- `active`: still governs an active lane or an imminent continuation batch
- `retired-in-place`: closed and still worth keeping briefly in the active tree
  while nearby work or traceability still benefits from it
- `archived`: no longer governs live work and moved out of the active specs
  surface so `docs/specs/` stays focused on active planning

Use `retired-in-place` sparingly. It is a short-lived holding state, not the
normal resting place for old planning artifacts.

## Archive rule

When a closed planning artifact still deserves preservation but no longer
belongs in the active specs surface:

- move it under `docs/specs/archive/`
- keep a lean structure there, usually mirroring only the minimal grouping the
  repo needs to retain traceability
- preserve references and context enough to explain what the artifact governed
- do not treat archive files as canonical execution authority once architecture
  and contracts carry the truth

Archive is for planning history and traceability, not a second live planning
lane.

## Master spec rule

Use a master spec when a goal:

- spans more than one meaningful batch
- changes user-facing behavior significantly
- introduces a non-trivial rollout or migration path
- has enough uncertainty that the team needs to reason through the path before
  architecture/contracts can be finalized

The master spec should define:

- the problem
- target operating model
- planning assumptions
- goals and non-goals
- phased realization plan
- open questions
- promotion targets
- stop conditions

## Batch card rule

Batch cards sit under a master spec and define a bounded execution card.

They should contain:

- exact objective
- governing spec plus canonical refs where already promoted
- scope boundaries
- ordered steps
- acceptance criteria
- validation commands
- evidence required
- stop conditions
- whether the next card may auto-start

Batch cards can guide execution tightly, but they should still inherit their
durable truths from architecture/contracts once those truths have been
promoted.

## Sparsity rule

Do not create specs for every small change.

Use them when they reduce ambiguity meaningfully.
If a change is already obvious and the architecture/contracts are clear, go
straight from those surfaces into roadmap execution.

## Dependencies

- Vision sets direction.
- Research and specs help shape changes before they harden.
- Architecture captures realized structure.
- Contracts capture durable behavioral rules.
- Roadmaps sequence approved work.
- Logs prove what was actually completed.

## Quick reference

- [Glossary: Specs, promotion](../glossary.md#research-and-promotion)
- [Cheat sheet: Posture quick pick](../cheat-sheet.md#posture-quick-pick)

## Next task

Apply the lifecycle and archive rule to a live specs surface so the active tree
shrinks back toward active planning instead of accumulating closed lanes in
place.
