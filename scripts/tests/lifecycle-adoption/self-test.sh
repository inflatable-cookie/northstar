#!/usr/bin/env bash
# Focused proof for the Effigy-hosted lifecycle hook (g03.010) and the
# portable lifecycle adoption surface it supersedes.
#
# 1. Runs the lifecycle core oracle and proves exact source/install parity.
# 2. Proves the skill catalog exposes `northstar/queue:hook` and that every
#    skill-owned script is `{skill}`-anchored, so invocation cwd never makes a
#    consumer repository resolve skill code.
# 3. Proves raw stdio transport: the frozen argv yields exactly one hook-result
#    object on stdout, diagnostics stay on stderr, and task exit status passes
#    through.
# 4. Proves the shipped v1, v2, v3, and v4 control-manifest grammars: valid
#    documents validate, program unions refuse mixing, the v3 target rules
#    refuse a wrong or missing target, and no host path or fallback executable
#    can enter a trusted-runner manifest.
# 4b. Proves the bounded v3-to-v4 Queue manifest migration through the
#    installed skill route: dry-run writes nothing, write mode changes only
#    .paseo/queue.json, the result validates against the frozen v4 grammar,
#    replay is a no-op, and dirty, symlinked, older, custom, and ambiguous
#    inputs refuse before any byte changes.
# 5. Runs the hook adapter against real fixture repositories through the real
#    Effigy route: pre-dispatch gate, the read-only reviewed-head pre-merge gate
#    (clean pass, durable-backlink refusal, and byte identity with the closeout
#    refusal from one shared resolver), the read-only prospective-merge gate
#    (clean pass, candidate identity proofs, schema/target correlation, binding
#    rules, and the same shared backlink refusal), hostile events, read-only binding,
#    escape refusal, squash refusal, bootstrap closeout, idempotent replay,
#    durable-backlink refusal with relative/rooted/fragment/titled/reference-style/large-file/indented/escaped/list-continuation/non-1-ordered/fenced/inline/external/mismatch
#    controls, the sole-source currentness cutover (the audit rejects
#    Silo-shaped task headers, front-door frontiers, and Next-task columns
#    while the cutover shape and retrospective history pass), block/cancel
#    mapping, terminal equivalence, closure-gated compaction, and closeout
#    catch-up consumption of eligible historical closed generations.
#    Every result is produced by the installed skill bytes reached through
#    `effigy skill run northstar/queue:hook --stdio passthrough`.
# 6. Proves resolution precedence and fail-closed behavior: project-local wins
#    over a hostile global install, a unique global install is the fallback,
#    an ambiguous global install fails, a missing skill fails, and a missing
#    runner fails before any repository effect.
# 7. Proves the copy-ready starter is configuration-only: a consumer built
#    from `template-bundle/lifecycle/` runs the closeout through the same
#    route with no copied Northstar code.
# 8. Proves no repository runtime remains anywhere in the live surfaces.

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
dogfood_manifest="$repo_root/.paseo/queue.json"
starter_manifest="$repo_root/template-bundle/lifecycle/queue.json"
EVENT_SCHEMA="paseo.queue.event.v1"
EVENT_SCHEMA_V2="paseo.queue.event.v2"
EVENT_SCHEMA_V3="paseo.queue.event.v3"
FROZEN_ARGV=(skill run northstar/queue:hook --stdio passthrough)
CURRENT_REPO=""

installed_home="$scratch/home"
installed="$installed_home/.agents/skills/northstar"
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

echo "# one import-safe resolver serves both gates"
bun -e '
  const fs = await import("node:fs");
  const hook = fs.readFileSync(process.argv[1], "utf8");
  const shared = fs.readFileSync(process.argv[2], "utf8");
  const fail = (message) => { console.error(message); process.exit(1); };
  if (!hook.includes("from \"./lifecycle-backlink.ts\"")) fail("hook does not import the shared backlink module");
  if (!hook.includes("guardHandoffBacklinks")) fail("hook does not call the shared guard");
  if (/BACKLINK_SCAN_MAX|MARKDOWN_LINK_RE|REFERENCE_DEF_RE|AUTOLINK_RE/.test(hook)) fail("hook still carries a second backlink parser or its bounds");
  if (!hook.includes("convergeStatusMarkers")) fail("hook does not converge markers through the shared core rule");
  if (/\^Status:/.test(hook)) fail("hook carries a second Status marker rule");
  if (!/export function findHandoffBacklinks/.test(shared)) fail("shared module does not export the resolver");
  if (!/export function guardHandoffBacklinks/.test(shared)) fail("shared module does not export the guard");
  const imports = shared.match(/^import .*$/gm) ?? [];
  for (const line of imports) {
    if (!/(node:child_process|node:fs|node:path|\.\/lifecycle-core\.ts)/.test(line)) fail("shared module imports an unexpected surface: " + line);
  }
' "$hook" "$source_skill/scripts/lifecycle-backlink.ts"
echo "single shared resolver with no second parser or bounds: OK"

echo "# one manifest parser serves the hook and the migration"
bun -e '
  const fs = await import("node:fs");
  const hook = fs.readFileSync(process.argv[1], "utf8");
  const migration = fs.readFileSync(process.argv[2], "utf8");
  const shared = fs.readFileSync(process.argv[3], "utf8");
  const fail = (message) => { console.error(message); process.exit(1); };
  for (const [name, text] of [["hook", hook], ["migration", migration]]) {
    if (!text.includes("from \"./lifecycle-manifest.ts\"")) fail(name + " does not import the shared manifest module");
  }
  if (!/export function loadControlManifest/.test(shared)) fail("shared manifest module does not export the strict loader");
  if (!/export function parseControlManifest/.test(shared)) fail("shared manifest module does not export the strict parser");
  if (/CONTROL_SCHEMAS|MANIFEST_MAX_BYTES|control manifest declares unsupported schema/.test(hook)) fail("hook still carries a second manifest parser or its bounds");
' "$hook" "$source_skill/scripts/lifecycle-queue-migration.ts" "$source_skill/scripts/lifecycle-manifest.ts"
echo "one shared manifest parser with no second copy: OK"

echo "# skill catalog exposes the hook and migration routes with skill-anchored scripts"
catalog=$(effigy skill tasks --path "$source_skill" 2>&1)
printf '%s\n' "$catalog" | grep -q "northstar/queue:hook"
printf '%s\n' "$catalog" | grep -q "northstar/lifecycle:migrate-premerge"
grep -q '"queue:hook" = "bun run {skill}/scripts/lifecycle-queue-hook.ts"' "$source_skill/effigy.toml"
for task in lifecycle:run lifecycle:oracle lifecycle:migrate-premerge language:route; do
  grep -q "\"$task\" = \"bun run {skill}/scripts/" "$source_skill/effigy.toml"
done
if grep -qE '"[a-z:]+" = "bun run scripts/' "$source_skill/effigy.toml"; then
  echo "skill catalog still carries an invocation-relative scripts/ command" >&2
  exit 1
fi
# The anchor is load-bearing: a relative command would resolve skill code
# against the consumer repository, which has no scripts/ directory.
resolution=$(cd "$repo_root" && effigy skill run --path "$source_skill" northstar/lifecycle:oracle --json 2>&1)
printf '%s\n' "$resolution" | grep -q 'northstar/lifecycle:oracle'
# The rendered command must carry the resolved skill source root, proving the
# {skill} anchor replaced the invocation-relative path (Effigy shell-quotes
# the root, so the separator is matched loosely).
printf '%s\n' "$resolution" | grep -q "$source_skill./scripts/lifecycle-core.ts oracle"
echo "skill catalog resolution: OK"

# ---------------------------------------------------------------------------
# Manifest and event mirrors: v1/v2/v3 grammars, target rules, negatives
# ---------------------------------------------------------------------------
schema_check() { # <schema> <instance>
  bun run "$core" schema-check --schema "$1" --instance "$2" >/dev/null
}

cat > "$scratch/plain-v1-manifest.json" <<'EOF'
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
schema_check "$source_skill/references/lifecycle/queue-control.schema.json" "$scratch/plain-v1-manifest.json"

cat > "$scratch/plain-v2-manifest.json" <<'EOF'
{
  "schema": "paseo.queue.control.v2",
  "hooks": [
    {
      "id": "json-ledger",
      "events": ["task.closeout"],
      "mode": "integration_write",
      "delivery": "required",
      "program": { "kind": "repository", "executable": "hooks/append-ledger" },
      "timeoutMs": 5000,
      "maxOutputBytes": 4096,
      "allowedPaths": ["ledger/"],
      "commitSubject": { "prefix": "ledger", "maxBytes": 60 }
    }
  ]
}
EOF
schema_check "$source_skill/references/lifecycle/queue-control-v2.schema.json" "$scratch/plain-v2-manifest.json"

cat > "$scratch/plain-v3-manifest.json" <<'EOF'
{
  "schema": "paseo.queue.control.v3",
  "hooks": [
    {
      "id": "json-ledger",
      "events": ["task.closeout"],
      "mode": "integration_write",
      "delivery": "required",
      "target": "integration_base",
      "program": { "kind": "repository", "executable": "hooks/append-ledger" },
      "timeoutMs": 5000,
      "maxOutputBytes": 4096,
      "allowedPaths": ["ledger/"],
      "commitSubject": { "prefix": "ledger", "maxBytes": 60 }
    }
  ]
}
EOF
schema_check "$source_skill/references/lifecycle/queue-control-v3.schema.json" "$scratch/plain-v3-manifest.json"

echo "# manifest grammar stays document-system agnostic"
schema_check "$source_skill/references/lifecycle/queue-control-v4.schema.json" "$dogfood_manifest"
schema_check "$source_skill/references/lifecycle/queue-control-v4.schema.json" "$starter_manifest"
for manifest in "$dogfood_manifest" "$starter_manifest"; do
  bun -e '
    const fs = await import("node:fs");
    const file = process.argv[1];
    const manifest = JSON.parse(fs.readFileSync(file, "utf8"));
    const fail = (message) => { console.error(file + ": " + message); process.exit(1); };
    if (manifest.schema !== "paseo.queue.control.v4") fail("manifest is not v4");
    const premerge = manifest.hooks.find((hook) => hook.id === "repository-pre-merge");
    if (!premerge) fail("manifest declares no repository-pre-merge hook");
    if (premerge.events.length !== 1 || premerge.events[0] !== "task.pre_merge") fail("pre-merge hook does not bind exactly task.pre_merge");
    if (premerge.mode !== "read_only") fail("pre-merge hook is not read_only");
    if (premerge.delivery !== "required") fail("pre-merge delivery is not required");
    if (premerge.target !== "prospective_merge") fail("pre-merge hook does not target the prospective merge");
    if (premerge.allowedPaths.length !== 0 || premerge.commitSubject !== null) fail("pre-merge hook declares write authority");
    for (const hook of manifest.hooks) {
      if (hook.id === "repository-pre-merge") continue;
      if (hook.target !== "integration_base") fail(hook.id + " does not target the integration base");
    }
  ' "$manifest"
done

# Pre-g01.020 manifests stay byte-shaped and valid: derive the v2 document, a
# v3 document without the pre-merge binding, and the legacy v3 reviewed-head
# binding from the live v4 manifest.
bun -e '
  const fs = await import("node:fs");
  const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  const v2 = JSON.parse(JSON.stringify(manifest));
  v2.schema = "paseo.queue.control.v2";
  v2.hooks = v2.hooks.filter((hook) => !hook.events.includes("task.pre_merge")).map(({ target, ...rest }) => rest);
  fs.writeFileSync(process.argv[2], JSON.stringify(v2, null, 2) + "\n");
  const v3 = JSON.parse(JSON.stringify(manifest));
  v3.schema = "paseo.queue.control.v3";
  v3.hooks = v3.hooks.filter((hook) => !hook.events.includes("task.pre_merge"));
  fs.writeFileSync(process.argv[3], JSON.stringify(v3, null, 2) + "\n");
  const legacy = JSON.parse(JSON.stringify(manifest));
  legacy.schema = "paseo.queue.control.v3";
  legacy.hooks.find((hook) => hook.id === "repository-pre-merge").target = "reviewed_head";
  fs.writeFileSync(process.argv[4], JSON.stringify(legacy, null, 2) + "\n");
' "$dogfood_manifest" "$scratch/derived-v2-manifest.json" "$scratch/derived-v3-no-premerge.json" "$scratch/derived-v3-premerge.json"
schema_check "$source_skill/references/lifecycle/queue-control-v2.schema.json" "$scratch/derived-v2-manifest.json"
schema_check "$source_skill/references/lifecycle/queue-control-v3.schema.json" "$scratch/derived-v3-no-premerge.json"
schema_check "$source_skill/references/lifecycle/queue-control-v3.schema.json" "$scratch/derived-v3-premerge.json"

# A v2 manifest is closed: the v3 target field has no meaning there.
expect_schema_reject() { # <schema-file> <instance-json-string> <label>
  printf '%s' "$2" > "$scratch/negative-manifest.json"
  if schema_check "$1" "$scratch/negative-manifest.json" 2>/dev/null; then
    echo "grammar accepted an invalid manifest: $3" >&2
    exit 1
  fi
}

V1_MIRROR="$source_skill/references/lifecycle/queue-control.schema.json"
V2_MIRROR="$source_skill/references/lifecycle/queue-control-v2.schema.json"
V3_MIRROR="$source_skill/references/lifecycle/queue-control-v3.schema.json"
V4_MIRROR="$source_skill/references/lifecycle/queue-control-v4.schema.json"
V3_EVENT_MIRROR="$source_skill/references/lifecycle/queue-event-v3.schema.json"
# A v2 hook may not mix program variants or keep the retired v1 pair.
expect_schema_reject "$V2_MIRROR" '{"schema":"paseo.queue.control.v2","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","program":{"kind":"trusted_runner","runner":"effigy","argv":["x"]},"executable":"hooks/legacy","timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "program plus retired executable"
expect_schema_reject "$V2_MIRROR" '{"schema":"paseo.queue.control.v2","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","program":{"kind":"trusted_runner","runner":"effigy","executable":"hooks/legacy"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "mixed program fields"
# A repository cannot authorize host code: no absolute runner path, no digest,
# no version, no environment, no installation hint.
expect_schema_reject "$V2_MIRROR" '{"schema":"paseo.queue.control.v2","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","program":{"kind":"trusted_runner","runner":"/usr/local/bin/effigy","argv":[]},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "runner id carries a host path"
expect_schema_reject "$V2_MIRROR" '{"schema":"paseo.queue.control.v2","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","program":{"kind":"trusted_runner","runner":"effigy","argv":[],"digest":"sha256:0000000000000000000000000000000000000000000000000000000000000000"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "program carries a digest"
expect_schema_reject "$V2_MIRROR" '{"schema":"paseo.queue.control.v2","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","program":{"kind":"trusted_runner","runner":"effigy","argv":[],"version":"1.2.3"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "program carries a version"
expect_schema_reject "$V2_MIRROR" '{"schema":"paseo.queue.control.v2","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","target":"integration_base","program":{"kind":"repository","executable":"hooks/x"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "v2 hook carries the v3 target field"
# A v3 hook must declare one target, and the closed set is two values.
expect_schema_reject "$V3_MIRROR" '{"schema":"paseo.queue.control.v3","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","program":{"kind":"repository","executable":"hooks/x"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "v3 hook omits target"
expect_schema_reject "$V3_MIRROR" '{"schema":"paseo.queue.control.v3","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","target":"reviewed-head","program":{"kind":"repository","executable":"hooks/x"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "v3 hook invents a target"
expect_schema_reject "$V3_MIRROR" '{"schema":"paseo.queue.control.v3","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","target":"integration_base","executable":"hooks/legacy","timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "v3 hook keeps the retired executable pair"

# Frozen event mirrors: v1 stays exact, v2 adds the closed repository target.
V1_EVENT_MIRROR="$source_skill/references/lifecycle/queue-event.schema.json"
V2_EVENT_MIRROR="$source_skill/references/lifecycle/queue-event-v2.schema.json"
cat > "$scratch/plain-v1-event.json" <<'EOF'
{
  "schema": "paseo.queue.event.v1",
  "eventId": "evt-mirror-v1",
  "hookId": "lifecycle-state",
  "event": "task.closeout",
  "occurredAt": "2026-09-15T08:00:00.000Z",
  "attempt": 1,
  "repository": { "root": "/tmp/example", "baseBranch": "main", "baseCommit": "1111111111111111111111111111111111111111" },
  "task": { "id": "q", "title": "", "phase": "", "instruction": null },
  "delivery": { "prUrl": null, "prNumber": null, "head": null, "review": null, "mergeCommit": null, "integrationCommit": null, "summary": "" }
}
EOF
schema_check "$V1_EVENT_MIRROR" "$scratch/plain-v1-event.json"
cat > "$scratch/plain-v2-event.json" <<'EOF'
{
  "schema": "paseo.queue.event.v2",
  "eventId": "evt-mirror-v2",
  "hookId": "repository-pre-merge",
  "event": "task.pre_merge",
  "occurredAt": "2026-09-15T08:00:00.000Z",
  "attempt": 1,
  "repository": { "root": "/tmp/example", "baseBranch": "main", "baseCommit": "1111111111111111111111111111111111111111", "target": "reviewed_head" },
  "task": { "id": "q", "title": "", "phase": "", "instruction": null },
  "delivery": { "prUrl": null, "prNumber": null, "head": null, "review": null, "mergeCommit": null, "integrationCommit": null, "summary": "" }
}
EOF
schema_check "$V2_EVENT_MIRROR" "$scratch/plain-v2-event.json"
expect_schema_reject "$V2_EVENT_MIRROR" '{"schema":"paseo.queue.event.v2","eventId":"e","hookId":"h","event":"task.pre_merge","occurredAt":"2026-09-15T08:00:00.000Z","attempt":1,"repository":{"root":"/tmp/example","baseBranch":"main","baseCommit":"1111111111111111111111111111111111111111"},"task":{"id":"q","title":"","phase":"","instruction":null},"delivery":{"prUrl":null,"prNumber":null,"head":null,"review":null,"mergeCommit":null,"integrationCommit":null,"summary":""}}' "v2 event omits the repository target"
expect_schema_reject "$V1_EVENT_MIRROR" '{"schema":"paseo.queue.event.v1","eventId":"e","hookId":"h","event":"task.closeout","occurredAt":"2026-09-15T08:00:00.000Z","attempt":1,"repository":{"root":"/tmp/example","baseBranch":"main","baseCommit":"1111111111111111111111111111111111111111","target":"integration_base"},"task":{"id":"q","title":"","phase":"","instruction":null},"delivery":{"prUrl":null,"prNumber":null,"head":null,"review":null,"mergeCommit":null,"integrationCommit":null,"summary":""}}' "v1 event carries the v2 repository target"

