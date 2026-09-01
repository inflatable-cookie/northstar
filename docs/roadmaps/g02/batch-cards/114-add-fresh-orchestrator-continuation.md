# 114 - Add Fresh Orchestrator Continuation

Status: blocked; ready after `g02.045/113` merges and current `main` is refreshed
Owner: repo maintainers
Created: 2026-09-01
Master roadmap: `g02.046`
Governing refs: `docs/roadmaps/g02/046-add-fresh-orchestrator-continuation.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`,
`skills/northstar/references/handoff-contract.md`
Auto-start next card: no

## Objective

Teach the reusable Northstar orchestrator route to publish and dispatch a fresh
orchestrator continuation through Paseo without confusing it with a worker,
planning delegate, or UI-automation task.

## Scope

- add orchestrator-continuation activation to the router and handoff contract;
- reuse the generic handoff template with the three settled activation fields;
- add the source-yield and successor-entry procedure to orchestrator mode;
- propagate the compact reusable rule to doctrine, copy-ready working rules,
  protocol kernel, operator guidance, and skill outcome text;
- specify the Paseo local-workspace, profile, capitalized label, prompt, identity,
  and manual-pinning behavior without hard-coded model names;
- add deterministic positive and negative assertions for every milestone oracle
  row;
- update source/install parity, card, milestone, log, handoff, and front doors;
- open a reviewable PR and stop for orchestrator exact-head review.

Out of scope: modifying Paseo, writing a plugin, automating sidebar UI, adding a
new public skill/mode/template, spawning a successor as part of the test,
archiving the source workspace, or changing worker/planning-delegate semantics.

## Ready-State Checks

- [x] the operator explicitly requested fresh-orchestrator handoff and dispatch;
- [x] spec 026, architecture, and working rules settle authority and adapter
  behavior;
- [x] current Paseo MCP and CLI inspection shows agent labels and local
  workspaces but no native pin/reorder surface;
- [ ] PR 18 is merged and card 113/front-door closeout is current on `main`;
- [ ] no other worker owns orchestrator mode, handoff contract, router, doctrine,
  copy-ready contract, or this card's closeout surfaces.

## Acceptance Criteria

- [ ] all eight milestone oracle rows have deterministic proof;
- [ ] a fresh continuation selects Orchestrator mode without worker preflight;
- [ ] the source yields the transferred lane after pushed handoff dispatch;
- [ ] Paseo launch uses one separate local workspace for the same project/path,
  one current orchestrator profile, `Orchestrator=true`, and the single absolute
  handoff prompt;
- [ ] absent pin support is manual and never invokes UI automation;
- [ ] manual fallback returns the absolute path and stays provider-neutral;
- [ ] generic handoff shape remains seven sections and no new template is added;
- [ ] source/install parity, docs QA, full QA, and `git diff --check` pass;
- [ ] the PR records the exact tested head and unresolved limits.

## Evidence Required

- before/after routing and handoff activation inventory;
- all eight oracle scenarios with expected failures named;
- current Paseo capability evidence for local workspaces, agent labels, and
  absent pin/reorder control;
- `effigy check:command-skills`, isolated `effigy check:skill-install`,
  `effigy qa:docs`, `effigy qa`, and `git diff --check` results;
- closeout log, reviewable PR, and exact tested head.

## Stop Conditions

- the prerequisite merge or ownership boundary is not clean;
- implementation needs a Paseo product/API change;
- workspace labels rather than supported agent labels are required for the
  operator's sidebar behavior;
- a second template/public mode becomes necessary;
- validation changes the plan.

## Next Task

After PR 18 merges, refresh this card to `ready`, create one worker handoff, and
dispatch a matching non-frontier day-to-day worker. Do not merge from the worker.
