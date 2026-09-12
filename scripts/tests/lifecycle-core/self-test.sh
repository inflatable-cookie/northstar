#!/usr/bin/env bash
# Focused proof for the portable task lifecycle core.
#
# 1. Runs the exhaustive in-process oracle from the source skill.
# 2. Proves exact source/install parity for the whole skill directory.
# 3. Runs the installed command from an isolated consumer directory outside the
#    Northstar checkout, with no Paseo, Queue, network, or source dependency.

set -euo pipefail

harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$(cd "$harness_dir/../../.." && pwd -P)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/northstar-lifecycle-core.XXXXXX")
trap 'rm -rf "$scratch"' EXIT

source_skill="$repo_root/skills/northstar"
installed="$scratch/installed/northstar"

echo "# source oracle"
bun run "$source_skill/scripts/lifecycle-core.ts" oracle

echo "# source/install parity"
mkdir -p "$installed"
rsync -a --delete "$source_skill/" "$installed/"
effigy --repo "$repo_root" check:skill-install "$installed"

echo "# installed consumer fixture (isolated, offline)"
consumer="$scratch/consumer"
mkdir -p "$consumer"
(
  cd "$consumer"
  bun run "$installed/scripts/lifecycle-core.ts" oracle
)

echo "# installed command surface resolves through the skill catalogue"
effigy --repo "$installed" lifecycle:oracle >/dev/null

echo "lifecycle-core self-test: OK"
