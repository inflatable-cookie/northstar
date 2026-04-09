# Apply Lane Budget And Pause-Signal Contract

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md
Batch refs: docs/specs/batch-cards/037-apply-lane-budget-and-pause-signal-contract.md

## Summary

Applied the lane-budget and pause-signal contract to the live working rules,
batch-card template, log guidance, and handoff surfaces.

## Findings

- the continuation model now distinguishes card-level in-bounds continuation
  from lane-level autonomy budget
- clean pauses can now be reported with a compact explicit vocabulary instead
  of free-form prose
- handoffs and logs can carry lane budget and pause state without introducing
  heavyweight run-state machinery
- the next useful step is to re-prove whether this combined model is now clean
  enough for routine use

## Files Changed

- docs/contracts/001-working-rules.md
- template-bundle/specs/templates/batch-card-template.md
- template-bundle/logs/README.md
- template-bundle/logs/templates/thread-handoff-template.md
- skills/northstar-handoff/SKILL.md
- skills/northstar-handoff/references/handoff-contract.md
- skills/northstar-handoff/assets/templates/northstar-handoff.md.template
- docs/specs/011-lane-budget-and-pause-signal-contract.md
- docs/specs/batch-cards/037-apply-lane-budget-and-pause-signal-contract.md
- docs/specs/batch-cards/038-reprove-lane-budget-and-pause-signal-contract.md
- docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md
- docs/README.md
- docs/specs/README.md
- docs/roadmaps/README.md
- docs/roadmaps/g02/README.md
- docs/roadmaps/generation-index.md
- docs/contracts/contract-index.md
- docs/logs/README.md
- scripts/check-northstar-repo-contract.ts

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

The lane-budget and pause-signal model is now explicit in the reusable
surfaces. The next step is to re-prove the combined continuation and
lane-budget model against another longer autonomous lane.

## Next Task

Start `g02.008` batch `8.3` by re-proving the lane-budget and pause-signal
contract against another longer autonomous lane.
