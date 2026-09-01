# 111 - Prefer Economical Worker Routing

Status: complete
Owner: repo maintainers
Created: 2026-09-01
Master roadmap: `g02.043`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/roadmaps/g02/043-prefer-economical-worker-routing.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Auto-start next card: no

## Objective

Promote economical-by-default worker selection through Northstar's reusable
orchestrator surfaces so ordinary work uses matching day-to-day profiles and
frontier workers are reserved for the rare lanes that satisfy both escalation
axes.

## Scope

- update architecture, working rules, reusable doctrine, and operator guidance;
- update the installable orchestrator mode and concise top-level outcome;
- update the worker handoff template so frontier dispatch records both reasons;
- update copy-ready consumer contract surfaces that bind profile selection;
- add deterministic positive and negative checks for the routing scenarios;
- write closeout evidence and reconcile roadmap/front-door state.

Out of scope: provider prices, model IDs, local profile names, Paseo profile
changes, a runtime scheduler, mid-run worker replacement, or weaker review
gates.

## Ready-State Checks

- [x] the operator selected economical day-to-day worker routing as the default;
- [x] current Paseo profile notes distinguish day-to-day workers from the
  highest-priority, highest-complexity worker;
- [x] the over-broad frontier trigger and desired two-axis replacement are
  settled in spec 026 and milestone 043;
- [x] implementation surfaces and falsification scenarios are bounded;
- [x] no active worker or PR owns this routing change.

## Acceptance Criteria

- [x] ordinary bounded workers prefer a matching non-frontier day-to-day profile;
- [x] broad mechanical audits/docs prefer fast/low-cost or mechanically oriented
  profiles;
- [x] frontier implementation requires both exceptional reasoning difficulty
  and highest priority or material consequence;
- [x] the handoff records both frontier reasons;
- [x] single-axis, broad-scope, and risk-label-only cases do not route frontier;
- [x] unresolved designs return to planning and no-fit profiles are reported;
- [x] risky lanes retain explicit review oracles and frontier review;
- [x] doctrine, copy-ready contracts, skill source, handoff template, operator
  docs, and installed payload agree;
- [x] repository QA and isolated skill-install parity pass.

## Review Oracle

Use milestone `g02.043`. Exercise all seven scenario rows against final wording
and deterministic checks. A reviewer must be able to identify the chosen worker
class, the evidence for each escalation axis, and whether the lane should return
to planning instead.

## Evidence Required

- current-profile note inventory with local names omitted from reusable policy;
- before/after inventory of automatic frontier triggers;
- seven-row scenario matrix covering ordinary, mechanical, risk-domain,
  conjunctive single-axis (priority-only and complexity-only), positive-frontier,
  ambiguity, and no-fit behavior; both single-axis cases need separate evidence;
- changed-surface parity inventory;
- `effigy check:command-skills`, `effigy check:skill-install`,
  `effigy qa:docs`, `effigy qa`, and `git diff --check` results;
- closeout log and reviewable PR exact head.

## Stop Conditions

- any routing or authority choice remains unresolved;
- correct behavior needs a hard-coded provider, model, price, or profile name;
- the change weakens review rigor for risky work;
- a current worker-routing owner overlaps this card;
- validation changes the plan.

## Next Task

Complete. PR 15 merged at `d5acd75` after exact-head review and passing checks.
