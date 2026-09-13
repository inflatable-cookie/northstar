---
kind: northstar-handoff
title: "g03.011 — Support parallel active-generation projections"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-13
updated: 2026-09-13
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Tom approved one Queue task per Northstar project on 2026-09-13; Underlay must retain its legitimate parallel-generation mode."
queue:
  capability: complex
  skipPRReview: false
---

## What This Thread Was Doing

Chatterbox was rolling out the Effigy-hosted lifecycle hook across the Northstar
portfolio. Underlay exposed a schema gap: it legitimately runs `g11` and `g12`
in parallel, while lifecycle projection configuration names one active generation.

## Why It Matters

Picking either Underlay generation would publish false state. The portable core
needs a strict plural representation while preserving the singular default for
sequential repositories.

## Current State

- Canonical task: [`g03.011`](../roadmaps/g03/011-support-parallel-active-generation-projections.md).
- Northstar `g03.010` and the live v2 closeout proof are complete at `36dc197`.
- Twenty-seven singular consumers are already queued for configuration adoption.
- Underlay adoption waits for this task; no Underlay file has been changed.
- Queue origin is escalation routing only, with closeout notification disabled.

## Boundaries

Implement the strict singular/plural union inside Northstar. Do not edit Queue,
Effigy, Underlay, consumer product behavior, releases, CI, or Paseo threads and
workspaces.

## Important Context

Northstar supports explicit sequential and parallel generation modes. Plural
lifecycle configuration records an already-authorized repository mode; it must
not grant parallel planning authority by itself.

## Suggested Next Move

Implement normalized active-generation membership and deterministic multi-row
projection rendering with focused negative fixtures. Open a PR, obtain
independent exact-head review, merge, and let the existing required hook publish
terminal state.

## Completion Protocol

The task completes through Queue after accepted implementation, independent
review, merge, and Effigy-hosted hook closeout. The hook consumes this exact
handoff; no agent-authored closeout commit is permitted.
