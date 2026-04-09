# 012 - Define Full Strict Compliance Migration Program

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.011
Vision tags: `migration`, `strict-compliance`, `operators`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/015-full-strict-compliance-migration-program.md`
Planning state: ready

## Problem

Northstar now has a usable lane-first entry path into the strict doctrine, but
it does not yet define a reusable migration program for taking mature projects
to full strict compliance.

## Goals

- [x] define the full strict-compliance target state and migration phases
- [ ] apply the migration-program guidance to Northstar surfaces
- [x] re-prove the migration surface

## Non-Goals

- [ ] migrating any one consumer repo inside this lane
- [ ] normalizing indefinite mixed-mode operation

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 12.1 - Define Full Strict Target State

- [x] define the full strict-compliance target state
- [x] define the migration phases and checkpoints
- [x] leave the application batch explicit and ready

### Batch 12.2 - Apply Migration Program Guidance

- [x] apply the migration-program guidance to doctrine, setup, and template
      surfaces
- [x] refresh currentness/check surfaces affected by those changes
- [x] leave the re-proof batch explicit and ready

### Batch 12.3 - Reprove Full Strict Migration Surface

- [x] re-prove the migration path after the guidance update
- [x] open another slice only if a bounded problem remains

## Acceptance Criteria

- [x] The full strict-compliance target state is explicit.
- [x] The migration-program guidance is materially reflected in Northstar.
- [x] The full strict-compliance migration surface is re-proved.

## Planning Gaps

- none

## Evidence Requirements

- [x] definition log for the migration program
- [x] consolidation log for the migration-program guidance
- [x] re-proof log for the full strict-compliance migration surface

## Completion Notes

`g02.012` closed the reusable migration-path question cleanly:

- full strict compliance is now defined as a real project-level operating state
- the migration phases and checkpoints are explicit
- the path from baseline or lane-first posture to full compliance is now clear
  enough to use

The next missing piece is operational rollout: how to audit real projects,
classify where they sit in the migration, and drive that transition without
reinventing the process each time.

## Next Task

Start `g02.013` batch `13.1` by defining the strict-compliance audit and
rollout surface for real project migrations.
