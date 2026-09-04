---
title: Implement Chatterbox-led planning
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Northstar orchestrator
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-110043-implement-chatterbox-led-planning.md
base_required: pushed-main
tags: [coordination, handoff, worker, card-128]
---

## What This Thread Was Doing

Dispatch the sole approved ready frontier `g02.053/128` directly to one
economical implementation worker. This is a mechanical overlay on the already
promoted canonical plan; it does not recompile planning or create a promotion
worker, planning delegate, or planning PR.

## Why It Matters

Card 128 implements the promoted Chatterbox-led planning topology: Chatterbox
owns canonical planning and the approved frontier, while the coordinator
performs factual preflight, dispatch, identity tracking, exact-head review
leases, merge gating, and closeout.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `8531f16`
- **Pushed main verification:** local `HEAD` equals `origin/main` before this handoff commit
- **Planning checkout:** clean before this handoff
- **Worker mode:** implementation worker dispatched by the orchestrator
- **Worker branch:** `worker/implement-chatterbox-led-planning`
- **Worker worktree:** Paseo-managed; record the actual path before broad reads
- **Worktree creation:** Paseo `create_workspace`, `isolation: worktree`, `mode: branch-off`, `baseBranch: origin/main`
- **Required sibling worktree links:** `none`
- **Approved lane:** `g02.053/128`
- **Canonical refs:** `docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`; `docs/roadmaps/g02/batch-cards/128-implement-chatterbox-led-planning.md`; `docs/contracts/001-working-rules.md`
- **Worker class:** economical implementation agent capable of broad documentation/skill/checker refactoring; frontier reasoning is not required
- **Approved concurrent siblings:** none
- **Integration ownership:** worker owns card/roadmap/log and implementation front-door closeout; coordinator owns review lease, merge gate, and merge; Chatterbox owns any later planning change
- **Required validation:** card 128 evidence commands: `git diff --check`; `effigy check:chatterbox-git`; `effigy check:command-skills`; `effigy check:repo-contract`; `effigy check:model-routing`; isolated `effigy check:skill-install skills/northstar`; `effigy qa:docs`; `effigy qa`; and exact-head review
- **Review oracle:** spec-037 and card-128 fidelity, no invented authority or scope, all named role/direction/yield/frontier/review/esc escalation invariants, exact current head, and no weakened checks or merge gates
- **PR:** against current pushed `main`; pending
- **Review state:** awaiting independent review child after worker finish
- **Merge path:** coordinator after accepted exact-head verdict, resolved findings, passing checks, acceptable ancestry, mergeability, and no operator pause

## Boundaries

- **In scope:** only card `g02.053/128` and its named mutable surfaces, prerequisites, evidence, and closeout.
- **Out of scope:** new semantic artifacts, planning recompile, promotion-only workers, planning delegates, product/Paseo API changes, card 126 execution, unrelated cleanup, and any `.github/workflows/` or release mutation.
- Use the clean dedicated worktree selected by the completion protocol. Do not edit the planning checkout.
- Missing role, scope, dependency, acceptance, or parallelism decisions return context-completely to Chatterbox; do not choose them here.

## Important Context

The promoted plan says the normal path is direct Chatterbox planning followed by
mechanical worker dispatch. It also requires visible coordinator-owned review
children in the existing worker workspace, with a serial clean exact-head lease
and `notifyOnFinish: true`. Preserve all provenance distinctions between
operator-confirmed direction, Chatterbox recommendation, and administrative
notice.

## Suggested Next Move

Run the worker preflight, read the tracked handoff plus card/spec, implement the
single approved lane, validate, falsify the diff against its review oracle,
commit, push, and open one reviewable PR. Do not merge.

## Completion Protocol

1. Before broad reads run `git rev-parse --show-toplevel`,
   `git branch --show-current`, `git status --porcelain`, and
   `git worktree list --porcelain`. Accept only a clean registered non-`main`
   launcher worktree; record its actual root and branch.
2. Fetch with
   `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`.
   Confirm `HEAD == origin/main`, `8531f16` is an ancestor, and this handoff
   exists in `HEAD`; load its tracked blob and stop if it differs from this
   absolute file. Required sibling links are `none`.
3. Read the card and governing refs. Execute only the approved card. Do not
   invent a new role, dependency, acceptance rule, or semantic destination.
4. Run all card validation, enumerate universal/exact/negative claims, and
   exercise every review-oracle counterexample. Stop on any planning or
   authority gap and return a context-complete escalation to Chatterbox.
5. Commit the implementation, push the worker branch, and open one PR against
   current pushed `main`. Link the card, spec, changed surfaces, evidence,
   validation, and unresolved items. Do not merge.
6. Report the PR URL, exact head SHA, changed files, validation, and blockers.

### Review and merge lease

After the worker finishes, the coordinator pauses it and verifies the existing
worker workspace is on the exact PR head with a clean index/tracked worktree
and no Git operation active. It creates the independent review child through
the agent-scoped call with this same worker `workspaceId`, preserving
coordinator parentage, visible tab placement, and `notifyOnFinish: true`.
The reviewer is read-only and posts a provider verdict naming the exact head.
No review-only workspace, coordinator-workspace fallback, concurrent lease,
checkout, branch change, tracked-file edit, commit, push, or direct worker
contact is allowed. Requested changes repeat the clean-boundary and exact-head
review cycle with the same identities where available.
