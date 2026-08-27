#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

escape_seatbelt() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

test "$#" -eq 2 || fail "usage: run-subject.sh <cohort-dir> <subject-id>"
harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
repository_root=$(git -C "$harness_dir" rev-parse --show-toplevel)
cohort_root=$(cd "$1" && pwd -P)
subject_id=$2
[[ "$subject_id" =~ ^(worktree-api|repository-mixed|degraded-unsafe)$ ]] \
  || fail "unknown subject: $subject_id"
subject="$cohort_root/subjects/$subject_id"
coordinator="$cohort_root/coordinators/$subject_id.json"
runtime="$cohort_root/runtime/$subject_id"
test -d "$subject" || fail "subject missing"
test -f "$coordinator" || fail "coordinator key missing"
test ! -e "$runtime" || fail "subject runtime already exists"
mkdir -p "$runtime"

codex_bin=$(command -v codex) || fail "codex missing"
codex_version=$($codex_bin --version)
test "$codex_version" = "$(jq -r '.frozen_runtime.cli' "$cohort_root/cohort.json")" \
  || fail "Codex runtime drift"
test "gpt-5.6-sol" = "$(jq -r '.frozen_runtime.model' "$cohort_root/cohort.json")" \
  || fail "model authority drift"
test "medium" = "$(jq -r '.frozen_runtime.reasoning_effort' "$cohort_root/cohort.json")" \
  || fail "reasoning authority drift"

profile="$runtime/subject.sb"
repo_escaped=$(escape_seatbelt "$repository_root")
subject_escaped=$(escape_seatbelt "$subject")
runtime_escaped=$(escape_seatbelt "$runtime")
cohort_escaped=$(escape_seatbelt "$cohort_root")
{
  printf '%s\n' '(version 1)' '(allow default)' '(deny file-write*)'
  printf '(allow file-write* (subpath "%s") (subpath "%s"))\n' \
    "$subject_escaped" "$runtime_escaped"
  printf '(deny file-read* file-write* (subpath "%s")' "$repo_escaped"
  printf ' (subpath "%s/coordinators")' "$cohort_escaped"
  printf ' (literal "%s/cohort.json")' "$cohort_escaped"
  for sibling in worktree-api repository-mixed degraded-unsafe; do
    if [[ "$sibling" != "$subject_id" ]]; then
      printf ' (subpath "%s/subjects/%s")' "$cohort_escaped" "$sibling"
    fi
  done
  printf ')\n'
} >"$profile"

set +e
(
  cd "$subject"
  /usr/bin/sandbox-exec -f "$profile" /bin/sh -c \
    'test -r README.md && ! test -r "$1" && ! test -r "$2" && : >"$3" && ! mkdir "$4"' \
    sh "$coordinator" "$repository_root/README.md" "$runtime/write-probe" \
    "$cohort_root/outside-write"
) 2>"$runtime/isolation-stderr.log"
probe_status=$?
set -e
test "$probe_status" -eq 0 || fail "subject isolation probe failed"

user_codex_home=${CODEX_HOME:-"$HOME/.codex"}
test -f "$user_codex_home/auth.json" || fail "Codex auth missing"
ln -s "$user_codex_home/auth.json" "$runtime/auth.json"

events="$runtime/events.jsonl"
stderr_log="$runtime/stderr.log"
final_message="$runtime/final-message.txt"
agent_id="subject-$subject_id-$(od -An -N3 -tx1 /dev/urandom | tr -d ' \n')"
prompt="You are isolated production-evidence agent $agent_id working packet $subject_id. Work only inside this packet. Read README.md and follow the bundled Northstar Rust explicit-audit route exactly. Do not inspect coordinator data, sibling subjects, the Northstar checkout, expected outcomes, or prior evidence. Use the supplied verified Cargo-native tool and canonical Git-metadata records. Finish the audit, validate it, and create subject-return.json with the exact requested keys. Its subject_id must be exactly $subject_id from production-payload.json, never the runtime agent ID, and result_path must be the exact relative path required by README.md. Record runtime as codex-cli/gpt-5.6-sol, runtime_version as $codex_version, and reasoning_effort as medium. Return a terse completion note."
started=$(date +%s)
set +e
(
  cd "$subject"
  CODEX_HOME="$runtime" /usr/bin/sandbox-exec -f "$profile" \
    "$codex_bin" exec --dangerously-bypass-approvals-and-sandbox \
      --skip-git-repo-check --ephemeral --ignore-user-config --ignore-rules \
      -C "$subject" -m gpt-5.6-sol -c 'model_reasoning_effort="medium"' \
      --json -o "$final_message" "$prompt" </dev/null >"$events" 2>"$stderr_log"
)
exit_status=$?
set -e
finished=$(date +%s)
tool_invocations=$(jq -s '[.[] | select(.type == "item.started" and .item.type == "command_execution")] | length' "$events")
jq -n --arg subject_id "$subject_id" --arg agent_id "$agent_id" \
  --arg runtime_version "$codex_version" --argjson exit_status "$exit_status" \
  --argjson elapsed_seconds "$((finished - started))" \
  --argjson tool_invocations "$tool_invocations" \
  '{subject_id:$subject_id,agent_id:$agent_id,runtime:"codex-cli/gpt-5.6-sol",
    runtime_version:$runtime_version,reasoning_effort:"medium",
    isolation_method:"filesystem_enforced",repository_access:"packet_only",
    exit_status:$exit_status,elapsed_seconds:$elapsed_seconds,
    tool_invocations:$tool_invocations}' >"$runtime/launch.json"
test "$exit_status" -eq 0 || fail "subject runtime failed: $exit_status"
test -f "$subject/subject-return.json" || fail "subject return missing"
jq -e --arg id "$subject_id" --arg version "$codex_version" '
  (keys | sort) == ["audit_id","limitations","reasoning_effort","result_path","runtime","runtime_version","subject_id"] and
  .subject_id == $id and .audit_id == "production-v2" and
  .runtime == "codex-cli/gpt-5.6-sol" and .runtime_version == $version and
  .reasoning_effort == "medium" and (.limitations | type == "array")
' "$subject/subject-return.json" >/dev/null || fail "subject return invalid"
jq . "$runtime/launch.json"
