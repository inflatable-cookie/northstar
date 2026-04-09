# Define Closeout Pattern

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g01.003 batch 3.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/003-ready-state-and-closeout-mechanics.md

## Summary

Defined the minimum closeout order for meaningful batches, then threaded that
sequence through the live working rules, doctrine, logs guidance, batch-card
template, and handoff surfaces.

## Files Changed

- updated `bundle-docs/sections/07-delivery-framework-and-autonomy.md`
- updated `docs/contracts/001-working-rules.md`
- updated `docs/logs/README.md`
- updated `template-bundle/logs/README.md`
- updated `template-bundle/specs/templates/batch-card-template.md`
- updated `skills/northstar-handoff/SKILL.md`
- updated `skills/northstar-handoff/references/handoff-contract.md`
- updated `skills/northstar-handoff/assets/templates/northstar-handoff.md.template`
- updated `template-bundle/logs/templates/thread-handoff-template.md`
- updated the live spec, batch-card, and roadmap next-task chain

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- closeout is now treated as an ordered sequence instead of a vague reminder to
  update planning surfaces
- handoff is explicitly positioned as a later closeout step rather than a
  substitute for logs or roadmap updates
- the reusable bundle and live repo now describe the same end-of-lane sequence

## Unresolved

- the live repo checks do not yet enforce the new readiness and closeout
  mechanics
- the mechanics still need to be proven in one follow-on execution lane

## Next Task

Start batch 3.3 by applying the readiness and closeout mechanics to the live
repo checks and proving them in one follow-on lane.
