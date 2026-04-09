# 003 - Tighten Currentness Surfaces And Alignment Checks

Status: complete
Owner: repo maintainers
Created: 2026-04-09
Depends on: g02.002
Vision tags: `currentness`, `operator-flow`, `alignment`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md`
Planning state: ready

## Problem

Northstar's autonomy lane showed that stale front doors and currentness indexes
can survive even when the deeper planning spine is sound. That slows operators
down and makes the live lane harder to trust than it should be.

## Goals

- [x] define the canonical currentness surfaces and refresh rule
- [x] add lightweight deterministic checks for the most predictable stale states
- [x] prove what still depends on manual judgment after that enforcement

## Non-Goals

- [ ] building a heavy generic docs-state linter
- [ ] adding another public skill surface for currentness maintenance

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 3.1 - Define Currentness Surfaces And Refresh Rule

- [x] define the currentness surfaces in doctrine and live working rules
- [x] promote the same rule into the bundle surfaces
- [x] open the next lane with a lightweight-check batch explicitly queued

### Batch 3.2 - Add Lightweight Currentness Checks

- [x] define the bounded set of deterministic currentness surfaces to check
- [x] extend the live repo checker for those surfaces
- [x] refresh any live docs exposed by the new checks

### Batch 3.3 - Prove The Currentness Path

- [x] run the updated currentness path on the live repo
- [x] capture what still depends on human judgment
- [x] compile the next improvement slice from that evidence

## Acceptance Criteria

- [x] The currentness surfaces and refresh rule are explicit.
- [x] Lightweight deterministic checks defend the most predictable stale states.
- [x] The live repo has one proof pass showing what still remains manual.
- [x] `g02` remains the active generation throughout this milestone.

## Risks and Mitigations

- Risk: the work becomes a heavy linter project.
- Mitigation: keep the checker repo-local, deterministic, and bounded to the
  repeated stale-state pattern.

- Risk: the work adds more reminder prose without reducing drift.
- Mitigation: make a checker batch explicit and follow it with a proof pass.

## Planning Gaps

- none

## Evidence Requirements

- [x] doctrine, bundle, and live working-rules updates for batch 3.1
- [x] validation output for the lightweight checker batch
- [x] batch log for the proof pass and next-slice finding

## Completion Notes

This milestone now has a full three-step chain:

- currentness surfaces and refresh rules are explicit
- deterministic stale states are checked mechanically
- the remaining ambiguity is recorded as a curation problem, not an alignment
  gap

That proof closed `g02.003` and opened `g02.004` around currentness curation
and evidence-window guidance.

## Next Task

Start `g02.004` batch `4.1` by defining the currentness curation rules and
evidence-window policy in doctrine, bundle, and live working rules.
