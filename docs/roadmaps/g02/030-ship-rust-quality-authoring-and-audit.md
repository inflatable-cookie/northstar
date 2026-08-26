# 030 - Ship Rust Quality Authoring And Audit

Status: complete
Owner: repo maintainers
Created: 2026-08-25
Depends on: `g02.027`, contract `004-language-quality-pack`
Vision tags: `rust-quality`, `everyday-authoring`, `explicit-audit`, `no-slop`
Master spec refs: `docs/specs/031-rust-quality-authoring-and-audit.md`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/contracts/003-agent-instruction-surface.md`,
`docs/architecture/system-architecture.md`
Planning state: cards 083-088 complete

## Problem

Northstar has promoted and distributed the strict Rust catalogue and both
routed workflows inside the single installable skill. Fresh blinded production
evidence and exact source/install parity support the bounded claims below.

## Goals

- [x] freeze the portable package, profile, projection, and recorder boundary;
- [x] promote the approved catalogue into one production authority;
- [x] add compact everyday Rust authoring with start and changed-tranche exit
      re-entry;
- [x] add explicitly triggered worktree/repository audit-and-repair;
- [x] preserve action-specific remediation authority and dirty worktree state;
- [x] prove blinded production-pack behavior before distribution;
- [x] prove source and installed distribution parity before claiming
      availability.

## Non-Goals

- no second installable Northstar skill;
- no ordinary or high-assurance activation;
- no combined-workflow or compaction-resilience claim;
- no automatic unsafe/FFI repair or slop-detector mutation authority;
- no universal MSRV, Cargo command graph, or blanket Clippy lint group;
- no production implementation copied straight from prototype scripts.

## Contract Coverage

- Contract 004 owns workflow names, strict profile validity, catalogue fields,
  scope, remediation authority, deviations, evidence, and claim limits.
- Contract 003 keeps everyday activation compact and moves audit procedure to an
  on-demand mode.
- Existing skill architecture keeps `northstar` as the single installable
  artifact. Rust authoring and audit are internal modes; explicit audit gets a
  thin `/northstar-rust-audit` adapter.
- Effigy discovers repository-native validation and owns orchestration. It does
  not become a second Rust rule catalogue.

## Execution Plan

### Batch 30.1 — Freeze the production boundary

- [x] prove a portable deterministic recorder path without undeclared runtime
      assumptions;
- [x] freeze canonical payload paths, consumer profile resolution, projection
      checks, audit record operations, and the explicit adapter name;
- [x] promote any durable boundary correction before implementation.

Card: `g02.030/083`.

### Batch 30.2 — Build the shared foundation and everyday track

- [x] promote the six approved rules and one evaluation-only input into the
      installable payload;
- [x] add mechanical schema/projection/authority checks;
- [x] route Rust coding to one compact authoring mode with start and exit
      re-entry;
- [x] add copy-ready, path-scoped activation and strict-profile guidance.

Cards: `g02.030/084`, `g02.030/085`.

### Batch 30.3 — Build explicit audit-and-repair

- [x] add the explicit audit mode and thin command adapter;
- [x] resolve worktree or repository scope and snapshot dirty state;
- [x] record findings before coherent repair waves;
- [x] construct final evidence from deterministic case-local records and stop on
      operator-owned decisions.

Card: `g02.030/086`.

### Batch 30.4 — Reprove, promote, and distribute

- [x] run fresh blinded strict evidence against the production payload for both
      required tracks;
- [x] reject false-positive, authority, locality, preservation, churn, or review
      regression;
- [x] update doctrine, templates, checks, installed parity, and operator docs
      only after the production evidence gate passes.

Cards: `g02.030/087`, `g02.030/088`.

## Acceptance Criteria

- [x] One canonical catalogue mechanically projects both workflows.
- [x] Everyday Rust work loads only compact applicable guidance and rechecks the
      changed tranche at closeout.
- [x] Explicit audit runs only on explicit intent and supports worktree and
      repository scopes.
- [x] Audit evidence cannot cross assessed-unit boundaries or hide mutation.
- [x] Strict unsafe/FFI findings remain report-only and slop remains
      evaluation-only/report-only.
- [x] MSRV-compatible substitution and version-policy changes resolve to
      different authority.
- [x] Dirty user state and unrelated code remain untouched.
- [x] Fresh production-pack evidence passes the frozen track gates and blind
      review.
- [x] Source and installed skill payloads pass parity and repository QA.

## Lane Runway

- Generation goal: extend the reusable Northstar skill with source-backed
  language quality without expanding always-loaded context or creating a second
  authority.
- Immediate card: none; cards 083 through 088 are complete.
- Continuation envelope: closed.
- Lane budget: complete.
- Pause signal: `lane-complete` after source/install parity and repository QA.
- Planning checkpoint: closed after the frozen production boundary, evidence,
  and distribution all passed.

## Risks And Mitigations

- Risk: the production skill inherits a platform-specific research harness.
  Mitigation: card 083 proves the runtime and dependency boundary first.
- Risk: everyday guidance falls out of context. Mitigation: compact start and
  changed-tranche exit re-entry, with projection parity checks.
- Risk: audit produces good code with invalid evidence or authority. Mitigation:
  deterministic local records, findings before mutation, and independent blind
  review.
- Risk: a single skill becomes bloated. Mitigation: two routed modes, selective
  references, and command-adapter budget checks.

## Evidence Requirements

- card-level changed-file inventories and validation output;
- production-boundary decision evidence from card 083;
- mechanical catalogue/projection/authority checks;
- fresh isolated subject and blind-review records for both required tracks;
- source/install parity and final repository QA;
- a closeout log that states unsupported profiles and unproven claims.

## Next Task

The lane is complete. Seek operator-provided live-use feedback without
dispatching a consumer run or expanding the supported assurance claims.
