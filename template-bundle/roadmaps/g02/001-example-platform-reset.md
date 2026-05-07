# 001 - Example Platform Reset

**Type: EXAMPLE** -- Illustrates a generation rollover. Remove from your project after reading.

Status: ready
Owner: Core Team
Created: YYYY-MM-DD
Depends on: none
Vision tags: `ALIGN`, `RELIABILITY`, `OPS`
Contract refs: `004-platform-topology-contract.md`, `005-runtime-boundary-contract.md`
Planning state: ready

## Problem

The original `g01` roadmap assumed a stable three-repo topology, but refocus
work revealed a broader platform split and ownership change that invalidated
multiple queued milestones. The old generation is no longer a trustworthy
execution baseline.

## Goals

- [ ] Replace stale `g01` assumptions with a new contract-backed platform
      sequence.
- [ ] Re-establish one trustworthy active queue under `g02`.
- [ ] Resume execution only from work that reflects the new repo topology.

## Non-Goals

- [ ] No further execution from superseded `g01` milestones.
- [ ] No compatibility storytelling that preserves the old sequencing baseline.

## Contract Coverage

- [ ] `004-platform-topology-contract.md` defines the new authority split across
      platform repos.
- [ ] `005-runtime-boundary-contract.md` defines the runtime seam that changed
      sequencing across the program.
- [ ] Superseded `g01` milestones remain visible for traceability but are not
      part of the active queue.

## Execution Plan

### Batch 1.1 - Reset active queue and first valid platform slice

- [ ] Mark stale `g01` milestones superseded and update references to the new
      generation.
- [ ] Confirm `g02` contract refs match architecture, inventory, and authority
      surfaces.
- [ ] Execute the first platform-reset batch against the new topology.

## Acceptance Criteria

- [ ] `generation-index.md` clearly records why `g02` replaced `g01`.
- [ ] Active roadmap work no longer depends on stale topology assumptions.
- [ ] The first `g02` batch is directly backed by current contracts.

## Risks and Mitigations

- Risk: teams continue reading `g01` as active because the rollover was only
  implied.
- Mitigation: mark stale milestones superseded, log the rollover clearly, and
  treat `g02` as the only active queue.

## Planning Gaps

- `none`

## Evidence Requirements

- [ ] rollover decision log explaining why in-generation repair was rejected
- [ ] contract-delta log showing the new topology contracts
- [ ] batch closure log for the first `g02` execution slice

## Next Task

Execute Batch 1.1 and publish the first `g02` closure log after stale `g01`
items are explicitly superseded.
