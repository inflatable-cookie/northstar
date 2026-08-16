# Specs

Use this folder for master specs while a change is still being
worked through.

## Artifact types

- `NNN-<slug>.md`
  master specs for material goals or epics

## Active planning

- [027 - Northstar Native Pre-Execution Discovery](./027-northstar-native-pre-execution-discovery.md)
- [Related translation memo](../../bundle-docs/research/translation-memos/matt-pocock-skills-audit-to-northstar.md)

## Rules

- Use a master spec when a goal spans multiple meaningful batches, changes
  user-facing behavior, or introduces non-trivial execution policy.
- Treat the stricter `specs/` plus batch-card layer as the surface for the full
  continuation-envelope, lane-budget, and pause-signal model. A roadmap-only
  repo can still route live work well, but it should not pretend to carry the
  same explicit autonomy state.
- Promote durable structural outcomes into `docs/architecture/`.
- Promote durable behavioral or policy rules into `docs/contracts/`.
- Once promoted, roadmap execution should rely on architecture and contracts,
  not only on the raw spec text.
- Keep `docs/specs/` tidy so it mostly reflects active planning:
  keep active or still-useful specs, and archive or remove stale ones once the
  canonical surfaces already carry the durable truth.
- Before roadmap generation rollover, purge stale generation-specific specs
  from the active tree so the next generation does not inherit dead planning
  debris. Batch cards live under `docs/roadmaps/gNN/batch-cards/` and stay with
  their generation.
- Use explicit lifecycle states for specs:
  - `active` for live planning
  - `retired-in-place` for short-lived traceability near active work
  - `archived` for closed planning artifacts that should be preserved but no
    longer belong in the active tree
- Prefer `docs/specs/archive/` over indefinite in-place accumulation once a
  closed planning artifact no longer governs live work.
- Keep the archive lean and do not treat it as a second live planning surface.

## Archive layout

When archive is warranted, use:

- `archive/NNN-<slug>.md`

Mirror only the minimum grouping needed to preserve traceability.

## Current strict posture note

- Optional drift check: `effigy check:posture-advisory`
- Recent evidence:
  `docs/logs/2026-05/19-172500-add-posture-advisory-effigy-checks.md`
