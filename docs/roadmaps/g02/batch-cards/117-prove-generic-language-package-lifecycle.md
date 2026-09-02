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

## Accepted Review Decisions

- The operational boundary is the provider-neutral
  `language-package-host.v1` JSON request/result protocol. Host adapters supply
  native catalogue, filesystem, atomic-state, transport, and execution
  capabilities. Effigy and Bun are optional adapters/reference harnesses, not
  consumer prerequisites.
- V1 operations are `resolve`, `acquire_activate`, and `rollback`; requests and
  results follow spec 034's exact fields and status grammar.
- `self_check.invocation` is an explicit `direct`/`command` tagged union. Direct
  execution receives `[package_root]`; command execution receives
  `[resolved_entrypoint, package_root]`. Capability-list order has no meaning.
- These decisions resolve PR 22 review round-two planning findings 1 and 2.

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
- add and validate the `language-package-host.v1` request/result machine
  contract and exercise operational resolve/acquire/rollback entrypoints from
  an installed skill with Effigy absent;
- extend the manifest schema and fixtures with the explicit self-check
  invocation union and prove both variants plus missing-capability failure;
- add deterministic positive and negative fixture oracles and installed parity.

Do not fetch a production language package, add language policy, change
consumer activation, or depend on Effigy for installed routing.

## Acceptance Criteria

- [x] explicit workflow intent or existing activation can acquire the pinned
  fixture; detection alone cannot;
- [x] invalid identity, receipt, content, compatibility, trust, and revocation
  fail before activation (self-check execution per the explicit invocation contract);
- [x] raw manifest and canonical tree digest vectors produce exact required
  `sha256:` identities across source, staged, and retained payloads;
- [x] trust and lifecycle documents validate, reject duplicate or stale
  selections, and never take authority from consumer files;
- [x] install/update/rollback failures preserve selection and consumer bytes;
- [x] compatible installed routing is local-only and works without Effigy;
- [x] the installed operational surface accepts and returns
  `language-package-host.v1` messages without requiring Bun, Node, Python,
  POSIX shell, Effigy, or a provider API;
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
| Host protocol is portable. | Installed skill is invoked with Effigy and Bun absent, or an adapter omits one required capability. | Conforming host message routes; missing capability returns scoped `stopped`. | Installed-skill protocol fixture and capability-denied adapter. |
| Self-check invocation is explicit. | Capability order changes, command runner is undeclared, or direct entrypoint is not executable. | Order has no effect; invalid invocation stops before selection. | Direct/command fixtures and negative runner/permission cases. |

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
against the accepted card-116 baseline and the promoted review decisions
(`language-package-host.v1` operational protocol; explicit self-check
invocation), across the PR 22 review rounds:

- `operator-trust.schema.json` and `lifecycle-state.schema.json` under
  `skills/northstar/references/packages/` inside the frozen Draft 2020-12
  vocabulary, with positive state fixtures and eight negative trust/lifecycle
  fixtures plus schema mutation discrimination and fail-closed keyword proofs.
- Canonical byte-exact content identity: manifest digest over exact manifest
  bytes and package-tree digest over the sorted length-framed regular-file
  stream, executable bit from permission bits, and fixed external vectors
  (NUL, non-UTF-8, multibyte, 0600/0444/0755) from an independent reference.
  The policy-free fixture derives the runtime identities: manifest
  `sha256:b9cdf39bbf2ae4fc2aeee656d2c8dc655c0faa951fbeec255eb887f210a683f9`,
  tree `sha256:b8e76dfdc87d84904ada0620425c0a94200532d11207e3d1339626fb2df85aa3`
  (the accepted card-116 identity `029efa32...` remains the recorded baseline).
- `language-package-host.v1` machine contract
  (`language-package-host-v1.schema.json`): resolve, acquire_activate, and
  rollback requests bind protocol version, intent, identity, version,
  language, workflow, core version, consumer scope/dir, and the operator state
  root (rollback binds the target receipt digest); results carry
  routed/activated/rolled_back/stopped, exact identities, resolved path and
  receipt when applicable, and the visible notice. Operational entrypoints
  are exercised from an INSTALLED SKILL with Effigy absent: the reference
  adapter (this repo's Bun harness — a reference adapter only) implements all
  three operations through the installed entrypoint, and a resolve-bound
  stdlib-only python3 host implements resolve while stopping
  acquire_activate/rollback as missing capability; capability-denied hosts
  and unsupported protocol versions return scoped `stopped` notices and never
  a fallback runtime or a v1 answer to a non-v1 request. No Bun, Node,
  Python, POSIX shell, Effigy, or provider API is a consumer prerequisite.
- Explicit `self_check.invocation` tagged union (`direct` executes the
  verified entrypoint with `[package_root]`; `command` executes a declared
  command, which must appear in `required_commands`, with
  `[entrypoint, package_root]`; package root is the working directory; no
  shell interpolation, no order semantics), frozen into
  `package-manifest.schema.json` and fixtures; both positive variants proven
  with argv/cwd evidence, plus undeclared-runner, unavailable-runner, and
  non-executable-direct negatives, and three schema-level negative fixtures.
- Identity-, receipt-, and trust-bound lifecycle: full-digest immutable
  install store with exclusive verify-or-fail publishing and truthful
  pre-selection receipts; lock-serialized atomic compare-and-swap state with
  stale-owner recovery and fail-closed ambiguity (real two-process oracle);
  trust restrictions and truthful receipt provenance; revocation before
  transport; offline local routing; scoped workflow failure.
- All ten review-oracle rows falsified (the eight original plus host-protocol
  portability and self-check invocation) plus restrictions, provenance,
  concurrency, identity/store, and invocation negatives. The checker
  schema-validates every written receipt (20) and every host request/result
  message (23), plus four negative result fixtures rejecting incomplete or
  operation-incoherent results. The request consumer scope binds trust
  restrictions at the host boundary for resolve and activation (mismatched
  scope against a restricted pin stops through the operational entrypoint).
  Repo-contract required files and `scripts/README.md` wired.
- Validation: standalone oracle (Effigy absent, all 13 groups) PASS;
  `effigy check:language-packages` PASS (20 receipts and 23 host messages
  schema-validated); isolated skill-install parity; `effigy qa:docs`;
  `effigy qa`; `git diff --check` clean.

## Next Task

Stop for exact-head re-review. After merge, refresh card 118 against the
shipped generic lifecycle protocol; do not start TypeScript extraction until
this PR is reviewed and merged.
