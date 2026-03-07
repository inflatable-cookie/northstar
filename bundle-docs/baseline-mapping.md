# Baseline Mapping

Status: active
Updated: 2026-03-07

## Purpose

Capture the documentation patterns used as Northstar starting points.
Record explicit Northstar deviations to avoid accidental drift.

## Source scan focus

- `docs/vision/`
- `docs/architecture/`
- `docs/research/` (when comparative/source-backed work is a durable need)
- `docs/roadmap/`
- `docs/logs/`

## Adopted patterns

- Vision as long-horizon constraints and directional blueprint.
- Architecture as system shape + invariants.
- Research as an optional synthesis layer for comparative/source-backed learning before architecture or roadmap commitments.
- Roadmaps as milestone files with executable task lists and acceptance criteria.
- Logs as dated evidence artifacts tied to roadmap batches.

## Northstar changes

1. Roadmap segmentation by generation key.
- Legacy pattern uses one flat `docs/roadmap/` sequence.
- Northstar uses `docs/roadmaps/gNN/NNN-<slug>.md`.
- Cross-reference format is `gNN.NNN` (example: `g01.105`).

2. Log segmentation by month.
- Legacy pattern stores logs in a single `docs/logs/` folder.
- Northstar uses `docs/logs/YYYY-MM/DD-HHMMSS-<slug>.md`.

3. Bundle-first packaging.
- Northstar separates template artifact (`template-bundle/`) from docs-about-the-bundle (`bundle-docs/`).

4. Research promotion contract.
- Jetstream and Loophole both proved the value of separating raw comparative research from project-facing recommendations.
- Northstar standardizes that as `specimen-dossiers/`, `value-tracks/`, `source-hubs/`, and `translation-memos/` inside optional `docs/research/`.

5. Research-to-implementation bridge.
- Chorus showed that large research corpora also need navigation and implementation-traceability support.
- Northstar now treats `master-index.md`, `research-to-implementation-playbook.md`, `research-to-architecture-crossref.md`, `gaps-found-during-implementation.md`, and implementation decision records as optional research support artifacts when the corpus becomes delivery-critical.

## Open decisions

- Confirm whether Northstar should eventually ship an Effigy check that validates research contracts only when `docs/research/` exists.
- Confirm whether project-specific research domains should keep the canonical `specimen-dossiers/` name or allow alias folders with a documented mapping.

## Next task

Pilot the new research add-on in a live project and decide whether the sweep pack needs stronger checks for discovery intake and research-to-architecture promotion hygiene.
