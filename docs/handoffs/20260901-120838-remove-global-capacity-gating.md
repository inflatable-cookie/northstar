---
title: Remove global capacity gating worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: awaiting-review
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-120838-remove-global-capacity-gating.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, orchestration]
---

## What This Thread Was Doing

The operator found that Northstar's parallel-first protocol was stopping all
new launches after one provider/profile refusal. Planning now distinguishes an
unlimited ready-frontier scheduler from lane-local provider and transport state.

This dispatches one bounded implementation lane. No transcript or second prompt
is part of the authority chain.

## Why It Matters

The current rule turned a single provider spend limit into global serialization
and reduced live orchestrator activity from roughly six-to-ten threads to three.
Northstar should keep unrelated ready work moving while preserving each failed
lane's authority chain and avoiding duplicate agents.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `97ea0376203f4a39bd2f168cafb98f82fb68821e`
- **Pushed main verification:** orchestrator will verify local `HEAD == origin/main`
  after committing this handoff and planning batch, before dispatch.
- **Planning checkout:** clean before this planning batch; worker must not edit it.
- **Worker mode:** implementation worker dispatched by the orchestrator; this
  handoff activates the worker-only worktree preflight.
- **Planning artifacts included at the base:** spec 026 correction,
  `g02.044`, card 112, this handoff, and live dogfood evidence.
- **Worker branch:** `worker/remove-global-capacity-gating`
- **Worker worktree:** Paseo-managed worktree; actual launcher path is authoritative.
- **Worktree creation command:** Paseo `branch-off` from pushed `origin/main`.
- **Worker worktree policy:** follow `Completion Protocol`; launcher worktree
  first, named/manual fallback only when required.
- **Required sibling worktree links:** none.
- **Active spec lane:** `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
- **Roadmap milestone:** `docs/roadmaps/g02/044-remove-global-capacity-gating.md`
- **Ready cards, in order:** `docs/roadmaps/g02/batch-cards/112-remove-global-capacity-gating.md`
- **Allowed runway:** card 112 only.
- **Remaining card budget:** one card.
- **Dispatch topology:** one Northstar implementation lane; consumer dogfood
  jobs remain passive evidence and are not worker dependencies.
- **Parallel safety check:** no other Northstar worker owns these protocol
  surfaces; live consumer orchestrators are outside this repository write scope.
- **Surfaces this lane owns:** live architecture/contract/spec-compatible
  wording, reusable doctrine, installable skill source, copy-ready contract,
  operator guidance, protocol-kernel routing, deterministic repo-contract data,
  milestone/card closeout, one dated log, and Northstar front-door currentness.
- **Integration ownership:** this worker owns its complete closeout; preserve the
  live dogfood triage buffer except for a factual link to this correction if needed.
- **Merge ordering:** same-repository PRs merge one at a time; the orchestrator
  refreshes this head against current `main` and re-reviews it if another lane
  merges first.
- **Canonical refs:** `docs/architecture/system-architecture.md`;
  `docs/contracts/001-working-rules.md`;
  `bundle-docs/sections/07-delivery-framework-and-autonomy.md`.
- **Review oracle:** milestone `g02.044`, all seven rows.
- **Model capability profile:** matching non-frontier day-to-day implementation
  profile selected from current Paseo profile notes.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** do not edit `.github/workflows/`, modify Paseo
  configuration, mutate installed profiles, or rewrite frozen historical logs
  and handoffs.
- **Required validation:** `effigy check:command-skills`; isolated
  `effigy check:skill-install`; `effigy qa:docs`; `effigy qa`;
  `git diff --check`.
- **PR base/head:** `main` <- `worker/remove-global-capacity-gating`.
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/17.
- **Review state:** worker implementation complete; awaiting exact-head review.
- **Merge path:** orchestrator after accepted review of the current head and
  passing required checks.

## Boundaries

Please keep this run inside card 112.

- **In scope:** propagate the spec 026 decision across the live reusable
  orchestrator surfaces, checks, parity, and closeout.
- **Out of scope:** scheduler redesign, Paseo changes, local profile changes,
  provider-specific constants, mid-run agent replacement, or weaker serial and
  review gates.
- **Outcome shape:** implementation. Inventory the old global-capacity clauses,
  replace them coherently, add falsification checks, validate, evidence, and
  open the PR.
- Do not invent architecture, change the settled rule, widen the roadmap, or
  choose provider-specific behavior.
- Work only in the clean worker worktree selected by `Completion Protocol`.
- Do not merge the PR. Merge belongs to the orchestrator after review and checks.

## Important Context

- **Planning lineage:** g02.042 made scheduling parallel-first; g02.043 made
  worker routing economical. This correction removes the accidental global-slot
  interpretation without undoing either result.
- **Why this card is ready:** the operator supplied the missing runtime fact and
  approved the correction; spec 026 and milestone 044 settle the semantics.
- **Decisions and preferences:** launch every safe lane; route provider failures
  locally; try a capability-equivalent profile; never spend frontier only for
  availability; pause only the lane when no fit remains.
- **Open tensions:** transport creation may return an identity before failure.
  Preserve it and fail closed against duplicate retry while continuing lanes
  whose state is unambiguous.
- **Report after:** the full propagation and validation batch, or immediately on
  a stop condition.
- **Report to:** the operator through Paseo; the orchestrator retains review.

## Suggested Next Move

Run the worker preflight, read milestone 044, card 112, spec 026, and the current
parallel-scheduling surfaces. Inventory exact old wording with `rg`, then apply
one coherent propagation batch and falsify all seven oracle rows.

## Completion Protocol

Before broad reads, run `git rev-parse --show-toplevel`,
`git branch --show-current`, `git status --porcelain`, and
`git worktree list --porcelain`. Reuse a clean registered non-`main`
launcher worktree. Do not create another because its generated path or branch
differs from this handoff. If the launcher context is dirty, on `main`, or
unregistered, stop and report it; use the repository's configured manual
fallback only when the handoff contract permits it. Never clean or discard
another checkout.

Fetch `origin` with the bounded SSH command from the installed worker protocol.
Confirm selected `HEAD == origin/main`, the planning base above is an ancestor,
and this repository-relative handoff exists in `HEAD`. Load that tracked blob;
if the absolute dispatch file differs, stop. Required sibling links are `none`.

Execute only card 112. Preserve historical evidence of the superseded rule.
Before PR creation, inventory universal, exact, and negative claims; exercise
all seven oracle rows; reconcile card, milestone, log, handoff, and front doors;
then run the required validation. Push the worker branch and open a PR against
current `main` with the exact head, evidence, checks, and unresolved items.
Do not merge.

If review requests changes, stay on this branch, repair only the posted findings,
revalidate, push, and notify the orchestrator. A planning change returns to the
orchestrator before revision. The orchestrator may merge an accepted current
head after required checks pass and mergeability is clear, without another
operator prompt.

- **Closeout refs:** card 112, milestone 044, one dated log, `docs/README.md`,
  roadmap front doors, generation index, and skill-install parity evidence.
