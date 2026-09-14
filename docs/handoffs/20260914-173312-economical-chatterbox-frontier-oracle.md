---
kind: northstar-handoff
title: "g03.016 — Economical Chatterbox and frontier Oracle"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-14
updated: 2026-09-14
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Tom said 'Great, go for it' after approving the economical Chatterbox, bounded frontier Oracle, and role-cleanup direction."
queue:
  capability: general
  skipPRReview: false
  notifyOriginOnCloseout: false
---

## What This Thread Was Doing

Chatterbox and the operator reviewed Northstar's planning-role cost. Persistent
frontier Chatterboxes work well but consume the OpenAI weekly allowance too
quickly; the current planning delegate already overlaps the proposed Oracle.

## Why It Matters

Routine planning needs continuity, conversation, repository inspection, and
canonical promotion more often than frontier reasoning. A bounded escalation
role can reserve Astra/Fable-class capacity for the few decisions that need it
without creating a second planning authority.

## Current State

- Canonical task: [g03.016](../roadmaps/g03/016-economical-chatterbox-frontier-oracle.md).
- `g03.015` is complete at `1b84042`; the generation is open and
  `planning_required`.
- Current doctrine has Chatterbox, planning delegate, Coordinator, Worker, and
  Reviewer boundaries, but the delivery mode is still named Orchestrator.
- Queue already handles routine coordination mechanically and reserves
  Coordinator recovery for unresolved exceptions.

## Boundaries

Change current reusable role doctrine, skill routing, templates, focused checks,
and matching Northstar planning only. Do not edit Queue, Effigy, consumers,
Paseo profiles, releases, product code, historical evidence, or any existing
agent thread/workspace.

## Important Context

The settled topology is economical persistent Chatterbox, optional bounded
frontier Oracle, on-demand/standalone Coordinator, implementation Worker, and
independent Reviewer. Oracle replaces planning delegate and returns advisory
intake to Chatterbox. Rename live Orchestrator-mode surfaces to Coordinator
atomically without an alias. Northstar remains provider-neutral; local profile
configuration maps actual models. Do not trust model self-assessment: add the
task's mandatory observable decision-risk gate and `Oracle gate` manifest
disposition. Material security, privacy, sensitive-data, trust-boundary,
irreversible, or complex cross-system decisions require Oracle planning unless
canonical authority and a falsifiable oracle prove the work is already
mechanical. Oracle dossiers stay minimal and redact secrets and raw sensitive
payloads.

## Suggested Next Move

Inventory every current role name and router edge, define the minimal topology
once, then update the distributable skill and reusable doctrine from that map.
Keep historical logs and completed task evidence untouched.

## Completion Protocol

Open one non-draft PR from the Queue workspace. Run docs QA, full QA,
installed-skill parity, focused role-routing/link checks, and
`git diff --check`. Independent review must verify authority separation,
provider neutrality, mandatory risk-gate positives and negatives, dossier
redaction, Coordinator portability, clean renames, and the explicit
preservation of existing threads/workspaces. After merge, let the repository
hook publish g03.016 and consume this handoff. No consumer rollout or live
profile mutation belongs to the worker.
