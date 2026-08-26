# 087 - Run Rust Quality Production Evidence

Status: complete
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/031-rust-quality-authoring-and-audit.md`
Roadmap ref: `g02.030`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`bundle-docs/research/prototypes/rust-quality/independent-trial-protocol.md`
Auto-start next card: no

## Ready-State Checks

- [x] Cards 085 and 086 provide separate production routes over one checked
      strict catalogue.
- [x] The installed-like payload passes routing, recorder, schema, authority,
      preservation, and source/install parity checks.
- [x] The production recorder exposes the frozen operation and record paths
      without an undeclared helper runtime.
- [x] The independent-trial protocol and frozen F/M gates remain available.
- [x] The card excludes doctrine promotion, distribution, and combined or
      compaction-resilience claims.

## Objective

Prove that the production payload preserves the validated strict behavior for
everyday authoring and explicit audit before distribution claims are updated.

## Scope

- fresh filesystem-isolated production-skill subjects;
- three valid replicates per required track;
- fresh blind review and frozen F/M quality, locality, authority, preservation,
  churn, and review gates;
- production payload only for subject instructions;
- no combined or synthetic compaction claim.

Subjects receive only the installed `skills/northstar/` payload: the canonical
record and strict projections under
`references/language-quality/rust/`, the two routed modes, the consumer
`rust-quality-profile.json` and `rust-quality-deviations.json`, and the recorder
operations exposed by `northstar/rust-quality:record`. Prototype paths remain
coordinator-only evidence infrastructure.

## Implementation Steps

1. Freeze the production payload, manifests, thresholds, and launch plan.
2. Prepare three opaque isolated packets for each required track.
3. Run subjects without coordinator access, then prepare fresh blind reviews.
4. Finalize, score, inspect, and halt on the first frozen critical failure.
5. Hash-freeze and archive valid evidence; publish one bounded cohort report.

## Acceptance Criteria

- [x] Everyday authoring passes `3/3` with task acceptance, preservation, and
      blind readability/correctness gates.
- [x] Explicit audit passes `3/3` with recall, precision, exact locality,
      authority, clean preservation, scope, churn, and blind review gates.
- [x] No subject sees coordinator or expected-outcome data.
- [x] Unsafe/FFI and slop report-only boundaries remain unchanged.
- [x] Every cohort is hash-frozen, verified, and archived without private
      runtime state.

## Validation

Run the production packet checks, isolated cohort finalizers, archive hash
verification, catalogue/projection tests, `git diff --check`, and relevant QA.

## Evidence

Record subject/reviewer provenance, exact runtime and version, isolation method,
scores, failures, archive hashes, and claim limits in one cohort report.

## Stop Conditions

- halt on any harness defect before scoring;
- halt on a critical authority, preservation, regression, or blind-review
  failure;
- do not tune instructions inside a frozen cohort;
- do not substitute prototype-only results for production evidence.

## Paused Attempt — 2026-08-25

Pre-launch inspection stopped before packet freeze or subject execution. The
frozen audit corpus requires the foreign-input `RUST-ERR-001` finding to stop as
`blocked_pending_foreign_error_policy`. The production audit mode likewise says
missing foreign error policy is an operator decision. The canonical catalogue,
however, gives every `RUST-ERR-001` action the default `review_required`
authority, and the production recorder therefore rejects an
`operator_decision` disposition for that finding.

No cohort was launched or scored. Card 088 remains blocked. Resume only after a
separate accepted correction adds an exact action-specific authority boundary,
reproves catalogue/projection/recorder parity, and starts a new frozen
production cohort.

Resolved 2026-08-25: the operator approved action
`change_foreign_error_policy` with `operator_decision` authority. The canonical
catalogue, both strict projections, selective authoring reference, explicit
mode, recording contract, package checks, and recorder tests now agree. The
frozen `blocked_pending_foreign_error_policy` outcome maps to that action
without changing its expected disposition. No subject packet from the paused
attempt exists to reuse.

## Completion Evidence — 2026-08-26

- Revision K is completed valid evidence for explicit audit: `3/3`, perfect
  recall, precision, and locality, seven authorized repairs per run, exact dirty
  state preservation, no regressions, and 5/5 median correctness/readability.
- Revision M is completed valid evidence for everyday authoring: `3/3`, every
  conjunctive gate passed, churn ratios `0.975`, `1.097`, and `1.143`, no
  residuals or regressions, and 5/5 median correctness/readability.
- Revision L halted unscored when the CLI changed from `0.149.0` to `0.149.1`
  mid-cohort. Both isolated runners now reject runtime-cell drift before model
  launch. No L packet or review was reused.
- The K-to-M installed audit-effective surface is identical: root/router,
  explicit-audit mode, strict-audit projection, recording contract, recorder,
  and catalogue after removing authoring projections.
- Immutable archives:
  `trial-results/2026-08-26-cohort-production-k`,
  `trial-results/2026-08-26-cohort-production-l`, and
  `trial-results/2026-08-26-cohort-production-m`.
- Bounded reports:
  `production-evidence-report-2026-08-26-k.md`,
  `production-evidence-report-2026-08-26-l.md`, and
  `production-evidence-report-2026-08-26-m.md`.

Card 087 is complete. Its continuation envelope and lane budget are exhausted;
card 088 is ready but does not auto-start.

## Next Task

Execute card 088 to promote and distribute the evidenced payload. Do not start
distribution without a fresh operator continuation.
