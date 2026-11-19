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

See [paths](#vst2_paths) and [setup](#setup).

## [Setup][INSTALL]

[Install]: b.md'
run > /dev/null && echo "ok code spans, fenced blocks, list continuations and underscore anchors" || { run; echo "FAIL false positives"; exit 1; }

mk 'docs/guide file.md' '## Café'
mk 'docs/guide(v2).md' 'Guide v2
--------'
mk docs/targets.md 'See [guide](guide%20file.md#caf%C3%A9), [v2](guide(v2).md), [escaped](guide\(v2\).md#guide-v2), and [ext](<https://example.com>).

Literal: ``[example](nowhere.md)``.
Also literal: \[escaped](nowhere.md).

    [indented example](nowhere.md)

~~~~md
~~~
[example](nowhere.md)
## Example only
~~~~'
run > /dev/null && echo "ok encoded paths and anchors, angle destinations and tilde fences" || { run; exit 1; }

mk tests/fixtures/corpus.md '[old](../../gone.md)'
run --frozen '^tests/fixtures/' > /dev/null && echo "ok --frozen paths are skipped" || { echo "FAIL --frozen"; exit 1; }
rm -rf "$repo/tests"

mk docs/bad.md '[x](b.md#nope) [y](missing.md) [z](targets.md#example-only)'
mk docs/escaped.md 'A literal backslash followed by a \\[real link](after-backslash.md).'
mk docs/paragraphs.md 'A literal backtick `

[real link](paragraph-target.md)

Another literal backtick `'
mk docs/list.md '-   Item

    [broken continuation](list-target.md)'
mk README.md '[ref]: ABSENT

[multiline]:
    other-missing.md'
mk docs/café.md '[broken](absent.md)'
git -C "$repo" add docs/café.md
set +e; out=$(run); rc=$?; set -e
[ "$rc" = 1 ] && echo "$out" | grep -q "missing anchor b.md#nope" && echo "$out" | grep -q "missing missing.md" \
  && echo "$out" | grep -q "missing anchor targets.md#example-only" \
  && echo "$out" | grep -q "docs/café.md: missing absent.md" \
  && echo "$out" | grep -q "README.md: missing ABSENT" \
  && echo "$out" | grep -q "README.md: missing other-missing.md" \
  && echo "$out" | grep -q "docs/list.md: missing list-target.md" \
  && echo "$out" | grep -q "docs/paragraphs.md: missing paragraph-target.md" \
  && echo "$out" | grep -q "docs/escaped.md: missing after-backslash.md" \
  && echo "ok broken links in tracked Unicode and untracked files, including anchors in examples" \
  || { echo "FAIL negatives: $out"; exit 1; }
rc=0
out=$(cd "$repo/docs" && python3 "$here/check-links.py") || rc=$?
[ "$rc" = 1 ] && echo "$out" | grep -q "README.md: missing ABSENT" \
  || { echo "FAIL nested repository check: $out"; exit 1; }

set +e; python3 "$here/check-links.py" --bogus > /dev/null 2>&1; rc=$?; set -e
[ "$rc" = 2 ] && echo "ok usage error exits 2" || { echo "FAIL usage exit $rc"; exit 1; }
echo "check-links self-test: OK"
