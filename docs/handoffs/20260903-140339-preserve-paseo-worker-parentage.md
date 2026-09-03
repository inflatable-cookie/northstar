---
title: Preserve Paseo worker parentage handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: awaiting-review
owner: repo maintainers
created: 2026-09-03
updated: 2026-09-03
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260903-140339-preserve-paseo-worker-parentage.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, paseo]
---

## What This Thread Was Doing

The operator reported that Paseo-backed orchestrators sometimes create workers
as detached root threads. Those workers get their own workspace but their
originating orchestrator receives no completion notification. Northstar now
has a ready card to bind dedicated workspace placement to child-agent creation.

This dispatches one bounded implementation lane. No transcript or second prompt
is part of the authority chain.

## Why It Matters

The worker/PR loop depends on the orchestrator receiving finish, error, and
permission events and resuming the same worker after requested changes. Paseo
already supports a child agent in another workspace; Northstar needs to prevent
orchestrators from substituting a detached top-level launch.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `f3f183518fe0dc70647f97b31e93ed944116d340`
- **Pushed main verification:** local `HEAD` and `origin/main` matched the full
  planning base before this handoff was written.
- **Planning checkout:** clean before this handoff; commit and push this file
  before launch.
- **Worker mode:** implementation worker dispatched by the orchestrator; this
  handoff activates the worker-only worktree preflight.
- **Planning artifacts at the base:** updated spec 026, milestone `g02.049`,
  card 123, planning log, and front-door state.
- **Worker branch:** `worker/preserve-paseo-worker-parentage`
- **Worker worktree:** Paseo-managed dedicated worktree at
  `/Users/tom/.paseo/worktrees/37pj4ag8/preserve-paseo-worker-parentage` (workspace `wks_0ac25c3a34f16567`).
- **Live launch record:** workspace `wks_0ac25c3a34f16567` created first;
  child agent `3b92a429-64ec-4d31-a85b-bd97fd5b49d2` created from orchestrator
  scope with `notifyOnFinish: true`; status snapshot records parent label
  `paseo.parent-agent-id=ea5b027e-e772-4209-861a-25aa8d12ca29`.
- **Worktree creation:** Paseo `branch-off` from pushed `origin/main`.
- **Required sibling worktree links:** none.
- **Active spec lane:** `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
- **Roadmap milestone:** `docs/roadmaps/g02/049-preserve-paseo-worker-parentage.md`
- **Ready cards:** `docs/roadmaps/g02/batch-cards/123-preserve-paseo-worker-parentage.md`
- **Allowed runway:** card 123 only; one card (complete).
- **Dispatch topology:** sole launched lane. Card 120 remains ready but serial
  behind this lane because both own the skill payload and closeout surfaces.
- **Surfaces this lane owns:** working rules, reusable doctrine, copy-ready
  working-rules template, installable Northstar skill/orchestrator mode,
  operator guidance, protocol-kernel routing where needed, focused assertions,
  card 123, milestone 049, one closeout log, this handoff, and affected front
  doors.
- **Integration ownership:** this worker owns its bounded closeout; do not edit
  or start card 120.
- **Canonical refs:** `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`;
  `docs/contracts/001-working-rules.md`;
  `bundle-docs/sections/07-delivery-framework-and-autonomy.md`.
- **Review oracle:** milestone 049's six rows (all 6 rows falsified).
- **Model capability profile:** bounded documentation/skill propagation with
  deterministic checks; choose a cheap adequate non-frontier profile.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** no Paseo product/CLI changes, no
  `.github/workflows/`, release mutation, browser/computer-use, provider/model
  policy change, language-package change, or card-120 work.
- **Required validation:** `effigy check:worker-parentage`,
  `effigy check:command-skills`, isolated
  `effigy check:skill-install skills/northstar`, `effigy qa:docs`, `effigy qa`,
  and `git diff --check`.
- **PR base/head:** `main` <- `worker/preserve-paseo-worker-parentage`.
- **PR URL:** pending.
- **Review state:** implementation complete; awaiting orchestrator exact-head review.
- **Merge path:** orchestrator after accepted review of the exact current head
  and passing required checks.

## Boundaries

- **In scope:** implement card 123's scoped cross-workspace child-agent rule,
  six-row proof, installed parity, closeout, and reviewable PR.
- **Out of scope:** Paseo code or CLI changes; generic notification services;
  shared worker workspaces; polling; provider/model changes; card 120; language
  packages; Sentrux; weaker worktree, review, or merge boundaries.
- **Outcome shape:** smallest complete contract-valid propagation and proof.
- Do not invent a parent override or undocumented CLI capability. The settled
  sequence is `create_workspace`, then the current orchestrator's agent-scoped
  `create_agent` with that returned workspace ID and finish notifications on.
- Write only the owned surfaces. Stop on overlapping work or a required Paseo
  product change.
- Work only in the clean launcher worktree. Do not edit the planning checkout.
- Do not merge. The orchestrator owns exact-head review and merge.

## Important Context

- **Planning lineage:** optional Paseo transport landed in `g02.036`; implicit
  use, worktree lifecycle, parallel scheduling, capacity correction, and model
  diversification followed. This change corrects transport ownership without
  changing those policies.
- **Why ready:** the operator supplied the live failure, the Paseo reference
  confirms cross-workspace children, and spec 026 now settles the full sequence
  and detached-launch rejection.
- **Decisions:** workspace placement and agent parentage are separate; a worker
  needs both isolation and parent ownership; manual dispatch stays valid only
  when the scoped tools are absent.
- **Open tension:** focused tests must discriminate creation sequence and
  invalid launch shapes without reverting to broad prose coupling.
- **Report after:** the reusable surfaces and six-row oracle are complete, or a
  documented Paseo capability mismatch stops the lane.
- **Report to:** the originating orchestrator through Paseo finish notification.

## Suggested Next Move

Run the worker preflight, then read `AGENTS.md`, spec 026, milestone 049, card
123, working rules, doctrine 07, and the current command-skill checker. Inventory
the existing dispatch wording before editing. Propagate the smallest coherent
rule and make the negative proof distinguish a detached launch.

## Completion Protocol

### Before you start

1. This handoff's worker metadata activates worker mode. Before broad reads,
   run `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. Accept a clean registered non-`main` launcher worktree regardless of its
   generated path or branch spelling. Record it and do not create another.
