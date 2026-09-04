---
title: Economical orchestrator coordination worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: complete; merged through PR 32 as 61d4cc2
owner: repo maintainers
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-000152-economical-orchestrator-coordination.md
base_required: pushed-main
tags: [coordination, handoff, worker, orchestrator, review, cost]
---

## What This Thread Was Doing

Northstar has compiled spec 036, milestone `g02.051`, and card 125. The operator
approved keeping the public orchestrator role while narrowing its default job to
economical coordination. Material planning comes from operator-confirmed
chatterbox packets; substantive PR review comes from independent child reviewers.

This handoff dispatches the bounded protocol implementation. Card 126's live
ten-PR trial remains separate and blocked.

## Why It Matters

Long-lived frontier orchestrators are spending expensive model capacity on
mechanical dispatch, status, and merge bookkeeping. Northstar should reserve
high-cost reasoning for product discovery and genuinely difficult review while
keeping the existing PR and merge safety gates.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Required planning lineage:** PR 31 merge `d1b162ecd787d869a961b959954dc62d8249c69c`
  must be an ancestor; launch from pushed `main` containing this handoff.
- **Planning checkout:** clean at dispatch.
- **Worker branch:** `worker/economical-orchestrator-coordination`
- **Worker worktree:** Paseo-managed dedicated worktree; accept the actual path.
- **Worktree creation:** Paseo `branch-off` from pushed `main`, branch
  `worker/economical-orchestrator-coordination`, slug
  `economical-orchestrator-coordination`.
- **Required sibling links:** none.
- **Active spec:** `docs/specs/036-economical-orchestrator-coordination.md`.
- **Roadmap:** `docs/roadmaps/g02/051-economical-orchestrator-coordination.md`.
- **Ready card:**
  `docs/roadmaps/g02/batch-cards/125-economical-orchestrator-coordination.md`.
- **Allowed runway:** card 125 only. Do not start card 126.
- **Surfaces owned:** orchestrator/chatterbox/direct-review/projection modes;
  working rules; reusable doctrine and copy-ready template; protocol kernel;
  architecture, inventory, operator guidance, skill outcome; structural checks
  and parity; card, milestone, one closeout log, this handoff, and front doors.
- **Integration ownership:** worker implements and opens the PR. The originating
  orchestrator owns exact-head review, revision routing, merge, and skill refresh.
- **Review oracle:** the ten rows in spec 036. Do not add material acceptance.
- **Model capability profile:** economical day-to-day implementation; the role
  split and safety boundaries are settled.
- **Frontier-worker justification:** none.
- **Required validation:** appropriate structural command/repo-contract checks,
  isolated `effigy check:skill-install skills/northstar`, `effigy qa:docs`,
  `effigy qa`, and `git diff --check`.
- **PR base/head:** `main` <- `worker/economical-orchestrator-coordination`.
- **Merge path:** originating orchestrator after accepted exact-head review and
  the unchanged merge gate.

## Boundaries

- Implement card 125 only.
- Do not edit Paseo profiles or encode local provider/model names, prices,
  allowances, or subscriptions in reusable policy.
- Do not run the ten-PR trial or create synthetic project work.
- Do not weaken exact-head review, checks, ancestry, mergeability, or operator
  pause handling.
- Keep semantic role boundaries in exact-head review evidence. Do not recreate
  prose-coupled substring validation rejected by `g02.045`.
- Work only in the launcher worktree. Do not mutate the planning checkout.
- Do not merge.

## Important Context

- Spec 026 currently assigns discovery, promotion, full semantic review, and
  merge to the frontier orchestrator. Card 125 intentionally changes that split.
- Spec 035 keeps chatterbox non-authoritative. Preserve that: only explicitly
  operator-confirmed meaning can enter a projection brief.
- Direct PR Review mode already owns independent provider-facing review. Reuse
  it rather than inventing another review protocol.
- Card 123 requires each worker or reviewer to live in its own workspace while
  remaining a child created through the orchestrator's agent-scoped path.
- The coordinator must verify the durable verdict names the exact current head
  and that all blocking findings, checks, ancestry, mergeability, and pauses are
  settled before merge. It must not merely trust a finish notification.
- Capability classes stay portable. The operator will update local Paseo agent
  profiles after this protocol is accepted.

## Suggested Next Move

Read `AGENTS.md`, card 125, milestone 051, specs 036/026/035, working rules,
orchestrator mode, direct PR review mode, chatterbox mode, and the existing
mechanical projection boundary. Implement the compact reusable rule across the
named surfaces, preserving structural-only checker discipline.

## Completion Protocol

### Before you start

1. Record repository root, branch, status, and worktree registration.
2. Accept the clean registered non-`main` launcher worktree. Do not create a
   replacement because its path differs from this handoff.
3. Fetch origin non-interactively. Confirm `HEAD == origin/main`, confirm
   `d1b162ecd787d869a961b959954dc62d8249c69c` is an ancestor, and confirm this
   handoff matches the tracked blob at `HEAD`.
4. Required sibling links are `none`.
5. Read the assigned card and governing refs before mutation.

### While you work

- Implement card 125 as one coherent protocol batch.
- Preserve Chatterbox's non-authority and Direct PR Review's no-branch-mutation
  boundary.
- Make the normal review child a parent-attached child in its own PR checkout
  workspace with finish notifications enabled.
- Preserve same-worker and same-reviewer identity across revisions when
  available; fail closed on stale or ambiguous review evidence.
- Stop and return any new product, authority, or merge-safety decision.

### When complete

1. Map all ten oracle rows to structural or exact-head review evidence.
2. Run the required validation after the coherent batch.
3. Reconcile card 125, milestone 051, one closeout log, this handoff, and all
   affected front doors. Leave card 126 blocked.
4. Integrate current `main` if it moved, rerun affected validation, push, and
   open a reviewable PR.
5. Report the PR URL and exact tested head through the finish notification.
   Do not merge or refresh the installed skill.

### Review and merge path

The originating orchestrator independently reviews this transition under the
current pre-change authority. Blocking findings return to this same child and
branch. Only after card 125 merges and the skill refreshes does the new
coordinator/reviewer split govern subsequent lanes.

### Handoff closeout

On a stop condition, record the exact blocker and pause. Do not start card 126,
edit Paseo configuration, or turn this implementation into its own live trial.
