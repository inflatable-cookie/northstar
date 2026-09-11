---
kind: northstar-handoff
title: "Implement UI design planning and delivery"
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: complete
base_required: pushed-main
queue_dispatch: northstar-queue
queue_approval: "Operator approved the three recommended policy choices, clarified the companion-tool posture, and said 'Let's dispatch' on 2026-09-11."
queue:
  capability: general
  skipPRReview: false
---

## What This Thread Was Doing

The operator reported that Northstar's orchestration loop produces weak UI
because workers receive implementation scope without a sufficiently designed
user workflow. Chatterbox researched current UI-design agent guidance, settled
the protocol choices with the operator, and promoted one strict implementation
lane.

## Why It Matters

Material experience decisions need to happen while alternatives are cheap to
inspect and change. The worker should implement an approved workflow and the
reviewer should judge the running result, rather than both reconstructing design
intent from a code diff.

## Current State

- **Done:** research is promoted; spec 039 freezes the brief, prototype gate,
  provider-neutral skill, companion-capability posture, and rendered review.
- **Implemented and merged:** the complete protocol in `g03.004`. PR #43 was
  accepted at exact head `571b0cde6e477736482dba18aea2095c8e7f7c1b` and merged
  as `d4245b18031f1589208a6babe2f49c2a62c4a18c`.
- **Active spec lane:** [`039`](../specs/039-ui-design-planning-and-delivery.md).
- **Current task:** [`g03.004`](../roadmaps/g03/004-ui-design-planning-and-delivery.md).
- **Canonical refs:** contract 001, system architecture, spec 039, and the
  research translation memo named by the task.
- **Remaining continuation envelope:** `g03.004` only; no automatic successor.
- **Lane budget / pause signal:** one bounded PR lane; stop on the task's named
  authority, handoff-shape, renderer, scoring, or fixture limits.
- **Sibling lanes:** none; this is the only approved frontier.
- **Worker profile:** automatic adequate implementation pool, general
  capability; frontier-worker justification: none.
- **Required sibling worktree links:** none.
- **Owned and reserved paths:** exactly those in the task dispatch manifest.
- **Key files:**
  - `/Users/tom/Dev/projects/northstar/docs/specs/039-ui-design-planning-and-delivery.md`
  - `/Users/tom/Dev/projects/northstar/docs/roadmaps/g03/004-ui-design-planning-and-delivery.md`
  - `/Users/tom/Dev/projects/northstar/bundle-docs/research/translation-memos/ui-design-planning-and-delivery.md`

## Boundaries

Please keep the implementation within spec 039 and the task manifest. Do not
change consumer-product UIs, require Impeccable or another external tool, add a
Northstar renderer, invent a universal aesthetic or design score, alter the
seven top-level handoff sections, touch workflows or releases, or combine
unrelated protocol cleanup. Follow the repository `AGENTS.md` and named
canonical refs.

## Important Context

- **Planning lineage:** operator UI-quality report → external design-workflow
  research → translation memo → operator policy choices → spec 039 → `g03.004`.
- **How the plan fits the system:** architecture and contract 001 will own the
  durable readiness and delivery boundaries; spec 039 owns the active design;
  the task owns execution and evidence.
- **Decisions and preferences:** the full brief lives in the canonical task or
  spec with a self-contained handoff copy; substantial redesign requires an
  operator-approved concept or prototype; the skill is provider-neutral;
  Impeccable is a recommended supported companion when a project lacks
  equivalent UI execution capability.
- **UI Design Brief:** this lane changes Northstar documentation, skills,
  templates, and structural checks rather than a product interface. Spec 039 is
  the protocol design. No product UI workflow or concept artifact applies to
  this implementation lane.
- **Open tensions:** deterministic fixtures can prove protocol wiring but cannot
  prove aesthetic quality. Preserve that limit and leave live consumer evidence
  for the first natural operator-supplied lanes.

## Suggested Next Move

No further worker action is needed. Return to Chatterbox for the next planning
checkpoint; no successor is approved.

## Completion Protocol

Task `g03.004` completed through PR #43, independent exact-head review,
merge-sync, and synchronized-main closeout. The task and roadmap surfaces now
retain the canonical outcome and evidence. No continuation envelope remains;
queue orchestration owns the final task disposition.

There is no continuation envelope after `g03.004`. The next task is an explicit
Chatterbox planning checkpoint.

Disposition trigger: delete this transient handoff after merge, abandonment, or
ownership transfer once its unique meaning is promoted or consumed.
