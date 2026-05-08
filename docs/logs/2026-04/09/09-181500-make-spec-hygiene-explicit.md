# Make Spec Hygiene Explicit

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.002 batch 2.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md

## Summary

Made regular spec hygiene an explicit part of the Northstar protocol so
`docs/specs/` is expected to stay focused on active planning as a project
grows.

## Files Changed

- updated `bundle-docs/sections/08-specs-and-promotion.md`
- updated `docs/contracts/001-working-rules.md`
- updated `template-bundle/specs/README.md`
- updated `docs/specs/README.md`
- updated `skills/northstar-plan/SKILL.md`
- updated `skills/northstar-recover/SKILL.md`
- updated `skills/northstar-setup/references/delivery-layer-adoption.md`
- updated `docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md`
- updated `docs/roadmaps/g02/002-tighten-execution-guardrails-and-extend-autonomy.md`
- added `docs/roadmaps/g02/batch-cards/019-make-spec-hygiene-explicit.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the protocol now explicitly says specs should be tidied regularly rather than
  allowed to grow unchecked
- the intended behavior is explicit:
  keep active or still-useful specs, and archive or remove stale ones once the
  canonical surfaces already carry the durable truth
- the longer autonomy lane now follows a cleaner, more explicit specs posture

## Unresolved

- the longer autonomy lane still needs to be run and logged
- no actual spec-archive move was needed in this repo yet because the active
  spec set is still live

## Next Task

Start `g02.002` batch `2.4` by running a longer live Northstar lane under the
tightened guardrails and the new spec-hygiene rule.
