# 123 - Preserve Paseo Worker Parentage

Status: ready
Owner: repo maintainers
Created: 2026-09-03
Master roadmap: `g02.049`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/roadmaps/g02/049-preserve-paseo-worker-parentage.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Auto-start next card: no

## Objective

Make Paseo worker dispatch preserve both dedicated-workspace isolation and the
worker's child relationship to the current orchestrator.

## Scope

- update working rules, reusable doctrine, copy-ready contract, and operator
  guidance with the scoped cross-workspace child sequence;
- update the installable orchestrator mode and concise skill outcome;
- update protocol-kernel or architecture routing only where needed to keep the
  canonical owner discoverable;
- add focused positive and negative assertions for the six milestone oracle
  rows;
- prove installed-skill parity;
- write closeout evidence, reconcile front doors, and open a reviewable PR.

Out of scope: Paseo code/CLI changes, shared workspaces, generic notification
infrastructure, polling, provider-specific model changes, card 120, language
packages, Sentrux, or weaker worktree/review/merge boundaries.

## Ready-State Checks

- [x] the operator supplied a live failure pattern: detached root workers do
  not notify their originating orchestrators;
- [x] the Paseo reference confirms that agent-scoped `create_agent` preserves
  parentage when passed another workspace's ID;
- [x] spec 026 settles the ordered workspace-then-scoped-agent sequence and
  rejects detached substitutes;
- [x] the six review-oracle rows and implementation surfaces are bounded;
- [x] no active Northstar worker owns the same protocol surfaces.

## Acceptance Criteria

- [ ] all six milestone oracle rows have focused proof;
- [ ] every Paseo worker gets a dedicated `branch-off` worktree workspace;
- [ ] worker creation is explicitly agent-scoped to the current orchestrator
  and receives the returned workspace ID;
- [ ] live reusable wording rejects detached root, schedule, generic detached,
  and unproven CLI substitutes;
- [ ] finish notification remains enabled and review follow-up targets the same
  child;
- [ ] manual/provider-neutral fallback remains intact;
- [ ] doctrine, copy-ready contract, skill source, operator guidance, and
  deterministic checks agree;
- [ ] isolated skill-install parity, docs QA, full QA, and `git diff --check`
  pass;
- [ ] the PR records its exact tested head and any limits.

## Evidence Required

- before/after inventory of Paseo worker creation wording;
- six-row scenario matrix with positive and negative discrimination;
- one live launch record showing separate workspace and child-agent ownership;
- focused proof that disabling notifications or substituting a root launch is
  rejected;
- `effigy check:command-skills`, isolated `effigy check:skill-install`,
  `effigy qa:docs`, `effigy qa`, and `git diff --check`;
- closeout log, reviewable PR, and exact tested head.

## Stop Conditions

- implementation requires a Paseo change or undocumented parent override;
- scoped agent creation cannot target the new workspace;
- tests can only assert prose without distinguishing the launch sequence;
- manual fallback or dedicated worktree isolation would be weakened;
- card 120 or another lane begins touching the same skill/front-door surfaces;
- validation changes the plan.

## Next Task

Implement this card in one worker lane and stop for exact-head orchestrator
review. Do not start card 120 from the worker.
