# 095 - Enforce Rust Scope And Assessment Ledger

Status: complete
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/033-rust-audit-v2-tool-enforcement.md`
Roadmap ref: `g02.032`
Governing refs: `docs/contracts/004-language-quality-pack.md`, card 094,
`bundle-docs/research/prototypes/rust-quality/rust-v2-boundary-report-2026-08-26-b.md`
Auto-start next card: no

## Ready-state checks

- [x] Card 094 froze the skill-shipped Cargo CLI, managed bootstrap, operations,
  semantic shapes, error codes, Rust 1.95 floor, and context budgets.
- [x] Contract 004 owns anchor scope, complete verdicts, attestations,
  structured limitations, and repair authority.
- [x] The prototype passes positive and negative scope/ledger paths without
  changing the production payload.
- [x] This card excludes evidence adapters and detector promotion.
- [x] Acceptance, validation, evidence, and stop conditions are explicit.

## Objective

Implement the frozen Rust v2 scope provenance, complete unit-rule ledger,
three-pass attestations, structured limitations, and deterministic finalization.

## Scope

- promote the locked prototype crate into `skills/northstar/tools/rust-quality/`;
- automatic payload-addressed installation, checksum/receipt, offline-cache,
  upgrade, and absolute-invocation checks;
- schemas, recorder lifecycle, Cargo-native `inspect`/scope operations, and
  checks; v2 recorder initialization consumes its checked discovery record;
- exact anchor/context/unit ownership and mutation-attribution invariants;
- verdict-to-finding/deviation/degraded consistency;
- deterministic structured limitation derivation and `report.md` generation;
- negative tests for every new finalization rejection;
- no new rule or mechanical detector.

## Acceptance criteria

- [x] card 094 Cargo-native interfaces are implemented without drift or an
  Effigy compatibility wrapper;
- [x] every normative unit-rule pair has one checked verdict, including
  evidenced `not_applicable` verdicts;
- [x] all three review attestations contain inspected surfaces and evidence;
- [x] structured limitations are derived from local records and match the
  human-report input exactly;
- [x] v1 silent scope widening and empty-findings completion are impossible;
- [x] focused setup, recorder, package, and schema checks pass.

## Validation

Run managed-bootstrap, root/nested discovery, Rust quality
setup/recorder/package, new scope and ledger fixtures, repository QA, docs QA,
posture advisory, and diff validation.

## Evidence

Record schema hashes, lifecycle transitions, positive fixtures, rejected
negative paths, compatibility decision, and exact changed surfaces.

## Stop conditions

- stop if card 094 is incomplete or its frozen interface changes;
- stop on an Effigy-hosted compatibility wrapper, unplanned v1 shim, or
  consumer policy migration;
- stop if a rule verdict can be inferred from absence of findings;
- do not add detector or candidate-rule behavior.

## Next task

Card 096 is ready. Start it only as a new bounded batch; this card's
continuation envelope does not auto-start it.
