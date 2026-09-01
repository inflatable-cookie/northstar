---
title: Make orchestrator scheduling parallel-first worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-101028-make-orchestrator-parallel-first.md
base_required: pushed-main
tags: [coordination, handoff, worker, orchestrator, parallelism]
---

## What This Thread Was Doing

The operator selected parallel-first scheduling as the Northstar orchestrator
default. The orchestrator settled the dependency-frontier, capacity-refill,
shared-surface, coherent-issue, and exact-head boundaries in spec 026 and made
`g02.042/110` ready.

This dispatches the bounded implementation and distribution lane. The handoff
links the authority; it does not replace it.

## Why It Matters

Northstar currently permits parallel workers but frames them as an optional
offer. That wording produces serial execution unless the operator asks again.
The system should launch safe independent work by default while keeping genuine
dependencies and shared authority serial.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch/base:** `main` at
  `9e9049a76d046e47821246952f475cd3a62d93a7`
- **Pushed-main verification:** local `HEAD` equalled `origin/main` after push
- **Worker branch:** `worker/make-orchestrator-parallel-first`
- **Worker worktree:** Paseo-managed; launcher-selected path is authoritative
- **Worktree creation:** Paseo `branch-off` from `origin/main`
- **Required sibling worktree links:** none
- **Roadmap/card:** `docs/roadmaps/g02/042-make-orchestrator-parallel-first.md`,
  `docs/roadmaps/g02/batch-cards/110-make-orchestrator-parallel-first.md`
- **Allowed runway:** one doctrine, contract, skill, template, check,
  distribution, closeout, and PR lane
- **Dispatch topology:** one coherent Northstar implementation lane; unrelated
  consumer-repo review/closeout work may continue concurrently
- **Parallel safety:** no duplicate Northstar protocol lane exists; this worker
  owns its branch and Northstar closeout surfaces until PR review
- **Review oracle:** all six rows in milestone `g02.042`
- **Capability:** meaning-sensitive protocol implementation; high reasoning
- **Required validation:** `effigy check:command-skills`,
  `effigy check:skill-install`, `effigy qa:docs`, `effigy qa`, and
  `git diff --check`
- **PR base/head:** `main` <- `worker/make-orchestrator-parallel-first`
- **Review/merge:** orchestrator exact-head review, then merge after acceptance
  and passing checks without another operator prompt

## Boundaries

- Implement card 110 across the named reusable and installable surfaces.
- Keep the behavior provider-neutral and profile-driven. Do not encode Paseo,
  a model name, a profile name, a fixed worker count, or a scheduler daemon.
- Preserve serial execution for actual dependency, shared mutable or closeout
  scope, unresolved authority, or exhausted capacity. Name the reason.
- Keep one reported issue-fix in one outcome lane. Parallelism must not create
  speculative cards or diagnosis-only PRs.
- Do not weaken worktree isolation, PR review, current-head checks, merge
  ordering, operator pause gates, or serial mechanical docs projection.
- Do not edit workflows or release surfaces. Do not merge from the worker.

## Important Context

- The current permissive wording appears in the orchestrator mode, working
  rules, architecture, reusable doctrine, and operator docs. Inventory it
  before mutation.
- Same-repo workers need partitioned mutable and closeout surfaces or one named
  orchestrator integration step. Same-repo PRs merge one at a time; refresh and
  re-review a remaining head if the first merge changes it.
- Available capacity comes from the active control plane. Northstar must still
  work when no optional control plane is installed.
- A docs QA assertion was already changed on the planning base to validate the
  stable generation-index heading rather than stale no-work prose. Do not
  reintroduce the old assertion.
- Report through Paseo after the surface inventory and at PR-ready closeout.

## Suggested Next Move

Run the worker preflight, then read `AGENTS.md`, spec 026, milestone 042, card
110, and the directly linked doctrine and contracts. Build the before/after
surface inventory and scenario matrix before editing.

## Completion Protocol

### Before You Start

1. Run only `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. Accept a clean registered non-`main` launcher worktree as authoritative. Do
   not create another worktree or clean user changes.
3. Fetch origin with bounded non-interactive SSH. Confirm `HEAD == origin/main`,
   the planning base is an ancestor, and the tracked handoff matches this path.
4. Read the card and governing refs. Use Effigy for repository-owned work.

### While You Work

- Apply only settled card 110 meaning. Stop if a scheduler, provider, model,
  capacity number, or authority choice is still needed.
- Exercise every review-oracle scenario against the final wording and checks.
- Keep source/install surfaces aligned. Use a fast/low-cost subagent only for an
  exact mechanical documentation brief; retain semantic ownership and review.
- Stop on overlapping Northstar ownership, shared worker writes, or validation
  that changes the plan.

### When Complete

1. Run the required validation and `git diff --check` as one final batch.
2. Reconcile card, milestone, front doors, and a compact September closeout log.
3. Push the branch and open a PR to `main` with the scenario matrix, changed-
   surface parity, validation, limitations, and exact head.
4. Report through Paseo and wait. Do not merge.

### Review And Merge

The orchestrator reviews the exact PR head and publishes its verdict on the PR.
Changes requested wake this same worker on the same branch. An accepted current
head with passing checks and mergeability may be merged by the orchestrator
without another operator approval prompt.
