#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(mktemp -d); trap 'rm -rf "$repo"' EXIT
mkdir -p "$repo/scripts" "$repo/skills/sample" "$repo/installed"
cp "$here/check-skill-install.py" "$repo/scripts/"
printf '# Sample\n' > "$repo/skills/sample/SKILL.md"
printf '#!/bin/sh\n' > "$repo/skills/sample/run.sh"
chmod +x "$repo/skills/sample/run.sh"
cp -pR "$repo/skills/sample" "$repo/installed/"

check() { python3 "$repo/scripts/check-skill-install.py" "$repo/installed"; }
mkdir "$repo/installed/sample/.effigy"
printf 'scratch\n' > "$repo/installed/sample/.effigy/log"
check

chmod a-x "$repo/installed/sample/run.sh"
ln -s "$repo/skills/sample" "$repo/installed/sample/extra-dir"
ln -s absent "$repo/installed/sample/dangling"
rc=0
out=$(check) || rc=$?
[ "$rc" = 1 ] && printf '%s\n' "$out" | grep -qF 'differing: run.sh' \
  && printf '%s\n' "$out" | grep -qF 'unexpected: dangling' \
  && printf '%s\n' "$out" | grep -qF 'unexpected: extra-dir' \
  || { echo "FAIL parity differences: $out"; exit 1; }
echo "check-skill-install self-test: OK"
