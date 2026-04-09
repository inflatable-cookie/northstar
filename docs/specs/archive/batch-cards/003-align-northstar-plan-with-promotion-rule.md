# 003 - Align Northstar Plan With Promotion Rule

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, skills/northstar-plan/SKILL.md
Auto-start next card: yes, if validation passes and the next card is ready

## Objective

Update `northstar-plan` so it treats specs as provisional planning and promotes
settled outcomes into architecture/contracts before roadmap execution.

## Scope

- update `northstar-plan` skill wording
- add a planning mode for shaping changes in specs and promoting outcomes
- tighten roadmap compilation to require canonical refs before execution

## Steps

1. Update the skill description, workflow, outputs, and guardrails.
2. Add a mode reference for specs-first planning and promotion.
3. Tighten the roadmap-compilation mode to reject raw-spec execution.
4. Update the skill metadata prompt.

## Acceptance Criteria

- `northstar-plan` explicitly supports specs as a provisional planning layer
- the skill requires promotion into architecture/contracts before roadmap
  execution
- `effigy qa`
- `effigy qa:docs`

## Evidence Required

- updated skill files under `skills/northstar-plan/`
- validation commands recorded in the batch log

## Stop Conditions

- the skill starts treating specs as a second permanent architecture
- roadmap compilation can still proceed directly from raw spec text

## Completion Notes

This card is complete. `northstar-plan` now follows the same promotion rule as
the published doctrine and the template bundle.

## Next Task

Update `northstar-recover` and `northstar-handoff` so they preserve both the
active spec lane and the canonical promoted refs during continuation and repair.
