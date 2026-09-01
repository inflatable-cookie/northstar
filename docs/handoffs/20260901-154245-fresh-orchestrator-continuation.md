---
title: Fresh orchestrator continuation implementation handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: complete
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-154245-fresh-orchestrator-continuation.md
tags: [coordination, handoff, worker, orchestration, paseo]
---

## What This Thread Was Doing

The operator asked Northstar orchestrator mode to support handing one live lane
to a fresh orchestrator thread. Planning settled the authority transfer and the
optional Paseo launch shape. PR 18 has now merged, so the serial validation
dependency is clear and card 114 is ready for implementation.

## Why It Matters

A fresh orchestrator needs the same lane authority without being mistaken for a
worker or planning delegate. Paseo should make the common launch concise and
visible, while manual launch remains complete and sidebar pinning stays a human
action when the control plane exposes no native pin API.

## Current State

- **Done:** card 114 protocol, eight-row assertions, closeout, and a reviewable
  PR on `worker/fresh-orchestrator-continuation`. Current `origin/main` at
  `94604a4` is integrated. Diversified model-routing remains unedited on main.
- **Still open:** orchestrator exact-head review and merge. Spec 034 is not
  ready. Diversified model-routing is a separate serial planning note.
- **Active spec lane:** none. Spec 034 is separate and not ready.
- **Current batch card:**
  `docs/roadmaps/g02/batch-cards/114-add-fresh-orchestrator-continuation.md`.
- **Canonical refs:** milestone 046, spec 026, system architecture, working
  rules, and the handoff contract.
- **Remaining continuation envelope:** exhausted after card 114; no auto-start.
- **Lane budget / pause signal:** stop after a pushed PR and exact tested head.
- **Planning base:** pushed `main` at `08851328353322140d6c9dcc71130a19c1f5230f`
  before this handoff commit.
- **Worker branch:** `worker/fresh-orchestrator-continuation`.
- **Required sibling worktree links:** none.
- **Concurrent Northstar lanes:** none owns the router, orchestrator mode,
  handoff contract, reusable doctrine, copy-ready working rules, or card 114
  closeout.
- **Owned surfaces:** card 114's protocol propagation, focused assertions,
  distribution proof, dated closeout log, handoff status, and directly
  dependent front doors.
- **Model capability profile:** Grok Worker, the matching day-to-day profile.
- **Frontier-worker justification:** none; planning and the eight-row oracle are
  settled.
- **Key files:**
  - `/Users/tom/Dev/projects/northstar/docs/roadmaps/g02/046-add-fresh-orchestrator-continuation.md`
  - `/Users/tom/Dev/projects/northstar/docs/roadmaps/g02/batch-cards/114-add-fresh-orchestrator-continuation.md`
  - `/Users/tom/Dev/projects/northstar/docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
  - `/Users/tom/Dev/projects/northstar/skills/northstar/references/handoff-contract.md`

## Boundaries

- **In scope:** card 114 only, including reusable protocol surfaces,
  deterministic assertions, source/install parity, closeout, and PR.
- **Out of scope:** modifying Paseo, adding a plugin or pin API, browser or
  computer-use pinning, launching a real successor during tests, changing
  worker/planning-delegate semantics, or beginning spec 034.
- **Repo constraints:** follow
  `/Users/tom/Dev/projects/northstar/AGENTS.md` and the canonical refs above.
- Preserve the generic seven-section handoff. Do not add a public mode or
  template.

## Important Context

- **Planning lineage:** the first-principles simplification work froze protocol
  growth, reduced prose-coupled validation through g02.045, then explicitly
  allowed this small operator-requested continuation feature as the next serial
  lane.
- **System fit:** spec 026 settles the orchestrator/worker authority model;
  architecture and working rules own reusable behavior; the handoff contract
  owns activation without becoming a second planning spine.
- **Decisions:** use a separate Paseo local workspace for the same project, copy
  a current orchestrator profile by its notes, apply the capitalized
  `Orchestrator=true` agent label, and use only the absolute handoff path as the
  launch prompt. Pin placement is manual unless Paseo later exposes a native
  control.
- **Open tension:** capability descriptions can drift. Keep reusable policy
  provider-neutral and prove absent pin support without encoding current model
  names or reaching for UI automation.

## Suggested Next Move

Review the worker PR at its exact tested head against the eight oracle rows.
Do not merge from the worker. Do not start spec 034 or the diversified
model-routing note from this handoff.

## Completion Protocol

### Worker and PR flow

1. Work only in the Paseo-managed non-`main` worktree and branch selected for
   this handoff. Preserve unrelated state.
2. Execute card 114 only. Do not invent unsettled behavior or start spec 034.
3. Falsify all eight milestone oracle rows before closeout.
4. Run `effigy check:command-skills`, isolated
   `effigy check:skill-install`, `effigy qa:docs`, `effigy qa`, and
   `git diff --check`.
5. Reconcile card 114, milestone 046, one dated log, this handoff, and directly
   dependent front doors.
6. Push `worker/fresh-orchestrator-continuation` and open a PR against current
   `main`. If `main` moved, integrate it and rerun validation.
7. Report the PR URL, exact tested head, validation, and any remaining limit.
   Do not merge; the orchestrator owns exact-head review and merge.

The continuation envelope is exhausted after card 114. Stop on a product/API
gap, workspace-label requirement, need for UI automation, or any change to the
settled authority model.
