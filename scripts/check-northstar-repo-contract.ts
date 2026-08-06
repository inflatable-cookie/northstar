import {
  forbidContains,
  pass,
  repoRootFrom,
  requireContains,
  requireFile,
  requirePortableMarkdownLinks,
} from "./lib/checks";

const repoRoot = repoRootFrom(import.meta.dir);

const requiredFiles = [
  "AGENTS.md",
  "README.md",
  "PAPERCUTS.md",
  "docs/README.md",
  "docs/vision/README.md",
  "docs/architecture/README.md",
  "docs/contracts/README.md",
  "docs/roadmaps/README.md",
  "docs/roadmaps/generation-index.md",
  "docs/roadmaps/g02/README.md",
  "docs/logs/README.md",
  "docs/architecture/system-architecture.md",
  "docs/architecture/system-inventory.md",
  "docs/architecture/product-guardrails.md",
  "docs/contracts/contract-index.md",
  "docs/contracts/001-working-rules.md",
  "docs/specs/README.md",
  "docs/specs/archive/007-currentness-curation-and-evidence-window.md",
  "docs/specs/008-spec-lifecycle-and-archive-mechanics.md",
  "docs/specs/009-archive-aware-skill-and-setup-surfaces.md",
  "docs/specs/024-papercuts-feedback-loop.md",
  "docs/specs/025-skill-distribution-and-consumer-papercut-proof.md",
  "docs/specs/010-continuation-envelope-and-stop-signal-contract.md",
  "docs/specs/011-lane-budget-and-pause-signal-contract.md",
  "docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md",
  "docs/specs/013-stricter-consumer-repo-autonomy-adoption.md",
  "docs/specs/014-lane-first-stricter-adoption-starter-pack.md",
  "docs/specs/015-full-strict-compliance-migration-program.md",
  "docs/specs/016-strict-compliance-audit-and-rollout.md",
  "docs/specs/archive/README.md",
  "docs/roadmaps/g02/batch-cards/023-prove-currentness-path-and-compile-next-slice.md",
  "docs/roadmaps/g02/batch-cards/024-define-currentness-curation-rules.md",
  "docs/roadmaps/g02/batch-cards/025-apply-currentness-curation-to-live-front-doors.md",
  "docs/roadmaps/g02/batch-cards/026-reprove-front-door-path-after-curation.md",
  "docs/roadmaps/g02/batch-cards/027-define-spec-lifecycle-and-archive-rule.md",
  "docs/roadmaps/g02/batch-cards/028-apply-spec-lifecycle-rule-to-live-repo.md",
  "docs/roadmaps/g02/batch-cards/029-reprove-specs-surface-after-lifecycle-update.md",
  "docs/roadmaps/g02/batch-cards/030-define-archive-aware-skill-contract.md",
  "docs/roadmaps/g02/batch-cards/031-apply-archive-aware-skill-alignment.md",
  "docs/roadmaps/g02/batch-cards/032-reprove-archive-aware-surface.md",
  "docs/roadmaps/g02/batch-cards/033-define-continuation-envelope-contract.md",
  "docs/roadmaps/g02/batch-cards/034-apply-continuation-envelope-contract.md",
  "docs/roadmaps/g02/batch-cards/035-reprove-continuation-envelope-contract.md",
  "docs/roadmaps/g02/batch-cards/036-define-lane-budget-and-pause-signal-contract.md",
  "docs/roadmaps/g02/batch-cards/037-apply-lane-budget-and-pause-signal-contract.md",
  "docs/roadmaps/g02/batch-cards/038-reprove-lane-budget-and-pause-signal-contract.md",
  "docs/roadmaps/g02/batch-cards/039-define-consumer-repo-autonomy-proof-lane.md",
  "docs/roadmaps/g02/batch-cards/040-run-consumer-repo-autonomy-proof.md",
  "docs/roadmaps/g02/batch-cards/041-apply-consumer-repo-autonomy-findings.md",
  "docs/roadmaps/g02/batch-cards/042-define-stricter-adoption-proof-lane.md",
  "docs/roadmaps/g02/batch-cards/043-run-stricter-consumer-repo-adoption-proof.md",
  "docs/roadmaps/g02/batch-cards/044-apply-stricter-adoption-findings.md",
  "docs/roadmaps/g02/batch-cards/045-define-lane-first-starter-pack.md",
  "docs/roadmaps/g02/batch-cards/046-apply-lane-first-starter-pack-guidance.md",
  "docs/roadmaps/g02/batch-cards/047-reprove-lane-first-adoption-surface.md",
  "docs/roadmaps/g02/batch-cards/048-define-full-strict-target-state.md",
  "docs/roadmaps/g02/batch-cards/049-apply-migration-program-guidance.md",
  "docs/roadmaps/g02/batch-cards/050-reprove-full-strict-migration-surface.md",
  "docs/roadmaps/g02/batch-cards/051-define-strict-compliance-audit-surface.md",
  "docs/roadmaps/g02/batch-cards/052-apply-audit-and-rollout-guidance.md",
  "docs/roadmaps/g02/batch-cards/053-reprove-audit-and-rollout-surface.md",
  "docs/roadmaps/g02/004-define-currentness-curation-and-evidence-window.md",
  "docs/roadmaps/g02/005-tighten-spec-lifecycle-and-archive-mechanics.md",
  "docs/roadmaps/g02/006-align-archive-aware-skill-and-setup-surfaces.md",
  "docs/roadmaps/g02/007-define-continuation-envelope-and-stop-signal-contract.md",
  "docs/roadmaps/g02/008-define-lane-budget-and-pause-signal-contract.md",
  "docs/roadmaps/g02/009-prove-combined-autonomy-model-in-consumer-repo.md",
  "docs/roadmaps/g02/010-prove-stricter-autonomy-adoption-in-consumer-repo.md",
  "docs/roadmaps/g02/011-define-lane-first-stricter-adoption-starter-pack.md",
  "docs/roadmaps/g02/012-define-full-strict-compliance-migration-program.md",
  "docs/roadmaps/g02/013-define-strict-compliance-audit-and-rollout-surface.md",
  "docs/roadmaps/g02/022-repair-installed-skill-portability.md",
  "docs/roadmaps/g02/023-add-papercuts-feedback-loop.md",
  "docs/roadmaps/g02/024-harden-skill-distribution-and-consumer-papercut-proof.md",
  "docs/roadmaps/g02/batch-cards/065-repair-portable-skill-boundary.md",
  "docs/roadmaps/g02/batch-cards/066-enforce-and-prove-skill-portability.md",
  "docs/roadmaps/g02/batch-cards/067-add-papercuts-feedback-loop.md",
  "docs/roadmaps/g02/batch-cards/068-document-and-prove-skill-distribution.md",
  "docs/roadmaps/g02/batch-cards/069-run-consumer-papercuts-proof.md",
  "docs/logs/2026-07/28-101319-repair-installed-skill-portability.md",
  "docs/logs/2026-08/06-000000-add-papercuts-feedback-loop.md",
  "docs/logs/2026-08/06-120000-harden-skill-distribution-and-consumer-proof.md",
  "bundle-docs/README.md",
  "bundle-docs/cheat-sheet.md",
  "bundle-docs/papercuts.md",
  "bundle-docs/protocol-kernel.md",
  "bundle-docs/operators/operator-quick-start.md",
  "bundle-docs/sections/07-delivery-framework-and-autonomy.md",
  "bundle-docs/sections/09-standard-docs-spine.md",
  "bundle-docs/sections/10-automation-runtime-policy.md",
  "scripts/README.md",
  "scripts/check-northstar-bundle.rhai",
  "scripts/check-northstar-repo-contract.ts",
  "scripts/check-northstar-posture-advisory.rhai",
  "scripts/check-northstar-skill-install.rhai",
  "scripts/lib/checks.ts",
  "template-bundle/README.md",
  "template-bundle/specs/archive/README.md",
  "template-bundle/contracts/001-working-rules-template.md",
  "template-bundle/roadmaps/g01/batch-cards/README.md",
  "skills/northstar/SKILL.md",
  "skills/northstar/agents/openai.yaml",
  "skills/northstar/references/router.md",
  "skills/northstar/references/handoff-contract.md",
  "skills/northstar/references/setup/repo-contract.md",
  "skills/northstar/references/setup/adoption-modes.md",
  "skills/northstar/references/setup/delivery-layer-adoption.md",
  "skills/northstar/references/setup/monkey-example.md",
  "skills/northstar/references/modes/normalize-docs.md",
  "skills/northstar/references/modes/handoff.md",
  "skills/northstar/references/modes/plan-from-scratch.md",
  "skills/northstar/references/modes/shape-with-specs-and-promote.md",
  "skills/northstar/references/modes/compile-roadmaps.md",
  "skills/northstar/references/modes/research.md",
  "skills/northstar/references/modes/replan-after-change.md",
  "skills/northstar/references/modes/refocus-drifted-project.md",
  "skills/northstar/references/modes/sweep-audit-repair.md",
  "skills/northstar/assets/templates/README.md",
  "skills/northstar/assets/templates/AGENTS.md",
  "skills/northstar/assets/templates/PAPERCUTS.md",
  "skills/northstar/assets/templates/effigy.native.toml.template",
  "skills/northstar/assets/templates/northstar-handoff.md.template",
] as const;

