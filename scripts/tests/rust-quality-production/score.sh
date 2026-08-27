#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

hash_file() {
  shasum -a 256 "$1" | awk '{print $1}'
}

test "$#" -eq 2 || fail "usage: score.sh <subjects|final> <cohort-dir>"
phase=$1
cohort=$(cd "$2" && pwd -P)
[[ "$phase" =~ ^(subjects|final)$ ]] || fail "invalid phase"
mkdir -p "$cohort/scored"
rows="$cohort/scored/subject-rows.ndjson"
: >"$rows"

for subject_id in worktree-api repository-mixed degraded-unsafe; do
  subject="$cohort/subjects/$subject_id"
  key="$cohort/coordinators/$subject_id.json"
  return_file="$subject/subject-return.json"
  test -f "$return_file" || fail "$subject_id return missing"
  result_rel=$(jq -r '.result_path' "$return_file")
  test "$result_rel" = '.git/northstar/rust-quality/audits/production-v2/result.json' \
    || fail "$subject_id result path is not canonical"
  result="$subject/$result_rel"
  test -f "$result" || fail "$subject_id result missing: $result_rel"
  record_root=$(dirname "$result")
  for record_file in manifest.json discovery.json scope-plan.json strict-audit.json \
    rust-quality-profile.json rust-quality-deviations.json report.md; do
    test -f "$record_root/$record_file" || fail "$subject_id audit record missing: $record_file"
  done

  expected_scope=$(jq -r '.expected_scope' "$key")
  test "$(jq -r '.scope' "$result")" = "$expected_scope" || fail "$subject_id scope mismatch"
  test "$(jq -r '.audit_id' "$result")" = production-v2 || fail "$subject_id audit mismatch"
  test "$(jq -r '.schema_version' "$result")" = northstar.rust-quality.audit-result.v2 \
    || fail "$subject_id result schema mismatch"
  test "$(hash_file "$record_root/strict-audit.json")" = "$(jq -r '.policy_sha256' "$result")" \
    || fail "$subject_id policy hash mismatch"
  test "$(hash_file "$record_root/rust-quality-profile.json")" = "$(jq -r '.profile_sha256' "$result")" \
    || fail "$subject_id profile hash mismatch"
  test "$(hash_file "$record_root/rust-quality-deviations.json")" = "$(jq -r '.deviations_sha256' "$result")" \
    || fail "$subject_id deviations hash mismatch"

  expected=$(jq -c '[.expected_findings[] | [.rule_id,.file]] | sort' "$key")
  actual=$(jq -c '[.units[].assessment.findings[] | [.rule_id,.file]] | sort' "$result")
  test "$actual" = "$expected" || fail "$subject_id finding recall/precision mismatch: $actual"
  expected_changed=$(jq -c '.required_changed_files | sort' "$key")
  actual_changed=$(jq -c '.changed_files | sort' "$result")
  jq -e --argjson required "$expected_changed" --argjson actual "$actual_changed" \
    '$required - $actual | length == 0' <<<null >/dev/null \
    || fail "$subject_id required changed scope missing: $actual_changed"
  allowed_changed=$(jq -c '.allowed_changed_files | sort' "$key")
  jq -e --argjson allowed "$allowed_changed" --argjson actual "$actual_changed" \
    '$actual - $allowed | length == 0' <<<null >/dev/null \
    || fail "$subject_id changed scope widened: $actual_changed"

  unit_count=$(jq '.units | length' "$result")
  test "$unit_count" -ge 1 || fail "$subject_id has no units"
  jq -e 'all(.units[]; (.assessment.verdicts | length) == 6 and
    ([.assessment.verdicts[].rule_id] | unique | length) == 6 and
    (.assessment.attestations | length) == 3 and
    ([.assessment.attestations[].dimension] | sort) == ["architecture","correctness_assurance","human_quality"])' \
    "$result" >/dev/null || fail "$subject_id ledger incomplete"
  while IFS= read -r unit_id; do
    for record_file in assessment.json completion.json; do
      test -f "$record_root/units/$unit_id/$record_file" \
        || fail "$subject_id unit record missing: $unit_id/$record_file"
    done
  done < <(jq -r '.units[].unit_id' "$result")

  while IFS= read -r limitation_key; do
    jq -e --arg key "$limitation_key" '.limitations | any(.key == $key)' "$result" >/dev/null \
      || fail "$subject_id missing limitation: $limitation_key"
  done < <(jq -r '.required_limitations[]' "$key")
  while IFS= read -r limitation_prefix; do
    jq -e --arg prefix "$limitation_prefix" '.limitations | any(.key | startswith($prefix))' "$result" >/dev/null \
      || fail "$subject_id missing limitation prefix: $limitation_prefix"
  done < <(jq -r '.required_limitation_prefixes[]' "$key")
  if [[ "$(jq -r '.allow_additional_limitations' "$key")" == false ]]; then
    test "$(jq '.limitations | length' "$result")" -eq 0 \
      || fail "$subject_id has unexpected limitations"
  fi
  if [[ "$subject_id" == degraded-unsafe ]]; then
    jq -e '.units[].evidence | any(.evidence_class == "scanner" and .status == "unavailable")' \
      "$result" >/dev/null || fail "$subject_id lacks unavailable scanner evidence"
  fi

  payload_manifest="$cohort/coordinators/$subject_id-payload-manifest.json"
  while IFS=$'\t' read -r relative expected_hash; do
    file="$subject/.agents/skills/northstar/$relative"
    test -f "$file" || fail "$subject_id payload file missing: $relative"
    test "$(hash_file "$file")" = "$expected_hash" || fail "$subject_id payload drift: $relative"
  done < <(jq -r '.[] | [.path,.sha256] | @tsv' "$payload_manifest")
  "$subject/.northstar/bin/northstar-rust-quality" verify-install \
    --source-root "$subject/.agents/skills/northstar/tools/rust-quality" >/dev/null \
    || fail "$subject_id installed payload verification failed"

  changed=$(git -C "$subject" status --porcelain | sed -E 's/^.. //' | LC_ALL=C sort | jq -Rsc 'split("\n") | map(select(length > 0))')
  allowed=$(jq -c '.allowed_worktree_files | sort' "$key")
  jq -e --argjson allowed "$allowed" --argjson actual "$changed" \
    '$actual - $allowed | length == 0 and ($actual | index("subject-return.json") != null)' \
    <<<null >/dev/null || fail "$subject_id hidden worktree mutation: $changed"
  test ! -e "$subject/PAPERCUTS.md" || fail "$subject_id created PAPERCUTS.md"

  cargo +1.95.0 test --locked --manifest-path "$subject/Cargo.toml" >/dev/null 2>&1
  if [[ "$subject_id" != degraded-unsafe ]]; then
    cargo +1.95.0 clippy --locked --manifest-path "$subject/Cargo.toml" --all-targets -- -D warnings >/dev/null 2>&1
  fi

  changed_lines=0
  start_root="$cohort/coordinators/$subject_id-audit-start"
  while IFS= read -r changed_file; do
    test -f "$start_root/$changed_file" || fail "$subject_id audit-start snapshot missing: $changed_file"
    line_delta=$(git diff --no-index --numstat -- \
      "$start_root/$changed_file" "$subject/$changed_file" 2>/dev/null | \
      awk '{print $1 + $2}' || true)
    changed_lines=$((changed_lines + ${line_delta:-0}))
  done < <(jq -r '.changed_files[]' "$result")
  max_changed_lines=$(jq '.max_changed_lines' "$key")
  test "$changed_lines" -le "$max_changed_lines" \
    || fail "$subject_id churn exceeded: $changed_lines > $max_changed_lines"

  jq -nc --arg subject_id "$subject_id" --arg result_path "$result_rel" \
    --arg result_sha256 "$(hash_file "$result")" --argjson changed_lines "$changed_lines" \
    --argjson findings "$(jq '[.units[].assessment.findings[]] | length' "$result")" \
    --argjson changed_files "$(jq '.changed_files | length' "$result")" \
    --argjson limitations "$(jq '.limitations | length' "$result")" \
    '{subject_id:$subject_id,status:"passed",result_path:$result_path,
      result_sha256:$result_sha256,findings:$findings,changed_files:$changed_files,
      limitations:$limitations,changed_lines:$changed_lines}' >>"$rows"
