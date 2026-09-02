# 034 - Modular Language Quality Packages

Status: promoted; retained as planning history, not implementation authority
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

The initial official Rust and TypeScript packages share the public sibling
source repository `inflatable-cookie/northstar-language-packs`. This is a
source and maintenance grouping, not the acquisition or activation unit.

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

The first canary is `@northstar/typescript-quality` `0.1.0` at
`packages/typescript`, compatible with Northstar core `>=0.2.0 <1.0.0`. It
owns TypeScript plus the `base`, `svelte`, and `sveltekit` overlays and exposes
only `explicit_audit_repair`. Package maintainers own its source and release
evidence; Northstar maintainers review the immutable official-registry pin.

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
- package self-check entrypoint, explicit `direct` or `command` invocation,
  and the profile/schema versions it validates;
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

### Provider-neutral host protocol

`language-package-host.v1` is the operational boundary. It is a versioned JSON
request/result protocol implemented by the current harness or another host
adapter, not a requirement for a particular executable runtime. V1 operations
are `resolve`, `acquire_activate`, and `rollback`. Every request names a
caller-generated request ID, operation, explicit intent, package ID and
version, language, workflow, core version, optional consumer scope, and
operator-supplied state root. Every result echoes that request ID so persisted
or asynchronous request/result pairs fail closed when mixed. A host may add
adapter-private transport input outside the reusable message, but it cannot
turn detection into intent or consumer data into trust.

Results use `routed`, `activated`, `rolled_back`, or `stopped`; successful
results include the exact tree and manifest identities plus resolved path and
receipt identity when applicable, and every result includes the visible
operator notice. The host supplies catalogue discovery, exact byte/mode reads,
exclusive creation, atomic state replacement, acquisition, and process
execution. Capability absence is an explicit `stopped` result scoped to the
requested workflow. Effigy and Bun may provide adapters or reference proof,
but the protocol and installed package do not depend on either.

### Self-check invocation

`self_check.invocation` is a required tagged union:

- `{ "type": "direct" }` executes the verified package-relative entrypoint
  directly with `[package_root]`;
- `{ "type": "command", "command": "<name>" }` executes the named command
  with `[resolved_entrypoint, package_root]`. The command must appear exactly in
  `runtime_capabilities.required_commands`.

Both variants use the package root as working directory. There is no shell
interpolation, argument template, inferred runner, or meaning attached to the
order of `required_commands`. Missing capability, launch failure, or non-zero
exit stops before the candidate receipt can be selected. Hosts may capture
bounded stdout/stderr as evidence, but output cannot grant trust or change the
invocation contract.

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

### Canonical content identity

V1 digest values use `sha256:<64 lowercase hex>` with the prefix required. The
manifest digest is SHA-256 over the exact bytes of `northstar-package.json`.
The package-tree digest is SHA-256 over one deterministic stream of every
regular file below the package root, including the manifest. Files are ordered
by their package-relative UTF-8 path bytes. Each record is framed as:

```text
F\0<path-byte-length>\0<path>\0<executable:0|1>\0<content-byte-length>\0<content>
```

Decimal lengths contain ASCII digits without padding. Package paths use `/`,
the portable ASCII component grammar already used by package-relative
entrypoints, and no absolute, empty, `.`, or `..` component. Case-folded path
collisions are invalid. Directories are implicit; empty directories carry no
identity and packages must not depend on them. Symbolic links and special file
types are rejected rather than followed or normalized. The executable bit is
the only retained mode information. An adapter may use any transport, but it
must reconstruct this exact file inventory and digest before package code runs.

### Operator-owned lifecycle state

Package state never lives in a consumer repository. The host or acquisition
adapter supplies one operator-owned state root. Northstar does not invent a
global path when the host has not supplied one. Card 117 freezes two additional
schemas under `references/packages/`:

- `operator-trust.schema.json` contains exact allowlist entries and revocations.
  Each record binds package ID, version, source identity, tree and manifest
  digests, compatible core range, optional workflow/consumer scope, actor,
  timestamp, and reason. Revocation wins over official registry or allowlist
  trust for the same content identity.
- `lifecycle-state.schema.json` contains a monotonic state revision, immutable
  installed-receipt references, and at most one selected receipt per package
  ID. Each reference repeats package ID, version, tree digest, manifest digest,
  receipt digest, and resolved installed path so selection cannot rely on a
  mutable path or name alone.

Receipts are immutable, digest-addressed documents. Installation stages bytes
outside the selected set, validates path shape and both digests, checks trust
and compatibility, then runs the declared self-check. Only after every gate
passes may it write the receipt and atomically replace lifecycle state using
the observed state revision. A concurrent or ambiguous write retains both the
old selection and staged identity, then stops for a fresh read; it never retries
as a second installation. Rollback changes only the selected receipt after
revalidating retained bytes and current revocation state. Failed install,
update, activation, rollback, or state replacement leaves the prior selection
and consumer repository byte-identical.

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

## Extraction Order

Extraction proceeds in four ordered stages:

