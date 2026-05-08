# 046 - Apply Lane-First Starter-Pack Guidance

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/014-lane-first-stricter-adoption-starter-pack.md
Roadmap refs: g02.011 batch 11.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/014-lane-first-stricter-adoption-starter-pack.md
Auto-start next card: yes, if the re-proof surface is explicit

## Objective

Apply the lane-first stricter adoption starter-pack guidance to Northstar's
setup, doctrine, and template surfaces.

## Scope

- keep the starter pack minimal and copy-ready
- avoid broad repo-wide stricter-mode rewrites
- leave the re-proof batch explicit and ready

## Steps

1. Apply the starter-pack guidance to setup and delivery-layer adoption docs.
2. Apply the same guidance to the reusable template and doctrine surfaces.
3. Refresh any currentness or checker surfaces affected by the changes.

## Acceptance Criteria

- the lane-first starter pack is materially reflected in Northstar
- the re-proof batch is explicit and ready

## Evidence Required

- consolidation log
- updated roadmap/spec state

## Stop Conditions

- the batch starts expanding beyond the bounded lane-first starter pack

## Completion Notes

Applied the lane-first starter-pack guidance across doctrine, setup, and
template surfaces.

The important clarification is now explicit:

- lane-first adoption is the migration entry point
- full strict compliance remains the intended destination for projects that are
  meant to live under the strict Northstar doctrine
- the starter pack should help projects enter the stricter model cleanly
  without normalizing indefinite mixed-mode operation

## Next Task

Start `g02.011` batch `11.3` by re-proving the lane-first starter-pack surface
after the guidance update.
