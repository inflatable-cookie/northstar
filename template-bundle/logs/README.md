# Logs

Logs capture dated evidence and assessments.

## Segmentation model

- Group logs by month directory: `YYYY-MM/`
- Name each log: `DD-HHMMSS-<slug>.md`

## Cadence rule

- Create logs per completed batch or update cycle.
- Do not create a separate log for every task.

## Lean evidence rule

- Manual validation notes and commands run are the default evidence format.
- Add checker scripts only when recurring pain justifies automation.
- If a checker is added, include an automation adoption note with owner/cadence/sunset trigger.

## Decision policy

- Do not maintain a separate `decisions/` folder by default.
- Capture major decisions as dedicated decision logs in this folder.
- For legacy migrations, rewrite references and remove old `decisions/` files in the same batch (no compatibility shim files).

## Seed file

- `YYYY-MM/01-090000-example-roadmap-g01-001-batch-1.1-contract-delta.md`
- `YYYY-MM/02-100000-example-planning-gap-g01-002-analytics-export.md`
- `YYYY-MM/03-110000-example-contract-delta-g01-002-analytics-export.md`
- `YYYY-MM/04-120000-example-roadmap-recompile-g01-002.md`
- `YYYY-MM/05-130000-example-rollover-decision-g02.md`
- `YYYY-MM/06-140000-example-contract-delta-g02-platform-reset.md`
- `YYYY-MM/07-150000-example-first-batch-g02-001.md`

## Templates

- `templates/roadmap-contract-delta-template.md`
- `templates/roadmap-gate-log-template.md`
- `templates/decision-log-template.md`
- `templates/thread-handoff-template.md` (optional)
- `templates/automation-adoption-note-template.md` (optional)
- `templates/roadmap-currentness-triage-template.md` (optional)

## Next task

Create the current month directory and add the first batch-level log for a completed roadmap batch.