for (const file of requiredFiles) {
  requireFile(repoRoot, file);
}

requirePortableMarkdownLinks(repoRoot, "skills/northstar");

requireContains(repoRoot, "AGENTS.md", "effigy tasks", "Effigy discovery step");
requireContains(repoRoot, "AGENTS.md", "effigy doctor", "Effigy doctor step");
requireContains(repoRoot, "AGENTS.md", "effigy qa", "Effigy QA step");
requireContains(repoRoot, "AGENTS.md", "check:posture-advisory", "AGENTS posture advisory hint");
requireContains(repoRoot, "AGENTS.md", "PAPERCUTS.md", "AGENTS papercuts loop");

requireContains(repoRoot, "README.md", "effigy tasks", "Effigy discovery step");
requireContains(repoRoot, "README.md", "effigy doctor", "Effigy doctor step");
requireContains(repoRoot, "README.md", "effigy qa", "Effigy QA step");
requireContains(repoRoot, "README.md", "check:posture-advisory", "README posture advisory hint");
requireContains(repoRoot, "README.md", "skills/northstar/", "northstar skill entry point");
requireContains(repoRoot, "README.md", "docs/README.md", "live docs entry point");
requireContains(repoRoot, "README.md", "PAPERCUTS.md", "README papercuts entry point");

