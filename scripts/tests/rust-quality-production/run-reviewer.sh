#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

escape_seatbelt() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

test "$#" -eq 2 || fail "usage: run-reviewer.sh <cohort-dir> <review-id>"
harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
repository_root=$(git -C "$harness_dir" rev-parse --show-toplevel)
cohort=$(cd "$1" && pwd -P)
review_id=$2
[[ "$review_id" =~ ^review-[a-f0-9]{12}$ ]] || fail "invalid review ID"
packet="$cohort/reviewers/$review_id"
runtime="$cohort/review-runtime/$review_id"
test -d "$packet" || fail "review packet missing"
test ! -e "$runtime" || fail "review runtime already exists"
mkdir -p "$runtime/scratch"
subject_id=$(jq -r --arg id "$review_id" '.reviews[] | select(.review_id == $id) | .subject_id' \
  "$cohort/review-map.json")
test -n "$subject_id" && test "$subject_id" != null || fail "review map entry missing"

codex_bin=$(command -v codex) || fail "codex missing"
codex_version=$($codex_bin --version)
test "$codex_version" = "$(jq -r '.frozen_runtime.cli' "$cohort/cohort.json")" \
  || fail "Codex runtime drift"
profile="$runtime/reviewer.sb"
repo_escaped=$(escape_seatbelt "$repository_root")
packet_escaped=$(escape_seatbelt "$packet")
runtime_escaped=$(escape_seatbelt "$runtime")
cohort_escaped=$(escape_seatbelt "$cohort")
{
  printf '%s\n' '(version 1)' '(allow default)' '(deny file-write*)'
  printf '(allow file-write* (subpath "%s") (literal "%s/review.json"))\n' \
    "$runtime_escaped" "$packet_escaped"
  printf '(deny file-read* file-write* (subpath "%s")' "$repo_escaped"
  printf ' (subpath "%s/subjects") (subpath "%s/coordinators")' "$cohort_escaped" "$cohort_escaped"
  printf ' (subpath "%s/runtime") (literal "%s/cohort.json")' "$cohort_escaped" "$cohort_escaped"
  printf ' (literal "%s/review-map.json")' "$cohort_escaped"
  while IFS= read -r sibling; do
    if [[ "$sibling" != "$review_id" ]]; then
      printf ' (subpath "%s/reviewers/%s")' "$cohort_escaped" "$sibling"
    fi
  done < <(jq -r '.reviews[].review_id' "$cohort/review-map.json")
  printf ')\n'
} >"$profile"

set +e
(
  cd "$packet"
  /usr/bin/sandbox-exec -f "$profile" /bin/sh -c \
    'test -r README.md && ! test -r "$1" && ! test -r "$2" && : >"$3" && ! mkdir "$4"' \
    sh "$cohort/coordinators/$subject_id.json" "$repository_root/README.md" \
    "$runtime/write-probe" "$cohort/outside-review-write"
) 2>"$runtime/isolation-stderr.log"
probe_status=$?
set -e
test "$probe_status" -eq 0 || fail "review isolation probe failed"

user_codex_home=${CODEX_HOME:-"$HOME/.codex"}
test -f "$user_codex_home/auth.json" || fail "Codex auth missing"
ln -s "$user_codex_home/auth.json" "$runtime/auth.json"
prompt="You are isolated blind reviewer $review_id. Work only from this review packet. Read README.md and inspect all supplied evidence independently. Do not inspect the source repository, subjects, coordinator data, review map, sibling reviews, expected outcomes, or prior scores. Write the exact review.json requested. Record runtime as codex-cli/gpt-5.6-sol, runtime_version as $codex_version, and reasoning_effort as medium. Validate JSON and return only a terse completion note."
started=$(date +%s)
set +e
(
  cd "$packet"
  REVIEW_SCRATCH="$runtime/scratch" CODEX_HOME="$runtime" \
    /usr/bin/sandbox-exec -f "$profile" "$codex_bin" exec \
      --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
      --ephemeral --ignore-user-config --ignore-rules -C "$packet" \
      -m gpt-5.6-sol -c 'model_reasoning_effort="medium"' --json \
      -o "$runtime/final-message.txt" "$prompt" </dev/null \
      >"$runtime/events.jsonl" 2>"$runtime/stderr.log"
)
exit_status=$?
set -e
finished=$(date +%s)
tool_invocations=$(jq -s '[.[] | select(.type == "item.started" and .item.type == "command_execution")] | length' "$runtime/events.jsonl")
jq -n --arg review_id "$review_id" --arg subject_id "$subject_id" \
  --arg version "$codex_version" --argjson exit_status "$exit_status" \
  --argjson elapsed_seconds "$((finished-started))" --argjson tools "$tool_invocations" \
  '{review_id:$review_id,subject_id:$subject_id,runtime:"codex-cli/gpt-5.6-sol",
    runtime_version:$version,reasoning_effort:"medium",isolation_method:"filesystem_enforced",
    repository_access:"review_packet_only",exit_status:$exit_status,
    elapsed_seconds:$elapsed_seconds,tool_invocations:$tools}' >"$runtime/launch.json"
test "$exit_status" -eq 0 || fail "review runtime failed: $exit_status"
test -f "$packet/review.json" || fail "review result missing"
jq empty "$packet/review.json" || fail "review JSON invalid"
jq . "$runtime/launch.json"
