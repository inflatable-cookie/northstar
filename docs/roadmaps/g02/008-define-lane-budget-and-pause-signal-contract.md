# 008 - Define Lane Budget And Pause-Signal Contract

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.007
Vision tags: `autonomy`, `execution`, `handoff`, `pause-state`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/011-lane-budget-and-pause-signal-contract.md`
Planning state: ready

## Problem

Northstar's continuation-envelope contract now makes bounded card-to-card
continuation explicit, but the system still under-describes the lane-level
budget and the exact reason a run paused once that bounded continuation ends.
That makes clean stops more legible than before, but still not explicit enough
for longer autonomous lanes.

## Goals

- [x] define the lane-budget and pause-signal contract
- [ ] apply that contract to the reusable doctrine, template, and handoff/log
      surfaces
- [ ] re-prove that the combined continuation and lane-budget model stops
      cleanly enough for routine use

## Non-Goals

- [ ] building a scheduler, job runner, or persistent run-state service
- [ ] replacing hard stop conditions with soft pause-only semantics

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 8.1 - Define Lane Budget And Pause-Signal Contract

- [x] define the compact lane-budget contract
- [x] define explicit pause-signal categories for clean stops
- [x] leave the implementation batch explicit and ready

### Batch 8.2 - Apply Lane Budget And Pause-Signal Contract

- [x] update the live and reusable doctrine/template surfaces
- [x] align handoff/log surfaces with the same lane-budget and pause model
- [x] refresh deterministic checks where expectations changed

### Batch 8.3 - Re-Prove The Lane Budget And Pause-Signal Contract

- [x] inspect another longer live lane through the updated budget/pause model
- [x] record any remaining bounded ambiguity
- [x] compile the next slice only if a bounded problem remains

## Acceptance Criteria

- [x] The lane-budget and pause-signal contract is explicit in the live
      planning surface.
- [x] The reusable surfaces reflect the same budget and pause posture.
- [x] The resulting combined model is re-proved after alignment.

## Risks and Mitigations

- Risk: the lane adds too much bookkeeping to ordinary batch cards and logs.
- Mitigation: keep the model compact, categorical, and subordinate to the
  existing continuation envelope.

- Risk: pause signals start to blur hard-stop conditions.
- Mitigation: keep planning gaps, failed validation, and authority mismatches
  as hard stop signals, not routine pauses.

## Planning Gaps

- none

## Evidence Requirements

- [x] definition log for the lane-budget contract batch
- [x] implementation log for the lane-budget alignment batch
- [x] re-proof log for the longer autonomous lane

## Next Task

Start `g02.009` batch `9.2` by running the combined autonomy model against a
real active consumer-repo lane and recording what still breaks outside
Northstar itself.
