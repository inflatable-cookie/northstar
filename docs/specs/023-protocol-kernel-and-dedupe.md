# 023 - Protocol Kernel And Dedupe

Status: retired-in-place  
Owner: repo maintainers  
Updated: 2026-05-19  
Vision refs: docs/vision/001-northstar-delivery-vision.md  
Governing refs: docs/contracts/001-working-rules.md  
Roadmap refs: g02.020

## Problem

The protocol is correct but scattered across doctrine sections, the template
bundle, skills, and live contracts. Duplicate normative lists drift apart and
raise load on operators and agents.

## Target operating model

- One short **protocol kernel** in `bundle-docs/` maps topics to canonical homes.
- Expanded enumerations stay in `bundle-docs/sections/06-…` and `07-…`.
- Strict repos keep a **compact** `docs/contracts/001-working-rules.md` that
  points at doctrine for full detail unless the repo intentionally narrows
  behavior.
- Skills reference the kernel (and paths) instead of re-embedding long lists.

## Goals

- [x] land `bundle-docs/protocol-kernel.md` and wire primary bundle entry points
- [x] dedupe obvious parallel lists in skills/templates/mode references where a pointer suffices
- [x] prove operator path: visual map → kernel → active section

## Non-goals

- Merging `06` and `07` into one file in this lane
- Rewriting every historical log or archived spec

## Artifact set

- `bundle-docs/protocol-kernel.md`
- `bundle-docs/README.md`, `bundle-docs/visual-map.md`, `bundle-docs/cheat-sheet.md`
- `docs/contracts/001-working-rules.md` (cross-reference only unless contract gap)
- `skills/northstar-*/SKILL.md` (read lists)
- `template-bundle/contracts/001-working-rules-template.md` (pointer where helpful)

## Closeout

Lane `g02.020` completed with Batch 20.3 proof and batch log
`docs/logs/2026-05/19-164500-finish-protocol-kernel-batch-20-3.md`. Keep this spec
in the active tree briefly as `retired-in-place` for traceability; move to
`docs/specs/archive/` when the next specs hygiene pass prefers a leaner active
surface.
