---
title: Remove embedded language quality payloads handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: implementation complete; PR 30 opened for exact-head review
owner: repo maintainers
created: 2026-09-03
updated: 2026-09-03
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260903-144604-remove-embedded-language-quality-payloads.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, language-packages]
---

## What This Thread Was Doing

Northstar extracted its TypeScript/Svelte and Rust quality systems into two
verified optional packages, proved both through real consumer canaries, and
added generic registry-owned discovery. Card 120 now removes the frozen copies
and migration fallbacks from the root skill.

This dispatches one bounded implementation lane. No transcript or second prompt
is part of the authority chain.

## Why It Matters

Northstar is a general-purpose core, not a bundle that grows with every
supported language. Removing the two embedded implementations proves that
language support can remain optional and independently installed without
breaking planning, orchestration, review, or existing consumer evidence.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `e93072a9e9beff10f315b2198cc708e92a51dee4`
- **Pushed main verification:** local `HEAD` and `origin/main` both equal the
  planning base before this handoff commit.
- **Planning checkout:** clean primary checkout at dispatch.
- **Worker mode:** implementation worker dispatched by the orchestrator; this
  handoff activates the worker-only worktree preflight.
- **Planning artifacts included at the base:** card 120 readiness and dispatch
  state, merge closeout for `g02.049/123`, and log
  `docs/logs/2026-09/03-144604-open-embedded-language-payload-removal.md`.
- **Worker branch:** `worker/remove-embedded-language-quality-payloads`
- **Worker worktree:** Paseo-managed dedicated worktree; accept the actual
  launcher path recorded by preflight.
- **Worktree creation command:** Paseo `branch-off` from pushed `main`, branch
  `worker/remove-embedded-language-quality-payloads`, slug
  `remove-embedded-language-quality-payloads`.
- **Worker worktree policy:** follow `Completion Protocol`; launcher worktree
  first, named/manual fallback only when required.
- **Required sibling worktree links:**
  - `northstar-language-packs`: source
    `/Users/tom/Dev/projects/northstar-language-packs`, destination
    `../northstar-language-packs` beside the worker worktree;
  - `convergence`: source `/Users/tom/Dev/projects/convergence`, destination
    `../convergence` beside the worker worktree;
  - `jetstream`: source `/Users/tom/Dev/projects/jetstream`, destination
    `../jetstream` beside the worker worktree.
  These siblings are read-only evidence sources. Never mutate them.
- **Active spec lane:** `docs/specs/034-modular-language-quality-packages.md`
- **Roadmap milestone:**
  `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`
- **Ready cards, in order:**
  `docs/roadmaps/g02/batch-cards/120-remove-embedded-language-quality-payloads.md`
- **Allowed runway:** card 120 only; remove the embedded payloads and close the
  modular-language-package extraction lane.
- **Remaining card budget:** one card; stop after its reviewable PR.
- **Dispatch topology:** sole launched lane; no other ready card owns these
  source, skill, checker, or closeout surfaces.
- **Parallel safety check:** no sibling implementation lane. The Sentrux note
  and any new language remain planning-only after this merge.
- **Surfaces this lane owns:** the frozen 95-file deletion inventory; the 19
  integration surfaces; card 120, milestone 048, spec 034 disposition, one
  closeout log, this handoff, and affected front doors/indexes.
- **Integration ownership:** worker owns the complete bounded closeout. The
  orchestrator owns exact-head review, merge, and installed-skill refresh.
- **Merge ordering:** same-repository PRs merge one at a time; the orchestrator
  refreshes this head against current `main` and re-reviews it if another merge
  changes the base.
- **Canonical refs:** `docs/architecture/system-architecture.md`;
  `docs/contracts/004-language-quality-pack.md`;
  `docs/specs/034-modular-language-quality-packages.md`.
- **Review oracle:** card 120's six rows plus the exact inventory in
  `docs/logs/2026-09/03-095021-refresh-embedded-removal-readiness.md`.
- **Model capability profile:** capable economical day-to-day implementation;
  broad deletion and proof work, but decisions and failure boundaries are
  settled.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** use Effigy selectors; no release or workflow
  mutations; do not update the live installed skill; use isolated copies for
  parity and core-only proofs; do not mutate sibling repositories.
- **Required validation:** card 120 oracle; exact negative inventory; isolated
  core-only install; missing-package containment; two-package installed route;
  accepted TypeScript and Rust package/consumer proofs; isolated skill-install
  parity; `effigy check:command-skills`; `effigy check:language-packages`;
  `effigy qa:docs`; `effigy qa`; `git diff --check`.
- **PR base/head:** `main` <- `worker/remove-embedded-language-quality-payloads`
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/30
- **Review state:** implementation complete. Three commits after base
  `57dab4d`: `380d20b` (removal + generic rewiring + replacement routes
  proof), `9c8fe2f` (closeout docs), `d4e0dc4` (handoff PR record), plus the
  last handoff bookkeeping commit. Review the exact pushed PR head. All
  required validation passed on the working tree of this branch, including
  the six-row card oracle falsified in
  `docs/logs/2026-09/03-154324-remove-embedded-language-quality-payloads.md`.
  Awaiting exact-head review and merge by the orchestrator; installed-skill
  refresh follows merge.
- **Merge path:** orchestrator after accepted review of the current head and
  passing required checks.

## Boundaries

