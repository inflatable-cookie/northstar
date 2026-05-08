# Define Lane Budget And Pause-Signal Contract

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md
Batch refs: docs/roadmaps/g02/batch-cards/036-define-lane-budget-and-pause-signal-contract.md

## Summary

Defined the lane-budget and pause-signal contract that complements the
card-level continuation envelope.

## Findings

- the continuation envelope answers whether the next card is still in-bounds,
  but not whether the overall run should keep spending autonomy budget
- a compact pause vocabulary is enough for clean stop reporting:
  `budget-exhausted`, `stop-signal-fired`, `lane-complete`, and
  `handoff-required`
- the next useful slice is to apply that model to the doctrine, template, and
  handoff/log surfaces rather than inventing heavier run-state machinery

## Files Changed

- docs/specs/011-lane-budget-and-pause-signal-contract.md
- docs/roadmaps/g02/batch-cards/036-define-lane-budget-and-pause-signal-contract.md
- docs/roadmaps/g02/batch-cards/037-apply-lane-budget-and-pause-signal-contract.md
- docs/roadmaps/g02/batch-cards/038-reprove-lane-budget-and-pause-signal-contract.md
- docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

The lane-budget contract is explicit and the implementation batch is ready.
The next step is to align the reusable surfaces with that model.

## Next Task

Start `g02.008` batch `8.2` by applying the lane-budget and pause-signal
contract to the reusable doctrine, template, and handoff/log surfaces.
