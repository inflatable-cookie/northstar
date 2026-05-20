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
- [specs/022-formalize-repo-posture-classification.md](./specs/022-formalize-repo-posture-classification.md)
- [roadmaps/generation-index.md](./roadmaps/generation-index.md)

## Sections

- `vision/` defines longer-term direction and constraints
- `architecture/` defines system shape, inventory, and guardrails
- `contracts/` is used only when a compact or seam-specific contract surface is
  worth the extra precision
- `specs/` carries master specs for material goals
- `roadmaps/` sequences contract-backed work into milestones
- `logs/` records completed batch evidence and decisions

## Current posture

This repo is using the delivery-layer doctrine it is proposing for the broader
Northstar system:

- **Agent refactors:** before v1.0, no compatibility shims or silent fallbacks;
  breaking changes get an operator decision. From v1.0, preserve expected stable
  behavior unless policy says otherwise. Canonical wording lives in
  [`contracts/001-working-rules.md`](./contracts/001-working-rules.md) and
  [`../bundle-docs/sections/07-delivery-framework-and-autonomy.md`](../bundle-docs/sections/07-delivery-framework-and-autonomy.md).
- planning should be explicit
- specs should shape changes before they are promoted into canonical surfaces
- batch execution should be tightly defined
- work should not be called done without real evidence
- agents should be able to continue through ready batch cards without needing
  repeated "continue" prompts from the operator

## Next Task

Run `effigy check:posture-advisory` when sanity-checking strict Northstar-shaped
repos; open the next `g02` milestone when new contract-backed work is queued.
