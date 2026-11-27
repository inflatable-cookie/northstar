#!/usr/bin/env bash
# Self-test for changelog.py against a scratch repository.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(mktemp -d); repo2=$(mktemp -d)
trap 'rm -rf "$repo" "$repo2"' EXIT
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
- Initial entries.

```md
## [Unreleased]
## [0.9.1] - 2026-02-03
```'
mk changelog.d/999-wrap-me.added.md 'Added CSV export.
The header row is optional. Preserve `a  b`.'
mk changelog.d/031-add-import.added.md 'Added CSV import.'
mk changelog.d/120-tidy-readme.changed.md 'Reworded the README intro.'
mk changelog.d/030-fix-rollback.fixed.md 'Restored the rollback path.'
py fold --version 0.9.1 --date 2026-02-03 --repo "$repo" > /dev/null
order CHANGELOG.md '## [Unreleased]' '## [0.9.1] - 2026-02-03' \
  '### Added' '- Added CSV import.' '- Added CSV export. The header row is optional. Preserve `a  b`.' \
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
before=$(cat "$repo/CHANGELOG.md")
set +e; msg=$(py fold --version 0.9.1 --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'bad.wibble.md' && printf '%s\n' "$msg" | grep -qi 'unknown type' \
  && echo "ok fold refuses a malformed fragment with file and reason" || { echo "FAIL: $msg"; exit 1; }
[ -f "$repo/changelog.d/030-fix-rollback.fixed.md" ] && echo "ok refusal leaves good fragments untouched" \
  || { echo "FAIL: refusal deleted good fragments"; exit 1; }
[ "$(cat "$repo/CHANGELOG.md")" = "$before" ] && echo "ok refusal leaves CHANGELOG.md untouched" \
  || { echo "FAIL: refusal changed CHANGELOG.md"; exit 1; }
refuses_fold() {
  local expected=$1 status=$2 msg rc=0 before
  shift 2
  before=$(cat "$repo/CHANGELOG.md")
  msg=$(py fold --repo "$repo" "$@" 2>&1) || rc=$?
  [ "$rc" = "$status" ] && printf '%s\n' "$msg" | grep -qF -- "$expected" \
    && [ "$(cat "$repo/CHANGELOG.md")" = "$before" ] \
    && [ -f "$repo/changelog.d/030-fix-rollback.fixed.md" ] \
    && echo "ok fold refuses $expected without writing" \
    || { echo "FAIL: expected $expected (exit $status), got $rc: $msg"; exit 1; }
}
rm "$repo/changelog.d/bad.wibble.md"
refuses_fold 'already exists' 1 --version 0.9.0
refuses_fold 'without brackets' 2 --version '0.9.1]'
refuses_fold 'valid YYYY-MM-DD' 2 --version 0.9.1 --date 2026-02-31
refuses_fold '--date requires a value' 2 --version 0.9.1 --date
mk changelog.d/045-list.added.md '- First fix.
- Second fix.'
refuses_fold 'without list markers' 1 --version 0.9.1
rc=0
msg=$(py check --repo "$repo" 2>&1) || rc=$?
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -qF '045-list.added.md: one entry per fragment without list markers' \
  && echo "ok check rejects list-marker fragment" \
  || { echo "FAIL: check accepted a list fragment: $msg"; exit 1; }
rm "$repo/changelog.d/045-list.added.md"
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
refuses_fold 'direct content' 1 --version 0.9.1
mk CHANGELOG.md '# Changelog

## [Unreleased]

## [Unreleased]

- Hand-written entry.'
refuses_fold 'more than one' 1 --version 0.9.1
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -q 'more than one' \
  || { echo "FAIL: duplicate Unreleased heading: $msg"; exit 1; }
if [ "$(id -u)" != 0 ]; then
  chmod a-w "$repo/changelog.d"
  mk CHANGELOG.md '## [Unreleased]'
  refuses_fold 'needs write and search permission' 1 --version 0.9.1
  chmod u+w "$repo/changelog.d"
fi
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
py check --repo "$repo2" | grep -q 'not adopted' && echo "ok check passes before adoption" \
  || { echo "FAIL: unadopted check"; py check --repo "$repo2"; exit 1; }
printf '# Changelog\n\n## [Unreleased]\n\n- Free-form entries are fine before adoption.\n' > "$repo2/CHANGELOG.md"
py check --repo "$repo2" | grep -q 'not adopted' && echo "ok check ignores [Unreleased] content before adoption" \
  || { echo "FAIL: unadopted check with content"; exit 1; }

# ------------------------------------------------------- extra edge cases
set +e; msg=$(py check --repo "$repo" --dry-run 2>&1); rc=$?; set -e
[ "$rc" = 2 ] && printf '%s\n' "$msg" | grep -qF 'unexpected argument --dry-run' \
  && echo "ok check rejects --dry-run" || { echo "FAIL check --dry-run ($rc): $msg"; exit 1; }
set +e; msg=$(py check --repo "$repo" --version 2>&1); rc=$?; set -e
[ "$rc" = 2 ] && printf '%s\n' "$msg" | grep -qF 'unexpected argument --version' \
  && echo "ok check rejects --version as unexpected" || { echo "FAIL check --version ($rc): $msg"; exit 1; }

mk CHANGELOG.md '# Changelog

## [Unreleased]'
rm -f "$repo"/changelog.d/* "$repo"/changelog.d/.*.md 2>/dev/null || true
mk changelog.d/stray-file.added 'Missing .md extension.'
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -qF 'stray-file.added' && printf '%s\n' "$msg" | grep -qF '.md extension' \
  && echo "ok check rejects stray non-.md file" || { echo "FAIL stray file ($rc): $msg"; exit 1; }
rm "$repo/changelog.d/stray-file.added"
mk changelog.d/no-type.md 'Missing type segment.'
set +e; msg=$(py check --repo "$repo" 2>&1); rc=$?; set -e
[ "$rc" = 1 ] && printf '%s\n' "$msg" | grep -qF 'no-type.md' && printf '%s\n' "$msg" | grep -qF 'missing .<type>' \
  && echo "ok check reports missing type segment" || { echo "FAIL missing type ($rc): $msg"; exit 1; }
rm "$repo/changelog.d/no-type.md"

mk changelog.d/001-first.added.md 'First release entry.'
py fold --version 0.1.0 --date 2026-01-01 --repo "$repo" > /dev/null
[ "$(tail -n 1 "$repo/CHANGELOG.md")" = "- First release entry." ] \
  && echo "ok folding into empty changelog leaves no trailing blank line" \
  || { echo "FAIL trailing blank line"; cat -A "$repo/CHANGELOG.md"; exit 1; }
echo "changelog self-test: OK"
