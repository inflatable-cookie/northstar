---
title: Make compact lifecycle the default
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Northstar orchestrator
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-123501-make-compact-lifecycle-default.md
base_required: pushed-main
tags: [lifecycle, compact-default, handoff, worker, card-132]
---

## Dispatch

Dispatch the approved sibling lane `g03.001/132` directly after card 130's
merge and synchronized-main verification. This overlay does not recompile
planning or create a promotion/planning child.

## State and scope

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning base:** `e8637b3d74db63c5d805f6726d4e59dd37a49da9`
- **Lane:** `g03.001/132`
- **Card:** `/Users/tom/Dev/projects/northstar/docs/roadmaps/g03/batch-cards/132-make-compact-lifecycle-default.md`
- **Governing refs:** `spec 038`, `docs/contracts/001-working-rules.md`
- **Worker class:** economical general/day-to-day implementation with documentation and deterministic-check competence; exclude auditor, planner, coordinator, and documentation-grind profiles
- **Approved sibling:** card 131, disjoint ownership; run concurrently
- **Escalation owner:** Chatterbox for behavior or compatibility choices

## Boundaries

Use only card 132's owned paths. Make one compact lifecycle the reusable
default, preserve strict authority/review/evidence/stop protections, implement
the mandatory provider-merge → fetch → local-main fast-forward → exact-head
reconciliation invariant, and add its fail-closed fixtures. Do not edit card
131's live generation/log/handoff/front-door compaction surfaces.

## Worker completion

Run the card's required checks and independent review oracle, commit, push, and
open one PR against current `main`. Do not merge. Report exact head, changed
paths, validation, and blockers. The coordinator will use a same-workspace
independent reviewer with a distinct provider/model identity.
