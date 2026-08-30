---
title: Papercuts wave 20 worker git-fetch timeout worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: awaiting-review
owner: Tom / papercuts orchestrator
created: 2026-08-30
updated: 2026-08-30
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260830-211110-papercuts-wave20-git-fetch-timeout.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, papercuts]
---

## What This Thread Was Doing

Effigy filed that worker preflight `git fetch origin` can sit silent for
minutes on a blocked SSH prompt. A retry with
`GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes"` returned
immediately. That fetch lives in the Northstar worker startup path.

The Northstar implementation worker wrapped the worker preflight fetch
on the three named surfaces and closed the matching PAPERCUTS bullet.
It left the Effigy copy for a later closeout.

## Why It Matters

Startup probes look wedged and burn a long command timeout.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `dbc71241080a5d3aee535d1c5240845108f0fc5b`
- **Worker mode:** implementation runway complete; handoff is review-only.
- **Actual worker branch:** `t3code/fix-git-fetch-timeout`
- **Actual worker worktree:**
  `/Users/tom/.t3/worktrees/northstar/t3code-d3af8f41`
- **Required sibling worktree links:** `none`
- **Completed work:**
  1. Wrapped worker preflight `git fetch origin` with
     `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes"` in
     `skills/northstar/references/router.md`,
     `skills/northstar/references/modes/orchestrator.md`, and
     `skills/northstar/assets/templates/northstar-orchestrator-run.md.template`.
  2. Kept the fetch itself; did not change GitHub workflows.
  3. Added-and-closed the matching bullet in `PAPERCUTS.md`.
- **Evidence commit:** `b48e2aa61213692813ec6a552d6509bf421dea74`
  (BatchMode wrap + papercut closeout; handoff review-state update follows).
- **Validation evidence (orchestrator at that SHA):** all three surfaces
  retain `git fetch origin` with the exact BatchMode/ConnectTimeout wrapper;
  `git diff --check` passed; full `effigy qa` passed; `effigy doctor` only
  showed the repo's existing unrelated god-files finding.
- **Out of scope (unchanged):** editing Effigy; portfolio skill sync;
  GitHub workflows; release mutations.
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/12
- **Review state:** `awaiting-review`
- **Merge authorisation:** absent; do not merge

## Boundaries

- Do not re-dispatch or re-execute this runway. Do not edit Effigy. Do
  not merge without operator authorisation.

## Important Context

- This repo's PAPERCUTS uses bullet entries. Closeout used that format.
- **Report to:** the operator / orchestrator reviewer.

## Suggested Next Move

Review https://github.com/inflatable-cookie/northstar/pull/12. Confirm
the three surfaces name the BatchMode wrap, the closed `PAPERCUTS.md`
bullet matches, and this handoff stays `awaiting-review` (not
`ready-to-launch`). Merge only with explicit operator authorisation.

## Completion Protocol

### Runway status

Assigned implementation runway is complete. Do not re-run the startup
preflight as a fresh dispatch.

### Review and merge path

Awaiting orchestrator review. Merge is operator-authorised only.

- **Closeout refs:** `PAPERCUTS.md`; this handoff; PR 12.

### Handoff closeout

Do not edit Effigy. Leave portfolio skill sync open.
