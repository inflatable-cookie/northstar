# 006 - Currentness Surfaces And Lightweight Alignment

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.003

## Problem

The longer autonomy lane showed that Northstar's front doors and currentness
surfaces drift faster than the core doctrine. That creates avoidable operator
friction: even when the planning system is sound, humans and agents can be sent
through stale README, roadmap, contract-index, or log index paths before they
reach the live lane.

## Target Operating Model

Northstar should define a small explicit set of currentness surfaces, make the
expected refresh behavior clear, and add lightweight enforcement only where the
drift is deterministic enough to justify it.

That means:

- the currentness surfaces are named explicitly
- milestone and generation transitions update those surfaces as part of normal
  closeout
- a lightweight checker can defend the most predictable stale states
- currentness triage remains available as a short manual cleanup path when the
  repo still drifts despite that lighter enforcement

## Goals

- Define the canonical currentness surfaces for a Northstar repo.
- Promote the currentness rule into doctrine, the bundle, and the live working
  rules.
- Add a lightweight repo-owned alignment check only where the repeated drift is
  deterministic enough to justify it.
- Leave `g02` open with another substantive lane rather than rolling
  generations.

## Non-Goals

- Building a heavy docs-state linter that tries to infer every repo's intent.
- Replacing human judgment for queue or roadmap curation.
- Turning currentness maintenance into a large new operator workflow.

## Artifact Set

- `bundle-docs/sections/03-roadmaps.md`
- `bundle-docs/sections/04-logs.md`
- `template-bundle/roadmaps/README.md`
- `template-bundle/logs/README.md`
- `docs/contracts/001-working-rules.md`
- `docs/roadmaps/g02/003-tighten-currentness-surfaces-and-alignment-checks.md`

## Phased Delivery

### Phase 1

Define the currentness surfaces and the refresh rule in doctrine, bundle
surfaces, and the live working rules.

### Phase 2

Add lightweight deterministic alignment checks for the live repo where the
stale-state pattern is already clear.

### Phase 3

Run the checker and currentness path against the live repo, then log what still
depends on manual judgment.

## Acceptance Criteria

- Northstar doctrine explicitly defines the currentness surfaces.
- The bundle tells downstream repos which front doors must stay aligned.
- The live repo has a dedicated currentness/alignment milestone in `g02`.
- The next batch for lightweight enforcement is explicit.

## Completion Notes

This spec delivered the bounded currentness-surface model, the lightweight
repo-local checks for deterministic stale states, and the proof pass that
showed the remaining friction is now curation rather than alignment.

## Stop Conditions

- the work turns into a heavy generic linter instead of a bounded alignment aid
- the new rule duplicates existing roadmap or log doctrine without clarifying
  operator behavior
- the lane only adds reminders and no clearer enforcement path

## Next Task

Start `g02.004` batch `4.1` by defining the currentness curation rules and
evidence-window policy in doctrine, bundle, and live working rules.
