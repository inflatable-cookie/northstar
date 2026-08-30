# Reduce Worker Review Rework

Date: 2026-08-30
Roadmap: `g02.035`
Card: `g02.035/103`
Status: complete

## Result

Northstar now treats worker handoffs as short dispatch overlays and moves detail
that affects correctness into the ready card's review oracle. Workers perform an
adversarial pass before initial PR creation and after requested changes.

Blocking review findings use five reason codes: `execution-miss`, `oracle-gap`,
`planning-change`, `validation-gap`, and `integration-drift`. This separates
worker execution quality from handoff, planning, and validation quality instead
of treating every extra review cycle as the same failure.

## Evidence basis

- Figmatic: 31 of 47 sampled PRs had at least one blocking correction; 4 had
  multiple blocking correction cycles.
- Swallowtail: 30 of the latest 50 sampled PRs had at least one blocking
  correction; 5 had multiple cycles.
- Multi-round examples used worker handoffs around 245-287 lines, so additional
  handoff volume was not a supported remedy.
- Reviewed examples included explicit criteria missed in implementation,
  under-specified counterexamples, missing negative/property tests, and a late
  planning threshold change.

## Changed boundary

- high-risk and universal/exact/negative acceptance gets a compact review oracle;
- risky worker lanes use frontier/high capability before dispatch;
- handoffs link card steps, acceptance, and doctrine instead of copying them;
- raw review-cycle count is retained as evidence but not used alone as a quality
  diagnosis.

## Validation

- `git diff --check` — pass;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- isolated `effigy check:skill-install` — pass, 122 files;
- installed handoff/orchestrator sources synced selectively; configured-install
  parity still reports the pre-existing unrelated
  `scripts/rust-quality-setup.rhai` mismatch, which this batch did not overwrite.

## Next

Use the reason codes in future orchestrator reviews and compare repeated causes,
not just revision totals.
