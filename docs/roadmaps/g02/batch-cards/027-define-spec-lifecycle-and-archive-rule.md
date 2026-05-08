# 027 - Define Spec Lifecycle And Archive Rule

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/008-spec-lifecycle-and-archive-mechanics.md
Roadmap refs: g02.005 batch 5.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/README.md, template-bundle/specs/README.md
Auto-start next card: yes, if the live-application batch is explicit

## Objective

Define when specs stay active, retire in place, or move into an archive
surface.

## Scope

- define the lifecycle states for master specs and batch-card lanes
- define a lean archive posture for closed planning artifacts
- make the rule reusable in doctrine, the bundle, and live working rules

## Steps

1. Define the lifecycle states for specs and batch-card lanes.
2. Define the archive layout and trigger.
3. Promote the rule into doctrine, the bundle, and live working rules.

## Acceptance Criteria

- the lifecycle rule is explicit enough to apply to a real repo
- the archive posture is lean and reuse-ready
- the live-application batch is explicit

## Evidence Required

- updated doctrine, bundle, and live working-rules surfaces
- next ready application batch

## Stop Conditions

- the rule stays too vague to guide cleanup
- the archive posture becomes heavier than the active clutter it is solving

## Completion Notes

Defined the lifecycle states as `active`, `retired-in-place`, and `archived`,
made `retired-in-place` explicitly short-lived, and set `docs/specs/archive/`
as the lean preservation surface for closed planning artifacts that still merit
traceability. The rule now exists in doctrine, the bundle, and live working
rules so the live cleanup batch can apply it directly.

## Next Task

Start `g02.005` batch `5.2` by applying the lifecycle rule to the live
Northstar specs surface.
