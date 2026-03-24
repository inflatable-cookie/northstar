# 05 Logs and Traceability Sweep

## Goal

Keep logs as batch-level evidence with strong roadmap, contract, and planning
traceability under a lean governance posture.

## Rules

- Log per update cycle / batch, not per individual task.
- Every log includes roadmap traceability using `gNN.NNN` where applicable.
- Logs that close planning work should mention the contract ids or planning gate
  surfaces they updated.
- Major decisions are recorded as decision logs under `docs/logs/YYYY-MM/`.
- `docs/logs/README.md` is canonical for naming/cadence.

## Drift Patterns

- Logs created for micro-tasks with no batch scope
- Missing roadmap/batch metadata
- Decision docs split into a separate `decisions/` root
- Missing validation/evidence sections
- Planning-gap fixes with no trace back to the architecture or contract surfaces changed

## Fix Rules

- Merge micro-logs into meaningful batch logs when practical.
- Backfill roadmap/batch metadata and evidence sections.
- Move decision records into `docs/logs/YYYY-MM/` and update references.
- When a batch closes a planning gap, add the relevant planning/contract refs to
  the log body.

## Fast Checks

```bash
find docs/logs -maxdepth 2 -type f -name '*.md' | sort
rg -n "Roadmap|Batch|Validation|Evidence|Next Task|contract|planning gap|system-inventory|repo-authority-map" docs/logs
```

## Completion Criteria

- Logs follow cadence and traceability rules.
- No split decision-root doctrine remains by default.
- Planning repair work is traceable to the surfaces it changed.
