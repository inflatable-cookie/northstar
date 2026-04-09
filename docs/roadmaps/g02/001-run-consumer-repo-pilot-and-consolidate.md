# 001 - Run Consumer-Repo Pilot And Consolidate

Status: complete
Owner: repo maintainers
Created: 2026-04-09
Depends on: g01.003
Vision tags: `operator-flow`, `external-proof`, `consolidation`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md`
Planning state: ready

## Problem

Northstar has internally proven its delivery framework and execution mechanics,
but it still needs an external proof pass against a real consumer repo to
confirm which operator surfaces actually earn their keep.

## Goals

- Run the first real consumer-repo Northstar pilot.
- Capture the real operator path and the real decision friction.
- Consolidate or trim low-value operator surfaces based on evidence.
- Use that evidence to define the next Northstar improvement lane.

## Non-Goals

- Reopening the internal foundation work already completed in `g01`.
- Adding more doctrine before the external pilot runs.
- Growing the skill surface.

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only until the pilot target is selected.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 1.1 - Select the pilot target

- [x] Define the target-repo selection criteria.
- [x] Tighten the pilot evidence contract if needed.
- [x] Record the selected consumer repo or the immediate target-selection step.

### Batch 1.2 - Run the first real pilot

- [x] Run the operator workflow drill against the selected consumer repo.
- [x] Fill the pilot record from real use.
- [x] Extract the concrete consolidation and routing fixes the evidence supports.

### Batch 1.3 - Apply the consolidation

- [x] Apply the pilot-backed consolidation or trim decisions.
- [x] Validate and log the result.
- [x] Close the generation cleanly.

## Acceptance Criteria

- [x] One real consumer-repo pilot has been run and recorded.
- [x] The operator decision path is evidenced rather than inferred.
- [x] At least one concrete consolidation or trim lands from pilot findings.
- [x] The next improvement lane is based on external evidence.

## Risks and Mitigations

- Risk: the work stays internal and never reaches a real consumer repo.
- Mitigation: make target selection the first explicit batch and treat it as a
  hard gate.
- Risk: consolidation becomes speculative or cosmetic.
- Mitigation: require every trim or merge to trace back to the pilot record.

## Planning Gaps

- none

## Evidence Requirements

- [x] Completed pilot record for the selected repo.
- [x] Batch-level logs for the pilot and consolidation work.
- [x] Validation commands actually run after the consolidation batch.

## Next Task

Continue `g02` with `002-tighten-execution-guardrails-and-extend-autonomy.md`
now that the first external pilot and consolidation pass are complete.
