---
title: Papercuts wave 20 worker git-fetch timeout worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
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

You are the Northstar implementation worker. Make the worker preflight
fail fast on SSH. Leave the Effigy copy for a later closeout if they
document the same wrap locally.

## Why It Matters

Startup probes look wedged and burn a long command timeout.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `dbc71241080a5d3aee535d1c5240845108f0fc5b`
- **Pushed main verification:** local `HEAD` and `origin/main` both resolved
  to that SHA before this handoff was created.
- **Planning checkout:** clean before this handoff file was created.
- **Worker mode:** implementation worker dispatched by the orchestrator.
- **Worker branch:** `worker/papercuts-wave20-git-fetch-timeout`
- **Worker worktree:** launcher first. `.agents.local.env` is absent in
  the planning checkout; if the launcher did not supply a clean
  dedicated non-`main` worktree, ask the operator for
  `AGENTS_WORKTREE_CONTAINER_DIR` before creating a fallback. Never use
  `/tmp`.
- **Required sibling worktree links:** `none`
- **Ready work items, in order:**
  1. Worker `git fetch origin` can hang on SSH — wrap the worker
     preflight fetch (router worker fast path, orchestrator mode, and
     the orchestrator-run template) with
     `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes"`.
     Keep the fetch itself. Do not change GitHub workflows. Add-and-close
     a Northstar PAPERCUTS bullet (this repo uses bullet format).
- **Out of scope:** editing Effigy; portfolio skill sync; GitHub
  workflows; release mutations.
- **Canonical refs:** `PAPERCUTS.md`;
  `skills/northstar/references/router.md` worker startup;
  `skills/northstar/references/modes/orchestrator.md`;
  `assets/templates/northstar-orchestrator-run.md.template`;
  Effigy open entry "`git fetch origin` can hang indefinitely waiting
  on SSH".
- **Required validation:** those three surfaces name the BatchMode
  wrap. Do not require a live hung-SSH reproduction.
- **PR URL:** pending
- **Merge authorisation:** absent; do not merge

## Boundaries

- Fail-fast fetch in worker preflight. Do not merge.

## Important Context

- This repo's PAPERCUTS uses bullet entries. Close in that format.
- **Report to:** the operator.

## Suggested Next Move

Read this file from the top. Run the worktree-safety preflight. After
the committed `HEAD` handoff checks out, skip sibling links (`none`),
then wrap the fetch.

## Completion Protocol

### Before you start

1. Read this handoff path. Its `worker_mode: implementation` and
   `dispatch_authority: orchestrator` metadata activate worker mode. Then
   run `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. If the current root is a registered worktree, status is empty, and the
   branch is not `main`, accept it. Record the actual path/branch.
3. If the launcher supplied a dirty or `main` worktree, stop and report
   it. `.agents.local.env` was absent; ask before creating a fallback.
   Never use `/tmp`.
4. From the selected worktree, record the repository-relative path
   `docs/handoffs/20260830-211110-papercuts-wave20-git-fetch-timeout.md`.
   Confirm `HEAD == origin/main`, ancestor
   `dbc71241080a5d3aee535d1c5240845108f0fc5b`, and that relative path in
   `HEAD`. Load
   `git show HEAD:docs/handoffs/20260830-211110-papercuts-wave20-git-fetch-timeout.md`.
   If the absolute dispatch file differs, stop. The `HEAD` copy is
   canonical.
5. Required sibling list is `none`. Skip link setup.
6. Read `AGENTS.md` and `PAPERCUTS.md`.

### When the assigned runway is complete

1. Close the bullet in `PAPERCUTS.md`. Push a PR. Do not merge.

### Review and merge path

Awaiting orchestrator review. Merge is operator-authorised only.

- **Closeout refs:** `PAPERCUTS.md`; this handoff; the PR.

### Handoff closeout

Do not edit Effigy. Leave portfolio skill sync open.
