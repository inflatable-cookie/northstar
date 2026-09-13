#!/usr/bin/env bash
# Focused proof for g03.006 portable lifecycle adoption, the g03.007
# hook-owned closeout cutover, and the g03.008 pinned hook runtime.
#
# 1. Runs the lifecycle core oracle (reducer, containment, multi-target).
# 2. Scans the hook adapter with the same portability scan as the core.
# 3. Proves the shipped control-manifest grammar admits a non-Northstar hook
#    and that the adapter refuses non-Northstar instructions honestly.
# 4. Runs the hook adapter against real fixture repositories: pre-dispatch
#    gate, hostile events, read-only binding, escape refusal, squash refusal,
#    bootstrap closeout, idempotent replay, block/cancel mapping. Every
#    fixture invocation goes through the committed launcher, so each result is
#    produced by repository-committed runtime bytes.
# 5. Proves the closeout hook consumes exactly the submitted handoff:
#    deletion inside declared allowed paths, changed/symlinked/missing
#    handoff refusals before any byte changes, and replay idempotence.
# 6. Proves the active generation README is a deterministic projection target
#    and that no mutation lands outside declared paths; the generated block
#    names the active generation, its open disposition, and the derived
#    planning_required runway after the only task reaches terminal state.
# 7. Proves terminal equivalence: equivalent standalone and generic Queue
#    sequences produce the same portable digest, in both task orders.
# 8. Proves generation compaction consumes exact closure authority through the
#    committed runtime: terminal records alone refuse, tasks-digest authors the
#    closure, a fresh closed record compacts, replay is a no-op, stale
#    authority refuses, and removing the closure reopens the generation.
# 9. Proves the committed runtime closure: the launcher, reducer, adapter, and
#    every schema come from the repository checkout, the closure is derived
#    from the canonical skill, and drift in code, schema, launcher bytes,
#    extra files, or the executable bit fails the parity oracle.
# 10. Proves a hostile or stale global installation under $HOME cannot change
#    what Queue executes, and that removing it entirely changes nothing.
# 11. Proves the copy-ready starter is self-contained: a consumer repository
#    built only from `template-bundle/lifecycle/` runs the closeout with no
#    Northstar source checkout and a minimal environment.
# 12. Runs the closeout through the committed launcher under a minimal
#    environment: no Paseo, Queue, network, global skill, or Northstar source
#    checkout.

set -euo pipefail

harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
repo_root=$(cd "$harness_dir/../../.." && pwd -P)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/northstar-lifecycle-adoption.XXXXXX")
# Lexical containment in the core compares path spellings; a $TMPDIR with a
# trailing slash would give the scratch a doubled separator and break it.
scratch=$(cd "$scratch" && pwd -P)
trap 'rm -rf "$scratch"' EXIT

source_skill="$repo_root/skills/northstar"
core="$source_skill/scripts/lifecycle-core.ts"
hook="$source_skill/scripts/lifecycle-queue-hook.ts"
runtime_tool="$source_skill/scripts/lifecycle-runtime.ts"
dogfood_hooks="$repo_root/.paseo/hooks"
starter_hooks="$repo_root/template-bundle/lifecycle/hooks"
installed_home="$scratch/home"
installed="$installed_home/.agents/skills/northstar"
EVENT_SCHEMA="paseo.queue.event.v1"
CURRENT_REPO=""

mkdir -p "$installed_home/.agents/skills"
rsync -a --delete "$source_skill/" "$installed/"

echo "# core oracle and source/install parity"
bun run "$core" oracle >/dev/null
effigy --repo "$repo_root" check:skill-install "$installed" >/dev/null
echo "core oracle and parity: OK"

echo "# hook adapter portability scan"
bun -e '
  const core = await import(process.argv[1]);
  const fs = await import("node:fs");
  const forbidden = core.forbiddenImportSpecifiers(fs.readFileSync(process.argv[2], "utf8"));
  if (forbidden.length > 0) {
    console.error("hook adapter imports provider/network modules: " + forbidden.join(", "));
    process.exit(1);
  }
' "$core" "$hook"
echo "hook adapter imports no Paseo, Queue, daemon, or network module: OK"

echo "# committed hook runtime closure is generated, complete, and drift-checked"
runtime_clone="$scratch/runtime-hooks"
bun run "$runtime_tool" check --hooks "$dogfood_hooks" >/dev/null
bun run "$runtime_tool" check --hooks "$starter_hooks" >/dev/null
bun run "$runtime_tool" copy --hooks "$runtime_clone" >/dev/null
bun run "$runtime_tool" check --hooks "$runtime_clone" >/dev/null
[ -x "$runtime_clone/northstar-lifecycle" ]
[ -f "$runtime_clone/northstar-lifecycle.runtime/scripts/lifecycle-queue-hook.ts" ]
[ -f "$runtime_clone/northstar-lifecycle.runtime/scripts/lifecycle-core.ts" ]
# The closure is derived, so it carries every canonical schema, not a list.
canonical_schemas=$(find "$source_skill/references/lifecycle" -name '*.schema.json' | wc -l | tr -d ' ')
committed_schemas=$(find "$runtime_clone/northstar-lifecycle.runtime/references/lifecycle" -name '*.schema.json' | wc -l | tr -d ' ')
[ "$canonical_schemas" = "$committed_schemas" ]
[ "$canonical_schemas" -gt 0 ]
# Every relative import in the committed payload resolves inside the payload,
# so no executed module can come from the checkout or the installing user.
bun -e '
  const fs = await import("node:fs");
  const path = await import("node:path");
  const root = path.resolve(process.argv[1]);
  const walk = (dir) => fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) =>
    entry.isDirectory() ? walk(path.join(dir, entry.name)) : [path.join(dir, entry.name)]);
  const offenders = [];
  for (const file of walk(root).filter((name) => name.endsWith(".ts"))) {
    const source = fs.readFileSync(file, "utf8");
    for (const match of source.matchAll(/(?:from|import)\s+"([^"]+)"/g)) {
      const spec = match[1];
      if (!spec.startsWith(".")) continue;
      const resolved = path.resolve(path.dirname(file), spec);
      if (resolved !== root && !resolved.startsWith(root + path.sep)) offenders.push(file + " -> " + spec);
    }
  }
  if (offenders.length > 0) {
    console.error("committed runtime closure escapes its own payload: " + offenders.join(", "));
    process.exit(1);
  }
