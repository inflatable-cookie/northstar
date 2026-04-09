# Roll To g02 External Pilot

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.001
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md

## Summary

Rolled Northstar from `g01` into `g02` because the internal foundation and
mechanics work is now complete and the next meaningful phase is external proof
against a real consumer repo.

## Files Changed

- added `docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md`
- added batch cards `014`, `015`, and `016`
- added `docs/roadmaps/g02/001-run-consumer-repo-pilot-and-consolidate.md`
- added `docs/roadmaps/g02/README.md`
- updated `docs/roadmaps/generation-index.md`
- updated the live docs and contract next-task chains to point at `g02.001`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- `g01` now reads as a coherent internal-foundation generation instead of a
  bucket for every future improvement
- `g02` is explicitly the external-proof generation
- the next lane is now anchored on a real consumer-repo pilot rather than more
  internal iteration

## Unresolved

- the pilot target repo has not been selected yet
- the operator/consolidation surfaces still need external evidence before
  another round of trimming

## Next Task

Start `g02.001` batch 1.1 by selecting the consumer-repo pilot target and
tightening the pilot evidence contract if needed.
