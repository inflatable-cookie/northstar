---
name: northstar-plan
description: Use when a project needs Northstar planning work before or around execution. Handles plan-from-scratch coverage, contract-first planning gates, contract authoring, and roadmap compilation from approved contracts without exposing those as separate top-level skills.
---

# Northstar Plan

Use this skill when the user asks to:

- plan a product or program in Northstar before implementation starts
- decompose a multi-repo system into explicit responsibilities and contracts
- tighten agent guardrails so roadmap work cannot outrun planning
- lay out the next few roadmaps or milestones from completed planning
- sequence the next batches from approved contracts
- write or repair the contract surfaces a roadmap depends on

## Outcome

Leave the repo with coherent planning surfaces and contract-backed roadmap work
without inventing missing system behavior.

Use this skill when the work is still fundamentally about planning.
If the plan was valid but changed, route to `northstar-recover`.
If the current project state is stale or contradictory, route to
`northstar-recover`.

## Quick Start

Inspect the active Northstar surface first:

```sh
effigy tasks
effigy doctor
```

Then read:

- `README.md`
- `AGENTS.md`
- `docs/vision/`
- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` when present
- `docs/contracts/contract-index.md`
- `docs/roadmaps/`
- [`references/modes/plan-from-scratch.md`](./references/modes/plan-from-scratch.md)
- [`references/modes/compile-roadmaps.md`](./references/modes/compile-roadmaps.md)

## Workflow

1. Diagnose which planning mode is actually needed: plan from scratch, repair
   contract surfaces, or compile roadmaps from already-approved contracts.
2. If planning coverage is still missing, use
   [`references/modes/plan-from-scratch.md`](./references/modes/plan-from-scratch.md)
   and complete the architecture, inventory, authority, and contract surfaces.
3. If the boundaries are known but the contract surface is thin, write or
   update the needed contracts before drafting roadmap work.
4. If planning is already coherent, use
   [`references/modes/compile-roadmaps.md`](./references/modes/compile-roadmaps.md)
   and compile only contract-backed milestones.
5. Surface planning gaps instead of writing speculative roadmap or execution
   work.
6. Leave one explicit next task in the planning chain.

## Required Outputs

Depending on the active mode, leave some or all of these surfaces materially
advanced:

- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` for multi-repo work
- `docs/contracts/contract-index.md`
- new or updated contract files for active roadmap dependencies
- new or updated roadmap milestones under `docs/roadmaps/gNN/`

## Guardrails

- Do not start roadmap execution to discover missing system behavior.
- Do not treat unplanned repos or interfaces as implied by context.
- Do not mark planning complete while `pending` or unknown authorities still
  govern active roadmap scope.
- Do not let roadmap prose substitute for a contract.
- Do not expose roadmap compilation as if it were separate from the rest of the
  planning spine; it is a planning mode, not a different operating model.

## Next Step

After the relevant planning mode is complete, either compile the next valid
milestones or hand execution to the first contract-valid batch.
