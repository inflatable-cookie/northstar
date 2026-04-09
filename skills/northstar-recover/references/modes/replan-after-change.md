# Replan After Change Mode

Use this mode when the plan was previously sound and then a known change
invalidated part of it.

## Goal

Leave the planning surfaces coherent again before execution resumes.

## Steps

1. Identify the contract, authority, or promoted-architecture change that
   invalidated the old plan.
2. Update the affected contract first, or record a contract delta in the log
   flow when the change is still under review.
3. Propagate the change into architecture, system inventory, repo authority
   mapping, and active specs/batch cards where relevant.
4. Update the active roadmap/spec lane so its governing refs point to the
   current canonical surfaces.
5. Mark affected roadmap milestones blocked or stale until they are recompiled.
6. Roll over to a new roadmap generation when the sequencing baseline changed
   materially rather than patching the old generation indefinitely.
7. Leave a clear next task that points to the next planning artifact or the
   first newly valid execution batch.

## Guardrails

- Do not patch implementation around a broken contract.
- Do not leave the active spec lane pointing at outdated canonical refs.
- Do not keep executing from a stale roadmap because the next fix looks small.
- Do not treat cross-repo uncertainty as a temporary detail; resolve authority
  explicitly.
