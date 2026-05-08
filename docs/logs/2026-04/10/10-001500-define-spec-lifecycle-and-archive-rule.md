# Define Spec Lifecycle And Archive Rule

Status: complete
Owner: repo maintainers
Date: 2026-04-10
Roadmap refs: g02.005 batch 5.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/008-spec-lifecycle-and-archive-mechanics.md

## Summary

Defined the reusable lifecycle and archive rule for specs and batch-card lanes.
The rule now distinguishes active planning from short-lived retired-in-place
artifacts and from archived planning history, and it establishes a lean
`docs/specs/archive/` posture for preserved closed lanes.

## Findings

The key requirement is not just "keep specs tidy" but to define where closed
planning artifacts should go and what authority they lose when they move:

- `active` is for live planning only
- `retired-in-place` is a short-lived traceability state, not a resting place
  for old plans
- `archived` is for preserved planning history that no longer belongs in the
  active specs surface

That gives Northstar a clearer way to reduce `docs/specs/` without destroying
traceability or leaving old specs to compete with canonical surfaces.

## Files Changed

- updated `bundle-docs/sections/08-specs-and-promotion.md`
- updated `template-bundle/specs/README.md`
- added `template-bundle/specs/archive/README.md`
- updated `docs/contracts/001-working-rules.md`
- updated `docs/specs/README.md`
- added `docs/specs/archive/README.md`
- updated `docs/roadmaps/g02/batch-cards/027-define-spec-lifecycle-and-archive-rule.md`
- updated `docs/roadmaps/g02/batch-cards/028-apply-spec-lifecycle-rule-to-live-repo.md`
- updated `docs/roadmaps/g02/005-tighten-spec-lifecycle-and-archive-mechanics.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the lifecycle rule is now explicit in doctrine, the bundle, and live working
  rules
- the archive posture is defined without overbuilding a second planning tree
- the live cleanup batch is now ready

## Unresolved

- the live specs surface still needs to be reduced according to the new rule
- the resulting surface still needs a re-proof pass after cleanup

## Next Task

Start `g02.005` batch `5.2` by applying the lifecycle rule to the live
Northstar specs surface.
