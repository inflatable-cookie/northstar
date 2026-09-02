# 117 - Prove Generic Language Package Lifecycle

Status: complete
Owner: repo maintainers
Updated: 2026-09-02
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, card 116
Auto-start next card: no

## Ready-State Checks

- [x] card 116 is merged and this card names its exact schema and fixture
  identities;
- [x] canonical digest framing and operator-owned lifecycle/trust state are
  promoted into architecture, contract 004, and spec 034;
- [x] runtime scope is limited to generic discovery, verification, lifecycle,
  routing, and fixture proof;
- [x] transaction, trust, offline, rollback, and failure boundaries are
  canonical;
- [x] review oracle and stop conditions cover all material negative behavior;
- [x] no language policy or extraction belongs in this card.

## Objective

Implement and falsify the generic installed-package resolver and transactional
fixture lifecycle without adding language-specific core behavior.

## Accepted Card-116 Baseline

- reviewed head: `87496cb31877713d270b7361b297c54633c13d99`;
- merge commit: `eaeac8889dd340e03558594e3d486b5dceaef9ce`;
- manifest schema SHA-256: `393e7948f7826bbeec44e6286704573eee94d987374045642976cda7ad5f3c40`;
- registry schema SHA-256: `72bdea9eac29a3681fbc8a3f48885be8630fa0cbaae37ea07409d403e238837d`;
- receipt schema SHA-256: `7e83635408f68a9ae20f8fbe75aa7ef41d22784c08834f49b30d31a7a70a5d85`;
- official registry SHA-256: `b7d77d17524f50ce0e2a3c123349199b4e1473cff31accc71e43313abde2dc43`;
- policy-free fixture manifest SHA-256: `029efa327745aba66c3316714cfb28b29246c365459bb5c9d7e6526e409c64ef`.

These are source-baseline identities. Card 117 implements the promoted
canonical package-tree algorithm and derives the first runtime tree identity;
it must not substitute Git tree IDs or ad hoc archive hashes.

## Lane Runway Context

- Higher-level lane owner: g02.048 Batch A.
- Next likely card: 118 TypeScript/Svelte canary.
- Next planning checkpoint: refresh TypeScript source inventory and migration
  proof against the accepted runtime protocol.

## Scope

- discover compatible installed packages through the available-skill catalogue
  or an adapter-resolved path;
- implement the canonical manifest/tree digest framing and reject non-portable
  paths, collisions, symlinks, special files, and digest spelling drift;
- add `operator-trust.schema.json` and `lifecycle-state.schema.json` under the
  generic package references, with fixtures and the bounded schema evaluator;
- verify manifest, registry, receipt, content, compatibility, revocation, and
  self-check ordering;
- prove local immutable acquisition, transactional activation, retained
  rollback, offline routing, and language-workflow-only failure;
- emit visible official acquisition and migration/failure notices;
- expose generic package routing without hard-coded language branches;
- add deterministic positive and negative fixture oracles and installed parity.

Do not fetch a production language package, add language policy, change
consumer activation, or depend on Effigy for installed routing.

## Acceptance Criteria

- [x] explicit workflow intent or existing activation can acquire the pinned
  fixture; detection alone cannot;
- [x] invalid identity, receipt, content, compatibility, trust, revocation, or
  self-check fails before activation;
- [x] raw manifest and canonical tree digest vectors produce exact required
  `sha256:` identities across source, staged, and retained payloads;
- [x] trust and lifecycle documents validate, reject duplicate or stale
  selections, and never take authority from consumer files;
- [x] install/update/rollback failures preserve selection and consumer bytes;
- [x] compatible installed routing is local-only and works without Effigy;
- [x] offline missing-package failure stops only the requested package workflow;
- [x] ambiguous create/acquire outcomes retain identity and never duplicate an
  installed package;
- [x] no language or provider-specific branch enters core;
- [x] full QA, package checks, parity, and negative side-effect proof pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Detection is not authority. | Cargo files exist without Rust intent or activation. | No acquisition attempt. | Transport spy fixture. |
| Content identity is canonical. | Two adapters reorder files, follow a symlink, or spell a digest without `sha256:`. | Reject or derive the same exact identity before execution. | Cross-adapter vectors and path-type negatives. |
| Activation is transactional. | Candidate self-check fails after bytes stage. | Old selection and consumer files remain exact. | Before/after digest proof. |
| State is operator-owned and compare-and-swap. | Consumer config selects a package or a writer uses a stale revision. | Ignore consumer authority; retain current selection and staged identity. | State-root and stale-writer fixtures. |
| Offline is local. | Network unavailable with a compatible install. | Route installed package without registry access. | Network-denied fixture. |
| Failure is scoped. | Requested package is missing offline. | Stop only package workflow; core route still passes. | Dual-workflow fixture. |
| Trust is revocable. | Installed receipt is valid but its identity is revoked. | Block execution, retain evidence and bytes. | Revocation fixture. |
| Routing is generic. | Fixture uses an unknown language name with declared workflow. | Resolve by manifest fields, not core switch. | Synthetic-language fixture. |

