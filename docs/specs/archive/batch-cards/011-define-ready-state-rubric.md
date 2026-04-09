# 011 - Define Ready-State Rubric

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/003-ready-state-and-closeout-mechanics.md
Roadmap refs: g01.003 batch 3.1
Governing refs: docs/contracts/001-working-rules.md, template-bundle/specs/templates/batch-card-template.md, skills/northstar-plan/SKILL.md
Auto-start next card: yes, if the rubric is explicit in doctrine, templates, and plan surfaces

## Objective

Make it explicit when a single card or a short card chain is genuinely ready
for autonomous execution.

## Scope

- define the ready-state rubric in doctrine and working rules
- update batch-card and roadmap templates so readiness is visible in the file
- update `northstar-plan` so roadmap compilation uses the same rubric

## Steps

1. Define the minimum readiness criteria for a single card.
2. Define the extra criteria for a multi-card autonomous chain.
3. Update the reusable templates so readiness is visible rather than implied.
4. Align `northstar-plan` and the live repo wording with the same rules.

## Acceptance Criteria

- the repo defines what makes a card ready
- the repo defines what makes a short card chain safe for auto-continuation
- the batch-card and roadmap templates expose the readiness checks directly
- `northstar-plan` points at the same rubric

## Evidence Required

- updated doctrine, working-rules, and template surfaces
- updated planning skill surfaces

## Stop Conditions

- the rubric still depends on operator intuition more than file state
- the rubric widens scope instead of constraining it

## Completion Notes

The repo now defines the minimum file-state checks for a ready card and a ready
short chain in doctrine, the live working rules, reusable planning templates,
and `northstar-plan`.

## Next Task

Define the closeout pattern so completed lanes can update their state without a
fresh round of manual coordination.
