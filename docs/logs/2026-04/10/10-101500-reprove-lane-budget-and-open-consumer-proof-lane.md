# Re-Prove Lane Budget And Open Consumer Proof Lane

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md
Batch refs: docs/roadmaps/g02/batch-cards/038-reprove-lane-budget-and-pause-signal-contract.md

## Summary

Re-proved the combined continuation and lane-budget model and closed
`g02.008`. The model is now good enough for bounded routine use inside
Northstar itself. The next meaningful step is external proof in a real active
consumer repo rather than further internal doctrine churn.

## Findings

- the combined continuation and lane-budget model now distinguishes in-bounds
  continuation, clean budget exhaustion, and pause reasons clearly enough for
  Northstar's own live lanes
- the remaining uncertainty is external: whether the same model stays legible
  in a real consumer repo with non-doctrine work
- the next improvement should therefore be proof-backed, not internally
  speculative

## Files Changed

- docs/specs/011-lane-budget-and-pause-signal-contract.md
- docs/roadmaps/g02/batch-cards/038-reprove-lane-budget-and-pause-signal-contract.md
- docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

`g02.008` is complete. The next active lane is `g02.009`, which will prove the
combined autonomy model against a real active consumer repo before more
internal refinement.

## Next Task

Start `g02.009` batch `9.1` by defining the consumer-repo autonomy proof lane.
