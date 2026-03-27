# Sweep Audit And Repair Mode

Use this mode when a repo needs a structured audit-and-repair pass using the
Northstar sweep pack.

## Goal

Leave the repo structurally consistent, planning-valid, and explicitly logged
after a sweep-led repair pass.

## Steps

1. Start from `bundle-docs/sweeps/README.md` and the fresh-agent sweep prompt.
2. Audit before editing.
3. List concrete drift findings with file paths.
4. Apply fixes in meaningful batches rather than one tiny patch at a time.
5. Re-run the relevant sweep checks and close the findings explicitly.
6. Add one batch log under `docs/logs/YYYY-MM/` summarizing what changed and
   what remains unresolved.

## Guardrails

- Do not edit before the audit has named the drift.
- Do not treat a planning gap as a cleanup detail; stop and repair planning
  first.
- Do not leave sweep findings implicit; write them down with paths.
