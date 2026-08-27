#!/usr/bin/env bash

set -euo pipefail

harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
repository_root=$(git -C "$harness_dir" rev-parse --show-toplevel)
skill_source="$repository_root/skills/northstar"
output_dir=${1:-}
stage_dir=""
complete=false

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

hash_file() {
  shasum -a 256 "$1" | awk '{print $1}'
}

cleanup() {
  if [[ "$complete" == false && -n "$stage_dir" && -d "$stage_dir" ]]; then
    rm -r "$stage_dir"
  fi
}
trap cleanup EXIT

test -n "$output_dir" || fail "usage: prepare.sh <cohort-dir>"
test ! -e "$output_dir" || fail "output already exists: $output_dir"
parent=$(dirname "$output_dir")
test -d "$parent" && test -w "$parent" || fail "output parent unavailable"
for command_name in cargo codex git jq rsync rustc shasum; do
  command -v "$command_name" >/dev/null 2>&1 || fail "missing command: $command_name"
done

stage_dir=$(mktemp -d "$parent/.northstar-rust-v2-production.XXXXXX")
mkdir -p "$stage_dir/subjects" "$stage_dir/coordinators" "$stage_dir/runtime"

payload_rows="$stage_dir/payload-rows.ndjson"
: >"$payload_rows"
while IFS= read -r source_file; do
  relative=${source_file#"$skill_source/"}
  case "$relative" in
    tools/rust-quality/target/*) continue ;;
  esac
  jq -nc --arg path "$relative" --arg sha256 "$(hash_file "$source_file")" \
    '{path: $path, sha256: $sha256}' >>"$payload_rows"
done < <(find "$skill_source" -type f -print | LC_ALL=C sort)
jq -s 'sort_by(.path)' "$payload_rows" >"$stage_dir/production-payload-manifest.json"
rm "$payload_rows"
payload_manifest_sha=$(hash_file "$stage_dir/production-payload-manifest.json")
payload_hash=$(cargo +1.95.0 run --quiet --locked \
  --manifest-path "$skill_source/tools/rust-quality/Cargo.toml" -- \
  verify-install --source-root "$skill_source/tools/rust-quality" |
  jq -r '.source_payload_sha256')
payload_binary="$HOME/Library/Caches/northstar/rust-quality/payloads/$payload_hash/bin/northstar-rust-quality"
if [[ ! -x "$payload_binary" ]]; then
  cargo +1.95.0 install --locked --offline \
    --path "$skill_source/tools/rust-quality" \
    --root "$HOME/Library/Caches/northstar/rust-quality/payloads/$payload_hash"
fi

write_common() {
  local subject=$1
  local subject_id=$2
  local scope=$3
  mkdir -p "$subject/.agents/skills" "$subject/docs/contracts" "$subject/.northstar/bin"
  rsync -a --exclude target/ "$skill_source/" "$subject/.agents/skills/northstar/"
  cp "$payload_binary" "$subject/.northstar/bin/northstar-rust-quality"
  chmod +x "$subject/.northstar/bin/northstar-rust-quality"
  cp "$skill_source/assets/templates/language-quality/rust/rust-quality-deviations.json" \
    "$subject/docs/contracts/rust-quality-deviations.json"
  jq '.msrv.cargo_manifests = ["Cargo.toml"] | .msrv.toolchain_policy_paths = ["rust-toolchain.toml"]' \
    "$skill_source/assets/templates/language-quality/rust/rust-quality-profile.json" \
    >"$subject/docs/contracts/rust-quality-profile.json"
  cp "$skill_source/assets/templates/language-quality/rust/AGENTS.md" "$subject/AGENTS.md"
  printf '\n%s\n' \
    'This is an isolated explicit-audit production packet. Do not create PAPERCUTS.md.' \
    'The packet README is the operator request. Preserve all packet policy and baseline files.' \
    >>"$subject/AGENTS.md"
  printf '%s\n' 'target/' '.audit-inputs/' >"$subject/.gitignore"
  jq -n --arg subject_id "$subject_id" --arg scope "$scope" \
    --arg payload_hash "$payload_hash" --arg manifest_sha "$payload_manifest_sha" \
    '{schema_version:"northstar.rust-quality.production-subject.v2",subject_id:$subject_id,
      scope:$scope,audit_id:"production-v2",payload_sha256:$payload_hash,
      payload_manifest_sha256:$manifest_sha}' >"$subject/production-payload.json"
  printf '%s\n' '[toolchain]' 'channel = "1.95.0"' 'profile = "minimal"' \
    >"$subject/rust-toolchain.toml"
}

write_readme() {
  local subject=$1
  local scope=$2
  local note=$3
  printf '%s\n' \
    '# Isolated Northstar Rust v2 production subject' '' \
    "Explicitly audit and repair the $scope scope in this repository." \
    'Read `.agents/skills/northstar/SKILL.md`, route to the explicit Rust audit,' \
    'and follow its current Cargo-native lifecycle exactly. The verified tool is' \
    '`.northstar/bin/northstar-rust-quality`; verify it against the copied skill' \
    'source before use. Use audit ID `production-v2`.' '' \
    "$note" '' \
    'Do not inspect paths outside this packet. Do not alter the copied skill,' \
    'profile, deviations, toolchain policy, packet metadata, committed baseline,' \
    'or repository architecture policy. Put lifecycle JSON inputs and outputs' \
    'under ignored `.audit-inputs/`. Do not create PAPERCUTS.md. Findings must' \
    'precede mutation. Apply only authorized bounded repairs. Run repository-native' \
    'validation, finalize the production audit, and leave its canonical result in' \
    'Git metadata. Write `subject-return.json` with only: subject_id, audit_id,' \
    'result_path, runtime, runtime_version, reasoning_effort, and limitations.' \
    'Set subject_id to the exact value in production-payload.json, not a runtime agent ID.' \
    'Set result_path to exactly `.git/northstar/rust-quality/audits/production-v2/result.json`.' \
    >"$subject/README.md"
}

initialize_git() {
  local subject=$1
  cargo +1.95.0 generate-lockfile --manifest-path "$subject/Cargo.toml"
  git -C "$subject" init -q
  git -C "$subject" config user.name "Northstar Evidence Harness"
  git -C "$subject" config user.email "evidence@invalid"
  git -C "$subject" add .
  git -C "$subject" commit -q -m "freeze production subject"
}

freeze_audit_start() {
  local subject=$1
  local subject_id=$2
  local destination="$stage_dir/coordinators/$subject_id-audit-start"
  mkdir -p "$destination"
  while IFS= read -r source_file; do
    relative=${source_file#"$subject/"}
    mkdir -p "$destination/$(dirname "$relative")"
    cp "$source_file" "$destination/$relative"
  done < <(find "$subject" \
    -path "$subject/.agents" -prune -o \
    -path "$subject/.northstar" -prune -o \
    -type f -name '*.rs' -print | LC_ALL=C sort)
}

# Subject A: dirty API tranche with repository-owned redaction policy.
subject="$stage_dir/subjects/worktree-api"
mkdir -p "$subject/src" "$subject/tests" "$subject/docs/architecture"
write_common "$subject" worktree-api worktree
printf '%s\n' '[package]' 'name = "worktree-api"' 'version = "0.1.0"' \
  'edition = "2024"' 'rust-version = "1.95"' >"$subject/Cargo.toml"
printf '%s\n' \
  '#![warn(missing_debug_implementations)]' '' \
  'pub struct Session {' '    token: String,' '    label: String,' '}' '' \
  'impl Session {' '    pub fn new(token: impl Into<String>, label: impl Into<String>) -> Self {' \
  '        Self { token: token.into(), label: label.into() }' '    }' '' \
  '    pub fn label(&self) -> &str { &self.label }' '}' >"$subject/src/lib.rs"
printf '%s\n' '# API policy' '' 'Public operational types implement `Debug`.' \
  '`Session::token` is secret. Structural Debug must use the logical string value' \
  '`<redacted>` for that field; ordinary Debug quotation marks are formatting, not' \
  'secret content. Empty and non-empty tokens must produce the same field rendering.' \
  >"$subject/docs/architecture/api.md"
printf '%s\n' 'use worktree_api::Session;' '' '#[test]' 'fn label_is_stable() {' \
  '    assert_eq!(Session::new("secret", "primary").label(), "primary");' '}' \
  >"$subject/tests/session.rs"
write_readme "$subject" worktree \
  'Treat `docs/architecture/api.md` as governed read-only context for the dirty Rust anchor.'
initialize_git "$subject"
printf '\n// Public API promoted in the current tranche.\n' >>"$subject/src/lib.rs"
freeze_audit_start "$subject" worktree-api
jq -n '{subject_id:"worktree-api",expected_scope:"worktree",
  expected_findings:[{rule_id:"RUST-API-001",file:"src/lib.rs"}],
  required_changed_files:["src/lib.rs"],
  allowed_changed_files:["src/lib.rs","tests/session.rs"],
  allowed_worktree_files:["src/lib.rs","tests/session.rs","subject-return.json"],
  max_changed_lines:55,
  required_limitations:[],required_limitation_prefixes:[],
  allow_additional_limitations:false}' \
  >"$stage_dir/coordinators/worktree-api.json"

# Subject B: clean mixed repository with nested Cargo workspace and async defect.
subject="$stage_dir/subjects/repository-mixed"
mkdir -p "$subject/crates/core/src" "$subject/crates/core/tests" \
  "$subject/docs/architecture" "$subject/web"
write_common "$subject" repository-mixed repository
jq '.msrv.cargo_manifests = ["Cargo.toml", "crates/core/Cargo.toml"]' \
  "$subject/docs/contracts/rust-quality-profile.json" >"$subject/docs/contracts/profile.tmp"
mv "$subject/docs/contracts/profile.tmp" "$subject/docs/contracts/rust-quality-profile.json"
printf '%s\n' '[workspace]' 'members = ["crates/core"]' 'resolver = "3"' \
  >"$subject/Cargo.toml"
printf '%s\n' '[package]' 'name = "mixed-core"' 'version = "0.1.0"' \
  'edition = "2024"' 'rust-version = "1.95"' '[features]' 'strict = []' \
  >"$subject/crates/core/Cargo.toml"
printf '%s\n' '#![warn(missing_debug_implementations)]' '' \
  'use std::sync::{Mutex, PoisonError};' '' '#[derive(Debug)]' 'pub struct Counter {' \
  '    value: Mutex<u64>,' '}' '' 'impl Counter {' \
  '    pub fn new(value: u64) -> Self { Self { value: Mutex::new(value) } }' '' \
  '    pub fn increment(&self) {' \
  '        let mut guard = self.value.lock().unwrap_or_else(PoisonError::into_inner);' \
  '        *guard = guard.saturating_add(1);' '    }' '' \
  '    pub async fn snapshot(&self) -> u64 {' \
  '        let guard = self.value.lock().unwrap_or_else(PoisonError::into_inner);' \
  '        pause().await;' '        *guard' '    }' '}' '' 'async fn pause() {}' \
  >"$subject/crates/core/src/lib.rs"
printf '%s\n' '{"private":true,"scripts":{"check":"echo web"}}' >"$subject/web/package.json"
printf '%s\n' '# Concurrency boundary' '' \
  '`Counter` retains its mutex-backed interior-mutability boundary because the' \
  'production type will grow multi-field state that must update atomically.' \
  'Repairs may shorten guard lifetime but must not replace the mutex abstraction.' \
  >"$subject/docs/architecture/concurrency.md"
printf '%s\n' 'use std::{future::Future, task::{Context, Poll, Waker}};' '' \
  '#[test]' 'fn increment_and_snapshot_are_stable() {' \
  '    let counter = mixed_core::Counter::new(3);' '    counter.increment();' \
  '    let mut snapshot = Box::pin(counter.snapshot());' \
  '    let mut context = Context::from_waker(Waker::noop());' \
  '    assert_eq!(snapshot.as_mut().poll(&mut context), Poll::Ready(4));' '}' \
  >"$subject/crates/core/tests/counter.rs"
write_readme "$subject" repository \
  'Claim full repository coverage only from exact Cargo discovery. `web/` is a non-Rust mixed-project sibling. `docs/architecture/concurrency.md` governs the Rust concurrency boundary.'
initialize_git "$subject"
freeze_audit_start "$subject" repository-mixed
jq -n '{subject_id:"repository-mixed",expected_scope:"repository",
  expected_findings:[
    {rule_id:"RUST-ASYNC-001",file:"crates/core/src/lib.rs"}],
  required_changed_files:["crates/core/src/lib.rs"],
  allowed_changed_files:["crates/core/src/lib.rs","crates/core/tests/counter.rs"],
  allowed_worktree_files:["crates/core/src/lib.rs","crates/core/tests/counter.rs","subject-return.json"],
  max_changed_lines:12,
  required_limitations:[],required_limitation_prefixes:[],
  allow_additional_limitations:false}' \
  >"$stage_dir/coordinators/repository-mixed.json"

# Subject C: dirty authorized API repair plus report-only unsafe finding and tool degradation.
subject="$stage_dir/subjects/degraded-unsafe"
mkdir -p "$subject/src" "$subject/tests"
write_common "$subject" degraded-unsafe worktree
printf '%s\n' '[package]' 'name = "degraded-unsafe"' 'version = "0.1.0"' \
  'edition = "2024"' 'rust-version = "1.95"' >"$subject/Cargo.toml"
printf '%s\n' '#![warn(missing_debug_implementations)]' '' 'mod ffi;' '' \
  'pub struct Endpoint {' '    pub port: u16,' '}' '' \
  'pub use ffi::read_first;' >"$subject/src/lib.rs"
printf '%s\n' 'pub unsafe fn read_first(pointer: *const u8) -> u8 {' \
  '    unsafe { *pointer }' '}' >"$subject/src/ffi.rs"
printf '%s\n' '#[test]' 'fn endpoint_port_is_stable() {' \
  '    assert_eq!(degraded_unsafe::Endpoint { port: 443 }.port, 443);' '}' \
  >"$subject/tests/endpoint.rs"
write_readme "$subject" worktree \
  'The requested scanner service is unavailable in this packet. Record that as structured evidence; do not install or substitute one. Unsafe repair remains report-only.'
initialize_git "$subject"
printf '\n// Public API added in the current tranche.\n' >>"$subject/src/lib.rs"
printf '\n// Raw-pointer boundary added in the current tranche.\n' >>"$subject/src/ffi.rs"
freeze_audit_start "$subject" degraded-unsafe
jq -n '{subject_id:"degraded-unsafe",expected_scope:"worktree",
  expected_findings:[
    {rule_id:"RUST-API-001",file:"src/lib.rs"},
    {rule_id:"RUST-UNSAFE-001",file:"src/ffi.rs"}],
  required_changed_files:["src/lib.rs"],
  allowed_changed_files:["src/lib.rs","tests/endpoint.rs"],
  allowed_worktree_files:["src/ffi.rs","src/lib.rs","tests/endpoint.rs","subject-return.json"],
  max_changed_lines:12,
  required_limitations:[],required_limitation_prefixes:["finding:","evidence:"],
  allow_additional_limitations:true}' \
  >"$stage_dir/coordinators/degraded-unsafe.json"

for subject_id in worktree-api repository-mixed degraded-unsafe; do
  cp "$stage_dir/production-payload-manifest.json" \
    "$stage_dir/coordinators/$subject_id-payload-manifest.json"
done

jq -n --arg cli "$(codex --version)" --arg rust "$(rustc +1.95.0 --version)" \
  --arg payload_hash "$payload_hash" --arg manifest_sha "$payload_manifest_sha" \
  '{schema_version:"northstar.rust-quality.production-cohort.v2",
    revision:"2026-08-26-v2-e",status:"prepared",subjects:3,reviews:3,
    frozen_runtime:{cli:$cli,model:"gpt-5.6-sol",reasoning_effort:"medium",
      rust_toolchain:$rust,isolation_method:"filesystem_enforced",
      repository_access:"packet_only"},
    payload_sha256:$payload_hash,payload_manifest_sha256:$manifest_sha}' \
  >"$stage_dir/cohort.json"

mv "$stage_dir" "$output_dir"
stage_dir=""
complete=true
jq -n --arg output "$output_dir" --arg payload "$payload_hash" \
  '{status:"ok",output:$output,payload_sha256:$payload,subjects:3,reviews:3}'
