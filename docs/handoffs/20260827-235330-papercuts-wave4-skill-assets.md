---
title: Papercuts wave 4 skill assets worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-for-review
owner: Tom / papercuts orchestrator
created: 2026-08-27
updated: 2026-08-28
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260827-235330-papercuts-wave4-skill-assets.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, papercuts]
---

## What This Thread Was Doing

Consumer papercuts still say compile-roadmaps needs
`docs/specs/templates/batch-card-template.md` in the installed Northstar
assets package, and the Effigy skill JSON example queries
`.result.payload.tasks[]` instead of `.result.catalog_tasks[]`. Those
filings live in Underlay; the files to fix live here (and in the Effigy
skill copy this repo may not own).

You are the Northstar implementation worker. Restore or retarget the
batch-card template in the packaged skill assets. If the stale tasks JSON
path lives only in the Effigy skill, stop and report rather than editing
Effigy from this repo.

## Why It Matters

Roadmap compilation infers readiness fields from existing cards instead
of the declared template. Agents fail machine-readable task inventory
before they can filter ownership.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `5035d15626f0d1017db09582ead3b00c17c74a13`
- **Pushed main verification:** local `HEAD` and `origin/main` both resolved
  to that SHA before this handoff was created.
- **Planning checkout:** clean before this handoff file was created.
- **Worker mode:** implementation worker dispatched by the orchestrator.
- **Worker branch:** `t3code/follow-papercuts-wave-four-handoff` (launcher
  worktree reused; handoff placeholder `worker/papercuts-wave4-skill-assets`
  not recreated)
- **Worker worktree:** `/Users/tom/.t3/worktrees/northstar/t3code-83c09327`
- **Ready work items, in order:**
  1. Northstar compile-roadmaps references a missing batch-card template —
     **done:** shipped under skill assets; README + compile-roadmaps agree
  2. Effigy task-inventory JSON example uses a stale payload path —
     **reported:** lives only in vendored `.agents/skills/effigy/` and the
     upstream installed Effigy skill; not edited here
- **Out of scope:** editing consumer Underlay docs; changing compile
  semantics beyond pointing at a real template.
- **Canonical refs:**
  `skills/northstar/assets/templates/README.md` (lists
  `docs/specs/templates/batch-card-template.md`);
  `template-bundle/specs/templates/batch-card-template.md`;
  compile-roadmaps mode.
- **Required validation:** `effigy qa:docs` OK after the asset restore.
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/6
- **Merge authorisation:** absent; do not merge

## Boundaries

- Prefer restoring the missing asset over rewriting compile-roadmaps.
  The template already exists under `template-bundle/specs/templates/`.
- Do not merge.

## Important Context

- Filed in Underlay PAPERCUTS; fix the skill package here.
- **Report to:** the operator.

## Suggested Next Move

Orchestrator review of the PR. Separately refresh the Effigy skill upstream
so `.result.catalog_tasks[]` replaces `.result.payload.tasks[]`.

## Completion Protocol

### Before you start

1. Read this handoff. Run the four git identity commands.
2. Accept a clean dedicated non-`main` registered worktree.
3. Confirm `HEAD == origin/main` and ancestor
   `5035d15626f0d1017db09582ead3b00c17c74a13`.
4. Confirm this handoff exists in `HEAD`.

### When the assigned runway is complete

1. Log the fix in this repo's `PAPERCUTS.md` if the friction is not
   already here. Push a PR. Do not merge.

### Review and merge path

Awaiting orchestrator review. Merge is operator-authorised only.

- **Closeout refs:** `PAPERCUTS.md`; this handoff; the PR.

### Handoff closeout

If the template already exists at the live compile-roadmaps path, close
with evidence instead of duplicating it.

### Worker evidence

- Restored
  `skills/northstar/assets/templates/docs/specs/templates/batch-card-template.md`
  from `template-bundle/specs/templates/batch-card-template.md`.
- Pointed assets README and compile-roadmaps at the skill-shipped path.
- Did not edit `.agents/skills/effigy/`; live schema confirmed
  `.result.catalog_tasks` (payload null).
- `effigy qa:docs` passed.
