---
title: Papercuts wave 4 skill assets worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Tom / papercuts orchestrator
created: 2026-08-27
updated: 2026-08-27
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
- **Worker branch:** `worker/papercuts-wave4-skill-assets`
- **Worker worktree:** launcher first. `.agents.local.env` was absent;
  ask before creating a manual fallback. Never use `/tmp`.
- **Ready work items, in order:**
  1. Northstar compile-roadmaps references a missing batch-card template
  2. Effigy task-inventory JSON example uses a stale payload path — only
     if that example is in this repo's packaged Effigy/Northstar skill
     docs; otherwise report the owning repo
- **Out of scope:** editing consumer Underlay docs; changing compile
  semantics beyond pointing at a real template.
- **Canonical refs:**
  `skills/northstar/assets/templates/README.md` (lists
  `docs/specs/templates/batch-card-template.md`);
  `template-bundle/specs/templates/batch-card-template.md`;
  compile-roadmaps mode.
- **Required validation:** the installed/packaged path compile-roadmaps
  actually reads exists; README and mode agree. Skill JSON example, if
  touched, uses `.result.catalog_tasks[]` (or the live schema).
- **PR URL:** pending
- **Merge authorisation:** absent; do not merge

## Boundaries

- Prefer restoring the missing asset over rewriting compile-roadmaps.
  The template already exists under `template-bundle/specs/templates/`.
- Do not merge.

## Important Context

- Filed in Underlay PAPERCUTS; fix the skill package here.
- **Report to:** the operator.

## Suggested Next Move

Read this file, run the worktree preflight, then diff the assets README
list against the files on disk.

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