1. prove the core manifest, discovery, compatibility, trust, installation,
   activation, rollback, and generic routing protocol with a deliberately small
   fixture package that carries no production language policy;
2. extract the TypeScript/Svelte package first, preserving its explicit-audit-
   only workflow and conditional overlay boundaries. This is the package and
   acquisition canary because it has no everyday activation or compiled audit
   engine;
3. extract Rust after the TypeScript package boundary passes, then prove both
   everyday authoring and explicit audit plus the Cargo-native recorder and
   toolchain/runtime requirements;
4. remove each embedded implementation only after its independently installed
   package matches the frozen source behavior, consumer activation and profile
   compatibility pass, and rollback evidence exists.

The stages are not one combined migration. TypeScript extraction must settle
package-protocol findings before Rust copies that shape. No new language package
starts until both existing implementations are independently distributed and
the root payload no longer owns their policy or engines.

## Migration And Embedded Cutover

Each language gets one bounded overlap window. The external package is
published, pinned in the official registry, and made authoritative before the
embedded implementation is removed. During that window the embedded copy is
frozen: new rules, workflow behavior, tooling changes, and ordinary fixes land
in the package, not in two active implementations.

The generic core route prefers the verified installed package. If official
acquisition cannot complete during the overlap, core may use the frozen
embedded implementation only after a visible migration-fallback notice naming
the failed package identity and acquisition reason. It must not call that
fallback the package, update it independently, or hide that the external route
failed. An unsafe defect in the fallback pauses cutover planning rather than
creating an open-ended dual-maintenance promise.

The overlap-window registry is a schema-validated core machine contract. Each
open window binds one language to an exact package ID and version plus the
human-facing frozen-payload label. The fallback decision accepts only a
correlated `stopped` acquisition response for explicit workflow or activation
intent. Detection, a mismatched request ID, another package/version, a closed
window, or an unregistered language fails before the fallback notice.

Existing consumer activation markers, profile and deviation paths, rule IDs,
workflow intent, and evidence formats remain valid across extraction. Package
setup adopts those existing files without rewriting valid repository policy.
Thin language command adapters move with the package; the root generic route
continues to recognize ordinary language intent and existing activation without
carrying the language catalogue or engine.

The overlap closes only after exact source-to-package behavior reconciliation,
independent package install and self-check proof, installed routing, rollback,
offline fallback, current consumer activation, and one real consumer workflow
pass for that language. The following migration milestone removes the embedded
payload and its fallback in one change. From that point, a missing compatible
package stops only the requested language workflow under the normal package
contract.

## Release Ownership And Promotion

The language-package source repository owns each package's source, manifest,
self-check, package-scoped fixtures, independently addressable artifact,
content digest, changelog, and release evidence. Source-to-install parity is
proved per package; it is not the root Northstar skill's whole-payload parity
check and does not make unrelated sibling packages part of the release unit.

Northstar core owns the package-manifest schema, official registry entries,
generic resolver and installer behavior, core/package compatibility fixtures,
and consumer migration rules. A package release publishes an immutable
candidate first. A reviewed Northstar registry change then pins its exact
source and content identities and runs installation, self-check, compatibility,
and real-consumer proof. Registry merge makes that candidate the official
automatic choice for eligible workflows.

Neither source nor installed routing follows a moving branch or tag. A package
may publish without changing Northstar's default, and Northstar may continue to
pin an older compatible package until the registry review passes. Package and
core releases therefore remain independent while the registry change is the
explicit promotion boundary between them.

## Planning Status

The compatibility, trust, acquisition, update, rollback, offline, extraction,
cutover, and release-ownership questions are settled. This spec is ready to
promote into architecture and contract 004. It does not authorize package
implementation or roadmap dispatch before that promotion is complete.

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

## Promotion

The stable package topology, registration, ownership, release, and extraction
boundary is promoted into `docs/architecture/system-architecture.md`. Binding
acquisition, trust, compatibility, update, rollback, offline, release, and
migration behavior is promoted into
`docs/contracts/004-language-quality-pack.md`.

This spec remains the decision history behind those surfaces. It is not a
second authority for implementation. Roadmap
`docs/roadmaps/g02/048-extract-modular-language-quality-packages.md` sequences
the fixture protocol, TypeScript, Rust, and embedded-removal batches.

## Readiness Gate

The design gate is satisfied and card 113 is closed. Roadmap g02.048 is
compiled. Card 116 merged through PR 21; its readiness review promoted the
missing digest and lifecycle-state boundary. Card 117 proved the generic
lifecycle against the host-protocol and self-check invocation decisions
promoted here (byte-exact digest vectors, operator trust and lifecycle state,
the `language-package-host.v1` machine contract with operational entrypoints
from an installed skill, explicit self-check invocation, atomic CAS,
identity-bound routing, transactional acquire/update/rollback, offline
routing, revocable trust). PR 22 merged at `75db6f5`. Card 118's public source
repository is bootstrapped and its package-source worker is in flight against
the accepted protocol and settled first-canary identity; cards 119-120 remain
blocked behind their named dependencies and readiness refreshes.
