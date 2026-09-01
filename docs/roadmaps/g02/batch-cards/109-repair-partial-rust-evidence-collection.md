# 109 - Repair Partial Rust Evidence Collection

Status: complete
Owner: repo maintainers
Created: 2026-09-01
Master roadmap: `g02.041`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/specs/033-rust-audit-v2-tool-enforcement.md`,
`skills/northstar/references/language-quality/rust/evidence-collection.md`,
`skills/northstar/tools/rust-quality/src/evidence.rs`
Auto-start next card: no

## Objective

Repair the installed Rust-quality collector so a partial later evidence call
cannot fabricate audit-wide `unrun` limitations that contradict immutable
records already on disk.

## Scope

- reproduce Signal's two-call evidence shape with a multi-unit fixture;
- diagnose persistent-record and current-plan coverage semantics;
- implement the smallest contract-valid collector repair;
- add regression coverage for existing, missing, ambiguous, and colliding
  evidence;
- update the compact evidence-collection reference only where the corrected
  call semantics need to be explicit;
- write the closeout log and reconcile this card and roadmap state.

Out of scope: Signal code or audit metadata, evidence deletion or rewriting,
schema/catalogue changes, detector work, wider recorder refactoring, and
consumer-audit reruns.

## Ready-State Checks

- [x] the consumer failure and impact are recorded in Signal `PAPERCUTS.md`;
- [x] the implementation owner is the Northstar skill-shipped Rust tool;
- [x] no active agent, branch, or PR already owns this collector defect;
- [x] expected behavior and fail-closed boundaries are explicit in `g02.041`;
- [x] the lane has one worker, one branch, and one PR.

## Acceptance Criteria

- [x] pre-fix behavior is reproduced without altering Signal's sealed audit;
- [x] already-recorded unit/class evidence prevents contradictory synthetic
  `unrun` output on a later partial call;
- [x] genuinely absent applicable coverage remains an honest scoped limitation;
- [x] invalid or ambiguous later calls fail before any record is written;
- [x] existing evidence bytes and hashes do not change;
- [x] focused Rust-quality tests, `effigy check:rust-quality`,
  `effigy check:skill-install`, `effigy qa:docs`, and `effigy qa` pass;
- [x] changed files stay inside the Northstar collector, its focused tests,
  directly affected reference, and lane evidence surfaces.

## Review Oracle

Use the milestone oracle. In review, run the two-call fixture and inspect the
evidence directory after each call. Reconcile every new record to one targeted
unit/class pair and compare pre-existing record hashes byte-for-byte.

## Evidence Required

- failing pre-fix and passing post-fix two-call regression;
- new-record inventory and existing-record preservation hashes;
- focused tool test output and repository-native validation;
- closeout log under `docs/logs/2026-09/`;
- pushed PR head, changed-file list, and unresolved limitations.

## Stop Conditions

- any public schema or CLI contract must change;
- target scope cannot be resolved without a new caller choice;
- immutable evidence would need mutation;
- correction expands beyond Rust evidence collection or conflicts with another
  live lane;
- validation changes the plan.

## Next Task

PR opened for orchestrator exact-head review. Do not merge from this worker.
After accepted review and passing checks, the orchestrator may merge and then
close the Signal papercut in a separate Signal coordination update.
