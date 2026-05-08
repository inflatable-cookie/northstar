# Define Consumer-Repo Autonomy Proof Lane

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/009-prove-combined-autonomy-model-in-consumer-repo.md
Batch refs: docs/roadmaps/g02/batch-cards/039-define-consumer-repo-autonomy-proof-lane.md

## Summary

Defined the external-proof lane for the combined autonomy model.

## Findings

- more internal autonomy doctrine would now be churn without external proof
- the next valid proof target must be an active consumer repo already using
  Northstar, not an artificial specimen
- the consolidation rule should stay strict: only proof-backed changes come
  back into Northstar

## Files Changed

- docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md
- docs/roadmaps/g02/batch-cards/039-define-consumer-repo-autonomy-proof-lane.md
- docs/roadmaps/g02/batch-cards/040-run-consumer-repo-autonomy-proof.md
- docs/roadmaps/g02/batch-cards/041-apply-consumer-repo-autonomy-findings.md
- docs/roadmaps/g02/009-prove-combined-autonomy-model-in-consumer-repo.md

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

The external-proof lane is explicit and the proof batch is ready. The next
step is to run the model against a real active consumer-repo lane.

## Next Task

Start `g02.009` batch `9.2` by running the combined autonomy model against a
real active consumer-repo lane and recording what still breaks outside
Northstar itself.
