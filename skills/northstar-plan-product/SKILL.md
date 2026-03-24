---
name: northstar-plan-product
description: Use when a project needs exhaustive Northstar planning before execution and planning coverage is still missing or incomplete. Builds complete system coverage, repo authority mapping, and contract-first planning gates so agents stop on missing planning instead of inventing behavior.
---

# Northstar Plan Product

Use this skill when the user asks to:

- plan a product or program in Northstar before implementation starts
- decompose a multi-repo system into explicit responsibilities and contracts
- tighten agent guardrails so roadmap work cannot outrun planning

## Outcome

Leave the repo with enough planning coverage that execution can proceed without
inventing missing system behavior.

Use this skill only when planning coverage is still missing or incomplete.
If planning is already coherent and the user wants the next milestones, route to
`northstar-roadmap-compiler`.
If the plan was valid but changed, route to `northstar-replan`.
If the current project state is stale or contradictory, route to
`northstar-refocus`.

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

## Workflow

1. Inventory every known execution-relevant surface: repos, services, packages,
   interfaces, operators, external dependencies, and validation surfaces.
2. Write or update `system-architecture.md` so the top-level shape and
   invariants are explicit.
3. Fill `system-inventory.md` with complete coverage and list planning gaps
   instead of guessing missing pieces.
4. For multi-repo systems, write `repo-authority-map.md` so ownership and seam
   authority are unambiguous.
5. Create or update `contract-index.md` and add contracts for every boundary
   the active roadmap will depend on.
6. Mark roadmap work blocked until the required contracts exist.
7. Leave one explicit next task in the planning chain.

## Required Outputs

- complete or materially advanced `docs/architecture/system-architecture.md`
- complete or materially advanced `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` for multi-repo work
- complete or materially advanced `docs/contracts/contract-index.md`
- new or updated contract files for active roadmap dependencies

## Guardrails

- Do not start roadmap execution to “discover” missing system behavior.
- Do not treat unplanned repos or interfaces as implied by context.
- Do not mark planning complete while `pending` or unknown authorities still
  govern active roadmap scope.
- Do not let roadmap prose substitute for a contract.

## Next Step

After planning is complete, use a roadmap-generation skill to compile the
approved contracts into executable batches.
