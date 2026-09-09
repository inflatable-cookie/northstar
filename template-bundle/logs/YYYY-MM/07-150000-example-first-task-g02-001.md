# Roadmap g02.001 Task Closure

**Type: EXAMPLE** -- Illustrates a post-rollover task closure. Remove from your project after reading.

Status: draft
Created: YYYY-MM-DD
Roadmap: g02.001
Task: g02.001 - Reset active queue and first valid platform slice
Cycle scope: executed the first post-rollover task from the new contract-backed generation

## Summary

- Executed the first `g02` task after the rollover and topology contract
  updates.
- Removed stale active references to superseded `g01` work.
- Re-established one trustworthy active queue for continuing delivery.

## Changes

1. Updated roadmap references and operator surfaces to point to `g02`.
2. Executed the first platform-reset implementation slice against the new
   topology contracts.
3. Published closure evidence proving the queue now runs from the refocused
   generation.

## Validation Performed

1. Manual checks:
- Verified `g02` is the only active generation referenced by current execution
  surfaces.
- Verified the executed task matched the new topology and runtime-boundary
  contracts.

2. Commands executed:
- `rg -n "g02\\.001|Active generation|superseded|Contract refs" docs/roadmaps docs/logs`
- Result: pass

3. Automation changes (optional):
- none

## Evidence

- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/g02/001-example-platform-reset.md`
- `docs/contracts/004-platform-topology-contract.md`
- `docs/contracts/005-runtime-boundary-contract.md`

## Risks

- Residual references to superseded `g01` work may still exist outside the main
  planning spine and should be cleaned as follow-up.

## Next Task

Compile the next `g02` task from the refocused contract set and continue
execution from the new queue only.
