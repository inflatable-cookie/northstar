# Replan After Change Mode

Use this mode when the plan was previously sound and then a known change
invalidated part of it.

## Goal

Leave the planning surfaces coherent again before execution resumes.

## Steps

1. Identify the contract or authority change that invalidated the old plan.
2. Update the affected contract first, or record a contract delta in the log
   flow when the change is still under review.
3. Propagate the change into architecture, system inventory, and repo
   authority mapping.
4. Mark affected roadmap milestones blocked or stale until they are recompiled.
5. Roll over to a new roadmap generation when the sequencing baseline changed
   materially rather than patching the old generation indefinitely.
6. Leave a clear next task that points to the next planning artifact or the
   first newly valid execution batch.

## Guardrails

- Do not patch implementation around a broken contract.
- Do not keep executing from a stale roadmap because the next fix looks small.
- Do not treat cross-repo uncertainty as a temporary detail; resolve authority
  explicitly.
