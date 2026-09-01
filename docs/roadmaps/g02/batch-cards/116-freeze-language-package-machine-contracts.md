# 116 - Freeze Language Package Machine Contracts

Status: complete
Owner: repo maintainers
Updated: 2026-09-01
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`
Auto-start next card: no

## Ready-State Checks

- [x] objective is bounded to schemas, a policy-free fixture, validation, and
  planning closeout;
- [x] architecture and contract 004 own every package field and trust boundary;
- [x] paths, negative cases, validation, evidence, and stop conditions are
  explicit;
- [x] the review oracle covers identity, compatibility, independence, and
  portability;
- [x] no open spec 034 decision governs this card;
- [x] no other worker owns the package-protocol or language-quality surfaces.

## Objective

Freeze and validate the provider-neutral machine contracts that later cards
must implement, using one deliberately policy-free fixture package.

## Lane Runway Context

- Higher-level lane owner: g02.048 modular language-package extraction.
- Next likely cards: 117 generic lifecycle proof, then 118 TypeScript canary.
- Next planning checkpoint: refresh card 117 against the merged schema and
  fixture identities before dispatch.

## Scope

- add versioned package-manifest, official-registry, and installation-receipt
  schemas under `skills/northstar/references/packages/`;
- add an empty or non-authorizing initial official registry whose structure can
  pin exact repo, subpath, commit/tree, manifest digest, and core range;
- add a policy-free fixture skill package under
  `skills/northstar/assets/fixtures/language-packages/` with no Rust or
  TypeScript catalogue content;
- add focused validation and negative fixtures for malformed, mutable,
  incompatible, ambiguous, cross-package, and self-authorizing identities;
- wire the focused check into docs QA and installed-skill parity;
- update card, roadmap, front doors, and closeout evidence.

Do not implement remote acquisition, production activation, language routing,
TypeScript/Rust extraction, or execute fixture package code before identity and
compatibility validation succeeds.

## Steps

1. Inventory current core version identity, skill layout, schema conventions,
   and installed-parity boundaries.
2. Add the three schemas and minimal official-registry document.
3. Add one independently addressable fixture package and its manifest.
4. Implement a read-only checker that validates schemas, exact identities,
   package independence, and the negative fixture set.
5. Prove source/install parity includes the generic contracts and only the
   named fixture payload when addressed independently.
6. Reconcile planning and open a reviewable PR.

## Acceptance Criteria

- [x] manifest covers every promoted contract field without provider-specific
  acquisition configuration;
- [x] registry and receipt distinguish source, content, manifest, trust, and
  compatibility identities;
- [x] package self-claims cannot grant official or third-party trust;
- [x] fixture has no production language rules, profiles, overlays, or engines;
- [x] one package can be addressed without retaining sibling payloads;
- [x] malformed, mutable, incompatible, duplicate, ambiguous, and digest-drift
  fixtures fail before executable package content is consulted;
- [x] schema/check surfaces are present in the installed Northstar skill;
- [x] focused checks, docs QA, full QA, parity, and `git diff --check` pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Identity precedes execution. | Fixture manifest contains a valid self-check but its digest is wrong. | Reject before resolving or running self-check. | Side-effect-free negative fixture. |
| Official trust is core-owned. | Package manifest calls itself official. | Schema rejection or ignored non-authoritative field; never trusted. | Self-authorization negative case. |
| Sources are immutable. | Registry entry names `main`, a tag, or lacks content identity. | Registry validation fails. | Mutable-source fixtures. |
| Packages are independent. | Fixture shares a source tree with a second package. | Addressing the fixture yields only its subpath and identity. | Two-package inventory fixture. |
| Core compatibility is exact. | Package range excludes the current core or is malformed. | Reject as incompatible without mutation. | Boundary range fixtures. |
| Contract stays portable. | Schema or checker requires Effigy, Paseo, a local path, or provider name. | Focused check fails. | Forbidden-dependency scan. |

## Evidence Required

- before/after inventory of schemas, package surfaces, and parity paths;
- positive schema validation plus every named negative fixture;
- proof that invalid content creates no receipt, activation, or side effect;
- `effigy check:skill-install` against an isolated install;
- focused package-contract check, `effigy qa:docs`, `effigy qa`, and
  `git diff --check`;
- closeout log, reviewable PR, exact tested head, and known limits.

## Continuation Envelope

- Auto-start next card: no.
- In-bounds next card: 117 after review, merge, and readiness refresh.
- Remaining ready chain after this card: 0.
- Transition proof: merged schemas, fixture identities, parity, and focused
  negative suite.

## Lane Budget

- Current card ends budgeted run: yes.
- Further operator decision required after this card: no unless implementation
  exposes a contract gap.
- Pause signal if run stops here: lane-complete.

## Stop Conditions

- a required manifest field is not settled by architecture or contract 004;
- a schema choice would bind core to one package host or control plane;
- official trust cannot be separated from package-controlled content;
- an executable fixture is required before identity validation;
- validation changes the plan.

## Completion Notes

Completed and repaired machine contracts for modular language quality packages (g02.048/116):
- Added `skills/northstar/references/packages/package-manifest.schema.json`, `official-registry.schema.json`, `installation-receipt.schema.json` (JSON Schema Draft 2020-12 dialect) and initial `official-registry.json`.
- Implemented an iterative bounded schema validation engine evaluating the frozen contract vocabulary directly from disk and recursively failing closed on any unsupported schema keywords.
- Added schema mutation discrimination proofs verifying that modifying supported schema constraints (such as `schema_version.const` to `9.9.9` or `package_id.pattern`) rejects instances and introducing unsupported keywords (such as `maxLength`) fails closed.
- Implemented exact SemVer parsing and numeric range evaluation, supporting exact, caret, bounded, and open ranges while rejecting lexicographical comparison flaws.
- Frozen package-relative path containment grammar and enforced strict rejection of directory traversal (`..`), empty segments, and absolute paths in schemas and runtime checks.
- Modeled explicit receipt trust variants (`official`, `operator_allowlist`, `interactive_approval`) and source variants (`git`, `local_path`, `archive`), proving required and forbidden field combinations while preserving exact content identities (`package_tree_digest`, `manifest_digest`).
- Added deep recursive policy-free fixture verification across all files and directories for zero production language rules, catalogues, profiles, or engines.
- Proved independent package addressing and payload materialization into isolated staging from multi-package repository sources, verifying clean single-package inventories and negative multi-package leakage rejection.
- Implemented mandatory negative review-oracle suite with explicit discrimination assertions for all 9 invariants (identity/digest-drift, self-authorizing trust, immutable sources, independent addressing/staging, exact semver ranges, path traversal, malformed manifests, duplicate registry packages, and ambiguous receipts).
- Wired `check:language-packages` into root and skill `effigy.toml`, `qa:docs`, `validate`, and repo contract checks.
- Validated with `effigy check:language-packages`, `effigy check:skill-install`, `effigy qa:docs`, `effigy qa`, and `git diff --check`.

## Next Task

Stop for exact-head review. After merge, refresh card 117 against the shipped
machine contracts; do not infer runtime behavior from draft schemas.