' "$runtime_clone/northstar-lifecycle.runtime"

fresh_runtime() { # <name> -> prints a private copy of the generated payload
  local dir="$scratch/$1"
  rm -rf "$dir"
  cp -R "$runtime_clone" "$dir"
  printf '%s' "$dir"
}

expect_runtime_drift() { # <hooks-dir> <label> <expected-path>
  if bun run "$runtime_tool" check --hooks "$1" > "$scratch/runtime-drift.out" 2>&1; then
    echo "$2: runtime parity check accepted drifted bytes" >&2
    exit 1
  fi
  grep -q "lifecycle hook runtime drift" "$scratch/runtime-drift.out"
  grep -q "$3" "$scratch/runtime-drift.out"
}

mutate_code="$(fresh_runtime runtime-drift-code)"
printf '\n// drifted reducer\n' >> "$mutate_code/northstar-lifecycle.runtime/scripts/lifecycle-core.ts"
expect_runtime_drift "$mutate_code" "drifted reducer" "lifecycle-core.ts"

mutate_schema="$(fresh_runtime runtime-drift-schema)"
printf '\n' >> "$mutate_schema/northstar-lifecycle.runtime/references/lifecycle/queue-event.schema.json"
expect_runtime_drift "$mutate_schema" "drifted schema" "queue-event.schema.json"

mutate_launcher="$(fresh_runtime runtime-drift-launcher)"
printf '\n# drifted launcher\n' >> "$mutate_launcher/northstar-lifecycle"
expect_runtime_drift "$mutate_launcher" "drifted launcher" "northstar-lifecycle"

mutate_missing="$(fresh_runtime runtime-drift-missing)"
rm "$mutate_missing/northstar-lifecycle.runtime/references/lifecycle/evidence.schema.json"
expect_runtime_drift "$mutate_missing" "missing schema" "evidence.schema.json"

mutate_extra="$(fresh_runtime runtime-drift-extra)"
printf '// second implementation\n' > "$mutate_extra/northstar-lifecycle.runtime/scripts/lifecycle-extra.ts"
expect_runtime_drift "$mutate_extra" "extra runtime module" "lifecycle-extra.ts"

mutate_mode="$(fresh_runtime runtime-drift-mode)"
chmod -x "$mutate_mode/northstar-lifecycle"
expect_runtime_drift "$mutate_mode" "non-executable launcher" "not executable"

# `copy` is the repair: it rewrites canonical bytes and prunes stale ones.
bun run "$runtime_tool" copy --hooks "$mutate_code" >/dev/null
bun run "$runtime_tool" check --hooks "$mutate_code" >/dev/null
bun run "$runtime_tool" copy --hooks "$mutate_extra" >/dev/null
bun run "$runtime_tool" check --hooks "$mutate_extra" >/dev/null
bun run "$runtime_tool" copy --hooks "$mutate_mode" >/dev/null
bun run "$runtime_tool" check --hooks "$mutate_mode" >/dev/null
echo "committed runtime closure parity: OK"

echo "# manifest grammar stays document-system agnostic"
bun run "$core" schema-check \
  --schema "$source_skill/references/lifecycle/queue-control.schema.json" \
  --instance "$repo_root/.paseo/queue.json" >/dev/null
cat > "$scratch/plain-manifest.json" <<'EOF'
{
  "schema": "paseo.queue.control.v1",
  "hooks": [
    {
      "id": "json-ledger",
      "events": ["task.closeout"],
      "mode": "integration_write",
      "delivery": "required",
      "executable": "hooks/append-ledger",
      "argv": [],
      "timeoutMs": 5000,
      "maxOutputBytes": 4096,
      "allowedPaths": ["ledger/"],
      "commitSubject": { "prefix": "ledger", "maxBytes": 60 }
    }
  ]
}
EOF
bun run "$core" schema-check \
  --schema "$source_skill/references/lifecycle/queue-control.schema.json" \
  --instance "$scratch/plain-manifest.json" >/dev/null
echo "shipped and non-Northstar manifests validate against the frozen control grammar: OK"

# ---------------------------------------------------------------------------
# Fixture repository: two tasks planned and readied, one committed handoff
# each, a feature branch merged with a merge commit, front doors committed.
# ---------------------------------------------------------------------------
build_fixture() { # <repo-dir> [dogfood|starter]
  local repo=$1 surface=${2:-dogfood}
  local queue_from hooks_from targets_from
  case "$surface" in
    dogfood)
      queue_from="$repo_root/.paseo/queue.json"
      hooks_from="$dogfood_hooks"
      targets_from="$repo_root/.northstar/lifecycle/v1/projection-targets.json"
      ;;
    starter)
      queue_from="$repo_root/template-bundle/lifecycle/queue.json"
      hooks_from="$starter_hooks"
      targets_from="$repo_root/template-bundle/lifecycle/projection-targets.json"
      ;;
    *) echo "fixture failure: unknown hooks surface $surface" >&2; exit 1 ;;
  esac
  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.email fixture@example.invalid
  git -C "$repo" config user.name Fixture
  mkdir -p "$repo/docs/roadmaps/g03" "$repo/docs/handoffs" "$repo/.northstar/lifecycle/v1" "$repo/.paseo/hooks"
  for number in 006 007; do
    printf '# Task g03.%s\n\nStatus: ready\nOwner: fixture\n' "$number" \
      > "$repo/docs/roadmaps/g03/$number-fixture-task.md"
    git -C "$repo" add -A
    git -C "$repo" commit -qm "plan g03.$number"
    printf 'Deployment note: none yet.\n' >> "$repo/docs/roadmaps/g03/$number-fixture-task.md"
    git -C "$repo" add -A
    git -C "$repo" commit -qm "ready g03.$number"

    cat > "$repo/docs/handoffs/handoff-$number.md" <<EOF
---
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
---

## Current State

