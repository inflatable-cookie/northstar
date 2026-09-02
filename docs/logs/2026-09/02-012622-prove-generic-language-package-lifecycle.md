# Prove Generic Language Package Lifecycle

Date: 2026-09-02
Roadmap: `g02.048`
Card: `g02.048/117`
Status: complete; ready for review

## Result

The generic installed-package lifecycle is implemented and falsified against
the accepted card-116 baseline. Northstar core now has a provider-neutral
runtime proof covering canonical content identity, operator-owned
trust/lifecycle state, transactional acquisition/update/rollback, offline
local routing, revocable trust, and generic manifest-field routing — with no
language-specific core branch, no Effigy dependency, and no consumer-owned
trust or selection.

The policy-free fixture derives the first runtime tree identity
`sha256:653ce7f63ddc46da3381314d561dea3657b4eaf59eb8aa1c57b4ba046d9f90f0`
(manifest `sha256:029efa327745aba66c3316714cfb28b29246c365459bb5c9d7e6526e409c64ef`),
proven identical across source, staged, and retained payloads and across
reordered cross-adapter materialization.

## Changed surfaces (before/after)

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/packages/operator-trust.schema.json` | did not exist | Draft 2020-12 schema for exact allowlist entries and revocations (required `sha256:` digests, source identity, scope, actor, timestamp, reason) |
| `skills/northstar/references/packages/lifecycle-state.schema.json` | did not exist | Draft 2020-12 schema for the revisioned lifecycle index with immutable receipt references and at most one selected receipt per package |
| `skills/northstar/assets/fixtures/language-packages/state/` | did not exist | Positive operator-trust and lifecycle-state conformance specimens pinning the accepted fixture identity |
| `skills/northstar/assets/fixtures/language-packages/negative/trust/`, `negative/lifecycle/` | did not exist | Eight negative fixtures: duplicate allowlist, duplicate revocation, missing fields, bare-hex digest, duplicate selection, duplicate references, missing required, bare-hex digest |
| `skills/northstar/assets/fixtures/language-packages/synthetic-language/` | did not exist | Positive fixture declaring the unknown `quantum-lang` language for generic routing proof |
| `skills/northstar/scripts/check-language-packages.rhai` | card-116 contract validation | + canonical manifest/tree digest framing, operator trust/lifecycle document validation, generic resolver and transactional lifecycle, visible notices, eight review-oracle falsifications, runtime scan slices |
| `scripts/lib/northstar-repo-contract-data.rhai` | lacked card-117 surfaces | New schemas and fixture files pinned in required files |
| `scripts/README.md` | documented card-116 check | Extended check surface documented (items 11-16) |
| `docs/roadmaps/g02/batch-cards/117-prove-generic-language-package-lifecycle.md` | `ready` | `complete` with acceptance criteria and completion notes |

## Review oracle invariants falsified

| Invariant | Adversarial counterexample | Expected failure or stop point | Proof |
| --- | --- | --- | --- |
| Detection is not authority | Cargo files exist without Rust intent or activation | No acquisition attempt | Transport spy fixture: `handle_workflow_request` with `detection` intent returns no-route, spy zero calls, no lifecycle state created, consumer bytes exact |
| Content identity is canonical | Two adapters reorder files, follow a symlink, or spell a digest without `sha256:` | Reject or derive the same exact identity before execution | Cross-adapter reordered vectors equal the frozen tree digest; symlink, special-file, case-fold, and spelling negatives rejected; executable bit changes identity |
| Activation is transactional | Candidate self-check fails after bytes stage | Old selection and consumer files remain exact | 0.3.0 candidate staged, self-check gate fails, state revision, selection, receipts, and consumer hashes byte-identical |
| State is operator-owned and compare-and-swap | Consumer config selects a package or a writer uses a stale revision | Ignore consumer authority; retain current selection and staged identity | Consumer-claimed trust never routes or acquires; stale writer's CAS write conflicts, selection and state unchanged, no duplicate install |
| Offline is local | Network unavailable with a compatible install | Route installed package without registry access | Network-denied adapter: route succeeds with zero transport calls and exact resolved identity |
| Failure is scoped | Requested package is missing offline | Stop only package workflow; core route still passes | Dual-workflow fixture: missing-language workflow stops with identity and local route notice; installed workflow still routes |
| Trust is revocable | Installed receipt is valid but its identity is revoked | Block execution, retain evidence and bytes | Revocation stops routing and acquisition before any transport call; installed bytes, receipts, and lifecycle state retained |
| Routing is generic | Fixture uses an unknown language name with declared workflow | Resolve by manifest fields, not core switch | `quantum-lang` installs and routes via manifest fields; undeclared workflow and wrong-language requests do not route; scan slices prove no language branch or Effigy in the runtime |

## Lifecycle transition matrix

| Transition | Result |
| --- | --- |
| none -> installed (workflow request, allowlist pin) | activated; revision 1; one selected receipt |
| installed -> updated (explicit intent, pinned variant) | activated; revision 2; prior receipt retained |
| update failure (self-check fails after staging) | stopped; revision, selection, and bytes exact |
| installed -> rolled back (retained proven install) | reselected; revision 3; no transport calls |
| rollback failure (retained bytes tampered) | stopped at revalidation; selection and state exact |
| installed -> revoked | routing and acquisition blocked; evidence and bytes retained |
| stale writer CAS | conflict; current selection and staged identity retained; no duplicates |

## Validation

- `effigy check:language-packages` — pass (card-116 suite plus both new
  schemas, 8 negative trust/lifecycle fixtures, mutation discrimination and
  fail-closed vocabulary proofs, canonical digest vectors, and all 8
  card-117 review-oracle falsifications);
- `effigy check:skill-install /tmp/northstar-skill-install-117` — pass
  (168 files in exact isolated parity);
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — clean.

## Limits

The runtime proof executes the deterministic protocol self-check gate over the
staged payload rather than arbitrary package code: the policy-free fixture
carries no runnable engine, and real package execution is the card-118 canary
boundary. The case-fold collision negative is proven through the same
fold-registration predicate the walker executes because the host filesystem is
case-insensitive and cannot materialize two case-only names. Receipt documents
are schema-validated by the harness against every written receipt; the runtime
constructs them from its fixed template because Effigy Rhai caps call depth at
eight frames, which oneOf recursion inside the runtime would exceed. No
production package was fetched, no language policy was added, and consumer
activation was not changed.

## PR

https://github.com/inflatable-cookie/northstar/pull/22 — opened for card
`g02.048/117` against `main` from
`worker/prove-generic-language-package-lifecycle`. Exact tested head:
`cab4cad` (all validation above ran on this commit); the PR head advances only
with this closeout record. Exact-head review pending; do not merge.
