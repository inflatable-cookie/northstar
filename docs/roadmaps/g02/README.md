# g02

`g02` is the first external-proof generation for Northstar after the internal
foundation work in `g01`.

This generation is intended to stay open for a substantial tranche of work. It
is the long-running external-proof and execution-hardening generation, not a
single-pilot bucket.

## Generation Runway

| Goal | State | Governing refs | Next milestone |
| --- | --- | --- | --- |
| Keep proving Northstar against real consumer repositories before treating stricter posture as settled doctrine. | active | `docs/contracts/001-working-rules.md`, `docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md`, `docs/specs/013-stricter-consumer-repo-autonomy-adoption.md` | pending |
| Harden setup, nested-authority adoption, and posture classification so downstream repos can install the spine without hand adaptation. | active | `docs/specs/020-formalize-nested-docs-authority-setup.md`, `docs/specs/022-formalize-repo-posture-classification.md` | pending |
| Keep execution autonomy bounded by ready cards, lane budgets, pause signals, and a file-based orchestrator/worker PR boundary instead of ad-hoc continuation prompts. | active | `docs/contracts/001-working-rules.md`, `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`, `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | `g02.026` planning checkpoint |
| Consolidate bundle doctrine, templates, skills, and checks so the reusable system stays copy-ready. | active | `bundle-docs/protocol-kernel.md`, `template-bundle/README.md`, `skills/northstar/SKILL.md` | pending |

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
- `026-add-northstar-native-pre-execution-discovery.md` (active; Batch 26.1 and
  Batch 26.2 complete, `g02.026/078` ready for Batch 26.3)

## Next Task

`g02.025` is complete. `g02.024` is complete; its planning input was the
consumer papercuts evidence. Cards `g02.026/075`, `g02.026/076`, and
`g02.026/077` are complete.
The Batch 26.2 planning and route implementation are complete. The Batch 26.3
starter-surface planning checkpoint is complete and `g02.026/078` is ready. Its
route closeout is
`docs/logs/2026-08/16-215610-pre-execution-discovery-routes-worker-pr-closeout.md`.

Batch cards live in `g02/batch-cards/` when strict posture uses them.