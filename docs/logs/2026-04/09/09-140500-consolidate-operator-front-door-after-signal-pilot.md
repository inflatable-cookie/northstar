# Consolidate Operator Front Door After Signal Pilot

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md

## Summary

Applied the first evidence-backed operator-doc consolidation after the Signal
pilot. The core change is structural: normal operator docs now focus on
day-to-day routing, while pilot-maintenance pages were moved out of
`bundle-docs/operators/` and into `bundle-docs/maintenance/`.

## Files Changed

- added `bundle-docs/maintenance/README.md`
- added `bundle-docs/maintenance/operator-workflow-drill.md`
- added `bundle-docs/maintenance/operator-pilot-record-template.md`
- added `bundle-docs/maintenance/operator-doc-pruning-rubric.md`
- updated `bundle-docs/operators/README.md`
- updated `bundle-docs/operators/operator-quick-start.md`
- updated `bundle-docs/README.md`
- updated `README.md`
- updated live spec, batch-card, roadmap, and contract next-task chains
- removed pilot-maintenance pages from `bundle-docs/operators/`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the operator front door now distinguishes the two real operator states more
  clearly:
  - healthy active repo
  - unclear or drifted repo
- pilot, drill, and pruning pages no longer clutter the normal operator path
- `g02.001` is now complete with both the Signal pilot and the resulting
  consolidation logged in the live Northstar docs

## Unresolved

- Northstar still needs a decision on whether the next improvement lane should
  stay in `g02` or roll to `g03`
- the next lane itself has not been compiled yet

## Next Task

Decide whether the next Northstar improvement lane should stay in `g02` or roll
to `g03` now that the first external pilot and consolidation pass are
complete.
