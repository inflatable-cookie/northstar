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
- Explicit language-workflow intent or an existing repository activation
  authorizes installation of a compatible official package from a pinned
  trusted source. Northstar shows a visible notice and continues without a
  confirmation pause.
- Third-party packages require an operator allowlist or explicit approval.
- A package owns its catalogue, projections, overlays, schemas, setup,
  recorder/tooling, fixtures, version, and distribution proof.
- Consumer repositories continue to own project profiles, toolchains,
  exclusions, deviations, architecture, and repair authority.
- Northstar core routes to an available compatible package and remains valid
  when none is installed.

## Initial Official Repository Topology

The initial official Rust and TypeScript packages share one sibling source
repository, provisionally `northstar-language-packs`. This is a source and
maintenance grouping, not the acquisition or activation unit.

Each language package has its own root, package identity, manifest, version,
core-compatibility range, integrity identity, release evidence, and installed
state. An acquisition request names exactly one package. Installing or
activating Rust must not install, expose, or load TypeScript or any later
sibling package. A source adapter may temporarily fetch the shared repository,
but the retained installed payload and runtime context contain only the named
package. A release adapter should publish independently addressable package
artifacts so repository growth does not make every consumer download every
language indefinitely.

The shared repository is an initial convenience, not a protocol constraint.
The manifest and discovery contract must also permit an official package to
move to its own repository and a third-party package to originate elsewhere
without changing Northstar core or consumer activation files.

## Official Acquisition And Notice

Northstar may acquire a missing official package only when the operator has
explicitly requested one of that package's workflows or the consumer
repository already carries a valid activation for it. Language, manifest,
framework, dependency, or source-file detection alone is not acquisition
authority.

For an eligible official package, core resolves one compatible package from
its trusted pinned registry entry, emits a visible notice naming the package,
version, source, target, and requested workflow, then continues without asking
for confirmation. Success emits the resolved installed identity before routing
into the package. Acquisition and activation are transactional: failure leaves
any prior compatible install and consumer files unchanged.

When no compatible installed package exists and official acquisition cannot
complete, only the requested language workflow stops. Northstar core remains
usable and reports the exact acquisition failure plus the manual or offline
installation route; it must not silently run a missing workflow, substitute a
different package, or infer permission for a third-party source.

Third-party acquisition always requires an operator allowlist entry or explicit
approval before any fetch or install. A visible notice is evidence of an
already-authorized official acquisition, not a substitute for third-party
approval.

## Update, Rollback, And Offline Behavior

Ordinary routing is local-only. When a compatible installed package exists,
Northstar uses it without checking a registry, querying a remote version, or
touching the network. A newer compatible release is advisory until the
operator explicitly requests an update.

Explicit update intent may acquire and activate a newer compatible official
package with the same visible-notice and transaction rules as first install.
The other automatic acquisition case is compatibility recovery: when an
explicitly requested workflow has no compatible installed package, Northstar
may acquire the core registry's pinned compatible choice and continue. An
installed but incompatible package is retained as evidence and possible input
to a later compatible core, but it is never routed into the current run.

Activation retains the previously selected compatible install until the new
package has passed manifest, integrity, compatibility, and package self-checks.
Rollback reselects that proven install without fetching. A failed update or
rollback leaves the current selection and consumer repository unchanged.

Offline use therefore needs no special mode when a compatible package is
already installed. Without one, the requested workflow stops with the exact
missing identity and a local-path installation route; core planning,
orchestration, review, and documentation workflows continue normally.

## Compatibility And Trust Questions

Planning must settle these before a roadmap becomes ready:

1. package identity, manifest, core-compatibility range, and independently
   addressable artifact shape;
2. official package discovery and pinned acquisition mechanism;
3. integrity and provenance evidence, plus the minimum package self-checks
   required before activation;
4. how package commands and modes register without editing or duplicating the
   root router;
5. third-party allowlist ownership and revocation;
6. migration of existing embedded Rust and TypeScript activations;
7. source/install parity and release ownership after extraction;
8. extraction order and the point at which embedded compatibility ends.

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