requireContains(repoRoot, "bundle-docs/README.md", "effigy tasks", "Effigy discovery step");
requireContains(repoRoot, "bundle-docs/README.md", "effigy doctor", "Effigy doctor step");
requireContains(repoRoot, "bundle-docs/README.md", "effigy qa", "Effigy QA step");
requireContains(repoRoot, "bundle-docs/README.md", "delivery/autonomy layer", "delivery doctrine reference");
requireContains(repoRoot, "bundle-docs/README.md", "standard docs spine", "standard docs spine reference");
requireContains(repoRoot, "bundle-docs/README.md", "protocol-kernel.md", "bundle docs protocol kernel entry");
requireContains(repoRoot, "bundle-docs/README.md", "skills/northstar/", "bundle docs northstar skill entry");
requireContains(repoRoot, "bundle-docs/README.md", "papercuts.md", "bundle docs papercuts entry");
requireContains(repoRoot, "bundle-docs/skills/README.md", "one installable agent skill", "skills README single skill doctrine");
requireContains(repoRoot, "bundle-docs/skills/README.md", "one-folder artifact", "portable skill boundary");
requireContains(repoRoot, "bundle-docs/cheat-sheet.md", "check:posture-advisory", "cheat sheet posture advisory command");
requireContains(repoRoot, "bundle-docs/protocol-kernel.md", "check:posture-advisory", "protocol kernel posture advisory hint");
requireContains(repoRoot, "bundle-docs/protocol-kernel.md", "Agent execution feedback", "protocol kernel papercuts row");
requireContains(repoRoot, "bundle-docs/papercuts.md", "must append", "papercuts agent contract");
requireContains(repoRoot, "bundle-docs/sections/10-automation-runtime-policy.md", "check:posture-advisory", "automation policy posture advisory hint");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Ready-state rubric", "ready-state doctrine heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Closeout pattern", "closeout doctrine heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Autonomy support levels", "autonomy support levels heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Full strict compliance", "full strict compliance heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Migration phases", "migration phases heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Migration checkpoints", "migration checkpoints heading");
requireContains(repoRoot, "template-bundle/README.md", "Standard docs spines", "template bundle spine heading");
requireContains(repoRoot, "template-bundle/README.md", "contracts/001-working-rules-template.md", "working-rules template reference");
requireContains(repoRoot, "template-bundle/README.md", "continuation envelopes, lane budgets, pause signals", "template bundle stricter autonomy wording");
requireContains(repoRoot, "template-bundle/README.md", "PAPERCUTS.md", "template bundle papercuts companion");
requireContains(repoRoot, "template-bundle/specs/templates/batch-card-template.md", "## Ready-State Checks", "batch-card ready-state section");
requireContains(repoRoot, "template-bundle/specs/templates/batch-card-template.md", "## Continuation Envelope", "batch-card continuation section");
requireContains(repoRoot, "template-bundle/specs/templates/batch-card-template.md", "## Lane Budget", "batch-card lane-budget section");
requireContains(repoRoot, "template-bundle/specs/templates/batch-card-template.md", "## Closeout Sequence", "batch-card closeout section");
requireContains(repoRoot, "template-bundle/roadmaps/templates/roadmap-milestone-template.md", "## Execution Readiness", "roadmap readiness section");
requireContains(repoRoot, "template-bundle/logs/README.md", "## Closeout rule", "bundle logs closeout rule");
requireContains(repoRoot, "template-bundle/logs/README.md", "## Continuation note", "bundle logs continuation note");
requireContains(repoRoot, "template-bundle/logs/README.md", "lane budget state and pause signal", "bundle logs lane-budget note");
requireContains(repoRoot, "template-bundle/specs/README.md", "`active`", "template specs active lifecycle state");
requireContains(repoRoot, "template-bundle/specs/README.md", "`retired-in-place`", "template specs retired lifecycle state");
requireContains(repoRoot, "template-bundle/specs/README.md", "full continuation-envelope, lane-budget, and pause-signal", "template specs autonomy threshold wording");
requireContains(repoRoot, "template-bundle/specs/README.md", "`archived`", "template specs archived lifecycle state");
requireContains(repoRoot, "template-bundle/specs/README.md", "seed `docs/specs/archive/README.md` up front", "template specs seeded archive posture");
requireContains(repoRoot, "template-bundle/specs/archive/README.md", "closed planning artifacts", "template specs archive purpose");
requireContains(repoRoot, "template-bundle/specs/archive/README.md", "seed this README from the start", "template specs archive seeded from start");

