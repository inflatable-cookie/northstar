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
  (`cargo_json`, `stopslop_json`, or `generic`); or
- `execution.kind: unavailable` with `failure_stage` and diagnostics, or
  `execution.kind: unrun` with a reason.

Declare every applicable class in `applicable_classes`. A class without a
request becomes an `unrun` limitation for each unit in the call's resolved
scope that still lacks sealed coverage for that class. Existing immutable
unit/class records stay authoritative: a later partial plan must not invent
contradictory `unrun` evidence for them, a colliding request for an already
represented unit/class fails before any new record is written, and two
requests in one plan for the same unit/class are rejected before execution.
With no requests, scope is every audit unit (or the closeout root). With
requests, scope is only the units those requests name. Use `unavailable` for a
known routing, configuration, startup, or collection barrier, including an
unavailable external service. A process launch failure is normalized as
`startup`.

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

## Exact-forwarder candidate scan

For `RUST-SLOP-001`, use the verified audit-only scanner from
`tool-bootstrap.md` as a `scanner` request. Run it from the resolved audit root:

```json
{
  "evidence_id": "forwarders-<unit-id>",
  "unit_id": "<unit-id>",
  "evidence_class": "scanner",
  "selector": "stopslop 0.5.1 SLOP039",
  "origin": "agent_resolved",
  "package_cwd": ".",
  "environment": "<actual audit environment>",
  "execution": {
    "kind": "command",
    "program": "<absolute-scanner-root>/bin/stopslop",
    "args": ["--no-config", "--select", "SLOP039", "--format", "json", "<owned-rust-path>..."],
    "format": "stopslop_json"
  }
}
```

The adapter maps `SLOP039` to evaluation-only `RUST-SLOP-001` evidence and
retains raw output. Submit one request per unit with its complete owned Rust
path set. Record every returned candidate, then classify its actual
responsibility manually. stopslop excludes test-like, generated, and vendored
paths; include those exclusions in the coverage statement and add manually
identified in-scope candidates to the same ledger. A missing scanner is an
explicit limitation, not clean evidence.
