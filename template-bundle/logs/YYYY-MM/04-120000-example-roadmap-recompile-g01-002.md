# Roadmap g01.002 Batch 2.2 Recompile

Status: draft
Created: YYYY-MM-DD
Roadmap: g01.002
Batch: 2.2 - Recompile and execute the first contract-valid export slice
Cycle scope: recompiled the blocked export milestone after the seam contract was approved

## Summary

- Recompiled `g01.002` from a blocked planning-repair milestone into a
  contract-backed execution milestone.
- Updated contract refs, planning state, and evidence requirements to match the
  newly approved export seam.
- Left the next execution batch ready without carrying forward stale planning
  assumptions.

## Changes

1. Changed `g01.002` planning state from `blocked on planning` to `ready`.
2. Replaced planning-gap-only tasks with the first executable export batch.
3. Updated acceptance criteria and evidence requirements to reference the seam
   contract directly.

## Validation Performed

1. Manual checks:
- Verified the roadmap milestone no longer references unresolved ownership.
- Verified the milestone's contract refs match the contract index and authority
  map.

2. Commands executed:
- `rg -n "g01\.002|Contract refs|Planning state|Planning Gaps" docs/roadmaps docs/contracts docs/architecture`
- Result: pass

3. Automation changes (optional):
- none

## Evidence

- `docs/roadmaps/g01/002-example-analytics-export.md`
- `docs/contracts/003-analytics-export-contract.md`
- `docs/contracts/contract-index.md`
- `docs/architecture/repo-authority-map.md`

## Risks

- Export implementation still needs normal execution validation; the recompile
  only proves the plan is now coherent.

## Next Task

Execute the first contract-valid export batch and publish its batch closure log.
