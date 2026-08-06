# 022 - Add Lightweight Currentness Checks

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md
Roadmap refs: g02.003 batch 3.2
Governing refs: docs/contracts/001-working-rules.md, docs/roadmaps/generation-index.md, scripts/check-northstar-repo-contract.rhai
Auto-start next card: yes, if the proof pass is explicit

## Objective

Add lightweight deterministic checks for the live repo's most predictable
currentness surfaces so stale front doors are less likely to survive milestone
churn.

## Scope

- define a bounded set of live surfaces that should match the active lane
- update the repo-owned check path to verify those surfaces
- avoid turning the checker into a generic docs-state inference engine

## Steps

1. Decide which currentness surfaces are deterministic enough to check.
2. Extend the live repo checker for those surfaces only.
3. Update the affected live docs if the new check exposes stale state.

## Acceptance Criteria

- the checker defends a small useful set of currentness surfaces
- the enforcement stays deterministic and repo-local
- the next batch can prove what still remains manual

## Evidence Required

- updated check path
- validation output showing the checks pass

## Stop Conditions

- the checker tries to infer too much repo intent
- the check surface grows beyond the clearly repeated drift pattern

## Completion Notes

Added lightweight deterministic checks for the live repo's most predictable
currentness surfaces:

- `docs/README.md`
- `docs/roadmaps/README.md`
- `docs/roadmaps/g02/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/contracts/contract-index.md`
- `docs/logs/README.md`

The checks intentionally stay repo-local and bounded. They defend the repeated
stale-state pattern the autonomy lane exposed without trying to infer every
possible docs-state transition.

## Next Task

Run the currentness path again and record what still depends on human judgment.
