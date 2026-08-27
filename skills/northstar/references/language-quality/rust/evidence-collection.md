# Rust Mechanical Evidence Collection

Load this only while assembling audit evidence or closing an everyday Rust
tranche. First ensure the binary through `tool-bootstrap.md`.

The tool executes an explicit JSON evidence plan. It does not discover a
universal command graph, invoke a shell, install dependencies, fix findings, or
turn diagnostics into repair authority. Resolve selectors from the active
profile, repository tasks, direct Cargo ownership, or agent inspection and mark
the `origin` accordingly: `profile`, `repository_task`, `cargo_native`, or
`agent_resolved`.

Each request supplies:

- stable `evidence_id`; audit requests also supply `unit_id`;
- `evidence_class`: `compiler`, `lint`, `docs`, `test`, `graph`, or `scanner`;
- human-readable `selector`, repository-relative `package_cwd`, and concrete
  `environment`;
- `execution.kind: command` with exact `program`, argument array, and `format`
  (`cargo_json` or `generic`); or
- `execution.kind: unavailable` with `failure_stage` and diagnostics, or
  `execution.kind: unrun` with a reason.

Declare every applicable class in `applicable_classes`. A class without a
request becomes an `unrun` limitation. Use `unavailable` for a known routing,
configuration, startup, or collection barrier, including an unavailable
external service. A process launch failure is normalized as `startup`.

For Cargo compiler diagnostics, include
`--message-format=json-diagnostic-rendered-ansi`. The adapter preserves stdout
and stderr as hashed artifacts, records exit status and warnings, and maps exact
upstream identifiers to `catalogue_evidence` plus the qualification ledger's
`mapping_disposition`. The disposition says whether the diagnostic was promoted
for enforcement or evidence, remains evaluation-only, or requires manual
classification. The mapping is evidence-only: it never creates a finding or
repair plan. An agent verdict remains mandatory before either exists.

## Audit collection

```text
<tool> collect --repo <repo> --audit <audit-id> --input <evidence-plan.json>
```

Records are immutable under the audit's Git-metadata `evidence/` directory.
Unit completion names `evidence_ids`; the tool rechecks record and raw-artifact
hashes. A warning-bearing zero exit is `warning`, not `passed`. Applied repairs
require at least one referenced `passed` record for that unit.

## Everyday closeout

```text
<tool> closeout --repo <repo> --input <closeout-input.json> --output <closeout.json>
```

The input contains `applicable_rules` plus `evidence_plan`; everyday requests
omit `unit_id`. The result contains only changed paths, anchors, applicable
rules, compact statuses, identifiers, catalogue evidence, and limitations.
Compact evidence also carries the distinct mapping dispositions seen in each
record.
Raw artifacts remain outside the worktree under Git metadata. This operation
does not initialize or load an audit ledger.
