#!/usr/bin/env bash
# Self-test for check-links.py against a scratch repository.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(mktemp -d); trap 'rm -rf "$repo"' EXIT
git -C "$repo" init -q
mk() { mkdir -p "$(dirname "$repo/$1")"; printf '%s\n' "$2" > "$repo/$1"; }
run() { python3 "$here/check-links.py" --repo "$repo" "$@"; }

mk docs/a.md '# A

## Shape

See [b](b.md#rules), [self](#shape) and [ext](https://example.com).'
mk docs/b.md '# B

## Rules'
run > /dev/null && echo "ok valid links, anchors and external links pass" || { run; echo "FAIL clean repo"; exit 1; }

mk docs/spans.md 'Cite like `[[1]](https://example.com)` or `[x](nowhere.md)`.

```md
[y](also-nowhere.md)
```'
mk docs/listcont.md '- Ranges
   [0.05, 0.95]: the useful band.'
mk docs/anchors.md '## vst2_paths

See [paths](#vst2_paths).'
run > /dev/null && echo "ok code spans, fenced blocks, list continuations and underscore anchors" || { run; echo "FAIL false positives"; exit 1; }

mk tests/fixtures/corpus.md '[old](../../gone.md)'
run --frozen '^tests/fixtures/' > /dev/null && echo "ok --frozen paths are skipped" || { echo "FAIL --frozen"; exit 1; }
rm -rf "$repo/tests"

mk docs/bad.md '[x](b.md#nope) [y](missing.md)'
set +e; out=$(run); rc=$?; set -e
[ "$rc" = 1 ] && echo "$out" | grep -q "missing anchor b.md#nope" && echo "$out" | grep -q "missing missing.md" \
  && echo "ok missing files and anchors are reported, including untracked files" || { echo "FAIL negatives: $out"; exit 1; }

set +e; python3 "$here/check-links.py" --bogus > /dev/null 2>&1; rc=$?; set -e
[ "$rc" = 2 ] && echo "ok usage error exits 2" || { echo "FAIL usage exit $rc"; exit 1; }
echo "check-links self-test: OK"
