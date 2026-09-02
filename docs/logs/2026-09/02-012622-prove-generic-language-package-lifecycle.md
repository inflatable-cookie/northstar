# Prove Generic Language Package Lifecycle

Date: 2026-09-02
Roadmap: `g02.048`
Card: `g02.048/117`
Status: complete; exact-head review repaired; ready for re-review

## Result

The generic installed-package lifecycle is implemented and falsified against
the accepted card-116 baseline, then repaired against the exact-head review of
PR 22. The lifecycle ships as a callable provider-neutral surface
(`skills/northstar/scripts/language-package-lifecycle.ts`, run by Bun) with
canonical byte-exact content identity, operator-owned trust/lifecycle state,
atomic compare-and-swap lifecycle replacement, immutable digest-addressed
receipts, identity-bound routing, transactional acquisition/rollback, offline
local routing, revocation, and declared self-check execution — with no
language-specific branch, no Effigy dependency, and no consumer-owned trust or
selection. The exact same surface is exercised with Effigy absent
(`bun run language-package-lifecycle.ts oracle ...`) and from the Effigy
checker, which also schema-validates every receipt the surface writes.

The policy-free fixture was revised so its declared self-check is executable:
`scripts/self-check.sh` runs under the declared `required_commands: ["sh"]`
capability after identity and compatibility gates. The accepted card-116
manifest identity `029efa32...` remains the recorded baseline; the revised
fixture derives the new runtime identities:

- manifest `sha256:bfd357c0e39785c974147e7521e6d39da0c121c2842a25bc7148535a640fdf45`
- tree `sha256:125c0daf6de56f00ae8f293425b587af767a1bacfacac3711c042e9b56ae40d9`

