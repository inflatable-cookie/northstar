# Roadmap g01.002 Batch 2.1 Contract Delta

Status: draft
Created: YYYY-MM-DD
Roadmap: g01.002
Batch: 2.1 - Planning repair and seam ownership
Cycle scope: converted the blocked analytics export seam into an explicit contract

## Summary

- Resolved the authoritative owner of the analytics export seam.
- Drafted the missing seam contract and updated planning artifacts to point to
  it.
- Left execution blocked until the roadmap milestone was recompiled against the
  new contract.

## Changes

1. Added `003-analytics-export-contract.md` to cover source, consumer, and
   failure semantics.
2. Updated `contract-index.md` to move the seam from pending to active.
3. Updated architecture and repo authority surfaces so export ownership is
   explicit.

## Validation Performed

1. Manual checks:
- Verified the seam now has a named source repo, consumer repo, and authority
  owner.
- Verified the missing contract no longer appears in the pending list.

2. Commands executed:
- `rg -n "003-analytics-export-contract|analytics export|pending|active" docs/architecture docs/contracts`
- Result: pass

3. Automation changes (optional):
- none

## Evidence

- `docs/contracts/003-analytics-export-contract.md`
- `docs/contracts/contract-index.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md`

## Risks

- The roadmap is still stale until its execution plan and acceptance criteria
  are recompiled against the new seam contract.

## Next Task

Recompile `g01.002` so its planning state, batch list, and evidence
requirements match the new analytics export contract.
