# 011 - Define Lane-First Stricter Adoption Starter Pack

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.010
Vision tags: `autonomy`, `adoption`, `migration`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/014-lane-first-stricter-adoption-starter-pack.md`
Planning state: ready

## Problem

Northstar now supports lane-first stricter adoption in principle, but the
starter pack and migration sequence are not yet compact enough to seed quickly
in a mature baseline repo. The migration also needs to be framed correctly:
lane-first is the way in, not the final destination for projects that are
expected to reach full strict compliance.

## Goals

- [x] define the lane-first stricter adoption starter pack
- [ ] apply the starter-pack guidance to Northstar surfaces
- [ ] re-prove the lane-first adoption surface

## Non-Goals

- [ ] rewriting mature baseline repos into full stricter mode
- [ ] treating lane-first starter packs as the permanent end state where full
      strict compliance is the intended project target
- [ ] backfilling closed history for symmetry

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 11.1 - Define Lane-First Starter Pack

- [x] define the minimum starter-pack files and migration order
- [x] leave the application batch explicit and ready

### Batch 11.2 - Apply Lane-First Starter-Pack Guidance

- [x] apply the starter-pack guidance to setup, doctrine, and template surfaces
- [x] refresh currentness/check surfaces affected by those changes
- [x] leave the re-proof batch explicit and ready

### Batch 11.3 - Reprove Lane-First Adoption Surface

- [ ] re-prove the lane-first adoption path after the guidance update
- [ ] open another slice only if a bounded problem remains

## Acceptance Criteria

- [x] The lane-first starter pack is explicit.
- [x] The starter-pack guidance is materially reflected in Northstar.
- [x] The lane-first adoption surface is re-proved.

## Planning Gaps

- none

## Evidence Requirements

- [x] definition log for the lane-first starter pack
- [x] consolidation log for the starter-pack guidance
- [x] re-proof log for the lane-first adoption surface

## Completion Notes

`g02.011` closed the lane-first migration question cleanly:

- the easy-in path is now explicit
- the doctrine now states clearly that full strict compliance remains the
  intended destination where projects are meant to live under the strict
  framework
- the next missing piece is a deliberate migration program for taking mature
  projects from mixed posture to full compliance

## Next Task

Start `g02.012` batch `12.1` by defining the full strict-compliance migration
program for mature Northstar projects.
