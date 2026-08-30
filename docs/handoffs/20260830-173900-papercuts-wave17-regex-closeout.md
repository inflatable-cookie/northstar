---
title: Papercuts wave 17 regex surface closeout worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: awaiting-review
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
`is_match` / `captures` twins). This repo still listed the copy.

The Northstar implementation worker proved that catalog against sibling
Effigy and closed the copy. It did not re-implement the surface here.

## Why It Matters

An open copy still sends the next script author to the reversed
signature.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `77dcda9fa20e9d63977eb3488b0738ea0391f0bb`
- **Worker mode:** implementation runway complete; handoff is review-only.
- **Actual worker branch:** `t3code/close-regex-surface-copy`
- **Actual worker worktree:**
  `/Users/tom/.t3/worktrees/northstar/t3code-259f4503`
- **Sibling link:** `../effigy` → `/Users/tom/Dev/projects/effigy`
  (created; resolves correctly).
- **Completed work:**
  1. Ran sibling `cargo run --bin effigy -- rhai surface` from Effigy
     HEAD `13182d2b19eb7ff23f91f2742947bcb0514557c2` (PR 56).
  2. Confirmed live-order catalog strings:
     `regex::replace(pattern, value, replacement)`,
     `regex::is_match(pattern, value)`,
     `regex::captures(pattern, value)`.
  3. Closed the matching open bullet in `PAPERCUTS.md` citing that SHA.
- **Evidence commit:** `61d8bab28bc23da7dfff4fe9b936397856243e43`
  (papercut closeout; handoff review-state update follows).
- **Out of scope (unchanged):** editing Effigy; Swallowtail `gated`
  status vocabulary; batch-card template edits; GitHub workflows;
  release mutations.
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/10
- **Review state:** `awaiting-review`
- **Merge authorisation:** absent; do not merge

## Boundaries

- Do not re-dispatch or re-execute this runway. Do not edit Effigy. Do
  not merge without operator authorisation.

## Important Context

- This repo's PAPERCUTS uses bullet entries. Closeout used that format.
- **Report to:** the operator / orchestrator reviewer.

## Suggested Next Move

Review https://github.com/inflatable-cookie/northstar/pull/10. Confirm
the closed `PAPERCUTS.md` bullet cites
`13182d2b19eb7ff23f91f2742947bcb0514557c2` and that this handoff stays
`awaiting-review` (not `ready-to-launch`). Merge only with explicit
operator authorisation.

## Completion Protocol

### Runway status

Assigned implementation runway is complete. Do not re-run the startup
preflight or sibling-link setup as a fresh dispatch.

### Review and merge path

Awaiting orchestrator review. Merge is operator-authorised only.

- **Closeout refs:** `PAPERCUTS.md`; this handoff; PR 10.

### Handoff closeout

Sibling Effigy at PR 56 printed the live-order signatures; the papercut
is closed against that SHA.
