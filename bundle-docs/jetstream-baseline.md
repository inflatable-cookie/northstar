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
- `docs/logs/`

## Adopted patterns

- Vision as long-horizon constraints and directional blueprint.
- Architecture as system shape + invariants.
- Roadmaps as milestone files with executable task lists and acceptance criteria.
- Logs as dated evidence artifacts tied to roadmap batches.

## Northstar changes

1. Roadmap segmentation by generation key.
- Jetstream uses one flat `docs/roadmap/` sequence.
- Northstar uses `docs/roadmaps/gNN/NNN-<slug>.md`.
- Cross-reference format is `gNN.NNN` (example: `g01.105`).

2. Log segmentation by month.
- Jetstream stores logs in a single `docs/logs/` folder.
- Northstar uses `docs/logs/YYYY-MM/DD-HHMMSS-<slug>.md`.

3. Bundle-first packaging.
- Northstar separates template artifact (`template-bundle/`) from docs-about-the-bundle (`bundle-docs/`).

## Open decisions

- Confirm manual generation rollover trigger ownership/criteria wording for project templates.
- Confirm whether all roadmap/log templates should include mandatory Vision delta sections from day one.

## Next task

Finalize `03-roadmaps.md` and `04-logs.md` spec rules, then create first concrete milestone and log templates directly in `template-bundle/roadmaps/` and `template-bundle/logs/`.
