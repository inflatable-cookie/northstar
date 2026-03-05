# Jetstream Baseline Mapping

Status: draft
Updated: 2026-03-05

## Purpose

Capture the Jetstream documentation patterns used as Northstar starting points.
Record explicit Northstar deviations to avoid accidental drift.

## Source scan focus

- `docs/vision/`
- `docs/architecture/`
- `docs/roadmap/`
- `docs/reports/`

## Adopted patterns

- Vision as long-horizon constraints and directional blueprint.
- Architecture as system shape + invariants.
- Roadmaps as milestone files with executable task lists and acceptance criteria.
- Reports as dated evidence artifacts tied to roadmap batches.

## Northstar changes

1. Roadmap segmentation by generation key.
- Jetstream uses one flat `docs/roadmap/` sequence.
- Northstar uses `docs/roadmaps/gNN/NNN-<slug>.md`.
- Cross-reference format is `gNN.NNN` (example: `g01.105`).

2. Report segmentation by month.
- Jetstream stores reports in a single `docs/reports/` folder.
- Northstar uses `docs/reports/YYYY-MM/DD-HHMMSS-<slug>.md`.

3. Bundle-first packaging.
- Northstar separates template artifact (`template-bundle/`) from docs-about-the-bundle (`bundle-docs/`).

## Open decisions

- Confirm exact generation rollover threshold (current starter: 120 files).
- Confirm whether all roadmap/report templates should include mandatory Vision delta sections from day one.

## Next task

Finalize `03-roadmaps.md` and `04-reports.md` spec rules, then create first concrete milestone and report templates directly in `template-bundle/roadmaps/` and `template-bundle/reports/`.
