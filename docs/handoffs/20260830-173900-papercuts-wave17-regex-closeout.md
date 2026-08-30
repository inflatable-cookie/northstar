---
title: Papercuts wave 17 regex surface closeout worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Tom / papercuts orchestrator
created: 2026-08-30
updated: 2026-08-30
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260830-173900-papercuts-wave17-regex-closeout.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, papercuts]
---

## What This Thread Was Doing

Effigy PR 56 landed: the Rhai surface catalog now matches the live host
order `regex::replace(pattern, value, replacement)` (and the same-order
`is_match` / `captures` twins). This repo still lists the copy.

You are the Northstar implementation worker. Prove that catalog against
sibling Effigy and close the copy. Do not re-implement the surface here.

## Why It Matters

An open copy still sends the next script author to the reversed
signature.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `77dcda9fa20e9d63977eb3488b0738ea0391f0bb`
- **Pushed main verification:** local `HEAD` and `origin/main` both resolved
  to that SHA before this handoff was created.
- **Planning checkout:** clean before this handoff file was created.
- **Worker mode:** implementation worker dispatched by the orchestrator.
- **Worker branch:** `worker/papercuts-wave17-regex-closeout`
- **Worker worktree:** launcher first. `.agents.local.env` is absent in
  the planning checkout; if the launcher did not supply a clean
  dedicated non-`main` worktree, ask the operator for
  `AGENTS_WORKTREE_CONTAINER_DIR` before creating a fallback. Never use
  `/tmp`.
- **Required sibling worktree links:**
  - `effigy` from `/Users/tom/Dev/projects/effigy` as `../effigy`
  Create when absent; reuse only a symlink that already resolves to that
  source; stop on any other existing path; never overwrite.
- **Ready work items, in order:**
  1. Effigy `regex::replace` surface signature is reversed — close if
     sibling Effigy `13182d2b19eb7ff23f91f2742947bcb0514557c2` (PR 56)
     prints `regex::replace(pattern, value, replacement)` from
     `effigy rhai surface` (and the live-order `is_match` / `captures`
     strings if those were in the same fix). Cite that SHA. If PATH
     Effigy is older, run the sibling binary **from inside that
     checkout**. Do not re-implement the catalog here.
- **Out of scope:** editing Effigy; Swallowtail `gated` status
  vocabulary; batch-card template edits; GitHub workflows; release
  mutations.
- **Canonical refs:** `PAPERCUTS.md` (bullet format, not `### [ ]`);
  Effigy PR 56 (`13182d2b19eb7ff23f91f2742947bcb0514557c2`).
- **Required validation:** sibling `effigy rhai surface` shows the
  live-order replace signature. Close the bullet with the SHA you
  actually ran.
- **PR URL:** pending
- **Merge authorisation:** absent; do not merge

## Boundaries

- Prove Effigy 56, then close the copy. Do not edit Effigy. Do not merge.

## Important Context

- This repo's PAPERCUTS uses bullet entries. Close in that format.
- **Report to:** the operator.

## Suggested Next Move

Read this file from the top. Run the worktree-safety preflight. After
the committed `HEAD` handoff checks out, create the Effigy sibling
link, then prove the catalog.

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
   `docs/handoffs/20260830-173900-papercuts-wave17-regex-closeout.md`.
   Confirm `HEAD == origin/main`, ancestor
   `77dcda9fa20e9d63977eb3488b0738ea0391f0bb`, and that relative path in
   `HEAD`. Load
   `git show HEAD:docs/handoffs/20260830-173900-papercuts-wave17-regex-closeout.md`.
   If the absolute dispatch file differs, stop. The `HEAD` copy is
   canonical.
5. Then create the sibling links from that tracked list. Canonicalize
   source and destination. Create when absent; reuse only a correct
   symlink; stop on conflict; never overwrite. Do not skip a listed
   catalog member.
6. Read `AGENTS.md` and `PAPERCUTS.md`.

### When the assigned runway is complete

1. Close the bullet in `PAPERCUTS.md`. Push a PR. Do not merge.

### Review and merge path

Awaiting orchestrator review. Merge is operator-authorised only.

- **Closeout refs:** `PAPERCUTS.md`; this handoff; the PR.

### Handoff closeout

If sibling Effigy is older than PR 56, keep the copy open with the SHA
you actually ran.
