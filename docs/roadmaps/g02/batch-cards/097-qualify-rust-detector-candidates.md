# 097 - Qualify Rust Detector Candidates

Status: complete
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/033-rust-audit-v2-tool-enforcement.md`
Roadmap ref: `g02.032`
Governing refs: `docs/contracts/004-language-quality-pack.md`, card 096,
Rust quality translation memo
Auto-start next card: no

## Objective

Determine which Rust quality checks can become precise executable detectors and
which must remain contextual audit procedures.

## Scope

- individual rustc/Clippy diagnostics and applicable Effigy evidence;
- panic/invariant, cancellation, documentation, testing,
  architecture/cohesion, complexity, and residue candidates;
- custom detector prototypes only for narrow syntactic patterns with explicit
  valid, invalid, and exception fixtures;
- independent finding precision, repair, preservation, churn, and blind review;
- catalogue promotion only for candidates that pass the full contract gate.

## Acceptance criteria

- [x] every candidate has a decidability and false-positive classification;
- [x] upstream diagnostics are preferred where precise and stable;
- [x] no custom detector was needed; the eligibility boundary is checked;
- [x] meaning-dependent concerns remain manual rather than falsely mechanical;
- [x] failed candidates are recorded and omitted from production mappings;
- [x] promoted candidates carry provenance, applicability, authority,
  deviation, and completion evidence.

## Validation

Run detector fixtures, isolated subject/reviewer evidence, catalogue negative
tests, repository QA, docs QA, and diff validation.

## Evidence

Report E records all 14 dispositions, dual-toolchain fixtures, negative
authority tests, exact mapping identity, install parity, and context budgets.

## Stop conditions

- stop if a heuristic needs repository policy not already owned;
- stop if false positives require broad suppressions or laundering code;
- stop if a detector is used to justify its own repair;
- stop before production evidence when the final catalogue is not frozen.

## Next task

Execute ready card 098 as a separate bounded batch. Run fresh isolated v2
production evidence without distribution.
