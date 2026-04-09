# 005 - Tighten Spec Lifecycle And Archive Mechanics

Status: complete
Owner: repo maintainers
Created: 2026-04-09
Depends on: g02.004
Vision tags: `specs`, `archive`, `planning-hygiene`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/008-spec-lifecycle-and-archive-mechanics.md`
Planning state: ready

## Problem

Northstar's front-door path is now much clearer, but `docs/specs/` still
contains a growing stack of closed planning artifacts in place. That weakens
the protocol's claim that specs are provisional planning surfaces and makes the
active planning lane harder to see than it should be.

## Goals

- [x] define a reusable lifecycle and archive rule for specs
- [x] apply that rule to the live Northstar repo
- [ ] re-prove the resulting specs surface

## Non-Goals

- [ ] deleting planning history indiscriminately
- [ ] forcing heavyweight archive migrations on every repo

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 5.1 - Define Spec Lifecycle And Archive Rule

- [x] define when specs stay active, retire in place, or move into an archive
- [x] define a lean archive layout for closed planning artifacts
- [x] promote the rule into doctrine, the bundle, and live working rules

### Batch 5.2 - Apply Lifecycle Rule To Live Repo

- [x] reduce stale in-place planning artifacts in the live specs surface
- [x] keep active planning lanes obvious and traceable
- [x] refresh any affected front doors or indexes

### Batch 5.3 - Re-Prove The Specs Surface

- [x] re-run the specs path after the lifecycle update
- [x] record what clutter or ambiguity remains acceptable
- [x] compile the next improvement slice only if a bounded problem remains

## Acceptance Criteria

- [x] The lifecycle and archive rule is explicit in doctrine and live rules.
- [x] The live specs surface mostly reflects active planning.
- [x] The updated specs surface is re-proved after the lifecycle update.

## Risks and Mitigations

- Risk: the lane becomes a file-moving exercise without a reusable rule.
- Mitigation: define the lifecycle rule before changing the live tree.

- Risk: the archive posture becomes overengineered.
- Mitigation: keep the archive layout lean and focused on retired planning
  artifacts only.

## Planning Gaps

- none

## Evidence Requirements

- [x] doctrine, bundle, and live-rule updates for the lifecycle rule
- [x] application log for the live cleanup batch
- [x] re-proof log for the updated specs surface

## Completion Notes

`g02.005` is now complete. The active specs surface is focused enough to live
with, and the remaining bounded issue has moved from docs structure into the
reusable automation layer: setup, planning, and recovery should expose the
archive posture more explicitly so downstream repos do not need custom
interpretation.

## Next Task

Start `g02.006` batch `6.1` by aligning the setup, plan, and recover surfaces
with the spec archive posture.
