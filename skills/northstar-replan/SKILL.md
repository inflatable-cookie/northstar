---
name: northstar-replan
description: Use when Northstar plans were valid but need controlled rewiring after reality changes. Updates contracts, architecture, roadmap generations, and planning gates so agents replan explicitly instead of drifting into make-it-up-as-you-go execution.
---

# Northstar Replan

Use this skill when the user asks to:

- replan after requirements, contracts, or repo boundaries changed
- decide whether to roll over to a new roadmap generation
- repair drift after implementation exposed planning mistakes

## Outcome

Leave the planning surfaces coherent again before execution resumes.

Use this skill when the plan was previously sound and then changed.
If planning is still missing, route to `northstar-plan-product`.
If the current state is broadly stale or untrustworthy, route to
`northstar-refocus`.
If the planning surfaces are still sound and the user only wants the next
milestones, route to `northstar-roadmap-compiler`.

## Quick Start

Read:

- active roadmap milestones
- latest relevant logs
- `docs/contracts/contract-index.md`
- affected contract files
- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` when present
- `docs/roadmaps/generation-index.md`

## Workflow

1. Identify the contract or authority change that invalidated the old plan.
2. Update the affected contract first, or record a contract delta in the log
   flow when the change is still under review.
3. Propagate the change into architecture, system inventory, and repo authority
   mapping.
4. Mark affected roadmap milestones blocked or stale until they are recompiled.
5. Roll over to a new roadmap generation when the sequencing baseline changed
   materially rather than patching the old generation indefinitely.
6. Leave a clear next task that points to the next planning artifact or the
   first newly valid execution batch.

## Required Outputs

- updated planning artifacts for the changed boundary
- updated or superseded roadmap milestones
- generation-index updates when rollover happens
- a visible record of what became stale and why

## Guardrails

- Do not patch implementation around a broken contract.
- Do not keep executing from a stale roadmap because the next fix looks small.
- Do not treat cross-repo uncertainty as a temporary detail; resolve authority
  explicitly.

## Next Step

Once replanning is complete, compile the revised roadmap and resume execution
from the first contract-valid batch.