- Ready task: [\`g03.$number\`](../roadmaps/g03/$number-fixture-task.md)
EOF
    git -C "$repo" add -A
    git -C "$repo" commit -qm "handoff for g03.$number"
  done

  printf '# Project\n\nHuman front door stays.\n' > "$repo/docs/README.md"
  printf '# Roadmaps\n\nHuman roadmap stays.\n' > "$repo/docs/roadmaps/README.md"
  mkdir -p "$repo/docs/roadmaps/g03"
  printf '# g03\n\nHuman generation runway stays.\n' > "$repo/docs/roadmaps/g03/README.md"
  cp "$queue_from" "$repo/.paseo/queue.json"
  cp -R "$hooks_from/." "$repo/.paseo/hooks/"
  chmod +x "$repo/.paseo/hooks/northstar-lifecycle"
  cp "$targets_from" "$repo/.northstar/lifecycle/v1/projection-targets.json"
  if [ "$surface" = starter ]; then
    # Adoption edit: the copied starter declares its own scaffold generation;
    # this consumer's active generation is g03.
    bun -e '
      const fs = await import("node:fs");
      const file = process.argv[1];
      const config = JSON.parse(fs.readFileSync(file, "utf8"));
      config.active_generation = "g03";
      fs.writeFileSync(file, JSON.stringify(config, null, 2) + "\n");
    ' "$repo/.northstar/lifecycle/v1/projection-targets.json"
  fi
  git -C "$repo" add -A
  git -C "$repo" commit -qm "install lifecycle hook surfaces"

  git -C "$repo" checkout -qb feature
  echo "work" > "$repo/work.txt"
  git -C "$repo" add -A
  git -C "$repo" commit -qm "feature work"
  git -C "$repo" checkout -q main
  git -C "$repo" merge -q --no-ff feature -m "Merge branch 'feature'"
}

fixture_facts() { # <repo> <number> -> 5 lines: instruction commit, planning commit, instruction digest, feature head, merge commit
  local repo=$1 number=$2
  printf '%s\n' \
    "$(git -C "$repo" log -1 --format=%H -- "docs/handoffs/handoff-$number.md")" \
    "$(git -C "$repo" log -1 --format=%H -- "docs/roadmaps/g03/$number-fixture-task.md")" \
    "$(git -C "$repo" show "main:docs/handoffs/handoff-$number.md" | sha256sum | cut -d' ' -f1)" \
    "$(git -C "$repo" rev-parse feature)" \
    "$(git -C "$repo" rev-parse main)"
}

read_facts() { # <facts> into globals IC PC ID FH MC
  { read -r IC; read -r PC; read -r ID; read -r FH; read -r MC; } <<< "$1"
}

write_event() { # <file> <event-id> <event> <hook-id> <base> <queue-task> <title-json> <instruction-path> <instruction-commit> <instruction-digest-hex> [delivery-json]
  local file=$1 eventId=$2 event=$3 hookId=$4 base=$5 qtask=$6 title=$7 ipath=$8 icommit=$9 idigest=${10}
  local delivery=${11:-'{"prUrl":null,"prNumber":null,"head":null,"review":null,"mergeCommit":null,"integrationCommit":null,"summary":""}'}
  cat > "$file" <<EOF
{
  "schema": "$EVENT_SCHEMA",
  "eventId": "$eventId",
  "hookId": "$hookId",
  "event": "$event",
  "occurredAt": "2026-09-12T21:30:00.000Z",
  "attempt": 1,
  "repository": {"root": "$CURRENT_REPO", "baseBranch": "main", "baseCommit": "$base"},
  "task": {"id": "$qtask", "title": $title, "phase": "closing",
    "instruction": {"path": "$ipath", "commit": "$icommit", "digest": "sha256:$idigest", "mediaType": "text/markdown"}},
  "delivery": $delivery
}
EOF
}

run_hook() { # <event-file> <event-id> -> stdout JSON, exit code asserted 0
  # Always execute the repository-committed launcher: every result in this
  # harness must come from committed runtime bytes, never an installed skill.
  (cd "$CURRENT_REPO" && HOME="$installed_home" \
    PASEO_QUEUE_EVENT_ID="$2" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
    "$CURRENT_REPO/.paseo/hooks/northstar-lifecycle" < "$1")
}

json_field() { # <json> <expr over r>
  printf '%s' "$1" | bun -e '
    const chunks = [];
    for await (const chunk of process.stdin) chunks.push(chunk);
    const r = JSON.parse(Buffer.concat(chunks).toString("utf8"));
    process.stdout.write(String(eval(process.argv[1])));
  ' "$2"
}

expect_outcome() { # <json> <outcome> <label>
  local actual
  actual=$(json_field "$1" "r.outcome")
  if [ "$actual" != "$2" ]; then
    echo "$3: expected outcome $2, got $actual: $1" >&2
    exit 1
  fi
}

closeout_delivery() { # <head> <merge> -> delivery JSON
  printf '{"prUrl": "https://github.com/example/repo/pull/51", "prNumber": 51, "head": "%s", "review": "approved at head", "mergeCommit": "%s", "integrationCommit": "%s", "summary": "effigy qa passed"}' "$1" "$2" "$2"
}

echo "# fixture repository"
repoA="$scratch/repo-a"
build_fixture "$repoA"
CURRENT_REPO="$repoA"
read_facts "$(fixture_facts "$repoA" 006)"
echo "fixture repository with merged PR topology: OK"

echo "# pre-dispatch gate verifies identity without writing"
write_event "$scratch/pre.json" "evt-pre-0001" "task.pre_dispatch" "lifecycle-gate" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
expect_outcome "$(run_hook "$scratch/pre.json" "evt-pre-0001")" ok "pre-dispatch"
[ "$(json_field "$(run_hook "$scratch/pre.json" "evt-pre-0001")" "r.metadata.record_exists")" = "false" ]
[ -z "$(git -C "$repoA" status --porcelain)" ]
echo "pre-dispatch gate: OK"

echo "# hostile events fail closed without writes"
write_event "$scratch/tampered.json" "evt-tampered-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "0000000000000000000000000000000000000000000000000000000000000000"
tampered=$(run_hook "$scratch/tampered.json" "evt-tampered-0001")
expect_outcome "$tampered" blocked "tampered digest"
json_field "$tampered" "r.summary.includes('digest mismatch')" >/dev/null

write_event "$scratch/wronghook.json" "evt-wronghook-0001" "task.closeout" "no-such-hook" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
expect_outcome "$(run_hook "$scratch/wronghook.json" "evt-wronghook-0001")" blocked "unknown hook id"

task_digest=$(git -C "$repoA" show "main:docs/roadmaps/g03/006-fixture-task.md" | sha256sum | cut -d' ' -f1)
write_event "$scratch/nonhandoff.json" "evt-nonhandoff-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/roadmaps/g03/006-fixture-task.md" "$PC" "$task_digest"
nonhandoff=$(run_hook "$scratch/nonhandoff.json" "evt-nonhandoff-0001")
expect_outcome "$nonhandoff" blocked "non-handoff instruction"
json_field "$nonhandoff" "r.summary.includes('not a Northstar handoff')" >/dev/null

printf '%s\n' '{"schema": "paseo.queue.event.v1", "eventId": "x", "bogus": true}' > "$scratch/badschema.json"
badschema=$(run_hook "$scratch/badschema.json" "x")
expect_outcome "$badschema" failed "unknown event key"
json_field "$badschema" "r.summary.includes('not a valid')" >/dev/null

(cd "$repoA" && HOME="$installed_home" \
  PASEO_QUEUE_EVENT_ID="different-id" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
  bun run "$installed/scripts/lifecycle-queue-hook.ts" < "$scratch/pre.json" > "$scratch/envmismatch.out")
expect_outcome "$(cat "$scratch/envmismatch.out")" blocked "env identity mismatch"
json_field "$(cat "$scratch/envmismatch.out")" "r.summary.includes('PASEO_QUEUE_EVENT_ID')" >/dev/null

[ -z "$(git -C "$repoA" status --porcelain)" ]
[ "$(git -C "$repoA" rev-parse HEAD)" = "$MC" ]
echo "hostile events: OK"

echo "# read-only binding validates the closeout without writing"
cp "$repoA/.paseo/queue.json" "$scratch/saved-manifest.json"
bun -e '
  const fs = await import("node:fs");
  const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  for (const hook of manifest.hooks) {
    if (hook.id === "lifecycle-state") {
      hook.mode = "read_only";
      hook.allowedPaths = [];
      hook.commitSubject = null;
    }
  }
  fs.writeFileSync(process.argv[2], JSON.stringify(manifest, null, 2) + "\n");
' "$scratch/saved-manifest.json" "$repoA/.paseo/queue.json"
write_event "$scratch/closeout-ro.json" "evt-closeout-ro-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
ro=$(run_hook "$scratch/closeout-ro.json" "evt-closeout-ro-0001")
expect_outcome "$ro" ok "read-only closeout"
[ "$(json_field "$ro" "r.changedPaths.length")" = "0" ]
[ ! -e "$repoA/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoA/docs/handoffs/handoff-006.md" ]
cp "$scratch/saved-manifest.json" "$repoA/.paseo/queue.json"
[ -z "$(git -C "$repoA" status --porcelain)" ]
echo "read-only closeout binding: OK"

echo "# reserved manifest paths are refused"
bun -e '
  const fs = await import("node:fs");
  const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  manifest.hooks[1].allowedPaths.push(".paseo/queue.json");
  fs.writeFileSync(process.argv[2], JSON.stringify(manifest, null, 2) + "\n");
' "$scratch/saved-manifest.json" "$repoA/.paseo/queue.json"
reserved=$(run_hook "$scratch/closeout-ro.json" "evt-closeout-ro-0001")
expect_outcome "$reserved" blocked "reserved allowedPath"
json_field "$reserved" "r.summary.includes('reserved path')" >/dev/null
cp "$scratch/saved-manifest.json" "$repoA/.paseo/queue.json"
[ -z "$(git -C "$repoA" status --porcelain)" ]
echo "reserved manifest path refusal: OK"

echo "# undeclared projection target is refused before any write"
cat > "$repoA/.northstar/lifecycle/v1/projection-targets.json" <<'EOF'
{
  "schema_version": "northstar.lifecycle.projection-targets.v2",
  "targets": ["docs/README.md", "outside/leak.md"],
  "active_generation": "g03"
}
EOF
write_event "$scratch/closeout-escape.json" "evt-closeout-escape-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
escape=$(run_hook "$scratch/closeout-escape.json" "evt-closeout-escape-0001")
expect_outcome "$escape" blocked "escaping projection target"
json_field "$escape" "r.summary.includes('allowedPaths')" >/dev/null
[ ! -e "$repoA/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoA/docs/handoffs/handoff-006.md" ]
cp "$repo_root/.northstar/lifecycle/v1/projection-targets.json" "$repoA/.northstar/lifecycle/v1/projection-targets.json"
[ -z "$(git -C "$repoA" status --porcelain)" ]
echo "projection-target escape refusal: OK"

echo "# escaping instruction path fails closed before any read"
write_event "$scratch/closeout-dots.json" "evt-closeout-dots-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/roadmaps/../handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
dots=$(run_hook "$scratch/closeout-dots.json" "evt-closeout-dots-0001")
expect_outcome "$dots" blocked "parent-segment instruction path"
json_field "$dots" "r.summary.includes('parent segment')" >/dev/null
[ -z "$(git -C "$repoA" status --porcelain)" ]
echo "instruction path escape refusal: OK"

echo "# squash-shaped delivery is refused rather than fabricated"
repoS="$scratch/repo-squash"
build_fixture "$repoS"
git -C "$repoS" checkout -q main
# Drop the real merge so main never contains the feature head, then land the
# same work as one squash-style commit.
git -C "$repoS" reset -q --hard main~1
git -C "$repoS" cherry-pick -q --allow-empty --keep-redundant-commits feature 2>/dev/null || true
echo squashed > "$repoS/work.txt"
git -C "$repoS" add -A
git -C "$repoS" commit -qm "squash-shaped work"
squash_merge=$(git -C "$repoS" rev-parse HEAD)
if git -C "$repoS" merge-base --is-ancestor "$(git -C "$repoS" rev-parse feature)" "$squash_merge"; then
  echo "fixture failure: squash repository still contains the feature head" >&2
  exit 1
fi
CURRENT_REPO="$repoS"
read_facts "$(fixture_facts "$repoS" 006)"
write_event "$scratch/closeout-sq.json" "evt-closeout-sq-0001" "task.closeout" "lifecycle-state" "$squash_merge" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" \
  "$(printf '{"prUrl": null, "prNumber": 52, "head": "%s", "review": "approved at head", "mergeCommit": "%s", "integrationCommit": "%s", "summary": "qa passed"}' "$FH" "$squash_merge" "$squash_merge")"
sq=$(run_hook "$scratch/closeout-sq.json" "evt-closeout-sq-0001")
expect_outcome "$sq" blocked "squash-shaped merge"
json_field "$sq" "r.summary.includes('refusing to invent a merge method')" >/dev/null
[ ! -e "$repoS/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "squash refusal: OK"

echo "# bootstrap closeout publishes the terminal record and projections"
CURRENT_REPO="$repoA"
read_facts "$(fixture_facts "$repoA" 006)"
write_event "$scratch/closeout-a.json" "evt-closeout-a-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
closeout=$(run_hook "$scratch/closeout-a.json" "evt-closeout-a-0001")
expect_outcome "$closeout" ok "bootstrap closeout"
[ "$(json_field "$closeout" "r.metadata.revision")" = "8" ]
[ "$(json_field "$closeout" "r.commitSubjectSuffix")" = "g03.006 terminal record" ]
[ "$(json_field "$closeout" "r.changedPaths.includes('docs/README.md')")" = "true" ]
[ "$(json_field "$closeout" "r.changedPaths.includes('docs/roadmaps/README.md')")" = "true" ]
[ "$(json_field "$closeout" "r.changedPaths.includes('docs/roadmaps/g03/README.md')")" = "true" ]
[ "$(json_field "$closeout" "r.changedPaths.includes('docs/handoffs/handoff-006.md')")" = "true" ]
[ "$(json_field "$closeout" "r.metadata.handoff_consumed")" = "true" ]
grep -q "Human front door stays." "$repoA/docs/README.md"
grep -q "| g03 | open | planning_required |" "$repoA/docs/README.md"
grep -q "| g03.006 | complete | none |" "$repoA/docs/README.md"
grep -q "Human roadmap stays." "$repoA/docs/roadmaps/README.md"
grep -q "northstar:lifecycle:begin" "$repoA/docs/README.md"
grep -q "Human generation runway stays." "$repoA/docs/roadmaps/g03/README.md"
grep -q "| g03.006 | complete | none |" "$repoA/docs/roadmaps/g03/README.md"
[ ! -e "$repoA/docs/handoffs/handoff-006.md" ]
[ -z "$(git -C "$repoA" diff --cached)" ]
[ "$(git -C "$repoA" rev-parse HEAD)" = "$MC" ]
digest_a=$(json_field "$closeout" "r.metadata.portable_digest")
[ -n "$digest_a" ]
echo "bootstrap closeout: OK"

echo "# exhausted open generation projects planning_required, not completion"
[ ! -e "$repoA/.northstar/lifecycle/v1/generations/g03.closure.json" ]
runway_count=$(grep -h "| g03 | open | planning_required |" "$repoA/docs/README.md" "$repoA/docs/roadmaps/README.md" "$repoA/docs/roadmaps/g03/README.md" | wc -l | tr -d ' ')
[ "$runway_count" = "3" ]
if grep -q "| g03 | complete" "$repoA/docs/README.md"; then
  echo "projection labeled an open generation complete" >&2
  exit 1
fi
echo "runway state line: OK"

echo "# exact handoff consumption inside declared paths only"
git -C "$repoA" status --porcelain | grep -q " D docs/handoffs/handoff-006.md"
while IFS= read -r line; do
  [ -z "$line" ] && continue
  path="${line:3}"
  case "$path" in
    .northstar/lifecycle/*|docs/roadmaps/*|docs/handoffs/*|docs/README.md) ;;
    *)
      echo "mutation outside declared allowed paths: $path" >&2
      exit 1
      ;;
  esac
done < <(git -C "$repoA" status --porcelain)
echo "exact handoff consumption: OK"

echo "# changed handoff fails closed before any byte changes"
repoC="$scratch/repo-changed"
build_fixture "$repoC"
CURRENT_REPO="$repoC"
read_facts "$(fixture_facts "$repoC" 006)"
printf '\nLate editorial change.\n' >> "$repoC/docs/handoffs/handoff-006.md"
write_event "$scratch/closeout-c.json" "evt-closeout-c-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
changed=$(run_hook "$scratch/closeout-c.json" "evt-closeout-c-0001")
expect_outcome "$changed" blocked "changed handoff"
json_field "$changed" "r.summary.includes('changed since its pinned instruction blob')" >/dev/null
[ -e "$repoC/docs/handoffs/handoff-006.md" ]
[ ! -e "$repoC/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ "$(git -C "$repoC" status --porcelain)" = " M docs/handoffs/handoff-006.md" ]
git -C "$repoC" checkout -q -- docs/handoffs/handoff-006.md
echo "changed handoff refusal: OK"

echo "# symlinked handoff fails closed"
outside_file="$scratch/outside-handoff-target.md"
cp "$repoC/docs/handoffs/handoff-006.md" "$outside_file"
rm "$repoC/docs/handoffs/handoff-006.md"
ln -s "$outside_file" "$repoC/docs/handoffs/handoff-006.md"
symlink=$(run_hook "$scratch/closeout-c.json" "evt-closeout-c-0001")
expect_outcome "$symlink" blocked "symlinked handoff"
json_field "$symlink" "r.summary.includes('symlink')" >/dev/null
[ -L "$repoC/docs/handoffs/handoff-006.md" ]
[ ! -e "$repoC/.northstar/lifecycle/v1/tasks/g03.006.json" ]
rm "$repoC/docs/handoffs/handoff-006.md"
echo "symlinked handoff refusal: OK"

echo "# missing handoff with a non-terminal record fails closed"
missing=$(run_hook "$scratch/closeout-c.json" "evt-closeout-c-0001")
expect_outcome "$missing" blocked "missing handoff"
json_field "$missing" "r.summary.includes('missing from the integration checkout')" >/dev/null
[ ! -e "$repoC/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ "$(git -C "$repoC" status --porcelain)" = " D docs/handoffs/handoff-006.md" ]
git -C "$repoC" checkout -q -- docs/handoffs/handoff-006.md
echo "missing handoff refusal: OK"

echo "# identical retry is a no-diff replay"
retry=$(run_hook "$scratch/closeout-a.json" "evt-closeout-a-0001")
expect_outcome "$retry" ok "closeout retry"
[ "$(json_field "$retry" "r.changedPaths.length")" = "0" ]
[ ! -e "$repoA/docs/handoffs/handoff-006.md" ]
status_before=$(git -C "$repoA" status --porcelain)
run_hook "$scratch/closeout-a.json" "evt-closeout-a-0001" >/dev/null
[ "$status_before" = "$(git -C "$repoA" status --porcelain)" ]
echo "idempotent replay: OK"

echo "# committed launcher runs the adapter from a minimal environment"
launcher_out=$(cd "$repoA" && env -i HOME="$installed_home" PATH="$PATH" TMPDIR="${TMPDIR:-/tmp}" \
  PASEO_QUEUE_EVENT_ID="evt-closeout-a-0001" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
  ".paseo/hooks/northstar-lifecycle" < "$scratch/closeout-a.json")
expect_outcome "$launcher_out" ok "launcher replay"
[ "$(json_field "$launcher_out" "r.changedPaths.length")" = "0" ]
echo "committed launcher isolation: OK"

echo "# generation compaction consumes exact closure authority"
installed_core="$installed/scripts/lifecycle-core.ts"
compact_cmd=(compact --records .northstar/lifecycle/v1/tasks --generation g03 --out .northstar/lifecycle/v1/generations/g03.json)
if (cd "$repoA" && bun run "$installed_core" "${compact_cmd[@]}" > "$scratch/compact-noclosure.out" 2>&1); then
  echo "compaction without closure authority succeeded" >&2
  exit 1
fi
grep -q "closure record" "$scratch/compact-noclosure.out"
[ ! -e "$repoA/.northstar/lifecycle/v1/generations/g03.json" ]
tasks_json=$(cd "$repoA" && bun run "$installed_core" tasks-digest --records .northstar/lifecycle/v1/tasks --generation g03)
tasks_digest=$(json_field "$tasks_json" "r.tasks_digest")
[ -n "$tasks_digest" ]
mkdir -p "$repoA/.northstar/lifecycle/v1/generations"
printf '{\n  "schema_version": "northstar.lifecycle.generation-closure.v1",\n  "generation": "g03",\n  "disposition": "closed",\n  "reason": "fixture rollover boundary after preservation oracle",\n  "tasks_digest": "%s",\n  "closed_at": "2026-09-12T23:00:00.000Z"\n}\n' "$tasks_digest" > "$repoA/.northstar/lifecycle/v1/generations/g03.closure.json"
compact_out=$(cd "$repoA" && bun run "$installed_core" "${compact_cmd[@]}")
[ "$(json_field "$compact_out" "r.status")" = "applied" ]
[ "$(json_field "$(cat "$repoA/.northstar/lifecycle/v1/generations/g03.json")" "r.source_digest")" = "$tasks_digest" ]
compact_replay=$(cd "$repoA" && bun run "$installed_core" "${compact_cmd[@]}")
[ "$(json_field "$compact_replay" "r.status")" = "unchanged" ]
printf '{\n  "schema_version": "northstar.lifecycle.generation-closure.v1",\n  "generation": "g03",\n  "disposition": "closed",\n  "reason": "stale authority",\n  "tasks_digest": "sha256:%s",\n  "closed_at": "2026-09-12T23:00:00.000Z"\n}\n' "0000000000000000000000000000000000000000000000000000000000000000" > "$repoA/.northstar/lifecycle/v1/generations/g03.closure.json"
if (cd "$repoA" && bun run "$installed_core" "${compact_cmd[@]}" > "$scratch/compact-stale.out" 2>&1); then
  echo "stale closure authority accepted" >&2
  exit 1
fi
grep -q "stale or mismatched" "$scratch/compact-stale.out"
rm "$repoA/.northstar/lifecycle/v1/generations/g03.closure.json" "$repoA/.northstar/lifecycle/v1/generations/g03.json"
echo "closure-gated compaction: OK"

echo "# a hostile or stale global installation cannot change executed bytes"
hostile_home="$scratch/hostile-home"
for base in "$hostile_home/.agents/skills/northstar" "$hostile_home/.pi/agent/skills/northstar"; do
  mkdir -p "$base/scripts"
  cat > "$base/scripts/lifecycle-queue-hook.ts" <<'EOF'
// Hostile stale adapter: the g03.007 failure shape. It claims success without
// consuming the handoff and records that it ran, so any resolution of this
// file instead of the committed runtime is observable.
import * as fs from "node:fs";
fs.writeFileSync("hostile-global-adapter-ran.marker", "ran\n");
console.log(JSON.stringify({
  schema: "paseo.queue.hook-result.v1",
  eventId: process.env.PASEO_QUEUE_EVENT_ID ?? "",
  outcome: "ok",
  summary: "hostile global adapter ran",
  changedPaths: [],
  metadata: {},
  commitSubjectSuffix: null,
}));
EOF
done
repoE="$scratch/repo-hostile"
build_fixture "$repoE"
CURRENT_REPO="$repoE"
read_facts "$(fixture_facts "$repoE" 006)"
write_event "$scratch/closeout-hostile.json" "evt-closeout-hostile-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
hostile_out=$(cd "$repoE" && env -i HOME="$hostile_home" PATH="$PATH" TMPDIR="${TMPDIR:-/tmp}" \
  PASEO_QUEUE_EVENT_ID="evt-closeout-hostile-0001" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
  ".paseo/hooks/northstar-lifecycle" < "$scratch/closeout-hostile.json")
expect_outcome "$hostile_out" ok "hostile global closeout"
if [ "$(json_field "$hostile_out" "r.summary.includes('hostile')")" != "false" ]; then
  echo "hostile global installation supplied the executed adapter" >&2
  exit 1
fi
[ "$(json_field "$hostile_out" "r.metadata.handoff_consumed")" = "true" ]
[ ! -e "$repoE/hostile-global-adapter-ran.marker" ]
[ ! -e "$repoE/docs/handoffs/handoff-006.md" ]
[ -f "$repoE/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "stale global installation ignored: OK"

echo "# copy-only starter consumer runs with no Northstar checkout or skill"
consumer="$scratch/starter-consumer"
build_fixture "$consumer" starter
emptied_home="$scratch/empty-home"
mkdir -p "$emptied_home"
[ ! -e "$consumer/skills/northstar" ]
[ ! -e "$consumer/template-bundle" ]
bun run "$runtime_tool" check --hooks "$consumer/.paseo/hooks" >/dev/null
CURRENT_REPO="$consumer"
read_facts "$(fixture_facts "$consumer" 006)"
write_event "$scratch/closeout-starter.json" "evt-closeout-starter-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
starter_out=$(cd "$consumer" && env -i HOME="$emptied_home" PATH="$PATH" TMPDIR="${TMPDIR:-/tmp}" \
  PASEO_QUEUE_EVENT_ID="evt-closeout-starter-0001" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
  ".paseo/hooks/northstar-lifecycle" < "$scratch/closeout-starter.json")
expect_outcome "$starter_out" ok "starter copy-only closeout"
[ "$(json_field "$starter_out" "r.metadata.handoff_consumed")" = "true" ]
[ "$(json_field "$starter_out" "r.changedPaths.includes('docs/roadmaps/README.md')")" = "true" ]
[ "$(json_field "$starter_out" "r.changedPaths.includes('docs/README.md')")" = "true" ]
grep -q "| g03 | open | planning_required |" "$consumer/docs/README.md"
[ ! -e "$consumer/docs/handoffs/handoff-006.md" ]
[ -f "$consumer/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "copy-only starter consumer: OK"

echo "# block and cancel mappings"
repoD="$scratch/repo-block"
build_fixture "$repoD"
CURRENT_REPO="$repoD"
read_facts "$(fixture_facts "$repoD" 006)"

# Drive 006 to active/implementation through the standalone adapter first.
driver="$scratch/standalone-replay.ts"
cat > "$driver" <<'EOF'
// Standalone replay driver: applies the canonical envelope sequence with
// facts equivalent to the hook's, through the standalone adapter.
const { applyEnvelope } = await import(process.argv[2]!);
import * as fs from "node:fs";

const repo = process.argv[3]!;
const spec = JSON.parse(fs.readFileSync(process.argv[4]!, "utf8"));
const occurredAt = spec.occurred_at;
const recordFile = repo + "/.northstar/lifecycle/v1/tasks/" + spec.task_id + ".json";
const readCurrent = (): Record<string, unknown> | null =>
  fs.existsSync(recordFile) ? JSON.parse(fs.readFileSync(recordFile, "utf8")) : null;

let seq = 0;
const step = (transition: string, extra: Record<string, unknown> = {}) => {
  seq += 1;
  const current = readCurrent();
  const envelope = {
    schema_version: "northstar.lifecycle.transition.v1",
    event_id: "standalone-" + spec.event_id + "-" + String(seq).padStart(2, "0") + "-" + transition,
    task_id: spec.task_id,
    task_path: spec.task_path,
    generation: "g03",
    expected: current === null ? { revision: 0, digest: null } : { revision: Number(current.revision), digest: String(current.digest) },
    transition,
    event_time: occurredAt,
    actor: "standalone-integrator",
    source: { adapter: "standalone" },
    planning: { commit: spec.planning_commit, task_blob_digest: spec.planning_blob_digest },
    ...extra,
  };
  const result = applyEnvelope({ repoRoot: repo, envelope, branch: "main", targets: spec.targets });
  if (result.status !== "applied") throw new Error("standalone replay step failed: " + JSON.stringify(result));
};

for (const transition of spec.transitions as string[]) {
  if (transition === "complete") step("complete", { evidence: spec.evidence });
  else if (transition.startsWith("advance:")) {
    const target = transition.slice("advance:".length);
    const stageEvidence: Record<string, unknown> = {};
    if (target === "review") stageEvidence.evidence = { pr: spec.evidence.pr };
    if (target === "merge") stageEvidence.evidence = { merge: spec.evidence.merge, review: spec.evidence.review };
    if (target === "closeout") stageEvidence.evidence = { merge: spec.evidence.merge };
    step("advance_stage", { target_stage: target, ...stageEvidence });
  } else step(transition);
}
console.log("standalone replay applied " + String(seq) + " envelopes for " + spec.task_id);
EOF

# Hook-equivalent evidence, built independently for the standalone adapter.
make_evidence_spec() { # <event-id> <task-number> <occurred-at>
  local event_id=$1 number=$2 occurred=$3
  cat > "$scratch/spec-$event_id.json" <<EOF
{
  "event_id": "$event_id",
  "task_id": "g03.$number",
  "task_path": "docs/roadmaps/g03/$number-fixture-task.md",
  "planning_commit": "$PC",
  "planning_blob_digest": "$(git -C "$CURRENT_REPO" show "main:docs/roadmaps/g03/$number-fixture-task.md" >/dev/null; git -C "$CURRENT_REPO" cat-file blob "$PC:docs/roadmaps/g03/$number-fixture-task.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')",
  "occurred_at": "$occurred",
  "targets": ["docs/README.md", "docs/roadmaps/README.md"],
  "transitions": ["plan", "ready", "start"],
  "evidence": {}
}
EOF
}

make_evidence_spec "block-prep-006" 006 "2026-09-12T20:00:00.000Z"
bun run "$driver" "$installed/scripts/lifecycle-core.ts" "$repoD" "$scratch/spec-block-prep-006.json" >/dev/null

write_event "$scratch/blocked.json" "evt-blocked-0001" "task.blocked" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" \
  '{"prUrl":null,"prNumber":null,"head":null,"review":null,"mergeCommit":null,"integrationCommit":null,"summary":"worker reported upstream blocker"}'
blocked=$(run_hook "$scratch/blocked.json" "evt-blocked-0001")
expect_outcome "$blocked" ok "blocked mapping"
[ "$(json_field "$blocked" "r.commitSubjectSuffix")" = "g03.006 blocked" ]
grep -q '"status":"blocked"' "$repoD/.northstar/lifecycle/v1/tasks/g03.006.json"
blocked_again=$(run_hook "$scratch/blocked.json" "evt-blocked-0001")
[ "$(json_field "$blocked_again" "r.metadata.skipped")" = "already_blocked" ]

write_event "$scratch/cancel-007.json" "evt-cancel-007-0001" "task.cancelled" "lifecycle-state" "$MC" \
  "q-007" '"Implement g03.007 fixture task"' \
  "docs/handoffs/handoff-007.md" \
  "$(git -C "$repoD" log -1 --format=%H -- docs/handoffs/handoff-007.md)" \
  "$(git -C "$repoD" show "main:docs/handoffs/handoff-007.md" | sha256sum | cut -d' ' -f1)"
cancelled=$(run_hook "$scratch/cancel-007.json" "evt-cancel-007-0001")
expect_outcome "$cancelled" ok "cancel without record"
[ "$(json_field "$cancelled" "r.metadata.skipped")" = "no_record" ]

write_event "$scratch/blocked-terminal.json" "evt-blocked-term-0001" "task.blocked" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
run_hook "$scratch/blocked-terminal.json" "evt-blocked-term-0001" >/dev/null
echo "block and cancel mappings: OK"

echo "# terminal equivalence across adapters in both task orders"
# All clones share one commit universe, so evidence SHAs are identical and the
# portable digests are directly comparable. Four clones cover: standalone in
# both orders, hook in both orders, and standalone-vs-hook equivalence.
full_transitions='["plan", "ready", "start", "advance:implementation", "advance:review", "advance:merge", "advance:closeout", "complete"]'

evidence_json() { # <instruction-path> <head> <merge>
  printf '{
    "pr": {"level": "adapter_attested", "source": "queue", "actor": "queue", "method": "delivery_object", "recorded_at": "2026-09-12T21:30:00.000Z", "head_commit": "%s", "pr_number": 51, "provider_ref": "https://github.com/example/repo/pull/51"},
    "review": {"level": "adapter_attested", "source": "queue", "actor": "queue", "method": "delivery_object", "recorded_at": "2026-09-12T21:30:00.000Z", "verdict": "approved", "head_commit": "%s", "review_id": "approved at head"},
    "merge": {"level": "locally_verified", "source": "git", "actor": "queue-hook", "method": "merge_ancestry", "recorded_at": "2026-09-12T21:30:00.000Z", "merge_commit": "%s", "head_commit": "%s", "base": "main", "merge_method": "merge"},
    "integration": {"level": "locally_verified", "source": "git", "actor": "queue-hook", "method": "synchronized_main", "recorded_at": "2026-09-12T21:30:00.000Z", "synchronized_main_commit": "%s"},
    "validation": {"level": "adapter_attested", "source": "queue", "actor": "queue", "method": "verification_summary", "recorded_at": "2026-09-12T21:30:00.000Z", "passed": true, "head_commit": "%s"},
    "handoff": {"level": "locally_verified", "source": "docs", "actor": "queue-hook", "method": "instruction_blob_digest", "recorded_at": "2026-09-12T21:30:00.000Z", "ref": "%s"}
  }' "$2" "$2" "$3" "$2" "$3" "$2" "$1"
}

standalone_full() { # <repo> <task-number> <event-id>
  local repo=$1 number=$2 event_id=$3
  local pc digest
  pc=$(git -C "$repo" log -1 --format=%H -- "docs/roadmaps/g03/$number-fixture-task.md")
  digest=$(git -C "$repo" cat-file blob "$pc:docs/roadmaps/g03/$number-fixture-task.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')
  cat > "$scratch/spec-$event_id.json" <<EOF
{
  "event_id": "$event_id",
  "task_id": "g03.$number",
  "task_path": "docs/roadmaps/g03/$number-fixture-task.md",
  "planning_commit": "$pc",
  "planning_blob_digest": "$digest",
  "occurred_at": "2026-09-12T21:30:00.000Z",
  "targets": ["docs/README.md", "docs/roadmaps/README.md"],
  "transitions": $full_transitions,
  "evidence": $(evidence_json "docs/handoffs/handoff-$number.md" "$(git -C "$base_repo" rev-parse feature)" "$(git -C "$base_repo" rev-parse main)")
}
EOF
  bun run "$driver" "$installed/scripts/lifecycle-core.ts" "$repo" "$scratch/spec-$event_id.json" >/dev/null
}

hook_full() { # <repo> <task-number>
  local repo=$1 number=$2
  local ic id mc
  ic=$(git -C "$repo" log -1 --format=%H -- "docs/handoffs/handoff-$number.md")
  id=$(git -C "$repo" show "main:docs/handoffs/handoff-$number.md" | sha256sum | cut -d' ' -f1)
  mc=$(git -C "$repo" rev-parse main)
  write_event "$scratch/closeout-$number.json" "evt-closeout-$number-0001" "task.closeout" "lifecycle-state" "$mc" \
    "q-$number" "\"Implement g03.$number fixture task\"" \
    "docs/handoffs/handoff-$number.md" "$ic" "$id" "$(closeout_delivery "$(git -C "$base_repo" rev-parse feature)" "$mc")"
  expect_outcome "$(run_hook "$scratch/closeout-$number.json" "evt-closeout-$number-0001")" ok "hook closeout g03.$number"
}

base_repo="$scratch/repo-base"
build_fixture "$base_repo"
clone_of() { git clone -q "$base_repo" "$1"; }
clone_of "$scratch/clone-standalone-a"
clone_of "$scratch/clone-standalone-b"
clone_of "$scratch/clone-hook-a"
clone_of "$scratch/clone-hook-b"

CURRENT_REPO="$scratch/clone-standalone-a"
standalone_full "$CURRENT_REPO" 006 "sa-006"
standalone_full "$CURRENT_REPO" 007 "sa-007"

CURRENT_REPO="$scratch/clone-standalone-b"
standalone_full "$CURRENT_REPO" 007 "sb-007"
standalone_full "$CURRENT_REPO" 006 "sb-006"

CURRENT_REPO="$scratch/clone-hook-a"
hook_full "$CURRENT_REPO" 006
hook_full "$CURRENT_REPO" 007

CURRENT_REPO="$scratch/clone-hook-b"
hook_full "$CURRENT_REPO" 007
hook_full "$CURRENT_REPO" 006

digest_of() { # <repo> <task-number> -> portable digest
  bun -e '
    const fs = await import("node:fs");
    const record = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    process.stdout.write(String(record.portable_digest));
  ' "$1/.northstar/lifecycle/v1/tasks/g03.$2.json"
}

for number in 006 007; do
  s_a=$(digest_of "$scratch/clone-standalone-a" "$number")
  s_b=$(digest_of "$scratch/clone-standalone-b" "$number")
  h_a=$(digest_of "$scratch/clone-hook-a" "$number")
  h_b=$(digest_of "$scratch/clone-hook-b" "$number")
  if [ -z "$s_a" ] || [ -z "$h_a" ]; then
    echo "terminal equivalence: missing terminal record for g03.$number" >&2
    exit 1
  fi
  if [ "$s_a" != "$s_b" ] || [ "$h_a" != "$h_b" ]; then
    echo "task-order independence failed for g03.$number" >&2
    exit 1
  fi
  if [ "$s_a" != "$h_a" ]; then
    echo "adapter equivalence failed for g03.$number: standalone $s_a vs hook $h_a" >&2
    exit 1
  fi
  echo "g03.$number portable digest $s_a"
done
echo "terminal equivalence in both task orders: OK"

echo "lifecycle-adoption self-test: OK"
