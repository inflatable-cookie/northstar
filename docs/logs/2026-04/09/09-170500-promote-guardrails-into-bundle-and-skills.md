# Promote Guardrails Into Bundle And Skills

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.002 batch 2.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md

## Summary

Promoted the new execution guardrail pack into the copy-ready bundle and the
core installed Northstar skill surfaces, while also clarifying the intended
lifecycle of `specs/` as provisional planning surfaces rather than permanent
authority.

## Files Changed

- updated `template-bundle/README.md`
- updated `template-bundle/architecture/product-guardrails.md`
- updated `template-bundle/contracts/001-working-rules-template.md`
- updated `template-bundle/specs/README.md`
- updated `skills/northstar-setup/SKILL.md`
- updated `skills/northstar-setup/references/delivery-layer-adoption.md`
- updated `skills/northstar-setup/agents/openai.yaml`
- updated `skills/northstar-plan/SKILL.md`
- updated `skills/northstar-plan/references/modes/shape-with-specs-and-promote.md`
- updated `skills/northstar-plan/references/modes/compile-roadmaps.md`
- updated `skills/northstar-plan/agents/openai.yaml`
- updated `skills/northstar-recover/SKILL.md`
- updated `skills/northstar-recover/references/modes/refocus-drifted-project.md`
- updated `skills/northstar-recover/agents/openai.yaml`
- updated live roadmap/spec/batch-card state for `g02.002` batch `2.2`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- stricter repos now inherit an explicit anti-fake-work and anti-complexity
  guardrail pack from the copy-ready bundle
- the core Northstar skills now treat `specs/` as provisional planning
  surfaces, not permanent authority
- the intended answer on specs is now explicit:
  keep them while the lane is active or the history still helps, then archive
  or remove them when they no longer add value beyond the promoted canonical
  surfaces

## Unresolved

- the longer autonomy lane still needs to be run and logged
- installed skill homes still need a sync pass if the running environments
  should pick up the updated wording immediately

## Next Task

Start `g02.002` batch `2.3` by running a longer live Northstar lane under the
tightened guardrails and capture where autonomy still drifts or stops too
early.
