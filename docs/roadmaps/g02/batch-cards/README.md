# Batch Cards

**Type: OPTIONAL** (strict posture) -- Create when using batch-card-driven execution.

Use this folder for ready execution cards that sit under an active master spec.

## Rule

- create a batch card only when the work is specific enough to execute without
  fresh design decisions
- keep cards tightly scoped and sequence them through the active roadmap lane
- allow auto-continuation when the next card is already ready and the
  governing refs still match the work
- default to continuing through ready cards without pausing for operator
  acknowledgment at every boundary
- stop when a planning gap, contract contradiction, or failed evidence gate
  changes the plan

## File pattern

- `NNN-<slug>.md`

## Next Task

`g02.027/079` is complete: the always-loaded instruction audit and Northstar
source/template compaction are closed out. `g02.026/078` remains ready but deferred until operator-provided live feedback
supplies evidence for the starter surfaces. The architecture-refocus and reframe
routes are complete. Northstar does not dispatch the consumer run.
