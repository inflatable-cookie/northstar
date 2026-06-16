# 008 - Spec Lifecycle And Archive Mechanics

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.005

## Problem

Northstar now has a much clearer front-door path, but the underlying
`docs/specs/` surface still accumulates closed master specs and batch cards in
place. That weakens the protocol's claim that specs are provisional planning
surfaces and risks turning `docs/specs/` into a second archive rather than a
focused active-planning lane.

## Target Operating Model

Northstar should define a clean lifecycle for specs:

- active planning stays visible in `docs/specs/`
- completed or no-longer-governing specs can be retired without losing useful
  history
- batch-card accumulation should not drown the active planning lane
- archive or retirement mechanics should be explicit enough to reuse in other
  repos

## Goals

- define when a spec or batch-card lane should stay live, retire in place, or
  move into an archive surface
- define a lean archive layout for closed planning artifacts
- apply the rule to the live Northstar repo so `docs/specs/` mostly reflects
  active planning again
- prove that the resulting specs surface is easier to navigate without losing
  important planning history

## Non-Goals

- deleting planning history indiscriminately
- forcing every repo to archive on a fixed cadence regardless of scale
- turning spec cleanup into a heavyweight migration every time a lane closes

## Artifact Set

- `bundle-docs/sections/08-specs-and-promotion.md`
- `template-bundle/specs/README.md`
- `docs/contracts/001-working-rules.md`
- `docs/specs/README.md`
- `docs/roadmaps/g02/005-tighten-spec-lifecycle-and-archive-mechanics.md`

## Phased Delivery

### Phase 1

Define the lifecycle and archive rule in doctrine, bundle guidance, and the
live working rules.

### Phase 2

Apply that rule to the live Northstar repo by reducing stale in-place planning
artifacts.

### Phase 3

Re-prove the specs surface and record whether the archive posture is now clear
enough to reuse broadly.

## Acceptance Criteria

- Northstar doctrine defines a reusable spec-lifecycle and archive rule.
- The bundle gives downstream repos a clear way to keep `docs/specs/` focused
  on active planning.
- The live repo applies that rule to its own specs surface.
- The next batch is explicit and ready.

## Completion Notes

This spec delivered the lifecycle states, lean archive posture, live cleanup,
and the re-proof that the resulting specs surface is now focused enough to live
with. The remaining work is now about making that posture more explicit in the
reusable automation layer rather than changing the docs tree again.

## Stop Conditions

- the lane turns into a mass file move without a clear lifecycle rule
- the archive shape becomes heavier than the planning clutter it is trying to
  solve
- the work starts preserving every closed spec in the active tree "just in
  case"