requireContains(repoRoot, "skills/northstar/SKILL.md", "references/router.md", "northstar skill router");
requireContains(repoRoot, "skills/northstar/SKILL.md", "protocol-kernel.md", "northstar skill protocol kernel pointer");
requireContains(repoRoot, "skills/northstar/SKILL.md", "Handoff", "northstar skill handoff mode table");
requireContains(repoRoot, "skills/northstar/SKILL.md", "Normalize docs", "northstar skill normalize mode table");
requireContains(repoRoot, "skills/northstar/SKILL.md", "Papercuts loop", "northstar skill papercuts loop");
requireContains(repoRoot, "skills/northstar/references/router.md", "Handoff (explicit only)", "router handoff gate");
requireContains(repoRoot, "skills/northstar/references/router.md", "bare `continue`", "router handoff anti-trigger");
requireContains(repoRoot, "skills/northstar/references/modes/normalize-docs.md", "../setup/adoption-modes.md", "normalize adoption modes ref");
requireContains(repoRoot, "skills/northstar/references/modes/normalize-docs.md", "check:posture-advisory", "normalize posture advisory hint");
requireContains(repoRoot, "skills/northstar/references/setup/delivery-layer-adoption.md", "Baseline Mode Is Enough When", "delivery layer baseline mode heading");
requireContains(repoRoot, "skills/northstar/references/setup/repo-contract.md", "Baseline docs spine", "baseline docs spine contract");
requireContains(repoRoot, "skills/northstar/agents/openai.yaml", "references/router.md", "openai default router");
requireContains(repoRoot, "skills/northstar/agents/openai.yaml", "PAPERCUTS.md", "openai papercuts prompt");
requireContains(repoRoot, "skills/northstar/references/modes/compile-roadmaps.md", "Do not mark a batch `ready` just because it is next in sequence.", "compile-roadmaps readiness guardrail");
requireContains(repoRoot, "skills/northstar/references/modes/handoff.md", "explicit trigger only", "handoff mode explicit gate");
requireContains(repoRoot, "skills/northstar/references/handoff-contract.md", "Do not use it as a substitute for proper closeout in the live planning spine.", "handoff contract closeout rule");
requireContains(repoRoot, "skills/northstar/assets/templates/northstar-handoff.md.template", "Confirm the current batch card already reflects the stopping point.", "handoff template closeout step");
forbidContains(repoRoot, "skills/northstar/SKILL.md", "northstar-setup", "retired setup skill name in northstar skill");
forbidContains(repoRoot, "skills/northstar/SKILL.md", "northstar-plan", "retired plan skill name in northstar skill");
requireContains(repoRoot, "scripts/README.md", "TypeScript", "scripts README runtime language");
requireContains(repoRoot, "scripts/README.md", "bun", "scripts README bun policy");
requireContains(repoRoot, "scripts/README.md", "npx skills update northstar -g -y", "published skill update command");
requireContains(repoRoot, "scripts/README.md", "effigy check:skill-install", "skill parity checker command");
requireContains(repoRoot, "bundle-docs/skills/README.md", "npx skills update northstar -g -y", "skills distribution update command");
requireContains(repoRoot, "bundle-docs/skills/README.md", "effigy check:skill-install", "skills distribution parity command");
requireContains(repoRoot, "scripts/README.md", "check:posture-advisory", "scripts README posture advisory task");
requireContains(repoRoot, "scripts/README.md", "[northstar:advisory]", "scripts README advisory prefix");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Ready-state rubric", "working-rules readiness heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Continuation envelope", "working-rules continuation heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Lane budget and pause signals", "working-rules lane-budget heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Closeout pattern", "working-rules closeout heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Strict-compliance audit and rollout", "working-rules audit heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "Full doctrine enumerations for batch-card fields", "working-rules doctrine pointer");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "`active`, `retired-in-place`, and `archived`", "working-rules spec lifecycle states");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Papercuts feedback loop", "working-rules papercuts contract");
requireContains(repoRoot, "template-bundle/contracts/001-working-rules-template.md", "### Papercuts feedback loop", "working-rules template papercuts contract");
requireContains(repoRoot, "bundle-docs/operators/operator-quick-start.md", "protocol-kernel.md", "operator quick start protocol kernel link");
requireContains(repoRoot, "docs/README.md", "specs/024-papercuts-feedback-loop.md", "active spec front door");
requireContains(repoRoot, "docs/README.md", "specs/025-skill-distribution-and-consumer-papercut-proof.md", "distribution spec front door");
requireContains(repoRoot, "docs/roadmaps/README.md", "`g02` is the active generation", "roadmaps active generation");
requireContains(repoRoot, "docs/roadmaps/README.md", "`g02/README.md` owns the active generation runway", "roadmaps generation runway pointer");
requireContains(repoRoot, "docs/roadmaps/README.md", "`g02.020` and `g02.021` are complete", "roadmaps g02.020 and g02.021 complete");
requireContains(repoRoot, "docs/roadmaps/README.md", "`g02.022` is complete", "roadmaps g02.022 complete");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "## Generation Runway", "g02 generation runway heading");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "per-turn task list", "g02 generation runway stability note");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "018-add-workspace-container-adoption-specimen.md", "g02 milestone listing");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "020-add-protocol-kernel-and-dedupe-canonical-surfaces.md", "g02 milestone listing tail");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "021-add-posture-and-archive-advisory-checks-to-effigy.md", "g02 milestone listing end");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "022-repair-installed-skill-portability.md", "g02 portability milestone");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "`g02.024` is complete", "g02 distribution proof closeout");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "023-add-papercuts-feedback-loop.md", "g02 papercuts milestone");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "024-harden-skill-distribution-and-consumer-papercut-proof.md", "g02 distribution milestone");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "consumer papercuts evidence", "g02 consumer evidence next task");
requireContains(repoRoot, "docs/roadmaps/generation-index.md", "## Runway rule", "generation index runway rule");
requireContains(repoRoot, "docs/roadmaps/generation-index.md", "No blocking roadmap milestone is open", "generation index next task");
requireContains(repoRoot, "docs/logs/README.md", "## Closeout rule", "live logs closeout rule");
requireContains(repoRoot, "docs/logs/README.md", "## Still-governing context", "logs context heading");
requireContains(repoRoot, "docs/logs/README.md", "## Recent active-lane evidence", "logs evidence heading");
requireContains(repoRoot, "docs/logs/README.md", "09-111500-roll-to-g02-external-pilot.md", "governing context log");
requireContains(repoRoot, "docs/logs/README.md", "20-144500-consolidate-northstar-skill-surface.md", "latest active-lane log");
requireContains(repoRoot, "docs/logs/README.md", "28-101319-repair-installed-skill-portability.md", "portability repair log");
requireContains(repoRoot, "docs/logs/README.md", "06-120000-harden-skill-distribution-and-consumer-proof.md", "distribution proof log");
forbidContains(repoRoot, "docs/logs/README.md", "08-120000-bootstrap-live-northstar-docs.md", "stale bootstrap log in bounded evidence window");
forbidContains(repoRoot, "docs/logs/README.md", "09-205500-open-currentness-alignment-lane.md", "older currentness-alignment log in bounded evidence window");
forbidContains(repoRoot, "docs/logs/README.md", "09-121500-select-signal-pilot-target.md", "old pilot-selection log in bounded evidence window");
forbidContains(repoRoot, "docs/README.md", "## Next Task", "docs front door should not own live next task");
forbidContains(repoRoot, "docs/vision/README.md", "## Next Task", "vision front door should not own live next task");
forbidContains(repoRoot, "docs/architecture/README.md", "## Next Task", "architecture front door should not own live next task");
forbidContains(repoRoot, "docs/contracts/README.md", "## Next Task", "contracts front door should not own live next task");
forbidContains(repoRoot, "docs/contracts/contract-index.md", "## Next Task", "contract index should not own live next task");
forbidContains(repoRoot, "docs/logs/README.md", "## Next Task", "logs front door should not own live next task");
requireContains(repoRoot, "docs/specs/README.md", "19-172500-add-posture-advisory-effigy-checks.md", "specs README g02.021 closeout evidence");
requireContains(repoRoot, "docs/specs/README.md", "`effigy check:posture-advisory`", "specs README advisory task hint");
requireContains(repoRoot, "template-bundle/specs/README.md", "templates/strict-compliance-migration-template.md", "strict migration template listing");

