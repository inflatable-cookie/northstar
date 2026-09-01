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
A focused checker (`effigy check:language-packages`) evaluates instances directly
against Draft 2020-12 schemas without handwritten mirroring, verifies schema mutation
discrimination, enforces exact SemVer numeric ranges and package-relative path
containment, validates all receipt trust and source variants, materializes addressed
packages into isolated staging, and falsifies 9 negative review-oracle invariants
(identity/digest-drift, self-authorizing trust, immutable hex commit sources, independent
addressing/staging, exact semver ranges, path traversal, malformed manifests, duplicate
registry entries, and ambiguous receipts).

## Changed surfaces (before/after)

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/packages/package-manifest.schema.json` | did not exist | JSON Schema Draft 2020-12 defining package manifest contract |
| `skills/northstar/references/packages/official-registry.schema.json` | did not exist | JSON Schema Draft 2020-12 defining official registry contract |
| `skills/northstar/references/packages/installation-receipt.schema.json` | did not exist | JSON Schema Draft 2020-12 defining installation receipt contract |
| `skills/northstar/references/packages/official-registry.json` | did not exist | Initial empty official registry document |
| `skills/northstar/assets/fixtures/language-packages/policy-free-fixture/` | did not exist | Policy-free fixture package with manifest and self-check |
| `skills/northstar/assets/fixtures/language-packages/negative/` | did not exist | Negative fixtures for self-authorizing, malformed, incompatible, path traversal, duplicate registry, and ambiguous receipt cases |
| `skills/northstar/assets/fixtures/language-packages/sibling-packages/` | did not exist | Sibling package fixtures for proving independent subpath inventories and staging materialization |
| `skills/northstar/scripts/check-language-packages.rhai` | did not exist | Focused validator for schemas, registry, receipt instances, SemVer, paths, staging materialization, 9 oracle invariants, schema mutation discrimination, and portability |
| `effigy.toml`, `skills/northstar/effigy.toml` | lacked `check:language-packages` | `check:language-packages` task declared and wired into `qa:docs` and `validate` |
| `scripts/lib/northstar-repo-contract-data.rhai`, `scripts/test-northstar-repo-contract.rhai` | lacked package schemas and check task | Required files and `qa:docs`/`validate` pins updated |
| `scripts/README.md` | lacked package contract docs | `check:language-packages` usage and assertions documented |
| `docs/roadmaps/g02/batch-cards/116-freeze-language-package-machine-contracts.md` | `ready` | `complete` with acceptance criteria and completion notes |

## Review oracle invariants falsified

| Invariant | Adversarial counterexample | Expected failure or stop point | Proof in `check-language-packages.rhai` |
| --- | --- | --- | --- |
| Identity precedes execution | Valid self-check script with tampered manifest digest | Reject before running self-check | `expect_digest_drift_failure` verifies digest mismatch causes execution failure |
| Official trust is core-owned | Package manifest self-asserts `official: true` or `trusted: true` | Validation rejects self-authorizing fields | `expect_manifest_rejection` with `self-authorizing-manifest` negative fixture |
| Sources are immutable | Registry entry specifies `main` branch or a tag rather than exact commit | Validation rejects non-hex or mutable source commits | `expect_registry_rejection` with mutable/tag registry entries |
| Packages are independent | Sibling packages share repository tree under distinct subpaths | Addressing one subpath materializes only its isolated inventory into staging; broad selection captures siblings | `test_independent_package_materialization` proves alpha/beta isolated staging and broad-selection capture |
| Core compatibility is exact | Package specifies incompatible numeric range (e.g. `>=0.10.0 <1.0.0` against core `0.2.0`) | Incompatible range rejected by numeric SemVer evaluation | `expect_compat_rejection` with `incompatible-range-lexicographical` fixture and boundary test suite |
| Path containment is strict | Manifest specifies `../` or absolute path in entrypoint or subpath | Validation rejects path as unsafe | `expect_manifest_rejection` with path-traversal and absolute-path fixtures |
| Malformed content rejected | Manifest lacks required fields or has invalid kind | Validation fails schema requirements | `expect_manifest_rejection` with missing-fields and invalid-kind fixtures |
| Duplicate entries rejected | Registry contains duplicate package id and version entry | Validation rejects duplicate registration | `expect_registry_rejection` with `duplicate-package-registry.json` |
| Ambiguous identities rejected | Receipt matches multiple trust/source variants or mixes properties | Validation rejects ambiguous oneOf match | `expect_receipt_rejection` with `ambiguous-trust-receipt` and `ambiguous-source-receipt` |
| Schema is authoritative | Schema `schema_version.const` mutated to `9.9.9` or pattern changed | Validation rejects fixture instance | `test_schema_mutation_discrimination` proves schema constraints govern instance results |
| Contract stays portable | Schemas hardcode LLM provider names or local paths | Portability scan fails | `scan_forbidden_dependencies` rejects provider strings in references |

## Validation

- `effigy check:language-packages` — pass (3 Draft 2020-12 schemas, schema-derived instance conformance across all variants, schema mutation proof, SemVer numeric ranges, path containment, trust/source receipt variants, deep policy-free proof, staged sibling isolation proof, 9 negative oracle invariants, portable contracts);
- `effigy check:skill-install skills/northstar` — pass (152 files in exact parity);
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