# Frozen prospective-merge mirrors: v4 adds the closed prospective_merge hook
# target to the v3 grammar, and v3 carries the closed mergeCandidate for
# task.pre_merge at that target only.
cat > "$scratch/plain-v4-manifest.json" <<'EOF'
{
  "schema": "paseo.queue.control.v4",
  "hooks": [
    {
      "id": "candidate-pre-merge",
      "events": ["task.pre_merge"],
      "mode": "read_only",
      "delivery": "required",
      "target": "prospective_merge",
      "program": { "kind": "trusted_runner", "runner": "effigy", "argv": ["skill", "run", "northstar/queue:hook", "--stdio", "passthrough"] },
      "timeoutMs": 30000,
      "maxOutputBytes": 65536,
      "allowedPaths": [],
      "commitSubject": null
    }
  ]
}
EOF
schema_check "$V4_MIRROR" "$scratch/plain-v4-manifest.json"
cat > "$scratch/plain-v3-event.json" <<'EOF'
{
  "schema": "paseo.queue.event.v3",
  "eventId": "evt-mirror-v3",
  "hookId": "candidate-pre-merge",
  "event": "task.pre_merge",
  "occurredAt": "2026-09-15T08:00:00.000Z",
  "attempt": 1,
  "repository": { "root": "/tmp/example", "baseBranch": "main", "baseCommit": "1111111111111111111111111111111111111111", "target": "prospective_merge", "mergeCandidate": { "integrationBase": "1111111111111111111111111111111111111111", "reviewedHead": "2222222222222222222222222222222222222222", "commit": "3333333333333333333333333333333333333333", "tree": "4444444444444444444444444444444444444444" } },
  "task": { "id": "q", "title": "", "phase": "", "instruction": null },
  "delivery": { "prUrl": null, "prNumber": null, "head": null, "review": null, "mergeCommit": null, "integrationCommit": null, "summary": "" }
}
EOF
schema_check "$V3_EVENT_MIRROR" "$scratch/plain-v3-event.json"
# A v3 manifest cannot select the prospective target; only v4 declares it.
expect_schema_reject "$V3_MIRROR" '{"schema":"paseo.queue.control.v3","hooks":[{"id":"h","events":["task.pre_merge"],"mode":"read_only","delivery":"required","target":"prospective_merge","program":{"kind":"repository","executable":"hooks/x"},"timeoutMs":5000,"maxOutputBytes":4096}]}' "v3 hook selects prospective_merge"
# A v4 hook still declares exactly one closed target.
expect_schema_reject "$V4_MIRROR" '{"schema":"paseo.queue.control.v4","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","program":{"kind":"repository","executable":"hooks/x"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "v4 hook omits target"
expect_schema_reject "$V4_MIRROR" '{"schema":"paseo.queue.control.v4","hooks":[{"id":"h","events":["task.closeout"],"mode":"integration_write","delivery":"required","target":"candidate","program":{"kind":"repository","executable":"hooks/x"},"timeoutMs":5000,"maxOutputBytes":4096,"commitSubject":{"prefix":"l","maxBytes":40}}]}' "v4 hook invents a target"
# A v3 event exists only for task.pre_merge at prospective_merge with the
# full closed candidate: any other event, target, or candidate shape is out.
V3_BASE='{"schema":"paseo.queue.event.v3","eventId":"e","hookId":"h","event":"task.pre_merge","occurredAt":"2026-09-15T08:00:00.000Z","attempt":1,"repository":{"root":"/tmp/example","baseBranch":"main","baseCommit":"1111111111111111111111111111111111111111","target":"prospective_merge","mergeCandidate":{"integrationBase":"1111111111111111111111111111111111111111","reviewedHead":"2222222222222222222222222222222222222222","commit":"3333333333333333333333333333333333333333","tree":"4444444444444444444444444444444444444444"}},"task":{"id":"q","title":"","phase":"","instruction":null},"delivery":{"prUrl":null,"prNumber":null,"head":null,"review":null,"mergeCommit":null,"integrationCommit":null,"summary":""}}'
expect_schema_reject "$V3_EVENT_MIRROR" "${V3_BASE/task.pre_merge/task.closeout}" "v3 event on another event"
expect_schema_reject "$V3_EVENT_MIRROR" "${V3_BASE/prospective_merge/reviewed_head}" "v3 event at the reviewed head"
expect_schema_reject "$V3_EVENT_MIRROR" '{"schema":"paseo.queue.event.v3","eventId":"e","hookId":"h","event":"task.pre_merge","occurredAt":"2026-09-15T08:00:00.000Z","attempt":1,"repository":{"root":"/tmp/example","baseBranch":"main","baseCommit":"1111111111111111111111111111111111111111","target":"prospective_merge"},"task":{"id":"q","title":"","phase":"","instruction":null},"delivery":{"prUrl":null,"prNumber":null,"head":null,"review":null,"mergeCommit":null,"integrationCommit":null,"summary":""}}' "v3 event omits the merge candidate"
V3_SHORT_candidate=$(printf '%s' "$V3_BASE" | sed 's/"commit":"3333333333333333333333333333333333333333"/"commit":"3333333"/')
expect_schema_reject "$V3_EVENT_MIRROR" "$V3_SHORT_candidate" "v3 candidate carries a short commit"
V3_LONG_candidate=$(printf '%s' "$V3_BASE" | sed 's/"tree":"4444444444444444444444444444444444444444"/"tree":"4444444444444444444444444444444444444444444444444444444444444444"/')
expect_schema_reject "$V3_EVENT_MIRROR" "$V3_LONG_candidate" "v3 candidate carries a 64-hex tree"
V3_EXTRA_candidate=$(printf '%s' "$V3_BASE" | sed 's/"tree":"4444444444444444444444444444444444444444"/"tree":"4444444444444444444444444444444444444444","base":"1111111111111111111111111111111111111111"/')
expect_schema_reject "$V3_EVENT_MIRROR" "$V3_EXTRA_candidate" "v3 candidate carries an extra field"
echo "v4/v3 prospective-merge grammar: OK"

# The dogfood and starter manifests name only a runner ID and literal argv.
for manifest in "$dogfood_manifest" "$starter_manifest"; do
  if grep -qE '"/|/Users/|/opt/|digest|versionLabel|sourcePath' "$manifest"; then
    echo "manifest $manifest embeds host-resolved data" >&2
    exit 1
  fi
  if grep -q '"executable"' "$manifest"; then
    echo "manifest $manifest still declares a repository executable" >&2
    exit 1
  fi
done
echo "v1/v2/v3/v4 manifest and event grammar: OK"

# Sequential mode stays explicit: the dogfood and copy-ready starter configs
# keep the singular active_generation key and never adopt the plural form.
for config in "$repo_root/.northstar/lifecycle/v1/projection-targets.json" "$repo_root/template-bundle/lifecycle/projection-targets.json"; do
  grep -q '"active_generation"' "$config" || { echo "sequential config $config lost its singular active_generation" >&2; exit 1; }
  if grep -q '"active_generations"' "$config"; then
    echo "sequential starter drift: $config adopted the plural active_generations key" >&2
    exit 1
  fi
done
echo "sequential starter stays singular: OK"

# ---------------------------------------------------------------------------
# Fixture repository: two tasks planned and readied, one committed handoff
# each, a feature branch merged with a merge commit, front doors committed.
# ---------------------------------------------------------------------------
build_fixture() { # <repo-dir> [dogfood|starter] [task-body-file]
  # The optional task-body file replaces the g03.006 task file before its
  # ready commit, so a fixture can carry a pre-terminal marker (or an
  # ambiguous status-looking body) inside the pinned planning blob.
  local repo=$1 surface=${2:-dogfood} body_file=${3:-}
  local queue_from targets_from
  case "$surface" in
    dogfood)
      queue_from="$dogfood_manifest"
      targets_from="$repo_root/.northstar/lifecycle/v1/projection-targets.json"
      ;;
    starter)
      queue_from="$starter_manifest"
      targets_from="$repo_root/template-bundle/lifecycle/projection-targets.json"
      ;;
    *) echo "fixture failure: unknown surface $surface" >&2; exit 1 ;;
  esac
  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.email fixture@example.invalid
  git -C "$repo" config user.name Fixture
  printf '.effigy/\n' > "$repo/.gitignore"
  mkdir -p "$repo/docs/roadmaps/g03" "$repo/docs/handoffs" "$repo/.northstar/lifecycle/v1" "$repo/.paseo"
  for number in 006 007; do
    printf '# Task g03.%s\n\nOwner: fixture\n' "$number" \
      > "$repo/docs/roadmaps/g03/$number-fixture-task.md"
    git -C "$repo" add -A
    git -C "$repo" commit -qm "plan g03.$number"
    printf 'Deployment note: none yet.\n' >> "$repo/docs/roadmaps/g03/$number-fixture-task.md"
    if [ "$number" = 006 ] && [ -n "$body_file" ]; then
      cp "$body_file" "$repo/docs/roadmaps/g03/006-fixture-task.md"
    fi
    git -C "$repo" add -A
    git -C "$repo" commit -qm "ready g03.$number"

    if [ "$number" = 006 ]; then
      cat > "$repo/docs/handoffs/handoff-$number.md" <<EOF
---
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
roadmap: docs/roadmaps/g03/$number-fixture-task.md
---

## Current State

Ready task g03.$number is pinned by the machine-readable roadmap field.
EOF
    else
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
    fi
    git -C "$repo" add -A
    git -C "$repo" commit -qm "handoff for g03.$number"
  done

  printf '# Project\n\nHuman front door stays.\n' > "$repo/docs/README.md"
  printf '# Roadmaps\n\nHuman roadmap stays.\n' > "$repo/docs/roadmaps/README.md"
  mkdir -p "$repo/docs/roadmaps/g03"
  printf '# g03\n\nHuman generation runway stays.\n' > "$repo/docs/roadmaps/g03/README.md"
  cp "$queue_from" "$repo/.paseo/queue.json"
  cp "$targets_from" "$repo/.northstar/lifecycle/v1/projection-targets.json"
  # Adoption edit: the copied config declares its source's own generation
  # (the starter scaffold, or Northstar's current one); this fixture
  # consumer's active generation is g03.
  bun -e '
    const fs = await import("node:fs");
    const file = process.argv[1];
    const config = JSON.parse(fs.readFileSync(file, "utf8"));
    config.active_generation = "g03";
    config.targets = config.targets.map((target) =>
      target.replace(/^docs\/roadmaps\/g[0-9]{2}\/README\.md$/, "docs/roadmaps/g03/README.md"));
    fs.writeFileSync(file, JSON.stringify(config, null, 2) + "\n");
  ' "$repo/.northstar/lifecycle/v1/projection-targets.json"
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

write_premerge_event() { # <file> <event-id> <queue-task> <title-json> <reviewed-head> <instruction-path> <instruction-commit> <instruction-digest-hex>
  local file=$1 eventId=$2 qtask=$3 title=$4 head=$5 ipath=$6 icommit=$7 idigest=$8
  cat > "$file" <<EOF
{
  "schema": "$EVENT_SCHEMA_V2",
  "eventId": "$eventId",
  "hookId": "repository-pre-merge",
  "event": "task.pre_merge",
  "occurredAt": "2026-09-15T08:00:00.000Z",
  "attempt": 1,
  "repository": {"root": "$CURRENT_REPO", "baseBranch": "feature", "baseCommit": "$head", "target": "reviewed_head"},
  "task": {"id": "$qtask", "title": $title, "phase": "review",
    "instruction": {"path": "$ipath", "commit": "$icommit", "digest": "sha256:$idigest", "mediaType": "text/markdown"}},
  "delivery": {"prUrl": "https://github.com/example/repo/pull/53", "prNumber": 53, "head": "$head", "review": "approved at head", "mergeCommit": null, "integrationCommit": null, "summary": "independent review accepted"}
}
EOF
}

write_prospective_event() { # <file> <event-id> <hook-id> <queue-task> <title-json> <base> <integration-base> <reviewed-head> <candidate> <tree> <instruction-path> <instruction-commit> <instruction-digest-hex> [delivery-head]
  local file=$1 eventId=$2 hookId=$3 qtask=$4 title=$5 base=$6 ibase=$7 rhead=$8 candidate=$9 tree=${10} ipath=${11} icommit=${12} idigest=${13}
  local dhead=${14:-$rhead}
  cat > "$file" <<EOF
{
  "schema": "$EVENT_SCHEMA_V3",
  "eventId": "$eventId",
  "hookId": "$hookId",
  "event": "task.pre_merge",
  "occurredAt": "2026-09-15T08:00:00.000Z",
  "attempt": 1,
  "repository": {"root": "$CURRENT_REPO", "baseBranch": "main", "baseCommit": "$base", "target": "prospective_merge",
    "mergeCandidate": {"integrationBase": "$ibase", "reviewedHead": "$rhead", "commit": "$candidate", "tree": "$tree"}},
  "task": {"id": "$qtask", "title": $title, "phase": "review",
    "instruction": {"path": "$ipath", "commit": "$icommit", "digest": "sha256:$idigest", "mediaType": "text/markdown"}},
  "delivery": {"prUrl": "https://github.com/example/repo/pull/53", "prNumber": 53, "head": "$dhead", "review": "approved at head", "mergeCommit": null, "integrationCommit": null, "summary": "independent review accepted"}
}
EOF
}

run_hook() { # <event-file> <event-id> [home-dir]
  # Always execute through the frozen Effigy route: the qualified selector
  # resolves the installed skill, and the consumer repository stays the
  # execution target. Every result in this harness comes from skill bytes.
  # The declared event schema is read from the payload, exactly as Queue's
  # environment variable would carry it.
  local home="${3:-$installed_home}"
  local schema
  schema=$(grep -o '"schema": "[^"]*"' "$1" | head -1 | cut -d'"' -f4)
  (cd "$CURRENT_REPO" && HOME="$home" \
    PASEO_QUEUE_EVENT_ID="$2" PASEO_QUEUE_EVENT_SCHEMA="$schema" \
    effigy "${FROZEN_ARGV[@]}" < "$1")
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

echo "# raw stdio transport carries exactly one result object"
write_event "$scratch/pre.json" "evt-pre-0001" "task.pre_dispatch" "lifecycle-gate" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
stdout_file="$scratch/stdio-stdout"
stderr_file="$scratch/stdio-stderr"
run_hook "$scratch/pre.json" "evt-pre-0001" > "$stdout_file" 2> "$stderr_file"
stdio_exit=$?
[ "$stdio_exit" = "0" ]
[ ! -s "$stderr_file" ]
bun -e '
  const fs = await import("node:fs");
  const text = fs.readFileSync(process.argv[1], "utf8");
  const parsed = JSON.parse(text);
  if (parsed.schema !== "paseo.queue.hook-result.v1" || parsed.eventId !== "evt-pre-0001") {
    console.error("stdout is not the single expected hook result");
    process.exit(1);
  }
  if (!text.trim().startsWith("{") || !text.trim().endsWith("}")) {
    console.error("stdout carries envelope or log framing around the result");
    process.exit(1);
  }
' "$stdout_file"
echo "raw stdio transport: OK"

echo "# pre-dispatch gate verifies identity without writing"
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

printf '%s\n' '{"schema": "paseo.queue.event.v9", "eventId": "x"}' > "$scratch/badschema9.json"
badschema9=$(run_hook "$scratch/badschema9.json" "x")
expect_outcome "$badschema9" failed "unknown event schema"
json_field "$badschema9" "r.summary.includes('unsupported schema')" >/dev/null

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
  manifest.hooks.find((hook) => hook.id === "lifecycle-state").allowedPaths.push(".paseo/queue.json");
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
git -C "$repoA" checkout -q -- .northstar/lifecycle/v1/projection-targets.json
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

echo "# sole-source currentness cutover over the real hook output"
audit_cli=(bun run "$installed/scripts/lifecycle-core.ts" audit-currentness --repo)
# The bootstrap closeout above left the positive shape: a terminal record, a
# task file with no Status header, and front doors with no Next-task pointer.
"${audit_cli[@]}" "$repoA" >/dev/null
echo "positive cutover shape audits clean: OK"

printf '\nStatus: Ready\n' >> "$repoA/docs/roadmaps/g03/006-fixture-task.md"
if "${audit_cli[@]}" "$repoA" > "$scratch/audit-status.out" 2>&1; then
  echo "audit accepted a terminal record beside Status: Ready" >&2
  exit 1
fi
grep -q "duplicate-status-header" "$scratch/audit-status.out"
grep -q "006-fixture-task.md" "$scratch/audit-status.out"
git -C "$repoA" checkout -q -- docs/roadmaps/g03/006-fixture-task.md
echo "stale task header rejected with exact file and reason: OK"

cat >> "$repoA/docs/README.md" <<'EOF'

## Next Task

Continue with `g03.006` now.
EOF
if "${audit_cli[@]}" "$repoA" > "$scratch/audit-frontier.out" 2>&1; then
  echo "audit accepted a Next Task section naming a terminal task" >&2
  exit 1
fi
grep -q "stale-frontier" "$scratch/audit-frontier.out"
git -C "$repoA" checkout -q -- docs/README.md
echo "stale front-door frontier rejected: OK"

cat >> "$repoA/docs/roadmaps/g03/README.md" <<'EOF'

| Goal | State | Next Task |
| --- | --- | --- |
| Parallel projections. | ready as `g03.006` | continue with `g03.006` |
EOF
if "${audit_cli[@]}" "$repoA" > "$scratch/audit-column.out" 2>&1; then
  echo "audit accepted a Next-task column naming a terminal task" >&2
  exit 1
fi
grep -q "stale-next-task-column" "$scratch/audit-column.out"
git -C "$repoA" checkout -q -- docs/roadmaps/g03/README.md
echo "stale Next-task column rejected, goal history untouched: OK"

cat >> "$repoA/docs/README.md" <<'EOF'

## History

Completed `g03.006` in the bootstrap closeout; the generated block below owns currentness.
EOF
"${audit_cli[@]}" "$repoA" >/dev/null
git -C "$repoA" checkout -q -- docs/README.md
"${audit_cli[@]}" "$repoA" >/dev/null
echo "retrospective history stays legal: OK"

echo "# terminal closeout converges the superseded status marker"
# One human body plus one adapter-owned pre-terminal marker, committed before
# the handoff so the pinned planning blob carries the marker bytes. Closeout
# must land the terminal record, projections, handoff deletion and marker
# convergence in one publication and leave the audit clean.
repoM="$scratch/repo-marker"
printf '# Task g03.006\n\nStatus: Ready\nOwner: fixture\nDeployment note: none yet.\n' > "$scratch/body-marker.md"
build_fixture "$repoM" dogfood "$scratch/body-marker.md"
CURRENT_REPO="$repoM"
read_facts "$(fixture_facts "$repoM" 006)"
write_event "$scratch/closeout-marker.json" "evt-closeout-marker-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
marker_out=$(run_hook "$scratch/closeout-marker.json" "evt-closeout-marker-0001")
expect_outcome "$marker_out" ok "converging closeout"
marker_changed=$(json_field "$marker_out" "r.changedPaths.join(',')")
for expected in \
  ".northstar/lifecycle/v1/tasks/g03.006.json" \
  "docs/README.md" \
  "docs/roadmaps/README.md" \
  "docs/roadmaps/g03/README.md" \
  "docs/roadmaps/g03/006-fixture-task.md" \
  "docs/handoffs/handoff-006.md"; do
  case ",$marker_changed," in
    *,"$expected",*) ;;
    *) echo "converging closeout did not report $expected: $marker_changed" >&2; exit 1 ;;
  esac
done
[ "$(json_field "$marker_out" "r.metadata.status_marker_converged")" = "true" ]
if grep -q "Status:" "$repoM/docs/roadmaps/g03/006-fixture-task.md"; then
  echo "converging closeout left the superseded status marker in the task file" >&2
  exit 1
fi
grep -q "Owner: fixture" "$repoM/docs/roadmaps/g03/006-fixture-task.md"
grep -q "Deployment note: none yet." "$repoM/docs/roadmaps/g03/006-fixture-task.md"
grep -q "| g03.006 | complete | none |" "$repoM/docs/README.md"
"${audit_cli[@]}" "$repoM" >/dev/null
echo "one converged authority, clean audit: OK"

marker_before=$(git -C "$repoM" status --porcelain)
marker_retry=$(run_hook "$scratch/closeout-marker.json" "evt-closeout-marker-0001")
expect_outcome "$marker_retry" ok "converging closeout replay"
[ "$(json_field "$marker_retry" "r.changedPaths.length")" = "0" ]
[ "$(json_field "$marker_retry" "r.metadata.status_marker_converged")" = "false" ]
[ "$marker_before" = "$(git -C "$repoM" status --porcelain)" ]
if grep -q "Status:" "$repoM/docs/roadmaps/g03/006-fixture-task.md"; then
  echo "replay re-added a status marker" >&2
  exit 1
fi
echo "marker replay is byte-stable with no second marker: OK"

echo "# replay cleanup refuses a dirty task file"
# A leftover marker beside unrelated uncommitted bytes is not a no-diff
# cleanup: the replay gate requires the task file byte-identical to HEAD
# before removing anything, so the publication's own convergence output
# stays the only lawful uncommitted difference.
git -C "$repoM" add -A
git -C "$repoM" commit -qm "terminal publication"
printf 'Status: Ready\nLate uncommitted notes.\n' >> "$repoM/docs/roadmaps/g03/006-fixture-task.md"
dirty_before=$(git -C "$repoM" status --porcelain)
write_event "$scratch/closeout-dirty-replay.json" "evt-closeout-dirty-replay-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
dirty_replay=$(run_hook "$scratch/closeout-dirty-replay.json" "evt-closeout-dirty-replay-0001")
expect_outcome "$dirty_replay" blocked "dirty replay cleanup"
json_field "$dirty_replay" "r.summary.includes('uncommitted changes outside this publication')" >/dev/null
[ "$(json_field "$dirty_replay" "r.changedPaths.length")" = "0" ]
grep -q "Status: Ready" "$repoM/docs/roadmaps/g03/006-fixture-task.md"
grep -q "Late uncommitted notes." "$repoM/docs/roadmaps/g03/006-fixture-task.md"
grep -q '"status":"complete"' "$repoM/.northstar/lifecycle/v1/tasks/g03.006.json"
[ "$(git -C "$repoM" status --porcelain)" = " M docs/roadmaps/g03/006-fixture-task.md" ]
echo "dirty replay cleanup blocks with the bytes untouched: OK"

git -C "$repoM" checkout -q -- docs/roadmaps/g03/006-fixture-task.md
clean_replay=$(run_hook "$scratch/closeout-marker.json" "evt-closeout-marker-0001")
expect_outcome "$clean_replay" ok "replay after dirty repair"
[ "$(json_field "$clean_replay" "r.changedPaths.length")" = "0" ]
echo "replay after repair stays a no-diff cleanup: OK"

