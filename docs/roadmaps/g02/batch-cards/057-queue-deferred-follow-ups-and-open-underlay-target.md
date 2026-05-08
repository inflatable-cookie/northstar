# 057 - Queue Deferred Follow-Ups And Open Underlay Target

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md
Roadmap refs: g02.015 batch 15.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md
Auto-start next card: no

## Objective

Record Jetstream and Loophole as explicit deferred strict-migration returns and
open Underlay as the active next recovery target.

## Scope

- update Northstar’s own currentness/front-door surfaces
- make the deferred follow-up queue explicit
- make Underlay the live next target

## Steps

1. Record Jetstream’s deferred return trigger.
2. Record Loophole’s deferred return trigger.
3. Open a Northstar lane for the Underlay recovery target.
4. Refresh the active Northstar front doors so they point at that lane.

## Acceptance Criteria

- Jetstream and Loophole are explicitly queued as deferred return targets
- Underlay is explicitly named as the active next recovery target
- Northstar’s front-door surfaces point at the new lane

## Evidence Required

- updated roadmap/spec/front-door surfaces
- batch log

## Stop Conditions

- the batch starts doing Underlay repo surgery before the recovery target is
  defined

## Completion Notes

- Jetstream remains intentionally parked at lane-first strict adoption while the
  current physics cycle is still exploratory.
- Loophole remains intentionally parked at planning-layer strict recovery while
  the recovered Chorus runway proves itself.
- Underlay is now the active next target because its docs posture says the
  Poodle translation/contraction line is complete while the real shared-surface
  overhaul clearly continues across multiple consumers.

## Next Task

Run the Underlay recovery audit and decide whether the repo needs only planning
surface repair or a stricter execution lane too.
