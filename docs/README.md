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
- [specs/035-chatterbox-intake-channel.md](./specs/035-chatterbox-intake-channel.md)
- [specs/036-economical-orchestrator-coordination.md](./specs/036-economical-orchestrator-coordination.md)
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
- spec 036 plans an economical coordinator default: material discovery moves to
  operator-confirmed chatterbox packets, canonical promotion stays bounded and
  mechanical, and substantive PR review moves to independent child reviewers;
  card 125 is ready and the ten-PR trial remains blocked
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
  fixture protocol, TypeScript, Rust, and embedded removal. Card 117's generic
  lifecycle proof merged through PR 22 at `75db6f5`. Card 118's public package
  repository merged package PR 1 as `09ef174`; exact TypeScript identity and
  inventory are accepted, and the reviewed installed-invocation repair merged
  as `d18dc33b` (package PR 2). Core PR 23 repins that replacement identity
  (registry version `1.2.0`) and adds the non-vacuous installed setup/record
  operational proof through the exact public `effigy skill run --path` surface;
  it merged as `5951dfb`. Jetstream PR 4 passed exact-head review at
  `177b75c80e5310d84fdd227d0229b261d59d6271` and squash-merged as
  `dbf7561d3845bf344f9ae4fae3296d1601b074bf`. Its bounded fallback,
  installed-audit, and byte-preservation proof is accepted; four pre-existing
  editor failures and current-Poodle `ResolvedIconGeometry` API drift remain
  limits. The Rust readiness refresh selected Convergence and froze the
  54-file source boundary, but found the external package's agent-facing
  `SKILL.md` loaded an absent router. Package-source PR 3 repaired it and
  merged as `c9ef2a2`; card 121's registry `1.3.0` pin merged as `69e4d5d`.
  Rust package-source PR 4 merged as `56b2e11`; card 119's registry
  promotion pinned that identity at registry version `1.4.0` with the
  reproduced 59-file tree, proved the real-package lifecycle and installed
  engine-integrity transcripts, and opened the bounded Rust overlap window.
  PR 27 merged as `256d0f7`; Convergence PR 4 repaired its evidence gap and
  merged as `dff19c9`. Card 119 is complete. The exact embedded-removal
  inventory exposed a missing generic intent/activation selection layer.
  Card 122 implemented it, closed three first-review defects, and merged
  through PR 28 as `ddaae0d`; PR 29 merged the Paseo worker-parentage
  correction as `7ebaa9c` and the installed 199-file skill copy matched
  source. Card 120 then removed the embedded
  payloads and fallback (95-file frozen inventory) on
  `worker/remove-embedded-language-quality-payloads`: core keeps only generic
  package discovery, registry, trust, lifecycle, and routing; the payload is
  111 files; `check:language-package-routes` proves core-only operation,
  scoped missing-package containment, and both installed routes. Milestone
  `g02.048` completed through PR 30 as `aa9a005`; the installed skill now
  matches the 111-file generic core.
- unresolved conversational observations should be captured in `triage/` before
  a deeper branch is pursued, then managed during refresh and cleanup
- chatterbox intake is implemented as spec 035 / `g02.050` / card 124.
  Independent operator-facing threads write unique `docs/triage/` notes on the
  shared checkout and report them to the operator without starting an
  orchestrator turn in v1; they must not implement, promote, or dispatch
