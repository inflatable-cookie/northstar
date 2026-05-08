# Define Continuation Envelope Contract

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/007-define-continuation-envelope-and-stop-signal-contract.md
Batch refs: docs/roadmaps/g02/batch-cards/033-define-continuation-envelope-contract.md

## Summary

Defined the continuation-envelope and stop-signal contract for longer
autonomous Northstar lanes.

## Findings

- a single `Auto-start next card` flag is not enough to define how far a chain
  may continue safely
- continuation needs explicit transition proof, not just sequence order
- failed validation, planning gaps, and new user-facing ambiguity must remain
  hard stop signals
- logs and handoffs should preserve the remaining continuation envelope when it
  still exists rather than resetting context to only the last completed task

## Files Changed

- docs/specs/010-continuation-envelope-and-stop-signal-contract.md
- docs/roadmaps/g02/batch-cards/033-define-continuation-envelope-contract.md
- docs/roadmaps/g02/batch-cards/034-apply-continuation-envelope-contract.md
- docs/roadmaps/g02/batch-cards/035-reprove-continuation-envelope-contract.md
- docs/roadmaps/g02/007-define-continuation-envelope-and-stop-signal-contract.md

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

The contract is explicit and the implementation batch is ready. The next step
is to push the continuation model into the live and reusable doctrine,
templates, and handoff/planning surfaces.

## Next Task

Start `g02.007` batch `7.2` by applying the continuation-envelope and
stop-signal contract to the working rules, templates, and handoff/planning
surfaces.
