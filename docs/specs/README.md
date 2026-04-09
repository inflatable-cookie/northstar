# Specs

Use this folder for master specs and batch cards while a change is still being
worked through.

## Artifact types

- `NNN-<slug>.md`
  master specs for material goals or epics
- `batch-cards/NNN-<slug>.md`
  tightly scoped execution cards derived from an active master spec

## Rules

- Use a master spec when a goal spans multiple meaningful batches, changes
  user-facing behavior, or introduces non-trivial execution policy.
- Use batch cards when you want execution to be paint-by-numbers rather than
  driven by fresh design or planning decisions.
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
- Use explicit lifecycle states for specs and batch-card lanes:
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
- `archive/batch-cards/NNN-<slug>.md`

Mirror only the minimum grouping needed to preserve traceability.

## Next Task

Use `018-consumer-repo-follow-up-queue-and-underlay-recovery.md` to keep the
consumer-repo strict-migration queue explicit, including deferred return
targets and the active Underlay recovery target while `g01.098` proves the
next honest Underlay-owned lane.
