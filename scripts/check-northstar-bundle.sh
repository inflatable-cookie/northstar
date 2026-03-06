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
  "bundle-docs/sweeps/README.md"
  "bundle-docs/sweeps/fresh-agent-sweep-prompt.md"
  "template-bundle/README.md"
  "template-bundle/architecture/README.md"
  "template-bundle/architecture/system-architecture.md"
  "template-bundle/contracts/README.md"
  "template-bundle/contracts/001-contract-template.md"
  "template-bundle/logs/README.md"
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
check_heading "template-bundle/README.md" "Optional add-on folders (not included by default)"
check_heading "template-bundle/README.md" "Folder policy"
check_heading "template-bundle/README.md" "Operating posture"

echo "Northstar bundle checks: OK"
