# Compile Ready-State And Closeout Milestone

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.003
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/003-ready-state-and-closeout-mechanics.md

## Summary

Compiled the next live Northstar milestone from the autonomy-pilot and
runtime-policy findings so the next work targets the remaining real execution
friction: ready-state selection and lane closeout.

## Files Changed

- added `docs/specs/archive/003-ready-state-and-closeout-mechanics.md`
- added batch cards `011`, `012`, and `013`
- added `docs/roadmaps/g01/003-tighten-ready-state-and-closeout-mechanics.md`
- updated `docs/roadmaps/g01/README.md` and `docs/roadmaps/generation-index.md`
- updated `docs/contracts/contract-index.md`
- updated live docs and working-rules next-task chains

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the next live lane is now explicit and bounded
- the work is grouped around the two real unresolved limits from the recent
  pilots instead of reopening broader doctrine
- `g01.003` is ready to start at batch 3.1

## Unresolved

- the ready-state rubric itself still needs to be written
- the closeout pattern itself still needs to be written and proven live

## Next Task

Start batch 3.1 by defining the ready-state rubric in doctrine, working rules,
and reusable planning templates.
