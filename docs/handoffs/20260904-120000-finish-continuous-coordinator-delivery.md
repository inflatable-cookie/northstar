---
title: Finish continuous coordinator delivery
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Northstar orchestrator
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-120000-finish-continuous-coordinator-delivery.md
base_required: pushed-main
tags: [coordination, handoff, worker, card-129]
---

## Dispatch

Dispatch the sole approved ready lane `g02.054/129` directly to one economical
implementation worker. This is a mechanical overlay on canonical planning at
`4933d6aac05b6b4214009e1524a473f0b475b1f5`; it does not recompile planning or
create a promotion worker, planning child, or planning PR.

## State and scope

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning base:** `4933d6aac05b6b4214009e1524a473f0b475b1f5`
- **Lane:** `g02.054/129`
- **Card:** `docs/roadmaps/g02/batch-cards/129-finish-continuous-coordinator-delivery.md`
- **Governing refs:** `docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`, `docs/roadmaps/g02/054-finish-continuous-coordinator-delivery.md`, `docs/contracts/001-working-rules.md`
- **Worker class:** fast economical general/day-to-day implementation worker; exclude audit, documentation-grind, review, planning, and coordinator profiles
- **Approved siblings:** none
- **Serial edge:** card 126 is passive after card 129 merge and installed parity; stop at the tenth natural lane or `2026-09-18 17:00 Europe/London`
- **Escalation owner:** Chatterbox for missing semantics, sequencing, or acceptance; operator only for destructive/material permission choices

## Boundaries

Use only card 129's named mutable surfaces. Preserve exact-head review,
same-workspace serial clean leases, independent provider/model identity, merge
gates, installed parity, and the connector-write fallback rule. Do not create
synthetic card-126 work, notify Chatterbox for child-wait yields, or make
semantic choices absent from the card.

## Worker completion

Implement, validate, commit, push, and open one PR against current `main`.
Report the PR URL, exact head, changed files, checks, and blockers. Do not merge.
The coordinator will create one independent reviewer in this same worker
workspace with `notifyOnFinish: true`; the reviewer must use a different
underlying provider/model identity from the worker.
