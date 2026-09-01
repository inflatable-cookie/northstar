---
title: Diversified model routing implementation handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: complete
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-161201-diversified-model-routing.md
tags: [coordination, handoff, worker, orchestration, routing]
---

## What This Thread Was Doing

The operator corrected Northstar's model policy after repeated best-fit routing
first exhausted Opus usage and then concentrated the same pattern on Grok. PR 19
closed the preceding fresh-orchestrator lane. Planning now treats configured
profiles as a portfolio and card 115 is ready to implement that rule.

## Why It Matters

The PR review loop makes small economical models capable of most settled worker
tasks. Northstar should spread work across adequate routes before allowances are
exhausted, while keeping planning, review oracles, exact-head review, and
repository validation as the real risk controls.

## Current State

- **Done:** PR 19 merged at `b99d19c`; the operator decision was promoted into
  architecture, working rules, spec 026, milestone 047, and card 115 on pushed
  `main` at `b30e288`.
- **Done in this lane:** card 115 is implemented; `check:model-routing`
  falsifies all ten milestone oracle rows; the full validation suite passes;
  the branch is pushed and a reviewable PR is open.
- **Still open:** orchestrator exact-head review and merge of that PR.
- **Current card:**
  `docs/roadmaps/g02/batch-cards/115-diversify-model-routing-across-runs.md`.
- **Planning base:** `b30e288a1525d4d06c49dfabb0972503be4b5e61`.
- **Worker branch:** `worker/diversify-model-routing`.
- **Required sibling worktree links:** none.
- **Concurrent Northstar lanes:** none owns model routing, orchestrator mode,
  doctrine, templates, assertions, or card 115 closeout.
- **Owned surfaces:** card 115's reusable policy propagation, focused tests,
  installed parity, closeout log, this handoff, and dependent front doors.
- **Selected profile:** GLM 5.3 Flash Worker, a day-to-day route not used for
  card 114 and selected to exercise provider/model variation.
- **Frontier-worker justification:** none; the ten-row oracle and policy choices
  are settled.
- **Remaining continuation envelope:** exhausted; the lane ends at its
  reviewable PR.

## Boundaries

- Work only on card 115.
- Do not add persistent usage accounting, billing integration, provider-specific
  load balancing, model prices, balances, allowances, or automatic top-ups.
- Do not hard-code this handoff's profile or any other local profile/model name
  into reusable Northstar policy or tests.
- Do not weaken planning, review oracles, exact-head review, validation, merge,
  lane-local failure, or operator override.
- Do not start spec 034 or modify Paseo.

## Important Context

- The failure was concentration before refusal, not fallback after refusal.
  Routing must rotate successful adequate routes rather than wait for quota
  failure.
- Adequacy comes before price or rotation. Prefer the cheapest adequate tier,
  then the least-recent provider/model within it.
- Adapter-visible recent-agent history is optional. Without it, current-run
  route memory is enough; Northstar owns no durable usage ledger.
- Apply diversification to ordinary workers, mechanical jobs, planning
  delegates, fresh orchestrators, and rare frontier workers. A material but
  well-settled lane may use a small worker because review strength stays with
  the orchestrator and repository evidence.
- The rare frontier exception must explain why planning and review controls
  cannot bound the remaining reasoning. Risk, priority, complexity, and breadth
  alone are not enough.

## Suggested Next Move

Run orchestrator exact-head review of the PR against card 115's ten-row
oracle, required validation, and the boundaries above. Merge is
orchestrator-owned; spec 034 remains separate and not ready.

## Completion Protocol

1. Work only in the Paseo-managed non-`main` worktree and preserve unrelated
   state.
2. Implement card 115 without inventing a runtime usage service or local model
   catalogue.
3. Falsify all ten milestone oracle rows. Keep assertions focused on the routing
   contract; do not restore broad editorial validation.
4. Search the reusable payload for stale one-default, same-class-only fallback,
   frontier-always, and local profile/model/cost wording.
5. Run `effigy check:command-skills`, isolated
   `effigy check:skill-install`, `effigy qa:docs`, `effigy qa`, and
   `git diff --check`.
6. Reconcile card 115, milestone 047, one dated log, this handoff, and directly
   dependent front doors.
7. Integrate current `origin/main` if it moves, revalidate, push
   `worker/diversify-model-routing`, and open a PR against `main`.
8. Report the PR URL, exact tested head, validation, and remaining limits. Do
   not merge; the orchestrator owns exact-head review and merge.

Stop on an unresolved adequacy/cost signal, need for durable cross-thread
storage, conflict with explicit operator selection, broad prose-checker growth,
or validation that changes the plan. The lane ends after its reviewable PR.