## Evidence Required

- exact card-116 identity references above and this readiness record;
- canonical digest vectors plus lifecycle/trust schema conformance and
  fail-closed vocabulary proof;
- lifecycle state-transition matrix and mutation-before/after hashes;
- acquisition notices and detection-only no-call proof;
- Effigy-absent installed route, offline, rollback, revocation, and ambiguity
  fixtures;
- package checks, isolated install parity, `effigy qa`, and `git diff --check`;
- closeout log, reviewable PR, exact tested head, and limitations.

## Continuation Envelope

- Auto-start next card: no.
- In-bounds next card: 118 after review, merge, and TypeScript readiness refresh.
- Remaining ready chain after this card: 0.
- Transition proof: accepted fixture lifecycle and generic routing evidence.

## Lane Budget

- Current card ends budgeted run: yes.
- Further operator decision required after this card: only if the runtime
  protocol contradicts the promoted contract.
- Pause signal if run stops here: lane-complete.

## Stop Conditions

- runtime needs a language-specific route, global daemon, or required Effigy;
- transactional recovery cannot preserve the active install and consumer files;
- a provider API must become part of the reusable contract;
- fixture proof exposes an architecture or trust gap;
- validation changes the plan.

## Completion Notes

Completed and falsified the generic language package lifecycle (g02.048/117)
against the accepted card-116 baseline:

- Added `operator-trust.schema.json` and `lifecycle-state.schema.json` under
  `skills/northstar/references/packages/` inside the frozen Draft 2020-12
  vocabulary, with positive state fixtures and eight negative trust/lifecycle
  fixtures (duplicate allowlist, duplicate revocation, missing fields, digest
  spelling drift, duplicate selection, duplicate receipt references, missing
  required fields, bare-hex digests) plus schema mutation discrimination and
  fail-closed keyword proofs.
- Implemented the canonical content identity: manifest digest over exact
  manifest bytes and the package-tree digest over the sorted length-framed
  regular-file stream `F\0<path-len>\0<path>\0<executable>\0<content-len>\0<content>`,
  with required `sha256:` spelling, rejection of non-portable paths, symlinks
  (never followed), special files, and case-fold collisions, and the
  executable bit as the only retained mode. The policy-free fixture derives the
  first runtime tree identity `sha256:653ce7f63ddc46da3381314d561dea3657b4eaf59eb8aa1c57b4ba046d9f90f0`
  (manifest `sha256:029efa327745aba66c3316714cfb28b29246c365459bb5c9d7e6526e409c64ef`),
  proven identical across source, staged, and retained payloads and across
  reordered cross-adapter materialization.
- Implemented the generic installed-package runtime in
  `check-language-packages.rhai`: local-only discovery and routing by manifest
  fields (no language switch, no Effigy dependency, read-only route selection
  proven by scan slices), operator-owned lifecycle state with immutable
  digest-addressed receipts and compare-and-swap replacement, transactional
  acquisition/update/rollback with deterministic staged self-check, revocation
  gating before any transport, and visible acquisition/routing/failure notices.
- Falsified all eight review-oracle rows with deterministic fixtures:
  detection-is-not-authority transport spy (zero calls), canonical identity
  vectors and path-type negatives, transactional activation with before/after
  hashes, operator-owned compare-and-swap with a stale-writer conflict, offline
  network-denied local routing, scoped dual-workflow failure, revocable trust
  with retained evidence/bytes, and synthetic `quantum-lang` manifest-field
  routing.
- Lifecycle transition matrix proven: init -> installed -> updated (prior
  retained) -> rolled back -> revoked, with every failed install/update/rollback
  leaving selection, state revision, receipts, and consumer bytes byte-identical.
- Wired the new schemas and fixtures into the repo-contract required files and
  documented the extended check in `scripts/README.md`.
- Validated with `effigy check:language-packages` (all 8 oracles), isolated
  skill-install parity (168 files), `effigy qa:docs`, `effigy qa`, and
  `git diff --check`.

Known limits: the runtime proof executes the deterministic protocol self-check
gate over the staged payload rather than arbitrary package code (the policy-free
fixture carries no runnable engine; real package execution is the card 118
canary boundary). The case-fold collision negative is proven through the same
fold-registration predicate the walker executes because the host filesystem is
case-insensitive and cannot materialize two case-only names. Receipt documents
are validated for schema conformance by the harness against every written
receipt; the runtime constructs them from its fixed template (Effigy Rhai caps
call depth at eight frames, which oneOf recursion inside the runtime would
exceed).

## Next Task

Stop for exact-head review. After merge, refresh card 118 against the shipped
generic lifecycle protocol; do not start TypeScript extraction until the
generic lifecycle PR is reviewed and merged.
