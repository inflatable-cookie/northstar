# Add Lightweight Currentness Checks

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.003 batch 3.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md

## Summary

Added lightweight deterministic checks for the most predictable currentness
surfaces in the live Northstar repo and refreshed the affected front doors so
they match the active `g02.003` lane.

## Files Changed

- updated `docs/README.md`
- updated `docs/roadmaps/README.md`
- updated `docs/roadmaps/g02/README.md`
- updated `docs/roadmaps/generation-index.md`
- updated `docs/logs/README.md`
- updated `scripts/check-northstar-repo-contract.ts`
- updated `docs/roadmaps/g02/batch-cards/022-add-lightweight-currentness-checks.md`
- updated `docs/roadmaps/g02/003-tighten-currentness-surfaces-and-alignment-checks.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the live repo now checks a bounded deterministic set of currentness surfaces
  instead of relying only on memory or occasional cleanup
- the check scope stays narrow and repo-local rather than turning into a
  generic docs-state inference engine
- batch `3.3` is now the right place to prove what still remains manual

## Unresolved

- some currentness decisions still require human judgment, especially around
  how much evidence to surface in readmes and when to use currentness triage
  logs
- the proof pass has not been run yet

## Next Task

Start `g02.003` batch `3.3` by running the currentness path again and
recording what still depends on human judgment after the new checks.
