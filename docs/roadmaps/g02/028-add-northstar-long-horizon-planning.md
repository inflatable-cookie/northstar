# 028 - Add Northstar Long-Horizon Planning

Status: active
Owner: repo maintainers
Created: 2026-08-17
Updated: 2026-08-17
Depends on: g02.026, g02.027
Vision tags: `long-horizon-planning`, `strategic-runway`, `multi-horizon`, `northstar-atlas`
Master spec refs: `docs/specs/029-northstar-long-horizon-planning.md`
Governing refs: `bundle-docs/protocol-kernel.md`, `docs/vision/`, `docs/architecture/`, `docs/contracts/001-working-rules.md`
Planning state: Atlas route contract, mode, slash adapter, deterministic command checks, and Northstar-scale validation complete; non-Northstar validation and operator confirmation remain pending

## Problem

Northstar's planning-readiness review checks whether existing planning can
continue, but it does not yet shape long-horizon strategic direction and a
multi-horizon runway. A memorable explicit command must not conceal that gap.

## Goals

- [x] define the distinction between readiness review and long-horizon planning;
- [x] define the Atlas route contract and plan-only authority boundary;
- [x] implement the provisional Atlas mode and router entry;
- [x] validate Atlas against a genuinely large-scale planning scenario;
- [ ] confirm the output is strategic horizon synthesis rather than a review or
      short-term roadmap;
- [x] add the thin `/northstar-atlas` slash adapter;
- [x] add deterministic command-surface and distribution checks;
- [x] preserve natural-language routing and the operator-owned dogfooding boundary.

## Execution plan

### Batch 28.1 — Define and route Atlas

- `docs/specs/029-northstar-long-horizon-planning.md` owns the route contract;
- `skills/northstar/references/modes/atlas.md` defines the scale test, required
  reads, horizon model, promotion map, and stop conditions;
- `skills/northstar/references/router.md` distinguishes Atlas from readiness
  review, discovery, architecture refocus, and roadmap compilation;
- no production code, worker, worktree, or consumer execution.

### Batch 28.2 — Validate strategic scale

- choose one genuinely large project, product, platform, or portfolio scenario;
- run Atlas against vision, architecture, contracts, generation runway, and
  roadmap horizons;
- record whether it surfaces strategic bets, dependencies, non-goals, accepted
  uncertainty, and meaningful horizon transitions;
- capture operator corrections and revise the mode contract only where evidence
  shows the route is too small, too broad, or too implementation-oriented.

### Batch 28.3 — Publish the explicit command surface

- add `/northstar-atlas` only after Batch 28.2 demonstrates the contract;
- add the five thin utility adapters for reframe, AGENTS review, readiness review,
  architecture refocus, and refresh, alongside Atlas;
- add one deterministic command-surface checker and installed-tree parity
  evidence;
- retire the copied-sounding `northstar wayfinder` alias while retaining
  `northstar planning readiness review` as the natural-language trigger.

## Acceptance criteria

- [x] readiness review is explicitly smaller than Atlas;
- [x] Atlas is routed as a distinct, plan-only mode;
- [x] Northstar itself produces a useful strategic horizon model in a
      large-scale validation scenario;
- [ ] the operator confirms the scale and usefulness of the output;
- [x] the slash adapter loads the router and exactly one mode without duplicating
      procedure content;
- [x] the command index remains within the agreed context budget;
- [x] source and installed skill trees pass parity checks;
- [x] no consumer dogfood run is selected, dispatched, or managed by Northstar.

## Stop conditions

- stop if Atlas is only restating existing docs or reviewing currentness;
- stop if it becomes a feature backlog or 20-to-50-card waterfall;
- stop if it resolves operator-owned strategic choices implicitly;
- stop if it requires a second planning authority or external tracker;
- stop if the slash adapter is published before the large-scale scenario passes.

## Next task

Run the Atlas route against a large non-Northstar planning scenario and record
the operator's correction burden before treating `/northstar-atlas` as fully
validated.
