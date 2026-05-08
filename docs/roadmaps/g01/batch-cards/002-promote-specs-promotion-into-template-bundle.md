# 002 - Promote Specs Promotion Into Template Bundle

Status: archived
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.2
Governing refs: docs/contracts/001-working-rules.md, template-bundle/specs/README.md
Auto-start next card: yes, if validation passes and the next card is ready

## Objective

Promote the minimum reusable specs-promotion artifacts into the template bundle
without bloating the copy-ready product surface.

## Scope

- add the copy-ready `template-bundle/specs/` surface
- add master-spec and batch-card templates
- update surrounding bundle guidance so specs are provisional and architecture
  plus contracts remain canonical

## Steps

1. Add `template-bundle/specs/README.md`.
2. Add a master-spec template and batch-card template.
3. Update bundle guidance to explain the promotion rule and keep specs optional.
4. Re-run repo validation.

## Acceptance Criteria

- the template bundle exposes a copy-ready `specs/` surface
- the bundle says specs are provisional and must promote into
  architecture/contracts
- `effigy qa`
- `effigy qa:docs`

## Evidence Required

- template-bundle files exist and are linked from bundle guidance
- validation commands recorded in the batch log

## Stop Conditions

- the bundle starts carrying repo-specific planning state
- the specs surface becomes mandatory instead of conditional

## Completion Notes

This card is complete. The bundle now carries the minimum reusable specs
surfaces and the promotion rule.

## Next Task

Update `northstar-plan` so it follows the same specs-first, promote-before-
execution rule by default.
