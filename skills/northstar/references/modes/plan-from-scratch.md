# Plan From Scratch Mode

Use this mode when planning coverage is missing or incomplete.

## Goal

Leave the repo with enough planning coverage that execution can proceed without
inventing missing system behavior.

## Steps

1. Inventory every known execution-relevant surface: repos, services,
   packages, interfaces, operators, external dependencies, and validation
   surfaces.
2. Write or update `system-architecture.md` so the top-level shape and
   invariants are explicit.
3. Fill `system-inventory.md` with complete coverage and list planning gaps
   instead of guessing missing pieces.
4. For multi-repo systems, write `repo-authority-map.md` so ownership and seam
   authority are unambiguous.
5. Decide whether the change needs provisional specs before the durable
   outcomes can be promoted.
6. Create or update `contract-index.md` and add contracts for every boundary
   the active roadmap will depend on.
7. Mark roadmap work blocked until the required contracts exist.
8. Leave one explicit next task in the planning chain.

## Guardrails

- Do not start roadmap execution to discover missing behavior.
- Do not treat unplanned repos or interfaces as implied by context.
- Do not mark planning complete while unknown authorities still govern active
  roadmap scope.
- Do not confuse provisional specs with canonical architecture/contracts.
