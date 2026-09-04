# Batch Cards

**Type: OPTIONAL** -- Create when using batch-card-driven execution.

Use this folder for ready execution cards that sit under an active roadmap lane.

Batch cards own **step-by-step execution detail** for one batch. The parent
roadmap milestone owns lane shape and the multi-batch sequence. Do not recreate
the roadmap each agent turn — update cards and tick roadmap checkboxes during
closeout.

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

Add the first ready card only after the governing architecture, contracts, and
roadmap lane already exist.
