#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

test "$#" -eq 1 || fail "usage: prepare-reviews.sh <cohort-dir>"
cohort=$(cd "$1" && pwd -P)
test -f "$cohort/scored/subjects.json" || fail "subjects must pass before review preparation"
test "$(jq -r '.status' "$cohort/scored/subjects.json")" = passed || fail "subject score not passing"
test ! -e "$cohort/reviewers" || fail "review packets already exist"
mkdir -p "$cohort/reviewers" "$cohort/review-runtime"
: >"$cohort/review-rows.ndjson"

for subject_id in worktree-api repository-mixed degraded-unsafe; do
  review_id="review-$(od -An -N6 -tx1 /dev/urandom | tr -d ' \n')"
  packet="$cohort/reviewers/$review_id"
  subject="$cohort/subjects/$subject_id"
  result_rel=$(jq -r '.result_path' "$subject/subject-return.json")
  mkdir -p "$packet/before" "$packet/after"
  while IFS= read -r source_file; do
    mkdir -p "$packet/before/$(dirname "$source_file")" "$packet/after/$(dirname "$source_file")"
    cp "$cohort/coordinators/$subject_id-audit-start/$source_file" \
      "$packet/before/$source_file"
    cp "$subject/$source_file" "$packet/after/$source_file"
  done < <(git -C "$subject" ls-files 'src/*.rs' 'tests/*.rs' \
    'crates/*/src/*.rs' 'crates/*/tests/*.rs')
  cp "$subject/$result_rel" "$packet/audit-result.json"
  cp "$(dirname "$subject/$result_rel")/report.md" "$packet/audit-report.md"
  : >"$packet/repair.diff"
  while IFS= read -r changed_file; do
    git diff --no-index -- \
      "$cohort/coordinators/$subject_id-audit-start/$changed_file" \
      "$subject/$changed_file" >>"$packet/repair.diff" || true
  done < <(jq -r '.changed_files[]' "$subject/$result_rel")
  cp "$subject/README.md" "$packet/operator-request.md"
  cp "$subject/Cargo.toml" "$packet/Cargo.toml"
  if [[ -f "$subject/docs/architecture/api.md" ]]; then
    mkdir -p "$packet/docs/architecture"
    cp "$subject/docs/architecture/api.md" "$packet/docs/architecture/api.md"
  fi
  printf '%s\n' \
    '# Blind Rust v2 audit review' '' \
    'Independently review the supplied before/after Rust source, repair diff,' \
    'operator request, audit result, and rendered report. You have no answer key,' \
    'rule labels to recover, prior score, track identity, or sibling result.' \
    'Judge whether the audit found the material defects visible in the packet,' \
    'used sound authority, preserved behavior and scope, produced readable code,' \
    'and honestly represented mechanical evidence and limitations.' '' \
    'Write `review.json` with exactly: review_id, subject_id, verdict (`accept`' \
    'or `reject`), dimensions, concerns, runtime, runtime_version, and' \
    'reasoning_effort. Dimensions must contain exactly correctness, architecture,' \
    'human_quality, evidence_integrity, and scope_preservation. Each dimension' \
    'has integer score 1-5 and a non-empty evidence array. Accept only when every' \
    'dimension is at least 4 and no material concern remains.' \
    >"$packet/README.md"
  jq -nc --arg review_id "$review_id" --arg subject_id "$subject_id" \
    '{review_id:$review_id,subject_id:$subject_id}' >>"$cohort/review-rows.ndjson"
done
jq -s '{schema_version:"northstar.rust-quality.production-review-map.v2",reviews:.}' \
  "$cohort/review-rows.ndjson" >"$cohort/review-map.json"
rm "$cohort/review-rows.ndjson"

find "$cohort/subjects" "$cohort/runtime" -type f -print | LC_ALL=C sort | while IFS= read -r file; do
  shasum -a 256 "$file"
done >"$cohort/raw-subject-evidence.sha256"
jq . "$cohort/review-map.json"
