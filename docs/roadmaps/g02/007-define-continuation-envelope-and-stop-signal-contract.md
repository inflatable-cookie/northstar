# 007 - Define Continuation Envelope And Stop-Signal Contract

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.006
Vision tags: `autonomy`, `execution`, `handoff`, `batch-cards`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/010-continuation-envelope-and-stop-signal-contract.md`
Planning state: ready

## Problem

Northstar has stronger ready-state, closeout, and archive posture now, but the
system still leaves autonomous continuation too implicit. Agents can tell when
one card is ready, yet they still lack a compact contract for how far they may
continue through a chain and which stop signals should immediately halt that
continuation.

## Goals

- [x] define the continuation-envelope and stop-signal contract
- [ ] apply that contract to the reusable doctrine, template, and skill surfaces
- [ ] re-prove that the contract supports longer autonomous lanes cleanly

## Non-Goals

- [ ] building a workflow engine or persistent autonomous runner
- [ ] weakening stop conditions around planning gaps, validation failures, or
      user-facing ambiguity

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 7.1 - Define Continuation Envelope Contract

- [x] define the compact continuation-envelope contract
- [x] define explicit stop signals that override continuation
- [x] leave the implementation batch explicit and ready

### Batch 7.2 - Apply Continuation Envelope Contract

- [x] update the live and reusable doctrine/template surfaces
- [x] align planning and handoff surfaces with the same continuation model
- [x] refresh deterministic checks where expectations changed

### Batch 7.3 - Re-Prove The Continuation Envelope Contract

- [x] inspect one longer live lane through the updated continuation model
- [x] record any remaining bounded ambiguity
- [x] compile the next slice only if a bounded problem remains

## Acceptance Criteria

- [x] The continuation-envelope contract is explicit in the live planning
      surface.
- [x] The reusable surfaces reflect the same continuation and stop-signal
      posture.
- [x] The resulting continuation contract is re-proved after alignment.

## Risks and Mitigations

- Risk: the lane drifts into heavyweight orchestration ideas.
- Mitigation: keep the contract file-state oriented and limited to bounded
  continuation, validation, and stop signals.

- Risk: continuation logic weakens the existing stop conditions.
- Mitigation: treat failed validation, planning gaps, and design ambiguity as
  hard stop signals throughout the lane.

## Planning Gaps

- none

## Evidence Requirements

- [x] definition log for the continuation contract batch
- [x] implementation log for the continuation-surface alignment batch
- [x] re-proof log for the longer autonomous lane

## Next Task

Start `g02.008` batch `8.2` by applying the lane-budget and pause-signal
contract to the reusable doctrine, template, and handoff/log surfaces.
