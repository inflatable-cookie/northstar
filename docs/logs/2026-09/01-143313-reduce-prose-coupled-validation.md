# Reduce Prose-Coupled Validation

Date: 2026-09-01
Status: implementation complete; awaiting exact-head review
Roadmap: `g02.045`
Card: `g02.045/113`

## Outcome

The Northstar repo-contract checker now protects structural paths, portable
skill links, Markdown link integrity, and the canonical batch-card mirror. It
no longer mirrors editorial wording or requires individual historical planning
artifacts. The focused fixture task proves the retained failures and the newly
tolerated benign changes without using a consumer checkout or provider state.

The worker branch is ready for orchestrator exact-head review. The
orchestration protocol and spec 034 remain unchanged and out of scope.

## Required-path inventory

The pre-change inventory contained 167 paths, 320 exact-presence assertions, 41
exact-absence assertions, and one mirror pair. The post-change live inventory
contains 97 paths: 22 stable-structure paths, 57 active-authority paths, 16
executable-validation paths, and 2 parity paths. The 73 historical paths were
removed from executable policy but remain in the repository as evidence.

The following classification covers every old `required_files` entry.

### Stable structure — 22 old paths retained

- root entry points: `AGENTS.md`, `CLAUDE.md`, `.agents.local.env.example`,
  `README.md`, `PAPERCUTS.md`
- live docs front doors: `docs/README.md`, `docs/vision/README.md`,
  `docs/architecture/README.md`, `docs/contracts/README.md`,
  `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`,
  `docs/roadmaps/g02/README.md`, `docs/logs/README.md`,
  `docs/handoffs/README.md`, `docs/triage/README.md`, `docs/specs/README.md`,
  `docs/specs/archive/README.md`
- copy-ready entry points: `template-bundle/README.md`,
  `template-bundle/triage/README.md`,
  `template-bundle/minimal/triage/README.md`,
  `template-bundle/specs/archive/README.md`,
  `template-bundle/roadmaps/g01/batch-cards/README.md`

### Active authority — 57 old paths retained

- Northstar architecture and contracts: `docs/architecture/system-architecture.md`,
  `docs/architecture/system-inventory.md`,
  `docs/architecture/product-guardrails.md`,
  `docs/contracts/contract-index.md`, `docs/contracts/001-working-rules.md`,
  `docs/contracts/002-agent-local-paths.md`,
  `docs/contracts/003-agent-instruction-surface.md`,
  `docs/specs/030-conversational-triage-and-docs-cleanup.md`
- reusable doctrine: `bundle-docs/README.md`, `bundle-docs/cheat-sheet.md`,
  `bundle-docs/papercuts.md`, `bundle-docs/protocol-kernel.md`,
  `bundle-docs/operators/operator-quick-start.md`,
  `bundle-docs/sections/07-delivery-framework-and-autonomy.md`,
  `bundle-docs/sections/09-standard-docs-spine.md`,
  `bundle-docs/sections/10-automation-runtime-policy.md`,
  `bundle-docs/research/translation-memos/agent-instruction-surface-optimization.md`
- copy-ready contracts: `template-bundle/contracts/001-working-rules-template.md`,
  `template-bundle/contracts/002-agent-local-paths-template.md`,
  `template-bundle/contracts/003-agent-instruction-surface-template.md`
- installable skill authority: `skills/northstar/SKILL.md`,
  `skills/northstar/agents/openai.yaml`, `skills/northstar/references/router.md`,
  `skills/northstar/references/handoff-contract.md`,
  `skills/northstar/references/setup/repo-contract.md`,
  `skills/northstar/references/setup/adoption-modes.md`,
  `skills/northstar/references/setup/delivery-layer-adoption.md`,
  `skills/northstar/references/setup/monkey-example.md`,
  `skills/northstar/references/setup/paseo-project.md`,
  `skills/northstar/references/modes/normalize-docs.md`,
  `skills/northstar/references/modes/project-refresh.md`,
  `skills/northstar/references/modes/cleanup-docs.md`,
  `skills/northstar/references/modes/architecture-refocus.md`,
  `skills/northstar/references/modes/planning-readiness-review.md`,
  `skills/northstar/references/modes/atlas.md`,
  `skills/northstar/references/modes/agent-instruction-review.md`,
  `skills/northstar/references/modes/pr-review.md`,
  `skills/northstar/commands/northstar-cleanup/SKILL.md`,
  `skills/northstar/references/modes/handoff.md`,
  `skills/northstar/references/modes/plan-from-scratch.md`,
  `skills/northstar/references/modes/shape-with-specs-and-promote.md`,
  `skills/northstar/references/modes/compile-roadmaps.md`,
  `skills/northstar/references/modes/research.md`,
  `skills/northstar/references/modes/replan-after-change.md`,
  `skills/northstar/references/modes/refocus-drifted-project.md`,
  `skills/northstar/references/modes/sweep-audit-repair.md`,
  `skills/northstar/assets/templates/README.md`,
  `skills/northstar/assets/templates/AGENTS.md`,
  `skills/northstar/assets/templates/CLAUDE.md.template`,
  `skills/northstar/assets/templates/.agents.local.env.example`,
  `skills/northstar/assets/templates/PAPERCUTS.md`,
  `skills/northstar/assets/templates/paseo.json.template`,
  `skills/northstar/scripts/paseo-worktree.rhai`,
  `skills/northstar/assets/templates/effigy.native.toml.template`,
  `skills/northstar/assets/templates/northstar-handoff.md.template`,
  `skills/northstar/assets/templates/northstar-discovery-delegate.md.template`,
  `skills/northstar/assets/templates/northstar-documentation-projection.md.template`