done
jq -s '{schema_version:"northstar.rust-quality.production-subject-score.v2",
  status:"passed",subjects:length,rows:.}' "$rows" >"$cohort/scored/subjects.json"

if [[ "$phase" == final ]]; then
  test -f "$cohort/review-map.json" || fail "review map missing"
  review_rows="$cohort/scored/review-rows.ndjson"
  : >"$review_rows"
  while IFS=$'\t' read -r review_id subject_id; do
    review="$cohort/reviewers/$review_id/review.json"
    test -f "$review" || fail "$review_id result missing"
    jq -e --arg review_id "$review_id" --arg subject_id "$subject_id" '
      .review_id == $review_id and .subject_id == $subject_id and .verdict == "accept" and
      (.dimensions | keys | sort) == ["architecture","correctness","evidence_integrity","human_quality","scope_preservation"] and
      all(.dimensions[]; .score >= 4 and .score <= 5 and (.evidence | length) > 0) and
      (.concerns | type == "array") and (.runtime | type == "string") and
      (.runtime_version | type == "string") and .reasoning_effort == "medium"
    ' "$review" >/dev/null || fail "$review_id rejected or malformed"
    jq -c '{review_id,subject_id,verdict,
      minimum_score:([.dimensions[].score]|min),concerns}' "$review" >>"$review_rows"
  done < <(jq -r '.reviews[] | [.review_id,.subject_id] | @tsv' "$cohort/review-map.json")
  jq -s '{schema_version:"northstar.rust-quality.production-review-score.v2",
    status:"passed",reviews:length,rows:.}' "$review_rows" >"$cohort/scored/reviews.json"
  jq -n --slurpfile subjects "$cohort/scored/subjects.json" \
    --slurpfile reviews "$cohort/scored/reviews.json" \
    --arg payload "$(jq -r '.payload_sha256' "$cohort/cohort.json")" \
    '{schema_version:"northstar.rust-quality.production-decision.v2",status:"passed",
      payload_sha256:$payload,subjects:$subjects[0],reviews:$reviews[0],
      decision:"eligible_for_distribution_card"}' >"$cohort/scored/decision.json"
  jq . "$cohort/scored/decision.json"
else
  jq . "$cohort/scored/subjects.json"
fi
