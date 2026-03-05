# 04 Reports

Status: draft
Updated: 2026-03-05

## Why this section matters now

Reports are the evidence layer for roadmap progress and policy adherence.
Month segmentation keeps this directory navigable as volume grows.

## Scope

Define report naming, placement, and minimum sections.
Ensure reports can be traced back to roadmap keys and batches.

## Template layout

- `docs/reports/README.md`
- `docs/reports/YYYY-MM/DD-HHMMSS-<slug>.md`
- `docs/reports/templates/roadmap-contract-delta-template.md`
- `docs/reports/templates/phase-gate-report-template.md`

## Naming and ordering

- Directory pattern: `docs/reports/YYYY-MM/`
- File pattern: `DD-HHMMSS-<report-slug>.md`
- Example: `docs/reports/2026-03/05-160623-roadmap-g01-001-batch-1.2-contract-delta.md`

## Content contract (per report)

1. `Status`, `Created`, `Roadmap`, `Batch`
2. `## Summary`
3. `## Changes`
4. `## Evidence`
5. `## Risks`
6. `## Next Task`

## Traceability rule

Each report must include roadmap key references using `gNN.NNN` format.

## Next task

Draft `docs/reports/README.md` with concrete filename examples and add baseline report template files.
