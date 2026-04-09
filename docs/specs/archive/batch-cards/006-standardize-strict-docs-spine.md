# 006 - Standardize Strict Docs Spine

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.4
Governing refs: docs/contracts/001-working-rules.md, template-bundle/README.md, bundle-docs/README.md
Auto-start next card: yes, if the standard spine is fully defined and no planning gap appears

## Objective

Make the stricter Northstar docs spine explicit and copy-ready so setup and
execution no longer have to infer it from scattered docs.

## Scope

- define the standard stricter docs spine in bundle doctrine
- add the missing copy-ready working-rules contract template
- make the `specs/` batch-card surface explicit in the template bundle
- keep the bundle generic and copy-ready

## Steps

1. Write the standard docs spine doctrine and link it from the existing bundle docs.
2. Add the missing bundle files that make the stricter spine concrete.
3. Update the relevant bundle READMEs so the stricter spine is obvious without
   reading multiple distant docs.

## Acceptance Criteria

- the stricter docs spine is explicitly described in `bundle-docs/`
- `template-bundle/` includes a copy-ready working-rules contract template
- `template-bundle/specs/` clearly exposes the batch-card surface
- the bundle guidance explains the default spine versus stricter add-ons

## Evidence Required

- updated doctrine and bundle README surfaces
- new copy-ready files in `template-bundle/contracts/` and `template-bundle/specs/`

## Stop Conditions

- the standard spine still depends on operator inference instead of explicit docs
- the bundle becomes repo-specific or overly ceremonial

## Completion Notes

The standard stricter docs spine is now explicit in doctrine and in the
template bundle. The missing copy-ready working-rules template and
`specs/batch-cards/README.md` now make the stricter execution surface concrete
instead of implied.

## Next Task

Align `northstar-setup` and its templates so a stricter repo can scaffold this
docs spine directly instead of reconstructing it from doctrine.
