# Prove Currentness Path And Open Curation Lane

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.003 batch 3.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md

## Summary

Ran the currentness path again after the new checks and recorded what still
depends on human judgment. That proof closed `g02.003` and opened the next
`g02` lane around currentness curation and evidence-window rules.

## Findings

The lightweight checks now cover the predictable stale states, but these areas
still depend on human judgment:

- which active spec belongs on the main docs front door
- which active milestone deserves prominent surfacing across multiple readmes
- how much recent evidence should be surfaced in `docs/logs/README.md`
- when a dedicated currentness-triage log is worth writing instead of just
  relying on normal batch logs

Those are curation questions, not alignment-check questions.

## Files Changed

- added `docs/specs/archive/batch-cards/023-prove-currentness-path-and-compile-next-slice.md`
- added `docs/specs/archive/007-currentness-curation-and-evidence-window.md`
- added `docs/specs/archive/batch-cards/024-define-currentness-curation-rules.md`
- added `docs/roadmaps/g02/004-define-currentness-curation-and-evidence-window.md`
- updated `docs/README.md`
- updated `docs/roadmaps/README.md`
- updated `docs/roadmaps/g02/README.md`
- updated `docs/roadmaps/generation-index.md`
- updated `docs/contracts/contract-index.md`
- updated `docs/logs/README.md`
- updated `scripts/check-northstar-repo-contract.ts`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- `g02.003` is now complete
- the checker scope is clearly bounded
- the next lane is now about currentness curation and evidence windows rather
  than checker expansion

## Unresolved

- the curation rule and evidence-window policy still need to be defined and
  applied
- the front-door path still needs one more proof pass after that rule lands

## Next Task

Start `g02.004` batch `4.1` by defining the currentness curation rules and
evidence-window policy in doctrine, bundle, and live working rules.
