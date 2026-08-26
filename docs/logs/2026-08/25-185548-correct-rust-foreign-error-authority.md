# Correct Rust Foreign Error Authority

Date: 2026-08-25
Roadmap: `g02.030`
Card state: `g02.030/087` ready; `g02.030/088` pending

## Outcome

Added the exact `RUST-ERR-001` action `change_foreign_error_policy` with
`operator_decision` authority. Ordinary error repair remains
`review_required`. The correction changes no unsafe/FFI repair authority and no
slop enforcement boundary.

The action is aligned across the canonical catalogue, strict audit and
authoring projections, selective authoring reference, explicit audit mode,
recording contract, and contract 004. The frozen benchmark outcome
`blocked_pending_foreign_error_policy` now has one production action that can
represent it without changing the expected stop.

## Evidence

- package validation asserts the exact action, strict authority, unchanged
  default error authority, and a negative broadened-authority case;
- recorder validation accepts and reports the operator-owned stop without a
  repair plan, and rejects a repair plan for the same action;
- source and isolated installed-like package/recorder checks pass with
  `PATH=/bin`;
- source/install parity passes for 75 files;
- skill-creator validation passes.

No cohort was launched during correction. Card 087 is ready for a fresh frozen
production-evidence run. Card 088 remains blocked until both tracks pass.

Pause signal: `budget-exhausted` for the correction batch.
