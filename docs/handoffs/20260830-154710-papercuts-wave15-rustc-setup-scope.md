---
title: Papercuts wave 15 rust-quality setup relative-scope worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Tom / papercuts orchestrator
created: 2026-08-30
updated: 2026-08-30
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260830-154710-papercuts-wave15-rustc-setup-scope.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, papercuts]
---

## What This Thread Was Doing

Signal filed that `rust-quality:setup apply` rejects an absolute scope
directory even when that path is the target root. The helper
`require_relative_scope` only admits `.` or a repo-relative segment
path. The first setup invocation fails before profile discovery.

You are the Northstar implementation worker. Make absolute-under-target
scope usable, and make the usage error name the relative form. Leave
TypeScript setup alone unless it is the same helper and the same
rejection. Do not change audit scope (`worktree` / `repository`).

## Why It Matters

A consumer activation that already holds an absolute repo path cannot
start the managed Rust setup.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `d43176501669829636cf6bfcfa359c1643f1ff36`
- **Pushed main verification:** local `HEAD` and `origin/main` both resolved
  to that SHA before this handoff was created.
- **Planning checkout:** clean before this handoff file was created.
- **Worker mode:** implementation worker dispatched by the orchestrator.
- **Worker branch:** `worker/papercuts-wave15-rustc-setup-scope`
- **Worker worktree:** launcher first. `.agents.local.env` is absent in
  the planning checkout; if the launcher did not supply a clean
  dedicated non-`main` worktree, ask the operator for
  `AGENTS_WORKTREE_CONTAINER_DIR` before creating a fallback. Never use
  `/tmp`.
- **Required sibling worktree links:** `none`
- **Ready work items, in order:**
  1. Rust quality setup scope is repository-relative — Signal hit
     `skills/northstar/scripts/rust-quality-setup.rhai`
     `require_relative_scope` with an absolute directory that was the
     target root. Keep relative as the stored form. If the caller
     passes an absolute path that is the target root or a subdirectory
     of it, canonicalize to relative instead of failing. Reject `..`
     and paths outside the target. Usage / error text must name the
     relative form (`.` or `crates/foo`). Add a self-test for
     absolute-target-root and a still-rejected escape (`..` or outside
     target). Do not change audit `--scope worktree|repository`.
- **Out of scope:** Signal consumer closeout (later, after this
  lands); TypeScript quality setup unless it is the same absolute-scope
  rejection in `typescript-quality-setup.rhai`; GitHub workflows;
  release mutations; AGENTS compacting.
- **Canonical refs:** `PAPERCUTS.md` (bullet format, not `### [ ]`);
  `skills/northstar/scripts/rust-quality-setup.rhai`; Signal
  `PAPERCUTS.md` entry "Rust quality setup scope is repository-relative".
- **Required validation:** `rust-quality:setup self-test` passes,
  including the new absolute-under-target case. Usage error still names
  the relative form. Do not require a live Signal apply from this PR.
- **PR URL:** pending
- **Merge authorisation:** absent; do not merge

## Boundaries

- Setup scope canonicalization only. Do not merge.

## Important Context

- This repo's PAPERCUTS uses bullet entries, not `### [ ]`. Close in
  that format.
- The Signal copy stays open until a later consumer closeout cites this
  SHA.
- **Report to:** the operator.

## Suggested Next Move

Read this file from the top. Run the worktree-safety preflight. After
the committed `HEAD` handoff checks out, skip sibling links (`none`),
then fix `require_relative_scope` / apply argument handling.

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
   `docs/handoffs/20260830-154710-papercuts-wave15-rustc-setup-scope.md`.
   Confirm `HEAD == origin/main`, ancestor
   `d43176501669829636cf6bfcfa359c1643f1ff36`, and that relative path in
   `HEAD`. Load
   `git show HEAD:docs/handoffs/20260830-154710-papercuts-wave15-rustc-setup-scope.md`.
   If the absolute dispatch file differs, stop. The `HEAD` copy is
   canonical.
5. Required sibling list is `none`. Skip link setup.
6. Read `AGENTS.md` and `PAPERCUTS.md`.

### When the assigned runway is complete

1. Close the entry in this repo's `PAPERCUTS.md` (bullet format). Push a
   PR. Do not merge.

### Review and merge path

Awaiting orchestrator review. Merge is operator-authorised only.

- **Closeout refs:** `PAPERCUTS.md`; this handoff; the PR.

### Handoff closeout

Do not edit Signal in this PR.
