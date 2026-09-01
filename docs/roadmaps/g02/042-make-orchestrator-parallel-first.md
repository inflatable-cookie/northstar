# 042 - Make Orchestrator Scheduling Parallel-First

Status: active
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.025`, `g02.035`, `g02.036`, `g02.037`
Vision tags: `orchestration`, `parallelism`, `workers`, `paseo`, `model-efficiency`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Planning state: card 110 ready for worker dispatch

## Problem

Northstar allows independent worker lanes to run in parallel, but the current
orchestrator procedure says to assess and offer that shape. In practice the
orchestrator follows one lane through dispatch, review, and merge unless the
operator explicitly asks for concurrency. Safe work is therefore serialized by
conversation habit rather than by dependency.

## Goals

- [ ] make dependency-frontier planning part of runway compilation and every
  dispatch checkpoint;
- [ ] make launching all safe ready lanes up to available capacity the default;
- [ ] refill capacity and continue unrelated planning/review while workers run;
- [ ] require a concrete reason for serializing an otherwise-ready lane;
- [ ] preserve one coherent issue-fix lane and every authority, worktree,
  review, exact-head, and merge gate;
- [ ] distribute the behavior through doctrine, consumer contracts, the
  installable skill, handoff template, and operator guidance.

## Non-goals

- no fixed provider, model, profile, worker count, or control-plane dependency;
- no parallel writes to shared files or shared closeout/front-door authority;
- no speculative cards created only to fill worker slots;
- no split diagnosis/fix PRs for one bounded reported defect;
- no weakening of accepted-review, passing-check, mergeability, or operator
  pause gates;
- no change to serial mechanical documentation projection in the planning
  checkout.

## Execution Plan

Card `g02.042/110` owns one bounded protocol, template, validation, distribution,
and closeout lane. The worker updates already-settled behavior; it does not
choose a scheduler implementation or provider-specific concurrency limit.

## Acceptance Criteria

- the orchestrator plans a dependency graph and ready frontier rather than
  treating parallelism as an optional prompt;
- every independent ready lane is dispatched up to actual available capacity
  without a second operator request;
- queued ready work fills freed capacity and the orchestrator continues useful
  non-overlapping work while workers are active;
- serial decisions name the dependency, shared mutable/closeout surface,
  unresolved authority, or capacity limit;
- same-repo parallel lanes partition mutable and closeout surfaces or reserve a
  named orchestrator integration step;
- one coherent issue-fix remains one worker lane;
- each worker keeps a distinct handoff, worktree, branch, PR, review loop, and
  exact-head merge gate;
- source/install parity and repository QA pass.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Independent work starts concurrently. | Two ready lanes touch different repos and have no dependency, but only one worker launches. | Launch both up to available capacity without another operator prompt. | Procedure and handoff scenario evidence. |
| Dependencies still serialize. | Lane B consumes an artifact produced by lane A. | Keep B queued and name the A -> B edge. | Negative scenario evidence. |
| Shared authority does not race. | Two same-repo cards both edit the generation README. | Partition closeout ownership or reserve an orchestrator integration step before launch. | Same-repo scenario evidence. |
| Capacity is reused. | Three lanes are ready, capacity is two, and one worker finishes. | Launch the queued third lane while the other worker continues. | Capacity-refill scenario evidence. |
| Issue fixes remain coherent. | A reported defect could be split into diagnosis and patch workers. | Keep reproduce-through-fix in one outcome lane. | Doctrine/skill assertion. |
| Exact-head review survives concurrency. | One same-repo PR merges while a sibling PR is still open. | Refresh the remaining head against current `main`; re-review any changed head. | Merge-order scenario evidence. |

## Stop Conditions

- safe parallelism requires a provider-specific scheduler or fixed worker count;
- the change would allow workers to share mutable scope or bypass planning;
- the protocol cannot distinguish ready-frontier work from speculative backlog;
- validation reveals source/install divergence or contradictory consumer rules;
- another active Northstar lane already owns parallel-first orchestrator policy.

## Next Task

Dispatch card `g02.042/110` from the committed handoff. The worker opens a PR;
the orchestrator reviews and merges the exact accepted head without another
operator approval prompt.
