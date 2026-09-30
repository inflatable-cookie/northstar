#!/usr/bin/env bash
# Self-test for retired-concepts.ts against a scratch repository.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
check="$here/retired-concepts.ts"
repo=$(mktemp -d)
trap 'rm -rf "$repo"' EXIT
git -C "$repo" init -q
mkdir -p "$repo/docs/knowledge/contracts" "$repo/state" "$repo/old/spine"
cat > "$repo/docs/knowledge/retired.toml" <<'TOML'
frozen = ["frozen/"]

[[retired]]
id = "spine-bundles"
retired = "2026-08-21"
replacement = "Bovine publishing"
owner = "docs/knowledge/contracts/content.md"
terms = ["spine bundle"]
paths = ["old/spine/"]
config_keys = ["canonical-spine-bundle"]
allow = ["history/", "tools/*-census/", "deep/**/calibration/"]

[[retired]]
id = "planning-files"
retired = "2026-09-27"
replacement = "Queue plan"
paths = ["docs/plan.md", "docs/triage/"]

[[retired]]
id = "papercuts-file"
retired = "2026-09-26"
replacement = "Queue papercuts"
paths = ["PAPERCUTS.md"]
TOML
echo "Spine bundles are retired; content comes from Bovine." > "$repo/docs/knowledge/contracts/content.md"
echo "ok" > "$repo/state/app.toml"
git -C "$repo" add -A && git -C "$repo" -c user.email=t@t -c user.name=t commit -qm base

expect() { # <want-exit> <label>
  set +e; out=$(bun run "$check" --repo "$repo" --json); got=$?; set -e
  [ "$got" = "$1" ] || { echo "FAIL $2: exit $got, want $1"; echo "$out"; exit 1; }
  echo "ok $2"
}
commit() { git -C "$repo" add -A && git -C "$repo" -c user.email=t@t -c user.name=t commit -qm "$1"; }

expect 0 "a clean repository passes; the owner file and the retired list are exempt"
echo "x" > "$repo/old/spine/data.sql"; commit "path"
expect 1 "a tracked file under a retired path is a finding"
git -C "$repo" rm -rq old && commit "rm path"
echo "import './old/spine-locator'" > "$repo/state/loader.ts"; commit "sibling"
expect 0 "a directory path does not match a sibling file that shares its prefix"
git -C "$repo" rm -q state/loader.ts && commit "rm sibling"
echo 'key = "canonical-spine-bundle"' > "$repo/state/app.toml"; commit "key"
expect 1 "a config key is a finding"
echo "ok" > "$repo/state/app.toml"; mkdir -p "$repo/history"; echo "the SPINE BUNDLE era" > "$repo/history/log.md"; commit "allowed"
expect 0 "matches are case-insensitive but allowed paths are exempt"
mkdir -p "$repo/tools/page-census"; echo "spine bundle row" > "$repo/tools/page-census/data.md"; commit "glob"
expect 0 "a directory glob in allow covers every matching directory"
mkdir -p "$repo/deep/a/b/calibration"; echo "spine bundle" > "$repo/deep/a/b/calibration/x.md"; commit "deep"
expect 0 "a ** glob in allow matches across path segments"
mkdir -p "$repo/frozen"; echo "old spine bundle receipt" > "$repo/frozen/receipt.md"; commit "frozen"
expect 0 "top-level frozen paths are exempt from every retirement"
mkdir -p "$repo/old/spine"; echo x > "$repo/old/spine/data.sql"; commit "path again"
rm -r "$repo/old"
expect 0 "an unstaged deletion under a retired path is not a finding"
git -C "$repo" add -A && git -C "$repo" -c user.email=t@t -c user.name=t commit -qm "rm staged"
echo "new spine bundle notes" > "$repo/new.md"
expect 1 "a new untracked file is searched"
rm "$repo/new.md"
echo "see https://github.com/o/r/blob/0123abc/old/spine/data.sql for history" > "$repo/HISTORY.md"; commit "permalink"
expect 0 "a GitHub permalink pinned to a commit is a history pointer, not a live reference"
git -C "$repo" rm -q HISTORY.md && commit "rm permalink"
echo "see [papercuts](specs/024-papercuts.md) and old-PAPERCUTS.md" > "$repo/notes.md"; commit "path boundary"
expect 0 "a path matches case-sensitively and only at a path boundary"
echo "write it to PAPERCUTS.md, or apps/x/PAPERCUTS.md" > "$repo/notes.md"; commit "path hit"
expect 1 "a path at a boundary is a finding"
git -C "$repo" rm -q notes.md && commit "rm notes"
mkdir -p "$repo/docs/knowledge/notes"
echo "Intent lives in \`plan.md\`." > "$repo/docs/AGENTS.md"; commit "relative"
expect 1 "a relative reference inside the retired path's directory is a finding"
echo "See ../plan.md for order." > "$repo/docs/AGENTS.md"; commit "relative up"
expect 0 "a reference that resolves outside the retired path is not a finding"
echo "See ../plan.md for order." > "$repo/docs/knowledge/notes.md"; commit "relative deeper"
expect 1 "a ../ reference that resolves to the retired path is a finding"
rm "$repo/docs/knowledge/notes.md"; echo "Our \`plan.md\` template." > "$repo/docs/knowledge/notes/x.md"; commit "sibling name"
expect 0 "a same-named file elsewhere is not a finding"
echo "Sequencing moved; see \`plan.md\` (Git history)." > "$repo/docs/AGENTS.md"; commit "history pointer"
expect 0 "a history pointer is not a finding"
echo "See \`triage/README.md\`." > "$repo/docs/AGENTS.md"; commit "relative dir"
expect 1 "a relative reference into a retired directory is a finding"
echo "links README.md triage/README.md" > "$repo/docs/effigy.toml"; echo "ok" > "$repo/docs/AGENTS.md"; commit "config"
expect 0 "relative matching reads Markdown only; config paths depend on where they run"
echo "- \`../plan.md\` (in Git history)" > "$repo/docs/knowledge/notes/y.md"; commit "in history"
expect 0 "an (in Git history) pointer is not a finding"
echo "- \`triage/2026-old-note.md\` (Git history)" > "$repo/docs/knowledge/notes/y.md"; echo "- \`../triage/x.md\` (in Git history)" > "$repo/docs/knowledge/notes/z.md"; commit "dir history"
expect 0 "a history pointer to a file under a retired directory is not a finding"
git -C "$repo" rm -rq docs/AGENTS.md docs/effigy.toml docs/knowledge/notes && commit "rm relative"
echo "rebuild the Spine Bundle" > "$repo/README.md"; commit "term"
expect 1 "a term in a live file is a finding"
echo "[[retired]" > "$repo/docs/knowledge/retired.toml"; commit "bad toml"
expect 2 "invalid TOML is a configuration error"
echo "retired-concepts self-test: OK"