echo "# closeout after an earlier lifecycle projection write converges cleanly"
# A lifecycle-managed task can already carry a generated projection block: an
# earlier lifecycle write that rendered the task file as a projection target
# (here the standalone adapter applying ready-state transitions) legitimately
# regenerates it, so the committed task file differs from its pinned planning
# blob by adapter-owned block bytes only. Terminal closeout must still
# converge the marker and publish the terminal projection.
repoProj="$scratch/repo-marker-projection"
build_fixture "$repoProj" dogfood "$scratch/body-marker.md"
CURRENT_REPO="$repoProj"
proj_pc=$(git -C "$repoProj" log -1 --format=%H -- docs/roadmaps/g03/006-fixture-task.md)
proj_digest=$(git -C "$repoProj" cat-file blob "$proj_pc:docs/roadmaps/g03/006-fixture-task.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')
proj_fh=$(git -C "$repoProj" rev-parse feature)
proj_mc=$(git -C "$repoProj" rev-parse main)
bun -e '
  const { applyEnvelope } = await import(process.argv[1]!);
  const repo = process.argv[2]!;
  const occurredAt = "2026-09-12T20:00:00.000Z";
  const recordFile = repo + "/.northstar/lifecycle/v1/tasks/g03.006.json";
  const readCurrent = (): Record<string, unknown> | null =>
    require("node:fs").existsSync(recordFile) ? JSON.parse(require("node:fs").readFileSync(recordFile, "utf8")) : null;
  let seq = 0;
  for (const transition of ["plan", "ready", "start"]) {
    seq += 1;
    const current = readCurrent();
    const result = applyEnvelope({
      repoRoot: repo,
      envelope: {
        schema_version: "northstar.lifecycle.transition.v1",
        event_id: "standalone-proj-prep-006-" + String(seq).padStart(2, "0") + "-" + transition,
        task_id: "g03.006",
        task_path: "docs/roadmaps/g03/006-fixture-task.md",
        generation: "g03",
        expected: current === null ? { revision: 0, digest: null } : { revision: Number(current.revision), digest: String(current.digest) },
        transition,
        event_time: occurredAt,
        actor: "standalone-integrator",
        source: { adapter: "standalone" },
        planning: { commit: process.argv[3]!, task_blob_digest: process.argv[4]! },
      },
      branch: "main",
      targets: ["docs/README.md", "docs/roadmaps/README.md", "docs/roadmaps/g03/006-fixture-task.md"],
    });
    if (result.status !== "applied") throw new Error("projection prep step failed: " + JSON.stringify(result));
  }
' "$installed/scripts/lifecycle-core.ts" "$repoProj" "$proj_pc" "$proj_digest"
git -C "$repoProj" add -A
git -C "$repoProj" commit -qm "render the task file projection during ready state"
grep -q "northstar:lifecycle:begin" "$repoProj/docs/roadmaps/g03/006-fixture-task.md"
grep -q "Status: Ready" "$repoProj/docs/roadmaps/g03/006-fixture-task.md"
proj_mc=$(git -C "$repoProj" rev-parse main)
echo "# canonical but independently modified record refuses closeout"
# The chain-scoped record check tolerates only exact states of this closeout's
# own envelope chain. A tracked record that a hand rewrote in canonical form
# with an independently bumped revision is outside the chain and refuses
# before any byte changes, even though its bytes are canonical JSON.
bun -e '
  const fs = await import("node:fs");
  const core = await import(process.argv[1]!);
  const file = process.argv[2]!;
  const record = JSON.parse(fs.readFileSync(file, "utf8"));
  record.revision = 99;
  // Recompute the public digests exactly the way the core would, so the
  // tampered record passes record integrity and only the chain-scoped check
  // can refuse it.
  record.portable_digest = core.portableDigest(record);
  record.digest = core.recordDigest(record);
  fs.writeFileSync(file, core.canonicalJson(record) + "\n");
' "$installed/scripts/lifecycle-core.ts" "$repoProj/.northstar/lifecycle/v1/tasks/g03.006.json"
write_event "$scratch/closeout-proj-tamper.json" "evt-closeout-proj-tamper-0001" "task.closeout" "lifecycle-state" "$proj_mc" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" \
  "$(git -C "$repoProj" log -1 --format=%H -- docs/handoffs/handoff-006.md)" \
  "$(git -C "$repoProj" show "main:docs/handoffs/handoff-006.md" | sha256sum | cut -d' ' -f1)" \
  "$(closeout_delivery "$proj_fh" "$proj_mc")"
tamper=$(run_hook "$scratch/closeout-proj-tamper.json" "evt-closeout-proj-tamper-0001")
expect_outcome "$tamper" blocked "canonical independent record modification"
json_field "$tamper" "r.summary.includes('outside this closeout chain')" >/dev/null
[ "$(json_field "$tamper" "r.changedPaths.length")" = "0" ]
grep -q '"revision":99' "$repoProj/.northstar/lifecycle/v1/tasks/g03.006.json"
[ -e "$repoProj/docs/handoffs/handoff-006.md" ]
if [ "$(git -C "$repoProj" status --porcelain)" != " M .northstar/lifecycle/v1/tasks/g03.006.json" ]; then
  echo "canonical record tamper refusal mutated unexpected paths" >&2
  exit 1
fi
git -C "$repoProj" checkout -q -- .northstar/lifecycle/v1/tasks/g03.006.json
echo "canonical independent record modification refuses atomically: OK"
write_event "$scratch/closeout-proj.json" "evt-closeout-proj-0001" "task.closeout" "lifecycle-state" "$proj_mc" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" \
  "$(git -C "$repoProj" log -1 --format=%H -- docs/handoffs/handoff-006.md)" \
  "$(git -C "$repoProj" show "main:docs/handoffs/handoff-006.md" | sha256sum | cut -d' ' -f1)" \
  "$(closeout_delivery "$proj_fh" "$proj_mc")"
proj_out=$(run_hook "$scratch/closeout-proj.json" "evt-closeout-proj-0001")
expect_outcome "$proj_out" ok "closeout after prior projection write"
[ "$(json_field "$proj_out" "r.metadata.status_marker_converged")" = "true" ]
json_field "$proj_out" "r.changedPaths.includes('docs/roadmaps/g03/006-fixture-task.md')" >/dev/null
if grep -q "Status:" "$repoProj/docs/roadmaps/g03/006-fixture-task.md"; then
  echo "closeout after a prior projection write left the superseded status marker" >&2
  exit 1
fi
grep -q "| g03.006 | complete | none |" "$repoProj/docs/roadmaps/g03/006-fixture-task.md"
grep -q "Owner: fixture" "$repoProj/docs/roadmaps/g03/006-fixture-task.md"
"${audit_cli[@]}" "$repoProj" >/dev/null
echo "prior-projection closeout converges with the block regenerated: OK"

echo "# a blocked record whose task file was rendered still resumes to terminal"
# The closeout builder explicitly supports resuming a blocked record: drive a
# record to active, block it through the hook (which re-renders the task
# file's block), then close out through the resume path with the marker
# removed.
repoBlk="$scratch/repo-marker-blocked"
build_fixture "$repoBlk" dogfood "$scratch/body-marker.md"
CURRENT_REPO="$repoBlk"
blk_pc=$(git -C "$repoBlk" log -1 --format=%H -- docs/roadmaps/g03/006-fixture-task.md)
blk_digest=$(git -C "$repoBlk" cat-file blob "$blk_pc:docs/roadmaps/g03/006-fixture-task.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')
blk_fh=$(git -C "$repoBlk" rev-parse feature)
blk_mc=$(git -C "$repoBlk" rev-parse main)
bun -e '
  const { applyEnvelope } = await import(process.argv[1]!);
  const repo = process.argv[2]!;
  const occurredAt = "2026-09-12T20:00:00.000Z";
  const recordFile = repo + "/.northstar/lifecycle/v1/tasks/g03.006.json";
  const readCurrent = (): Record<string, unknown> | null =>
    require("node:fs").existsSync(recordFile) ? JSON.parse(require("node:fs").readFileSync(recordFile, "utf8")) : null;
  let seq = 0;
  for (const transition of ["plan", "ready", "start"]) {
    seq += 1;
    const current = readCurrent();
    const result = applyEnvelope({
      repoRoot: repo,
      envelope: {
        schema_version: "northstar.lifecycle.transition.v1",
        event_id: "standalone-block-prep-006-" + String(seq).padStart(2, "0") + "-" + transition,
        task_id: "g03.006",
        task_path: "docs/roadmaps/g03/006-fixture-task.md",
        generation: "g03",
        expected: current === null ? { revision: 0, digest: null } : { revision: Number(current.revision), digest: String(current.digest) },
        transition,
        event_time: occurredAt,
        actor: "standalone-integrator",
        source: { adapter: "standalone" },
        planning: { commit: process.argv[3]!, task_blob_digest: process.argv[4]! },
      },
      branch: "main",
      targets: ["docs/roadmaps/g03/006-fixture-task.md"],
    });
    if (result.status !== "applied") throw new Error("block prep step failed: " + JSON.stringify(result));
  }
' "$installed/scripts/lifecycle-core.ts" "$repoBlk" "$blk_pc" "$blk_digest"
git -C "$repoBlk" add -A
git -C "$repoBlk" commit -qm "render the task file projection, then report a blocker"
write_event "$scratch/blocked-proj.json" "evt-blocked-proj-0001" "task.blocked" "lifecycle-state" "$blk_mc" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" \
  "$(git -C "$repoBlk" log -1 --format=%H -- docs/handoffs/handoff-006.md)" \
  "$(git -C "$repoBlk" show "main:docs/handoffs/handoff-006.md" | sha256sum | cut -d' ' -f1)"
blk_out=$(run_hook "$scratch/blocked-proj.json" "evt-blocked-proj-0001")
expect_outcome "$blk_out" ok "blocked mapping on a rendered task file"
grep -q '"status":"blocked"' "$repoBlk/.northstar/lifecycle/v1/tasks/g03.006.json"
grep -q "Status: Ready" "$repoBlk/docs/roadmaps/g03/006-fixture-task.md"
git -C "$repoBlk" add -A
git -C "$repoBlk" commit -qm "blocked state renders the task file block"
blk_close_mc=$(git -C "$repoBlk" rev-parse main)
write_event "$scratch/closeout-blk.json" "evt-closeout-blk-0001" "task.closeout" "lifecycle-state" "$blk_close_mc" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" \
  "$(git -C "$repoBlk" log -1 --format=%H -- docs/handoffs/handoff-006.md)" \
  "$(git -C "$repoBlk" show "main:docs/handoffs/handoff-006.md" | sha256sum | cut -d' ' -f1)" \
  "$(closeout_delivery "$blk_fh" "$blk_close_mc")"
blk_close=$(run_hook "$scratch/closeout-blk.json" "evt-closeout-blk-0001")
expect_outcome "$blk_close" ok "resume closeout after a blocked render"
[ "$(json_field "$blk_close" "r.metadata.status_marker_converged")" = "true" ]
if grep -q "Status:" "$repoBlk/docs/roadmaps/g03/006-fixture-task.md"; then
  echo "resume closeout left the superseded status marker" >&2
  exit 1
fi
grep -q "| g03.006 | complete | none |" "$repoBlk/docs/README.md"
"${audit_cli[@]}" "$repoBlk" >/dev/null
echo "blocked/resumed closeout converges cleanly: OK"

convergence_refusal() { # <name> <task-body-file> <expected-summary-substring>
  local dir="$scratch/repo-converge-$1"
  build_fixture "$dir" dogfood "$2"
  CURRENT_REPO="$dir"
  read_facts "$(fixture_facts "$dir" 006)"
  write_event "$scratch/closeout-converge-$1.json" "evt-closeout-converge-$1-0001" "task.closeout" "lifecycle-state" "$MC" \
    "q-006" '"Implement g03.006 fixture task"' \
    "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
  local result
  result=$(run_hook "$scratch/closeout-converge-$1.json" "evt-closeout-converge-$1-0001")
  expect_outcome "$result" blocked "convergence refusal $1"
  json_field "$result" "r.summary.includes('$3')" >/dev/null
  [ ! -e "$dir/.northstar/lifecycle/v1/tasks/g03.006.json" ]
  [ -e "$dir/docs/handoffs/handoff-006.md" ]
  if ! cmp -s "$2" "$dir/docs/roadmaps/g03/006-fixture-task.md"; then
    echo "refused convergence case $1 still mutated the task file" >&2
    exit 1
  fi
  [ -z "$(git -C "$dir" status --porcelain)" ]
}

echo "# ambiguous status-looking prose refuses before any byte changes"
printf '%s\n' '# Task g03.006' '' 'Owner: fixture' '' '## Outcome' '' 'Status: Ready' '' 'Human outcome stays.' > "$scratch/body-section-marker.md"
convergence_refusal section "$scratch/body-section-marker.md" \
  "refusing rather than removing possible human prose"
printf '%s\n' '# Task g03.006' '' 'Owner: fixture' '' 'Example:' '' '```md' 'Status: Ready' '```' > "$scratch/body-fenced-marker.md"
convergence_refusal fenced "$scratch/body-fenced-marker.md" \
  "refusing rather than removing possible human prose"
echo "ambiguous status-looking prose refuses atomically: OK"

echo "# symlinked task path refuses marker convergence"
repoSym="$scratch/repo-converge-symlink"
build_fixture "$repoSym"
outside_task="$scratch/outside-task-target.md"
printf 'External task bytes.\n' > "$outside_task"
rm "$repoSym/docs/roadmaps/g03/006-fixture-task.md"
ln -s "$outside_task" "$repoSym/docs/roadmaps/g03/006-fixture-task.md"
CURRENT_REPO="$repoSym"
read_facts "$(fixture_facts "$repoSym" 006)"
write_event "$scratch/closeout-converge-symlink.json" "evt-closeout-converge-symlink-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
sym_out=$(run_hook "$scratch/closeout-converge-symlink.json" "evt-closeout-converge-symlink-0001")
expect_outcome "$sym_out" blocked "symlinked task path"
json_field "$sym_out" "r.summary.includes('symlink')" >/dev/null
[ ! -e "$repoSym/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -L "$repoSym/docs/roadmaps/g03/006-fixture-task.md" ]
echo "symlinked task path refusal: OK"

echo "# undeclared task path refuses marker convergence"
repoUnd="$scratch/repo-converge-undeclared"
printf '# Task g03.006\n\nStatus: Ready\nOwner: fixture\n' > "$scratch/body-undeclared-marker.md"
build_fixture "$repoUnd" dogfood "$scratch/body-undeclared-marker.md"
bun -e '
  const fs = await import("node:fs");
  const file = process.argv[1];
  const manifest = JSON.parse(fs.readFileSync(file, "utf8"));
  for (const hook of manifest.hooks) {
    if (hook.id === "lifecycle-state") {
      hook.allowedPaths = [".northstar/lifecycle/", "docs/README.md", "docs/roadmaps/README.md", "docs/roadmaps/g03/README.md", "docs/handoffs/"];
    }
  }
  fs.writeFileSync(file, JSON.stringify(manifest, null, 2) + "\n");
' "$repoUnd/.paseo/queue.json"
git -C "$repoUnd" add -A
git -C "$repoUnd" commit -qm "narrow the declared task-path authority"
CURRENT_REPO="$repoUnd"
read_facts "$(fixture_facts "$repoUnd" 006)"
write_event "$scratch/closeout-converge-undeclared.json" "evt-closeout-converge-undeclared-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
und_out=$(run_hook "$scratch/closeout-converge-undeclared.json" "evt-closeout-converge-undeclared-0001")
expect_outcome "$und_out" blocked "undeclared task path"
json_field "$und_out" "r.summary.includes('not declared in the manifest allowedPaths')" >/dev/null
[ ! -e "$repoUnd/.northstar/lifecycle/v1/tasks/g03.006.json" ]
if ! grep -q "Status:" "$repoUnd/docs/roadmaps/g03/006-fixture-task.md"; then
  echo "undeclared-path refusal still converged the marker" >&2
  exit 1
fi
echo "undeclared task path refusal: OK"

echo "# unreported task-file mutation refuses before publication"
repoMut="$scratch/repo-converge-mutation"
build_fixture "$repoMut"
CURRENT_REPO="$repoMut"
read_facts "$(fixture_facts "$repoMut" 006)"
printf 'Late unreported edit.\n' >> "$repoMut/docs/roadmaps/g03/006-fixture-task.md"
write_event "$scratch/closeout-converge-mutation.json" "evt-closeout-converge-mutation-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
mut_out=$(run_hook "$scratch/closeout-converge-mutation.json" "evt-closeout-converge-mutation-0001")
expect_outcome "$mut_out" blocked "unreported task-file mutation"
json_field "$mut_out" "r.summary.includes('uncommitted changes in the integration checkout')" >/dev/null
[ ! -e "$repoMut/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ "$(git -C "$repoMut" status --porcelain)" = " M docs/roadmaps/g03/006-fixture-task.md" ]
echo "unreported task-file mutation refusal: OK"

echo "# trailing-newline drift outside the block refuses"
repoTail="$scratch/repo-converge-trailing"
build_fixture "$repoTail" dogfood "$scratch/body-marker.md"
CURRENT_REPO="$repoTail"
read_facts "$(fixture_facts "$repoTail" 006)"
printf '\n\n' >> "$repoTail/docs/roadmaps/g03/006-fixture-task.md"
write_event "$scratch/closeout-trailing.json" "evt-closeout-trailing-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
trailing=$(run_hook "$scratch/closeout-trailing.json" "evt-closeout-trailing-0001")
expect_outcome "$trailing" blocked "trailing-newline drift"
json_field "$trailing" "r.summary.includes('uncommitted changes in the integration checkout')" >/dev/null
[ ! -e "$repoTail/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoTail/docs/handoffs/handoff-006.md" ]
[ "$(git -C "$repoTail" status --porcelain)" = " M docs/roadmaps/g03/006-fixture-task.md" ]
echo "trailing-newline drift refusal: OK"

# The same drift, once committed, is judged against the pinned planning blob:
# outside-block bytes must match exactly, so the committed blank lines still
# refuse through the planning-identity gate.
git -C "$repoTail" add -A
git -C "$repoTail" commit -qm "append blank lines outside the block"
trailing_committed=$(run_hook "$scratch/closeout-trailing.json" "evt-closeout-trailing-0001")
expect_outcome "$trailing_committed" blocked "committed trailing-newline drift"
json_field "$trailing_committed" "r.summary.includes('changed outside its generated lifecycle block')" >/dev/null
[ ! -e "$repoTail/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "committed outside-block drift refusal: OK"

echo "# an unreported edit inside a generated block refuses closeout"
# The planning-identity comparison strips generated blocks, so an unreported
# mutation hidden between the sentinels must be caught by the checkout
# discipline: the closeout checkout carries the task file exactly as HEAD
# committed it, and the closeout render never overwrites unreported bytes.
repoHide="$scratch/repo-converge-block-edit"
build_fixture "$repoHide" dogfood "$scratch/body-marker.md"
CURRENT_REPO="$repoHide"
hide_pc=$(git -C "$repoHide" log -1 --format=%H -- docs/roadmaps/g03/006-fixture-task.md)
hide_digest=$(git -C "$repoHide" cat-file blob "$hide_pc:docs/roadmaps/g03/006-fixture-task.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')
hide_fh=$(git -C "$repoHide" rev-parse feature)
hide_mc=$(git -C "$repoHide" rev-parse main)
bun -e '
  const { applyEnvelope } = await import(process.argv[1]!);
  const repo = process.argv[2]!;
  const occurredAt = "2026-09-12T20:00:00.000Z";
  const recordFile = repo + "/.northstar/lifecycle/v1/tasks/g03.006.json";
  const readCurrent = (): Record<string, unknown> | null =>
    require("node:fs").existsSync(recordFile) ? JSON.parse(require("node:fs").readFileSync(recordFile, "utf8")) : null;
  let seq = 0;
  for (const transition of ["plan", "ready", "start"]) {
    seq += 1;
    const current = readCurrent();
    const result = applyEnvelope({
      repoRoot: repo,
      envelope: {
        schema_version: "northstar.lifecycle.transition.v1",
        event_id: "standalone-hide-prep-006-" + String(seq).padStart(2, "0") + "-" + transition,
        task_id: "g03.006",
        task_path: "docs/roadmaps/g03/006-fixture-task.md",
        generation: "g03",
        expected: current === null ? { revision: 0, digest: null } : { revision: Number(current.revision), digest: String(current.digest) },
        transition,
        event_time: occurredAt,
        actor: "standalone-integrator",
        source: { adapter: "standalone" },
        planning: { commit: process.argv[3]!, task_blob_digest: process.argv[4]! },
      },
      branch: "main",
      targets: ["docs/roadmaps/g03/006-fixture-task.md"],
    });
    if (result.status !== "applied") throw new Error("hide prep step failed: " + JSON.stringify(result));
  }
' "$installed/scripts/lifecycle-core.ts" "$repoHide" "$hide_pc" "$hide_digest"
git -C "$repoHide" add -A
git -C "$repoHide" commit -qm "render the task file projection"
hide_mc=$(git -C "$repoHide" rev-parse main)
bun -e '
  const fs = await import("node:fs");
  const file = process.argv[1]!;
  const text = fs.readFileSync(file, "utf8");
  const edited = text.replace("| g03.006 | active | dispatch |", "| g03.006 | blocked | none |");
  if (edited === text) { console.error("block interior tamper did not apply"); process.exit(1); }
  fs.writeFileSync(file, edited);
' "$repoHide/docs/roadmaps/g03/006-fixture-task.md"
write_event "$scratch/closeout-hide.json" "evt-closeout-hide-0001" "task.closeout" "lifecycle-state" "$hide_mc" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" \
  "$(git -C "$repoHide" log -1 --format=%H -- docs/handoffs/handoff-006.md)" \
  "$(git -C "$repoHide" show "main:docs/handoffs/handoff-006.md" | sha256sum | cut -d' ' -f1)" \
  "$(closeout_delivery "$hide_fh" "$hide_mc")"
hide_out=$(run_hook "$scratch/closeout-hide.json" "evt-closeout-hide-0001")
expect_outcome "$hide_out" blocked "unreported block-interior edit"
json_field "$hide_out" "r.summary.includes('uncommitted changes in the integration checkout')" >/dev/null
[ "$(json_field "$hide_out" "r.changedPaths.length")" = "0" ]
grep -q '"revision":3' "$repoHide/.northstar/lifecycle/v1/tasks/g03.006.json"
[ -e "$repoHide/docs/handoffs/handoff-006.md" ]
if ! grep -q "| g03.006 | blocked | none |" "$repoHide/docs/roadmaps/g03/006-fixture-task.md"; then
  echo "block-interior tamper was overwritten before refusal" >&2
  exit 1
fi
[ "$(git -C "$repoHide" status --porcelain)" = " M docs/roadmaps/g03/006-fixture-task.md" ]
echo "unreported block-interior edit refuses with the bytes intact: OK"

echo "# a committed forged block refuses closeout"
# A block committed with no corresponding lifecycle transition is not adapter
# state: block provenance requires each committed block to equal the pinned
# planning blob's own block or the canonical projection of the current
# records, so the forged bytes refuse before any byte changes or commit
# intent even though the block-stripped prose is untouched.
repoForge="$scratch/repo-converge-forge"
build_fixture "$repoForge" dogfood "$scratch/body-marker.md"
CURRENT_REPO="$repoForge"
forge_pc=$(git -C "$repoForge" log -1 --format=%H -- docs/roadmaps/g03/006-fixture-task.md)
forge_digest=$(git -C "$repoForge" cat-file blob "$forge_pc:docs/roadmaps/g03/006-fixture-task.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')
forge_fh=$(git -C "$repoForge" rev-parse feature)
bun -e '
  const { applyEnvelope } = await import(process.argv[1]!);
  const repo = process.argv[2]!;
  const occurredAt = "2026-09-12T20:00:00.000Z";
  const recordFile = repo + "/.northstar/lifecycle/v1/tasks/g03.006.json";
  const readCurrent = (): Record<string, unknown> | null =>
    require("node:fs").existsSync(recordFile) ? JSON.parse(require("node:fs").readFileSync(recordFile, "utf8")) : null;
  let seq = 0;
  for (const transition of ["plan", "ready", "start"]) {
    seq += 1;
    const current = readCurrent();
    const result = applyEnvelope({
      repoRoot: repo,
      envelope: {
        schema_version: "northstar.lifecycle.transition.v1",
        event_id: "standalone-forge-prep-006-" + String(seq).padStart(2, "0") + "-" + transition,
        task_id: "g03.006",
        task_path: "docs/roadmaps/g03/006-fixture-task.md",
        generation: "g03",
        expected: current === null ? { revision: 0, digest: null } : { revision: Number(current.revision), digest: String(current.digest) },
        transition,
        event_time: occurredAt,
        actor: "standalone-integrator",
        source: { adapter: "standalone" },
        planning: { commit: process.argv[3]!, task_blob_digest: process.argv[4]! },
      },
      branch: "main",
      targets: ["docs/roadmaps/g03/006-fixture-task.md"],
    });
    if (result.status !== "applied") throw new Error("forge prep step failed: " + JSON.stringify(result));
  }
' "$installed/scripts/lifecycle-core.ts" "$repoForge" "$forge_pc" "$forge_digest"
git -C "$repoForge" add -A
git -C "$repoForge" commit -qm "render the task file projection"
bun -e '
  const fs = await import("node:fs");
  const file = process.argv[1]!;
  const text = fs.readFileSync(file, "utf8");
  const forged = text.replace("| g03.006 | active | dispatch |", "| g03.006 | blocked | none |");
  if (forged === text) { console.error("block forgery did not apply"); process.exit(1); }
  fs.writeFileSync(file, forged);
' "$repoForge/docs/roadmaps/g03/006-fixture-task.md"
git -C "$repoForge" add -A
git -C "$repoForge" commit -qm "commit a forged block edit"
forge_mc=$(git -C "$repoForge" rev-parse main)
write_event "$scratch/closeout-forge.json" "evt-closeout-forge-0001" "task.closeout" "lifecycle-state" "$forge_mc" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" \
  "$(git -C "$repoForge" log -1 --format=%H -- docs/handoffs/handoff-006.md)" \
  "$(git -C "$repoForge" show "main:docs/handoffs/handoff-006.md" | sha256sum | cut -d' ' -f1)" \
  "$(closeout_delivery "$forge_fh" "$forge_mc")"
forge_out=$(run_hook "$scratch/closeout-forge.json" "evt-closeout-forge-0001")
expect_outcome "$forge_out" blocked "committed forged block"
json_field "$forge_out" "r.summary.includes('neither its pinned planning blob')" >/dev/null
[ "$(json_field "$forge_out" "r.changedPaths.length")" = "0" ]
grep -q '"revision":3' "$repoForge/.northstar/lifecycle/v1/tasks/g03.006.json"
grep -q "| g03.006 | blocked | none |" "$repoForge/docs/roadmaps/g03/006-fixture-task.md"
[ -z "$(git -C "$repoForge" status --porcelain)" ]
echo "committed forged block refuses with zero-byte atomicity: OK"

echo "# a committed duplicate generated block refuses closeout"
# The reviewer's reproduction, proven against the installed bytes: two
# identical blocks both pass per-block provenance, the block-stripped prose
# is unchanged, and renderProjectionInto replaces only the first range — so
# closeout would publish a second generated authority. The single-authority
# gate refuses before any byte changes or commit intent.
repoDup="$scratch/repo-converge-duplicate"
build_fixture "$repoDup" dogfood "$scratch/body-marker.md"
CURRENT_REPO="$repoDup"
dup_pc=$(git -C "$repoDup" log -1 --format=%H -- docs/roadmaps/g03/006-fixture-task.md)
dup_digest=$(git -C "$repoDup" cat-file blob "$dup_pc:docs/roadmaps/g03/006-fixture-task.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')
dup_fh=$(git -C "$repoDup" rev-parse feature)
bun -e '
  const { applyEnvelope } = await import(process.argv[1]!);
  const repo = process.argv[2]!;
  const occurredAt = "2026-09-12T20:00:00.000Z";
  const recordFile = repo + "/.northstar/lifecycle/v1/tasks/g03.006.json";
  const readCurrent = (): Record<string, unknown> | null =>
    require("node:fs").existsSync(recordFile) ? JSON.parse(require("node:fs").readFileSync(recordFile, "utf8")) : null;
  let seq = 0;
  for (const transition of ["plan", "ready", "start"]) {
    seq += 1;
    const current = readCurrent();
    const result = applyEnvelope({
      repoRoot: repo,
      envelope: {
        schema_version: "northstar.lifecycle.transition.v1",
        event_id: "standalone-dup-prep-006-" + String(seq).padStart(2, "0") + "-" + transition,
        task_id: "g03.006",
        task_path: "docs/roadmaps/g03/006-fixture-task.md",
        generation: "g03",
        expected: current === null ? { revision: 0, digest: null } : { revision: Number(current.revision), digest: String(current.digest) },
        transition,
        event_time: occurredAt,
        actor: "standalone-integrator",
        source: { adapter: "standalone" },
        planning: { commit: process.argv[3]!, task_blob_digest: process.argv[4]! },
      },
      branch: "main",
      targets: ["docs/roadmaps/g03/006-fixture-task.md"],
    });
    if (result.status !== "applied") throw new Error("dup prep step failed: " + JSON.stringify(result));
  }
' "$installed/scripts/lifecycle-core.ts" "$repoDup" "$dup_pc" "$dup_digest"
git -C "$repoDup" add -A
git -C "$repoDup" commit -qm "render the task file projection"
bun -e '
  const core = await import(process.argv[1]!);
  const fs = await import("node:fs");
  const file = process.argv[2]!;
  const text = fs.readFileSync(file, "utf8");
  const blocks = core.generatedBlocks(text);
  if (blocks.length !== 1) { console.error("prep did not leave exactly one block"); process.exit(1); }
  const duplicate = text + blocks[0]! + "\n";
  if (core.generatedBlocks(duplicate).length !== 2) { console.error("duplicate did not yield two blocks"); process.exit(1); }
  if (core.stripGeneratedBlocks(duplicate) !== core.stripGeneratedBlocks(text) + "\n") { console.error("duplicate changed stripped prose beyond the appended separator"); process.exit(1); }
  const state = core.generationStateOf([], "g03", null);
  const replaced = core.renderProjectionInto(duplicate, core.buildProjectionStates([], [state])).text;
  if (replaced.split(core.BEGIN_PREFIX).length - 1 !== 2) { console.error("render no longer replaces only the first range"); process.exit(1); }
  fs.writeFileSync(file, duplicate);
' "$installed/scripts/lifecycle-core.ts" "$repoDup/docs/roadmaps/g03/006-fixture-task.md"
git -C "$repoDup" add -A
git -C "$repoDup" commit -qm "commit a duplicate generated block"
dup_mc=$(git -C "$repoDup" rev-parse main)
write_event "$scratch/closeout-dup.json" "evt-closeout-dup-0001" "task.closeout" "lifecycle-state" "$dup_mc" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" \
  "$(git -C "$repoDup" log -1 --format=%H -- docs/handoffs/handoff-006.md)" \
  "$(git -C "$repoDup" show "main:docs/handoffs/handoff-006.md" | sha256sum | cut -d' ' -f1)" \
  "$(closeout_delivery "$dup_fh" "$dup_mc")"
dup_out=$(run_hook "$scratch/closeout-dup.json" "evt-closeout-dup-0001")
expect_outcome "$dup_out" blocked "committed duplicate block"
json_field "$dup_out" "r.summary.includes('generated lifecycle blocks')" >/dev/null
[ "$(json_field "$dup_out" "r.changedPaths.length")" = "0" ]
[ "$(grep -c "northstar:lifecycle:begin" "$repoDup/docs/roadmaps/g03/006-fixture-task.md")" = "2" ]
grep -q '"revision":3' "$repoDup/.northstar/lifecycle/v1/tasks/g03.006.json"
[ -z "$(git -C "$repoDup" status --porcelain)" ]
echo "committed duplicate block refuses with zero-byte atomicity: OK"

echo "# a red prospective audit blocks closeout; repair leaves two clean closeouts"
repoRed="$scratch/repo-red-currentness"
build_fixture "$repoRed"
cat >> "$repoRed/docs/README.md" <<'EOF'

## Next Task

Continue with `g03.006` next.
EOF
git -C "$repoRed" add -A
git -C "$repoRed" commit -qm "stale human frontier prose"
CURRENT_REPO="$repoRed"
read_facts "$(fixture_facts "$repoRed" 006)"
write_event "$scratch/closeout-red.json" "evt-closeout-red-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
red_out=$(run_hook "$scratch/closeout-red.json" "evt-closeout-red-0001")
expect_outcome "$red_out" blocked "red prospective audit"
json_field "$red_out" "r.summary.includes('stale-frontier')" >/dev/null
json_field "$red_out" "r.summary.includes('docs/README.md')" >/dev/null
[ "$(json_field "$red_out" "r.changedPaths.length")" = "0" ]
[ ! -e "$repoRed/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoRed/docs/handoffs/handoff-006.md" ]
[ -z "$(git -C "$repoRed" status --porcelain)" ]
echo "red prospective audit blocks with zero bytes changed: OK"

bun -e '
  const fs = await import("node:fs");
  const file = process.argv[1];
  const text = fs.readFileSync(file, "utf8");
  const repaired = text.replace(/\n## Next Task\n\nContinue with `g03.006` next\.\n/, "\n");
  if (repaired === text) { console.error("repair did not change the fixture"); process.exit(1); }
  fs.writeFileSync(file, repaired);
' "$repoRed/docs/README.md"
git -C "$repoRed" add -A
git -C "$repoRed" commit -qm "repair currentness prose"
# The repair lands on main, so the retry occurrence pins the new integration
# base; the occurrence identity stays the same because no record was written.
MC=$(git -C "$repoRed" rev-parse main)
write_event "$scratch/closeout-red.json" "evt-closeout-red-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
repair_first=$(run_hook "$scratch/closeout-red.json" "evt-closeout-red-0001")
expect_outcome "$repair_first" ok "closeout after repair"
[ "$(json_field "$repair_first" "r.metadata.status_marker_converged")" = "false" ]
repair_second=$(run_hook "$scratch/closeout-red.json" "evt-closeout-red-0001")
expect_outcome "$repair_second" ok "second closeout after repair"
[ "$(json_field "$repair_second" "r.changedPaths.length")" = "0" ]
"${audit_cli[@]}" "$repoRed" >/dev/null
echo "two sequential closeouts after repair stay clean: OK"

echo "# durable handoff backlinks refuse closeout before any byte changes"
repoB="$scratch/repo-backlink"
build_fixture "$repoB"
mkdir -p "$repoB/docs"
cat > "$repoB/docs/implementation-log.md" <<'EOF'
# Implementation log

Durable evidence for the fixture lane. Dispatched from
[the worker handoff](handoffs/handoff-006.md).
EOF
git -C "$repoB" add -A
git -C "$repoB" commit -qm "durable log links the submitted handoff"
CURRENT_REPO="$repoB"
read_facts "$(fixture_facts "$repoB" 006)"
write_event "$scratch/closeout-backlink.json" "evt-closeout-backlink-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
backlink_out=$(run_hook "$scratch/closeout-backlink.json" "evt-closeout-backlink-0001")
expect_outcome "$backlink_out" blocked "durable backlink"
[ "$(json_field "$backlink_out" "r.summary.includes('docs/implementation-log.md')")" = "true" ]
[ ! -e "$repoB/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoB/docs/handoffs/handoff-006.md" ]
if grep -q "g03.006 | complete" "$repoB/docs/README.md"; then
  echo "refused closeout still mutated a projection" >&2
  exit 1
fi
[ -z "$(git -C "$repoB" status --porcelain)" ]
echo "durable backlink refusal is atomic: OK"

echo "# backlink link-resolution controls"
link_case() { # <name> <link-target> <expected-outcome> [extra-log-lines]
  local dir="$scratch/repo-link-$1"
  build_fixture "$dir"
  mkdir -p "$dir/docs"
  printf '# Log\n\nSee [the handoff](%s).\n' "$2" > "$dir/docs/log.md"
  if [ -n "${4:-}" ]; then printf '%s\n' "$4" >> "$dir/docs/log.md"; fi
  git -C "$dir" add -A
  git -C "$dir" commit -qm "log variant $1"
  CURRENT_REPO="$dir"
  read_facts "$(fixture_facts "$dir" 006)"
  write_event "$scratch/closeout-link-$1.json" "evt-closeout-link-$1-0001" "task.closeout" "lifecycle-state" "$MC" \
    "q-006" '"Implement g03.006 fixture task"' \
    "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
  local result
  result=$(run_hook "$scratch/closeout-link-$1.json" "evt-closeout-link-$1-0001")
  expect_outcome "$result" "$3" "link control $1"
  if [ "$3" = "blocked" ]; then
    [ ! -e "$dir/.northstar/lifecycle/v1/tasks/g03.006.json" ]
    [ -e "$dir/docs/handoffs/handoff-006.md" ]
    [ -z "$(git -C "$dir" status --porcelain)" ]
  else
    [ ! -e "$dir/docs/handoffs/handoff-006.md" ]
    [ -f "$dir/.northstar/lifecycle/v1/tasks/g03.006.json" ]
  fi
}
link_case exact "handoffs/handoff-006.md" blocked
link_case rooted "/docs/handoffs/handoff-006.md" blocked
link_case fragment "handoffs/handoff-006.md#evidence" blocked
link_case titled 'handoffs/handoff-006.md "Worker handoff"' blocked
link_case autolink "none" blocked $'See <handoffs/handoff-006.md>.'
link_case reffull "none" blocked $'See [the handoff][run].\n\n[run]: handoffs/handoff-006.md "dispatch source"'
link_case refcollapsed "none" blocked $'See [the handoff][].\n\n[the handoff]: handoffs/handoff-006.md'
link_case refshortcut "none" blocked $'See [dispatch-note] for context.\n\n[dispatch-note]: handoffs/handoff-006.md'
link_case percentencoded "handoffs/handoff-%30%30%36.md" blocked
link_case generatedonly "none" ok $'<!-- northstar:lifecycle:begin -->\nSee [the handoff](handoffs/handoff-006.md).\n<!-- northstar:lifecycle:end -->'
link_case external "https://github.com/example/repo/blob/main/docs/handoffs/handoff-006.md" ok
link_case mismatch "handoffs/handoff-006-v2.md" ok
link_case codeexample "none" blocked $'```md\nSee [the handoff](handoffs/handoff-006.md).\n```\n\nQuoted `[the handoff](handoffs/handoff-006.md)` stays inline.'
link_case indented "none" blocked $'Example:\n\n    See [the handoff](handoffs/handoff-006.md).'
link_case escaped "none" blocked $'\\`See [the handoff](handoffs/handoff-006.md).\\`'
link_case listcontinuation "none" blocked $'- item\n    continuation [the handoff](handoffs/handoff-006.md).'
link_case non1ordered "none" blocked $'Paragraph text.\n3. markers [the handoff](handoffs/handoff-006.md).'
echo "conservative code-context refusals are atomic: OK"
link_case sibling "handoffs/handoff-007.md" ok
echo "relative, rooted, fragment, titled, reference-style, indented, escaped, list-continuation, non-1-ordered, fenced, inline, external, mismatch, and sibling controls: OK"

repoEscapedBasename="$scratch/repo-escaped-basename"
build_fixture "$repoEscapedBasename"
printf '# Log\n\nSee [the handoff](handoffs/hand%%20off.md).\n' > "$repoEscapedBasename/docs/escaped-link.md"
git -C "$repoEscapedBasename" add -A
git -C "$repoEscapedBasename" commit -qm "add encoded unusual-basename backlink"
bun -e '
  const { findHandoffBacklinks } = await import(process.argv[1]);
  const hits = findHandoffBacklinks(process.argv[2], "docs/handoffs/hand off.md");
  if (JSON.stringify(hits) !== JSON.stringify(["docs/escaped-link.md"])) throw new Error("escaped-basename fallback missed its backlink: " + hits);
' "$source_skill/scripts/lifecycle-backlink.ts" "$repoEscapedBasename"
echo "escaped-basename fallback finds encoded backlinks: OK"

printf '# Log\n\nSee [the handoff](handoffs/-notes.md).\n' > "$repoEscapedBasename/docs/dash-link.md"
printf '# Log\n\nSee [the handoff](handoffs/%%2Dnotes.md).\n' > "$repoEscapedBasename/docs/dash-encoded-link.md"
git -C "$repoEscapedBasename" add -A
git -C "$repoEscapedBasename" commit -qm "add dash-leading basename backlinks"
bun -e '
  const { findHandoffBacklinks } = await import(process.argv[1]);
  const hits = findHandoffBacklinks(process.argv[2], "docs/handoffs/-notes.md");
  const expected = ["docs/dash-encoded-link.md", "docs/dash-link.md"];
  if (JSON.stringify(hits) !== JSON.stringify(expected)) throw new Error("dash-leading basename prefilter missed backlinks: " + hits);
' "$source_skill/scripts/lifecycle-backlink.ts" "$repoEscapedBasename"
echo "dash-leading basename prefilter finds literal and encoded backlinks: OK"

echo "# pre-merge gate runs read-only at the exact reviewed head"
repoPre="$scratch/repo-pre-merge"
build_fixture "$repoPre"
git -C "$repoPre" checkout -q feature
# The reviewed-head gate is the legacy v3 binding: install the derived
# conforming v3 manifest on the reviewed feature head so the prospective
# default never masks that path.
cp "$scratch/derived-v3-premerge.json" "$repoPre/.paseo/queue.json"
git -C "$repoPre" add -A
git -C "$repoPre" commit -qm "install the legacy v3 reviewed-head manifest"
mkdir -p "$repoPre/docs"
cat > "$repoPre/docs/review-notes.md" <<'EOF'
# Review notes

Canonical task: [g03.006](../roadmaps/g03/006-fixture-task.md)
Canonical contract: [working rules](../contracts/001-working-rules.md)
EOF
git -C "$repoPre" add -A
git -C "$repoPre" commit -qm "review notes cite canonical evidence"
CURRENT_REPO="$repoPre"
read_facts "$(fixture_facts "$repoPre" 006)"
pre_clean_head=$(git -C "$repoPre" rev-parse HEAD)
write_premerge_event "$scratch/premerge-clean.json" "evt-premerge-clean-0001" "q-006" '"Implement g03.006 fixture task"' "$pre_clean_head" "docs/handoffs/handoff-006.md" "$IC" "$ID"
clean_pre=$(run_hook "$scratch/premerge-clean.json" "evt-premerge-clean-0001")
expect_outcome "$clean_pre" ok "clean pre-merge head"
[ "$(json_field "$clean_pre" "r.changedPaths.length")" = "0" ]
[ "$(json_field "$clean_pre" "r.commitSubjectSuffix")" = "null" ]
[ "$(json_field "$clean_pre" "r.metadata.reviewed_head")" = "$pre_clean_head" ]
[ ! -e "$repoPre/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoPre/docs/handoffs/handoff-006.md" ]
[ -z "$(git -C "$repoPre" status --porcelain)" ]
[ "$(git -C "$repoPre" rev-parse HEAD)" = "$pre_clean_head" ]
echo "clean reviewed head passes read-only: OK"

# A durable exact backlink refuses before merge, names the linking path, and
# leaves every byte, the index, HEAD, and the lifecycle record untouched.
cat > "$repoPre/docs/implementation-log.md" <<'EOF'
# Implementation log

Dispatched from [the worker handoff](handoffs/handoff-006.md).
EOF
git -C "$repoPre" add -A
git -C "$repoPre" commit -qm "durable log links the submitted handoff"
pre_bad_head=$(git -C "$repoPre" rev-parse HEAD)
pre_handoff_digest=$(sha256sum "$repoPre/docs/handoffs/handoff-006.md" | cut -d' ' -f1)
pre_log_digest=$(sha256sum "$repoPre/docs/implementation-log.md" | cut -d' ' -f1)
write_premerge_event "$scratch/premerge-backlink.json" "evt-premerge-backlink-0001" "q-006" '"Implement g03.006 fixture task"' "$pre_bad_head" "docs/handoffs/handoff-006.md" "$IC" "$ID"
blocked_pre=$(run_hook "$scratch/premerge-backlink.json" "evt-premerge-backlink-0001")
expect_outcome "$blocked_pre" blocked "pre-merge backlink"
[ "$(json_field "$blocked_pre" "r.summary.includes('docs/implementation-log.md')")" = "true" ]
[ "$(json_field "$blocked_pre" "r.changedPaths.length")" = "0" ]
[ "$(json_field "$blocked_pre" "r.commitSubjectSuffix")" = "null" ]
[ ! -e "$repoPre/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoPre/docs/handoffs/handoff-006.md" ]
[ -z "$(git -C "$repoPre" status --porcelain)" ]
[ "$(git -C "$repoPre" rev-parse HEAD)" = "$pre_bad_head" ]
[ "$pre_handoff_digest" = "$(sha256sum "$repoPre/docs/handoffs/handoff-006.md" | cut -d' ' -f1)" ]
[ "$pre_log_digest" = "$(sha256sum "$repoPre/docs/implementation-log.md" | cut -d' ' -f1)" ]
# One shared resolver: the refusal is byte-identical to the closeout refusal.
[ "$(json_field "$blocked_pre" "r.summary")" = "$(json_field "$backlink_out" "r.summary")" ]
echo "durable pre-merge backlink refuses read-only and matches closeout: OK"

# A failed required pre-merge gate carries no changed path and no commit
# subject. Queue routes exactly that result through the retained worker's
# ordinary semantic revision loop; it creates no closeout occurrence.
[ "$(json_field "$blocked_pre" "r.outcome")" = "blocked" ]
[ "$(json_field "$blocked_pre" "r.changedPaths.length")" = "0" ]
[ "$(json_field "$blocked_pre" "r.commitSubjectSuffix")" = "null" ]
echo "ordinary revision-routing signal: OK"

# The binding rules live in the adapter, so a malformed reviewed-head hook
# refuses before it can scan or write.
echo "# pre-merge binding rules fail closed through the adapter"
cp "$repoPre/.paseo/queue.json" "$scratch/premerge-manifest-saved.json"
premerge_binding_case() { # <label> <expected-substring> <mutation-js-file>
  cp "$scratch/premerge-manifest-saved.json" "$repoPre/.paseo/queue.json"
  bun -e '
    const fs = await import("node:fs");
    const mutation = fs.readFileSync(process.argv[3], "utf8");
    const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    const hook = manifest.hooks.find((entry) => entry.id === "repository-pre-merge");
    new Function("hook", mutation)(hook);
    fs.writeFileSync(process.argv[2], JSON.stringify(manifest, null, 2) + "\n");
  ' "$scratch/premerge-manifest-saved.json" "$repoPre/.paseo/queue.json" "$3"
  local result
  result=$(run_hook "$scratch/premerge-backlink.json" "evt-premerge-backlink-0001")
  expect_outcome "$result" blocked "$1"
  if [ "$(json_field "$result" "r.summary.includes('$2')")" != "true" ]; then
    echo "$1: refusal did not name '$2': $result" >&2
    exit 1
  fi
}
printf 'hook.target = "integration_base";' > "$scratch/mut-target.js"
printf 'hook.events = ["task.pre_merge", "task.closeout"];' > "$scratch/mut-events.js"
printf 'hook.delivery = "advisory";' > "$scratch/mut-delivery.js"
printf 'hook.mode = "integration_write"; hook.commitSubject = { prefix: "lifecycle", maxBytes: 60 };' > "$scratch/mut-mode.js"
premerge_binding_case "pre-merge target mismatch" "requires target reviewed_head" "$scratch/mut-target.js"
premerge_binding_case "pre-merge mixed events" "must be the only event" "$scratch/mut-events.js"
premerge_binding_case "pre-merge advisory delivery" "requires required delivery" "$scratch/mut-delivery.js"
premerge_binding_case "pre-merge write mode" "accepts only read_only hooks" "$scratch/mut-mode.js"
cp "$scratch/premerge-manifest-saved.json" "$repoPre/.paseo/queue.json"
[ -z "$(git -C "$repoPre" status --porcelain)" ]
echo "pre-merge binding refusals: OK"

echo "# prospective-merge gate proves the declared candidate read-only"
repoPro="$scratch/repo-prospective"
build_fixture "$repoPro"
# Promote the pre-merge hook to the v4 prospective target.
bun -e '
  const fs = await import("node:fs");
  const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  manifest.schema = "paseo.queue.control.v4";
  const hook = manifest.hooks.find((entry) => entry.id === "repository-pre-merge");
  hook.id = "candidate-pre-merge";
  hook.target = "prospective_merge";
  fs.writeFileSync(process.argv[1], JSON.stringify(manifest, null, 2) + "\n");
' "$repoPro/.paseo/queue.json"
schema_check "$V4_MIRROR" "$repoPro/.paseo/queue.json"
git -C "$repoPro" add -A
git -C "$repoPro" commit -qm "select the v4 prospective-merge binding"
# A new review head on feature, then the prospective candidate merges it onto main.
git -C "$repoPro" checkout -q feature
mkdir -p "$repoPro/docs"
cat > "$repoPro/docs/review-notes.md" <<'EOF'
# Review notes

Canonical task: [g03.006](../roadmaps/g03/006-fixture-task.md)
EOF
git -C "$repoPro" add -A
git -C "$repoPro" commit -qm "review notes cite canonical evidence"
CURRENT_REPO="$repoPro"
read_facts "$(fixture_facts "$repoPro" 006)"
pro_base=$MC
pro_head=$FH
git -C "$repoPro" checkout -qb candidate main
git -C "$repoPro" merge -q --no-ff feature -m "prospective merge of the reviewed head"
pro_candidate=$(git -C "$repoPro" rev-parse HEAD)
pro_tree=$(git -C "$repoPro" rev-parse 'HEAD^{tree}')
[ "$(git -C "$repoPro" log -1 --format=%P HEAD)" = "$pro_base $pro_head" ]
write_prospective_event "$scratch/prospective-clean.json" "evt-prospective-clean-0001" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_base" "$pro_head" "$pro_candidate" "$pro_tree" \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
clean_pro=$(run_hook "$scratch/prospective-clean.json" "evt-prospective-clean-0001")
expect_outcome "$clean_pro" ok "clean prospective candidate"
[ "$(json_field "$clean_pro" "r.changedPaths.length")" = "0" ]
[ "$(json_field "$clean_pro" "r.commitSubjectSuffix")" = "null" ]
[ "$(json_field "$clean_pro" "r.metadata.target")" = "prospective_merge" ]
[ "$(json_field "$clean_pro" "r.metadata.candidate_commit")" = "$pro_candidate" ]
[ "$(json_field "$clean_pro" "r.metadata.reviewed_head")" = "$pro_head" ]
[ ! -e "$repoPro/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoPro/docs/handoffs/handoff-006.md" ]
[ -z "$(git -C "$repoPro" status --porcelain)" ]
[ "$(git -C "$repoPro" rev-parse HEAD)" = "$pro_candidate" ]
echo "clean prospective candidate passes read-only: OK"

# Every candidate identity mismatch fails closed before scanning, with no
# record, no changed path, no commit subject, and an untouched checkout.
prospective_identity_case() { # <label> <expected-substring> <event-file> <expected-outcome> <event-id>
  local result
  result=$(run_hook "$3" "$5")
  expect_outcome "$result" "$4" "$1"
  if [ "$(json_field "$result" "r.summary.includes('$2')")" != "true" ]; then
    echo "$1: refusal did not name '$2': $result" >&2
    exit 1
  fi
  [ "$(json_field "$result" "r.changedPaths.length")" = "0" ]
  [ "$(json_field "$result" "r.commitSubjectSuffix")" = "null" ]
  [ ! -e "$repoPro/.northstar/lifecycle/v1/tasks/g03.006.json" ]
  [ "$(git -C "$repoPro" status --porcelain)" = "" ]
  [ "$(git -C "$repoPro" rev-parse HEAD)" = "$pro_candidate" ]
}
# Declared tree is not the checkout tree.
write_prospective_event "$scratch/prospective-tree.json" "evt-prospective-treediff" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_base" "$pro_head" "$pro_candidate" \
  "4444444444444444444444444444444444444444" "docs/handoffs/handoff-006.md" "$IC" "$ID"
prospective_identity_case "candidate tree mismatch" "not the declared candidate tree" "$scratch/prospective-tree.json" failed "evt-prospective-treediff"
# Checkout HEAD is not the declared candidate commit.
write_prospective_event "$scratch/prospective-head.json" "evt-prospective-headdiff" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_base" "$pro_head" "$pro_head" "$pro_tree" \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
prospective_identity_case "candidate HEAD mismatch" "not the declared candidate commit" "$scratch/prospective-head.json" failed "evt-prospective-headdiff"
# Declared candidate is absent locally.
write_prospective_event "$scratch/prospective-absent.json" "evt-prospective-absent" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_base" "$pro_head" \
  "0000000000000000000000000000000000000000" "$pro_tree" "docs/handoffs/handoff-006.md" "$IC" "$ID"
prospective_identity_case "absent candidate commit" "is not present locally" "$scratch/prospective-absent.json" blocked "evt-prospective-absent"
# Declared base is not the integration base.
write_prospective_event "$scratch/prospective-base.json" "evt-prospective-basediff" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_head" "$pro_head" "$pro_candidate" "$pro_tree" \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
prospective_identity_case "integration base mismatch" "not the declared integration base" "$scratch/prospective-base.json" failed "evt-prospective-basediff"
# Delivery head is not the reviewed head.
write_prospective_event "$scratch/prospective-delivery.json" "evt-prospective-deliverydiff" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_base" "$pro_head" "$pro_candidate" "$pro_tree" \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$pro_base"
prospective_identity_case "delivery head mismatch" "not the declared reviewed head" "$scratch/prospective-delivery.json" failed "evt-prospective-deliverydiff"
# A missing delivery head refuses before scanning.
bun -e '
  const fs = await import("node:fs");
  const event = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  event.delivery.head = null;
  event.eventId = "evt-prospective-nohead";
  fs.writeFileSync(process.argv[2], JSON.stringify(event, null, 2) + "\n");
' "$scratch/prospective-clean.json" "$scratch/prospective-nohead.json"
prospective_identity_case "missing delivery head" "requires the delivery head" "$scratch/prospective-nohead.json" blocked "evt-prospective-nohead"
# Candidate parents in the wrong order refuse: merge main into the head.
git -C "$repoPro" checkout -qb reversed "$pro_head"
git -C "$repoPro" merge -q --no-ff main -m "reversed prospective merge"
pro_reversed=$(git -C "$repoPro" rev-parse HEAD)
pro_reversed_tree=$(git -C "$repoPro" rev-parse 'HEAD^{tree}')
[ "$(git -C "$repoPro" log -1 --format=%P HEAD)" = "$pro_head $pro_base" ]
git -C "$repoPro" checkout -q candidate
write_prospective_event "$scratch/prospective-order.json" "evt-prospective-order" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_base" "$pro_head" "$pro_reversed" "$pro_reversed_tree" \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
# The reversed checkout is the execution target for this one case.
CURRENT_REPO="$repoPro"
git -C "$repoPro" checkout -q reversed
order_out=$(run_hook "$scratch/prospective-order.json" "evt-prospective-order")
expect_outcome "$order_out" blocked "reversed candidate parents"
[ "$(json_field "$order_out" "r.summary.includes('parents in order')")" = "true" ]
[ "$(json_field "$order_out" "r.changedPaths.length")" = "0" ]
[ ! -e "$repoPro/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ "$(git -C "$repoPro" status --porcelain)" = "" ]
[ "$(git -C "$repoPro" rev-parse HEAD)" = "$pro_reversed" ]
git -C "$repoPro" checkout -q candidate
echo "candidate identity refusals: OK"

# Malformed v3 payloads never reach policy evaluation.
prospective_schema_case() { # <label> <expected-substring> <mutation-js>
  bun -e '
    const fs = await import("node:fs");
    const event = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    new Function("event", fs.readFileSync(process.argv[3], "utf8"))(event);
    event.eventId = "evt-prospective-malformed";
    fs.writeFileSync(process.argv[2], JSON.stringify(event, null, 2) + "\n");
  ' "$scratch/prospective-clean.json" "$scratch/prospective-malformed.json" "$3"
  local result
  result=$(run_hook "$scratch/prospective-malformed.json" "evt-prospective-malformed")
  expect_outcome "$result" failed "$1"
  if [ "$(json_field "$result" "r.summary.includes('not a valid paseo.queue.event.v3')")" != "true" ]; then
    echo "$1: refusal did not name the v3 schema: $result" >&2
    exit 1
  fi
  [ ! -e "$repoPro/.northstar/lifecycle/v1/tasks/g03.006.json" ]
  [ "$(git -C "$repoPro" status --porcelain)" = "" ]
}
printf 'event.repository.mergeCandidate.tree = "abc";' > "$scratch/mut-short-id.js"
printf 'event.repository.mergeCandidate.base = event.repository.mergeCandidate.integrationBase;' > "$scratch/mut-extra-field.js"
printf 'delete event.repository.mergeCandidate;' > "$scratch/mut-no-candidate.js"
printf 'event.event = "task.closeout";' > "$scratch/mut-other-event.js"
prospective_schema_case "short candidate id" "v3" "$scratch/mut-short-id.js"
prospective_schema_case "extra candidate field" "v3" "$scratch/mut-extra-field.js"
prospective_schema_case "missing candidate" "v3" "$scratch/mut-no-candidate.js"
prospective_schema_case "v3 on another event" "v3" "$scratch/mut-other-event.js"
echo "malformed v3 payload refusals: OK"

# Wrong schema/target pairs fail closed on both sides of the version cut.
cat > "$scratch/prospective-v2.json" <<EOF
{
  "schema": "$EVENT_SCHEMA_V2",
  "eventId": "evt-prospective-v2pair",
  "hookId": "candidate-pre-merge",
  "event": "task.pre_merge",
  "occurredAt": "2026-09-15T08:00:00.000Z",
  "attempt": 1,
  "repository": {"root": "$CURRENT_REPO", "baseBranch": "feature", "baseCommit": "$pro_head", "target": "reviewed_head"},
  "task": {"id": "q-006", "title": "Implement g03.006 fixture task", "phase": "review",
    "instruction": {"path": "docs/handoffs/handoff-006.md", "commit": "$IC", "digest": "sha256:$ID", "mediaType": "text/markdown"}},
  "delivery": {"prUrl": "https://github.com/example/repo/pull/53", "prNumber": 53, "head": "$pro_head", "review": "approved at head", "mergeCommit": null, "integrationCommit": null, "summary": "independent review accepted"}
}
EOF
v2pair=$(run_hook "$scratch/prospective-v2.json" "evt-prospective-v2pair")
expect_outcome "$v2pair" blocked "v2 event at the prospective binding"
[ "$(json_field "$v2pair" "r.summary.includes('requires event schema paseo.queue.event.v3')")" = "true" ]
[ ! -e "$repoPro/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ "$(git -C "$repoPro" status --porcelain)" = "" ]
CURRENT_REPO="$repoPre"
bun -e '
  const fs = await import("node:fs");
  const event = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  event.hookId = "repository-pre-merge";
  event.repository.root = process.argv[3];
  event.eventId = "evt-prospective-v3pair";
  fs.writeFileSync(process.argv[2], JSON.stringify(event, null, 2) + "\n");
' "$scratch/prospective-clean.json" "$scratch/prospective-v3pair.json" "$repoPre"
v3pair=$(run_hook "$scratch/prospective-v3pair.json" "evt-prospective-v3pair")
expect_outcome "$v3pair" failed "v3 event at the reviewed-head binding"
[ "$(json_field "$v3pair" "r.summary.includes('does not target the reviewed head')")" = "true" ]
CURRENT_REPO="$repoPro"
[ -z "$(git -C "$repoPre" status --porcelain)" ]
[ -z "$(git -C "$repoPro" status --porcelain)" ]
echo "schema/target pair refusals: OK"

# The prospective binding keeps the read-only correlation: write mode, mixed
# events, advisory delivery, and a pre-v4 manifest each refuse before scanning.
cp "$repoPro/.paseo/queue.json" "$scratch/prospective-manifest-saved.json"
prospective_binding_case() { # <label> <expected-substring> <mutation-js-file>
  cp "$scratch/prospective-manifest-saved.json" "$repoPro/.paseo/queue.json"
  bun -e '
    const fs = await import("node:fs");
    const mutation = fs.readFileSync(process.argv[3], "utf8");
    const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    const hook = manifest.hooks.find((entry) => entry.id === "candidate-pre-merge");
    new Function("hook", "manifest", mutation)(hook, manifest);
    fs.writeFileSync(process.argv[2], JSON.stringify(manifest, null, 2) + "\n");
  ' "$scratch/prospective-manifest-saved.json" "$repoPro/.paseo/queue.json" "$3"
  local result
  result=$(run_hook "$scratch/prospective-clean.json" "evt-prospective-clean-0001")
  expect_outcome "$result" blocked "$1"
  if [ "$(json_field "$result" "r.summary.includes('$2')")" != "true" ]; then
    echo "$1: refusal did not name '$2': $result" >&2
    exit 1
  fi
}
printf 'hook.mode = "integration_write"; hook.commitSubject = { prefix: "lifecycle", maxBytes: 60 };' > "$scratch/mut-pro-mode.js"
printf 'hook.events = ["task.pre_merge", "task.closeout"];' > "$scratch/mut-pro-events.js"
printf 'hook.delivery = "advisory";' > "$scratch/mut-pro-delivery.js"
printf 'manifest.schema = "paseo.queue.control.v3";' > "$scratch/mut-pro-downgrade.js"
prospective_binding_case "prospective write mode" "accepts only read_only hooks" "$scratch/mut-pro-mode.js"
prospective_binding_case "prospective mixed events" "must be the only event" "$scratch/mut-pro-events.js"
prospective_binding_case "prospective advisory delivery" "requires required delivery" "$scratch/mut-pro-delivery.js"
prospective_binding_case "prospective target on a v3 manifest" "not a valid paseo.queue.control.v3" "$scratch/mut-pro-downgrade.js"
cp "$scratch/prospective-manifest-saved.json" "$repoPro/.paseo/queue.json"
[ -z "$(git -C "$repoPro" status --porcelain)" ]
echo "prospective binding refusals: OK"

# A durable exact backlink in the candidate tree refuses read-only with the
# same resolver message the closeout and reviewed-head gates produce.
git -C "$repoPro" checkout -q feature
cat > "$repoPro/docs/implementation-log.md" <<'EOF'
# Implementation log

Dispatched from [the worker handoff](handoffs/handoff-006.md).
EOF
git -C "$repoPro" add -A
git -C "$repoPro" commit -qm "durable log links the submitted handoff"
pro_head2=$(git -C "$repoPro" rev-parse feature)
git -C "$repoPro" checkout -qb candidate2 main
git -C "$repoPro" merge -q --no-ff feature -m "prospective merge of the linked head"
pro_candidate2=$(git -C "$repoPro" rev-parse HEAD)
pro_tree2=$(git -C "$repoPro" rev-parse 'HEAD^{tree}')
git -C "$repoPro" checkout -q candidate2
pro_log_digest=$(sha256sum "$repoPro/docs/implementation-log.md" | cut -d' ' -f1)
write_prospective_event "$scratch/prospective-backlink.json" "evt-prospective-backlink-0001" "candidate-pre-merge" \
  "q-006" '"Implement g03.006 fixture task"' "$pro_base" "$pro_base" "$pro_head2" "$pro_candidate2" "$pro_tree2" \
  "docs/handoffs/handoff-006.md" "$IC" "$ID"
blocked_pro=$(run_hook "$scratch/prospective-backlink.json" "evt-prospective-backlink-0001")
expect_outcome "$blocked_pro" blocked "prospective backlink"
[ "$(json_field "$blocked_pro" "r.summary.includes('docs/implementation-log.md')")" = "true" ]
[ "$(json_field "$blocked_pro" "r.changedPaths.length")" = "0" ]
[ "$(json_field "$blocked_pro" "r.commitSubjectSuffix")" = "null" ]
[ "$(json_field "$blocked_pro" "r.summary")" = "$(json_field "$backlink_out" "r.summary")" ]
[ ! -e "$repoPro/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoPro/docs/handoffs/handoff-006.md" ]
[ -z "$(git -C "$repoPro" status --porcelain)" ]
[ "$(git -C "$repoPro" rev-parse HEAD)" = "$pro_candidate2" ]
[ "$pro_log_digest" = "$(sha256sum "$repoPro/docs/implementation-log.md" | cut -d' ' -f1)" ]
echo "durable prospective backlink refuses read-only with the shared message: OK"

# Pre-g01.020 repositories keep their prior lifecycle behavior. A v2 manifest
# and a v3 manifest without the pre-merge binding both close out unchanged and
# cannot declare the reviewed-head event.
echo "# manifests without the pre-merge binding keep prior lifecycle behavior"
repoCompatV2="$scratch/repo-compat-v2"
build_fixture "$repoCompatV2"
cp "$scratch/derived-v2-manifest.json" "$repoCompatV2/.paseo/queue.json"
git -C "$repoCompatV2" add -A
git -C "$repoCompatV2" commit -qm "install the pre-g01.020 v2 manifest"
CURRENT_REPO="$repoCompatV2"
read_facts "$(fixture_facts "$repoCompatV2" 006)"
write_event "$scratch/closeout-v2.json" "evt-closeout-v2-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
compat_v2=$(run_hook "$scratch/closeout-v2.json" "evt-closeout-v2-0001")
expect_outcome "$compat_v2" ok "v2 closeout"
[ ! -e "$repoCompatV2/docs/handoffs/handoff-006.md" ]
[ -f "$repoCompatV2/.northstar/lifecycle/v1/tasks/g03.006.json" ]
write_premerge_event "$scratch/premerge-v2.json" "evt-premerge-v2-0001" "q-007" '"Implement g03.007 fixture task"' "$FH" "docs/handoffs/handoff-007.md" "$IC" "$ID"
compat_premerge=$(run_hook "$scratch/premerge-v2.json" "evt-premerge-v2-0001")
expect_outcome "$compat_premerge" blocked "v2 manifest has no pre-merge binding"
[ "$(json_field "$compat_premerge" "r.summary.includes('not declared in the control manifest')")" = "true" ]

repoCompatV3="$scratch/repo-compat-v3"
build_fixture "$repoCompatV3"
cp "$scratch/derived-v3-no-premerge.json" "$repoCompatV3/.paseo/queue.json"
git -C "$repoCompatV3" add -A
git -C "$repoCompatV3" commit -qm "install a v3 manifest without the pre-merge binding"
CURRENT_REPO="$repoCompatV3"
read_facts "$(fixture_facts "$repoCompatV3" 006)"
write_event "$scratch/closeout-v3nopre.json" "evt-closeout-v3nopre-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
compat_v3=$(run_hook "$scratch/closeout-v3nopre.json" "evt-closeout-v3nopre-0001")
expect_outcome "$compat_v3" ok "v3 manifest without pre-merge"
[ ! -e "$repoCompatV3/docs/handoffs/handoff-006.md" ]
[ -f "$repoCompatV3/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "old-manifest compatibility: OK"

echo "# large Markdown backlink scan bounds"
write_markdown_filler() { # <path> <byte-count>
  dd if=/dev/zero bs=1 count="$2" 2>/dev/null | tr '\0' 'x' > "$1"
  printf '\n' >> "$1"
}
write_sparse_markdown() { # <path> <byte-count>
  truncate -s "$2" "$1"
}

repoLargeClean="$scratch/repo-large-clean"
build_fixture "$repoLargeClean"
mkdir -p "$repoLargeClean/docs"
write_markdown_filler "$repoLargeClean/docs/large-ledger.md" 300000
git -C "$repoLargeClean" add -A
git -C "$repoLargeClean" commit -qm "add large clean Markdown ledger"
CURRENT_REPO="$repoLargeClean"
read_facts "$(fixture_facts "$repoLargeClean" 006)"
write_event "$scratch/closeout-large-clean.json" "evt-closeout-large-clean-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
large_clean_out=$(run_hook "$scratch/closeout-large-clean.json" "evt-closeout-large-clean-0001")
expect_outcome "$large_clean_out" ok "large clean Markdown"
[ ! -e "$repoLargeClean/docs/handoffs/handoff-006.md" ]
[ -f "$repoLargeClean/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -z "$(git -C "$repoLargeClean" diff --cached)" ]
echo "large clean Markdown scans successfully: OK"

repoLargeLink="$scratch/repo-large-link"
build_fixture "$repoLargeLink"
mkdir -p "$repoLargeLink/docs"
write_markdown_filler "$repoLargeLink/docs/large-ledger.md" 300000
printf '\nSee [the handoff](handoffs/handoff-006.md).\n' >> "$repoLargeLink/docs/large-ledger.md"
git -C "$repoLargeLink" add -A
git -C "$repoLargeLink" commit -qm "add large linked Markdown ledger"
CURRENT_REPO="$repoLargeLink"
read_facts "$(fixture_facts "$repoLargeLink" 006)"
write_event "$scratch/closeout-large-link.json" "evt-closeout-large-link-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
large_link_handoff_digest=$(sha256sum "$repoLargeLink/docs/handoffs/handoff-006.md" | cut -d' ' -f1)
large_link_ledger_digest=$(sha256sum "$repoLargeLink/docs/large-ledger.md" | cut -d' ' -f1)
large_link_readme_digest=$(sha256sum "$repoLargeLink/docs/README.md" | cut -d' ' -f1)
large_link_out=$(run_hook "$scratch/closeout-large-link.json" "evt-closeout-large-link-0001")
expect_outcome "$large_link_out" blocked "large linked Markdown"
[ "$(json_field "$large_link_out" "r.summary.includes('docs/large-ledger.md')")" = "true" ]
[ ! -e "$repoLargeLink/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoLargeLink/docs/handoffs/handoff-006.md" ]
[ "$large_link_handoff_digest" = "$(sha256sum "$repoLargeLink/docs/handoffs/handoff-006.md" | cut -d' ' -f1)" ]
[ "$large_link_ledger_digest" = "$(sha256sum "$repoLargeLink/docs/large-ledger.md" | cut -d' ' -f1)" ]
[ "$large_link_readme_digest" = "$(sha256sum "$repoLargeLink/docs/README.md" | cut -d' ' -f1)" ]
[ -z "$(git -C "$repoLargeLink" status --porcelain)" ]
echo "large exact-link refusal is atomic: OK"

echo "# aggregate Markdown scan bounds"
repoBovineShape="$scratch/repo-bovine-shaped"
build_fixture "$repoBovineShape"
mkdir -p "$repoBovineShape/docs/bovine"
bovine_existing=$(git -C "$repoBovineShape" ls-files -- '*.md' | wc -l | tr -d ' ')
bovine_needed=$((18190 - bovine_existing))
for number in $(seq -w 1 "$bovine_needed"); do
  write_sparse_markdown "$repoBovineShape/docs/bovine/file-$number.md" 2160
done
git -C "$repoBovineShape" add -A
git -C "$repoBovineShape" commit -qm "add Bovine-shaped Markdown set"
bovine_files=$(git -C "$repoBovineShape" ls-files -- '*.md' | wc -l | tr -d ' ')
[ "$bovine_files" = 18190 ]
CURRENT_REPO="$repoBovineShape"
read_facts "$(fixture_facts "$repoBovineShape" 006)"
write_event "$scratch/closeout-bovine-shaped.json" "evt-closeout-bovine-shaped-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
bovine_out=$(run_hook "$scratch/closeout-bovine-shaped.json" "evt-closeout-bovine-shaped-0001")
expect_outcome "$bovine_out" ok "Bovine-shaped aggregate Markdown set"
[ ! -e "$repoBovineShape/docs/handoffs/handoff-006.md" ]
[ -f "$repoBovineShape/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "Bovine-shaped Markdown set ($bovine_files files, roughly 37.5 MiB) scans successfully: OK"

repoCountOverflow="$scratch/repo-count-overflow"
build_fixture "$repoCountOverflow"
mkdir -p "$repoCountOverflow/docs/count-overflow"
count_existing=$(git -C "$repoCountOverflow" ls-files -- '*.md' | wc -l | tr -d ' ')
count_needed=$((25001 - count_existing))
for number in $(seq -w 1 "$count_needed"); do
  printf '# Count overflow fixture %s\n' "$number" > "$repoCountOverflow/docs/count-overflow/file-$number.md"
done
git -C "$repoCountOverflow" add -A
git -C "$repoCountOverflow" commit -qm "add over-count Markdown set"
count_files=$(git -C "$repoCountOverflow" ls-files -- '*.md' | wc -l | tr -d ' ')
[ "$count_files" = 25001 ]
CURRENT_REPO="$repoCountOverflow"
read_facts "$(fixture_facts "$repoCountOverflow" 006)"
write_event "$scratch/closeout-count-overflow.json" "evt-closeout-count-overflow-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
count_out=$(run_hook "$scratch/closeout-count-overflow.json" "evt-closeout-count-overflow-0001")
expect_outcome "$count_out" ok "over-count Markdown set"
[ ! -e "$repoCountOverflow/docs/handoffs/handoff-006.md" ]
[ -f "$repoCountOverflow/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "over-count Markdown set ($count_files files) passes with a bounded hit set: OK"

repoAggregateOverflow="$scratch/repo-aggregate-overflow"
build_fixture "$repoAggregateOverflow"
mkdir -p "$repoAggregateOverflow/docs/aggregate-overflow"
for number in $(seq -w 1 129); do
  write_sparse_markdown "$repoAggregateOverflow/docs/aggregate-overflow/file-$number.md" $((1024 * 1024))
done
git -C "$repoAggregateOverflow" add -A
git -C "$repoAggregateOverflow" commit -qm "add over-aggregate Markdown set"
CURRENT_REPO="$repoAggregateOverflow"
read_facts "$(fixture_facts "$repoAggregateOverflow" 006)"
write_event "$scratch/closeout-aggregate-overflow.json" "evt-closeout-aggregate-overflow-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
aggregate_out=$(run_hook "$scratch/closeout-aggregate-overflow.json" "evt-closeout-aggregate-overflow-0001")
expect_outcome "$aggregate_out" ok "over-aggregate Markdown set"
[ ! -e "$repoAggregateOverflow/docs/handoffs/handoff-006.md" ]
[ -f "$repoAggregateOverflow/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "over-aggregate Markdown set (more than 128 MiB) passes with a bounded hit set: OK"

for file in "$repoAggregateOverflow"/docs/aggregate-overflow/*.md; do
  printf '\nhandoff-006.md\n' >> "$file"
done
git -C "$repoAggregateOverflow" add -A
git -C "$repoAggregateOverflow" commit -qm "make aggregate corpus a backlink hit set"
bun -e '
  const { findHandoffBacklinks, BacklinkError } = await import(process.argv[1]);
  try {
    findHandoffBacklinks(process.argv[2], "docs/handoffs/handoff-006.md");
    throw new Error("oversized hit aggregate passed");
  } catch (error) {
    if (!(error instanceof BacklinkError) || error.outcome !== "blocked" || !error.message.includes("aggregate Markdown size")) throw error;
  }
' "$source_skill/scripts/lifecycle-backlink.ts" "$repoAggregateOverflow"
echo "over-aggregate backlink hit set refuses before parsing: OK"

echo "# tracked listing transport bound"
make_long_path() {
  local character=$1 count=$2
  printf '%*s' "$count" '' | tr ' ' "$character"
}

repoLargeListing="$scratch/repo-large-listing"
build_fixture "$repoLargeListing"
listing_prefix="$repoLargeListing/docs/$(make_long_path x 200)/$(make_long_path y 200)"
mkdir -p "$listing_prefix"
for number in $(seq -w 1 4000); do
  printf '# Listing fixture %s\n' "$number" > "$listing_prefix/file-$number.md"
done
git -C "$repoLargeListing" add -A
git -C "$repoLargeListing" commit -qm "add large tracked Markdown listing"
listing_bytes=$(git -C "$repoLargeListing" ls-files -z | wc -c | tr -d ' ')
if [ "$listing_bytes" -le $((1024 * 1024)) ] || [ "$listing_bytes" -ge $((4 * 1024 * 1024)) ]; then
  echo "fixture listing is not between 1 MiB and 4 MiB: $listing_bytes" >&2
  exit 1
fi
CURRENT_REPO="$repoLargeListing"
read_facts "$(fixture_facts "$repoLargeListing" 006)"
write_event "$scratch/closeout-large-listing.json" "evt-closeout-large-listing-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
large_listing_out=$(run_hook "$scratch/closeout-large-listing.json" "evt-closeout-large-listing-0001")
expect_outcome "$large_listing_out" ok "large tracked listing"
[ ! -e "$repoLargeListing/docs/handoffs/handoff-006.md" ]
[ -f "$repoLargeListing/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "large tracked listing ($listing_bytes bytes) scans successfully: OK"

repoOverflowListing="$scratch/repo-overflow-listing"
build_fixture "$repoOverflowListing"
overflow_prefix="$repoOverflowListing/docs/$(make_long_path a 210)/$(make_long_path b 210)/$(make_long_path c 210)/$(make_long_path d 210)"
mkdir -p "$overflow_prefix"
for number in $(seq -w 1 5000); do
  printf '# Overflow fixture %s\n' "$number" > "$overflow_prefix/file-$number.md"
done
git -C "$repoOverflowListing" add -A
git -C "$repoOverflowListing" commit -qm "add over-cap tracked Markdown listing"
overflow_bytes=$(git -C "$repoOverflowListing" ls-files -z | wc -c | tr -d ' ')
if [ "$overflow_bytes" -le $((4 * 1024 * 1024)) ]; then
  echo "fixture listing does not exceed 4 MiB: $overflow_bytes" >&2
  exit 1
fi
CURRENT_REPO="$repoOverflowListing"
read_facts "$(fixture_facts "$repoOverflowListing" 006)"
write_event "$scratch/closeout-overflow-listing.json" "evt-closeout-overflow-listing-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
overflow_out=$(run_hook "$scratch/closeout-overflow-listing.json" "evt-closeout-overflow-listing-0001")
expect_outcome "$overflow_out" ok "over-cap tracked listing"
[ ! -e "$repoOverflowListing/docs/handoffs/handoff-006.md" ]
[ -f "$repoOverflowListing/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "over-cap tracked listing ($overflow_bytes bytes) passes with a bounded hit set: OK"

fake_git_dir="$scratch/fake-git"
mkdir -p "$fake_git_dir"
real_git=$(command -v git)
cat > "$fake_git_dir/git" <<EOF
#!/usr/bin/env bash
if [ "\$1" = "grep" ]; then
  echo "synthetic backlink prefilter failure" >&2
  exit 73
fi
exec "$real_git" "\$@"
EOF
chmod +x "$fake_git_dir/git"
CURRENT_REPO="$repoLargeLink"
git_failure_out=$(PATH="$fake_git_dir:$PATH" run_hook "$scratch/closeout-large-link.json" "evt-closeout-large-link-0001")
expect_outcome "$git_failure_out" failed "non-zero backlink prefilter"
json_field "$git_failure_out" "r.summary.includes('exit status 73')" >/dev/null
json_field "$git_failure_out" "r.summary.includes('stderr synthetic backlink prefilter failure')" >/dev/null
echo "non-zero backlink prefilter reports exit and stderr evidence: OK"

cat > "$fake_git_dir/git" <<EOF
#!/usr/bin/env bash
if [ "\$1" = "grep" ]; then
  for number in \$(seq 1 25001); do printf 'docs/hit-%s.md\\0' "\$number"; done
  exit 0
fi
exec "$real_git" "\$@"
EOF
chmod +x "$fake_git_dir/git"
hit_count_out=$(PATH="$fake_git_dir:$PATH" run_hook "$scratch/closeout-large-link.json" "evt-closeout-large-link-0001")
expect_outcome "$hit_count_out" blocked "over-count backlink hit set"
[ "$(json_field "$hit_count_out" "r.summary.includes('25000-file bound')")" = "true" ]
[ ! -e "$repoLargeLink/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoLargeLink/docs/handoffs/handoff-006.md" ]
echo "over-count backlink hit set refuses atomically: OK"

repoOversized="$scratch/repo-oversized"
build_fixture "$repoOversized"
mkdir -p "$repoOversized/docs"
write_markdown_filler "$repoOversized/docs/oversized-ledger.md" $((4 * 1024 * 1024 + 1))
printf '\nSee handoff-006.md in this oversized hit.\n' >> "$repoOversized/docs/oversized-ledger.md"
git -C "$repoOversized" add -A
git -C "$repoOversized" commit -qm "add oversized Markdown ledger"
CURRENT_REPO="$repoOversized"
read_facts "$(fixture_facts "$repoOversized" 006)"
write_event "$scratch/closeout-oversized.json" "evt-closeout-oversized-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
oversized_handoff_digest=$(sha256sum "$repoOversized/docs/handoffs/handoff-006.md" | cut -d' ' -f1)
oversized_readme_digest=$(sha256sum "$repoOversized/docs/README.md" | cut -d' ' -f1)
oversized_out=$(run_hook "$scratch/closeout-oversized.json" "evt-closeout-oversized-0001")
expect_outcome "$oversized_out" blocked "oversized Markdown"
[ "$(json_field "$oversized_out" "r.summary.includes('oversized Markdown file docs/oversized-ledger.md')")" = "true" ]
[ ! -e "$repoOversized/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -e "$repoOversized/docs/handoffs/handoff-006.md" ]
[ "$oversized_handoff_digest" = "$(sha256sum "$repoOversized/docs/handoffs/handoff-006.md" | cut -d' ' -f1)" ]
[ "$oversized_readme_digest" = "$(sha256sum "$repoOversized/docs/README.md" | cut -d' ' -f1)" ]
[ -z "$(git -C "$repoOversized" status --porcelain)" ]
echo "above-4-MiB Markdown refusal is atomic: OK"

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

echo "# the frozen route runs from a minimal environment"
minimal_out=$(cd "$repoA" && env -i HOME="$installed_home" PATH="$PATH" TMPDIR="${TMPDIR:-/tmp}" \
  PASEO_QUEUE_EVENT_ID="evt-closeout-a-0001" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
  effigy "${FROZEN_ARGV[@]}" < "$scratch/closeout-a.json")
expect_outcome "$minimal_out" ok "minimal-env replay"
[ "$(json_field "$minimal_out" "r.changedPaths.length")" = "0" ]
echo "minimal-environment route: OK"

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

echo "# parallel active-generation closeout publishes both generations"
repoP="$scratch/repo-parallel"
build_fixture "$repoP"
mkdir -p "$repoP/docs/roadmaps/g04"
printf '# Task g04.010\n\nOwner: fixture\n' > "$repoP/docs/roadmaps/g04/010-parallel-task.md"
printf '# g04\n\nHuman parallel generation runway stays.\n' > "$repoP/docs/roadmaps/g04/README.md"
git -C "$repoP" add -A
git -C "$repoP" commit -qm "plan g04.010"
cat > "$repoP/docs/handoffs/handoff-010.md" <<'EOF'
---
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
---

## Current State

- Ready task: [`g04.010`](../roadmaps/g04/010-parallel-task.md)
EOF
git -C "$repoP" add -A
git -C "$repoP" commit -qm "handoff for g04.010"
# Declare the already-authorized parallel mode: both generations join the
# active set and the g04 README joins the currentness targets.
bun -e '
  const fs = await import("node:fs");
  const file = process.argv[1];
  const config = JSON.parse(fs.readFileSync(file, "utf8"));
  delete config.active_generation;
  config.active_generations = ["g03", "g04"];
  config.targets.push("docs/roadmaps/g04/README.md");
  fs.writeFileSync(file, JSON.stringify(config, null, 2) + "\n");
' "$repoP/.northstar/lifecycle/v1/projection-targets.json"
git -C "$repoP" add -A
git -C "$repoP" commit -qm "declare parallel active generations"

CURRENT_REPO="$repoP"
ic010=$(git -C "$repoP" log -1 --format=%H -- docs/handoffs/handoff-010.md)
id010=$(git -C "$repoP" show "main:docs/handoffs/handoff-010.md" | sha256sum | cut -d' ' -f1)
mcP=$(git -C "$repoP" rev-parse main)
fhP=$(git -C "$repoP" rev-parse feature)
write_event "$scratch/closeout-parallel.json" "evt-closeout-parallel-0001" "task.closeout" "lifecycle-state" "$mcP" \
  "q-010" '"Implement g04.010 parallel fixture task"' \
  "docs/handoffs/handoff-010.md" "$ic010" "$id010" "$(closeout_delivery "$fhP" "$mcP")"
parallel=$(run_hook "$scratch/closeout-parallel.json" "evt-closeout-parallel-0001")
expect_outcome "$parallel" ok "parallel closeout"
[ "$(json_field "$parallel" "r.metadata.revision")" = "8" ]
[ "$(json_field "$parallel" "r.commitSubjectSuffix")" = "g04.010 terminal record" ]
for target in docs/README.md docs/roadmaps/README.md docs/roadmaps/g04/README.md; do
  grep -q "Human" "$repoP/$target"
  grep -q "| g03 | open | planning_required |" "$repoP/$target"
  grep -q "| g04 | open | planning_required |" "$repoP/$target"
  g03_row=$(grep -n "| g03 | open | planning_required |" "$repoP/$target" | head -1 | cut -d: -f1)
  g04_row=$(grep -n "| g04 | open | planning_required |" "$repoP/$target" | head -1 | cut -d: -f1)
  [ "$g03_row" -lt "$g04_row" ]
  grep -q "| g04.010 | complete | none |" "$repoP/$target"
  if grep -q "| g03.006 |" "$repoP/$target"; then
    echo "parallel projection leaked an untracked g03 record into $target" >&2
    exit 1
  fi
done
[ ! -e "$repoP/docs/handoffs/handoff-010.md" ]
[ -f "$repoP/.northstar/lifecycle/v1/tasks/g04.010.json" ]
[ -z "$(git -C "$repoP" diff --cached)" ]
echo "parallel active-generation closeout: OK"

retry_parallel=$(run_hook "$scratch/closeout-parallel.json" "evt-closeout-parallel-0001")
expect_outcome "$retry_parallel" ok "parallel closeout replay"
[ "$(json_field "$retry_parallel" "r.changedPaths.length")" = "0" ]
echo "parallel closeout replay is a no-diff no-op: OK"

echo "# a generation outside the declared set is refused"
repoO="$scratch/repo-outside"
build_fixture "$repoO"
mkdir -p "$repoO/docs/roadmaps/g05"
printf '# Task g05.011\n\nOwner: fixture\n' > "$repoO/docs/roadmaps/g05/011-outside-task.md"
cat > "$repoO/docs/handoffs/handoff-011.md" <<'EOF'
---
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
---

## Current State

- Ready task: [`g05.011`](../roadmaps/g05/011-outside-task.md)
EOF
git -C "$repoO" add -A
git -C "$repoO" commit -qm "plan out-of-set g05.011"
CURRENT_REPO="$repoO"
ic011=$(git -C "$repoO" log -1 --format=%H -- docs/handoffs/handoff-011.md)
id011=$(git -C "$repoO" show "main:docs/handoffs/handoff-011.md" | sha256sum | cut -d' ' -f1)
mcO=$(git -C "$repoO" rev-parse main)
fhO=$(git -C "$repoO" rev-parse feature)
write_event "$scratch/closeout-outside.json" "evt-closeout-outside-0001" "task.closeout" "lifecycle-state" "$mcO" \
  "q-011" '"Implement g05.011 outside fixture task"' \
  "docs/handoffs/handoff-011.md" "$ic011" "$id011" "$(closeout_delivery "$fhO" "$mcO")"
outside=$(run_hook "$scratch/closeout-outside.json" "evt-closeout-outside-0001")
expect_outcome "$outside" blocked "out-of-set closeout"
json_field "$outside" "r.summary.includes('not in the declared active-generation set')" >/dev/null
[ ! -e "$repoO/.northstar/lifecycle/v1/tasks/g05.011.json" ]
[ -e "$repoO/docs/handoffs/handoff-011.md" ]
[ -z "$(git -C "$repoO" status --porcelain)" ]
echo "out-of-set generation refusal: OK"

echo "# parallel configuration union negatives fail the hook closed"
repoU="$scratch/repo-union"
build_fixture "$repoU"
CURRENT_REPO="$repoU"
read_facts "$(fixture_facts "$repoU" 006)"
union_case() { # <name> <config-json> <message-fragment>
  printf '%s\n' "$2" > "$repoU/.northstar/lifecycle/v1/projection-targets.json"
  write_event "$scratch/closeout-union.json" "evt-closeout-union-0001" "task.closeout" "lifecycle-state" "$MC" \
    "q-006" '"Implement g03.006 fixture task"' \
    "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
  local result
  result=$(run_hook "$scratch/closeout-union.json" "evt-closeout-union-0001")
  expect_outcome "$result" blocked "$1"
  if ! json_field "$result" "r.summary.includes('$3')" >/dev/null; then
    echo "$1: refusal missed '$3': $result" >&2
    exit 1
  fi
  git -C "$repoU" checkout -q -- .northstar/lifecycle/v1/projection-targets.json
  [ -z "$(git -C "$repoU" status --porcelain)" ]
}
union_case "mixed singular and plural keys" \
  '{"schema_version":"northstar.lifecycle.projection-targets.v2","targets":["docs/README.md"],"active_generation":"g03","active_generations":["g03"]}' \
  "exactly one"
union_case "neither key" \
  '{"schema_version":"northstar.lifecycle.projection-targets.v2","targets":["docs/README.md"]}' \
  "neither key"
union_case "empty parallel set" \
  '{"schema_version":"northstar.lifecycle.projection-targets.v2","targets":["docs/README.md"],"active_generations":[]}' \
  "1-16 gNN generations"
union_case "unsorted parallel set" \
  '{"schema_version":"northstar.lifecycle.projection-targets.v2","targets":["docs/README.md"],"active_generations":["g11","g03"]}' \
  "lexical order"
union_case "duplicate parallel set" \
  '{"schema_version":"northstar.lifecycle.projection-targets.v2","targets":["docs/README.md"],"active_generations":["g03","g03"]}' \
  "duplicate active generations"
echo "parallel configuration union negatives: OK"

echo "# resolution precedence and fail-closed behavior"
# A hostile global installation supplies a fake adapter that claims success
# without consuming the handoff. The project-local install must win.
hostile_home="$scratch/hostile-home"
for base in "$hostile_home/.agents/skills/northstar" "$hostile_home/.pi/agent/skills/northstar"; do
  mkdir -p "$base/scripts"
  cat > "$base/scripts/lifecycle-queue-hook.ts" <<'EOF'
// Hostile stale adapter: it claims success without consuming the handoff and
// records that it ran, so any resolution of this file instead of the
// project-local skill is observable.
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
mkdir -p "$repoE/.agents/skills"
rsync -a --delete "$source_skill/" "$repoE/.agents/skills/northstar/"
CURRENT_REPO="$repoE"
read_facts "$(fixture_facts "$repoE" 006)"
write_event "$scratch/closeout-hostile.json" "evt-closeout-hostile-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
hostile_out=$(cd "$repoE" && env -i HOME="$hostile_home" PATH="$PATH" TMPDIR="${TMPDIR:-/tmp}" \
  PASEO_QUEUE_EVENT_ID="evt-closeout-hostile-0001" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
  effigy "${FROZEN_ARGV[@]}" < "$scratch/closeout-hostile.json")
expect_outcome "$hostile_out" ok "project-local precedence"
if [ "$(json_field "$hostile_out" "r.summary.includes('hostile')")" != "false" ]; then
  echo "hostile global installation supplied the executed adapter" >&2
  exit 1
fi
[ "$(json_field "$hostile_out" "r.metadata.handoff_consumed")" = "true" ]
[ ! -e "$repoE/hostile-global-adapter-ran.marker" ]
[ ! -e "$repoE/docs/handoffs/handoff-006.md" ]
[ -f "$repoE/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "project-local precedence over hostile global install: OK"

# A unique global install is the fallback when no project-local copy exists.
repoG="$scratch/repo-global"
build_fixture "$repoG"
CURRENT_REPO="$repoG"
read_facts "$(fixture_facts "$repoG" 006)"
write_event "$scratch/closeout-global.json" "evt-closeout-global-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
global_out=$(run_hook "$scratch/closeout-global.json" "evt-closeout-global-0001")
expect_outcome "$global_out" ok "unique global fallback"
[ "$(json_field "$global_out" "r.metadata.handoff_consumed")" = "true" ]
echo "unique global fallback: OK"

# Two distinct global installs are ambiguous and fail closed.
ambiguous_home="$scratch/ambiguous-home"
mkdir -p "$ambiguous_home/.agents/skills" "$ambiguous_home/.claude/skills"
rsync -a --delete "$source_skill/" "$ambiguous_home/.agents/skills/northstar/"
rsync -a --delete "$source_skill/" "$ambiguous_home/.claude/skills/northstar/"
repoH="$scratch/repo-ambiguous"
build_fixture "$repoH"
CURRENT_REPO="$repoH"
read_facts "$(fixture_facts "$repoH" 006)"
if run_hook "$scratch/closeout-global.json" "evt-ambiguous-0001" "$ambiguous_home" > "$scratch/ambiguous.out" 2>&1; then
  echo "ambiguous global skill resolution succeeded" >&2
  exit 1
fi
grep -q "ambiguous" "$scratch/ambiguous.out"
[ ! -e "$repoH/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -z "$(git -C "$repoH" status --porcelain)" ]
echo "ambiguous global install fails closed: OK"

# A missing skill fails closed before any effect.
empty_home="$scratch/empty-home"
mkdir -p "$empty_home"
repoM="$scratch/repo-missing-skill"
build_fixture "$repoM"
CURRENT_REPO="$repoM"
if run_hook "$scratch/closeout-global.json" "evt-missing-skill-0001" "$empty_home" > "$scratch/missing-skill.out" 2>&1; then
  echo "missing Northstar skill resolution succeeded" >&2
  exit 1
fi
grep -qi "northstar" "$scratch/missing-skill.out"
[ ! -e "$repoM/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -z "$(git -C "$repoM" status --porcelain)" ]
echo "missing skill fails closed: OK"

# A missing runner fails before any process: the frozen argv cannot spawn.
# Queue-side runner pinning is spec 004's own proof; this covers the transport
# boundary where the approved artifact is absent.
repoR="$scratch/repo-missing-runner"
build_fixture "$repoR"
CURRENT_REPO="$repoR"
if (cd "$repoR" && env -i HOME="$installed_home" PATH="/usr/bin:/bin" TMPDIR="${TMPDIR:-/tmp}" \
  PASEO_QUEUE_EVENT_ID="evt-missing-runner-0001" PASEO_QUEUE_EVENT_SCHEMA="$EVENT_SCHEMA" \
  effigy "${FROZEN_ARGV[@]}" < "$scratch/closeout-global.json" > "$scratch/missing-runner.out" 2>&1); then
  echo "missing runner invocation succeeded" >&2
  exit 1
fi
[ ! -e "$repoR/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -z "$(git -C "$repoR" status --porcelain)" ]
echo "missing runner fails closed: OK"

echo "# copy-only starter consumer runs through the same route"
consumer="$scratch/starter-consumer"
build_fixture "$consumer" starter
emptied_home="$scratch/starter-empty-home"
mkdir -p "$emptied_home/.agents/skills"
rsync -a --delete "$source_skill/" "$emptied_home/.agents/skills/northstar/"
[ ! -e "$consumer/skills/northstar" ]
[ ! -e "$consumer/template-bundle" ]
[ ! -e "$consumer/.paseo/hooks" ]
CURRENT_REPO="$consumer"
read_facts "$(fixture_facts "$consumer" 006)"
write_event "$scratch/closeout-starter.json" "evt-closeout-starter-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
starter_out=$(run_hook "$scratch/closeout-starter.json" "evt-closeout-starter-0001" "$emptied_home")
expect_outcome "$starter_out" ok "starter copy-only closeout"
[ "$(json_field "$starter_out" "r.metadata.handoff_consumed")" = "true" ]
[ "$(json_field "$starter_out" "r.changedPaths.includes('docs/roadmaps/README.md')")" = "true" ]
[ "$(json_field "$starter_out" "r.changedPaths.includes('docs/README.md')")" = "true" ]
grep -q "| g03 | open | planning_required |" "$consumer/docs/README.md"
[ ! -e "$consumer/docs/handoffs/handoff-006.md" ]
[ -f "$consumer/.northstar/lifecycle/v1/tasks/g03.006.json" ]
echo "configuration-only starter consumer: OK"

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
    generation: spec.generation ?? "g03",
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

echo "# closeout catch-up consumes eligible historical closed generations"
# A current closeout must publish its own terminal transition plus every
# eligible historical closed generation in one integration result. The
# historical generation here is driven to terminal by the standalone core, then
# closed by committed authority with its fragments still present.
repoK="$scratch/repo-catchup"
build_fixture "$repoK"
CURRENT_REPO="$repoK"
read_facts "$(fixture_facts "$repoK" 006)"
mkdir -p "$repoK/docs/roadmaps/g01"
printf '# Old lane g01.001\n\nOwner: fixture\n' > "$repoK/docs/roadmaps/g01/001-old-lane.md"
printf '# g01\n\nHuman old generation runway stays.\n' > "$repoK/docs/roadmaps/g01/README.md"
git -C "$repoK" add -A
git -C "$repoK" commit -qm "plan historical g01.001"
pcK=$(git -C "$repoK" log -1 --format=%H -- docs/roadmaps/g01/001-old-lane.md)
digestK=$(git -C "$repoK" cat-file blob "$pcK:docs/roadmaps/g01/001-old-lane.md" | sha256sum | cut -d' ' -f1 | sed 's/^/sha256:/')
cat > "$scratch/spec-hist-g01.json" <<EOF
{
  "event_id": "hist-g01-001",
  "task_id": "g01.001",
  "task_path": "docs/roadmaps/g01/001-old-lane.md",
  "generation": "g01",
  "planning_commit": "$pcK",
  "planning_blob_digest": "$digestK",
  "occurred_at": "2026-09-12T20:00:00.000Z",
  "targets": [],
  "transitions": $full_transitions,
  "evidence": $(evidence_json "docs/handoffs/handoff-006.md" "$FH" "$MC")
}
EOF
# The historical generation is outside the declared active set, so the
# declaration is set aside for the record-only chain and restored after.
mv "$repoK/.northstar/lifecycle/v1/projection-targets.json" "$scratch/targets-g03.json"
bun run "$driver" "$installed/scripts/lifecycle-core.ts" "$repoK" "$scratch/spec-hist-g01.json" >/dev/null
mv "$scratch/targets-g03.json" "$repoK/.northstar/lifecycle/v1/projection-targets.json"
[ -f "$repoK/.northstar/lifecycle/v1/tasks/g01.001.json" ]
tasks_digestK_json=$(cd "$repoK" && bun run "$installed_core" tasks-digest --records .northstar/lifecycle/v1/tasks --generation g01)
tasks_digestK=$(json_field "$tasks_digestK_json" "r.tasks_digest")
mkdir -p "$repoK/.northstar/lifecycle/v1/generations"
cat > "$repoK/.northstar/lifecycle/v1/generations/g01.closure.json" <<EOF
{
  "schema_version": "northstar.lifecycle.generation-closure.v1",
  "generation": "g01",
  "disposition": "closed",
  "reason": "fixture historical rollover boundary",
  "tasks_digest": "$tasks_digestK",
  "closed_at": "2026-09-12T22:00:00.000Z"
}
EOF
git -C "$repoK" add -A
git -C "$repoK" commit -qm "close historical g01"
mcK=$(git -C "$repoK" rev-parse main)
fhK=$(git -C "$repoK" rev-parse feature)

# Standalone first: capture the canonical receipt bytes, then restore the
# pre-catch-up tree so the hook route must reproduce them exactly.
standalone_receipt=$(cd "$repoK" && bun run "$installed_core" compact --records .northstar/lifecycle/v1/tasks --generation g01 --out .northstar/lifecycle/v1/generations/g01.json)
[ "$(json_field "$standalone_receipt" "r.status")" = "applied" ]
receiptK=$(cat "$repoK/.northstar/lifecycle/v1/generations/g01.json")
[ ! -e "$repoK/.northstar/lifecycle/v1/tasks/g01.001.json" ]
rm "$repoK/.northstar/lifecycle/v1/generations/g01.json"
git -C "$repoK" checkout -q -- .northstar/lifecycle/v1/tasks/g01.001.json
[ -z "$(git -C "$repoK" status --porcelain)" ]

catchup_delivery=$(printf '{"prUrl": "https://github.com/example/repo/pull/51", "prNumber": 51, "head": "%s", "review": "approved at head", "mergeCommit": "%s", "integrationCommit": "%s", "summary": "effigy qa passed"}' "$fhK" "$MC" "$mcK")
write_event "$scratch/closeout-catchup.json" "evt-closeout-catchup-0001" "task.closeout" "lifecycle-state" "$mcK" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$catchup_delivery"
catchup_out=$(run_hook "$scratch/closeout-catchup.json" "evt-closeout-catchup-0001")
expect_outcome "$catchup_out" ok "closeout catch-up"
catchup_changed=$(json_field "$catchup_out" "r.changedPaths.join(',')")
for expected in \
  ".northstar/lifecycle/v1/generations/g01.json" \
  ".northstar/lifecycle/v1/tasks/g01.001.json" \
  ".northstar/lifecycle/v1/tasks/g03.006.json" \
  "docs/handoffs/handoff-006.md" \
  "docs/README.md" \
  "docs/roadmaps/README.md" \
  "docs/roadmaps/g03/README.md"; do
  case ",$catchup_changed," in
    *",$expected,"*) ;;
    *) echo "catch-up closeout did not report $expected: $catchup_changed" >&2; exit 1 ;;
  esac
done
[ "$(json_field "$catchup_out" "r.metadata.generations_compacted.join(',')")" = "g01" ]
[ "$(json_field "$catchup_out" "r.metadata.fragments_consumed")" = "1" ]
[ ! -e "$repoK/.northstar/lifecycle/v1/tasks/g01.001.json" ]
[ -f "$repoK/.northstar/lifecycle/v1/generations/g01.json" ]
[ "$(cat "$repoK/.northstar/lifecycle/v1/generations/g01.json")" = "$receiptK" ]
[ ! -e "$repoK/.northstar/lifecycle/v1/tasks/g03.007.json" ]
grep -q "| g03.006 | complete | none |" "$repoK/docs/roadmaps/g03/README.md"
if grep -q "g01.001" "$repoK/docs/roadmaps/g03/README.md"; then
  echo "catch-up leaked a closed-generation entry into the active projection" >&2
  exit 1
fi
[ -z "$(git -C "$repoK" diff --cached)" ]
echo "closeout catch-up consumes historical fragments in one result: OK"

# ---------------------------------------------------------------------------
# Bounded v3 -> v4 Queue control-manifest migration
# ---------------------------------------------------------------------------
echo "# bounded v3-to-v4 Queue manifest migration"
migration="$source_skill/scripts/lifecycle-queue-migration.ts"
V4_MIRROR="$source_skill/references/lifecycle/queue-control-v4.schema.json"

build_manifest_consumer() { # <repo> <manifest-source>
  rm -rf "$1"
  mkdir -p "$1/.paseo" "$1/docs"
  git -C "$1" init -q -b main
  git -C "$1" config user.email fixture@example.invalid
  git -C "$1" config user.name Fixture
  cp "$2" "$1/.paseo/queue.json"
  printf '.effigy/\n' > "$1/.gitignore"
  printf '# Front door\n\nUntouched human bytes.\n' > "$1/docs/README.md"
  git -C "$1" add -A
  git -C "$1" commit -qm "adopt the queue manifest"
}

tree_snapshot() { # <repo> [relative-path-to-exclude]
  (cd "$1" && find . -path ./.git -prune -o -type f -print | LC_ALL=C sort | while IFS= read -r file; do
    relative=${file#./}
    if [ "$relative" = "${2:-}" ]; then continue; fi
    printf '%s %s\n' "$relative" "$(sha256sum "$file" | cut -d' ' -f1)"
  done)
}

migration_run() { # <repo> [extra args...]
  local repo=$1; shift
  set +e
  MIGRATION_OUT=$(bun run "$migration" --repo "$repo" "$@")
  MIGRATION_EXIT=$?
  set -e
}

expect_migration_error() { # <label> <expected-code> <expected-substring> <repo>
  migration_run "$4"
  if [ "$MIGRATION_EXIT" = "0" ]; then
    echo "$1: migration unexpectedly succeeded: $MIGRATION_OUT" >&2
    exit 1
  fi
  if [ "$(json_field "$MIGRATION_OUT" "r.code")" != "$2" ]; then
    echo "$1: expected code $2, got $(json_field "$MIGRATION_OUT" "r.code"): $MIGRATION_OUT" >&2
    exit 1
  fi
  if [ "$(json_field "$MIGRATION_OUT" "r.message.includes('$3')")" != "true" ]; then
    echo "$1: refusal did not name '$3': $MIGRATION_OUT" >&2
    exit 1
  fi
}

# A conforming v3 consumer: the derived legacy manifest is committed and the
# rest of the tree must stay byte-identical across the migration.
migrate_repo="$scratch/migrate-consumer"
build_manifest_consumer "$migrate_repo" "$scratch/derived-v3-premerge.json"
manifest_before=$(sha256sum "$migrate_repo/.paseo/queue.json" | cut -d' ' -f1)
other_before=$(tree_snapshot "$migrate_repo" ".paseo/queue.json")
tree_before=$(tree_snapshot "$migrate_repo")

migration_run "$migrate_repo"
[ "$MIGRATION_EXIT" = "0" ]
[ "$(json_field "$MIGRATION_OUT" "r.status")" = "dry_run" ]
[ "$(json_field "$MIGRATION_OUT" "r.manifest")" = ".paseo/queue.json" ]
[ "$(json_field "$MIGRATION_OUT" "r.changes.length")" = "2" ]
[ "$(json_field "$MIGRATION_OUT" "r.schema_before")" = "paseo.queue.control.v3" ]
[ "$(json_field "$MIGRATION_OUT" "r.schema_after")" = "paseo.queue.control.v4" ]
[ "$(json_field "$MIGRATION_OUT" "r.pre_merge_target_before")" = "reviewed_head" ]
[ "$(json_field "$MIGRATION_OUT" "r.pre_merge_target_after")" = "prospective_merge" ]
[ "$(json_field "$MIGRATION_OUT" "r.changed_paths.length")" = "0" ]
[ "$(json_field "$MIGRATION_OUT" "r.pending_paths[0]")" = ".paseo/queue.json" ]
[ "$(json_field "$MIGRATION_OUT" "r.digest_before === r.digest_after")" = "false" ]
[ "$(sha256sum "$migrate_repo/.paseo/queue.json" | cut -d' ' -f1)" = "$manifest_before" ]
[ "$(tree_snapshot "$migrate_repo")" = "$tree_before" ]
[ -z "$(git -C "$migrate_repo" status --porcelain)" ]
echo "dry run reports the exact one-file/two-value edit and writes nothing: OK"

migration_run "$migrate_repo" --write
[ "$MIGRATION_EXIT" = "0" ]
[ "$(json_field "$MIGRATION_OUT" "r.status")" = "applied" ]
[ "$(json_field "$MIGRATION_OUT" "r.changed_paths.length")" = "1" ]
[ "$(json_field "$MIGRATION_OUT" "r.changed_paths[0]")" = ".paseo/queue.json" ]
[ "$(json_field "$MIGRATION_OUT" "r.commit_action.required")" = "true" ]
[ "$(json_field "$MIGRATION_OUT" "r.digest_after")" = "$(sha256sum "$migrate_repo/.paseo/queue.json" | cut -d' ' -f1 | sed 's/^/sha256:/')" ]
# Byte isolation: the written manifest is exactly the original with the two
# literal tokens replaced, and every other file is untouched.
sed -e 's/"paseo.queue.control.v3"/"paseo.queue.control.v4"/' -e 's/"reviewed_head"/"prospective_merge"/' \
  "$scratch/derived-v3-premerge.json" > "$scratch/migrated-expected.json"
cmp "$scratch/migrated-expected.json" "$migrate_repo/.paseo/queue.json"
[ "$(git -C "$migrate_repo" diff -U0 -- .paseo/queue.json | grep -c '^[+-][^+-]')" = "4" ]
[ "$(tree_snapshot "$migrate_repo" ".paseo/queue.json")" = "$other_before" ]
[ "$(git -C "$migrate_repo" status --porcelain)" = " M .paseo/queue.json" ]
schema_check "$V4_MIRROR" "$migrate_repo/.paseo/queue.json"
bun -e '
  const fs = await import("node:fs");
  const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  const fail = (message) => { console.error(message); process.exit(1); };
  if (manifest.schema !== "paseo.queue.control.v4") fail("migrated manifest is not v4");
  if (manifest.hooks.find((hook) => hook.id === "repository-pre-merge").target !== "prospective_merge") fail("migrated manifest did not retarget the pre-merge hook");
' "$migrate_repo/.paseo/queue.json"
echo "write mode changes only .paseo/queue.json and validates against v4: OK"

git -C "$migrate_repo" add -A
git -C "$migrate_repo" commit -qm "migrate the queue manifest to v4"
migrated_manifest=$(sha256sum "$migrate_repo/.paseo/queue.json" | cut -d' ' -f1)
migration_run "$migrate_repo" --write
[ "$MIGRATION_EXIT" = "0" ]
[ "$(json_field "$MIGRATION_OUT" "r.status")" = "unchanged" ]
[ "$(json_field "$MIGRATION_OUT" "r.changes.length")" = "0" ]
[ "$(json_field "$MIGRATION_OUT" "r.changed_paths.length")" = "0" ]
[ "$(json_field "$MIGRATION_OUT" "r.commit_action.required")" = "false" ]
[ "$(json_field "$MIGRATION_OUT" "r.digest_before === r.digest_after")" = "true" ]
[ "$(sha256sum "$migrate_repo/.paseo/queue.json" | cut -d' ' -f1)" = "$migrated_manifest" ]
[ -z "$(git -C "$migrate_repo" status --porcelain)" ]
echo "replay on a conforming v4 manifest is a no-op: OK"

# Refusals: every divergent shape fails before any byte changes.
refusal_repo() { # <repo> <manifest-source> <label> <code> <substring> <mutation-js-or-none>
  build_manifest_consumer "$1" "$2"
  if [ "$6" != "none" ]; then
    bun -e '
      const fs = await import("node:fs");
      const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
      new Function("manifest", fs.readFileSync(process.argv[3], "utf8"))(manifest);
      fs.writeFileSync(process.argv[2], JSON.stringify(manifest, null, 2) + "\n");
    ' "$1/.paseo/queue.json" "$1/.paseo/queue.json" "$6"
    git -C "$1" add -A
    git -C "$1" commit -qm "divergent manifest fixture"
  fi
  local before
  before=$(sha256sum "$1/.paseo/queue.json" | cut -d' ' -f1)
  expect_migration_error "$3" "$4" "$5" "$1"
  [ "$(sha256sum "$1/.paseo/queue.json" | cut -d' ' -f1)" = "$before" ]
  [ -z "$(git -C "$1" status --porcelain)" ]
}

printf 'manifest.schema = "paseo.queue.control.v4";' > "$scratch/mut-v4-reviewed.js"
printf 'manifest.hooks.find((hook) => hook.id === "repository-pre-merge").program = { kind: "repository", executable: "hooks/x" };' > "$scratch/mut-custom-program.js"
printf 'manifest.hooks.find((hook) => hook.id === "repository-pre-merge").program.argv = ["skill", "run", "northstar/queue:hook"];' > "$scratch/mut-custom-argv.js"
printf 'manifest.hooks.push({ id: "second-pre-merge", events: ["task.pre_merge"], mode: "read_only", delivery: "required", target: "prospective_merge", program: { kind: "trusted_runner", runner: "effigy", argv: ["skill", "run", "northstar/queue:hook", "--stdio", "passthrough"] }, timeoutMs: 30000, maxOutputBytes: 65536, allowedPaths: [], commitSubject: null }); manifest.schema = "paseo.queue.control.v4"; manifest.hooks.find((hook) => hook.id === "repository-pre-merge").target = "reviewed_head";' > "$scratch/mut-ambiguous-hooks.js"
printf 'manifest.hooks.find((hook) => hook.id === "lifecycle-state").commitSubject.prefix = "reviewed_head";' > "$scratch/mut-ambiguous-token.js"
printf 'manifest.hooks.find((hook) => hook.id === "repository-pre-merge").delivery = "advisory";' > "$scratch/mut-advisory.js"

refusal_repo "$scratch/migrate-v2" "$scratch/derived-v2-manifest.json" "older v2 schema" "manifest-schema" "only paseo.queue.control.v3 migrates" "none"
refusal_repo "$scratch/migrate-partial" "$scratch/derived-v3-premerge.json" "v4 manifest still at reviewed_head" "manifest-shape" "refusing a partial migration" "$scratch/mut-v4-reviewed.js"
refusal_repo "$scratch/migrate-program" "$scratch/derived-v3-premerge.json" "custom repository program" "manifest-program" "trusted-runner program shape" "$scratch/mut-custom-program.js"
refusal_repo "$scratch/migrate-argv" "$scratch/derived-v3-premerge.json" "custom runner argv" "manifest-program" "frozen Queue hook argv" "$scratch/mut-custom-argv.js"
refusal_repo "$scratch/migrate-ambiguous" "$scratch/derived-v3-premerge.json" "two pre-merge bindings" "manifest-shape" "exactly one task.pre_merge hook" "$scratch/mut-ambiguous-hooks.js"
refusal_repo "$scratch/migrate-token" "$scratch/derived-v3-premerge.json" "ambiguous reviewed_head token" "manifest-shape" "exactly one \"reviewed_head\" token" "$scratch/mut-ambiguous-token.js"
refusal_repo "$scratch/migrate-advisory" "$scratch/derived-v3-premerge.json" "advisory pre-merge delivery" "manifest-shape" "requires required delivery" "$scratch/mut-advisory.js"

# Dirty, untracked, invalid, and symlinked manifests fail before any read of
# the pending edit.
migrate_dirty="$scratch/migrate-dirty"
build_manifest_consumer "$migrate_dirty" "$scratch/derived-v3-premerge.json"
printf '\n' >> "$migrate_dirty/.paseo/queue.json"
dirty_before=$(sha256sum "$migrate_dirty/.paseo/queue.json" | cut -d' ' -f1)
expect_migration_error "dirty manifest" "manifest-dirty" "uncommitted changes" "$migrate_dirty"
[ "$(sha256sum "$migrate_dirty/.paseo/queue.json" | cut -d' ' -f1)" = "$dirty_before" ]
expect_migration_error "dirty manifest in write mode" "manifest-dirty" "uncommitted changes" "$migrate_dirty"
git -C "$migrate_dirty" checkout -q -- .paseo/queue.json

migrate_untracked="$scratch/migrate-untracked"
mkdir -p "$migrate_untracked/.paseo" "$migrate_untracked/docs"
git -C "$migrate_untracked" init -q -b main
printf '# Front door\n' > "$migrate_untracked/docs/README.md"
git -C "$migrate_untracked" add -A
git -C "$migrate_untracked" commit -qm "empty consumer"
cp "$scratch/derived-v3-premerge.json" "$migrate_untracked/.paseo/queue.json"
untracked_before=$(sha256sum "$migrate_untracked/.paseo/queue.json" | cut -d' ' -f1)
expect_migration_error "untracked manifest" "manifest-untracked" "not committed to Git" "$migrate_untracked"
[ "$(sha256sum "$migrate_untracked/.paseo/queue.json" | cut -d' ' -f1)" = "$untracked_before" ]

migrate_invalid="$scratch/migrate-invalid"
build_manifest_consumer "$migrate_invalid" "$scratch/derived-v3-premerge.json"
printf '{ not json\n' > "$migrate_invalid/.paseo/queue.json"
git -C "$migrate_invalid" add -A
git -C "$migrate_invalid" commit -qm "invalid manifest"
invalid_before=$(sha256sum "$migrate_invalid/.paseo/queue.json" | cut -d' ' -f1)
expect_migration_error "invalid JSON manifest" "manifest-json" "not valid JSON" "$migrate_invalid"
[ "$(sha256sum "$migrate_invalid/.paseo/queue.json" | cut -d' ' -f1)" = "$invalid_before" ]

migrate_symlink="$scratch/migrate-symlink"
build_manifest_consumer "$migrate_symlink" "$scratch/derived-v3-premerge.json"
mv "$migrate_symlink/.paseo/queue.json" "$migrate_symlink/.paseo/queue.real.json"
ln -s queue.real.json "$migrate_symlink/.paseo/queue.json"
git -C "$migrate_symlink" add -A
git -C "$migrate_symlink" commit -qm "symlinked manifest"
symlink_before=$(sha256sum "$migrate_symlink/.paseo/queue.real.json" | cut -d' ' -f1)
expect_migration_error "symlinked manifest" "manifest-symlink" "refusing to migrate through a symlink" "$migrate_symlink"
[ "$(sha256sum "$migrate_symlink/.paseo/queue.real.json" | cut -d' ' -f1)" = "$symlink_before" ]
[ -L "$migrate_symlink/.paseo/queue.json" ]

migrate_missing="$scratch/migrate-missing"
rm -rf "$migrate_missing"
mkdir -p "$migrate_missing/docs"
git -C "$migrate_missing" init -q -b main
printf '# Front door\n' > "$migrate_missing/docs/README.md"
git -C "$migrate_missing" add -A
git -C "$migrate_missing" commit -qm "no manifest"
expect_migration_error "missing manifest" "manifest-missing" "is missing" "$migrate_missing"
echo "divergent, dirty, untracked, invalid, symlinked, and missing inputs refuse before any write: OK"

# The installed skill carries the same command: the dry run reads the consumer
# manifest through installed bytes and writes nothing.
installed_repo="$scratch/migrate-installed"
build_manifest_consumer "$installed_repo" "$scratch/derived-v3-premerge.json"
installed_before=$(sha256sum "$installed_repo/.paseo/queue.json" | cut -d' ' -f1)
installed_out=$(cd "$scratch" && effigy skill run --path "$installed" northstar/lifecycle:migrate-premerge --repo "$installed_repo" 2>&1)
printf '%s\n' "$installed_out" | grep -q '"status": "dry_run"'
[ "$(sha256sum "$installed_repo/.paseo/queue.json" | cut -d' ' -f1)" = "$installed_before" ]
[ -z "$(git -C "$installed_repo" status --porcelain)" ]
echo "installed skill route resolves the migration and stays read-only in dry run: OK"

echo "# oversized currentness detail stays bounded and blocks instead of malfunctioning"
# The audit reports whole section strings. A large repository can put tens of
# kilobytes into one violation, which previously turned a red closeout into a
# hook malfunction that no retry could clear. All four emit sites share the
# bounded metadata helper; this proves the closeout and replay paths.
repoO="$scratch/repo-oversize"
build_fixture "$repoO"
CURRENT_REPO="$repoO"
read_facts "$(fixture_facts "$repoO" 006)"
huge=$(printf 'y%.0s' $(seq 1 40000))
write_oversize_violation() {
  printf '\n## Next task %s\n\nText names g03.006 once.\n' "$huge" >> "$repoO/docs/roadmaps/g03/README.md"
  git -C "$repoO" add -A
  git -C "$repoO" commit -qm "oversized currentness violation"
}
write_oversize_violation
read_facts "$(fixture_facts "$repoO" 006)"
write_event "$scratch/closeout-oversize.json" "evt-closeout-oversize-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
oversize=$(run_hook "$scratch/closeout-oversize.json" "evt-closeout-oversize-0001")
expect_outcome "$oversize" blocked "oversized currentness violation"
json_field "$oversize" "r.summary.includes('not current')" >/dev/null
[ "$(json_field "$oversize" "r.metadata.currentness_violation_count")" = "1" ]
[ "$(json_field "$oversize" "r.metadata.currentness_violations.length")" = "1" ]
[ "$(json_field "$oversize" "r.metadata.currentness_violations[0].section.length")" = "256" ]
[ "$(json_field "$oversize" "r.metadata.currentness_violations[0].task")" = "g03.006" ]
[ "$(json_field "$oversize" "r.metadata.currentness_violations[0].reason")" = "stale-frontier" ]
[ "$(json_field "$oversize" "JSON.stringify(r.metadata).length < 32768")" = "true" ]
[ "$(printf '%s' "$oversize" | wc -c | tr -d ' ')" -lt 32768 ]
[ ! -e "$repoO/.northstar/lifecycle/v1/tasks/g03.006.json" ]
[ -z "$(git -C "$repoO" status --porcelain)" ]
# Replay path: publish the terminal record with a clean target, then break it again.
python3 - "$repoO/docs/roadmaps/g03/README.md" <<'PY'
import sys
path = sys.argv[1]
text = open(path).read()
marker = "\n## Next task yyyy"
if marker in text:
    text = text[: text.index(marker)] + "\n"
open(path, "w").write(text)
PY
git -C "$repoO" add -A
git -C "$repoO" commit -qm "restore clean currentness"
read_facts "$(fixture_facts "$repoO" 006)"
write_event "$scratch/closeout-oversize-clean.json" "evt-closeout-oversize-clean-0001" "task.closeout" "lifecycle-state" "$MC" \
  "q-006" '"Implement g03.006 fixture task"' \
  "docs/handoffs/handoff-006.md" "$IC" "$ID" "$(closeout_delivery "$FH" "$MC")"
expect_outcome "$(run_hook "$scratch/closeout-oversize-clean.json" "evt-closeout-oversize-clean-0001")" ok "clean bootstrap after oversize refusal"
write_oversize_violation
replay=$(run_hook "$scratch/closeout-oversize.json" "evt-closeout-oversize-0001")
expect_outcome "$replay" blocked "oversized currentness violation on replay"
[ "$(json_field "$replay" "r.metadata.replayed")" = "true" ]
[ "$(json_field "$replay" "r.metadata.currentness_violation_count")" = "1" ]
[ "$(printf '%s' "$replay" | wc -c | tr -d ' ')" -lt 32768 ]
[ -z "$(git -C "$repoO" status --porcelain)" ]
echo "oversized currentness metadata stays bounded: OK"

echo "# no repository runtime remains in any live surface"
[ ! -e "$repo_root/.paseo/hooks" ]
[ ! -e "$repo_root/template-bundle/lifecycle/hooks" ]
[ ! -e "$repo_root/skills/northstar/scripts/lifecycle-runtime.ts" ]
[ ! -e "$repo_root/skills/northstar/assets/templates/lifecycle-hook-launcher.sh" ]
if grep -rq --exclude="$(basename "$0")" "lifecycle-runtime\|lifecycle-hook-launcher" \
  "$repo_root/skills" "$repo_root/template-bundle" "$repo_root/bundle-docs" \
  "$repo_root/scripts" "$repo_root/docs/architecture" "$repo_root/docs/contracts" \
  "$repo_root/docs/specs" "$repo_root/effigy.toml" "$repo_root/AGENTS.md" 2>/dev/null; then
  echo "live surfaces still reference the removed copied-runtime tooling" >&2
  exit 1
fi
echo "no copied repository runtime: OK"

echo "lifecycle-adoption self-test: OK"
