# Rust Audit Recording Contract

First follow `tool-bootstrap.md`. In the commands below, `<tool>` is the
verified absolute payload binary and `<repo>` is the consumer Git root. JSON
inputs are scratch files outside the worktree. Canonical records live under
the repository's Git metadata at:

```text
<git-path>/northstar/rust-quality/audits/<audit-id>/
```

This needs no `.gitignore` entry and no consumer Effigy catalogue.

## Discover and freeze scope

```text
<tool> inspect --repo <repo> --scope <worktree|repository> --output <discovery.json>
<tool> plan --discovery <discovery.json> --input <plan-input.json> --output <scope-plan.json>
```

Worktree plans partition discovered dirty Rust anchors into assessed units.
Every dirty file is owned as an anchor or related read-only context, or is
explicitly excluded with a reason. Repository plans additionally carry exact
Cargo-discovered workspaces, packages, targets, features, public API surfaces,
and risk boundaries. Context relations are `owning_manifest`, `caller`,
`implementation`, `focused_test`, `governed_documentation`,
`architecture_contract`, or `tool_configuration`.

Initialize before source assessment or mutation:

```text
<tool> init --repo <repo> --discovery <discovery.json> \
  --plan <scope-plan.json> --rules <skill>/references/language-quality/rust/strict-audit.json \
  --profile <repo>/docs/contracts/rust-quality-profile.json \
  --deviations <repo>/docs/contracts/rust-quality-deviations.json
```

Initialization reruns discovery and rejects stale state. It snapshots mutable,
read-only, and excluded files plus the checked projection, repository profile,
and accepted deviations. A `deviation` finding must match an accepted rule and
file scope with non-empty owner, reason, evidence, and recheck trigger.

## Assess every unit

```text
<tool> assess --repo <repo> --audit <audit-id> --input <assessment.json>
```

An assessment contains exactly one verdict for each approved normative rule.
Verdicts are `pass`, `finding`, `not_applicable`, or `degraded`; each names
inspected surfaces and evidence. `finding` links findings, `not_applicable`
supplies applicability evidence, and `degraded` links structured limitations.
It also contains exactly one non-empty attestation for each dimension:
`correctness_assurance`, `architecture`, and `human_quality`.

Findings name `finding_id`, `rule_id`, `action`, repository-relative `file`,
evidence, and disposition. Repair plans name `plan_id`, linked finding IDs,
mutable owned files, and preserved behavior. The tool derives remediation
authority from the checked projection and rejects report-only or
operator-decision plans. Empty findings never substitute for verdicts.

## Extend before mutation

```text
<tool> extend --repo <repo> --audit <audit-id> --input <extension.json>
```

An extension names a unit, non-empty reason, files with anchor relations, and
the existing repair plan that owns each file. Every extension file must be
unowned, tied to one unit anchor, attributed to exactly one authorized plan,
and unchanged when recorded. Extension after any audit-owned mutation fails.

## Complete a unit

```text
<tool> complete --repo <repo> --audit <audit-id> --input <completion.json>
```

Supply exactly one `applied` or `not_applied` completion per repair plan.
Applied entries name exact changed files and require non-empty passing
mechanical evidence. First load `evidence-collection.md` and run:

```text
<tool> collect --repo <repo> --audit <audit-id> --input <evidence-plan.json>
```

Completion names the immutable `evidence_ids`, not agent-authored pass claims.
The tool verifies record and raw-artifact hashes. Derived fingerprints must
equal the union of applied repair files. Read-only and excluded files must
remain unchanged.

## Finalize

```text
<tool> finalize --repo <repo> --audit <audit-id>
```

Finalization requires every unit assessment and completion, rechecks policy and
fingerprints, and refuses a second run. It derives all changed files and
limitations from unit-local records, then writes deterministic `result.json`
and `report.md`. A retained finding, operator decision, explicit degraded
verdict, unapplied plan, or warning/failed/unavailable/unrun evidence remains a
structured limitation; the Markdown report is rendered from that exact list.
