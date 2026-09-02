# 119 - Extract Rust Language Package

Status: planned; awaiting operator checkpoint and Rust inventory/readiness refresh
Owner: repo maintainers
Updated: 2026-09-02
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, cards 116-118
Auto-start next card: no

## Ready-State Checks

- [x] TypeScript canary is accepted and protocol findings are reconciled;
- [ ] current Rust payload, engine, install, and consumer cohort are inventoried;
- [x] strict everyday authoring and explicit audit remain separate workflows;
- [x] Cargo-native engine, six normative rules, evaluation input, authority,
  scope, and evidence contracts remain unchanged;
- [x] root reduction is out of scope.

## Objective

Publish, pin, install, and prove Rust as an independent official package while
preserving both production workflows and the Cargo-native audit engine.

## Lane Runway Context

- Higher-level lane owner: g02.048 Batch C.
- Next likely card: 120 embedded-payload removal.
- Next planning checkpoint: verify both packages meet the overlap-close gate
  before any root deletion.

## Scope

- move Rust catalogue, modes, setup, schemas, engine, fixtures, templates, and
  thin adapter into the independently addressable Rust package;
- publish immutable candidate, pin through core registry review, and prove
  package-scoped source/install parity;
- preserve consumer activation/profile/deviation/evidence paths and engine
  cache/integrity behavior;
- prove everyday authoring, explicit audit, independent acquisition, rollback,
  offline, visible fallback, and one real consumer;
- keep TypeScript package and root reduction untouched.

Do not change MSRV ownership, catalogue rules, remediation authority, engine
lifecycle, or install unrelated package payloads.

## Acceptance Criteria

- [ ] installed payload contains only the named Rust package;
- [ ] strict everyday and explicit-audit behavior plus revision-E evidence stay
  exact;
- [ ] Cargo-native engine remains payload-addressed, checksum-verified, and
  independent of consumer Effigy catalogues;
- [ ] valid consumer policy/evidence remain byte-compatible;
- [ ] source/install parity, registry promotion, installed, rollback, offline,
  fallback, and real-consumer proofs pass;
- [ ] no TypeScript payload is fetched or loaded;
- [ ] all new Rust package development lands externally during overlap;
- [ ] full package and Northstar QA pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Workflows remain distinct. | Ordinary Rust task enters repository audit. | Stay changed-tranche-only. | Everyday/audit route fixtures. |
| Engine integrity survives extraction. | Installed engine source or binary differs from receipt. | Reject before audit execution. | Digest-tamper fixture. |
| Consumer owns MSRV. | Package infers or raises compiler floor. | Stop for repository policy. | Existing MSRV fixtures. |
| Package is independent. | Shared repo includes TypeScript sibling. | Rust install retains no TypeScript payload. | Installed inventory. |
| Evidence remains exact. | Existing v2 records are read after migration. | Preserve lifecycle and result meaning. | Compatibility fixtures. |
| Fallback is visible and bounded. | Registry acquisition fails during overlap. | Name failure and frozen fallback. | Forced-failure transcript. |

## Evidence Required

- accepted TypeScript protocol findings and current Rust inventory;
- package release identity, registry pin, artifact/manifest/engine digests;
- package parity and no-TypeScript installed inventory;
- existing production fixtures plus both workflows, rollback, offline,
  fallback, and real-consumer runs;
- consumer policy/evidence compatibility hashes;
- package QA, Northstar QA, `git diff --check`, PR, exact head, and limits.

## Continuation Envelope

- Auto-start next card: no.
- In-bounds next card: 120 after both overlap-close gates are reviewed.
- Remaining ready chain after this card: 0.
- Transition proof: accepted Rust package and exact two-package removal inventory.

## Lane Budget

- Current card ends budgeted run: yes.
- Further operator decision required after this card: if either package fails
  the promoted overlap-close gate.
- Pause signal if run stops here: lane-complete.

## Stop Conditions

- extraction changes Rust rule meaning, workflow scope, authority, MSRV policy,
  or evidence lifecycle;
- engine requires global Cargo mutation, consumer Effigy, or root source;
- package installs or loads TypeScript;
- revision-E or real-consumer proof cannot be preserved;
- validation changes the plan.

## Completion Notes

Card 118's accepted TypeScript prerequisite is complete. The bounded canary
proof, fallback visibility, installed audit, byte preservation, and known
consumer limits are recorded in card 118 and its closeout log. Card 119 remains
planned and not ready; the next step is the operator checkpoint followed by a
current Rust inventory and readiness refresh.

## Next Task

At the operator checkpoint, reconcile the current Rust inventory and apply the
ready-state rubric. Do not mark this card ready or launch it automatically.
