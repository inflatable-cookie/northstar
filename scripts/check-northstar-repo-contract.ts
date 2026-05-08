import {
  forbidContains,
  pass,
  repoRootFrom,
  requireContains,
  requireFile,
} from "./lib/checks";

const repoRoot = repoRootFrom(import.meta.dir);

const requiredFiles = [
  "AGENTS.md",
  "README.md",
  "docs/README.md",
  "docs/vision/README.md",
  "docs/roadmaps/README.md",
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
  "docs/specs/010-continuation-envelope-and-stop-signal-contract.md",
  "docs/specs/011-lane-budget-and-pause-signal-contract.md",
  "docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md",
  "docs/specs/013-stricter-consumer-repo-autonomy-adoption.md",
  "docs/specs/014-lane-first-stricter-adoption-starter-pack.md",
  "docs/specs/015-full-strict-compliance-migration-program.md",
  "docs/specs/016-strict-compliance-audit-and-rollout.md",
  "docs/specs/archive/README.md",
  "docs/specs/archive/batch-cards/023-prove-currentness-path-and-compile-next-slice.md",
  "docs/specs/archive/batch-cards/024-define-currentness-curation-rules.md",
  "docs/specs/archive/batch-cards/025-apply-currentness-curation-to-live-front-doors.md",
  "docs/specs/archive/batch-cards/026-reprove-front-door-path-after-curation.md",
  "docs/specs/archive/batch-cards/027-define-spec-lifecycle-and-archive-rule.md",
  "docs/specs/batch-cards/028-apply-spec-lifecycle-rule-to-live-repo.md",
  "docs/specs/batch-cards/029-reprove-specs-surface-after-lifecycle-update.md",
  "docs/specs/batch-cards/030-define-archive-aware-skill-contract.md",
  "docs/specs/batch-cards/031-apply-archive-aware-skill-alignment.md",
  "docs/specs/batch-cards/032-reprove-archive-aware-surface.md",
  "docs/specs/batch-cards/033-define-continuation-envelope-contract.md",
  "docs/specs/batch-cards/034-apply-continuation-envelope-contract.md",
  "docs/specs/batch-cards/035-reprove-continuation-envelope-contract.md",
  "docs/specs/batch-cards/036-define-lane-budget-and-pause-signal-contract.md",
  "docs/specs/batch-cards/037-apply-lane-budget-and-pause-signal-contract.md",
  "docs/specs/batch-cards/038-reprove-lane-budget-and-pause-signal-contract.md",
  "docs/specs/batch-cards/039-define-consumer-repo-autonomy-proof-lane.md",
  "docs/specs/batch-cards/040-run-consumer-repo-autonomy-proof.md",
  "docs/specs/batch-cards/041-apply-consumer-repo-autonomy-findings.md",
  "docs/specs/batch-cards/042-define-stricter-adoption-proof-lane.md",
  "docs/specs/batch-cards/043-run-stricter-consumer-repo-adoption-proof.md",
  "docs/specs/batch-cards/044-apply-stricter-adoption-findings.md",
  "docs/specs/batch-cards/045-define-lane-first-starter-pack.md",
  "docs/specs/batch-cards/046-apply-lane-first-starter-pack-guidance.md",
  "docs/specs/batch-cards/047-reprove-lane-first-adoption-surface.md",
  "docs/specs/batch-cards/048-define-full-strict-target-state.md",
  "docs/specs/batch-cards/049-apply-migration-program-guidance.md",
  "docs/specs/batch-cards/050-reprove-full-strict-migration-surface.md",
  "docs/specs/batch-cards/051-define-strict-compliance-audit-surface.md",
  "docs/specs/batch-cards/052-apply-audit-and-rollout-guidance.md",
  "docs/specs/batch-cards/053-reprove-audit-and-rollout-surface.md",
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
  "bundle-docs/README.md",
  "bundle-docs/sections/07-delivery-framework-and-autonomy.md",
  "bundle-docs/sections/09-standard-docs-spine.md",
  "bundle-docs/sections/10-automation-runtime-policy.md",
  "scripts/README.md",
  "scripts/check-northstar-bundle.ts",
  "scripts/check-northstar-repo-contract.ts",
  "scripts/lib/checks.ts",
  "template-bundle/README.md",
  "template-bundle/specs/archive/README.md",
  "template-bundle/contracts/001-working-rules-template.md",
  "template-bundle/roadmaps/g01/batch-cards/README.md",
  "skills/northstar-setup/SKILL.md",
  "skills/northstar-setup/agents/openai.yaml",
  "skills/northstar-setup/references/repo-contract.md",
  "skills/northstar-setup/references/adoption-modes.md",
  "skills/northstar-setup/references/monkey-example.md",
  "skills/northstar-setup/assets/templates/README.md",
  "skills/northstar-setup/assets/templates/AGENTS.md",
  "skills/northstar-setup/assets/templates/CHANGELOG.md",
  "skills/northstar-setup/assets/templates/docs.README.md.template",
  "skills/northstar-setup/assets/templates/scripts.README.md.template",
  "skills/northstar-setup/assets/templates/effigy.native.toml.template",
  "skills/northstar-setup/assets/templates/effigy.compat.toml.template",
  "skills/northstar-plan/SKILL.md",
  "skills/northstar-plan/agents/openai.yaml",
  "skills/northstar-plan/references/modes/plan-from-scratch.md",
  "skills/northstar-plan/references/modes/compile-roadmaps.md",
  "skills/northstar-recover/SKILL.md",
  "skills/northstar-recover/agents/openai.yaml",
  "skills/northstar-recover/references/modes/replan-after-change.md",
  "skills/northstar-recover/references/modes/refocus-drifted-project.md",
  "skills/northstar-recover/references/modes/sweep-audit-repair.md",
] as const;

