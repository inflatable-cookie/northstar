# 04 Reports

Status: active
Updated: 2026-03-05

## Why this section matters now

Reports are the evidence layer for roadmap progress and decision quality.
Month segmentation keeps historical reporting navigable at scale.

## Scope

Define report naming, placement, cadence, and minimum sections.
Reports must trace directly back to roadmap keys and batches.

## Template layout

- `docs/reports/README.md`
- `docs/reports/YYYY-MM/DD-HHMMSS-<slug>.md`
- `docs/reports/templates/roadmap-contract-delta-template.md`
- `docs/reports/templates/phase-gate-report-template.md`
- `docs/reports/templates/automation-adoption-note-template.md` (optional)
- `docs/reports/templates/roadmap-currentness-triage-template.md` (optional)

## Naming and ordering

- Directory pattern: `docs/reports/YYYY-MM/`
- File pattern: `DD-HHMMSS-<report-slug>.md`
- Example: `docs/reports/2026-03/05-160623-roadmap-g01-001-batch-1.2-contract-delta.md`

## Cadence rule

- Create reports per update cycle / completed batch.
- Do not create a new report for every individual task.

## Lean evidence rule

- Reports should capture what was actually run in the batch.
- Prefer a short list of manual checks plus commands executed.
- Do not add a checker script unless roadmap lean-governance criteria are met.

## Consolidation rule

- Use optional currentness/consolidation reports only when roadmap/report volume creates decision noise.
- Keep consolidation reports concise and explicitly linked to source reports.

## Content contract (per report)

1. `Status`, `Created`, `Roadmap`, `Batch`
2. `## Summary`
3. `## Changes`
4. `## Validation Performed`
5. `## Evidence`
6. `## Risks`
7. `## Next Task`

## Traceability rule

Each report must include roadmap references in `gNN.NNN` format.

## Next task

Align report templates so the metadata/body describe batch scope and outcomes, and keep automation/currentness artifacts optional by default.
