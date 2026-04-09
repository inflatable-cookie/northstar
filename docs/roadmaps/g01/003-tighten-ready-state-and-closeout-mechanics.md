# 003 - Tighten Ready-State And Closeout Mechanics

Status: complete
Owner: repo maintainers
Created: 2026-04-08
Depends on: g01.002
Vision tags: `autonomy`, `execution`, `closeout`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/archive/003-ready-state-and-closeout-mechanics.md`
Planning state: complete

## Problem

Northstar can now support longer uninterrupted lanes, but agents still need too
much manual judgment to decide which next cards are truly ready and to close a
lane cleanly once a batch ends.

## Goals

- Define a concrete ready-state rubric for cards and short autonomous chains.
- Define a concrete closeout pattern for batch, milestone, log, and handoff
  updates.
- Promote those mechanics into reusable Northstar surfaces.
- Apply the mechanics to Northstar itself and prove them in a live lane.

## Non-Goals

- Adding new public skills.
- Reopening already-settled delivery-layer doctrine.
- Building full automation for every planning-state update.

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 3.1 - Define the ready-state rubric

- [x] Add the ready-state rubric to doctrine and the live working rules.
- [x] Update roadmap and batch-card templates so readiness is explicit in file
      state rather than implied.
- [x] Align `northstar-plan` with the same readiness checks.

### Batch 3.2 - Define the closeout pattern

- [x] Add the closeout pattern to doctrine and the live working rules.
- [x] Update the reusable log, batch-card, and handoff surfaces.
- [x] Align `northstar-handoff` with the same closeout sequence.

### Batch 3.3 - Apply and prove the mechanics

- [x] Tighten the live repo checks around readiness and closeout expectations.
- [x] Run one live follow-on lane using the new mechanics.
- [x] Validate and log the result.

## Acceptance Criteria

- [x] The repo defines what makes a card ready and what makes a short chain
      safe for auto-continuation.
- [x] The repo defines a concrete closeout sequence for meaningful batches.
- [x] The reusable bundle and live repo surfaces expose the same mechanics.
- [x] A follow-on live lane uses the mechanics in practice.

## Risks and Mitigations

- Risk: the milestone adds more wording without making decisions easier.
- Mitigation: require the mechanics to appear in templates, skills, and checks.
- Risk: the readiness rubric becomes too loose to be useful.
- Mitigation: keep it tied to visible file-state and governing refs.

## Planning Gaps

- none

## Evidence Requirements

- [x] One batch log for the milestone's completed execution lane.
- [x] Manual validation checks and commands actually run.
- [x] Follow-on log showing whether the new mechanics improved live use.

## Next Task

Decide whether the next improvement still belongs in `g01` or merits a clean
new generation.
