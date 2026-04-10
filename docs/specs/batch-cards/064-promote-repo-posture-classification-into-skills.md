# 064 - Promote Repo Posture Classification Into Skills

Status: complete
Owner: repo maintainers
Completed: 2026-04-10
Roadmap: g02.019
Spec: docs/specs/022-formalize-repo-posture-classification.md
Governing refs: docs/contracts/001-working-rules.md

## Objective

Add one explicit repo-posture classification model to the reusable doctrine and
thread it into `northstar-setup`, `northstar-plan`, and `northstar-recover`.

## Scope

- close the workspace-container specimen lane
- add the posture taxonomy to doctrine
- update setup/plan/recover skills and prompts to use that taxonomy
- make paused-gate versus ready-lane versus drifted-state triage more explicit

## Out of Scope

- redesigning the full Northstar skill surface
- changing consumer repos again
- adding more top-level skills

## Steps

- [x] close `g02.018` and open the posture-classification lane
- [x] add the posture taxonomy to doctrine and setup references
- [x] update setup/plan/recover skills and agent prompts to classify posture explicitly
- [x] log the change and refresh Northstar currentness surfaces

## Acceptance Criteria

- [x] one posture taxonomy exists in reusable Northstar docs
- [x] `northstar-setup` explicitly classifies repo posture and authority mode
- [x] `northstar-plan` and `northstar-recover` explicitly distinguish ready lane, paused gate, migration state, and drifted state

## Validation

- [ ] `effigy qa`
- [ ] `effigy qa:docs`

## Next Task

Use the posture taxonomy in the next real setup, planning, or recovery pass and
watch whether it reduces operator interpretation at planning boundaries.