### Executable validation surface — 13 old paths retained; 3 added

- old task and checker paths: `scripts/README.md`,
  `scripts/check-northstar-bundle.rhai`,
  `scripts/check-northstar-repo-contract.rhai`,
  `scripts/check-northstar-posture-advisory.rhai`,
  `scripts/check-northstar-skill-install.rhai`,
  `scripts/check-northstar-readiness-map.rhai`,
  `scripts/check-northstar-command-skills.rhai`,
  `scripts/test-northstar-readiness-map.rhai`, `paseo.json`,
  `skills/northstar/effigy.toml`,
  `skills/northstar/scripts/check-agent-instructions.rhai`,
  `scripts/lib/northstar-repo-contract-data.rhai`,
  `scripts/lib/northstar-readiness-map.rhai`
- new executable paths: `effigy.toml`,
  `scripts/test-northstar-repo-contract.rhai`,
  `scripts/lib/northstar-repo-contract-checker.rhai`

### Parity surface — 2 old paths retained

- `template-bundle/specs/templates/batch-card-template.md`
- `skills/northstar/assets/templates/docs/specs/templates/batch-card-template.md`

### Historical inventory — 73 old paths removed from live policy

- closed or retired specs: `docs/specs/archive/007-currentness-curation-and-evidence-window.md`,
  `docs/specs/008-spec-lifecycle-and-archive-mechanics.md`,
  `docs/specs/009-archive-aware-skill-and-setup-surfaces.md`,
  `docs/specs/024-papercuts-feedback-loop.md`,
  `docs/specs/025-skill-distribution-and-consumer-papercut-proof.md`,
  `docs/specs/028-agent-instruction-surface-optimization.md`,
  `docs/specs/010-continuation-envelope-and-stop-signal-contract.md`,
  `docs/specs/011-lane-budget-and-pause-signal-contract.md`,
  `docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md`,
  `docs/specs/013-stricter-consumer-repo-autonomy-adoption.md`,
  `docs/specs/014-lane-first-stricter-adoption-starter-pack.md`,
  `docs/specs/015-full-strict-compliance-migration-program.md`,
  `docs/specs/016-strict-compliance-audit-and-rollout.md`
- historical milestones: `docs/roadmaps/g02/004-define-currentness-curation-and-evidence-window.md`,
  `docs/roadmaps/g02/005-tighten-spec-lifecycle-and-archive-mechanics.md`,
  `docs/roadmaps/g02/006-align-archive-aware-skill-and-setup-surfaces.md`,
  `docs/roadmaps/g02/007-define-continuation-envelope-and-stop-signal-contract.md`,
  `docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md`,
  `docs/roadmaps/g02/009-prove-combined-autonomy-model-in-consumer-repo.md`,
  `docs/roadmaps/g02/010-prove-stricter-autonomy-adoption-in-consumer-repo.md`,
  `docs/roadmaps/g02/011-define-lane-first-stricter-adoption-starter-pack.md`,
  `docs/roadmaps/g02/012-define-full-strict-compliance-migration-program.md`,
  `docs/roadmaps/g02/013-define-strict-compliance-audit-and-rollout-surface.md`,
  `docs/roadmaps/g02/022-repair-installed-skill-portability.md`,
  `docs/roadmaps/g02/023-add-papercuts-feedback-loop.md`,
  `docs/roadmaps/g02/024-harden-skill-distribution-and-consumer-papercut-proof.md`,
  `docs/roadmaps/g02/027-optimize-agent-instruction-surfaces.md`,
  `docs/roadmaps/g02/029-add-conversational-triage-and-docs-cleanup.md`
