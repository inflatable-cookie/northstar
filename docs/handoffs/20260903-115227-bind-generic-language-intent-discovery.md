---
title: Generic language intent discovery worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: complete
owner: repo maintainers
created: 2026-09-03
updated: 2026-09-03
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260903-115227-bind-generic-language-intent-discovery.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr]
---

## What This Thread Was Doing

Northstar extracted and canary-proved its TypeScript and Rust quality packages.
Card 120's pre-deletion inventory then found that core still selects those
packages through language-specific router branches. Card 122 is the bounded
prerequisite that replaces that hidden dependency with generic discovery.

This dispatches one bounded implementation lane. No transcript or second prompt
is part of the authority chain.

## Why It Matters

Deleting the embedded branches now would strand missing-package requests and
existing activation markers. Generic, registry-owned selection lets Northstar
remain general-purpose as more optional language packages appear without
teaching core each package name.

## Current State

Here is the state the worker is inheriting:

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `de6a6bf86fafca260d08d3cd2ba1d7cd4f6c29e2`
- **Pushed main verification:** local `HEAD` and `origin/main` both resolved to
  `de6a6bf86fafca260d08d3cd2ba1d7cd4f6c29e2` before this handoff was written.
- **Planning checkout:** clean before this handoff; the handoff will be committed
  and pushed before launch.
- **Worker mode:** implementation worker dispatched by the orchestrator; this
  handoff activates the worker-only worktree preflight.
- **Planning artifacts included at the base:** card 122, card 120's blocked
  readiness state, milestone `g02.048`, and the exact removal inventory log.
- **Worker branch:** `worker/bind-generic-language-intent-discovery`
- **Worker worktree:** Paseo-managed worktree; use the actual launcher path.
- **Worktree creation command:** Paseo `branch-off` from pushed `origin/main`.
- **Worker worktree policy:** follow `Completion Protocol`; launcher worktree
  first, named/manual fallback only when required.
- **Required sibling worktree links:** none.
- **Active spec lane:** `docs/specs/034-modular-language-quality-packages.md`
- **Roadmap milestone:** `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`
- **Ready cards, in order:** `docs/roadmaps/g02/batch-cards/122-bind-generic-language-intent-discovery.md`
- **Allowed runway:** card 122 only.
- **Remaining card budget:** one card.
- **Dispatch topology:** sole ready lane. Card 120 is serial behind this lane's
  reviewed merge and readiness refresh.
- **Parallel safety check:** no other ready Northstar worker lane was found.
- **Surfaces this lane owns:** registry schema/data, package lifecycle/discovery
  code and fixtures, generic router integration, package checks, card 122,
  milestone 048, one dated closeout log, this handoff, and affected Northstar
  front doors.
- **Integration ownership:** this worker owns its bounded closeout. It must leave
  card 120 blocked and must not perform embedded deletion.
- **Merge ordering:** same-repository PRs merge one at a time; the orchestrator
  refreshes this head against current `main` and re-reviews it if a sibling lane
  merges first.
- **Canonical refs:** `docs/architecture/system-architecture.md`;
  `docs/contracts/004-language-quality-pack.md`;
  `docs/specs/034-modular-language-quality-packages.md`.
- **Review oracle:** card 122 `## Review Oracle`.
- **Model capability profile:** ordinary bounded implementation; choose the
  cheapest adequate non-frontier day-to-day profile and retain material review
  in the orchestrator.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** no `.github/workflows/` or release mutation;
  no package-policy, trust, language, fallback, or embedded-payload change.
- **Required validation:** `effigy check:language-packages`, isolated
  `effigy check:skill-install skills/northstar`, `effigy qa:docs`, `effigy qa`,
  and `git diff --check`.
- **PR base/head:** `main` <- `worker/bind-generic-language-intent-discovery`.
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/28
  (validation exact head `91d953acfe5290dd58325f81c4c06e57feb00a7e` after
  round-1 review repairs; handoff-state-only commits may advance the tip
  beyond it without touching code, schemas, registry, or fixtures).
- **Review state:** accepted at exact head `183b55b`; PR 28 squash-merged as
  `ddaae0d` after focused and full QA passed. Card 120 passed its post-merge
  readiness refresh.
- **Merge path:** orchestrator after accepted review of the current head and
  passing required checks.

## Boundaries

Please keep this run inside the named runway:

- **In scope:** implement card 122's registry-owned, package-neutral selection
  for explicit intent and existing activation, including its schemas, fixtures,
  integration, negative proofs, and closeout.
- **Out of scope:** card 120 deletion; overlap-window removal; edits to either
  language package; new languages; package rule or workflow changes; broader
  trust; source-detection acquisition; Sentrux work.
- **Outcome shape:** smallest complete contract-valid implementation, validation,
  adversarial evidence, and reviewable PR.
- Do not invent architecture, change contracts, widen the roadmap, or choose an
  unresolved product/API/persistence/security decision.
