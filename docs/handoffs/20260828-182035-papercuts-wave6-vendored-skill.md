---
title: Papercuts wave 6 vendored Effigy skill worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Tom / papercuts orchestrator
created: 2026-08-28
updated: 2026-08-28
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260828-182035-papercuts-wave6-vendored-skill.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, papercuts]
---

## What This Thread Was Doing

Wave 4 shipped the batch-card template in the Northstar skill assets.
This repo still notes that the vendored Effigy skill queries
`.result.payload.tasks[]`. Effigy PR 49 retargeted the upstream examples
to `.result.catalog_tasks[]`.

You are the Northstar implementation worker. Refresh the vendored Effigy
skill from that upstream fix. Do not treat the vendored copy as the
source of truth, and do not edit Effigy.

## Why It Matters

Machine-readable task inventory fails in this checkout before agents can
filter ownership.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `35a706d91bcb3dafb8a00bf2604b58acb03bf782`
- **Pushed main verification:** local `HEAD` and `origin/main` both resolved
  to that SHA before this handoff was created.
- **Planning checkout:** clean before this handoff file was created.
- **Worker mode:** implementation worker dispatched by the orchestrator.
- **Worker branch:** `worker/papercuts-wave6-vendored-skill`
- **Worker worktree:** launcher worktree first. `.agents.local.env` was
  absent; ask before creating a manual fallback. Never use `/tmp`.
- **Ready work items, in order:**
  1. Vendored Effigy skill uses a stale tasks JSON path — update
     `.agents/skills/effigy/SKILL.md` and `references/` jq examples from
     sibling Effigy `552ef1b93283` (PR 49) to
     `.result.catalog_tasks[]`. Mark the papercut resolved in this
     repo's format
- **Out of scope:** editing Effigy source; refreshing
  `~/.claude/skills` on the operator machine; batch-card template (already
  in this repo's skill assets).
- **Canonical refs:** `PAPERCUTS.md`; `.agents/skills/effigy/`; sibling
  Effigy `skills/effigy/SKILL.md` at `552ef1b93283`.
- **Required validation:** vendored examples match live
  `effigy --json tasks` (`.result.catalog_tasks[].task`).
- **PR URL:** pending
- **Merge authorisation:** absent; do not merge

## Boundaries

- Copy upstream examples. Do not invent a schema. Do not merge.

## Important Context

- This repo's PAPERCUTS uses bullet entries, not `### [ ]`. Close in
  that format.
- **Report to:** the operator.

## Suggested Next Move

Read this file, run the worktree preflight, then retarget the vendored
jq examples from sibling Effigy PR 49.

## Completion Protocol

### Before you start

1. Read this handoff. Run `git rev-parse --show-toplevel`,
   `git branch --show-current`, `git status --porcelain`, and
   `git worktree list --porcelain`.
2. Accept a clean dedicated non-`main` registered worktree. Record the
   actual path/branch.
3. Confirm `HEAD == origin/main` and ancestor
   `35a706d91bcb3dafb8a00bf2604b58acb03bf782`.
4. Confirm this handoff exists in `HEAD`.

### When the assigned runway is complete

1. Update `PAPERCUTS.md`. Push a PR. Do not merge.

### Review and merge path

Awaiting orchestrator review. Merge is operator-authorised only.

- **Closeout refs:** `PAPERCUTS.md`; this handoff; the PR.

### Handoff closeout

If the vendored copy already matches PR 49, close with evidence.
