---
kind: northstar-handoff
title: "g03.017 — Reject transient handoff backlinks before merge"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-15
updated: 2026-09-15
base_required: pushed-main
roadmap: docs/roadmaps/g03/017-reject-transient-handoff-backlinks-before-merge.md
queue_dispatch: northstar-queue
queue_approval: "Tom said 'Continue' after Chatterbox proposed promoting and dispatching the pre-merge backlink gate on 2026-09-15."
queue:
  dependsOn: [a1571254-17e5-414c-9bc0-d80146c6288c]
  capability: general
  skipPRReview: false
  notifyOriginOnCloseout: false
---

## What This Thread Was Doing

Chatterbox traced repeated post-merge closeout escalations to a timing flaw.
Northstar already refuses to delete a transient worker handoff while durable
Markdown links to it, but the mechanical proof runs only after merge.

## Why It Matters

A worker-fixable backlink should use the ordinary PR revision loop. Discovering
it during hook-owned closeout consumes recovery and Chatterbox attention after
the implementation has already merged.

## Current State

- Canonical task: [g03.017](../roadmaps/g03/017-reject-transient-handoff-backlinks-before-merge.md).
- Northstar planning is pushed on `main` at `c022f3c`.
- Queue froze control manifest v3, event envelope v2, `task.pre_merge`, and
  `target: reviewed_head` at Queue planning commit
  `7b562d47836178a035443f0577a043d91acc987d`.
- Queue implementation task `a1571254-17e5-414c-9bc0-d80146c6288c` is the
  serial prerequisite. Queue will not dispatch this worker until it is done.
- The existing closeout resolver and atomic refusal are live under
  `skills/northstar/scripts/lifecycle-queue-hook.ts`.

## Boundaries

Change Northstar's lifecycle skill, frozen Queue contract mirrors, self-hosting
and starter manifests, focused tests, reusable lifecycle doctrine, and matching
g03 evidence. Do not edit Queue, Effigy, consumers, CI, releases, provider
routing, or any existing agent thread or workspace.

## Important Context

Use one import-safe backlink resolver for pre-merge and closeout. The new hook
is required, read-only, and runs in the retained clean task workspace at the
accepted exact PR head. It reads the task's pinned submitted instruction and
returns a blocking result naming durable backlink paths. Queue owns routing
that refusal to the retained worker's semantic revision loop. Preserve v1/v2
manifest compatibility and `paseo.queue.hook-result.v1`. Keep the closeout
guard unchanged as defence in depth.

This Northstar PR can self-prove the integration: Effigy resolves the skill from
the repository checkout before the global install, so the reviewed PR head can
run its own new adapter through Queue's landed v3 event support.

## Suggested Next Move

Read Queue Spec 007 and its landed contract first. Extract the resolver without
changing its behavior, add the v3/v2 schema mirrors and event handling, then
bind `repository-pre-merge` in both manifests and prove the full exact-head
positive and negative path.

## Completion Protocol

Open one non-draft PR from the Queue workspace. Run focused lifecycle and hook
fixtures, docs QA, full QA, skill validation, installed parity, and
`git diff --check`. Independent review must verify exact reviewed-head binding,
one shared resolver, read-only behavior, old-manifest compatibility, ordinary
revision routing, and unchanged closeout refusal. Do not add any durable link
to this submitted handoff; cite the canonical task, PR, commit, contract, or a
durable log instead. After merge, let the repository hook publish g03.017 and
consume this handoff.
