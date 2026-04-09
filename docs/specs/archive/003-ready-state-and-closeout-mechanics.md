# 003 - Ready-State And Closeout Mechanics

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g01.003

## Problem

Northstar can now support longer uninterrupted execution lanes, but two
critical transitions still depend too much on manual judgment:

- deciding which next one to three batch cards are genuinely ready
- closing a lane cleanly across batch cards, roadmap state, logs, and handoff
  surfaces

That gap keeps agents dependent on frequent operator nudges even when the
underlying planning is otherwise strong.

## Target Operating Model

Northstar should make both transitions more mechanical:

- a ready-state rubric should make it obvious when a single card or short card
  chain is valid for autonomous execution
- a closeout pattern should make end-of-lane state updates predictable and
  consistent across the planning spine
- the same rules should appear in doctrine, templates, skills, and the live
  repo checks

## Goals

- Define a concrete ready-state rubric for cards and short autonomous chains.
- Define a concrete closeout pattern for batch, milestone, log, and handoff
  updates.
- Promote both mechanics into the reusable bundle and skill surfaces.
- Apply the mechanics to Northstar itself so the repo can pilot them live.

## Non-Goals

- Adding another public Northstar skill.
- Building full automation for every planning-state update.
- Reopening broader delivery-layer doctrine that is already settled.

## Planned Surfaces

- live working rules and contract index
- bundle doctrine and reusable templates
- `northstar-plan`, `northstar-recover`, and `northstar-handoff`
- live repo checks and log/closeout guidance

## Acceptance Criteria

- A clear ready-state rubric exists for single cards and short autonomous
  chains.
- A clear closeout pattern exists for end-of-lane updates.
- The reusable bundle and the live repo both expose those mechanics.
- The next live execution lane can rely on those mechanics with less operator
  interpretation.

## Stop Conditions

- The milestone produces more abstract doctrine without making state
  transitions easier to execute.
- The ready-state rubric is too vague to reject unsafe chains.
- The closeout pattern is still too loose to keep roadmap/spec/log state in
  sync.

## Next Task

Use the completed `g01` findings to decide whether the next improvement belongs
in `g01` or should start a clean new generation.
