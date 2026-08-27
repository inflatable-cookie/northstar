# 098 - Run Rust V2 Production Evidence

Status: complete
Owner: repo maintainers
Updated: 2026-08-27
Master spec refs: `docs/specs/033-rust-audit-v2-tool-enforcement.md`
Roadmap ref: `g02.032`
Governing refs: `docs/contracts/004-language-quality-pack.md`, cards 094-097
Auto-start next card: no

## Objective

Prove the frozen Rust v2 payload across fresh isolated production subjects and
blind reviewers before distribution.

## Scope

- at least three fresh subjects spanning worktree anchors, repository scope,
  nested/mixed packages, tool degradation, and authorized repair;
- coordinator-owned frozen answer keys and independent reviewers;
- primary finding recall, precision, rule-ledger completeness, three-pass
  attestations, authority, preservation, churn, validation, and limitations;
- no consumer-repository dispatch or payload revision inside a scored run.

## Acceptance criteria

- [x] all replicates pass exact primary finding and locality gates;
- [x] every applicable unit-rule pair and review pass is evidenced;
- [x] anchor/context relations and repository-only coverage claims are exact;
- [x] repairs preserve protected behavior and stay within recorded authority;
- [x] degraded evidence and remaining limitations are complete and honest;
- [x] blind reviewers accept the result and bounded diff.

## Validation

Run the frozen production scorer, evidence-integrity checks, full repository QA,
docs QA, posture advisory, and diff validation.

## Evidence

Revision E passed `3/3` deterministic subjects and `3/3` packet-only blind
reviews with exact `4/4` primary findings, `18/18` rule verdicts, `9/9`
attestations, no review concerns, and an unchanged production payload. Revisions
A-D remain immutable halted or rejected evidence. See
`bundle-docs/research/prototypes/rust-quality/rust-v2-production-evidence-report-2026-08-27-e.md`.

## Stop conditions

- halt a run on payload drift, leaked oracle data, reviewer contamination,
  hidden mutation, missing ledger evidence, or preservation failure;
- do not patch a scored subject in place;
- do not distribute a partially passing payload.

## Next task

Execute ready card 099 as a separate bounded distribution batch.