for (const file of requiredFiles) {
  requireFile(repoRoot, file);
}

requireContains(repoRoot, "AGENTS.md", "effigy tasks", "Effigy discovery step");
requireContains(repoRoot, "AGENTS.md", "effigy doctor", "Effigy doctor step");
requireContains(repoRoot, "AGENTS.md", "effigy qa", "Effigy QA step");

requireContains(repoRoot, "README.md", "effigy tasks", "Effigy discovery step");
requireContains(repoRoot, "README.md", "effigy doctor", "Effigy doctor step");
requireContains(repoRoot, "README.md", "effigy qa", "Effigy QA step");
requireContains(repoRoot, "README.md", "skills/northstar-setup/", "setup skill entry point");
requireContains(repoRoot, "README.md", "skills/northstar-plan/", "plan skill entry point");
requireContains(repoRoot, "README.md", "skills/northstar-recover/", "recover skill entry point");
requireContains(repoRoot, "README.md", "docs/README.md", "live docs entry point");

requireContains(repoRoot, "bundle-docs/README.md", "effigy tasks", "Effigy discovery step");
requireContains(repoRoot, "bundle-docs/README.md", "effigy doctor", "Effigy doctor step");
requireContains(repoRoot, "bundle-docs/README.md", "effigy qa", "Effigy QA step");
requireContains(repoRoot, "bundle-docs/README.md", "delivery/autonomy layer", "delivery doctrine reference");
requireContains(repoRoot, "bundle-docs/README.md", "standard docs spine", "standard docs spine reference");
requireContains(repoRoot, "bundle-docs/README.md", "automation runtime policy", "runtime policy reference");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Ready-state rubric", "ready-state doctrine heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Closeout pattern", "closeout doctrine heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Autonomy support levels", "autonomy support levels heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Full strict compliance", "full strict compliance heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Migration phases", "migration phases heading");
requireContains(repoRoot, "bundle-docs/sections/07-delivery-framework-and-autonomy.md", "## Migration checkpoints", "migration checkpoints heading");
requireContains(repoRoot, "template-bundle/README.md", "Standard docs spines", "template bundle spine heading");
requireContains(repoRoot, "template-bundle/README.md", "contracts/001-working-rules-template.md", "working-rules template reference");
requireContains(repoRoot, "template-bundle/README.md", "continuation envelopes, lane budgets, pause signals", "template bundle stricter autonomy wording");
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

requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "use Northstar and Effigy", "setup skill trigger language");
requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "references/adoption-modes.md", "adoption mode reference");
requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "effigy docs --help", "PATH verification step");
requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "references/monkey-example.md", "consumer example reference");
requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "standard docs spine", "standard docs spine language");
requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "TypeScript", "TypeScript runtime language");
requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "bun", "Bun runtime language");
requireContains(repoRoot, "skills/northstar-setup/SKILL.md", "docs/specs/archive/README.md", "setup skill archive surface");
requireContains(repoRoot, "skills/northstar-setup/agents/openai.yaml", "display_name", "OpenAI skill metadata");
requireContains(repoRoot, "skills/northstar-setup/assets/templates/README.md", "effigy.native.toml.template", "native template selection");
requireContains(repoRoot, "skills/northstar-setup/assets/templates/README.md", "effigy.compat.toml.template", "compatibility template selection");
requireContains(repoRoot, "skills/northstar-setup/assets/templates/README.md", "scripts.README.md.template", "scripts template selection");
requireContains(repoRoot, "skills/northstar-setup/assets/templates/docs.README.md.template", "contracts/001-working-rules.md", "stricter docs spine template ref");
requireContains(repoRoot, "skills/northstar-setup/assets/templates/scripts.README.md.template", "TypeScript", "scripts template runtime language");
requireContains(repoRoot, "skills/northstar-setup/references/repo-contract.md", "Baseline docs spine", "baseline docs spine contract");
requireContains(repoRoot, "skills/northstar-setup/references/repo-contract.md", "TypeScript", "repo contract TypeScript policy");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "docs/specs/archive/README.md", "delivery layer archive surface");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "Baseline Mode Is Enough When", "delivery layer baseline mode heading");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "Lane-First Stricter Adoption", "delivery layer lane-first heading");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "Full Strict Compliance Target", "delivery layer full strict heading");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "Migration Phases", "delivery layer migration phases heading");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "Audit The Current Posture", "delivery layer audit heading");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "Rollout Tracking Pattern", "delivery layer rollout heading");
requireContains(repoRoot, "skills/northstar-setup/references/delivery-layer-adoption.md", "roadmap-only repos can still route active work cleanly", "delivery layer proof-backed baseline wording");
requireContains(repoRoot, "scripts/README.md", "TypeScript", "scripts README runtime language");
requireContains(repoRoot, "scripts/README.md", "bun", "scripts README bun policy");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Ready-state rubric", "working-rules readiness heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Continuation envelope", "working-rules continuation heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Lane budget and pause signals", "working-rules lane-budget heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Closeout pattern", "working-rules closeout heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "### Strict-compliance audit and rollout", "working-rules audit heading");
requireContains(repoRoot, "docs/contracts/001-working-rules.md", "`active`, `retired-in-place`, and `archived`", "working-rules spec lifecycle states");
requireContains(repoRoot, "docs/logs/README.md", "## Closeout rule", "live logs closeout rule");
requireContains(repoRoot, "docs/README.md", "specs/022-formalize-repo-posture-classification.md", "active spec front door");
requireContains(repoRoot, "docs/README.md", "roadmaps/g02/019-formalize-repo-posture-classification.md", "active roadmap front door");
requireContains(repoRoot, "docs/README.md", "Execute the repo-posture classification lane", "live docs next task");
requireContains(repoRoot, "docs/roadmaps/README.md", "`g02` is the active generation", "roadmaps active generation");
requireContains(repoRoot, "docs/roadmaps/README.md", "`g02.019` is the current milestone", "roadmaps active milestone");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "018-add-workspace-container-adoption-specimen.md", "g02 milestone listing");
requireContains(repoRoot, "docs/roadmaps/g02/README.md", "Execute `g02.019`", "g02 next task");
requireContains(repoRoot, "docs/roadmaps/generation-index.md", "Use `g02.019` to formalize repo-posture classification", "generation index next task");
requireContains(repoRoot, "docs/contracts/contract-index.md", "`g02.019` is the active setup/package lane", "contract index current lane");
requireContains(repoRoot, "docs/logs/README.md", "## Still-governing context", "logs context heading");
requireContains(repoRoot, "docs/logs/README.md", "## Recent active-lane evidence", "logs evidence heading");
requireContains(repoRoot, "docs/logs/README.md", "09-111500-roll-to-g02-external-pilot.md", "governing context log");
requireContains(repoRoot, "docs/logs/README.md", "10-231500-apply-signal-migration-proof-findings.md", "latest active-lane log");
requireContains(repoRoot, "docs/logs/README.md", "Execute `g02.019`", "logs next task");
forbidContains(repoRoot, "docs/logs/README.md", "08-120000-bootstrap-live-northstar-docs.md", "stale bootstrap log in bounded evidence window");
forbidContains(repoRoot, "docs/logs/README.md", "09-205500-open-currentness-alignment-lane.md", "older currentness-alignment log in bounded evidence window");
forbidContains(repoRoot, "docs/logs/README.md", "09-121500-select-signal-pilot-target.md", "old pilot-selection log in bounded evidence window");
requireContains(repoRoot, "docs/specs/README.md", "022-formalize-repo-posture-classification.md", "specs README next task");
requireContains(repoRoot, "template-bundle/specs/README.md", "templates/strict-compliance-migration-template.md", "strict migration template listing");

