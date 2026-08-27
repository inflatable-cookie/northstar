# 032 - Strengthen Rust Audit Tool Enforcement

Status: complete
Owner: repo maintainers
Created: 2026-08-26
Depends on: `g02.030`, contract `004-language-quality-pack`
Vision tags: `rust-quality`, `explicit-audit`, `tool-enforcement`, `no-slop`
Master spec refs: `docs/specs/033-rust-audit-v2-tool-enforcement.md`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/contracts/003-agent-instruction-surface.md`,
`docs/architecture/system-architecture.md`
Planning state: cards 094-099 complete

## Problem

Rust audit v1 relies on the agent to resolve scope and treats an empty findings
list as a completed assessment. Convergence proved that useful repairs can
coexist with weak coverage evidence. The correction belongs in deterministic
scope, ledger, evidence, and finalization tools rather than more skill prose.

## Goals

- [x] freeze a portable tool-enforced v2 boundary;
- [x] make anchor-based worktree scope and context relations executable;
- [x] require every applicable unit-rule verdict and review attestation;
- [x] normalize repository-native compiler, lint, docs, test, and graph evidence;
- [x] qualify narrow mechanical detectors without granting heuristic rewrite
  authority;
- [x] pass fresh isolated production evidence;
- [x] prove exact installed parity.

## Non-goals

- no new top-level skill or always-loaded rule dump;
- no blanket Clippy restriction group, formatting, or automatic fixing;
- no silent dependency, toolchain, MSRV, or repository-policy change;
- no candidate-rule promotion before its own evidence gate;
- no consumer dogfood dispatch, certification, or release mutation.

## Execution Plan

### Batch 32.1 - Freeze executable boundary

Card `g02.032/094` proves one skill-shipped Cargo-native engine around agent
judgment. It freezes managed bootstrap, commands, schemas, failure semantics,
and context budgets before production code changes. The rejected Effigy-hosted
split remains research evidence only.

### Batch 32.2 - Enforce scope and assessment completeness

Card `g02.032/095` implements dirty-anchor scope provenance, the complete
unit-rule ledger, three-pass attestations, structured limitations, and negative
lifecycle tests.

### Batch 32.3 - Add mechanical evidence adapters

Card `g02.032/096` adds checked adapters for repository-native Rust evidence and
a lightweight changed-tranche seam usable by everyday authoring without loading
the explicit audit procedure.

### Batch 32.4 - Qualify detector candidates

Card `g02.032/097` evaluates upstream lints and any narrow custom detector with
valid/invalid/exception fixtures. It may promote only candidates that pass the
existing precision, repair, preservation, and blind-review contract.

### Batch 32.5 - Reprove and distribute

Cards `g02.032/098-099` run fresh isolated v2 evidence, then publish only the
exact passing payload with source/install parity and honest claim limits.

## Acceptance Criteria

- [x] worktree audits cannot initialize without relevant dirty Rust anchors;
- [x] every context file records one direct relation to an anchor and cannot
  silently become mutable scope;
- [x] every unit has exactly one verdict per applicable normative rule and
  non-empty correctness, architecture, and human-quality attestations;
- [x] unavailable tools, warnings, unrun applicable selectors, retained
  findings, and policy stops appear as structured limitations;
- [x] candidate diagnostics never create repair authority by themselves;
- [x] the router and ordinary Rust context remain lean;
- [x] three fresh production replicates and the card-098 QA board pass;
- [x] source/install parity and the distribution QA board pass.

## Lane Controls

- Immediate task: none; the bounded Rust v2 lane is complete.
- Continuation envelope: closed after card 099.
- Lane budget: cards 094-099 completed without widening audit authority or
  always-loaded context. Pause signal: `lane-complete`.
- Pause signals: runtime beyond Cargo and Git, tool/authority contradiction,
  inability to distinguish candidates from findings, or evidence-schema shape
  that increases always-loaded context.
- Planning checkpoint: complete after revision-E distribution and exact
  120-file source/install parity.

## Next Task

Accept operator-provided live-use feedback. Do not dispatch a consumer audit or
broaden assurance claims without a new evidence-backed lane.
