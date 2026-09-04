---
title: Establish lifecycle and roll up g01
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Northstar orchestrator
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-123000-establish-lifecycle-and-roll-up-g01.md
base_required: pushed-main
tags: [lifecycle, generation-rollup, handoff, worker, card-130]
---

## Dispatch

Dispatch the sole approved ready lane `g03.001/130` directly to one economical
general/day-to-day implementation worker. This is a mechanical overlay on the
operator-confirmed canonical planning promotion `bde563c8a5c761fad1af4fafbf918663f6ab0c38`; it does not recompile planning or create a promotion or planning child.

## State and scope

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning base:** `bde563c8a5c761fad1af4fafbf918663f6ab0c38`
- **Lane:** `g03.001/130`
- **Card:** `/Users/tom/Dev/projects/northstar/docs/roadmaps/g03/batch-cards/130-establish-lifecycle-and-roll-up-g01.md`
- **Governing refs:** `spec 038`, `docs/contracts/001-working-rules.md`
- **Worker class:** economical general/day-to-day documentation implementation; exclude auditor, planner, coordinator, and documentation-grind profiles
- **Approved siblings:** none before this card merges; cards 131 and 132 are the approved concurrent frontier after merge and installed-base verification
- **Escalation owner:** Chatterbox for meaning, retention, or deletion choices

## Boundaries

Use only the card's exact owned mutable paths. Freeze every tracked `g01`
deletion target, preserve unique current authority and unresolved commitments,
create one non-procedural `g01` roll-up, remove only the expanded `g01` content,
and keep current links valid. Reserved shared closeout surfaces are not for
semantic expansion; update only what is required for changed `g01` links.

## Worker completion

Run the card's acceptance checks and preservation-oracle review, commit, push,
and open one PR against current `main`. Do not merge. Report the PR URL, exact
head SHA, frozen deletion inventory, changed paths, validation, and blockers.
The coordinator will create one independent reviewer in this same worker
workspace with `notifyOnFinish: true`, requiring a different underlying
provider/model identity, then apply the exact-head merge gate and closeout.