3. If the launcher context is dirty, `main`, unregistered, or unusable, report
   it. Only the documented `.agents.local.env` manual fallback may create a
   replacement; never use `/tmp`, guess a path, or clean existing state.
4. Fetch origin with the bounded SSH settings. Confirm `HEAD == origin/main`,
   confirm planning base `f3f183518fe0dc70647f97b31e93ed944116d340` is an
   ancestor, and load this handoff from the selected `HEAD`. Stop if the
   absolute file differs from the tracked blob.
5. Required sibling links are `none`.
6. Read the card, milestone, spec, `AGENTS.md`, and canonical refs before edits.

### While you work

- Execute card 123 only. Preserve the distinction between a separate workspace
  and a child agent created from the orchestrator scope.
- Keep the manual/provider-neutral fallback. Do not claim an unproven CLI path
  preserves parentage.
- Use focused assertions that fail for a root launch or disabled finish
  notification without policing unrelated editorial wording.
- Report a Paseo capability contradiction, scope expansion, or validation result
  that changes the plan instead of inventing behavior.

### When the assigned runway is complete

1. Run the required validation listed above.
2. Falsify every milestone-049 review row. Reconcile card 123, milestone 049,
   one dated log, this handoff, and affected front doors. Leave card 120 ready
   but not started.
3. Push the worker branch and open a PR against current `main`. If main moved,
   integrate it first and revalidate.
4. Link the spec, milestone, card, changed surfaces, oracle evidence,
   validation, live child-workspace launch record, and any limits.
5. Report the PR URL and exact tested head through the finish notification. Do
   not merge.

### Review and merge path

The orchestrator independently reviews the PR and records its verdict on the
provider surface. If changes are requested, it resumes this same child agent;
do not create a replacement worker. Blocking findings use `execution-miss`,
`oracle-gap`, `planning-change`, `validation-gap`, or `integration-drift`.
Accepted exact-head review plus passing checks and mergeability authorizes the
orchestrator to merge without another prompt.

- **Closeout refs:** card 123, milestone 049, one dated log, this handoff,
  `docs/README.md`, roadmap front doors, generation index, and contract index.

### Handoff closeout

Keep the lane state honest. On a blocker, record it and stop. Do not claim card
123 complete or start card 120 without an accepted reviewed merge.
