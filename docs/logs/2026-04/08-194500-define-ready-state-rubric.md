# Define Ready-State Rubric

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.003 batch 3.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/003-ready-state-and-closeout-mechanics.md

## Summary

Defined the minimum ready-state rubric for single cards and short autonomous
chains, then threaded it through the live contract, doctrine, reusable
planning templates, and `northstar-plan`.

## Files Changed

- updated `bundle-docs/sections/07-delivery-framework-and-autonomy.md`
- updated `docs/contracts/001-working-rules.md`
- updated `template-bundle/specs/templates/batch-card-template.md`
- updated `template-bundle/roadmaps/templates/roadmap-milestone-template.md`
- updated `template-bundle/specs/README.md`
- updated `skills/northstar-plan/SKILL.md`
- updated `skills/northstar-plan/references/modes/compile-roadmaps.md`
- updated the live spec, batch-card, and roadmap next-task chain

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- `ready` is now treated as a constrained execution state rather than a loose
  label
- the file-state checks for a ready card and a ready short chain are now
  visible in both the live repo and the reusable bundle
- roadmap compilation now has a clearer bar for when a card or chain may be
  marked ready

## Unresolved

- the closeout pattern still needs to be defined and propagated
- the live repo checks do not yet enforce the new readiness mechanics

## Next Task

Start batch 3.2 by defining the closeout pattern in doctrine, the working
rules, and the reusable handoff/log surfaces.
