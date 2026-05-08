# Define Archive-Aware Skill Contract

Status: complete
Owner: repo maintainers
Date: 2026-04-10
Roadmap refs: g02.006 batch 6.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/009-archive-aware-skill-and-setup-surfaces.md

## Summary

Defined the archive-aware contract for the reusable automation layer. This
batch does not yet update the reusable skills themselves. It makes the intended
setup, planning, recovery, and bundle behavior explicit enough that the next
implementation batch can change those surfaces directly without reopening the
design question.

## Findings

The reusable contract needs to make four things explicit:

- setup should treat the archive surface as part of the stricter docs contract
  when `specs/` are installed
- planning should treat archive as part of normal lifecycle decisions rather
  than as occasional cleanup folklore
- recovery should inspect and repair both the active specs surface and the
  archive posture when stale planning is involved
- the bundle should expose the same archive-aware behavior without adding heavy
  automation

## Files Changed

- updated `docs/specs/009-archive-aware-skill-and-setup-surfaces.md`
- updated `docs/roadmaps/g02/batch-cards/030-define-archive-aware-skill-contract.md`
- updated `docs/roadmaps/g02/batch-cards/031-apply-archive-aware-skill-alignment.md`
- updated `docs/roadmaps/g02/006-align-archive-aware-skill-and-setup-surfaces.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the archive-aware contract is now explicit enough to implement
- the implementation batch is now the live next step

## Unresolved

- the reusable skills, bundle surfaces, and checks still need the actual
  archive-aware alignment pass

## Next Task

Start `g02.006` batch `6.2` by applying the archive-aware contract to the
reusable skills, bundle surfaces, and checks.
