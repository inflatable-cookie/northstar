# Open Currentness Alignment Lane

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.003 batch 3.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md

## Summary

Opened the next `g02` lane around currentness-surface alignment and lightweight
checks, based directly on the findings from the completed autonomy run.

## Files Changed

- updated `bundle-docs/sections/03-roadmaps.md`
- updated `bundle-docs/sections/04-logs.md`
- updated `template-bundle/roadmaps/README.md`
- updated `template-bundle/logs/README.md`
- updated `docs/contracts/001-working-rules.md`
- updated `docs/contracts/contract-index.md`
- added `docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md`
- added `docs/roadmaps/g02/batch-cards/021-define-currentness-surfaces-and-refresh-rule.md`
- added `docs/roadmaps/g02/batch-cards/022-add-lightweight-currentness-checks.md`
- added `docs/roadmaps/g02/003-tighten-currentness-surfaces-and-alignment-checks.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- Northstar now explicitly defines which surfaces count as currentness front
  doors and when they should be refreshed
- the next `g02` lane is focused on bounded currentness alignment checks rather
  than more generic doctrine work
- batch `3.2` is ready as the next meaningful slice

## Unresolved

- the lightweight currentness check is not implemented yet
- the proof pass showing what still remains manual has not been run yet

## Next Task

Start `g02.003` batch `3.2` by adding lightweight deterministic checks for the
most predictable currentness surfaces in the live Northstar repo.
