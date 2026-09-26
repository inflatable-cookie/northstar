#!/usr/bin/env bash
# Self-test for cut.py against a scratch repository.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
repo=$(mktemp -d); trap 'rm -rf "$repo"' EXIT
git -C "$repo" init -q
mk() { mkdir -p "$(dirname "$repo/$1")"; printf '%s\n' "$2" > "$repo/$1"; }
mk docs/contracts/api.md '# API

See [overview](../architecture/overview.md#shape), [task](../roadmaps/g01/001-build-it.md) and `../guides/use.md`.'
mk docs/architecture/overview.md '# Overview

## Shape

Rules live in [api](../contracts/api.md).'
mk docs/roadmaps/g01/001-build-it.md '# g01.001'
mk docs/vision/001-vision.md '# Vision'
mk docs/vision/old-notes.md '# Old'
mk docs/guides/use.md '# Use

Read [the API contract](../contracts/api.md) and [docs/roadmaps/g01/001-build-it.md](../roadmaps/g01/001-build-it.md).'
mk tools/check.toml 'contract = "docs/contracts/api.md"'
mk src/lib.rs 'const DOC: &str = include_str!("../docs/contracts/api.md");'
mk releases/v1/manifest.md 'Pinned: [api](../../docs/contracts/api.md)'
cat > "$repo/plan.json" <<'JSON'
{"moves": [["docs/contracts/", "docs/knowledge/contracts/"], ["docs/architecture/", "docs/knowledge/architecture/"], ["docs/vision/001-vision.md", "docs/knowledge/vision.md"]],
 "removed": ["docs/roadmaps/", "docs/vision/"], "frozen": ["^releases/"]}
JSON
git -C "$repo" add -A && git -C "$repo" -c user.email=t@t -c user.name=t commit -qm base
python3 "$here/cut.py" apply "$repo/plan.json" --repo "$repo" > /dev/null
check() { grep -qF -- "$2" "$repo/$1" || { echo "FAIL: $1 lacks: $2"; cat "$repo/$1"; exit 1; }; echo "ok $3"; }
check docs/knowledge/contracts/api.md '[overview](../architecture/overview.md#shape)' "link between moved siblings keeps its anchor"
check docs/knowledge/contracts/api.md 'and `../../guides/use.md`' "backticked relative path follows the new depth"
check docs/knowledge/contracts/api.md 'See [overview]' "file moved"
grep -q "\[task\]" "$repo/docs/knowledge/contracts/api.md" && { echo "FAIL: link into removed record kept"; exit 1; } || echo "ok link into a removed record becomes plain text"
check docs/guides/use.md '[the API contract](../knowledge/contracts/api.md)' "unmoved file's link into a moved file"
check docs/guides/use.md 'task g01.001 (Git history)' "path-labelled link into removed record becomes a history pointer"
check tools/check.toml 'docs/knowledge/contracts/api.md' "root-relative string in config"
check src/lib.rs '"../docs/knowledge/contracts/api.md"' "../-relative string in code"
check releases/v1/manifest.md '../../docs/contracts/api.md' "frozen file untouched"
[ ! -e "$repo/docs/roadmaps" ] && echo "ok removed directory is gone"
if [ -f "$repo/docs/knowledge/vision.md" ] && [ ! -e "$repo/docs/vision" ]; then echo "ok a file moved out of a removed directory is moved; the rest is removed"; else echo "FAIL move out of removed directory"; exit 1; fi
check plan.json '"docs/contracts/"' "the plan file itself is not rewritten"
git -C "$repo" rm -rqf releases plan.json
if python3 "$here/cut.py" check-links --repo "$repo" > /dev/null; then echo "ok check-links clean after cut"; else python3 "$here/cut.py" check-links --repo "$repo"; echo "FAIL check-links"; exit 1; fi
mk docs/guides/spans.md 'Cite like `[[1]](https://example.com)` or `[x](nowhere.md)`.'
mk docs/guides/anchors.md '## vst2_paths

See [paths](#vst2_paths).'
python3 "$here/cut.py" check-links --repo "$repo" > /dev/null && echo "ok check-links ignores links inside code spans and keeps underscores in anchors" || { echo "FAIL code spans"; exit 1; }
mk docs/knowledge/retired.toml '# [[retired]]
# id = "<slug>"

frozen = ["tests/fixtures/"]

[[retired]]
id = "x"'
mk tests/fixtures/corpus.md '[old](../../docs/roadmaps/g01/001-build-it.md)'
python3 "$here/cut.py" check-links --repo "$repo" > /dev/null && echo "ok check-links skips frozen paths listed in retired.toml" || { echo "FAIL retired.toml frozen"; python3 "$here/cut.py" check-links --repo "$repo"; exit 1; }
mk docs/guides/bad.md '[x](../knowledge/contracts/api.md#nope) [y](missing.md)'
set +e; out=$(python3 "$here/cut.py" check-links --repo "$repo"); rc=$?; set -e
[ "$rc" = 1 ] && echo "$out" | grep -q "missing anchor" && echo "$out" | grep -q "missing missing.md" && echo "ok check-links finds missing files and anchors, including untracked edits" || { echo "FAIL check-links negatives: $out"; exit 1; }
echo "cut self-test: OK"
