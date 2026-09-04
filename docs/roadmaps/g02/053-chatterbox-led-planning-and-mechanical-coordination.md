# 053 - Chatterbox-Led Planning and Mechanical Coordination

Status: complete; card 128 merged through PR 34
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Depends on: `g02.050`, `g02.051`, `g02.052`, spec 037
Vision tags: `chatterbox`, `planning`, `coordination`, `parallelism`, `paseo`
Governing refs:
`docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`,
`docs/contracts/001-working-rules.md`

## Problem

The first economical-coordinator split still makes the coordinator compile and
dispatch promotion work, design parallel frontiers, and remain active while
children run. Live use produced a stopped promotion loop before actual-worker
dispatch.

## Goals

- make Chatterbox the canonical human-facing planner and promoter;
- restore small triage-only planning delegates for parallel conversations;
- publish lane graphs and approved parallel frontiers before coordination;
- reduce Luna to factual dispatch, review routing, gates, merge, and closeout;
- reuse worker workspaces for visible parent-attached reviewers;
- make coordinator turns notification-driven and operator questions complete.

## Non-goals

- no weaker implementation/review/merge gates;
- no Chatterbox product/runtime implementation or merge authority;
- no planning-delegate worktree/PR;
- no promotion-only worker;
- no provider-specific reusable policy.

## Execution plan

- [x] **Card 128** performs the one-shot role migration across doctrine,
      templates, skills, checks, trial surfaces, and source/install parity.

## Review oracle

Use spec 037. Falsify direct promotion, triage-only delegates, approved-frontier
consumption, direct direction messages, event-bounded coordinator turns,
worker-workspace reviewer leases, and context-complete escalations.

## Stop conditions

- any implementation surface still authorizes coordinator promotion or frontier
  design;
- a delegate can mutate canonical planning or contact the coordinator;
- review parentage or exact-head safety weakens;
- validation reveals an unplanned compatibility decision.

## Next task

Card 128 merged through PR 34 at `fd341aebd9c59bf1110f87deb4bce46cc3249d66`
after accepted exact-head review at `201c499b9134b764eabd7953101af93d3891ae32`.
The installed skill refresh and 111-file parity proof are complete. The live
continuity correction and observation packet are promoted under g02.054/card
129 and card 126.
