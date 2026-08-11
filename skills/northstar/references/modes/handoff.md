# Handoff mode (explicit trigger only)

Produce a continuation brief for **another agent thread**. The router should
have sent you here only because the user asked for a handoff, continuation
brief, spin-off, or fresh thread—not because context is low.

## Contract and template

- [`../handoff-contract.md`](../handoff-contract.md) — required sections and rules
- [`../../assets/templates/northstar-handoff.md.template`](../../assets/templates/northstar-handoff.md.template)

## Quick start

```sh
effigy tasks
effigy doctor
```

Read `docs/README.md`, active `docs/roadmaps/gNN/`, `docs/roadmaps/gNN/batch-cards/`
when present, `docs/specs/`, `docs/contracts/`, `docs/logs/README.md`, latest
relevant log in `docs/logs/YYYY-MM/`.

## Workflow

1. Inspect active spec lane, milestone, canonical promoted refs, latest log.
2. Fill the template: thread story first, then refs, envelope, boundaries.
3. Default path: current month under `docs/logs/YYYY-MM/` unless user specifies.
4. Handoff is **after** honest closeout: batch card, roadmap, currentness surfaces,
   log should reflect the stop unless user wants handoff-first.
5. Seven sections in order (see handoff contract).
6. Leave explicit next task and completion protocol pointing at roadmap/log surfaces.
7. If the consumer docs policy requires trailing headings on log handoffs
   (Jetstream: `## Vision Target Delta` and `## Next Task`), append them after
   `## Completion Protocol`. Do not fold them into the core seven.

## Do not

- Create a handoff only for compaction or a bare `continue`.
- Substitute handoff for batch log or roadmap update.
- Hand off from stale front doors without fixing currentness (unless user insists).
- Use provisional specs as sole authority when architecture/contracts govern.
- Use relative paths for local file refs in the brief.
- Ship a seven-section-only handoff into a consumer log tree whose QA still
  requires trailing report-policy headings.

## Operator message

Why the handoff exists → current lane state → next move. Short validation note
only if needed.
