# 041 - Repair Partial Rust Evidence Collection

Status: complete
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.032`, `g02.033`
Vision tags: `rust-quality`, `evidence`, `consumer-feedback`, `papercuts`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/specs/033-rust-audit-v2-tool-enforcement.md`,
`skills/northstar/references/language-quality/rust/evidence-collection.md`
Planning state: card 109 complete; PR 13 merged as `dbce3856`

## Problem

Signal's `g11.003` audit exposed a collector defect. A partial second `collect`
call omitted requests already represented by immutable passing records. The
installed Northstar tool treated those classes as absent from the new call and
wrote 42 audit-wide `unrun-<class>-<unit>` records that contradicted evidence
already on disk. Immutable evidence then forced a full audit restart.

Signal owns the consumer report and its eventual papercut closure. Northstar
owns the installed collector, its evidence semantics, regression coverage, and
distribution proof.

## Goals

- [x] reproduce the Signal call shape before mutation;
- [x] make staged audit collection respect already-sealed unit/class evidence;
- [x] limit synthetic `unrun` evidence to genuinely missing coverage in the
  current call's target scope;
- [x] fail without writing records when target scope cannot be resolved safely;
- [x] preserve immutable records and the legitimate first-call no-selector
  limitation;
- [x] return a reviewable Northstar PR with installed-skill validation.

## Non-goals

- no Signal source or audit-record mutation;
- no rewrite of the Rust audit lifecycle, evidence schema, or rule catalogue;
- no recovery or rewriting of the abandoned Signal audit records;
- no new detector, finding, repair authority, or consumer audit.

## Execution Plan

Card `g02.041/109` owned one bounded reproduce, diagnose, repair, validate, and
PR lane. After merge, the Signal orchestrator closes the originating
`PAPERCUTS.md` entry against the merged Northstar evidence.

## Acceptance Criteria

- a regression fixture reproduces the partial second-call failure against the
  pre-fix collector;
- a later partial call does not create `unrun` evidence for any unit/class pair
  already represented by an immutable record;
- synthetic `unrun` records cover only genuinely unrepresented applicable
  evidence in the call's resolved unit scope;
- ambiguous or contradictory collection input fails before any new record is
  persisted;
- existing record and raw-artifact bytes remain unchanged across the second
  call;
- the existing warning, unavailable, first-call unrun, completion, and
  finalization fixtures still pass;
- package checks, docs QA, installed-skill validation, and full repository QA
  pass.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Existing evidence stays authoritative. | A passed `test/core` record exists; a later call omits that request. | No `unrun-test-core` record is written. | Two-call regression and record inventory. |
| Missing coverage stays visible. | A targeted unit has an applicable class with no existing or new record. | One scoped `unrun` limitation is written, or ambiguous scope fails closed. | Focused negative fixture. |
| Collection is mutation-safe. | A later request collides or its target scope is contradictory. | Reject before writing any new record. | Before/after evidence-tree hash. |
| Consumer scope stays bounded. | Repair edits Signal or rewrites its sealed audit. | Stop and report. | Changed-file inventory. |
| Distributed behavior matches source. | Source tests pass but the installed skill payload differs. | Closeout fails. | Skill-install and package validation. |

## Stop Conditions

- the repair needs a schema or public command-shape change;
- correct target-unit semantics remain ambiguous after reproducing the live
  call and reading the existing collector contract;
- preserving immutable evidence requires deletion or rewriting;
- validation exposes a wider lifecycle or distribution defect;
- the lane overlaps an existing collector worker or PR.

## Next Task

Northstar implementation is merged. Signal owns closure of the originating
papercut against `dbce3856`; no further Northstar card remains on this lane.
