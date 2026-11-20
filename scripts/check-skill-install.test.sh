#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(mktemp -d); trap 'rm -rf "$repo"' EXIT
mkdir -p "$repo/scripts" "$repo/skills/sample" "$repo/installed"
cp "$here/check-skill-install.py" "$repo/scripts/"
printf '# Sample\n' > "$repo/skills/sample/SKILL.md"
printf '#!/bin/sh\n' > "$repo/skills/sample/run.sh"
chmod +x "$repo/skills/sample/run.sh"
ln -s SKILL.md "$repo/skills/sample/alias.md"
cp -pR "$repo/skills/sample" "$repo/installed/"

check() { python3 "$repo/scripts/check-skill-install.py" "$repo/installed"; }
mkdir "$repo/installed/sample/.effigy"
printf 'scratch\n' > "$repo/installed/sample/.effigy/log"
check

chmod a-x "$repo/installed/sample/run.sh"
printf '# Changed\n' > "$repo/installed/sample/SKILL.md"
ln -sf run.sh "$repo/installed/sample/alias.md"
printf 'regular\n' > "$repo/skills/sample/type-check.txt"
ln -s SKILL.md "$repo/installed/sample/type-check.txt"
ln -s "$repo/skills/sample" "$repo/installed/sample/extra-dir"
ln -s absent "$repo/installed/sample/dangling"
mkdir -p "$repo/skills/uninstalled"
printf '# Uninstalled\n' > "$repo/skills/uninstalled/SKILL.md"
printf 'extra\n' > "$repo/skills/sample/only-in-source.txt"
rc=0
out=$(check) || rc=$?
[ "$rc" = 1 ] \
  && printf '%s\n' "$out" | grep -qF 'missing: only-in-source.txt' \
  && printf '%s\n' "$out" | grep -qF 'differing (content): SKILL.md' \
  && printf '%s\n' "$out" | grep -qF 'differing (mode): run.sh' \
  && printf '%s\n' "$out" | grep -qF 'differing (symlink): alias.md' \
  && printf '%s\n' "$out" | grep -qF 'differing (type): type-check.txt' \
  && printf '%s\n' "$out" | grep -qF 'unexpected: dangling' \
  && printf '%s\n' "$out" | grep -qF 'unexpected: extra-dir' \
  && printf '%s\n' "$out" | grep -qF 'uninstalled: not installed' \
  || { echo "FAIL parity differences: $out"; exit 1; }

rc=0
python3 "$repo/scripts/check-skill-install.py" a b > /dev/null 2>&1 || rc=$?
[ "$rc" = 2 ] || { echo "FAIL usage exit $rc"; exit 1; }
rc=0
python3 "$repo/scripts/check-skill-install.py" --help > /dev/null 2>&1 || rc=$?
[ "$rc" = 2 ] || { echo "FAIL flag usage exit $rc"; exit 1; }
echo "check-skill-install self-test: OK"
