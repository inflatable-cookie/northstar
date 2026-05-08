# 050 - Reprove Full Strict Migration Surface

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/015-full-strict-compliance-migration-program.md
Roadmap refs: g02.012 batch 12.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/015-full-strict-compliance-migration-program.md
Auto-start next card: yes, if the next slice is explicit

## Objective

Re-prove the full strict-compliance migration surface after the program
guidance update.

## Scope

- verify the migration path is now clear enough to use across real projects
- confirm whether another bounded slice is still justified

## Steps

1. Re-run the migration path against the updated Northstar surfaces.
2. Record what is now explicit and what still depends on operator judgment.
3. Open another slice only if a bounded ambiguity remains.

## Acceptance Criteria

- the full strict-compliance migration surface is re-proved
- another slice opens only if warranted

## Evidence Required

- re-proof log
- updated roadmap/spec state if another slice opens

## Stop Conditions

- the re-proof batch starts inventing new doctrine without a concrete ambiguity

## Completion Notes

The migration path to full strict compliance is now good enough to use across
real projects.

The remaining gap is operational rather than doctrinal: Northstar still needs a
reusable way to audit a live project, classify its migration phase, and drive a
deliberate rollout toward full strict compliance without improvising the same
questions every time.

## Next Task

Start `g02.013` batch `13.1` by defining the strict-compliance audit and
rollout surface for real project migrations.
