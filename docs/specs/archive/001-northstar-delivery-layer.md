# 001 - Northstar Delivery Layer

Status: active
Owner: repo maintainers
Updated: 2026-04-08
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g01.001

## Problem

Northstar currently routes work more effectively than it constrains execution.
Projects still fall into the same traps: shallow planning, token completion,
UI overcomplication, and frequent operator intervention just to keep a thread
moving.

## Target Operating Model

Northstar should provide a delivery layer that makes material work feel
paint-by-numbers once planning is approved.

That means:

- projects carry explicit product guardrails
- completion quality is defined contractually
- agents operate under a written autonomy policy
- major goals can be broken into master specs and batch cards while they are
  still being shaped
- settled outcomes are promoted into architecture and contracts before roadmap
  execution relies on them
- roadmap milestones sequence ready work rather than vague intentions

## Goals

- Turn the repo itself into the first live pilot of the stricter delivery layer.
- Define canonical artifacts for guardrails, done-ness, autonomy, master specs,
  and batch cards.
- Reduce reliance on special operator phrasing or repeated "continue" prompts.
- Create a clear path for promoting the live repo pilot into the template
  bundle and installable skills.

## Non-Goals

- Shipping every delivery-layer artifact into the reusable template bundle in
  one batch.
- Adding more public skills before the new delivery layer proves itself.
- Replacing human judgment with unchecked autonomous runs.

## Artifact Set

- `docs/architecture/product-guardrails.md`
- `docs/contracts/001-working-rules.md`
- `docs/roadmaps/g01/batch-cards/001-establish-live-northstar-docs-spine.md`
- `docs/roadmaps/g01/001-enact-northstar-on-northstar.md`

## Phased Delivery

### Phase 1

Adopt the live `docs/` spine in this repo and capture the doctrine as active
Northstar artifacts.

### Phase 2

Promote the delivery-layer artifacts and the specs-promotion rule into the
reusable bundle where they should become canonical.

### Phase 3

Update `northstar-setup`, `northstar-plan`, `northstar-recover`,
`northstar-research`, and `northstar-handoff` so they rely on the new delivery
artifacts with minimal operator prompting.

### Phase 4

Run longer live execution lanes against batch cards and tune the autonomy
envelope based on real repo use rather than theory.

## Acceptance Criteria

- The repo has a live `docs/` spine with active vision, architecture, compact
  working rules, specs, roadmaps, and logs.
- The delivery layer is documented in `bundle-docs/sections/`.
- At least one live roadmap milestone and one completed batch card exist.
- Validation passes with `effigy qa` and `effigy qa:docs`.
- The next batches for template and skill promotion are explicit.

## Stop Conditions

- The delivery artifacts prove too vague to constrain execution.
- The repo accumulates new ceremony without reducing ambiguity.
- Autonomy increases before the underlying batch cards are good enough.

## Next Task

Compile the next live milestone from the autonomy-pilot findings, with focus on
making ready-state choice and lane closeout more mechanical.
