# Repair Partial Rust Evidence Collection

Date: 2026-09-01
Roadmap: `g02.041`
Card: `g02.041/109`
Status: complete

## Result

Staged Rust-quality `collect` now treats sealed unit/class evidence as
authoritative. A later partial plan no longer invents audit-wide `unrun`
records for classes already represented on disk, and synthetic `unrun` output
is limited to the call's resolved unit scope. Colliding or ambiguous coverage
fails before any new record is written. The first-call empty-request
no-selector limitation still works.

## Evidence basis

- Pre-fix reproduction: multi-unit fixture sealed passed `test-core`, then a
  partial second call requesting only `lint-core` with
  `applicable_classes: [lint, test]` fabricated `unrun-test-core` and
  `unrun-test-extra`.
- Post-fix: that two-call regression passes; sealed `test-core` bytes are
  unchanged across the second call.
- Missing-coverage fixture writes scoped `unrun-test-extra` only.
- Collision fixture returns `evidence.coverage_exists` with an unchanged
  evidence inventory.
- Ambiguous duplicate unit/class coverage returns
  `evidence.coverage_ambiguous` before write.
- Same-plan duplicate unit/class requests return
  `evidence.coverage_duplicate` before execution or write (no command side
  effect).
- Existing warning/unavailable/unrun, completion, and finalization fixtures
  still pass.

## Changed surfaces

- `skills/northstar/tools/rust-quality/src/evidence.rs`
- `skills/northstar/tools/rust-quality/tests/cli.rs`
- `skills/northstar/references/language-quality/rust/evidence-collection.md`
- `docs/roadmaps/g02/041-repair-partial-rust-evidence-collection.md`
- `docs/roadmaps/g02/batch-cards/109-repair-partial-rust-evidence-collection.md`
- front-door next-task pointers under `docs/`

## Preservation proof

- Sealed record path `test-core.json` compared byte-for-byte before and after
  the partial second collect in the two-call and missing-coverage fixtures.
- Collision and ambiguous fixtures assert no new request record is created and
  the original sealed bytes remain identical.

## Validation

- focused `cargo test` in `skills/northstar/tools/rust-quality` — pass
  (20 cli + 4 lib + 2 detector);
- `cargo clippy --all-targets -- -D warnings` for that crate — pass;
- `effigy check:rust-quality` — pass;
- isolated `effigy check:skill-install` — pass, 127 files;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — pass.

## Limits

- No Signal source or sealed-audit mutation.
- No schema or public CLI change.
- Signal papercut closure waits for Northstar merge evidence and stays with the
  Signal orchestrator.

## Next

Orchestrator exact-head review and merge of the worker PR, then Signal papercut
closure against the merged Northstar evidence.
