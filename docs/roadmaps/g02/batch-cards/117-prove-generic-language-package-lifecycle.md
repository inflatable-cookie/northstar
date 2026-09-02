# 117 - Prove Generic Language Package Lifecycle

Status: blocked; planning decision required (review findings 1-2)
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
- [x] invalid identity, receipt, content, compatibility, trust, and revocation
  fail before activation (self-check execution contract pending planning);
- [x] raw manifest and canonical tree digest vectors produce exact required
  `sha256:` identities across source, staged, and retained payloads;
- [x] trust and lifecycle documents validate, reject duplicate or stale
  selections, and never take authority from consumer files;
- [x] install/update/rollback failures preserve selection and consumer bytes;
- [ ] compatible installed routing is local-only and works without Effigy
  (operational entrypoint and portable core host pending planning);
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

## Planning Blockers (round-2 review findings 1-2)

Two canonical decisions are missing; the branch stops on them rather than
inventing authority:

1. **Portable core host/API for installed-package routing.** Contract 004
   requires an installed compatible package to remain routable without Effigy,
   but no architecture/contract text names the consumer runtime host or the
   operational API shape. The round-1 repair shipped a Bun CLI surface and
   exercised its oracle without Effigy; round-2 review rejected that as a
   consumer prerequisite without canonical authority (the existing
   production-pack boundary explicitly avoids Bun/Node as a consumer
   prerequisite merely to resolve scope). Decision required: choose and
   document the portable core host/API (candidates: a provider-neutral data
   protocol consumed by the harness directly; a POSIX-shell CLI; a python3
   CLI; or an explicit Bun/Node prerequisite with the boundary updated), then
   expose real operational commands/imports and prove them from an installed
   skill with Effigy absent.
2. **Explicit self-check runner/invocation contract.** The round-1 repair
   executed the declared self-check by treating
   `runtime_capabilities.required_commands[0]` as the runner
   (`<runner> <entrypoint> <staged-root>`). Neither the frozen manifest schema
   nor contract 004 assigns order or runner semantics to `required_commands`.
   Decision required: promote an explicit runner/invocation contract (or
   another provider-neutral self-check mechanism) into
   `package-manifest.schema.json`, contract 004, and spec 034, update
   fixtures, and re-base the self-check oracle on the selected contract.

While these are open, the branch claims only the accepted and repaired parts:
byte-exact digest vectors, trust/lifecycle schemas, identity/receipt-bound
routing, atomic CAS state, immutable digest-addressed installs with truthful
pre-selection receipts, trust restrictions and provenance, offline local
routing, revocation, and the real two-process concurrency oracle. It does not
claim an operational installed runtime or a canonical self-check contract.

## Completion Notes

Status: BLOCKED on planning decisions (round-2 review findings 1-2). The
implementation and oracle work below is delivered and validated; the two
planning-blocked items are scoped out of the claims.

Implemented and falsified against the accepted card-116 baseline, including
round-1 and round-2 review repairs:

- `operator-trust.schema.json` and `lifecycle-state.schema.json` under
  `skills/northstar/references/packages/` inside the frozen Draft 2020-12
  vocabulary, with positive state fixtures and eight negative trust/lifecycle
  fixtures plus schema mutation discrimination and fail-closed keyword proofs.
- A proof surface, `skills/northstar/scripts/language-package-lifecycle.ts`
  (Bun CLI), owns: canonical byte-exact digest framing (Buffer streams,
  permission-bit executable test, fixed external vectors for
  NUL/non-UTF-8/multibyte/0600/0444/0755 from an independent reference);
  operator trust/lifecycle document validation; lock-serialized atomic
  compare-and-swap lifecycle state (stale-owner recovery exactly once,
  fail-closed ambiguous writes, unique staging identities); immutable
  digest-addressed receipts; identity- and receipt-bound routing (requested
  package_id/version bound; receipt loaded, digest-checked, and cross-checked
  against reference and installed manifest); transactional
  acquire/update/rollback; revocation before transport; offline local
  routing; trust restrictions (`workflows`, `consumer_scope`) enforced before
  transport and route; receipts preserving the actual official/allowlist
  trust variant and pin source identity with truthful pre-selection
  `activation_status: "installed"`; and immutable install store addressed by
  the FULL tree digest with exclusive verify-or-fail publishing.
- Round-2 execution-miss repairs landed: staged manifest identity/version/
  range binding with mutated negatives; full-digest immutable install
  addressing with occupied/partial-target counterexamples; and a REAL
  two-process concurrency oracle (separate bun processes, deterministic
  barrier, one winner commits while the other fails closed on the held lock
  without removing it, state stays parseable, single selected identity), plus
  the interrupted/live-lock cases.
- All eight review-oracle rows falsified plus restrictions, provenance,
  concurrency, self-check execution (provisional, pending the runner
  contract), and identity/store negatives. Every written receipt is
  schema-validated by the checker (13 receipts).
- The policy-free fixture was revised to an executable self-check
  (`scripts/self-check.sh`, declared `sh` capability); the accepted card-116
  manifest identity `029efa32...` remains the recorded baseline, and the
  revised fixture derives manifest
  `sha256:bfd357c0e39785c974147e7521e6d39da0c121c2842a25bc7148535a640fdf45`,
  tree `sha256:125c0daf6de56f00ae8f293425b587af767a1bacfacac3711c042e9b56ae40d9`.
- Validation: standalone oracle (Effigy absent) PASS; `effigy
  check:language-packages` PASS (13 receipt schema validations); isolated
  skill-install parity; `effigy qa:docs`; `effigy qa`; `git diff --check`.

Not claimed (planning-blocked): an operational installed runtime entrypoint
and portable core host (see Planning Blockers 1) and a canonical self-check
runner/invocation contract (see Planning Blockers 2). The Bun surface is the
accepted proof harness, not a settled consumer prerequisite.

## Next Task

Stop at planning: the orchestrator must settle the portable core host/API and
the self-check runner/invocation contract (Planning Blockers 1-2) before this
card can complete. Do not start card 118 or TypeScript extraction until those
decisions land and this card's PR is reviewed and merged.