requireContains(repoRoot, "effigy.toml", '"check:bundle" = [{ rhai = "scripts/check-northstar-bundle.rhai" }]', "Rhai bundle checker task");
requireContains(repoRoot, "effigy.toml", "bun run ./scripts/check-northstar-repo-contract.ts", "bun repo checker task");
requireContains(repoRoot, "effigy.toml", "check:posture-advisory", "posture advisory task name");
requireContains(repoRoot, "effigy.toml", '"check:posture-advisory" = [{ rhai = "scripts/check-northstar-posture-advisory.rhai" }]', "Rhai posture advisory checker task");
requireContains(repoRoot, "effigy.toml", "check:skill-install", "Rhai skill parity task");
requireContains(repoRoot, "effigy.toml", "scripts/check-northstar-skill-install.rhai", "Rhai skill parity script");
requireContains(repoRoot, "skills/northstar/references/handoff-contract.md", "remaining continuation envelope", "handoff contract continuation state");
requireContains(repoRoot, "skills/northstar/assets/templates/northstar-handoff.md.template", "Lane budget / pause signal", "handoff template lane-budget state");
forbidContains(repoRoot, "README.md", "skills/northstar-setup/", "retired northstar-setup path in README");
forbidContains(repoRoot, "README.md", "skills/northstar-plan/", "retired northstar-plan path in README");
requireContains(repoRoot, "template-bundle/logs/templates/thread-handoff-template.md", "Remaining continuation envelope", "bundle handoff continuation state");
requireContains(repoRoot, "template-bundle/logs/templates/thread-handoff-template.md", "Lane budget / pause signal", "bundle handoff lane-budget state");
requireContains(repoRoot, "template-bundle/logs/templates/thread-handoff-template.md", "Confirm the current batch card already reflects the stopping point.", "bundle handoff closeout step");

forbidContains(repoRoot, "AGENTS.md", "--repo .", "current-repo flag example");
forbidContains(repoRoot, "README.md", "--repo .", "current-repo flag example");
forbidContains(repoRoot, "bundle-docs/README.md", "--repo .", "current-repo flag example");
forbidContains(repoRoot, "scripts/README.md", "--repo .", "current-repo flag example");
forbidContains(repoRoot, "effigy.toml", "bash ./scripts/check-northstar-bundle.sh", "legacy bash checker task");
forbidContains(repoRoot, "effigy.toml", "bash ./scripts/check-northstar-repo-contract.sh", "legacy bash checker task");

pass("Northstar repo contract checks: OK");
