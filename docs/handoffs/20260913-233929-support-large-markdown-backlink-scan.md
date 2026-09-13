---
kind: northstar-handoff
title: "g03.013 — Support large Markdown backlink scanning"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-13
updated: 2026-09-13
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Tom said Continue on 2026-09-13 for the g03.012 portfolio rollout; Monkey's exact held closeout proves this shared repair is required."
queue:
  capability: general
  skipPRReview: false
  notifyOriginOnCloseout: false
---

## What This Thread Was Doing

The g03.012 portfolio repair reached Monkey closeout and the installed guard refused its normal 531,294-byte changelog before scanning it.

## Why It Matters

Monkey is already merged and synchronized, but its exact terminal record and handoff consumption cannot publish. Poodle carries a 370,853-byte evidence ledger and would hit the same obsolete 256 KiB bound.

## Current State

- Canonical task: [g03.013](../roadmaps/g03/013-support-large-markdown-backlink-scan.md).
- Northstar main is clean and synchronized before this promotion.
- Monkey Queue task `2d577072-6c59-4ee0-ac2e-dcd604d10abf` is held at
  closeout hook event `1e778aa5-fd73-4822-849f-c762df1f7f8d`.
- Monkey and Poodle remain consumer evidence only; this worker edits neither.

## Boundaries

Change the Northstar backlink size bound, focused fixtures, and matching doctrine only. Do not edit consumers, bypass hooks, whitelist paths, change Queue/Effigy, release anything, or touch Paseo threads/workspaces.

## Important Context

Preserve g03.012's conservative lexical safety boundary. Large Markdown must be scanned in full within a finite 4 MiB per-file cap. Files above the cap still fail closed. Test both large-clean success and exact-link atomic refusal.

## Suggested Next Move

Start with the lifecycle adoption fixture so the old 256 KiB behavior fails for the right reason, then change the bound and retain every prior exact-link control.

## Completion Protocol

Open one non-draft PR from the Queue workspace. Run lifecycle core/adoption
checks, docs QA, full QA, installed parity, and `git diff --check`. Independent
review must verify the exact head and both large-file directions. After merge,
the Northstar repository hook publishes g03.013. Chatterbox then updates the
global skill and retries the retained consumer hook events; the worker performs
no consumer mutation.
