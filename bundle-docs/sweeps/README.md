# Northstar Sweep Pack

Use this pack when a fresh agent needs to audit and repair docs drift in a project that should follow Northstar doctrine.
Use the full pack when you need both structural normalization and execution-readiness checks.

## Use Case

Run these sweeps when:
- onboarding a project to Northstar
- running periodic docs maintenance
- cleaning up after major roadmap/log migrations
- validating agent outputs before merge

## Agent Execution Contract

For each sweep:
1. Audit first (do not edit yet).
2. List concrete drift findings with file paths.
3. Apply fixes in meaningful batches.
4. Re-run audit checks and confirm closure.
5. Add one batch log in `docs/logs/YYYY-MM/` summarizing changes.
6. Keep optional add-on folders (`research`, `schemas`, `templates`, `diagrams`, `specs`) out of baseline unless needed, but enforce Northstar structure if `docs/research/` is canonical.
7. Treat planning gaps as stop conditions: if required architecture coverage, repo authority, or contracts are missing, fix planning before permitting roadmap execution.

If no drift is found, record a no-op audit log.

Use [Fresh Agent Sweep Prompt](./fresh-agent-sweep-prompt.md) to start a new agent thread with the right constraints.

## Sweep Order

1. [01 Structure Sweep](./01-structure-sweep.md)
2. [02 Naming and Keys Sweep](./02-naming-and-keys-sweep.md)
3. [03 Format and Sections Sweep](./03-format-and-sections-sweep.md)
4. [04 Roadmap and Backlog Sweep](./04-roadmap-and-backlog-sweep.md)
5. [05 Logs and Traceability Sweep](./05-logs-and-traceability-sweep.md)
6. [06 Deprecation and Clean Migration Sweep](./06-deprecation-and-clean-migration-sweep.md)
7. [07 Research Sweep](./07-research-sweep.md)
8. [08 Planning Gate Sweep](./08-planning-gate-sweep.md)

## Required Agent Output

At sweep completion, the agent should return:
- files changed
- drift fixed (bulleted)
- validation checks run
- unresolved items (if any)
- next task

## Quick reference

- [Glossary: Sweep](../glossary.md#execution-and-workflow)
- [Cheat sheet: Naming](../cheat-sheet.md#file-naming)
- [Operator quick start](../operators/operator-quick-start.md)
