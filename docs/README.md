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
- [specs/034-modular-language-quality-packages.md](./specs/034-modular-language-quality-packages.md)
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
- `g02.041/109` repaired partial Rust evidence collection and merged; Signal
  owns the originating papercut closure
- dependency-frontier, parallel-first worker scheduling is the orchestrator
  default: every safe ready lane launches without a global thread budget, and a
  serial lane must name its dependency, shared surface, or unresolved authority;
  provider/profile availability pauses or reroutes only the affected lane
- `g02.042/110` delivered that default and merged through PR 14 at
  `8cfa0ae`
- `g02.043/111` implemented economical day-to-day worker routing; frontier
  workers now require both highest-priority/material-consequence and
  exceptional-reasoning gates. PR 15 merged at `d5acd75` after exact-head
  review.
- `g02.044/112` removed the accidental global-capacity interpretation: every
  safe ready lane launches without a global thread budget, and provider/profile
  failures stay lane-local. PR 17 merged at `e5e8060`; the 127-file skill
  payload is installed and all other `Orchestrator`-labelled workspaces were
  notified to re-read it.
- the first-principles packet and 26-observation dogfood cohort are promoted.
  The protocol remains frozen; `g02.045/113` reduced repo-contract validation
  to structural paths, links, parity, current authority, and stable machine
  contracts. PR 18 merged at `1f6647a` after exact-head review.
- `g02.046/114` merged through PR 19 at `b99d19c`: one pushed continuation
  handoff, one successor local workspace, a capitalized `Orchestrator` label,
  source-lane ownership transfer, and manual sidebar placement when Paseo has
  no native pin control.
- `g02.047/115` diversified model routing: every dispatch builds an adequate
  pool, prefers the cheapest adequate tier, and rotates recent provider/model
  use across workers, delegates, and fresh orchestrators; `check:model-routing`
  falsifies all ten oracle rows. PR 20 merged at `08ad810` after exact-head
  review.
- Northstar remains general-purpose. Spec 034's optional-package design is
  promoted into architecture and contract 004. Roadmap g02.048 now sequences
  fixture protocol, TypeScript, Rust, and embedded removal. Card 117 proved
  the generic lifecycle against the promoted host-protocol decisions
  (byte-exact digest vectors, operator trust and lifecycle state, the
  `language-package-host.v1` machine contract with operational entrypoints
  from an installed skill, explicit self-check invocation, atomic CAS,
  identity-bound routing, transactional acquire/update/rollback, offline
  routing, revocable trust); its PR 22 is open for exact-head re-review and
  card 118 stays blocked until it is accepted and merged.
- unresolved conversational observations should be captured in `triage/` before
  a deeper branch is pursued, then managed during refresh and cleanup
