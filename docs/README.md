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
- [contracts/003-agent-instruction-surface.md](./contracts/003-agent-instruction-surface.md)
- [contracts/004-language-quality-pack.md](./contracts/004-language-quality-pack.md)
- [specs/024-papercuts-feedback-loop.md](./specs/024-papercuts-feedback-loop.md)
- [specs/025-skill-distribution-and-consumer-papercut-proof.md](./specs/025-skill-distribution-and-consumer-papercut-proof.md)
- [specs/026-orchestrator-thread-and-worker-pr-loop.md](./specs/026-orchestrator-thread-and-worker-pr-loop.md)
- [specs/028-agent-instruction-surface-optimization.md](./specs/028-agent-instruction-surface-optimization.md)
- [specs/030-conversational-triage-and-docs-cleanup.md](./specs/030-conversational-triage-and-docs-cleanup.md)
- [triage/README.md](./triage/README.md)
- [roadmaps/generation-index.md](./roadmaps/generation-index.md)
- [handoffs/README.md](./handoffs/README.md)
- [PAPERCUTS.md](../PAPERCUTS.md) — agent-observed execution friction

## Sections

- `vision/` defines longer-term direction and constraints
- `architecture/` defines system shape, inventory, and guardrails
- `contracts/` is used only when a compact or seam-specific contract surface is
  worth the extra precision
- `specs/` carries master specs for material goals
- `roadmaps/` sequences contract-backed work into milestones
- `logs/` records completed batch evidence and decisions
- `handoffs/` stores friendly, timestamped notes for genuine fresh-thread takeovers
- `triage/` stores lightweight, timestamped capture notes until their useful
  content is promoted, merged, or removed

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
- frontier orchestrators may delegate settled mechanical documentation batches
  to fast/low-cost subagents, but retain planning and full-diff semantic review
- frontier orchestrators may delegate an operator-facing planning conversation,
  but canonical promotion and readiness remain with the orchestrator
- Signal live-use evidence has made `g02.041/109` ready: Northstar owns the
  partial Rust evidence collection repair; Signal retains papercut closure
- unresolved conversational observations should be captured in `triage/` before
  a deeper branch is pursued, then managed during refresh and cleanup
