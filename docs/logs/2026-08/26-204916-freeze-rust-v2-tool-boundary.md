# Freeze Rust V2 Tool Boundary

Status: superseded by `26-211937-replace-rust-v2-boundary-with-cargo.md`
Date: 2026-08-26
Roadmap: `g02.032`
Card: `g02.032/094`

## Outcome

Selected separate skill-local scope and evidence tasks around an upgraded,
subprocess-free recorder. Worktree anchors, context relations, complete
unit-rule verdicts, three review attestations, tool failure semantics, detector
authority, derived limitations, and context budgets are frozen.

The disposable Rhai prototype passes 18 semantic cases and one foreign-target
Git proof, including a PATH-limited run with only Effigy and Git available. The
production Rust payload remains unchanged.

## Decision

- `rust-quality:scope` owns snapshot and plan validation;
- `rust-quality:evidence` normalizes repository-owned evidence;
- `rust-quality:record` owns ledger lifecycle, repair authority, fingerprints,
  limitations, `result.json`, and deterministic `report.md`;
- one allowlisted structured `git -C <target>` read boundary is required until
  Effigy Git helpers accept a target root;
- target repository selectors run through target Effigy, not a universal Cargo
  graph inside Northstar;
- detectors remain candidate-only until card 097.

## Evidence

`bundle-docs/research/prototypes/rust-quality/rust-v2-boundary-report-2026-08-26-a.md`
records runtime alternatives, schemas, failure semantics, hashes, fixtures,
limits, and context measurements.

## Next task

Operator review rejected this execution host before card 095 began. Use the
Cargo-native correction log and report B; retain this log as rejected boundary
evidence. Card 095 still implements scope and assessment without evidence
adapters or detector rules.
