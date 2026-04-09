# Apply Ready-State And Closeout Mechanics

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g01.003 batch 3.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/003-ready-state-and-closeout-mechanics.md

## Summary

Applied the new readiness and closeout mechanics to the live repo checks,
synced the updated planning and handoff skills into the installed homes, and
used the new closeout order to finish the lane.

## Files Changed

- updated `scripts/check-northstar-repo-contract.ts` to defend the new
  readiness and closeout surfaces
- synced `skills/northstar-plan/` into both Codex and Claude
- synced `skills/northstar-handoff/` into both Codex and Claude
- updated the live spec, batch-card, roadmap, contract-index, and front-door
  next-task chains

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the live repo checks now defend the new readiness and closeout mechanics
- the installed plan and handoff skills now match the repo's current execution
  model
- the batch itself used the new closeout pattern cleanly: checker updates,
  installed-surface sync, validation, then planning/log closeout
- `g01.003` is complete

## Unresolved

- the remaining open question is structural rather than doctrinal: whether the
  next improvement lane should stay in `g01` or start a clean new generation

## Next Task

Decide whether the next live Northstar improvement still belongs in `g01` or
should start a clean new generation.
