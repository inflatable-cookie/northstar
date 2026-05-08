# 016 - Strict Compliance Audit And Rollout

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.013

## Problem

Northstar now defines the path to full strict compliance, but it still needs a
compact operational surface for applying that path to real projects.

Without that, operators still have to improvise:

- how to audit a repo's current posture
- how to classify its migration phase
- how to decide what has to change next
- how to track rollout progress across multiple projects

## Target Operating Model

Northstar should provide a compact audit and rollout surface that lets
operators:

- assess a project's current compliance posture
- classify it against the migration phases
- define the next migration tranche deliberately
- track rollout toward full strict compliance without ad hoc notes

## Goals

- define the reusable strict-compliance audit surface
- define the rollout-tracking surface for migrating real projects
- leave the application batch ready

## Non-Goals

- migrating any specific project in this batch
- creating a huge governance pack for its own sake
- replacing project-local planning with a central control board

## Artifact Set

- docs/roadmaps/g02/013-define-strict-compliance-audit-and-rollout-surface.md
- docs/roadmaps/g02/batch-cards/051-define-strict-compliance-audit-surface.md
- docs/roadmaps/g02/batch-cards/052-apply-audit-and-rollout-guidance.md
- docs/roadmaps/g02/batch-cards/053-reprove-audit-and-rollout-surface.md

## Audit Surface

The reusable audit should make these questions explicit:

- what phase the project is currently in
- which strict-compliance checkpoints are already satisfied
- which gaps still block the next migration phase
- whether mixed posture is still valid migration state or has become drift

## Rollout Surface

The rollout view should make these questions explicit:

- what the current migration tranche is
- what the next migration tranche is
- what evidence proves the tranche is complete
- which project-level surfaces still need to be upgraded before full strict
  compliance can be claimed

## Acceptance Criteria

- the audit and rollout surface is explicit
- the next application batch is ready

## Stop Conditions

- the lane turns into migrating one real project before the reusable surface
  exists
- the surface becomes broader than needed to drive real rollout decisions

## Next Task

Use the re-proved audit and rollout model as the basis for the first real
consumer-repo strict-compliance migration proof lane.
