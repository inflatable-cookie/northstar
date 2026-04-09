# Re-Prove Specs Surface And Open Archive-Aware Lane

Status: complete
Owner: repo maintainers
Date: 2026-04-10
Roadmap refs: g02.005 batch 5.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/008-spec-lifecycle-and-archive-mechanics.md

## Summary

Re-proved the cleaned-up specs surface after the lifecycle update. The active
tree is now focused enough to live with, and the remaining bounded gap has
moved into the reusable automation layer rather than the docs tree itself.

## Findings

The active specs path is now materially clearer:

- `docs/specs/` contains one live master spec plus the active card pair for the
  current lane
- closed planning history remains traceable under `docs/specs/archive/`
- the archive is lean enough to avoid acting like a second live planning lane

The remaining gap is that setup, planning, and recovery surfaces do not yet
make the archive posture explicit enough for downstream repos to inherit it
reliably without extra interpretation.

## Files Changed

- added `docs/specs/009-archive-aware-skill-and-setup-surfaces.md`
- added `docs/specs/batch-cards/030-define-archive-aware-skill-contract.md`
- added `docs/specs/batch-cards/031-apply-archive-aware-skill-alignment.md`
- added `docs/specs/batch-cards/032-reprove-archive-aware-surface.md`
- added `docs/roadmaps/g02/006-align-archive-aware-skill-and-setup-surfaces.md`
- updated `docs/specs/batch-cards/029-reprove-specs-surface-after-lifecycle-update.md`
- updated `docs/specs/008-spec-lifecycle-and-archive-mechanics.md`
- updated `docs/roadmaps/g02/005-tighten-spec-lifecycle-and-archive-mechanics.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- `g02.005` is now complete
- the cleaned-up specs surface is clear enough to live with
- `g02.006` is now open around archive-aware reusable surfaces

## Unresolved

- the setup, planning, and recovery surfaces still need archive-aware
  alignment work

## Next Task

Start `g02.006` batch `6.1` by defining the archive-aware setup, planning, and
recovery contract across skills and bundle guidance.
