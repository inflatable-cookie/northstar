#!/usr/bin/env bash
# Self-test for changelog.py against a scratch repository.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(mktemp -d); trap 'rm -rf "$repo"' EXIT
py() { python3 "$here/changelog.py" "$@"; }
mk() { mkdir -p "$(dirname "$repo/$1")"; printf '%s\n' "$2" > "$repo/$1"; }
check() { grep -qF -- "$2" "$repo/$1" || { echo "FAIL: $1 lacks: $2"; cat "$repo/$1"; exit 1; }; echo "ok $3"; }
order() { local f=$1; shift; local prev=0
  for pat in "$@"; do
    local n; n=$(grep -nF -- "$pat" "$repo/$f" | head -1 | cut -d: -f1)
    [ -n "$n" ] && [ "$n" -gt "$prev" ] || { echo "FAIL: order in $f at: $pat"; cat "$repo/$f"; exit 1; }
    prev=$n
  done; echo "ok order: $*"; }

# ---------------------------------------------------------------- fold
mk CHANGELOG.md '# Changelog

## [Unreleased]

## [0.9.0] - 2026-01-01

### Added
- Initial entries.'
mk changelog.d/999-wrap-me.added.md 'Added CSV export.
The header row is optional.'
mk changelog.d/031-add-import.added.md 'Added CSV import.'
mk changelog.d/120-tidy-readme.changed.md 'Reworded the README intro.'
mk changelog.d/030-fix-rollback.fixed.md 'Restored the rollback path.'
py fold --version 0.9.1 --date 2026-02-03 --repo "$repo" > /dev/null
order CHANGELOG.md '## [Unreleased]' '## [0.9.1] - 2026-02-03' \
  '### Added' '- Added CSV import.' '- Added CSV export. The header row is optional.' \
  '### Changed' '- Reworded the README intro.' \
  '### Fixed' '- Restored the rollback path.' '## [0.9.0] - 2026-01-01'
check CHANGELOG.md '- Initial entries.' "earlier release untouched"
[ ! -e "$repo/changelog.d/030-fix-rollback.fixed.md" ] && [ ! -e "$repo/changelog.d/999-wrap-me.added.md" ] \
  && echo "ok folded fragments are deleted" || { echo "FAIL: fragments survived"; exit 1; }
[ -f "$repo/changelog.d/.gitkeep" ] && echo "ok adoption marker .gitkeep survives the fold" || { echo "FAIL: no .gitkeep"; exit 1; }
if py fold --version 0.9.2 --repo "$repo" >/dev/null 2>&1; then echo "FAIL: fold with nothing left succeeded"; exit 1
else echo "ok fold refuses when no fragments are left"; fi

# ---------------------------------------------------------------- dry run
rm -f "$repo/changelog.d/.gitkeep"
mk CHANGELOG.md '# Changelog

## [Unreleased]

## [0.9.0] - 2026-01-01

### Added
- Initial entries.'
mk changelog.d/030-fix-rollback.fixed.md 'Restored the rollback path.'
mk changelog.d/040-drop-old-api.removed.md 'Removed the deprecated API.'
before=$(cat "$repo/CHANGELOG.md")
out=$(py fold --version 0.9.1 --date 2026-02-03 --repo "$repo" --dry-run)
[ "$(cat "$repo/CHANGELOG.md")" = "$before" ] && echo "ok dry run writes nothing" || { echo "FAIL: dry run changed CHANGELOG.md"; exit 1; }
[ -f "$repo/changelog.d/030-fix-rollback.fixed.md" ] && echo "ok dry run keeps fragments" || { echo "FAIL: dry run deleted fragments"; exit 1; }
printf '%s\n' "$out" | grep -qF '## [0.9.1] - 2026-02-03' && printf '%s\n' "$out" | grep -qF -- '### Removed' \
  && printf '%s\n' "$out" | grep -qF -- '- Removed the deprecated API.' \
  && echo "ok dry run shows the result" || { echo "FAIL: dry run output: $out"; exit 1; }

# ---------------------------------------------------------------- refusal
mk changelog.d/bad.wibble.md 'Unknown type.'
set +e; msg=$(py fold --version 0.9.1 --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'bad.wibble.md' && printf '%s\n' "$msg" | grep -qi 'unknown type' \
  && echo "ok fold refuses a malformed fragment with file and reason" || { echo "FAIL: $msg"; exit 1; }
[ -f "$repo/changelog.d/030-fix-rollback.fixed.md" ] && echo "ok refusal leaves good fragments untouched" \
  || { echo "FAIL: refusal deleted good fragments"; exit 1; }
check CHANGELOG.md '## [Unreleased]' "refusal leaves CHANGELOG.md untouched"
mk changelog.d/split.added.md 'First entry.

Second entry.'
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'split.added.md' && printf '%s\n' "$msg" | grep -q 'blank line' \
  && echo "ok check reports a blank-line fragment by file and reason" || { echo "FAIL: $msg"; exit 1; }
mk changelog.d/empty.changed.md ''
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'empty.changed.md' && printf '%s\n' "$msg" | grep -qi 'empty entry' \
  && echo "ok check reports an empty fragment" || { echo "FAIL: $msg"; exit 1; }
mk changelog.d/.9-hidden.md 'Missing name.'
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q '.9-hidden.md' && printf '%s\n' "$msg" | grep -q 'missing <name>' \
  && echo "ok check reports a fragment with no name" || { echo "FAIL: $msg"; exit 1; }

# ---------------------------------------------------------------- check
rm -f "$repo"/changelog.d/*.md "$repo"/changelog.d/.*.md
mk changelog.d/030-fix-rollback.fixed.md 'Restored the rollback path.'
py check --repo "$repo" | grep -q 'OK' && echo "ok check passes on a well-formed adopted repository" \
  || { echo "FAIL: clean check"; py check --repo "$repo"; exit 1; }
mk CHANGELOG.md '# Changelog

## [Unreleased]

- Hand-written entry in the wrong place.'
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'direct content' \
  && echo "ok check fails on direct [Unreleased] edits" || { echo "FAIL: $msg"; exit 1; }
mv "$repo/CHANGELOG.md" "$repo/KEEP"
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'CHANGELOG.md: missing' \
  && echo "ok check fails when CHANGELOG.md is missing" || { echo "FAIL: $msg"; exit 1; }
mv "$repo/KEEP" "$repo/CHANGELOG.md"
mk CHANGELOG.md '# Changelog

All notable changes live in fragments.'
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'no `## \[Unreleased\]` heading' \
  && echo "ok check fails when the [Unreleased] heading is gone" || { echo "FAIL: $msg"; exit 1; }

# ------------------------------------------------------- not yet adopted
repo2=$(mktemp -d)
py check --repo "$repo2" | grep -q 'not adopted' && echo "ok check passes before adoption" \
  || { echo "FAIL: unadopted check"; py check --repo "$repo2"; exit 1; }
printf '# Changelog\n\n## [Unreleased]\n\n- Free-form entries are fine before adoption.\n' > "$repo2/CHANGELOG.md"
py check --repo "$repo2" | grep -q 'not adopted' && echo "ok check ignores [Unreleased] content before adoption" \
  || { echo "FAIL: unadopted check with content"; exit 1; }
rm -rf "$repo2"
echo "changelog self-test: OK"