## Changed surfaces (before/after)

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/scripts/language-package-lifecycle.ts` | did not exist | Provider-neutral Bun lifecycle surface: byte-exact digests, trust/lifecycle validation, lock-based atomic CAS state, immutable receipts, identity/receipt-bound resolver, transactional acquire/rollback, declared self-check execution, oracle suite |
| `skills/northstar/references/packages/operator-trust.schema.json` | did not exist | Draft 2020-12 schema for exact allowlist entries and revocations |
| `skills/northstar/references/packages/lifecycle-state.schema.json` | did not exist | Draft 2020-12 schema for the revisioned lifecycle index |
| `skills/northstar/assets/fixtures/language-packages/policy-free-fixture/` | rhai self-check | `scripts/self-check.sh` + manifest declaring `sh` capability (revised identity) |
| `skills/northstar/assets/fixtures/language-packages/state/`, `negative/trust/`, `negative/lifecycle/`, `synthetic-language/` | card-116 era | Positive/negative trust and lifecycle fixtures, synthetic-language sh self-check |
| `skills/northstar/scripts/check-language-packages.rhai` | card-116 contract validation + card-117 Rhai runtime | Card-116 engine unchanged; card-117 section is now a driver: schema validation of trust/lifecycle fixtures, surface scan, oracle invocation, receipt schema validation |
| `scripts/lib/northstar-repo-contract-data.rhai`, `scripts/README.md` | lacked card-117 surfaces | New schemas/fixtures pinned; extended check documented |
| card 117, roadmap 048, g02/README, generation-index, roadmaps/README, docs/README, contract-index, spec 034 | card 117 ready | card 117 complete; card 118 planned behind review and merge |

## Review repair (PR 22 findings)

| Finding | Repair |
| --- | --- |
| Runtime not an installed surface; cannot work without Effigy | Lifecycle moved to a shipped provider-neutral Bun CLI; exercised both with Effigy absent and from the checker over the same file; surface code scanned (comments stripped) for Effigy, providers, and language branches |
| Tree identity not byte-exact (decimal mode parse; string framing) | Executable bit from permission bits (`mode & 0o111`); frame built from Buffers with byte lengths; fixed external vectors for `0600`/`0444`/`0755`, NUL, non-UTF-8, and multibyte content, expected digests from an independent reference |
| Route without matching receipt or requested identity | Resolver binds requested package_id/version; loads and digest-checks the immutable receipt; cross-checks receipt/reference/installed manifest; missing/forged/mismatched records are not routable |
| Trust restrictions and receipt provenance discarded | `workflows` and `consumer_scope` enforced before transport and before route execution; receipts preserve the actual official/allowlist trust variant and the pin's source identity; constructed receipts validated before reference; restricted-workflow, restricted-consumer, official-source, and provenance counterexamples covered |
| Replacement not atomic/CAS; shared temp names | Lock-file serialization with O_EXCL, stale-owner recovery (dead pid) exactly once, fail-closed ambiguous-write handling, unique staging identities, atomic rename; overlapping-writer (one winner, one conflict, no duplicates) and interrupted-write (stale lock recovered, live lock fails closed, no truncation) oracles |
| Declared self-check never runs | Fixture self-check is executed through the declared `sh` capability after identity/compat gates; valid-present-but-failing self-check proves execution by its output with state/consumer bytes exact; packages without a declared runtime command stop plainly |

## Review oracle invariants falsified

Detection is not authority (transport spy, zero calls); content identity is
canonical (independent vectors, reorder, symlink, special, fold, spelling);
activation is transactional (before/after hashes exact); state is
operator-owned compare-and-swap (consumer authority ignored, stale writer
conflict); offline is local (network-denied adapter, zero calls); failure is
scoped (dual-workflow); trust is revocable (execution blocked, evidence and
bytes retained); routing is generic (`quantum-lang` by manifest fields, no
core switch). Plus trust-restriction/provenance counterexamples and
concurrency oracles above.

## Lifecycle transition matrix

| Transition | Result |
| --- | --- |
| none -> installed (workflow request, allowlist pin) | activated; revision 1; one selected receipt |
| installed -> updated (explicit intent, pinned variant) | activated; revision 2; prior receipt retained |
| update failure (self-check fails after staging) | stopped; revision, selection, and bytes exact |
| installed -> rolled back (retained proven install) | reselected; revision 3; no transport calls |
| rollback failure (retained bytes tampered) | stopped at revalidation; selection and state exact |
| installed -> revoked | routing and acquisition blocked; evidence and bytes retained |
| stale/overlapping writer CAS | conflict; current selection retained; no duplicates |
| interrupted write | stale lock recovered once; live lock fails closed; no truncation |

## Validation

- `bun run language-package-lifecycle.ts vectors <fixture>` — pass
  (independent constants; NUL, non-UTF-8, multibyte, 0755/0600/0444 vectors);
- `bun run language-package-lifecycle.ts oracle <fixture> <out>` — pass with
  Effigy absent (11 oracle groups; all 8 review rows + restrictions +
  provenance + concurrency + self-check);
- `effigy check:language-packages` — pass (card-116 suite; trust/lifecycle
  fixtures; fail-closed proofs; surface oracle driven from the checker; 12
  receipts schema-validated);
- `effigy check:skill-install <isolated>` — pass (168 files, exact parity);
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — clean.

## Limits

The fixture self-check executes under the declared `sh` capability; the
surface itself requires a Bun-capable host (the repo's documented secondary
runtime — no non-Effigy Rhai host exists). The case-fold collision negative is
proven through the same fold-registration predicate the walker executes
because the host filesystem is case-insensitive. Arbitrary package code beyond
the declared self-check remains the card-118 canary boundary. No production
package was fetched, no language policy was added, and consumer activation was
not changed.

## PR

https://github.com/inflatable-cookie/northstar/pull/22 — opened for card
`g02.048/117` against `main` from
`worker/prove-generic-language-package-lifecycle`. Review head
`981db752e25486e453a72888dccff394aa115b3e` required changes; the repaired head
is pushed after this log with the full oracle and required validation rerun on
it. Exact-head re-review pending; do not merge.
