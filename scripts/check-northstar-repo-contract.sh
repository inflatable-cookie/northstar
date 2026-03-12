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
require_file "skills/northstar-effigy/SKILL.md"
require_file "skills/northstar-effigy/agents/openai.yaml"
require_file "skills/northstar-effigy/references/repo-contract.md"
require_file "skills/northstar-effigy/references/adoption-modes.md"
require_file "skills/northstar-effigy/references/monkey-example.md"
require_file "skills/northstar-effigy/assets/templates/README.md"
require_file "skills/northstar-effigy/assets/templates/AGENTS.md"
require_file "skills/northstar-effigy/assets/templates/CHANGELOG.md"
require_file "skills/northstar-effigy/assets/templates/effigy.native.toml.template"
require_file "skills/northstar-effigy/assets/templates/effigy.compat.toml.template"

require_contains "AGENTS.md" "effigy tasks" "Effigy discovery step"
require_contains "AGENTS.md" "effigy doctor" "Effigy doctor step"
require_contains "AGENTS.md" "effigy qa" "Effigy QA step"

require_contains "README.md" "effigy tasks" "Effigy discovery step"
require_contains "README.md" "effigy doctor" "Effigy doctor step"
require_contains "README.md" "effigy qa" "Effigy QA step"
require_contains "README.md" "skills/northstar-effigy/" "skill entry point"

require_contains "bundle-docs/README.md" "effigy tasks" "Effigy discovery step"
require_contains "bundle-docs/README.md" "effigy doctor" "Effigy doctor step"
require_contains "bundle-docs/README.md" "effigy qa" "Effigy QA step"

require_contains "skills/northstar-effigy/SKILL.md" "use Northstar and Effigy" "skill trigger language"
require_contains "skills/northstar-effigy/SKILL.md" "references/adoption-modes.md" "adoption mode reference"
require_contains "skills/northstar-effigy/SKILL.md" "effigy docs --help" "PATH verification step"
require_contains "skills/northstar-effigy/SKILL.md" "references/monkey-example.md" "consumer example reference"
require_contains "skills/northstar-effigy/agents/openai.yaml" "display_name" "OpenAI skill metadata"
require_contains "skills/northstar-effigy/assets/templates/README.md" "effigy.native.toml.template" "native template selection"
require_contains "skills/northstar-effigy/assets/templates/README.md" "effigy.compat.toml.template" "compatibility template selection"

forbid_contains "AGENTS.md" "--repo ." "current-repo flag example"
forbid_contains "README.md" "--repo ." "current-repo flag example"
forbid_contains "bundle-docs/README.md" "--repo ." "current-repo flag example"
forbid_contains "scripts/README.md" "--repo ." "current-repo flag example"
