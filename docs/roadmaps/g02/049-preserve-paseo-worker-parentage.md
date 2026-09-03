# 049 - Preserve Paseo Worker Parentage

Status: complete (card 123 executed and verified)
Owner: repo maintainers
Created: 2026-09-03
Depends on: `g02.047`, spec 026
Vision tags: `orchestration`, `paseo`, `notifications`, `worker-lifecycle`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`

## Problem

Some Paseo-backed orchestrators create each worker in a new workspace by using
a top-level launch path. The workspace is isolated, but the worker becomes a
detached root agent instead of a child of the orchestrator. The orchestrator
then receives no finish, error, or permission notification and can miss the PR
review handoff entirely.

Paseo already separates these concerns: an orchestrator-scoped agent creation
can target a newly created workspace while preserving parentage. Northstar's
current wording requires the workspace and notifications but does not state
that the creation call itself must stay agent-scoped.

## Goals

- create one dedicated worktree workspace per worker lane;
- create the worker from the current orchestrator's agent-scoped surface while
  passing that workspace ID;
- preserve the parent-child relationship across workspace placement;
- keep completion, error, and permission notifications enabled;
- retain the same child identity for review revisions;
- reject detached root launches as an implementation of Paseo worker dispatch;
- preserve manual/provider-neutral fallback when scoped Paseo tools are absent.

## Non-goals

- no Paseo product or CLI change;
- no shared worker workspace;
- no worker polling or transcript mining;
- no new notification service;
- no requirement that a provider without parent-child transport emulate it;
- no change to planning, review, merge, model-routing, or capacity semantics.

## Execution Plan

Card `g02.049/123` propagates the settled spec meaning through doctrine,
working rules, the installable orchestrator mode, copy-ready surfaces,
operator guidance, one live cross-workspace child launch, installed-skill parity,
and closeout. The live launch is the behavioral proof. Editorial wording stays
outside executable validation under `g02.045`.

Card 120 remains ready but serial behind this correction: both lanes own the
Northstar skill payload and roadmap/front-door closeout surfaces, and the next
worker dispatch should exercise the corrected creation sequence.

## Acceptance Criteria

- [x] the Paseo sequence creates the worktree workspace first, then creates the
  worker from the current orchestrator's agent-scoped tool context with that
  exact workspace ID;
- [x] reusable surfaces say workspace placement does not change parentage;
- [x] top-level/root-agent, schedule, generic detached, and unproven CLI launch
  paths are rejected for an automatic Paseo worker;
- [x] finish notifications remain enabled and review revisions resume the same
  child agent;
- [x] ambiguous creation preserves identities and never triggers a compensating
  poll or duplicate worker;
- [x] manual launch remains valid when scoped tools are absent;
- [x] source/install parity and full Northstar QA pass.

## Review Oracle

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof | Status |
| --- | --- | --- | --- | --- |
| Isolation and parentage coexist. | A worker needs a new worktree workspace. | Create the workspace, then create a child from the orchestrator scope with its ID. | Live launch record names both IDs and the ordered calls. | PASS (live launch record) |
| Workspace placement does not detach. | The child is placed in a workspace different from the parent. | Preserve the orchestrator-child relationship and notification route. | Live parent label plus finish notification delivered to the originating orchestrator. | PASS (live parent label + notification) |
| Detached roots are invalid workers. | An orchestrator uses a top-level CLI/root launch because it can create the same worktree. | Reject it as non-equivalent; use scoped creation or manual handoff. | Exact-head source review confirms the reusable rule rejects detached substitutes. | PASS (source review across working rules, doctrine 07, template, mode) |
| Notifications are structural. | The worker is created with finish notification disabled. | Reject launch configuration before creation. | Live launch record has notifications enabled; exact-head source review confirms the rejection rule. | PASS (live launch + source review) |
| Revisions retain identity. | Review requests changes after the child finishes. | Resume the same child agent; do not create a detached replacement. | This review revision resumes the recorded child ID. | PASS (PR 29 review addendum resumed child 3b92a429-64ec-4d31-a85b-bd97fd5b49d2) |
| Provider neutrality survives. | Scoped Paseo tools are absent. | Return the absolute handoff for manual launch without pretending parentage exists. | Exact-head source review confirms the manual fallback remains intact. | PASS (source review confirms fallback intact) |

## Stop Conditions

- None encountered. All acceptance criteria and review oracle rows verified via live launch, exact-head source review, and same-child revision without prose-coupled checkers.

## Next Task

Stop for exact-head orchestrator review. After reviewed merge and
installed-skill refresh, resume card 120's bounded root-reduction lane.
