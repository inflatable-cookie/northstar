#!/usr/bin/env bash

set -euo pipefail

harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
temporary=$(mktemp -d)
trap 'rm -r "$temporary"' EXIT

for script in prepare.sh run-subject.sh score.sh prepare-reviews.sh run-reviewer.sh; do
  bash -n "$harness_dir/$script"
done

cohort="$temporary/cohort"
"$harness_dir/prepare.sh" "$cohort" >/dev/null
test "$(jq '.subjects' "$cohort/cohort.json")" -eq 3
test "$(find "$cohort/subjects" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" -eq 3
test "$(find "$cohort/coordinators" -name '*.json' | wc -l | tr -d ' ')" -eq 6
test "$(jq -r '.frozen_runtime.model' "$cohort/cohort.json")" = gpt-5.6-sol
test "$(jq -r '.frozen_runtime.reasoning_effort' "$cohort/cohort.json")" = medium
test "$(jq -r '.scope' "$cohort/subjects/worktree-api/production-payload.json")" = worktree
test "$(jq -r '.scope' "$cohort/subjects/repository-mixed/production-payload.json")" = repository
test -n "$(git -C "$cohort/subjects/worktree-api" status --porcelain src/lib.rs)"
test -z "$(git -C "$cohort/subjects/repository-mixed" status --porcelain)"

set +e
"$harness_dir/score.sh" subjects "$cohort" >"$temporary/score.out" 2>"$temporary/score.err"
status=$?
set -e
test "$status" -ne 0
rg -q 'worktree-api return missing' "$temporary/score.err"

jq -n '{status:"ok",prepared_subjects:3,frozen_runtime_paths:2,
  worktree_paths:2,repository_paths:1,negative_score_paths:1}'
