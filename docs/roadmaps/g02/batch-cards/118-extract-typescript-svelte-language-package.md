# 118 - Extract TypeScript/Svelte Language Package

Status: planned; blocked on card 117
Owner: repo maintainers
Updated: 2026-09-01
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, cards 116-117
Auto-start next card: no

## Ready-State Checks

- [ ] cards 116-117 are merged and the accepted protocol is referenced exactly;
- [ ] current TypeScript payload and consumer cohort are inventoried against
  the accepted package boundary;
- [x] TypeScript remains explicit-audit-only and carries Svelte/SvelteKit as
  conditional overlays;
- [x] existing profile, deviation, rule, scope, and evidence contracts remain
  unchanged;
- [x] Rust and root reduction are out of scope.

## Objective

Publish, pin, install, and prove TypeScript/Svelte as the first independent
official language package under one bounded embedded-overlap window.

## Lane Runway Context

- Higher-level lane owner: g02.048 Batch B and package-protocol canary.
- Next likely card: 119 Rust extraction.
- Next planning checkpoint: accept or repair protocol findings before Rust
  copies the package shape.

## Scope

- move the TypeScript catalogue, overlays, schemas, mode, setup, recorder,
  fixtures, templates, and thin adapter into its independently addressable
  package;
- publish an immutable candidate and pin it through a reviewed core registry
  change;
- preserve existing consumer activation/profile/deviation/evidence paths;
- route explicit audit through the installed package and prove independent
  acquisition, self-check, rollback, offline, and visible frozen fallback;
- run package-scoped parity and at least one real consumer workflow.

Do not add TypeScript everyday authoring, alter rule meaning or authority,
install Rust, or remove the embedded fallback in this card.

## Acceptance Criteria

- [ ] installed payload contains only the named TypeScript/Svelte package;
- [ ] revision-S behavior, nine normative rules, evaluation-only boundary,
  overlays, scope, and retained limitations remain exact;
- [ ] valid consumer files remain byte-identical and existing evidence readable;
- [ ] package source/install parity and immutable registry promotion pass;
- [ ] installed, offline, rollback, acquisition-failure fallback, and real
  consumer routes pass;
- [ ] all new TypeScript package development lands externally during overlap;
- [ ] root fallback is frozen and visibly identified, not silently preferred;
- [ ] full Northstar and package QA pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Workflow availability is preserved. | Ordinary TypeScript coding triggers everyday package policy. | Route remains unavailable. | Negative activation fixture. |
| Overlays stay conditional. | Dependency exists without owned Svelte surface. | Do not activate overlay. | Existing overlay fixtures through package. |
| Package is independent. | Shared source repo also contains Rust. | TypeScript install retains no Rust payload. | Installed inventory. |
| Consumer policy survives. | Existing strict profile and deviation files predate extraction. | Preserve bytes and interpretation. | Migration fixture hashes. |
| Fallback is visible and bounded. | Package acquisition fails during overlap. | Name package failure and frozen root fallback. | Forced-failure transcript. |
| Evidence remains comparable. | Pre-extraction finalized audit is reopened/read. | Preserve schema and meaning. | Evidence compatibility fixture. |

## Evidence Required

- accepted-protocol and source-payload inventories;
- package release identity, registry pin, artifact and manifest digests;
- source/install parity and no-Rust inventory;
- existing production fixtures plus installed, rollback, offline, fallback, and
  real-consumer runs;
- consumer file and evidence compatibility hashes;
- package QA, Northstar QA, `git diff --check`, PR, exact head, and limits.

## Continuation Envelope

- Auto-start next card: no.
- In-bounds next card: 119 only after canary review and protocol reconciliation.
- Remaining ready chain after this card: 0.
- Transition proof: accepted TypeScript package and no unresolved protocol finding.

## Lane Budget

- Current card ends budgeted run: yes.
- Further operator decision required after this card: if the canary requires a
  contract or package-shape change.
- Pause signal if run stops here: lane-complete.

## Stop Conditions

- extraction changes catalogue semantics, workflow availability, repair
  authority, or consumer policy;
- installed package requires Rust or the root source checkout;
- package protocol findings would be copied into Rust;
- revision-S or real-consumer evidence cannot be preserved;
- validation changes the plan.

## Completion Notes

Pending cards 116-117 and readiness refresh.

## Next Task

After card 117 merges, reconcile the exact TypeScript inventory and apply the
ready-state rubric.
