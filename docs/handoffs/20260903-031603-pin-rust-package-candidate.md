---
title: Pin Rust package candidate worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-09-03
updated: 2026-09-03
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260903-031603-pin-rust-package-candidate.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, language-quality]
---

## What This Thread Was Doing

Northstar is extracting language-quality implementations from the root skill.
The Rust source package is accepted. This worker owns the next serial step:
pin and prove that immutable package through Northstar core, then stop before
the real Convergence consumer canary.

## Why It Matters

Root reduction is unsafe until the accepted Rust package can be acquired,
verified, routed offline, rolled back, and visibly fall back during the bounded
overlap without loading the TypeScript package or changing consumer authority.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `d4dd8215c2b81b300a22de7fc2abb09e1cfd64bd`
- **Pushed main verification:** worker must start from the pushed commit that
  contains this handoff and confirm `HEAD == origin/main`.
- **Planning checkout:** clean at dispatch.
- **Worker mode:** implementation worker dispatched by the orchestrator.
- **Planning artifacts included at the base:** card `g02.048/119`, milestone
  `g02.048`, current front doors, and this handoff.
- **Worker branch:** `worker/pin-rust-package-candidate`
- **Worker worktree:** Paseo launcher-owned worktree.
- **Worktree creation command:** Paseo `branch-off` from `origin/main`.
- **Worker worktree policy:** launcher worktree first; never create a second.
- **Required sibling worktree links:** `northstar-language-packs` from
  `/Users/tom/Dev/projects/northstar-language-packs`, beside this worktree.
- **Active spec lane:** `docs/specs/034-modular-language-quality-packages.md`
- **Roadmap milestone:** `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`
- **Ready cards, in order:** registry/proof step of `g02.048/119` only.
- **Allowed runway:** official Rust pin, lifecycle/routing/fallback proof,
  closeout, review-only PR.
- **Remaining card budget:** one serial step; stop before Convergence.
- **Dispatch topology:** sole ready lane.
- **Parallel safety check:** Convergence consumes this merged registry state.
- **Surfaces this lane owns:** registry/package protocol fixtures and checks,
  installed Rust route/fallback surfaces, card 119, milestone 048, one dated
  log, this handoff, and affected front doors.
- **Integration ownership:** this worker reconciles its own bounded closeout.
- **Merge ordering:** orchestrator exact-head review, then merge.
- **Canonical refs:** `docs/architecture/system-architecture.md`;
  `docs/contracts/004-language-quality-pack.md`;
  `docs/specs/034-modular-language-quality-packages.md`.
- **Review oracle:** card 119, especially package independence, engine source
  identity, evidence compatibility, and visible bounded fallback.
- **Model capability profile:** day-to-day implementation; planning is settled,
  but the exact identity and lifecycle negatives need careful execution.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** do not edit the package-source sibling; do not
  remove embedded payloads; no release or CI mutation.
- **Required validation:** `effigy check:language-packages`, isolated
  `effigy check:skill-install skills/northstar`, `effigy qa:docs`, `effigy qa`,
  `git diff --check`.
- **PR base/head:** `main` <- `worker/pin-rust-package-candidate`.
- **PR URL:** pending.
- **Review state:** implementation pending.
- **Merge path:** orchestrator after accepted current-head review and checks.

## Boundaries

- **In scope:** add the official `@northstar/rust-quality` `0.1.0` pin for
  accepted merge `56b2e1107b80f369807cff88e1b0253df035c700`, raw tree
  `sha256:e5cf9c5da4a30c0f5164f2ea0c5e9d87d544c0c32f09f3c139a386c56154dba0`,
  and manifest
  `sha256:dd71d04efd67cc7805f417a79666dd920ea1811ee252d941108dfbeca8aab612`;
  independently reproduce them before trust; prove acquisition, installed and
  offline routing, rollback, drift rejection, Rust-only retained inventory,
  source-payload engine integrity, and exact visible fallback during overlap.
- **Out of scope:** Convergence edits or canary execution, root embedded-payload
  deletion, TypeScript identity/policy changes, Rust rules, engine lifecycle,
  MSRV authority, release, and CI.
- **Outcome shape:** complete registry/routing proof and review-only PR.
- Keep detection non-authoritative. Keep host failure distinct from the core
  fallback decision. Do not make the package source repo a runtime dependency.
- Do not merge the PR.

## Important Context

- **Planning lineage:** cards 116-118 established the generic lifecycle and
  TypeScript canary; card 121 repinned its standalone adapter; package PR 4 is
  the accepted Rust source candidate.
- **Why ready:** source identity, package QA, adapted-source parity, package-only
  tool bootstrap, and pre/post-extraction v2 ledger compatibility passed review.
- **Decisions:** preserve the embedded Rust payload only as a bounded, visible
  overlap fallback. Do not install or load TypeScript while proving Rust.
- **Open tensions:** the existing fallback machinery was first exercised by
  TypeScript; extend generic identity handling without introducing a language
  switch or weakening its request/result correlation.
- **Report after:** PR opened with exact head and all oracle evidence.
- **Report to:** the originating orchestrator through Paseo.

## Suggested Next Move

Run worker preflight, read the card and canonical refs, materialize accepted
merge `56b2e11` read-only, and independently reproduce both digests before
changing the registry.

## Completion Protocol

### Before you start

Verify the launcher worktree is clean, registered, non-`main`, and based on
pushed `origin/main`; verify this committed handoff; verify the declared
`northstar-language-packs` sibling symlink resolves to its primary checkout.
Then read `AGENTS.md`, card 119, milestone 048, contract 004, spec 034, and the
current language-package checker/lifecycle/fallback surfaces.

### While you work

Keep all acquisition trust and lifecycle behavior generic. Stop for planning
if the accepted contracts cannot express the Rust package without a
language-specific core branch, a new consumer prerequisite, or changed package
policy/evidence semantics. Record small recurring friction in `PAPERCUTS.md`
without widening this lane.

### When the assigned runway is complete

Run every required validation command. Falsify each card oracle and the exact
pin: wrong commit/tree/manifest, detection-only request, installed drift,
offline route, rollback, overlap failure/notice, TypeScript contamination, and
engine source mismatch. Reconcile card, milestone, dated log, handoff, and front
doors. Commit, push, and open a review-only PR against current `main`. Report
the URL and exact tested head. Do not merge or start Convergence.

### Review and merge path

The orchestrator reviews the complete diff and current head. Address every
posted finding on this same branch and notify the orchestrator when ready.
Accepted current head plus required checks and mergeability permits the
orchestrator to merge without another operator prompt.

### Handoff closeout

Leave card 119 active with registry proof recorded and the Convergence canary
as the next serial step. Card 120 remains blocked.
