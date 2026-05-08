# 014 - Lane-First Stricter Adoption Starter Pack

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.011

## Problem

Northstar now knows that mature baseline repos may need lane-first stricter
adoption. The remaining problem is practical: the migration path is described,
but not yet compact enough to seed quickly in a real repo without guesswork.
At the same time, lane-first adoption must be framed correctly: as the entry
path toward full stricter compliance where that is the intended project
destination.

## Target Operating Model

Northstar should offer a minimal starter pack for lane-first stricter adoption:

- only the active lane gets the stricter `specs/` plus batch-card layer
- the repo's healthy baseline spine remains intact
- setup and planning guidance show the minimum files and migration order
- the starter pack makes the broader migration target explicit instead of
  normalizing indefinite mixed-mode operation

## Goals

- define the minimum lane-first stricter adoption starter pack
- define the migration sequence for adding it to a mature baseline repo
- keep the starter pack lean enough that operators can use it without a repo
  rewrite
- make full stricter compliance the explicit destination where projects are
  expected to live under the strict doctrine

## Non-Goals

- converting all mature baseline repos to full stricter mode
- treating lane-first starter packs as the permanent end state for projects
  that are expected to reach full strict compliance
- backfilling closed history just for symmetry
- adding another broad autonomy abstraction

## Artifact Set

- docs/roadmaps/g02/011-define-lane-first-stricter-adoption-starter-pack.md
- docs/roadmaps/g02/batch-cards/045-define-lane-first-starter-pack.md
- docs/roadmaps/g02/batch-cards/046-apply-lane-first-starter-pack-guidance.md
- docs/roadmaps/g02/batch-cards/047-reprove-lane-first-adoption-surface.md

## Acceptance Criteria

- the lane-first starter pack is explicit
- the migration order is explicit
- the guidance makes clear that lane-first adoption is the way in, not the
  final doctrinal destination where full strict compliance is expected
- the next application batch is ready

## Stop Conditions

- the starter pack grows into a full stricter-mode rewrite
- the lane starts requiring closed-history backfill

## Next Task

Start `g02.012` batch `12.1` by defining the full strict-compliance migration
program for mature Northstar projects.
