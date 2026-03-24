# Roadmap g02.001 Batch 1.1 Contract Delta

Status: draft
Created: YYYY-MM-DD
Roadmap: g02.001
Batch: 1.1 - Reset active queue and first valid platform slice
Cycle scope: created the new topology and runtime-boundary contracts for the post-rollover queue

## Summary

- Added the contracts that define the refocused platform topology.
- Updated planning surfaces to make the new repo ownership and runtime boundary
  explicit.
- Kept execution on hold until `g02.001` reflected the new contract chain.

## Changes

1. Added `004-platform-topology-contract.md` for the new authority split.
2. Added `005-runtime-boundary-contract.md` for the runtime seam that changed
   sequencing across the program.
3. Updated inventory, repo authority, and contract index surfaces to support
   `g02`.

## Validation Performed

1. Manual checks:
- Verified the new contracts cover the topology shift that invalidated `g01`.
- Verified `g02.001` contract refs can point only to current contracts.

2. Commands executed:
- `rg -n "004-platform-topology-contract|005-runtime-boundary-contract|g02\\.001" docs/architecture docs/contracts docs/roadmaps`
- Result: pass

3. Automation changes (optional):
- none

## Evidence

- `docs/contracts/004-platform-topology-contract.md`
- `docs/contracts/005-runtime-boundary-contract.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md`

## Risks

- The new generation will drift immediately if stale `g01` references are not
  cleaned up in the same batch.

## Next Task

Finalize `g02.001`, supersede stale `g01` references, and execute the first
contract-valid platform-reset batch.