- This handoff represents one worker lane. Write only inside **Surfaces this
  lane owns**. If shared mutable scope or a hidden dependency appears, stop and
  report it instead of widening the lane.
- Work only in the clean worker worktree selected by `Completion Protocol`.
  Never edit the planning checkout or an unrelated dirty checkout.
- Do not merge the PR. Merge belongs to the orchestrator after its accepted
  review/check gate.

## Important Context

- **Planning lineage:** contract 004 and spec 034 already require a generic
  language-package route. Cards 116-119 proved machine contracts, lifecycle,
  both official packages, and consumer canaries. The 2026-09-03 readiness log
  freezes the removal surface and identifies the remaining selection seam.
- **Why this card is ready:** identity, trust, lifecycle, workflow names,
  activation preservation, failure behavior, scope, and seven adversarial
  review rows are settled. No operator choice remains.
- **Decisions and preferences:** discovery metadata is data, not trust;
  detection never acquires; exactly one compatible match is required; current
  activation markers remain valid without consumer rewrites; bounded fallback
  stays until card 120.
- **Open tensions:** registry metadata must agree with the verified manifest
  without duplicating package policy; preserve current installed/offline and
  revocation behavior while removing all selection-code package names.
- **Report after:** generic selector and its negative oracle are working, or an
  earlier planning/contract stop is found.
- **Report to:** the operator, who will relay progress to the orchestrator.

## Suggested Next Move

Run the `Completion Protocol` preflight before broad reads. Then read
`AGENTS.md`, milestone 048, card 122, spec 034, contract 004, and the removal
readiness log. Reproduce the current package-specific selection seam before
editing. Implement the generic selector and falsify every review-oracle row.

## Completion Protocol

### Before you start

1. This handoff's `worker_mode: implementation` and
   `dispatch_authority: orchestrator` activate worker mode. Before broad reads,
   run `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. If the current root is a registered worktree, its status is empty, and its
   branch is not `main`, accept it as the launcher-provided worktree. Record its
   actual root/branch; do not compare its generated path/branch with the planned
   values or create another worktree merely because they differ.
3. If current context is `main`, dirty, unregistered, or unusable, inspect the
   named worktree. If unusable, read `.agents.local.env`, require
   `AGENTS_WORKTREE_CONTAINER_DIR`, and ask the operator when absent. Create a
   unique worktree/branch there from pushed `origin/main`. Never use `/tmp`,
   `TMPDIR`, or a guessed path; never clean, reset, stash-over, or discard dirty
   state. Report a launcher-supplied dirty or `main` worktree instead of creating
   another.
4. From the selected worktree, record this handoff's repository-relative path.
   Run `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`.
   Confirm `HEAD == origin/main`, confirm
   `git merge-base --is-ancestor de6a6bf86fafca260d08d3cd2ba1d7cd4f6c29e2 HEAD`,
   and confirm the relative handoff exists in `HEAD`. Load it with `git show`.
   If the absolute dispatch file differs from that tracked blob, stop. The
   committed `HEAD` copy is canonical.
5. Required sibling links are `none`; skip sibling-link creation.
6. Read the active milestone, card 122, `AGENTS.md`, and canonical refs.
7. Run the repo's cheap orientation checks and record what you actually ran.

### While you work

- Execute card 122 only and keep commits aligned with meaningful chunks.
- Use bounded causal and code-level judgment inside the card. Stop if the
  implementation needs a package-specific branch, consumer rewrite, manifest
  change, trust change, or new policy.
- Report meaningful progress, validation, remaining work, and blockers through
  the active control plane or operator.
- Do not quietly turn an open question into a new architecture.

### When the assigned runway is complete

1. Run `effigy check:language-packages`, isolated
   `effigy check:skill-install skills/northstar`, `effigy qa:docs`, `effigy qa`,
   and `git diff --check`.
2. Falsify all seven card-oracle rows. Enumerate exact/universal/negative claims
   and reconcile card 122, milestone 048, one dated log, this handoff, and front
   doors. Keep card 120 blocked.
3. Push the selected worker branch. If another same-repo lane merged first,
   integrate current `main`, rerun validation, and report the changed head.
4. Open a reviewable PR against current `main`. Link the spec, milestone, card,
   changed surfaces, oracle evidence, validation, and unresolved items.
5. Report the PR URL and exact tested head. Do not merge or start card 120.

### Review and merge path

The orchestrator reviews the exact PR head independently. If changes are
requested, repair only the classified in-bounds findings on this branch, push,
and report a new exact head. A `planning-change` returns to planning first.
When the reviewed head is current, required checks pass, the PR is mergeable,
and no stricter rule or operator pause applies, the orchestrator merges without
another approval prompt.

- **Requested changes:** none.
- **Closeout refs:** card 122, milestone 048, this handoff, one dated log, and
  affected Northstar front doors. Card 120 remains blocked.

### Handoff closeout

Before calling the runway complete, leave the card, roadmap, log, handoff, and
next-task state honest. If blocked, record the blocker and stop rather than
making the handoff look complete.
