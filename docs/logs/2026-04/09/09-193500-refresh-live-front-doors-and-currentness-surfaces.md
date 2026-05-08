# Refresh Live Front Doors And Currentness Surfaces

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.002 batch 2.4
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md

## Summary

Ran a longer live Northstar lane under the tightened guardrails by refreshing
the repo's stale front doors and currentness surfaces so they now point at the
real active generation, milestone, and evidence chain.

## Files Changed

- updated `docs/README.md`
- updated `docs/roadmaps/README.md`
- updated `docs/roadmaps/g02/README.md`
- updated `docs/roadmaps/generation-index.md`
- updated `docs/contracts/contract-index.md`
- updated `docs/logs/README.md`
- updated `docs/roadmaps/g02/002-tighten-execution-guardrails-and-extend-autonomy.md`
- added `docs/roadmaps/g02/batch-cards/020-refresh-live-front-doors-and-currentness-surfaces.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Autonomy Findings

- stale front doors and currentness indexes drift faster than core doctrine
  because they are easy to leave behind after milestone churn
- the tightened guardrails helped because the lane stayed focused on real
  operator value rather than cosmetic doc edits
- the next useful improvement is not another doctrine expansion; it is tighter
  discipline or tooling around currentness surfaces so the live front doors stay
  aligned with the active lane

## Outcome

- `g02.002` is now complete
- the live repo entry points now reflect `g02` and the current evidence chain
- the autonomy run produced a concrete next improvement area instead of vague
  confidence

## Unresolved

- the next `g02` improvement slice has not been compiled yet
- currentness drift is now visible, but not yet systematically prevented

## Next Task

Decide the next `g02` improvement slice from the autonomy findings now that
`g02.002` is complete.
