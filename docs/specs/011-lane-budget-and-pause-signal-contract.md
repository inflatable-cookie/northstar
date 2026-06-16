# 011 - Lane Budget And Pause-Signal Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.008

## Problem

Northstar now has a compact continuation-envelope contract for bounded ready
chains, but longer autonomous work still stops with too little explicit state
about the lane-level budget and the exact reason a run paused. That leaves too
much operator interpretation between "another card was in-bounds" and "the
agent paused cleanly for the right reason".

## Target Operating Model

Northstar should make lane-level autonomy budgeting and pause reasons explicit
enough that a run can stop cleanly without turning the next continuation into a
fresh diagnosis exercise.

That means:

- each active lane can express how much autonomous budget remains beyond the
  immediate card transition
- pause reasons use a compact explicit vocabulary instead of free-form prose
- logs and handoffs can tell the next thread whether the run stopped because
  the lane budget was exhausted, a stop signal fired, or the lane simply ended

## Goals

- define a compact lane-budget contract that complements the card-level
  continuation envelope
- define explicit pause-signal categories for clean stop reporting
- align the relevant doctrine, template, and handoff/log surfaces around the
  same model
- keep the result lean enough to aid day-to-day use rather than becoming
  orchestration metadata

## Non-Goals

- building a scheduler, worker pool, or persistent run-state service
- replacing the existing stop conditions with a softer pause-only model
- tracking fine-grained elapsed time inside every batch as operational
  telemetry

## Artifact Set

- docs/contracts/001-working-rules.md
- template-bundle/specs/templates/batch-card-template.md
- template-bundle/logs/README.md
- skills/northstar-handoff/SKILL.md
- skills/northstar-handoff/references/handoff-contract.md
- docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md

## Lane-Budget Contract

### Lane Budget

An active lane should be able to say, in compact file state:

- how much autonomous budget remains for the current run
- whether the current card is the end of that budgeted run
- whether the next continuation depends on a fresh operator decision

### Pause Signals

When a run stops, the reason should be explicit and short. The pause state
should distinguish between:

- `budget-exhausted`
- `stop-signal-fired`
- `lane-complete`
- `handoff-required`

### Relationship To Continuation Envelope

The continuation envelope remains the card-level rule for whether the next card
is in-bounds. The lane budget adds the lane-level answer to whether the run
should keep going even if another card is technically ready.

## Phased Delivery

### Phase 1

Define the lane-budget and pause-signal contract.

### Phase 2

Apply the contract to the reusable doctrine, template, and handoff/log
surfaces.

### Phase 3

Re-prove the combined continuation and lane-budget model against another longer
lane.

## Acceptance Criteria

- the lane-budget and pause-signal contract is explicit in the live planning
  surface
- the reusable surfaces reflect the same budget and pause posture
- the combined continuation and lane-budget model is re-proved as sufficient
  for routine bounded use

## Stop Conditions

- the lane starts introducing heavy run-state bookkeeping
- the pause model blurs the difference between a clean pause and a hard stop
