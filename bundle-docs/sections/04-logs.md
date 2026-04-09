# 04 Logs

Status: active
Updated: 2026-04-09

## Why this section matters now

Logs are the evidence layer for roadmap progress and decision quality.
Month segmentation keeps historical logging navigable at scale.

## Scope

Define log naming, placement, cadence, and minimum sections.
Logs must trace directly back to roadmap keys and batches.
When a batch produces or promotes research, cite the relevant research artifacts in evidence.

## Template layout

- `docs/logs/README.md`
- `docs/logs/YYYY-MM/DD-HHMMSS-<slug>.md`
- `docs/logs/templates/roadmap-contract-delta-template.md`
- `docs/logs/templates/roadmap-gate-log-template.md`
- `docs/logs/templates/decision-log-template.md`
- `docs/logs/templates/automation-adoption-note-template.md` (optional)
- `docs/logs/templates/roadmap-currentness-triage-template.md` (optional)

## Default vs optional

- `logs/` and `logs/templates/` are default core sections.
- Top-level add-ons (`docs/templates/`, `docs/schemas/`, `docs/diagrams/`, `docs/specs/`) are optional and should be added only when needed.

## Naming and ordering

- Directory pattern: `docs/logs/YYYY-MM/`
- File pattern: `DD-HHMMSS-<log-slug>.md`
- Example: `docs/logs/2026-03/05-160623-roadmap-g01-001-batch-1.2-contract-delta.md`

## Cadence rule

- Create logs per update cycle / completed batch.
- Do not create a new log for every individual task.

## Lean evidence rule

- Logs should capture what was actually run in the batch.
- Prefer a short list of manual checks plus commands executed.
- Do not add a checker script unless roadmap lean-governance criteria are met.

## Decisions policy

- Use decision logs for major decisions.
- Do not maintain a dedicated `decisions/` folder by default.
- During migration from legacy `decisions/`, move files to `logs/`, rewrite references, and delete legacy files in the same batch (no shim docs).

## Consolidation rule

- Use optional currentness/consolidation logs only when roadmap/log volume creates decision noise.
- Keep consolidation logs concise and explicitly linked to source logs.

## Currentness support rule

Logs are part of the repo's live navigation layer, not only its historical
evidence.

- `docs/logs/README.md` should reflect the current evidence chain rather than a
  stale subset of old logs
- when the active lane changes materially, refresh the log README so operators
  can find the recent batch trail quickly
- keep a bounded evidence window in `docs/logs/README.md`, usually the most
  recent 5 active-lane logs plus any still-governing rollover or decision log
  needed to explain the current state
- do not mirror the whole month or whole generation in `docs/logs/README.md`
  once that list stops helping an operator reach the live lane quickly
- use the optional currentness-triage template only when currentness cleanup is
  itself the batch, or when multiple stale front-door/evidence surfaces need a
  short explicit cleanup record beyond normal batch closeout

## Content contract (per log)

1. `Status`, `Created`, `Roadmap`, `Batch`
2. `## Summary`
3. `## Changes`
4. `## Validation Performed`
5. `## Evidence`
6. `## Risks`
7. `## Next Task`

## Traceability rule

Each log must include roadmap references in `gNN.NNN` format and can include research artifact links when those artifacts materially changed in the batch.

## Next task

Keep log doctrine and templates aligned so currentness surfaces remain useful as
operator navigation aids, not only as passive history.
