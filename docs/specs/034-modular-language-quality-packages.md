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

Effigy catalog packs were assessed as a candidate transport. The result below
keeps the language-package contract provider-neutral and outside that
service-catalog surface.

## Transport Assessment

Effigy's current catalog-pack surface is not the language-package transport.
It installs one active, independently versioned set of Effigy service-fragment
directories below project and user overrides. Its manifest cannot widen that
fragment schema, and its store selects one active pack rather than a set of
independent language extensions. Reusing it would couple Northstar packages to
the wrong content model and selection semantics.

`effigy skill run` is a useful optional execution adapter after a package path
has been resolved. It deliberately executes an operator-supplied skill path in
the context of a separate consumer repository; it does not discover, acquire,
activate, or update packages. Northstar's package contract therefore remains
provider-neutral. It may reuse proven digest, compatibility, transactional
activation, rollback, and offline principles, but it must not depend on the
Effigy service catalog-pack schema or require Effigy to be installed.

The unresolved transport choice is now narrower: define the package manifest
and installed-package discovery contract first, then let skills installers,
local paths, or a future digest-pinned artifact adapter implement acquisition.
Core routing must work with an already-installed compatible package even when
no acquisition adapter is available.

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
