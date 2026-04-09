# 013 - Stricter Consumer-Repo Autonomy Adoption

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.010

## Problem

The Signal proof showed that the combined autonomy model does not break because
the model is weak. It breaks because roadmap-only repos cannot carry the full
continuation-envelope, lane-budget, and pause-signal state cleanly.

Northstar now needs one more external-proof lane: show how to recognize when a
consumer repo should adopt the stricter `specs/` plus batch-card layer, and
test that threshold against a real active repo instead of leaving it as
doctrine.

## Target Operating Model

Northstar should support two clear operating modes:

- baseline roadmap mode for healthy routing and shorter bounded execution
- stricter delivery mode when longer autonomous runs need explicit execution
  state in file form

Setup and planning guidance should make that distinction clear enough that a
repo does not drift between the two or expect the baseline mode to behave like
the stricter one.

## Goals

- define the external proof lane for stricter delivery-layer adoption
- test the adoption threshold against a real active consumer repo
- capture only the bounded changes that the external adoption proof justifies

## Non-Goals

- forcing every consumer repo onto `specs/` and batch cards
- treating roadmap-only mode as invalid or second-class
- opening another internal-only doctrine lane before the external proof exists

## Artifact Set

- docs/roadmaps/g02/010-prove-stricter-autonomy-adoption-in-consumer-repo.md
- docs/specs/batch-cards/042-define-stricter-adoption-proof-lane.md
- docs/specs/batch-cards/043-run-stricter-consumer-repo-adoption-proof.md
- docs/specs/batch-cards/044-apply-stricter-adoption-findings.md

## Proof Contract

### External Target

The target repo must be:

- active
- already using Northstar surfaces
- plausibly in need of longer autonomous runs than roadmap-only mode expresses
  cleanly

### Evidence

The proof should capture:

- whether the repo really needs the stricter `specs/` and batch-card layer
- the minimum additional surfaces needed if adoption is warranted
- whether the stricter layer would clarify continuation-envelope, lane-budget,
  and pause-signal state materially
- what should remain out of scope if adoption is not yet justified

### Consolidation Rule

Only apply changes back into Northstar if the external adoption proof exposes a
real ambiguity or missing rule in setup, planning, or template guidance.

## Phased Delivery

### Phase 1

Define the stricter-adoption proof lane and its evidence contract.

### Phase 2

Run the adoption proof against a real active consumer repo.

### Phase 3

Apply only the bounded findings that materially improve Northstar.

## Acceptance Criteria

- the stricter-adoption proof lane is explicit
- the external adoption-proof batch is explicit and ready
- the proof records whether the target repo should stay baseline, adopt the
  stricter layer, or adopt it lane-first

## Stop Conditions

- the lane starts trying to retrofit a consumer repo without evidence that the
  stricter layer is actually warranted
- the work turns into generic doctrine expansion rather than proof-backed
  adoption guidance

## Completion Notes

The Signal proof sharpened the adoption rule:

- Signal's repo-wide baseline spine is still valid
- its active `g09` plugin-realization lane is deep enough that longer
  autonomous runs would benefit from stricter execution state
- the right move is not a full repo-wide rewrite first, but a lane-first
  stricter adoption when that lane actually needs continuation-envelope,
  lane-budget, and pause-signal state in file form

That means Northstar should support three practical postures:

- baseline roadmap mode
- lane-first stricter adoption inside a mature baseline repo
- fuller stricter delivery mode where the repo broadly needs it

## Next Task

Start `g02.011` batch `11.1` by defining the minimal lane-first stricter
adoption starter pack and migration sequence for mature baseline repos.
