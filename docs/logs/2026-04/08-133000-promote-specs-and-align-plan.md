# Promote Specs And Align Plan

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.001 batch 1.2, g01.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/001-northstar-delivery-layer.md

## Summary

Promoted the minimum reusable specs-promotion artifacts into the template
bundle and aligned `northstar-plan` with the new rule that specs are
provisional and must promote settled outcomes into architecture/contracts
before roadmap execution.

## Files Changed

- added `template-bundle/specs/` with master-spec and batch-card templates
- updated bundle guidance to explain the specs-promotion model
- updated `northstar-plan` skill wording, planning modes, and metadata
- updated the live roadmap and added explicit batch cards for this work

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- downstream projects now have a copy-ready specs surface with an explicit
  promotion rule
- `northstar-plan` no longer treats roadmap compilation as something that can
  run directly from raw spec text
- the live repo roadmap reflects completed batch 1.2 work and the
  `northstar-plan` portion of batch 1.3

## Unresolved

- `northstar-setup` still needs to install the stricter guardrail pack by
  default where appropriate
- `northstar-recover` and `northstar-handoff` still need to preserve the active
  spec lane plus canonical promoted refs
- the autonomy envelope still needs a longer live pilot

## Next Task

Update `northstar-recover` and `northstar-handoff` so they preserve both the
active spec lane and the canonical promoted refs during continuation and
recovery work.
