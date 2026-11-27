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
Escape with \` then `[not-a-link](nowhere.md)` and \\`[after-even-bs](nowhere.md)`.
Trailing backslash inside span `foo\` then `[still-code](nowhere.md)`.

```md
[y](also-nowhere.md)
```'
mk docs/listcont.md '- Ranges
   [0.05, 0.95]: the useful band.
- Single-word continuation
  [0.05, 0.95]: narrow

Some prose line
[Note]: important

`code`
[AfterCode]: also-prose'
mk docs/badge.svg '<svg/>'
mk docs/anchors.md '## vst2_paths

See [paths](#vst2_paths), [setup](#setup), [code-link](#check-ab), [code-ref](#check-setupinstall), [code-in-link](#code-label), [code-emph](#_code_emph_), [emph](#italic-and-bold), [kbd](#press-ctrl), [code-tag](#use-div-here), [img](#status), [linked-img](#linked), [ref-img](#refimg), [dup](#dup), [dup1](#dup-1), [foo](#foo), [foo1](#foo-1), [foo11](#foo-1-1), [bar](#bar), [bar1](#bar-1), [bar2](#bar-2), [named](#explicit-name), [id](#explicit-id), [sq-id](#single-id), [sq-name](#single-name), [any-el](#any-element-id), and [div](#div-id).

## [Setup][INSTALL]

## Check `[a](b)`

## Check `[Setup][INSTALL]`

## [`code-label`](b.md)

## `_code_emph_`

## _italic_ and __bold__

## Press <kbd>Ctrl</kbd>

## Use `<div>` here

## ![badge](badge.svg) Status

## [![badge](badge.svg)](b.md) Linked

## ![badge][IMG] RefImg

## Dup

## Dup

## Foo

## Foo

## Foo 1

## Bar

## Bar 1

## Bar

<a name="explicit-name"></a>
<a id="explicit-id"></a>
<a id='\''single-id'\''></a>
<a class="anchor" name='\''single-name'\'' href="#vst2_paths"></a>
<h2 class="sec" id="any-element-id">Custom</h2>
<div data-id="not-an-anchor" id="div-id"></div>
<input name="input-name">
Inline example: `<a id="code-span-anchor"></a>`

[Install]: b.md
[IMG]: badge.svg'
run > /dev/null && echo "ok code spans, fenced blocks, list continuations and underscore anchors" || { run; echo "FAIL false positives"; exit 1; }

mk 'docs/guide file.md' '## Café'
mk 'docs/guide(v2).md' 'Guide v2
--------'
mk 'docs/c#guide.md' '---
name: csharp
description: C# guide with [yaml](not-a-link.md)
---

# Real heading'
mk docs/dot-fm.md '---
title: Dots
note: [yaml](not-a-link.md)
...

See [b](b.md).'
printf '\xef\xbb\xbf%s\n' '---
title: BOM
note: [yaml](not-a-link.md)
---

# BOM heading

See [self](#bom-heading).' > "$repo/docs/bom-fm.md"
mk docs/targets.md 'See [guide](guide%20file.md#caf%C3%A9), [v2](guide(v2).md), [escaped](guide\(v2\).md#guide-v2), [hash](c\#guide.md#real-heading), [plain](b.md?plain=1), [plain-anchor](b.md?plain=1#rules), [![badge](badge.svg)](b.md), and [ext](<https://example.com>).

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

mk docs/bad.md '[x](b.md#nope) [y](missing.md) [z](targets.md#example-only) [fake](anchors.md#code-span-anchor) [wrong-slug](anchors.md#check-a) [bad-data-id](anchors.md#not-an-anchor) [bad-input-name](anchors.md#input-name) [bad-img-alt](anchors.md#badge-status) [bad-query](b.md?plain=1#nope) [escape](../../..)'
mk docs/escaped.md 'A literal backslash followed by a \\[real link](after-backslash.md).
Escape with \`. See [broken](escaped-backtick.md) and \`code\`.
Three \\\` and [broken2](three-backslashes.md) and \`end\`.'
mk docs/paragraphs.md 'A literal backtick `

[real link](paragraph-target.md)

