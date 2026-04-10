# Formalize Repo Posture Classification

Date: 2026-04-10
Roadmap refs: g02.019
Spec refs: docs/specs/022-formalize-repo-posture-classification.md

## Summary

Added an explicit repo-posture taxonomy and threaded it into the core
Northstar skills so setup, planning, and recovery can classify repo state more
mechanically.

## Evidence

- added `skills/northstar-setup/references/posture-classification.md`
- updated delivery doctrine with the posture model
- updated `northstar-setup`, `northstar-plan`, and `northstar-recover`
  workflow text and agent prompts to use the same posture language
- made paused strict gates and drifted-state triage more explicit in the skill
  mode references

## Validation

- `effigy qa`
- `effigy qa:docs`

## Next Task

Use the posture taxonomy in the next real setup, planning, or recovery pass
and watch whether it reduces operator interpretation at planning boundaries.
