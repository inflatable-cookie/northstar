# Align Recover And Handoff

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/001-northstar-delivery-layer.md

## Summary

Aligned `northstar-recover` and `northstar-handoff` with the specs-promotion
model so recovery and continuation work preserve both the active spec lane and
the canonical promoted refs that execution should trust.

## Files Changed

- updated `skills/northstar-recover/` to restore active specs and canonical refs
  during replans, refocus passes, and sweeps
- updated `skills/northstar-handoff/` so continuation briefs carry the active
  spec lane plus canonical promoted refs
- updated the live roadmap and batch-card chain for this work

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- `northstar-recover` no longer treats recovery as only roadmap/contract repair
- `northstar-handoff` no longer hands off only the immediate task and thread
  story; it also preserves the promoted authority surfaces
- the remaining open skill-alignment work is concentrated in `northstar-setup`
  and the longer autonomy pilot

## Unresolved

- `northstar-setup` still needs to install the delivery-layer guardrails and
  specs-promotion surfaces by default where appropriate
- the autonomy envelope still needs a longer live pilot

## Next Task

Update `northstar-setup` so stricter projects install the delivery-layer
guardrails and specs-promotion surfaces by default where appropriate.
