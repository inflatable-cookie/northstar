# 030 - Conversational Triage And Docs Cleanup

Status: active — implementation complete; operator usage feedback pending
Owner: repo maintainers
Created: 2026-08-19
Updated: 2026-08-19
Depends on: `g02.025`, `g02.027`
Governing refs: `bundle-docs/protocol-kernel.md`, `bundle-docs/sections/09-standard-docs-spine.md`, `docs/contracts/001-working-rules.md`
Route targets: `skills/northstar/references/modes/orchestrator.md`, `skills/northstar/references/modes/project-refresh.md`, `skills/northstar/references/modes/cleanup-docs.md`

## Problem

Northstar conversations produce useful observations, alternatives, and future
plans faster than a single branch can absorb them. Orchestrator and refresh
threads currently rely too heavily on the final response to preserve those
threads, so good ideas disappear when the conversation deepens elsewhere.

Northstar also lacks a deliberate maintenance route for `/docs` files and
folders that are unfamiliar, stale, duplicated, or only partly aligned with the
protocol. Blind deletion risks losing useful project knowledge; leaving every
outlier in place makes the docs spine harder to trust.

## Goal

Add a lightweight, file-based triage buffer and a docs-cleanup route that:

- captures unresolved conversational material at the moment it appears;
- gives every note a handoff-matched creation timestamp;
- makes refresh inspect and prune triage as a normal maintenance facet;
- identifies and classifies non-protocol docs paths before proposing rework;
- promotes clear material into canonical homes and asks the operator when the
  destination, ownership, meaning, or removal decision is uncertain.

## Protocol

### Triage folder

- `docs/triage/` is part of the standard Northstar spine.
- Notes use `YYYYMMDD-HHMMSS-<slug>.md`, with a `-2`, `-3`, and so on for a
  same-second slug collision.
- Notes are arbitrary Markdown with no mandatory frontmatter or body schema.
- Triage is a temporary capture buffer, not execution authority.
- Every note eventually gets a disposition: promote/rework, merge, remain
  explicitly open, or remove when implemented, superseded, or no longer useful.
  An explicitly open note is interim, not permanent; give it a next check or
  owner when possible and eventually promote, implement, or remove it.

### Conversational capture

Orchestrator and refresh runs read existing triage early. When a useful
observation, idea, plan, alternative, edge case, or question will not be
resolved in the current exchange, the agent writes it down before following one
branch deeply. Natural topic shifts and meaningful checkpoints are the cadence;
the agent does not wait for closeout.

### Refresh management

Refresh checks the triage folder, validates note names, records new unresolved
observations, and gives every note a disposition. Capturing or updating a
lightweight triage note is allowed during the pass; canonical promotion,
rework, and removal still require the route's normal authorization. Refresh
does not delete based on age or filename alone and asks the operator when a note
is ambiguous.

### Cleanup route

`northstar-cleanup` is a thin adapter for an internal `cleanup-docs` mode. The
mode inventories `/docs`, reads candidate content and references, classifies
paths as canonical, supported, legitimate project-specific, legacy/duplicate,
stale/empty, or ambiguous, and proposes or applies the smallest clear repair.
It never purges an unclassified path and never leaves a compatibility shim in a
deprecated location.

## Non-goals

- no rigid schema or form for quick triage notes;
- no automatic roadmap or implementation work from a triage note;
- no age-based purge, mass deletion, or silent operator-owned decision;
- no second installable skill or provider-specific cleanup workflow;
- no production-code changes or consumer-repository migration.

## Acceptance criteria

- [x] `docs/triage/` is documented and copy-ready in the full and minimal
      bundles.
- [x] Triage filenames use the handoff timestamp shape and the body remains
      intentionally lightweight.
- [x] Orchestrator instructions require regular capture at natural checkpoints.
- [x] Refresh reads, records, and dispositions triage notes.
- [x] Cleanup identifies non-protocol `/docs` paths without blind deletion and
      asks the operator when uncertain.
- [x] The internal cleanup route and thin command adapter pass command-surface
      and installed-skill parity checks.
- [ ] Operator feedback from a live refresh/orchestrator conversation is
      recorded before this spec is retired or archived.

## Validation

- `git diff --check`
- `effigy check:bundle`
- `effigy check:repo-contract`
- `effigy check:command-skills`
- `effigy qa:docs`
- `effigy qa`
- installed Northstar skill parity
- manual review of orchestrator, refresh, cleanup, and triage lifecycle wording

## Next Task

Use `northstar-refresh` or an orchestrator conversation against a real project,
inspect the resulting triage notes, and record operator feedback on capture
cadence and pruning friction. Keep the note format lightweight unless live use
shows a concrete recovery problem.
