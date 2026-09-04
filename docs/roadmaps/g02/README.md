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
| Keep execution autonomy bounded by ready cards, lane budgets, pause signals, and a file-based orchestrator/worker PR boundary instead of ad-hoc continuation prompts. | active | `docs/contracts/001-working-rules.md`, `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`, `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | accept operator-provided live feedback |
| Keep the orchestrator on the main runway by giving the operator independent chatterbox threads for side issues and ideas. | complete; cards 124 and 127 merged | `docs/specs/035-chatterbox-intake-channel.md`, `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`, `docs/specs/030-conversational-triage-and-docs-cleanup.md` | observe normal use |
| Make Chatterbox the human planning authority while the coordinator mechanically dispatches approved frontiers and gates PRs. | complete; cards 128 and 129 merged | `docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`, `docs/contracts/001-working-rules.md`, `docs/roadmaps/g02/054-finish-continuous-coordinator-delivery.md` | passively observe card 126 |
| Keep always-loaded agent context useful, human, and bounded while preserving safety, authority, and project intent. | complete | `docs/contracts/003-agent-instruction-surface.md`, `docs/specs/028-agent-instruction-surface-optimization.md` | accept later operator feedback |
| Consolidate bundle doctrine, templates, skills, and checks so the reusable system stays copy-ready. | active | `bundle-docs/protocol-kernel.md`, `template-bundle/README.md`, `skills/northstar/SKILL.md` | card 120 root reduction |
| Add a genuinely long-horizon planning route without conflating it with readiness review. | active | `docs/specs/029-northstar-long-horizon-planning.md`, `skills/northstar/references/modes/atlas.md` | Non-Northstar scenario and operator confirmation |
| Preserve useful conversational context and keep `/docs` drift recoverable without blind deletion. | active | `docs/specs/030-conversational-triage-and-docs-cleanup.md`, `docs/contracts/001-working-rules.md`, `skills/northstar/references/modes/cleanup-docs.md` | live triage and cleanup feedback |
| Raise language-code quality through evidence-bound routed workflows without making every implementation part of the root payload. | active; extraction complete, PR pending review | `docs/contracts/004-language-quality-pack.md`, `docs/architecture/system-architecture.md`, `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md` | operator checkpoint: Sentrux cohort or new language |

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
- `034-post-direct-pr-review-findings.md` (complete; card 102, provider-recorded
  direct review and no chat-only blocking findings)
- `035-reduce-worker-review-rework.md` (complete; card 103, review oracles,
  reason-coded findings, risk-based workers, and compact handoffs)
- `036-use-optional-control-plane-for-orchestrator-dispatch.md` (complete; card
  104, conditional Paseo dispatch, manual fallback, and 122-file skill parity)
- `037-make-paseo-dispatch-implicit-inside-paseo.md` (complete; card 105 replaces
  the redundant permission prompt with injected-tool detection)
- `038-centralize-paseo-worktree-runtime.md` (complete; card 106 proves the
  skill-owned lifecycle in a real Figmatic Paseo worktree)
- `039-delegate-mechanical-orchestrator-documentation.md` (complete; card 107
  delegates exact documentation projection while Sol retains planning and
  semantic authority)
- `040-delegate-conversational-feature-planning.md` (complete; card 108 adds an
  isolated operator-facing planning delegate with orchestrator-owned promotion)
- `041-repair-partial-rust-evidence-collection.md` (complete; card 109 repaired
  sealed-coverage-aware partial collect and merged PR 13)
- `042-make-orchestrator-parallel-first.md` (complete; card 110 made
  dependency-frontier parallel-first dispatch the orchestrator default; PR 14
  merged at `8cfa0ae` after exact-head review)
- `043-prefer-economical-worker-routing.md` (complete; card 111 merged through PR 15 at `d5acd75`)
- `044-remove-global-capacity-gating.md` (complete; card 112 propagated
  lane-local provider routing; PR 17 merged at `e5e8060`, the corrected skill
  is installed, and active orchestrators were notified)
- `045-reduce-prose-coupled-validation.md` (complete; PR 18 merged at
  `1f6647a` after exact-head review)
- `046-add-fresh-orchestrator-continuation.md` (complete; card 114 merged through PR 19 at `b99d19c`)
- `047-diversify-model-routing-across-runs.md` (complete; PR 20 merged at
  `08ad810` after exact-head review)
- `048-extract-modular-language-quality-packages.md` (complete pending PR
  review; cards 117-118 complete, the TypeScript standalone adapter repaired
  in package-source merge `c9ef2a2`, card 121 merged the registry `1.3.0` pin
  as `69e4d5d`, card 119's registry promotion proved the Rust pin at registry
  version `1.4.0` and merged as `256d0f7`; Convergence PR 4 repaired its
  evidence gap and merged as `dff19c9`; card 122 merged the generic selector
  as `ddaae0d`; card 120 removed the embedded payloads and fallback,
  completing Batch D)
- `049-preserve-paseo-worker-parentage.md` (complete; card 123 preserves
  Paseo worker parentage across dedicated worktree workspace placement, keeps
  finish notifications enabled, resumes same-child identity on revision, and
  proves all six oracle rows through live launch, exact-head source review, and
  same-child revision)
- `050-add-chatterbox-intake-channel.md` (complete; card 124 merged through PR
  31 at `d1b162e`)
- `051-economical-orchestrator-coordination.md` (initial model complete through
  card 125/PR 32, then superseded by g02.053 after failed live promotion;
  card 126 waits to observe the corrected model)
- `052-chatterbox-sibling-agent-tabs.md` (complete; card 127 merged through PR
  33 as `7d3bfd1`)
- `053-chatterbox-led-planning-and-mechanical-coordination.md` (complete; card
  128 merged through PR 34 at `fd341aeb`; card 126 remains the next bounded
  observation lane)
- `054-finish-continuous-coordinator-delivery.md` (complete; card 129 merged
  through PR 35 at `96a9395`; card 126's passive bounded observation is active)

## Next Task

Card 126's passive ten-lane-or-2026-09-18 observation is active and must not
block other projects. The Sentrux triage note and any new-language cohort remain
separate checkpoints.

`g02.048/117` merged through PR 22 at `75db6f5` after proving the generic
lifecycle. Card 118's public repository merged package PR 1 as `09ef174`, and
its reviewed installed-invocation repair merged as `d18dc33b` (package PR 2).
PR 23 pins the replacement identity at registry version `1.2.0`, adds the
non-vacuous installed setup/record operational proof, and merged as `5951dfb`.
The accepted Jetstream PR 4 canary passed exact-head review at
`177b75c80e5310d84fdd227d0229b261d59d6271` and squash-merged as
`dbf7561d3845bf344f9ae4fae3296d1601b074bf`. Its bounded fallback, installed
audit, byte-preservation, and hydrated-build evidence is accepted; four
pre-existing editor failures and current-Poodle `ResolvedIconGeometry` API
drift remain limits. Package-source PR 3 repaired the TypeScript adapter and
merged as `c9ef2a2`; card 121's registry `1.3.0` pin merged as `69e4d5d`.
Card 119's package source passed exact-head review at `7cc4cd0` and merged as
`56b2e11`, with accepted tree `sha256:e5cf9c5d...54dba0`. The Northstar
registry promotion pinned that identity at registry version `1.4.0`, proved
the real-package lifecycle and installed engine-integrity transcripts, and
merged as `256d0f7`. Convergence PR 4 passed exact-head review at `792a7c2`
and merged as `dff19c9`. The removal refresh froze 95 deletion targets and 19
integration surfaces. Card 122 repaired the missing data-driven selector and
merged as `ddaae0d`. Card 123's parentage correction merged as `7ebaa9c` and
the installed skill was refreshed. Card 120 removed the embedded payloads and
fallback on `worker/remove-embedded-language-quality-payloads`, closing the
extraction lane; its PR awaits exact-head review and merge.

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
Roadmap `g02.034` is complete. Card 102 added the fresh-thread direct PR-review
route: every blocking finding is posted on the provider review surface, with a
canonical `Changes required` comment when same-identity formal review is
unavailable. Chat is summary-only.
Roadmap `g02.035` is complete. Card 103 turned Figmatic and Swallowtail
revision evidence into review oracles, a worker adversarial pass, finding reason
codes, frontier/high routing for risky workers, and shorter dispatch overlays.
Roadmap `g02.036` is complete. Card 104 made Paseo an optional transport adapter:
Northstar selects current profiles by notes, creates one worktree workspace from
`origin/main`, launches from the absolute committed handoff, trusts
notifications, and keeps manual dispatch, permissions, review, and merge gates.
Operator feedback closed under `g02.037/105`: injected Paseo orchestration tools
now act as the routine dispatch signal, while `paseo.json` remains project
lifecycle configuration and every non-transport authority gate stays explicit.

Roadmap `g02.038` is complete. The installed `paseo:worktree` task passed its
self-test and a real Figmatic Paseo managed-worktree lifecycle. The same
correction removes the redundant merge prompt:
an orchestrator may merge its accepted, checks-passing current PR head without
asking again. Northstar does not dispatch consumer audits.

Batch cards live in `g02/batch-cards/` when strict posture uses them.
