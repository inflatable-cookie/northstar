# 05 Logs and Traceability Sweep

## Goal

Keep logs as batch-level evidence with strong roadmap traceability and lean governance posture.

## Rules

- Log per update cycle / batch, not per individual task.
- Every log includes roadmap traceability using `gNN.NNN` where applicable.
- Major decisions are recorded as decision logs under `docs/logs/YYYY-MM/`.
- `docs/logs/README.md` is canonical for naming/cadence.

## Drift Patterns

- Logs created for micro-tasks with no batch scope
- Missing roadmap/batch metadata
- Decision docs split into a separate `decisions/` root
- Missing validation/evidence sections

## Fix Rules

- Merge micro-logs into meaningful batch logs when practical.
- Backfill roadmap/batch metadata and evidence sections.
- Move decision records into `docs/logs/YYYY-MM/` and update references.

## Fast Checks

```bash
find docs/logs -maxdepth 2 -type f -name '*.md' | sort
rg -n "Roadmap|Batch|Validation|Evidence|Next Task" docs/logs
```

## Completion Criteria

- Logs follow cadence and traceability rules.
- No split decision-root doctrine remains by default.
