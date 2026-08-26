# Rust Audit Recording Contract

Locate the installed `northstar` skill root, then invoke:

```text
effigy --repo <northstar-skill-root> northstar/rust-quality:record <operation> ...
```

Records live under
`<target>/.effigy/rust-quality/audits/<audit-id>/`. Use repository-relative file
paths. JSON inputs are transient scratch files outside the record root; the
recorder writes canonical manifest, unit, and result records.

## Initialize

```text
... rust-quality:record init <target-root> <manifest-input.json>
```

Manifest input:

```json
{
  "audit_id": "rust-audit-20260825",
  "profile": "strict",
  "scope": "worktree",
  "initial_state": {
    "dirty_files": [
      {"file": "src/lib.rs", "states": ["staged", "unstaged"]}
    ],
    "in_scope_files": ["src/lib.rs"],
    "excluded_dirty_files": [],
    "scope_evidence": ["git status and repository scope inventory"]
  },
  "units": [
    {
      "unit_id": "core-errors",
      "primary_file": "src/lib.rs",
      "owned_files": ["src/lib.rs"]
    }
  ]
}
```

Every dirty file must be in scope or appear in `excluded_dirty_files` with a
non-empty reason. The initial in-scope set must exactly equal the union of
disjoint unit ownership. The recorder reads and hashes the canonical strict
profile and deviations file itself.

## Assess

```text
... rust-quality:record assess <target-root> <audit-id> <assessment.json>
```

```json
{
  "unit_id": "core-errors",
  "findings": [
    {
      "rule_id": "RUST-ERR-001",
      "confidence": "high",
      "action": "represent_failure",
      "location": {"file": "src/lib.rs", "symbol": "parse"},
      "evidence": "Malformed input reaches unwrap in a public path.",
      "disposition": "repair_planned"
    }
  ],
  "repair_plans": [
    {
      "rule_id": "RUST-ERR-001",
      "action": "represent_failure",
      "owned_files": ["src/lib.rs"],
      "preserved_behavior": ["valid input returns the same parsed value"]
    }
  ]
}
```

Locations need a symbol or a one-based inclusive `line_span`. Dispositions are
`repair_planned`, `reported`, `deviation`, or `operator_decision`; the recorder
derives maturity, enforcement, and authority from the catalogue and rejects a
mismatched disposition or unauthorized plan.

Use action `change_foreign_error_policy` with disposition
`operator_decision` when a repair would need new or changed foreign error
signaling. Record the stop without a repair plan.

## Extend before mutation

```text
... rust-quality:record extend <target-root> <audit-id> <extension.json>
```

```json
{
  "unit_id": "core-errors",
  "files": ["tests/parse.rs"],
  "reason": "direct regression test for the planned repair",
  "findings": [],
  "repair_plans": [],
  "plan_extensions": [
    {
      "rule_id": "RUST-ERR-001",
      "action": "represent_failure",
      "files": ["tests/parse.rs"]
    }
  ]
}
```

An extension may add independently justified findings and plans using the
assessment shapes. `plan_extensions` widens an existing plan to the named new
files before mutation; it cannot name an unrelated file or nonexistent plan.
Never manufacture a finding merely to widen scope.

## Complete

```text
... rust-quality:record complete <target-root> <audit-id> <completion.json>
```

```json
{
  "unit_id": "core-errors",
  "repairs": [
    {
      "rule_id": "RUST-ERR-001",
      "action": "represent_failure",
      "status": "applied",
      "changed_files": ["src/lib.rs"]
    }
  ],
  "validation": [
    {
      "selector": "effigy test:errors",
      "status": "passed",
      "evidence": "focused error-path tests passed"
    }
  ]
}
```

Every plan needs an `applied` or `not_applied` completion. Applied changes must
exactly equal file changes derived from hashes, stay inside that plan's owned
files, and have passing local validation.

## Finalize

```text
... rust-quality:record finalize <target-root> <audit-id>
```

Read `result.json` from the record root. Finalization is deterministic and
refuses a second run. Restart with a new audit ID if repository policy or
accepted deviations change during the audit.
