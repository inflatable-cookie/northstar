---
name: northstar-refocus
description: Use when a project has drifted, fragmented planning, or stale roadmaps and the current state is no longer trustworthy. Audits drift, rebuilds planning coverage, blocks fake execution, and recompiles or rolls over roadmaps as needed.
---

# Northstar Refocus

Use this skill when the user asks to:

- reorganize or refocus a project using Northstar
- recover from stale roadmaps, partial planning, or cross-repo drift
- bring ad hoc execution back under explicit contracts and planning gates

## Outcome

Leave the project with coherent planning surfaces again and a trustworthy active
roadmap queue.

Use this skill when the current planning or roadmap state is stale,
contradictory, or otherwise not trustworthy enough to assume a valid base.
If planning is simply missing, route to `northstar-plan-product`.
If the plan is still coherent and the user wants the next milestones, route to
`northstar-roadmap-compiler`.
If the plan was coherent but changed in a bounded way, route to
`northstar-replan`.

## Quick Start

Inspect:

```sh
effigy tasks
effigy doctor
```

Then read:

- `README.md`
- `AGENTS.md`
- `docs/architecture/`
- `docs/contracts/`
- `docs/roadmaps/`
- `docs/logs/`
- `docs/research/` when present
- `bundle-docs/sections/06-planning-and-contract-gates.md`
- `bundle-docs/sweeps/08-planning-gate-sweep.md`
- `bundle-docs/operators/project-refocus-starter-prompt.md`

## Workflow

1. Audit the live planning and execution surfaces before editing.
2. Identify drift explicitly: stale milestones, missing contracts, repo
   authority ambiguity, research that never promoted, and logs that hide
   planning failures.
3. Rebuild or repair `system-architecture.md`, `system-inventory.md`,
   `repo-authority-map.md`, and `contract-index.md`.
4. Mark invalid roadmap work blocked or superseded instead of trying to keep it
   limping forward.
5. Create contract deltas or new contracts for the real boundaries now shaping
   execution.
6. Recompile the active roadmap or open a new generation when the old sequence
   is no longer trustworthy.
7. Leave a clear next task pointing to the first newly valid batch or remaining
   planning blocker.

## Required Outputs

- explicit drift findings with paths
- repaired planning surfaces
- blocked, superseded, or recompiled roadmap milestones
- log evidence showing what changed and why

## Guardrails

- Do not preserve stale roadmap prose just because it already exists.
- Do not let implementation continue against a fake or implied contract.
- Do not collapse multiple repos into one owner to simplify the story.
- Do not treat refocus work as cosmetic cleanup; it must change execution
  authority.

## Next Step

Once the refocus pass is complete, hand work to roadmap compilation or execution
from the first contract-valid batch.
