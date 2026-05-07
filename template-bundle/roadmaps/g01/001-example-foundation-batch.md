# 001 - Example Foundation Batch

**Type: EXAMPLE** -- Shows what a completed milestone looks like. Remove from your project after reading.

Status: draft
Owner: Core Team
Created: YYYY-MM-DD
Depends on: none
Vision tags: `ALIGN`, `RELIABILITY`, `MAINT`
Contract refs: `001-session-and-role-contract.md`, `002-job-dispatch-contract.md`
Planning state: ready

## Problem

Teams need a repeatable execution model that keeps roadmap work focused, traceable, and lightweight.

## Goals

- [ ] Establish first active roadmap milestone with batch structure.
- [ ] Produce one batch-level closure log with explicit validation evidence.
- [ ] Confirm backlog and currentness rules are understood by maintainers.

## Non-Goals

- [ ] No full automation checker suite in this milestone.
- [ ] No framework-specific tooling mandates.

## Contract Coverage

- [ ] Session and role behavior is governed by `001-session-and-role-contract.md`.
- [ ] Async dispatch behavior is governed by `002-job-dispatch-contract.md`.
- [ ] No work in this milestone depends on the unresolved analytics export seam.

## Execution Plan

### Batch 1.1 - Foundation setup and first closure loop

- [ ] Finalize planning gate artifacts and confirm no active scope relies on
      pending contracts.
- [ ] Execute a small but meaningful contract-backed change against the defined
      criteria.
- [ ] Publish a batch closure log in `docs/logs/YYYY-MM/`.

## Acceptance Criteria

- [ ] First milestone file is traceable from vision and architecture.
- [ ] One batch-level log exists with `Validation Performed` completed.
- [ ] Next action is explicit and execution-ready.

## Risks and Mitigations

- Risk: logging overhead grows faster than delivery value.
- Mitigation: enforce batch-only logging cadence and lean evidence rules.

## Planning Gaps

- `none` for this milestone once analytics export work is kept out of scope

## Evidence Requirements

- [ ] one contract-delta log for Batch 1.1
- [ ] manual validation checks and executed commands listed in log
- [ ] no new checker scripts unless automation criteria are explicitly met

## Next Task

Execute Batch 1.1 and publish the first log for `g01.001`.
