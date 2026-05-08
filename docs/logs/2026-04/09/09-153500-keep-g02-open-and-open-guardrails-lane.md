# Keep g02 Open And Open Guardrails Lane

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.002 batch 2.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md

## Summary

Corrected Northstar's generation posture so `g02` remains the long-running
external-proof and execution-hardening generation, then opened `g02.002` as the
next active lane instead of preparing a premature `g03`.

## Files Changed

- updated `bundle-docs/sections/03-roadmaps.md`
- updated `bundle-docs/sections/07-delivery-framework-and-autonomy.md`
- updated `template-bundle/roadmaps/README.md`
- updated `template-bundle/roadmaps/generation-index.md`
- updated `docs/contracts/001-working-rules.md`
- updated `docs/roadmaps/generation-index.md`
- updated `docs/roadmaps/g02/README.md`
- updated `docs/README.md`
- updated `docs/specs/README.md`
- added `docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md`
- added `docs/roadmaps/g02/batch-cards/017-define-execution-guardrail-pack-and-keep-g02-open.md`
- added `docs/roadmaps/g02/batch-cards/018-promote-guardrails-into-bundle-and-skills.md`
- added `docs/roadmaps/g02/002-tighten-execution-guardrails-and-extend-autonomy.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- Northstar now explicitly treats generations as long-lived sequencing eras
  rather than tiny buckets of one or two milestone files
- the doctrine now includes an explicit execution guardrail pack aimed at fake
  completion, unnecessary complexity, and shallow follow-through
- `g02.002` is now open as the next active lane inside the same generation

## Unresolved

- the new guardrail pack still needs promotion into the reusable bundle and
  installed skills
- the longer autonomy lane still needs to be run and logged

## Next Task

Start `g02.002` batch 2.2 by promoting the execution guardrail pack into the
template bundle and installed Northstar skill surfaces.
