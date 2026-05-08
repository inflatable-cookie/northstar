# 012 - Consumer-Repo Autonomy Proof And Adoption

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.009

## Problem

Northstar's continuation-envelope, lane-budget, and pause-signal model is now
coherent inside this repo, but that is still an internal proof. The next real
question is whether the combined model actually helps an active consumer repo
run longer bounded lanes with less operator babysitting, or whether it breaks
down once the work is not doctrine-on-doctrine.

## Target Operating Model

Northstar should prove the combined autonomy model in a real active consumer
repo before adding more internal doctrine.

That means:

- selecting one active consumer-repo lane that is already running under
  Northstar
- checking whether the combined continuation and lane-budget model is legible
  enough in that repo's real planning surfaces
- capturing only the bounded adjustments that external proof actually justifies

## Goals

- define a consumer-repo proof lane for the combined autonomy model
- run the model against one active external lane
- consolidate only the changes that materially improve real operator flow

## Non-Goals

- opening another internal-only autonomy abstraction before external proof
- forcing a consumer repo onto a model it cannot yet support cleanly
- treating a stale or inactive repo as equivalent proof

## Artifact Set

- docs/roadmaps/g02/009-prove-combined-autonomy-model-in-consumer-repo.md
- docs/roadmaps/g02/batch-cards/039-define-consumer-repo-autonomy-proof-lane.md
- docs/roadmaps/g02/batch-cards/040-run-consumer-repo-autonomy-proof.md
- docs/roadmaps/g02/batch-cards/041-apply-consumer-repo-autonomy-findings.md

## Proof Contract

### Target Repo

The proof target must be:

- an active repo
- already using Northstar surfaces
- currently carrying a live lane where bounded autonomous continuation is
  plausible

### Evidence

The proof should capture:

- whether the continuation envelope is legible in the consumer repo
- whether lane-budget and pause-signal state are easy to record without extra
  friction
- whether the model reduces operator nudges in practice
- what bounded failures remain

### Consolidation Rule

Only apply changes back into Northstar if the external proof shows a real
operator or agent failure mode that the current model does not handle cleanly.

## Phased Delivery

### Phase 1

Define the consumer-repo proof lane and its evidence contract.

### Phase 2

Run the proof against an active consumer repo.

### Phase 3

Apply only the bounded findings that materially improve the model.

## Acceptance Criteria

- the consumer-repo proof lane is explicit
- the external-proof batch is explicit and ready
- the proof-backed adoption threshold is explicit in Northstar doctrine and
  setup guidance

## Stop Conditions

- the lane starts guessing at a repo or task that is not truly active
- the proof degrades into another internal Northstar-only exercise

## Completion Notes

The Signal proof showed that the combined autonomy model is not mainly failing
as a model. The important boundary is adoption depth:

- roadmap-only repos can still route active work and support shorter bounded
  execution well
- repos that want the full continuation-envelope, lane-budget, and pause-signal
  model need the stricter `specs/` plus batch-card layer so that state is
  explicit in file state

That finding should now shape setup guidance and the next external proof lane.

## Next Task

Start `g02.010` batch `10.2` by testing the stricter delivery-layer adoption
threshold against a real active consumer-repo lane.
