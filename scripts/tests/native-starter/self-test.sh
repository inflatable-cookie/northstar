#!/usr/bin/env bash

set -euo pipefail

harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$(cd "$harness_dir/../../.." && pwd -P)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/northstar-native-starter.XXXXXX")
trap 'rm -rf "$scratch"' EXIT

native_template="$repo_root/skills/northstar/assets/templates/effigy.native.toml.template"
authority_template="$repo_root/skills/northstar/assets/templates/effigy.native.docs-authority.toml.template"

if rg -n 'effigy docs check-(links|index|forbidden|paths|contains|headings)' \
  "$native_template" "$authority_template" \
  "$repo_root/skills/northstar/references/setup/repo-contract.md"; then
  echo "retired hyphenated Effigy docs command remains" >&2
  exit 1
fi

write_root_files() {
  local root=$1
  cat > "$root/AGENTS.md" <<'EOF'
# Agent instructions

Use `effigy tasks` and `effigy test --plan`.
Start at `docs/README.md`, `docs/vision/README.md`,
`docs/roadmaps/README.md`, and `docs/logs/README.md`.
EOF
  cat > "$root/README.md" <<'EOF'
# Starter

Open [docs](docs/README.md).
EOF
}

write_native_docs() {
  local root=$1
  mkdir -p "$root/docs/vision" "$root/docs/roadmaps/g01" "$root/docs/logs"
  cat > "$root/docs/README.md" <<'EOF'
# Docs

- [Vision](vision/README.md)
- [Roadmaps](roadmaps/README.md)
- [Logs](logs/README.md)
EOF
  cat > "$root/docs/vision/README.md" <<'EOF'
# Vision

## Current Vision

## Vision Artifacts

- [Project vision](001-project-vision.md)
EOF
  printf '# Project Vision\n' > "$root/docs/vision/001-project-vision.md"
  printf '# Roadmaps\n' > "$root/docs/roadmaps/README.md"
  cat > "$root/docs/roadmaps/g01/README.md" <<'EOF'
# Generation 01

## Generation Runway

## Next Task
EOF
  printf '# Logs\n' > "$root/docs/logs/README.md"
}

run_surface() {
  local label=$1
  local root=$2
  local include_test_plan=${3:-no}
  local command_name
  local commands=(doctor qa)
  if [[ "$include_test_plan" == "yes" ]]; then
    commands=(test-plan doctor qa)
  fi
  for command_name in "${commands[@]}"; do
    case "$command_name" in
      test-plan) command=(effigy test --plan) ;;
      doctor) command=(effigy doctor) ;;
      qa) command=(effigy qa) ;;
    esac
    if ! (cd "$root" && "${command[@]}") > "$scratch/$label-$command_name.log" 2>&1; then
      cat "$scratch/$label-$command_name.log" >&2
      echo "$label starter failed: ${command[*]}" >&2
      exit 1
    fi
  done
  echo "PASS $label starter: ${commands[*]}"
}

native_root="$scratch/native"
mkdir -p "$native_root"
sed 's/{{REPO_ALIAS}}/starter/' "$native_template" > "$native_root/effigy.toml"
write_root_files "$native_root"
write_native_docs "$native_root"
cat > "$native_root/Cargo.toml" <<'EOF'
[package]
name = "northstar-native-starter-smoke"
version = "0.1.0"
edition = "2021"
EOF
: > "$native_root/Cargo.lock"
printf '# Changelog\n' > "$native_root/CHANGELOG.md"
run_surface native "$native_root" yes

authority_root="$scratch/docs-authority"
mkdir -p "$authority_root/authority/vision" "$authority_root/authority/roadmaps/g01" "$authority_root/authority/logs"
sed -e 's/{{DOCS_AUTHORITY_ALIAS}}/starter-docs/g' \
  -e 's#{{DOCS_AUTHORITY_PATH}}#authority#g' \
  "$authority_template" > "$authority_root/effigy.toml"
write_root_files "$authority_root"
cat > "$authority_root/authority/README.md" <<'EOF'
# Authority Docs

- [Vision](vision/README.md)
- [Roadmaps](roadmaps/README.md)
- [Logs](logs/README.md)
EOF
cat > "$authority_root/authority/vision/README.md" <<'EOF'
# Vision

## Current Entrypoint

## Working Rule

## Vision Artifacts

- [Project vision](001-project-vision.md)
EOF
printf '# Project Vision\n' > "$authority_root/authority/vision/001-project-vision.md"
cat > "$authority_root/authority/roadmaps/README.md" <<'EOF'
# Roadmaps

## Generation Model

## Layout

## Current Queue

## Next Task
EOF
cat > "$authority_root/authority/roadmaps/g01/README.md" <<'EOF'
# Generation 01

## Generation Runway

## Next Task
EOF
printf '# Logs\n' > "$authority_root/authority/logs/README.md"
run_surface docs-authority "$authority_root"

echo "Northstar native starter smoke: OK"
