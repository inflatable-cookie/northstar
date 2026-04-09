# 10 131500 - Apply Consumer-Repo Autonomy Findings And Open Stricter Adoption Lane

## Summary

Closed `g02.009` by applying the bounded finding from the Signal proof:
roadmap-only repos are still valid, but the fuller continuation-envelope,
lane-budget, and pause-signal model should be treated as a stricter
`specs/` plus batch-card capability rather than assumed from baseline surfaces.

Opened `g02.010` to prove that stricter adoption threshold against a real
active consumer repo instead of extending doctrine without another external
check.

## Evidence

- updated `bundle-docs` doctrine so baseline and stricter autonomy support are
  described explicitly
- updated `northstar-setup` adoption guidance so setup can explain when
  roadmap-only mode is enough and when the stricter layer is warranted
- updated template guidance so downstream repos inherit the same distinction
- closed the `g02.009` spec, batch card, and roadmap surfaces
- opened `g02.010` with an explicit external-proof lane and ready next batch

## Validation

- `effigy qa`
- `effigy qa:docs`

## Continuation Note

- Remaining continuation envelope: one ready next card remains in-bounds,
  `g02.010` batch `10.2`
- Lane budget / pause signal: `handoff-required`

## Next Task

Start `g02.010` batch `10.2` by testing the stricter delivery-layer adoption
threshold against a real active consumer-repo lane.
