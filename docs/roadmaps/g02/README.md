# g02

`g02` is the first external-proof generation for Northstar after the internal
foundation work in `g01`.

This generation is intended to stay open for a substantial tranche of work. It
is the long-running external-proof and execution-hardening generation, not a
single-pilot bucket.

## Generation Runway

| Goal | State | Governing refs | Next milestone |
| --- | --- | --- | --- |
| Keep learning from operator-provided consumer feedback before treating stricter posture as settled doctrine. | active | `docs/contracts/001-working-rules.md`, `docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md`, `docs/specs/013-stricter-consumer-repo-autonomy-adoption.md` | pending |
| Harden setup, nested-authority adoption, and posture classification so downstream repos can install the spine without hand adaptation. | active | `docs/specs/020-formalize-nested-docs-authority-setup.md`, `docs/specs/022-formalize-repo-posture-classification.md` | pending |
| Keep execution autonomy bounded by ready cards, lane budgets, pause signals, and a file-based orchestrator/worker PR boundary instead of ad-hoc continuation prompts. | active | `docs/contracts/001-working-rules.md`, `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`, `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | operator feedback intake / Batch 26.4 checkpoint |
| Keep always-loaded agent context useful, human, and bounded while preserving safety, authority, and project intent. | complete | `docs/contracts/003-agent-instruction-surface.md`, `docs/specs/028-agent-instruction-surface-optimization.md` | accept later operator feedback |
| Consolidate bundle doctrine, templates, skills, and checks so the reusable system stays copy-ready. | active | `bundle-docs/protocol-kernel.md`, `template-bundle/README.md`, `skills/northstar/SKILL.md` | pending |
| Add a genuinely long-horizon planning route without conflating it with readiness review. | active | `docs/specs/029-northstar-long-horizon-planning.md`, `skills/northstar/references/modes/atlas.md` | Non-Northstar scenario and operator confirmation |
| Preserve useful conversational context and keep `/docs` drift recoverable without blind deletion. | active | `docs/specs/030-conversational-triage-and-docs-cleanup.md`, `docs/contracts/001-working-rules.md`, `skills/northstar/references/modes/cleanup-docs.md` | live triage and cleanup feedback |
| Raise language-code quality through evidence-bound routed workflows without creating a second standards authority or always-loaded rule dump. | active | `docs/contracts/004-language-quality-pack.md`, Rust/TypeScript translation memos, specs 031-033 | operator-provided live-use feedback |

Update this runway only when generation-level intent changes, a milestone
materially advances or closes a goal, or rollover is being considered. Do not
rewrite it as a per-turn task list. The runway does not need to pre-plan every
future milestone, but it should keep `g02` moving as a significant 20-to-50
roadmap generation rather than treating four or five completed roadmaps as a
rollover signal.

## Milestones

- `001-run-consumer-repo-pilot-and-consolidate.md`
- `002-tighten-execution-guardrails-and-extend-autonomy.md`
- `003-tighten-currentness-surfaces-and-alignment-checks.md`
- `004-define-currentness-curation-and-evidence-window.md`
- `005-tighten-spec-lifecycle-and-archive-mechanics.md`
- `006-align-archive-aware-skill-and-setup-surfaces.md`
- `007-define-continuation-envelope-and-stop-signal-contract.md`
- `008-define-lane-budget-and-pause-signal-contract.md`
- `009-prove-combined-autonomy-model-in-consumer-repo.md`
- `010-prove-stricter-autonomy-adoption-in-consumer-repo.md`
- `011-define-lane-first-stricter-adoption-starter-pack.md`
- `012-define-full-strict-compliance-migration-program.md`
- `013-define-strict-compliance-audit-and-rollout-surface.md`
- `014-prove-strict-compliance-migration-in-signal.md`
- `015-queue-deferred-strict-follow-ups-and-open-underlay-recovery.md`
- `016-open-underlay-consumer-cohort-and-underlay-reference-strict-pass.md`
- `017-formalize-nested-docs-authority-setup.md`
- `018-add-workspace-container-adoption-specimen.md`
- `019-formalize-repo-posture-classification.md`
- `020-add-protocol-kernel-and-dedupe-canonical-surfaces.md`
- `021-add-posture-and-archive-advisory-checks-to-effigy.md`
- `022-repair-installed-skill-portability.md`
- `023-add-papercuts-feedback-loop.md`
- `024-harden-skill-distribution-and-consumer-papercut-proof.md`
- `025-add-orchestrator-thread-and-worker-pr-loop.md`
- `026-add-northstar-native-pre-execution-discovery.md` (active; Batches 26.1 and
  26.2 complete, the Batch 26.3 checkpoint complete, `g02.026/078` ready but
  deferred, and the architecture-refocus and reframe parts of Batch 26.4 complete)
- `027-optimize-agent-instruction-surfaces.md` (complete; card 101 applied the
  intent-led operator-feedback correction)
- `028-add-northstar-long-horizon-planning.md` (active; Atlas mode and router
  contract, command adapter, source/runtime checks, and installed parity are
  complete; broader validation remains)
- `029-add-conversational-triage-and-docs-cleanup.md` (active; implementation
  and deterministic validation are complete; live operator usage remains)
- `030-ship-rust-quality-authoring-and-audit.md` (complete; cards 083-088,
  production evidence, agent-owned activation, published install, and 76-file
  parity proven)
- `031-ship-typescript-svelte-explicit-audit.md` (complete; cards 089-093,
  revision-S evidence, 93-file parity, and everyday workflow unavailable)
- `032-strengthen-rust-audit-tool-enforcement.md` (complete; cards 094-099,
  revision-E production proof, and 120-file configured parity)
- `033-apply-language-quality-live-use-corrections.md` (complete; card 100,
  explicit adapter activation, TypeScript retained findings, and pinned Rust
  forwarder evidence)

## Next Task

`g02.025` is complete. `g02.024` is complete; its planning input was the
consumer papercuts evidence. Cards `g02.026/075`, `g02.026/076`, and
`g02.026/077` are complete.
The Batch 26.2 planning and route implementation are complete. The Batch 26.3
starter-surface planning checkpoint is complete and `g02.026/078` remains ready
but deferred. The architecture-refocus and reframe parts of Batch 26.4 are
complete; feedback intake remains pending. The instruction-surface lane
`g02.027` is complete: card 101 used operator feedback and the T3 Code example
to replace the over-compact review model with an intent-led one.
Atlas validation is tracked by `g02.028`; Northstar does not select or manage the
operator's external dogfooding.
The Rust quality implementation lane `g02.030` is complete. Triage, Atlas, and
Rust live-use feedback remain independent operator-owned follow-ups.
`g02.031` is complete. Revision S passed `3/3` production subjects and blind reviewers:
`30/30` primary findings, `96/96` review dimensions, and `24/24` accepted
repairs. Card 093 distributed the exact payload with 93-file source/install
parity. Everyday TypeScript remains unavailable; accept operator-provided
live-use feedback without dispatching a consumer audit.
Convergence live-use evidence promoted a Rust v2 recorder boundary into contract
004. Cards 094-095 rejected the cross-root Effigy split, froze and implemented
a skill-shipped Cargo-native engine, and passed managed install, root/nested
scope, complete-ledger, mutation-attribution, and deterministic-report proofs.
Card 096 added immutable mechanical evidence and compact ledger-free closeout.
Card 097 qualified 14 finite detector candidates without adding a rule, custom
detector, or repair authority. Card 098 passed revision E across three isolated
subjects and three blind reviews. Card 099 distributed the exact 120-file
payload and closed `g02.032`.
Jetstream PR 2 then supplied mixed-repository live-use evidence. Card 100 fixed
all three blocking findings: full-depth adapter installation, an honest
TypeScript retained disposition, and agent-owned pinned forwarder scanning.
Roadmap `g02.033` is complete.

No blocking roadmap milestone is open. Accept operator-provided live-use
feedback; Northstar does not dispatch consumer audits.

Batch cards live in `g02/batch-cards/` when strict posture uses them.
