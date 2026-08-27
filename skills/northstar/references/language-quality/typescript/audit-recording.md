# TypeScript And Svelte Audit Recording Contract

Invoke the installed skill-local recorder through:

```text
effigy --repo <northstar-skill-root> northstar/typescript-quality:record <operation> ...
```

Records live at `<target>/.effigy/typescript-quality/audits/<audit-id>/`.
Inputs are transient JSON outside that root; all file paths are target-relative.

## Lifecycle

`init <target-root> <manifest-input.json>` records `audit_id`, strict profile,
`worktree|repository` scope, the full dirty-file disposition, scope evidence,
and non-empty disjoint units (`unit_id`, `primary_file`, `owned_files`). The
recorder hashes the catalogue, profile, deviations, owned files, and excluded
dirty files itself.

`assess <target-root> <audit-id> <assessment.json>` accepts one unit with
`findings` and `repair_plans`. A finding supplies `rule_id`, `confidence`,
`action`, exact `location` (file plus symbol or one-based line span), evidence,
and disposition. The recorder derives maturity, enforcement, and authority.
Plans require a matching `repair_planned` finding, owned files, and non-empty
`preserved_behavior`. A `review_required` finding may instead use `reported`
when the auditor retains it without mutation; it has no repair plan and is
carried into `remaining_limitations`.

`extend <target-root> <audit-id> <extension.json>` adds files before mutation.
It requires a reason and may include findings, plans, and `plan_extensions` for
an existing rule/action plan. It rejects files already owned by another unit or
files changed before extension.

`complete <target-root> <audit-id> <completion.json>` accounts for every plan as
`applied` or `not_applied`, with exact changed files. Any applied repair requires
passing local evidence objects shaped as:

```json
{
  "evidence_class": "compiler|framework|lint|test",
  "selector": "repository-owned selector or command",
  "package_cwd": "packages/web",
  "environment": "host|container-name",
  "status": "passed|failed|unavailable",
  "exit_status": 0,
  "diagnostics": ["captured summary or artifact path"],
  "warning_count": 0,
  "failure_stage": "none|routing|startup|configuration|collection|source"
}
```

Passing means zero exit, zero warnings, and `failure_stage: none`. Pre-source
failures must be `unavailable`. Evidence classes do not substitute for one
another.

`finalize <target-root> <audit-id>` writes `result.json` only after all units
complete and policy, ownership, attribution, and preservation checks pass. It
refuses a second finalization. Start a new audit if policy changes.
