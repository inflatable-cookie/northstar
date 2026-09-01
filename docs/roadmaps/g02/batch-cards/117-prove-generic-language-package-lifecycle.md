# 117 - Prove Generic Language Package Lifecycle

Status: planned; blocked on card 116
Owner: repo maintainers
Updated: 2026-09-01
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, card 116
Auto-start next card: no

## Ready-State Checks

- [ ] card 116 is merged and this card names its exact schema and fixture
  identities;
- [x] runtime scope is limited to generic discovery, verification, lifecycle,
  routing, and fixture proof;
- [x] transaction, trust, offline, rollback, and failure boundaries are
  canonical;
- [x] review oracle and stop conditions cover all material negative behavior;
- [x] no language policy or extraction belongs in this card.

## Objective

Implement and falsify the generic installed-package resolver and transactional
fixture lifecycle without adding language-specific core behavior.

## Lane Runway Context

- Higher-level lane owner: g02.048 Batch A.
- Next likely card: 118 TypeScript/Svelte canary.
- Next planning checkpoint: refresh TypeScript source inventory and migration
  proof against the accepted runtime protocol.

## Scope

- discover compatible installed packages through the available-skill catalogue
  or an adapter-resolved path;
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

- [ ] explicit workflow intent or existing activation can acquire the pinned
  fixture; detection alone cannot;
- [ ] invalid identity, receipt, content, compatibility, trust, revocation, or
  self-check fails before activation;
- [ ] install/update/rollback failures preserve selection and consumer bytes;
- [ ] compatible installed routing is local-only and works without Effigy;
- [ ] offline missing-package failure stops only the requested package workflow;
- [ ] ambiguous create/acquire outcomes retain identity and never duplicate an
  installed package;
- [ ] no language or provider-specific branch enters core;
- [ ] full QA, package checks, parity, and negative side-effect proof pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Detection is not authority. | Cargo files exist without Rust intent or activation. | No acquisition attempt. | Transport spy fixture. |
| Activation is transactional. | Candidate self-check fails after bytes stage. | Old selection and consumer files remain exact. | Before/after digest proof. |
| Offline is local. | Network unavailable with a compatible install. | Route installed package without registry access. | Network-denied fixture. |
| Failure is scoped. | Requested package is missing offline. | Stop only package workflow; core route still passes. | Dual-workflow fixture. |
| Trust is revocable. | Installed receipt is valid but its identity is revoked. | Block execution, retain evidence and bytes. | Revocation fixture. |
| Routing is generic. | Fixture uses an unknown language name with declared workflow. | Resolve by manifest fields, not core switch. | Synthetic-language fixture. |

## Evidence Required

- exact card-116 identity references and updated readiness record;
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

Pending card 116.

## Next Task

After card 116 merges, refresh exact identities and apply the ready-state rubric.
