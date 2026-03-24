# Roadmap Rollover Decision g02

Status: draft
Created: YYYY-MM-DD
Roadmap: g01 -> g02
Batch: rollover decision
Cycle scope: determined that refocus invalidated the current generation baseline and required a new active queue

## Summary

- Audited the post-refocus planning surfaces after wider platform ownership
  changes.
- Determined that multiple `g01` milestones relied on stale topology and runtime
  assumptions.
- Rejected in-generation recompilation and opened `g02` as the new active
  sequence.

## Changes

1. Marked affected `g01` milestones superseded or blocked for traceability.
2. Recorded the rollover reason in `generation-index.md`.
3. Declared `g02` the only active queue for continuing execution.

## Validation Performed

1. Manual checks:
- Verified more than one queued `g01` milestone depended on the invalidated
  topology.
- Verified the new authority split changed sequencing beyond a localized seam
  repair.

2. Commands executed:
- `rg -n "g01\\.|g02\\.|superseded|Active generation|Generation log" docs/roadmaps docs/logs`
- Result: pass

3. Automation changes (optional):
- none

## Evidence

- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/g01/`
- `docs/roadmaps/g02/001-example-platform-reset.md`

## Risks

- Teams may keep reading old `g01` files as current unless the rollover is
  reinforced in roadmap and handoff surfaces.

## Next Task

Create the new topology contracts and recompile the first `g02` milestone from
those contracts.