Another literal backtick `'
mk docs/list.md '- Item
  wrapped continuation

    [broken continuation](list-target.md)'
mk README.md '[ref]: ABSENT
[adjacent]: adjacent-missing.md

[`code-label`]: code-label-missing.md

[multiline]:
    other-missing.md
[after-multiline]: after-multiline-missing.md'
mk docs/empty-frontmatter.md '---
---
See [broken](after-empty-fm.md)

---'
mk docs/empty-dot-fm.md '---
...
See [broken](after-dot-fm.md)

...'
mk docs/nested.md '[![badge](missing-badge.svg)](b.md) [![ext-badge](missing-ext-badge.svg)](https://example.com)'
mk docs/escapes-in-links.md '[g](missing-dq.md "the \"real\" guide")
[s](missing-sq.md '\''it\'\''s'\'')
[p](missing-paren.md (escaped \) paren))
[array\]](missing-bracket.md)
[![badge \[1\]](missing-nested-bracket.svg)](missing-outer-bracket.md)

[ref-dq]: missing-ref-dq.md "the \"real\" guide"
[ref-sq]: missing-ref-sq.md '\''it\'\''s'\''
[ref-paren]: missing-ref-paren.md (escaped \) paren)
[ref-array\]]: missing-ref-bracket.md'
mk docs/café.md '[broken](absent.md)'
git -C "$repo" add docs/café.md
set +e; out=$(run); rc=$?; set -e
[ "$rc" = 1 ] && echo "$out" | grep -q "missing anchor b.md#nope" && echo "$out" | grep -q "missing missing.md" \
  && echo "$out" | grep -q "missing anchor targets.md#example-only" \
  && echo "$out" | grep -q "missing anchor anchors.md#code-span-anchor" \
  && echo "$out" | grep -q "missing anchor anchors.md#check-a" \
  && echo "$out" | grep -q "missing anchor anchors.md#not-an-anchor" \
  && echo "$out" | grep -q "missing anchor anchors.md#input-name" \
  && echo "$out" | grep -q "missing anchor anchors.md#badge-status" \
  && echo "$out" | grep -q "missing anchor b.md?plain=1#nope" \
  && echo "$out" | grep -q "docs/bad.md: escapes repo ../../.." \
  && echo "$out" | grep -q "docs/café.md: missing absent.md" \
  && echo "$out" | grep -q "README.md: missing ABSENT" \
  && echo "$out" | grep -q "README.md: missing adjacent-missing.md" \
  && echo "$out" | grep -q "README.md: missing code-label-missing.md" \
  && echo "$out" | grep -q "README.md: missing other-missing.md" \
  && echo "$out" | grep -q "README.md: missing after-multiline-missing.md" \
  && echo "$out" | grep -q "docs/list.md: missing list-target.md" \
  && echo "$out" | grep -q "docs/paragraphs.md: missing paragraph-target.md" \
  && echo "$out" | grep -q "docs/escaped.md: missing after-backslash.md" \
  && echo "$out" | grep -q "docs/escaped.md: missing escaped-backtick.md" \
  && echo "$out" | grep -q "docs/escaped.md: missing three-backslashes.md" \
  && echo "$out" | grep -q "docs/empty-frontmatter.md: missing after-empty-fm.md" \
  && echo "$out" | grep -q "docs/empty-dot-fm.md: missing after-dot-fm.md" \
  && echo "$out" | grep -q "docs/nested.md: missing missing-badge.svg" \
  && echo "$out" | grep -q "docs/nested.md: missing missing-ext-badge.svg" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-dq.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-sq.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-paren.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-bracket.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-nested-bracket.svg" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-outer-bracket.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-ref-dq.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-ref-sq.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-ref-paren.md" \
  && echo "$out" | grep -q "docs/escapes-in-links.md: missing missing-ref-bracket.md" \
  && echo "ok broken links in tracked Unicode and untracked files, including anchors in examples" \
  || { echo "FAIL negatives: $out"; exit 1; }
rc=0
out=$(cd "$repo/docs" && python3 "$here/check-links.py") || rc=$?
[ "$rc" = 1 ] && echo "$out" | grep -q "README.md: missing ABSENT" \
  || { echo "FAIL nested repository check: $out"; exit 1; }

set +e; python3 "$here/check-links.py" --bogus > /dev/null 2>&1; rc=$?; set -e
[ "$rc" = 2 ] && echo "ok usage error exits 2" || { echo "FAIL usage exit $rc"; exit 1; }
set +e; msg=$(python3 "$here/check-links.py" --repo 2>&1); rc=$?; set -e
[ "$rc" = 2 ] && printf '%s\n' "$msg" | grep -qF -- '--repo requires a value' \
  && echo "ok missing option value exits 2" || { echo "FAIL missing value ($rc): $msg"; exit 1; }
set +e; python3 "$here/check-links.py" --repo "$repo" --frozen '[' > /dev/null 2>&1; rc=$?; set -e
[ "$rc" = 2 ] && echo "ok invalid --frozen regex exits 2" || { echo "FAIL invalid regex exit $rc"; exit 1; }
echo "check-links self-test: OK"
