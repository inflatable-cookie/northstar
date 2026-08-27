# 096 - Add Rust Mechanical Evidence Adapters

Status: complete
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/033-rust-audit-v2-tool-enforcement.md`
Roadmap ref: `g02.032`
Governing refs: `docs/contracts/004-language-quality-pack.md`, cards 094-095
Auto-start next card: no

## Objective

Add checked adapters that collect and normalize repository-native Rust evidence
without mistaking tool output for source-review judgment.

## Scope

- profile-declared or repository-resolved compiler, lint, docs, test, and
  optional graph/scanner selectors;
- raw diagnostics, environment, exit status, warning count, and failure stage;
- mapping from exact upstream diagnostic identifiers to catalogue evidence;
- lightweight changed-tranche output for everyday authoring closeout;
- no blanket command graph, dependency install, automatic fix, or new rule.

## Acceptance criteria

- [x] adapters preserve raw evidence and distinguish source failure from
  routing, configuration, startup, and collection failure;
- [x] zero-exit warning-bearing evidence is not clean;
- [x] unrun applicable selectors and unavailable external services become
  structured limitations;
- [x] diagnostic mapping cannot create a finding or repair plan without an
  agent-recorded verdict;
- [x] everyday use loads only compact output and applicable rule references;
- [x] mixed and nested Rust packages resolve through repository ownership.

## Validation

Run adapter fixtures for pass, warning, source failure, unavailable runner,
nested package, and no-selector cases plus full package and repository QA.

## Evidence

Report D records supported evidence classes, selector resolution, normalized
examples, negative paths, context-size measurements, and unsupported tools:
`bundle-docs/research/prototypes/rust-quality/rust-v2-mechanical-evidence-report-2026-08-26-d.md`.

## Stop conditions

- stop if an adapter needs an undeclared runtime or silently installs tools;
- stop if repository-owned selectors cannot be distinguished from universal
  defaults;
- stop if tool output gains remediation authority;
- do not promote candidate rules.

## Next task

Card 097 is ready. Start it only as a separate bounded detector-qualification
batch; this card added no detector or repair authority.
