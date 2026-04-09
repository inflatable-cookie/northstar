# 013 - Apply Ready-State And Closeout Mechanics

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/003-ready-state-and-closeout-mechanics.md
Roadmap refs: g01.003 batch 3.3
Governing refs: docs/contracts/001-working-rules.md, scripts/check-northstar-repo-contract.ts, docs/logs/README.md
Auto-start next card: no

## Objective

Apply the new ready-state and closeout mechanics to the live Northstar repo and
prove that they make the next execution lane easier to choose and finish.

## Scope

- update the live repo checks around readiness and closeout expectations
- run one live follow-on lane using the new mechanics
- record the result in a batch log

## Steps

1. Tighten the live repo checks so the new readiness/closeout surfaces are
   defended.
2. Run a live follow-on lane using the ready-state rubric and closeout pattern.
3. Validate, update the milestone state, and log the outcome.

## Acceptance Criteria

- the live repo checks defend the new mechanics
- one follow-on lane uses the mechanics in practice
- the resulting log names what improved and what still remains awkward
- `effigy qa`
- `effigy qa:docs`

## Evidence Required

- updated repo checker logic
- validation commands recorded in the batch log
- one live follow-on log that references the new mechanics

## Stop Conditions

- the live lane still cannot use the readiness/closeout rules without heavy
  operator interpretation
- the repo checks become too brittle for normal planning work

## Completion Notes

The live repo checks now defend the new readiness and closeout mechanics, the
updated `northstar-plan` and `northstar-handoff` skills were synced into both
installed homes, and this batch itself used the new closeout order cleanly.

## Next Task

Decide whether the next improvement still belongs in `g01` or merits a clean
new generation.
