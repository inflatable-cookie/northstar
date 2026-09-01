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

## Package Shape And Registration

Each language package is a normal independently installable skill bundle. Its
root contains the agent-facing `SKILL.md` plus a machine-readable
`northstar-package.json`. Package-specific instructions, catalogues, schemas,
profiles, templates, fixtures, tools, and optional Effigy catalog stay inside
that bundle; they do not enter the root Northstar payload.

The v1 manifest declares:

- schema version, stable namespaced package ID, package version, and package
  kind (`language-quality`);
- compatible Northstar core range;
- owned languages and optional framework overlays;
- available workflow entrypoints (`everyday-authoring` and/or
  `explicit-audit-and-repair`), without inventing unavailable projections;
- required runtime capabilities and optional Effigy selectors;
- package self-check entrypoint and the profile/schema versions it validates;
- optional evidence-provider capabilities, which remain subject to consumer
  profile activation and contract 004 authority.

Source, resolved revision or artifact digest, installation time, and trust
decision belong to the installer receipt rather than the package declaring its
own integrity. Activation requires the manifest, receipt, content identity,
core compatibility, entrypoints, and self-check to agree.

Core discovers packages through the host's available-skill catalogue or an
acquisition adapter's returned installed path. It reads the manifest before
loading package instructions. It does not scan arbitrary home-directory paths,
infer packages from names alone, or maintain a hard-coded router branch per
language. A generic language-package route selects a compatible manifest and
delegates to the declared workflow entrypoint. A package may expose thin command
skills for direct use, but those adapters point to the same package authority
and do not duplicate its rules.

When Effigy is available, core or a thin adapter may execute declared package
tasks through `effigy skill run --path <PACKAGE> ...` in the consumer context.
Effigy is an execution adapter, not package identity or discovery authority. A
package must declare any required runtime capability and stop that workflow
plainly when the host cannot provide it.

## Official Registry And Integrity

Northstar core ships a small official-package registry as its automatic
acquisition trust root. Each entry names the stable package ID, approved
version, official source repository and package subpath, exact immutable source
commit, expected package-tree digest, manifest digest, and compatible core
range. A branch, mutable tag, repository name, skill name, or package
self-assertion is never enough for no-prompt acquisition.

An acquisition adapter may fetch source or an independently published artifact,
but it must reconstruct and verify the same named package tree before install.
The package manifest must match the registry identity, version, compatibility,
and digests. Package self-checks run only after path-shape, content identity,
manifest, and compatibility checks have succeeded; code from an unverified
candidate does not execute.

The installation receipt records the registry entry version, resolved source
commit or artifact digest, verified package-tree and manifest digests, installed
path, acquisition adapter, and activation result. Selection rechecks the
installed manifest and content identity before routing, so later mutation,
truncation, or path replacement makes the package unavailable rather than
trusted by history.

A package release may advance independently in the sibling repository, but it
does not change the automatic-install default for an existing Northstar core.
Updating that default requires a reviewed Northstar registry change with the
new immutable identities and compatibility evidence. An operator may explicitly
approve a newer source outside the bundled registry; that is an explicit trust
decision and does not silently rewrite the official default.

## Third-Party Trust And Revocation

Third-party trust belongs to operator-owned machine or user configuration, not
the consumer repository. A repository activation, package manifest, dependency,
or profile may request a third-party package or evidence provider, but it cannot
authorize fetching or executing that content.

An allowlist entry binds a stable package ID to an exact source identity and
content or artifact digest, compatible core range, and optionally permitted
workflows or consumer scopes. An interactive approval applies to that exact
identity for one acquisition unless the operator explicitly persists it as an
allowlist entry. Approval of one version, source, or digest does not trust later
content automatically.

Revocation immediately removes the package from eligible discovery and blocks
future acquisition and execution. It does not silently delete retained package
bytes, receipts, audit evidence, or consumer configuration. A requested workflow
that names revoked content stops visibly and identifies the revocation record;
core remains usable. Packages cannot edit, extend, or override the allowlist,
and an official language package cannot transfer its own trust to a third-party
provider such as Sentrux.

## Compatibility And Trust Questions

Planning must settle these before a roadmap becomes ready:

1. migration of existing embedded Rust and TypeScript activations;
2. source/install parity and release ownership after extraction;
3. extraction order and the point at which embedded compatibility ends.

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
