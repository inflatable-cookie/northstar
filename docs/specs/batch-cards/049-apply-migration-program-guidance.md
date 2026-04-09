# 049 - Apply Migration Program Guidance

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/015-full-strict-compliance-migration-program.md
Roadmap refs: g02.012 batch 12.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/015-full-strict-compliance-migration-program.md
Auto-start next card: yes, if the re-proof surface is explicit

## Objective

Apply the full strict-compliance migration-program guidance to Northstar's
doctrine, setup, and template surfaces.

## Scope

- make the migration program copyable and operational
- avoid repo-specific migration detail
- leave the re-proof batch explicit and ready

## Steps

1. Apply the target-state and migration-phase guidance to doctrine.
2. Apply the same guidance to setup and template surfaces.
3. Refresh any currentness or checker surfaces affected by the changes.

## Acceptance Criteria

- the migration program is materially reflected in Northstar
- the re-proof batch is explicit and ready

## Evidence Required

- consolidation log
- updated roadmap/spec state

## Stop Conditions

- the batch starts drifting into one repo's concrete migration work

## Completion Notes

Applied the full strict-compliance migration program across doctrine, setup,
and template surfaces.

The main reusable additions are now explicit:

- what full strict compliance means at project level
- the migration phases from baseline or lane-first posture to full compliance
- the checkpoints that separate valid migration state from indefinite mixed-mode
  drift

## Next Task

Start `g02.012` batch `12.3` by re-proving the full strict-compliance
migration surface after the guidance update.
