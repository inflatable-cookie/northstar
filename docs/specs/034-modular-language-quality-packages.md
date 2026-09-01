# 034 - Modular Language Quality Packages

Status: active planning; not ready for implementation
Owner: repo maintainers
Created: 2026-09-01
Depends on: `docs/contracts/004-language-quality-pack.md`,
`docs/architecture/system-architecture.md`
Evidence: `docs/logs/2026-09/01-140857-close-live-dogfood-and-plan-reduction.md`

## Problem

Rust and TypeScript quality now carry catalogues, profiles, schemas, setup,
recorders, a Cargo-native engine, fixtures, evidence cohorts, and distribution
checks inside the root Northstar skill. They are useful, but their lifecycle and
maintenance tax are a separate product concern from the docs spine and general
planning/orchestration system.

Keeping every language implementation in the root payload makes Northstar
larger for operators who do not use those languages and makes adding more
languages scale the always-distributed surface indefinitely.

## Settled Product Boundary

- Northstar core remains general-purpose and usable without a language package.
- Core owns a small package-discovery, compatibility, trust, activation, and
  routing protocol. It does not own every language catalogue and engine.
- Rust and TypeScript become optional packages under that shared protocol.
- Language detection alone never installs a package.
- Explicit language-workflow intent or an existing repository activation may
  install a compatible official package from a pinned trusted source with a
  visible notice.
- Third-party packages require an operator allowlist or explicit approval.
- A package owns its catalogue, projections, overlays, schemas, setup,
  recorder/tooling, fixtures, version, and distribution proof.
- Consumer repositories continue to own project profiles, toolchains,
  exclusions, deviations, architecture, and repair authority.
- Northstar core routes to an available compatible package and remains valid
  when none is installed.

## Compatibility And Trust Questions

Planning must settle these before a roadmap becomes ready:

1. package identity, manifest, and core-compatibility range;
2. official package discovery and pinned acquisition mechanism;
3. integrity, provenance, update, rollback, and offline behavior;
4. how package commands and modes register without editing or duplicating the
   root router;
5. repository activation and visible install notice;
6. third-party allowlist ownership and revocation;
7. migration of existing embedded Rust and TypeScript activations;
8. source/install parity and release ownership after extraction;
9. extraction order and the point at which embedded compatibility ends.

Effigy catalog packs are a candidate transport, not a settled dependency. The
planning lane must compare them with a provider-neutral package contract before
choosing an implementation.

## Non-Goals

- no extraction during `g02.045`;
- no automatic package installation from file detection;
- no hard-coded local profile, checkout, harness, or package-manager rule;
- no weakening of contract 004's finding-first, authority, scope, or evidence
  boundaries;
- no requirement that third-party packages be trusted as official packages;
- no new language implementation before the package protocol is proven.

## Promotion Targets

Once the open questions are settled, promote the stable package boundary into:

- `docs/architecture/system-architecture.md`;
- `docs/contracts/004-language-quality-pack.md`;
- the core Northstar router and package registration contract;
- a separate g02 extraction roadmap with migration and rollback cards.

## Readiness Gate

This spec is deliberately not ready. Compile its roadmap only after card 113
closes and the operator has accepted a concrete package identity, acquisition,
compatibility, trust, and migration design.
