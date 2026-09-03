# 119 - Extract Rust Language Package

Status: active; registry pin merged, Convergence canary in flight
Owner: repo maintainers
Updated: 2026-09-03
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, cards 116-118
Auto-start next card: no

## Ready-State Checks

- [x] TypeScript canary is accepted and protocol findings are reconciled;
- [x] the TypeScript package's agent-facing `SKILL.md` is standalone and the
  replacement identity is pinned through card 121;
- [x] current Rust payload, engine, install, and consumer cohort are inventoried;
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
  offline, visible fallback, and the Convergence real-consumer canary;
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
| Engine source identity survives extraction. | The installed binary's embedded source-payload identity differs from the current package engine source. | Reject before audit execution. | Source-payload and embedded-identity tamper fixtures. |
| Consumer owns MSRV. | Package infers or raises compiler floor. | Stop for repository policy. | Existing MSRV fixtures. |
| Package is independent. | Shared repo includes TypeScript sibling. | Rust install retains no TypeScript payload. | Installed inventory. |
| Evidence remains exact. | Existing v2 records are read after migration. | Preserve lifecycle and result meaning. | Compatibility fixtures. |
| Fallback is visible and bounded. | Registry acquisition fails during overlap. | Name failure and frozen fallback. | Forced-failure transcript. |

## Evidence Required

- accepted TypeScript protocol findings, card 121 replacement identity, and
  the current Rust inventory frozen in
  `docs/logs/2026-09/03-005031-refresh-rust-package-readiness.md`;
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
consumer limits are recorded in card 118 and its closeout log.

The post-merge readiness refresh re-derived the 54-file Rust extraction
boundary at Northstar `69e4d5dea3daa4f6133d7363d39c1a0f72848435`: 24 language references,
two modes, two Rhai scripts, 22 Cargo-engine files, one explicit command skill,
and three templates. The SHA-256 of the sorted GNU `sha256sum` listing is
`2f8515afce33c87e9b38f103b9c41440ed7f182142fc2c65fed4d10d9264040b`.
The historical 120-file figure is whole-skill distribution parity, not the
package source boundary. The earlier readiness log's `4f534b...` object is not
retrievable; current merged `main` reproduces its exact 54-file listing digest
and is the extraction source pin.

The operator selected Convergence as the real-consumer canary. Its clean
checkout was at `1f05db1e507aa67f73a68eccc2325e23dfc1d478`, with six Cargo
manifests, active everyday and explicit-audit instructions, profile digest
`5049d861115f819db5368dcd9ab2dc45381d1be6c5ae3c9947aa1e595fc281a4`,
and deviations digest
`d6d876aeb6e70da9fec368201350b6d16f345a7363309dde4169284c51c2fcd0`.

Package-source PR 3 repaired the TypeScript adapter and merged as `c9ef2a2`.
Card 121 pinned that identity at registry version `1.3.0` and merged as
`69e4d5d`. Independent review reproduced the package tree and manifest digests,
the superseded tree failed closed, and full Northstar QA passed. The serial
prerequisite is clear.

Rust package-source PR 4 passed exact-head review at
`7cc4cd018e82f45a411bb40b300028925d649cb6` and squash-merged as
`56b2e1107b80f369807cff88e1b0253df035c700`. The accepted 59-file
`@northstar/rust-quality` `0.1.0` candidate has raw spec-034 tree digest
`sha256:e5cf9c5da4a30c0f5164f2ea0c5e9d87d544c0c32f09f3c139a386c56154dba0`
and manifest digest
`sha256:dd71d04efd67cc7805f417a79666dd920ea1811ee252d941108dfbeca8aab612`.
Independent review reproduced both identities, package/repository QA passed,
and the pre-extraction engine produced a v2 ledger finalized by the installed
engine. Registry promotion is now the ready serial step; the Convergence
consumer canary remains behind its reviewed merge.

The Northstar registry promotion pinned that identity at registry version
`1.4.0` and opened the bounded Rust overlap window. Two independent
spec-034 implementations reproduced both digests over the 59-file tree. The
real-package transcript proved visible official-acquisition stop,
detection refusal, allowlist non-bypass, activation with the real self-check,
offline routing for both workflows, drift stop/restore, TypeScript and
wrong-identity staging refusals, the version-drifted variant refusal, the
exact frozen-Rust fallback notice, and the Rust-only retained inventory. The
package's installed-route prover passed on the installed payload, including
54-source parity, cross-boundary v2 ledger migration, and engine
source-payload tamper rejection. Evidence is in
`docs/logs/2026-09/03-033950-pin-rust-package-candidate.md`.

PR 27 exact-head review required two repairs, both landed: both Rust router
sections now route through the generic installed-package route by package
ID, version, and workflow with the visible bounded fallback (the exact
commit/tree/manifest pin stays owned by the official registry); and the
real-package replay is committed as the deterministic `check:rust-package-pin`
oracle wired into authoritative `qa` (installed skill stays independent of
the package-source sibling). A second review round removed the router's
registry-owned digest duplication and the prose-coupled checker assertions
as prohibited prose-coupled validation.

PR 27 passed the final exact-head review at `63353b1` and squash-merged as
`256d0f7`. Convergence milestone `g02.031` and card 102 were committed at
`c8f513f`; its evidence-only canary is running in a dedicated Paseo worktree.

## Next Task

Review the Convergence real-consumer canary at its reported exact head. Card
120 remains blocked until the installed everyday-authoring, explicit-audit,
consumer-policy/evidence, and before/after-hash proof is accepted.
