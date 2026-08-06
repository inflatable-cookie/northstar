import {
  pass,
  repoRootFrom,
  requireFile,
  requireHeading,
} from "./lib/checks";

const repoRoot = repoRootFrom(import.meta.dir);

const requiredFiles = [
  "README.md",
  "AGENTS.md",
  "PAPERCUTS.md",
  "effigy.toml",
  "bundle-docs/README.md",
  "bundle-docs/baseline-mapping.md",
  "bundle-docs/meta-folder-migration.md",
  "bundle-docs/papercuts.md",
  "bundle-docs/sections/01-vision.md",
  "bundle-docs/sections/02-architecture.md",
  "bundle-docs/sections/03-roadmaps.md",
  "bundle-docs/sections/04-logs.md",
  "bundle-docs/sections/05-research.md",
  "bundle-docs/sections/09-standard-docs-spine.md",
  "bundle-docs/sections/10-automation-runtime-policy.md",
  "bundle-docs/sweeps/README.md",
  "bundle-docs/sweeps/fresh-agent-sweep-prompt.md",
  "bundle-docs/sweeps/07-research-sweep.md",
  "template-bundle/README.md",
  "template-bundle/architecture/README.md",
  "template-bundle/architecture/system-architecture.md",
  "template-bundle/contracts/README.md",
  "template-bundle/contracts/001-contract-template.md",
  "template-bundle/contracts/001-working-rules-template.md",
  "template-bundle/logs/README.md",
  "template-bundle/research/master-index.md",
  "template-bundle/research/README.md",
  "template-bundle/research/research-to-architecture-crossref.md",
  "template-bundle/research/research-to-implementation-playbook.md",
  "template-bundle/research/quick-start-checklist.md",
  "template-bundle/research/gaps-found-during-implementation.md",
  "template-bundle/research/specimen-dossiers/README.md",
  "template-bundle/research/source-hubs/README.md",
  "template-bundle/research/templates/README.md",
  "template-bundle/research/templates/implementation-decision-record-template.md",
  "template-bundle/research/templates/specimen-dossier-template.md",
  "template-bundle/research/templates/value-track-synthesis-template.md",
  "template-bundle/research/templates/translation-memo-template.md",
  "template-bundle/research/templates/source-hub-template.md",
  "template-bundle/research/templates/discovery-intake-template.md",
  "template-bundle/research/templates/discovery-triage-log-template.md",
  "template-bundle/research/translation-memos/README.md",
  "template-bundle/research/value-tracks/README.md",
  "template-bundle/roadmaps/README.md",
  "template-bundle/roadmaps/generation-index.md",
  "template-bundle/specs/README.md",
  "template-bundle/specs/batch-cards/README.md",
  "template-bundle/vision/README.md",
  "template-bundle/vision/001-project-vision-blueprint-template.md",
] as const;

for (const file of requiredFiles) {
  requireFile(repoRoot, file);
}

requireHeading(repoRoot, "README.md", "What Northstar Is For");
requireHeading(repoRoot, "README.md", "What You Get In This Repo");
requireHeading(repoRoot, "README.md", "Quick Start (New Project)");
requireHeading(repoRoot, "README.md", "Migrate An Existing Project");
requireHeading(repoRoot, "README.md", "Key Conventions");
requireHeading(repoRoot, "README.md", "Read Next");
requireHeading(repoRoot, "README.md", "Operating Posture");

requireHeading(repoRoot, "bundle-docs/README.md", "Governance posture");
requireHeading(repoRoot, "bundle-docs/sweeps/README.md", "Use Case");
requireHeading(repoRoot, "bundle-docs/sweeps/README.md", "Agent Execution Contract");
requireHeading(repoRoot, "bundle-docs/sweeps/README.md", "Sweep Order");
requireHeading(repoRoot, "bundle-docs/sweeps/README.md", "Required Agent Output");
requireHeading(repoRoot, "template-bundle/README.md", "Core structure");
requireHeading(repoRoot, "template-bundle/README.md", "Standard docs spines");
requireHeading(repoRoot, "template-bundle/README.md", "Optional add-on folders");
requireHeading(repoRoot, "template-bundle/README.md", "Folder policy");
requireHeading(repoRoot, "template-bundle/README.md", "Operating posture");
requireHeading(repoRoot, "template-bundle/research/README.md", "Structure");
requireHeading(repoRoot, "template-bundle/research/README.md", "Operating model");
requireHeading(repoRoot, "template-bundle/research/README.md", "Promotion rule");
requireHeading(repoRoot, "template-bundle/research/README.md", "Using This Research During Delivery");

pass("Northstar bundle checks: OK");
