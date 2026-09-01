# Freeze Language Package Machine Contracts

Date: 2026-09-01
Roadmap: `g02.048`
Card: `g02.048/116`
Status: complete; ready for review

## Result

Machine contracts for modular language quality packages are frozen, schema-validated,
and protected by focused negative fixtures and repo-contract checks. Northstar core
owns the provider-neutral manifest, official registry, and installation receipt
schemas, while language packages remain independently addressable units.

A policy-free fixture package (`@northstar/language-fixture`) proves the contract
structure without containing any production language rules, engines, or profiles.
A focused checker (`effigy check:language-packages`) validates schemas, registry
entries, receipt structures, semver core ranges, and falsifies all six review-oracle
invariants (identity precedes execution, core-owned trust, immutable hex commit sources,
independent package inventories, exact core compatibility, and portable contracts).

## Changed surfaces (before/after)

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/packages/package-manifest.schema.json` | did not exist | JSON Schema Draft 2020-12 defining package manifest contract |
| `skills/northstar/references/packages/official-registry.schema.json` | did not exist | JSON Schema Draft 2020-12 defining official registry contract |
| `skills/northstar/references/packages/installation-receipt.schema.json` | did not exist | JSON Schema Draft 2020-12 defining installation receipt contract |
| `skills/northstar/references/packages/official-registry.json` | did not exist | Initial empty official registry document |
| `skills/northstar/assets/fixtures/language-packages/policy-free-fixture/` | did not exist | Policy-free fixture package with manifest and self-check |
| `skills/northstar/assets/fixtures/language-packages/negative/` | did not exist | Negative fixtures for self-authorizing, malformed, and incompatible manifests |
| `skills/northstar/assets/fixtures/language-packages/sibling-packages/` | did not exist | Sibling package fixtures for proving independent subpath inventories |
| `skills/northstar/scripts/check-language-packages.rhai` | did not exist | Focused validator for schemas, registry, fixtures, oracle invariants, and portability |
| `effigy.toml`, `skills/northstar/effigy.toml` | lacked `check:language-packages` | `check:language-packages` task declared and wired into `qa:docs` and `validate` |
| `scripts/lib/northstar-repo-contract-data.rhai`, `scripts/test-northstar-repo-contract.rhai` | lacked package schemas and check task | Required files and `qa:docs`/`validate` pins updated |
| `scripts/README.md` | lacked package contract docs | `check:language-packages` usage and assertions documented |
| `docs/roadmaps/g02/batch-cards/116-freeze-language-package-machine-contracts.md` | `ready` | `complete` with acceptance criteria and completion notes |

## Six review oracle invariants falsified

| Invariant | Adversarial counterexample | Expected failure or stop point | Proof in `check-language-packages.rhai` |
| --- | --- | --- | --- |
| Identity precedes execution | Valid self-check script with tampered manifest digest | Reject before running self-check | `expect_digest_drift_failure` verifies digest mismatch causes execution failure |
| Official trust is core-owned | Package manifest self-asserts `official: true` or `trusted: true` | Validation rejects self-authorizing fields | `expect_manifest_rejection` with `self-authorizing-manifest` negative fixture |
| Sources are immutable | Registry entry specifies `main` branch or a tag rather than exact commit | Validation rejects non-hex or mutable source commits | `expect_registry_rejection` with mutable/tag registry entries |
| Packages are independent | Sibling packages share repository tree under distinct subpaths | Addressing one subpath returns only its isolated inventory; leakage rejected | `extract_addressed_package_inventory` + `verify_package_isolation` prove alpha/beta isolation and reject sibling payload leaks |
| Core compatibility is exact | Package specifies incompatible numeric range (e.g. `>=0.10.0 <1.0.0` against core `0.2.0`) | Incompatible range rejected by numeric SemVer evaluation | `expect_compat_rejection` with `incompatible-range-lexicographical` fixture and boundary test suite |
| Contract stays portable | Schemas hardcode LLM provider names or local paths | Portability scan fails | `scan_forbidden_dependencies` rejects provider strings in references |

## Validation

- `effigy check:language-packages` — pass (3 Draft 2020-12 schemas, schema-derived instance conformance across all variants, SemVer numeric ranges, path containment, trust/source receipt variants, deep policy-free proof, sibling isolation proof, 7 negative oracle invariants, portable contracts);
- `effigy check:skill-install skills/northstar` — pass (146 files in exact parity);
- `effigy qa:docs` — pass (repo contract, readiness map, command skills, model routing, and language packages);
- `effigy validate` — pass;
- `effigy qa` — pass;
- `git diff --check` — clean (zero whitespace errors).

## Limits

This card freezes schemas and validates them against the policy-free fixture and negative suite.
It does not implement package installation adapters, runtime activation, language routing,
or extraction of TypeScript/Rust into independent packages (which belong to cards 117-120).

## PR

https://github.com/inflatable-cookie/northstar/pull/21 — opened for card `g02.048/116`
with exact-head review pending.
