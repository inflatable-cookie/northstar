# 024 - Papercuts Feedback Loop

Status: retired-in-place  
Owner: repo maintainers  
Updated: 2026-08-06  
Vision refs: docs/vision/001-northstar-delivery-vision.md  
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/papercuts.md  
Roadmap refs: g02.023

## Problem

Agents repeatedly encounter small execution friction that disappears from the
thread when the immediate task is complete. Operators then have to rediscover
the same tool, navigation, or instruction problems before they can improve the
system.

## Target operating model

- Each project can keep a versioned `PAPERCUTS.md` at the root of the repository
  that owns the work.
- The agent appends a terse entry as soon as it encounters a small, solvable
  hurdle, creating the file without operator intervention when needed.
- The note does not pause the current task or authorize an unplanned fix.
- Normal maintenance triages duplicate, fixed, repeated, and material entries
  into the existing backlog, roadmap, spec, architecture, contract, or
  automation surfaces.

## Goals

- [x] define the papercut contract and entry shape
- [x] seed a root queue and reusable starter template
- [x] wire the behavior into the Northstar skill and generated agent contract
- [x] expose the canonical rule through bundle docs and live architecture
- [x] add bounded QA coverage for the new source and template surfaces

## Non-goals

- [x] build a papercut database, dashboard, or automatic prioritization system
- [x] turn every command failure or unresolved blocker into a papercut
- [x] make papercuts a second backlog or a reason to interrupt active work
- [x] add a hook that depends on a particular agent runtime

## Artifact set

- `bundle-docs/papercuts.md`
- root `PAPERCUTS.md`
- `skills/northstar/assets/templates/PAPERCUTS.md`
- `skills/northstar/SKILL.md` and `skills/northstar/assets/templates/AGENTS.md`
- `docs/contracts/001-working-rules.md`
- `template-bundle/contracts/001-working-rules-template.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Closeout

The reusable contract and agent-facing starter surfaces are implemented. The
first live queue entry records a real orientation papercut found during this
batch. Consumer-repo usage remains the next proof step; papercut triage remains
manual maintenance by design.
