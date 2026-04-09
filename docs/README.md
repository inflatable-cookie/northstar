# Northstar Project Docs

This `docs/` tree governs development of Northstar itself.

Northstar is no longer just the template and doctrine repo. It also uses a live
Northstar planning spine for its own work so changes to the system can be
planned, executed, and logged under the same framework it asks other projects
to adopt.

## Start Here

- [vision/001-northstar-delivery-vision.md](./vision/001-northstar-delivery-vision.md)
- [architecture/system-architecture.md](./architecture/system-architecture.md)
- [architecture/product-guardrails.md](./architecture/product-guardrails.md)
- [contracts/001-working-rules.md](./contracts/001-working-rules.md)
- [specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md](./specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md)
- [roadmaps/g02/015-queue-deferred-strict-follow-ups-and-open-underlay-recovery.md](./roadmaps/g02/015-queue-deferred-strict-follow-ups-and-open-underlay-recovery.md)

## Sections

- `vision/` defines longer-term direction and constraints
- `architecture/` defines system shape, inventory, and guardrails
- `contracts/` is used only when a compact or seam-specific contract surface is
  worth the extra precision
- `specs/` carries master specs and batch cards for material goals
- `roadmaps/` sequences contract-backed work into milestones
- `logs/` records completed batch evidence and decisions

## Current posture

This repo is using the delivery-layer doctrine it is proposing for the broader
Northstar system:

- planning should be explicit
- specs should shape changes before they are promoted into canonical surfaces
- batch execution should be tightly defined
- work should not be called done without real evidence
- agents should be able to continue through ready batch cards without needing
  repeated "continue" prompts from the operator

## Next Task

Let Underlay execute `g01.098` Batch 98.2, then reassess from that audit
whether the repo now needs only continued planning/currentness repair or a
stricter execution lane too.