requireContains(repoRoot, "effigy.toml", "bun run ./scripts/check-northstar-bundle.ts", "bun bundle checker task");
requireContains(repoRoot, "effigy.toml", "bun run ./scripts/check-northstar-repo-contract.ts", "bun repo checker task");
requireContains(repoRoot, "skills/northstar-plan/SKILL.md", "references/modes/plan-from-scratch.md", "plan mode reference");
requireContains(repoRoot, "skills/northstar-plan/SKILL.md", "references/modes/compile-roadmaps.md", "roadmap mode reference");
requireContains(repoRoot, "skills/northstar-plan/SKILL.md", "readiness rubric", "plan readiness wording");
requireContains(repoRoot, "skills/northstar-plan/SKILL.md", "docs/specs/archive/README.md", "plan skill archive surface");
requireContains(repoRoot, "skills/northstar-plan/SKILL.md", "continuation envelope", "plan continuation envelope wording");
requireContains(repoRoot, "skills/northstar-plan/references/modes/compile-roadmaps.md", "Do not mark a batch `ready` just because it is next in sequence.", "plan readiness guardrail");
requireContains(repoRoot, "skills/northstar-recover/SKILL.md", "references/modes/replan-after-change.md", "replan mode reference");
requireContains(repoRoot, "skills/northstar-recover/SKILL.md", "references/modes/refocus-drifted-project.md", "refocus mode reference");
requireContains(repoRoot, "skills/northstar-recover/SKILL.md", "references/modes/sweep-audit-repair.md", "sweep mode reference");
requireContains(repoRoot, "skills/northstar-recover/SKILL.md", "docs/specs/archive/README.md", "recover skill archive surface");
requireContains(repoRoot, "skills/northstar-handoff/SKILL.md", "Treat handoff as the fourth closeout step", "handoff closeout ordering");
requireContains(repoRoot, "skills/northstar-handoff/SKILL.md", "continuation envelope", "handoff continuation wording");
requireContains(repoRoot, "skills/northstar-handoff/SKILL.md", "pause signal", "handoff pause-signal wording");
requireContains(repoRoot, "skills/northstar-handoff/SKILL.md", "Do not use a handoff as a substitute for the batch log or roadmap update.", "handoff closeout guardrail");
requireContains(repoRoot, "skills/northstar-handoff/references/handoff-contract.md", "remaining continuation envelope", "handoff contract continuation state");
requireContains(repoRoot, "skills/northstar-handoff/references/handoff-contract.md", "pause signal", "handoff contract pause-signal state");
requireContains(repoRoot, "skills/northstar-handoff/references/handoff-contract.md", "Do not use it as a substitute for proper closeout in the live planning spine.", "handoff contract closeout rule");
requireContains(repoRoot, "skills/northstar-handoff/assets/templates/northstar-handoff.md.template", "Remaining continuation envelope", "handoff template continuation state");
requireContains(repoRoot, "skills/northstar-handoff/assets/templates/northstar-handoff.md.template", "Lane budget / pause signal", "handoff template lane-budget state");
requireContains(repoRoot, "skills/northstar-handoff/assets/templates/northstar-handoff.md.template", "Confirm the current batch card already reflects the stopping point.", "handoff template closeout step");
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
