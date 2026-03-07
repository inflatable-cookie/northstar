#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_files=(
  "README.md"
  "AGENTS.md"
  "effigy.toml"
  "bundle-docs/README.md"
  "bundle-docs/baseline-mapping.md"
  "bundle-docs/meta-folder-migration.md"
  "bundle-docs/sections/01-vision.md"
  "bundle-docs/sections/02-architecture.md"
  "bundle-docs/sections/03-roadmaps.md"
  "bundle-docs/sections/04-logs.md"
  "bundle-docs/sections/05-research.md"
  "bundle-docs/sweeps/README.md"
  "bundle-docs/sweeps/fresh-agent-sweep-prompt.md"
  "bundle-docs/sweeps/07-research-sweep.md"
  "template-bundle/README.md"
  "template-bundle/architecture/README.md"
  "template-bundle/architecture/system-architecture.md"
  "template-bundle/contracts/README.md"
  "template-bundle/contracts/001-contract-template.md"
  "template-bundle/logs/README.md"
  "template-bundle/research/master-index.md"
  "template-bundle/research/README.md"
  "template-bundle/research/research-to-architecture-crossref.md"
  "template-bundle/research/research-to-implementation-playbook.md"
  "template-bundle/research/quick-start-checklist.md"
  "template-bundle/research/gaps-found-during-implementation.md"
  "template-bundle/research/specimen-dossiers/README.md"
  "template-bundle/research/source-hubs/README.md"
  "template-bundle/research/templates/README.md"
  "template-bundle/research/templates/implementation-decision-record-template.md"
  "template-bundle/research/templates/specimen-dossier-template.md"
  "template-bundle/research/templates/value-track-synthesis-template.md"
  "template-bundle/research/templates/translation-memo-template.md"
  "template-bundle/research/templates/source-hub-template.md"
  "template-bundle/research/templates/discovery-intake-template.md"
  "template-bundle/research/templates/discovery-triage-log-template.md"
  "template-bundle/research/translation-memos/README.md"
  "template-bundle/research/value-tracks/README.md"
  "template-bundle/roadmaps/README.md"
  "template-bundle/roadmaps/generation-index.md"
  "template-bundle/vision/README.md"
  "template-bundle/vision/001-project-vision-blueprint-template.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "missing required file: $file" >&2
    exit 1
  fi
done

check_heading() {
  local file="$1"
  local heading="$2"
  if ! grep -Fxq "## ${heading}" "$file"; then
    echo "missing heading '## ${heading}' in $file" >&2
    exit 1
  fi
}

check_heading "README.md" "What Northstar Is For"
check_heading "README.md" "What You Get In This Repo"
check_heading "README.md" "Quick Start (New Project)"
check_heading "README.md" "Migrate An Existing Project"
check_heading "README.md" "Key Conventions"
check_heading "README.md" "Read Next"
check_heading "README.md" "Operating Posture"

check_heading "bundle-docs/README.md" "Governance posture"
check_heading "bundle-docs/sweeps/README.md" "Use Case"
check_heading "bundle-docs/sweeps/README.md" "Agent Execution Contract"
check_heading "bundle-docs/sweeps/README.md" "Sweep Order"
check_heading "bundle-docs/sweeps/README.md" "Required Agent Output"
check_heading "template-bundle/README.md" "Core structure"
check_heading "template-bundle/README.md" "Optional add-on folders"
check_heading "template-bundle/README.md" "Folder policy"
check_heading "template-bundle/README.md" "Operating posture"
check_heading "template-bundle/research/README.md" "Structure"
check_heading "template-bundle/research/README.md" "Operating model"
check_heading "template-bundle/research/README.md" "Promotion rule"
check_heading "template-bundle/research/README.md" "Using This Research During Delivery"

echo "Northstar bundle checks: OK"
