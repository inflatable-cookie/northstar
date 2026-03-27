#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

require_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    printf 'missing required file: %s\n' "$file" >&2
    exit 1
  fi
}

require_contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"
  if ! rg -Fq -- "$pattern" "$file"; then
    printf 'missing %s in %s: %s\n' "$description" "$file" "$pattern" >&2
    exit 1
  fi
}

forbid_contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"
  if rg -Fq -- "$pattern" "$file"; then
    printf 'forbidden %s in %s: %s\n' "$description" "$file" "$pattern" >&2
    exit 1
  fi
}

require_file "AGENTS.md"
require_file "README.md"
require_file "bundle-docs/README.md"
require_file "scripts/README.md"
require_file "skills/northstar-setup/SKILL.md"
require_file "skills/northstar-setup/agents/openai.yaml"
require_file "skills/northstar-setup/references/repo-contract.md"
require_file "skills/northstar-setup/references/adoption-modes.md"
require_file "skills/northstar-setup/references/monkey-example.md"
require_file "skills/northstar-setup/assets/templates/README.md"
require_file "skills/northstar-setup/assets/templates/AGENTS.md"
require_file "skills/northstar-setup/assets/templates/CHANGELOG.md"
require_file "skills/northstar-setup/assets/templates/effigy.native.toml.template"
require_file "skills/northstar-setup/assets/templates/effigy.compat.toml.template"
require_file "skills/northstar-plan/SKILL.md"
require_file "skills/northstar-plan/agents/openai.yaml"
require_file "skills/northstar-plan/references/modes/plan-from-scratch.md"
require_file "skills/northstar-plan/references/modes/compile-roadmaps.md"
require_file "skills/northstar-recover/SKILL.md"
require_file "skills/northstar-recover/agents/openai.yaml"
require_file "skills/northstar-recover/references/modes/replan-after-change.md"
require_file "skills/northstar-recover/references/modes/refocus-drifted-project.md"
require_file "skills/northstar-recover/references/modes/sweep-audit-repair.md"

require_contains "AGENTS.md" "effigy tasks" "Effigy discovery step"
require_contains "AGENTS.md" "effigy doctor" "Effigy doctor step"
require_contains "AGENTS.md" "effigy qa" "Effigy QA step"

require_contains "README.md" "effigy tasks" "Effigy discovery step"
require_contains "README.md" "effigy doctor" "Effigy doctor step"
require_contains "README.md" "effigy qa" "Effigy QA step"
require_contains "README.md" "skills/northstar-setup/" "setup skill entry point"
require_contains "README.md" "skills/northstar-plan/" "plan skill entry point"
require_contains "README.md" "skills/northstar-recover/" "recover skill entry point"

require_contains "bundle-docs/README.md" "effigy tasks" "Effigy discovery step"
require_contains "bundle-docs/README.md" "effigy doctor" "Effigy doctor step"
require_contains "bundle-docs/README.md" "effigy qa" "Effigy QA step"

require_contains "skills/northstar-setup/SKILL.md" "use Northstar and Effigy" "setup skill trigger language"
require_contains "skills/northstar-setup/SKILL.md" "references/adoption-modes.md" "adoption mode reference"
require_contains "skills/northstar-setup/SKILL.md" "effigy docs --help" "PATH verification step"
require_contains "skills/northstar-setup/SKILL.md" "references/monkey-example.md" "consumer example reference"
require_contains "skills/northstar-setup/agents/openai.yaml" "display_name" "OpenAI skill metadata"
require_contains "skills/northstar-setup/assets/templates/README.md" "effigy.native.toml.template" "native template selection"
require_contains "skills/northstar-setup/assets/templates/README.md" "effigy.compat.toml.template" "compatibility template selection"
require_contains "skills/northstar-plan/SKILL.md" "references/modes/plan-from-scratch.md" "plan mode reference"
require_contains "skills/northstar-plan/SKILL.md" "references/modes/compile-roadmaps.md" "roadmap mode reference"
require_contains "skills/northstar-recover/SKILL.md" "references/modes/replan-after-change.md" "replan mode reference"
require_contains "skills/northstar-recover/SKILL.md" "references/modes/refocus-drifted-project.md" "refocus mode reference"
require_contains "skills/northstar-recover/SKILL.md" "references/modes/sweep-audit-repair.md" "sweep mode reference"

forbid_contains "AGENTS.md" "--repo ." "current-repo flag example"
forbid_contains "README.md" "--repo ." "current-repo flag example"
forbid_contains "bundle-docs/README.md" "--repo ." "current-repo flag example"
forbid_contains "scripts/README.md" "--repo ." "current-repo flag example"