- **In scope:** card 120 only, including the exact removal inventory, generic
  replacement wiring, integration proof, and lane closeout.
- **Out of scope:** new language support, Sentrux integration, package-policy
  changes, edits to `northstar-language-packs`, Convergence, or Jetstream,
  compatibility aliases, indefinite fallbacks, release changes, card 123.
- **Outcome shape:** smallest complete deletion that leaves generic core-only
  and installed-package workflows honest and proven.
- Do not invent architecture, change contracts, widen the roadmap, or choose an
  unresolved product, trust, runtime, or package-policy decision.
- Work only in the clean launcher worktree. Never edit the planning checkout or
  any sibling checkout.
- Do not merge. The orchestrator owns exact-head review and merge.

## Important Context

- **Planning lineage:** cards 116-119 froze the contracts, proved the generic
  lifecycle, shipped TypeScript and Rust packages, and passed Jetstream and
  Convergence canaries. Card 122 removed the last language-specific discovery
  dependency. Card 123 then fixed Paseo worker parentage and merged as
  `7ebaa9c`.
- **Why this card is ready:** every ready-state checkbox is satisfied; the
  95-file deletion set and 19 integration surfaces are frozen; both packages
  and consumers passed overlap-close proof; the generic selector is merged.
- **Decisions and preferences:** delete embedded implementations and bounded
  fallback together. Preserve generic discovery, registry, trust, lifecycle,
  receipts, host protocol, and routing. Visible missing-package stop is valid;
  silent fallback or compatibility alias is not.
- **Open tensions:** the root must remain useful with no language package, and
  pre-removal consumer evidence must remain readable without rewriting consumer
  policy. Stop if either requires redesign rather than bounded removal.
- **Report after:** the deletion and generic rewiring are coherent, then after
  integration proof and PR creation; report any stop condition immediately.
- **Report to:** the originating orchestrator through Paseo finish notification.

## Suggested Next Move

Run the `Completion Protocol` preflight. Read `AGENTS.md`, card 120, milestone
048, spec 034, contract 004, architecture, and both readiness/dispatch logs.
Reproduce the frozen inventory before deletion, then implement the smallest
coherent removal and replacement proof.

## Completion Protocol

### Before you start

1. This handoff's `worker_mode: implementation` and
   `dispatch_authority: orchestrator` activate worker mode. Before broad reads,
   run `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. Accept a clean registered non-`main` launcher worktree regardless of its
   generated path or branch spelling. Record it and do not create another.
3. If the launcher context is dirty, `main`, unregistered, or unusable, report
   it. Only the documented `.agents.local.env` fallback may create a
   replacement; never use `/tmp`, guess a path, or discard existing state.
4. Fetch origin with bounded non-interactive SSH. Confirm `HEAD == origin/main`,
   confirm `e93072a9e9beff10f315b2198cc708e92a51dee4` is an ancestor, and load
   this handoff from the selected `HEAD`. Stop if the absolute file differs
   from the tracked blob.
5. Verify all three required sibling links in the worktree container directory
   before using them. Reuse only correct symlinks to the declared sources. Stop
   on absence, mismatch, a directory/file collision, or missing source. Never
   delete, replace, overwrite, or mutate a sibling.
6. Read the assigned card and canonical refs. Use the frozen inventory as the
   deletion boundary and record cheap orientation evidence.

### While you work

- Execute card 120 only; keep commits aligned with meaningful chunks.
- Preserve generic package behavior and remove every embedded or fallback
  implementation in the frozen inventory. Do not replace deleted paths with
  aliases, shims, or silent fallbacks.
- Use isolated installed-skill copies and temporary consumer fixtures. Never
  sync the live `/Users/tom/.agents/skills/northstar` directory from this lane.
- Treat all three sibling repositories as read-only evidence sources.
- Stop on a missing contract, hidden language dependency requiring redesign,
  consumer evidence incompatibility, or validation result that changes the
  plan.

### When the assigned runway is complete

1. Run every required validation named above.
2. Falsify all six card-oracle rows, including an exact post-delete inventory,
   core-only operation, scoped missing-package stop, both installed routes,
   consumer evidence preservation, and rejection of compatibility theatre.
3. Reconcile card 120, milestone 048, spec 034, one closeout log, this handoff,
   and all affected front doors. Remove resolved triage only if its disposition
   is fully settled; leave the Sentrux note open for the operator checkpoint.
4. Integrate current `main` if it moved, rerun validation, push the worker
   branch, and open a reviewable PR against `main`.
5. Link the card, milestone, spec, inventory, changed surfaces, proof, validation,
   and unresolved limits. Report the PR URL and exact tested head through the
   finish notification. Do not merge.

### Review and merge path

The orchestrator independently reviews the exact PR head. Blocking findings use
`execution-miss`, `oracle-gap`, `planning-change`, `validation-gap`, or
`integration-drift`. Requested changes return to this same child agent and
branch. Accepted current-head review plus passing checks and mergeability lets
the orchestrator merge without another operator prompt.

- **Closeout refs:** card 120, milestone 048, spec 034, one dated log, this
  handoff, `docs/README.md`, roadmap front doors, generation index, contract
  index, and any affected skill/operator documentation.

### Handoff closeout

Keep the lane state honest. On a stop condition, record the blocker and pause.
Do not start Sentrux or another language package from this worker.