- historical batch cards: `docs/roadmaps/g02/batch-cards/023-prove-currentness-path-and-compile-next-slice.md`,
  `docs/roadmaps/g02/batch-cards/024-define-currentness-curation-rules.md`,
  `docs/roadmaps/g02/batch-cards/025-apply-currentness-curation-to-live-front-doors.md`,
  `docs/roadmaps/g02/batch-cards/026-reprove-front-door-path-after-curation.md`,
  `docs/roadmaps/g02/batch-cards/027-define-spec-lifecycle-and-archive-rule.md`,
  `docs/roadmaps/g02/batch-cards/028-apply-spec-lifecycle-rule-to-live-repo.md`,
  `docs/roadmaps/g02/batch-cards/029-reprove-specs-surface-after-lifecycle-update.md`,
  `docs/roadmaps/g02/batch-cards/030-define-archive-aware-skill-contract.md`,
  `docs/roadmaps/g02/batch-cards/031-apply-archive-aware-skill-alignment.md`,
  `docs/roadmaps/g02/batch-cards/032-reprove-archive-aware-surface.md`,
  `docs/roadmaps/g02/batch-cards/033-define-continuation-envelope-contract.md`,
  `docs/roadmaps/g02/batch-cards/034-apply-continuation-envelope-contract.md`,
  `docs/roadmaps/g02/batch-cards/035-reprove-continuation-envelope-contract.md`,
  `docs/roadmaps/g02/batch-cards/036-define-lane-budget-and-pause-signal-contract.md`,
  `docs/roadmaps/g02/batch-cards/037-apply-lane-budget-and-pause-signal-contract.md`,
  `docs/roadmaps/g02/batch-cards/038-reprove-lane-budget-and-pause-signal-contract.md`,
  `docs/roadmaps/g02/batch-cards/039-define-consumer-repo-autonomy-proof-lane.md`,
  `docs/roadmaps/g02/batch-cards/040-run-consumer-repo-autonomy-proof.md`,
  `docs/roadmaps/g02/batch-cards/041-apply-consumer-repo-autonomy-findings.md`,
  `docs/roadmaps/g02/batch-cards/042-define-stricter-adoption-proof-lane.md`,
  `docs/roadmaps/g02/batch-cards/043-run-stricter-consumer-repo-adoption-proof.md`,
  `docs/roadmaps/g02/batch-cards/044-apply-stricter-adoption-findings.md`,
  `docs/roadmaps/g02/batch-cards/045-define-lane-first-starter-pack.md`,
  `docs/roadmaps/g02/batch-cards/046-apply-lane-first-starter-pack-guidance.md`,
  `docs/roadmaps/g02/batch-cards/047-reprove-lane-first-adoption-surface.md`,
  `docs/roadmaps/g02/batch-cards/048-define-full-strict-target-state.md`,
  `docs/roadmaps/g02/batch-cards/049-apply-migration-program-guidance.md`,
  `docs/roadmaps/g02/batch-cards/050-reprove-full-strict-migration-surface.md`,
  `docs/roadmaps/g02/batch-cards/051-define-strict-compliance-audit-surface.md`,
  `docs/roadmaps/g02/batch-cards/052-apply-audit-and-rollout-guidance.md`,
  `docs/roadmaps/g02/batch-cards/053-reprove-audit-and-rollout-surface.md`,
  `docs/roadmaps/g02/batch-cards/065-repair-portable-skill-boundary.md`,
  `docs/roadmaps/g02/batch-cards/066-enforce-and-prove-skill-portability.md`,
  `docs/roadmaps/g02/batch-cards/067-add-papercuts-feedback-loop.md`,
  `docs/roadmaps/g02/batch-cards/068-document-and-prove-skill-distribution.md`,
  `docs/roadmaps/g02/batch-cards/069-run-consumer-papercuts-proof.md`,
  `docs/roadmaps/g02/batch-cards/079-audit-and-optimize-agent-instructions.md`,
  `docs/roadmaps/g02/batch-cards/080-define-triage-and-docs-cleanup-contract.md`,
  `docs/roadmaps/g02/batch-cards/081-apply-triage-and-docs-cleanup-surfaces.md`,
  `docs/roadmaps/g02/batch-cards/082-reprove-triage-and-docs-cleanup-surface.md`
- historical logs: `docs/logs/2026-07/28-101319-repair-installed-skill-portability.md`,
  `docs/logs/2026-08/06-000000-add-papercuts-feedback-loop.md`,
  `docs/logs/2026-08/06-120000-harden-skill-distribution-and-consumer-proof.md`,
  `docs/logs/2026-08/16-233931-optimize-agent-instruction-surface.md`,
  `docs/logs/2026-08/19-085645-add-triage-and-docs-cleanup.md`

## Fixture proof

`effigy test:repo-contract` runs seven isolated oracle rows. Missing structure,
broken distributed-skill links, and template parity drift fail with named
reasons. Token-like text, front-door rewording, papercut closeout text,
historical-evidence movement, source-preserving partition text, and removal of
an unlisted historical path pass. A source scan confirms that the removed
exact-content assertion data and calls are absent from the checker path.

## Validation

- baseline `effigy check:repo-contract` — pass;
- baseline `effigy check:readiness-map` — pass;
- baseline `effigy test:readiness-map` — pass (five fixtures);
- baseline `effigy check:command-skills` — pass (nine adapters);
- `effigy check:repo-contract` — pass;
- `effigy test:repo-contract` — pass (seven oracle rows; five benign variants);
- `effigy qa:docs` — pass, including the focused fixtures and unchanged
  readiness/command-surface checks;
- `effigy qa` — pass;
- `git diff --check` — clean.

## Limits

The experiment proves the checker boundary with local deterministic fixtures;
it does not claim that human review can be replaced for semantic contradiction,
misleading currentness, or historical-authority judgment. No historical file
was deleted, no consumer checkout was used, and no new currentness schema was
introduced.

## Next Task

Review the worker PR against all seven milestone rows and merge only after the
exact-head and required-check gate passes. Spec 034 remains a separate
not-ready planning lane.
