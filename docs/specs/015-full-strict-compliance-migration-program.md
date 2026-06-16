# 015 - Full Strict Compliance Migration Program

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.012

## Problem

Northstar now has a usable lane-first entry path into the strict doctrine, but
it still lacks a deliberate migration program for taking mature projects all
the way to full strict compliance.

Without that, projects can enter the stricter model but still drift in a mixed
posture for too long, leaving operators to improvise when and how the rest of
the project should comply.

## Target Operating Model

Northstar should define a migration program that makes full strict compliance a
clear managed transition rather than an aspirational future state.

That program should answer:

- what full strict compliance actually means at project level
- what phases a mature project should move through
- what evidence should show a project is ready to progress
- when a project is still allowed to be mixed-mode and when that becomes drift

## Full Strict Target State

At minimum, a mature project should count as fully strict-compliant only when:

- the stricter docs spine exists as a standing project surface
- active material work uses specs and batch cards as the normal execution unit
- architecture, contracts, and roadmap compilation are kept aligned as routine
  work
- product guardrails, working rules, and contract indexing are explicit and
  current
- logs, closeout, handoff, currentness, and spec-hygiene expectations operate
  as normal practice rather than exceptional cleanup

## Migration Phases

Northstar should describe the migration to full compliance in four phases:

1. baseline posture
2. lane-first stricter adoption
3. expanding strict coverage across active material lanes
4. full strict compliance as the project default

## Migration Checkpoints

The migration program should also make explicit:

- what evidence shows a project is ready to move from one phase to the next
- when mixed posture is still valid migration state
- when mixed posture should be treated as drift or migration debt instead

## Goals

- define the full strict-compliance target state for mature projects
- define the migration phases from baseline or lane-first posture into full
  compliance
- define the minimum evidence and checkpoints for each phase

## Non-Goals

- migrating any specific consumer repo inside this batch
- rewriting the entire Northstar bundle around one repo's local quirks
- introducing another top-level skill

## Artifact Set

- docs/roadmaps/g02/012-define-full-strict-compliance-migration-program.md
- docs/roadmaps/g02/batch-cards/048-define-full-strict-target-state.md
- docs/roadmaps/g02/batch-cards/049-apply-migration-program-guidance.md
- docs/roadmaps/g02/batch-cards/050-reprove-full-strict-migration-surface.md

## Acceptance Criteria

- the full strict-compliance target is explicit
- the migration phases and checkpoints are explicit
- the next application batch is ready

## Stop Conditions

- the lane turns into a repo-specific migration without first defining the
  reusable program
- the guidance normalizes indefinite mixed-mode operation
