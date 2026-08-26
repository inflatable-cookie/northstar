# Pause Rust Production Evidence On Authority

Date: 2026-08-25
Roadmap: `g02.030`
Card state: `g02.030/087` paused; `g02.030/088` pending

## Outcome

Card 087 stopped before packet freeze, subject launch, or scoring. The frozen M
audit corpus requires the foreign-input `RUST-ERR-001` finding to remain blocked
pending an operator-owned foreign error policy. The production audit mode agrees.
The production catalogue has no action-specific override for that decision, so
the recorder derives `review_required` and rejects the required
`operator_decision` disposition.

## Evidence

- frozen benchmark expectation:
  `blocked_pending_foreign_error_policy` in
  `benchmark-manifest.prototype.json`;
- production instruction: missing external error policy is an operator decision
  in `references/modes/rust-quality-audit.md`;
- production authority: `RUST-ERR-001` has `review_required` as its strict
  default and no action override in `catalogue.json`;
- recorder enforcement: `normalize_finding` accepts `operator_decision` only
  when effective action authority is `operator_decision`.

No subject saw a packet. No result was invalidated or discarded. No prototype
result was substituted for production evidence.

## Decision Needed

Recommended correction: add one exact `RUST-ERR-001` action such as
`change_foreign_error_policy` with `operator_decision` authority, align the mode
and frozen corpus vocabulary, add positive and negative recorder cases, reprove
catalogue/projection/install parity, then start a new card-087 cohort. Do not
weaken the FFI case, reuse the MSRV action name, or broaden the whole error rule.

Pause signal: `stop-signal-fired` (contract contradiction). Card 088 remains
blocked.

## Resolution

The operator approved the recommended exact action. The correction is recorded
in `25-185548-correct-rust-foreign-error-authority.md`; card 087 returned to
ready without reusing any subject packet.
