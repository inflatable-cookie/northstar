# 004 - Language Quality Pack

Status: active
Owner: repo maintainers
Updated: 2026-09-02
Depends on: `docs/contracts/001-working-rules.md`,
`docs/contracts/003-agent-instruction-surface.md`
Affects: Northstar package discovery and installation, language-quality
catalogues, scoped authoring skills, explicit audit skills or commands, Effigy
selectors, consumer quality profiles, findings, deviations, and completion
evidence

## Purpose

A language quality pack raises code quality through two workflows backed by one
source of truth: compact guidance during normal coding and an explicitly
requested audit-and-repair pass. This contract keeps those workflows aligned,
keeps contextual judgment reviewable, and prevents a detector or style
preference from becoming unsupervised rewrite authority.

The first pack is Rust. Its initial production-valid profile is `strict`.
Ordinary and high-assurance profiles remain modelled catalogue inputs, not
validated production claims. The initial TypeScript catalogue is also strict,
but only its explicit audit-and-repair workflow is eligible for production
implementation. TypeScript everyday authoring remains unavailable.

## Package identity and ownership

A language quality package is an independently installable skill bundle. It
contains `SKILL.md` and `northstar-package.json`; the manifest declares a
versioned schema, stable namespaced package ID, package version, kind
`language-quality`, compatible Northstar core range, supported languages and
overlays, available workflows, runtime capabilities and optional Effigy
selectors, self-check, profile and schema versions, and optional evidence
providers.

The package owns its catalogue, projections, overlays, schemas, setup,
recorder or other tooling, fixtures, self-check, version, release evidence,
and installed payload. Northstar core owns the manifest schema, official
registry, generic discovery/resolver/installer behavior, compatibility
fixtures, and migration rules. Consumer repositories continue to own their
profiles, deviations, toolchains, exclusions, architecture, and repair
authority.

Repository grouping is not package identity. Multiple official packages may
share one source repository, but each has an independent manifest, version,
artifact, digest, receipt, installation, activation, and release. Acquiring one
must not install or load unrelated siblings. Core routing is generic over
package kind, language, workflow, and compatibility; adding a language must not
require a language-specific core router branch.

## Discovery, acquisition, and trust

Core discovers installed packages from the host's available-skill catalogue or
an acquisition adapter's resolved installed path. An installed compatible
package must remain routable without Effigy or any acquisition adapter.
`effigy skill run` may execute a resolved package in a consumer repo, but the
Effigy service catalog is not the package transport or trust authority.

Core exposes package lifecycle behavior through the provider-neutral
`language-package-host.v1` request/result protocol. It does not require Bun,
Node, Python, POSIX shell, Effigy, or a provider runtime. A conforming host maps
its native catalogue, filesystem identity, atomic state, acquisition, and
process capabilities onto resolve, acquire-and-activate, and rollback
operations. Requests carry explicit intent, package ID/version, language,
workflow, core version, optional consumer scope, and the host-supplied
operator-state root. Results carry `routed`, `activated`, `rolled-back`, or
`stopped`, the exact selected identity and resolved path/receipt when relevant,
and the visible notice. Missing host capability stops only the requested
package workflow and never authorizes a fallback runtime or acquisition.

Language, framework, dependency, manifest, or source-file detection alone does
not authorize acquisition. An explicit request for a package workflow or an
existing valid consumer activation authorizes installation of a missing
compatible official package. Core emits a visible notice naming package,
version, source, target, and workflow, then continues without a confirmation
pause. Failure stops only that language workflow and reports a manual or local
installation route; other Northstar workflows remain usable.

Core's official registry binds an approved package ID and version to an exact
repository and subpath, immutable commit and tree digest, manifest digest, and
compatible core range. Installation verifies these identities before package
code or self-check execution, records them in a receipt, and re-verifies the
installed content before routing. Mutable branches and tags, names alone,
package self-claims, and unpublished registry choices cannot authorize
no-prompt installation.

The manifest declares self-check invocation explicitly. `direct` executes the
verified package-relative entrypoint with one argument, the package root.
`command` names a command that must also appear in
`runtime_capabilities.required_commands` and executes fixed arguments
`[entrypoint, package_root]`. The package root is the working directory in both
cases. Hosts do not infer a runner from capability-list order, interpolate a
shell command, or add arguments. Launch failure or non-zero exit fails the
candidate before receipt selection.

V1 content digests are required `sha256:<64 lowercase hex>` values. Manifest
identity hashes the exact manifest bytes. Tree identity hashes the canonical
sorted, length-framed regular-file stream defined by spec 034, including paths,
the executable bit, and file bytes. Package paths must be portable and
contained; case-fold collisions, symlinks, special files, and implicit empty
directory dependencies are invalid. Every acquisition adapter must reconstruct
the same identity before package code executes.

Third-party packages require either an exact operator allowlist entry or
interactive approval for one acquisition. The allowlist lives in machine or
user operator configuration; a consumer repo or package may request trust but
cannot grant it. Entries bind identity, digest, and core range and may narrow
workflows or consumers. Revocation immediately blocks discovery, acquisition,
and execution while retaining bytes, receipts, evidence, and consumer config.
A package cannot extend the allowlist or transfer its trust to an evidence
provider.

Trust and lifecycle state live under a host-supplied operator-owned root, never
in a consumer repository. Core owns schemas for exact allowlist/revocation
records and for a revisioned lifecycle index. Receipts are immutable and
digest-addressed; the index names retained receipts and at most one selected
receipt per package. Revocation outranks registry and allowlist trust. A path,
skill name, or previous selection without matching receipt and content identity
is not routable.

## Updates, rollback, and offline use

Ordinary routing is local-only. A compatible installed package is used without
a network or registry check. Updates require explicit operator intent. The
other automatic acquisition case is compatibility recovery after an explicit
workflow request finds no compatible installed package; it uses the registry's
pinned choice under the same notice and verification rules.

Activation is transactional and retains the previous compatible install until
manifest, integrity, compatibility, and self-check gates pass. Failed installs,
updates, and rollbacks leave the current selection and consumer files
unchanged. Rollback reselects a retained proven install without fetching.
Offline workflows use an installed compatible package normally; without one,
only the requested language workflow stops and names the local-path install
route.

State replacement is atomic against the observed lifecycle revision. A stale,
concurrent, or ambiguous write retains the prior selection and staged identity,
then stops for a fresh read rather than creating or selecting a duplicate.
Rollback rechecks retained bytes, receipt identity, compatibility, and current
revocation before changing only the selected receipt.

## Release and embedded migration

Package source owners publish an immutable candidate with package-scoped
source/install parity, artifact digest, self-check, changelog, and release
evidence. A reviewed Northstar registry change pins that candidate and runs
installation, compatibility, and real-consumer proof. Registry merge, not
publication alone, makes it the official automatic choice. No release or route
depends on a moving branch or tag, and root whole-payload parity is not a
substitute for package-scoped parity.

Rust and TypeScript extraction each receive one bounded overlap window. The
external package is authoritative once published and pinned; the embedded copy
is frozen, receives no ordinary fixes or new rules, and may run only after a
visible migration-fallback notice when official acquisition fails. Existing
activation markers, profiles, deviations, rule IDs, workflow intent, and
evidence formats remain valid and are not rewritten merely because ownership
moves.

The overlap closes only after exact parity, independent install and self-check,
installed routing, rollback, offline fallback, current consumer activation,
and one real consumer workflow pass. The following migration milestone removes
the embedded payload and fallback together. An unsafe fallback defect pauses
the cutover rather than creating indefinite dual maintenance. TypeScript
extraction proves the protocol before Rust copies it; no new language begins
until both embedded implementations have been removed from core.

## Stable workflow names and triggers

The two contract-level workflow names are:

- **everyday authoring**: activates when an agent writes, reviews, or refactors
  in-scope language code. It is normal coding guidance, not permission to audit
  or rewrite the wider repository.
- **explicit audit-and-repair**: activates only when the operator explicitly
  requests a quality audit, no-slop pass, or equivalent audit-and-fix action.
  The request must identify or permit resolution of worktree or repository
  scope.

A product may expose a thin command adapter, but command spelling is an
implementation detail. It must route to these workflows without creating a
third standard or making explicit audit implicit.

Workflow availability is evidence-gated per language pack. A pack may validate
and expose one workflow while the other remains unavailable; it must report
that split plainly and must not synthesize the unavailable projection from the
shared catalogue. The initial TypeScript pack follows this partial boundary.

## One catalogue, projected views

Each pack has one versioned rule catalogue. Everyday instructions, audit
procedures, mechanical checks, and completion reporting are generated from or
mechanically checked against that catalogue. Hand-maintained parallel rule
lists are forbidden.

Every rule record must carry:

- a stable rule ID, concern, category, applicability, and lifecycle maturity;
- profile-specific enforcement level;
- source provenance and the pinned source revision where available;
- a compact authoring projection and a deliberate audit procedure;
- named mechanical evidence, when any tool can contribute it;
- default remediation authority plus action-specific overrides;
- deviation requirements and completion evidence.

Enforcement levels mean:

- `mandatory`: assess whenever applicable and never silently waive a finding;
  record the effective remediation disposition even when authority is
  report-only;
- `required`: comply or record an accepted, evidenced deviation;
- `evaluation_only`: report and measure only; it cannot fail the workflow or
  authorize mutation.

Lifecycle maturity and enforcement are separate. Only approved normative
rules may fail a production workflow. Prototype or experimental records may
contribute evaluation-only candidates.

## Conditional framework overlays

A language pack may contain framework overlays when framework semantics add
rules to the owning language. An overlay stays in the same versioned catalogue
or a mechanically checked catalogue extension. It uses the same profile,
finding, authority, deviation, evidence, and workflow contracts as the base
language. It does not create a separate top-level skill or audit command unless
its lifecycle and authority genuinely differ.

Activation is evidence-based and scoped. Repository-owned signals identify the
framework and version; file and package ownership identify where its rules
apply. Dependency presence alone is insufficient for an application overlay:
an owned semantic surface such as framework source, routes, hooks, or server
modules must also establish applicability. Root or declared-workspace ownership
must prevent ancestor configs from leaking rules into fixtures, documentation
examples, generated output, or vendored resources. Unregistered nested packages
are reported for policy resolution, not silently included or discarded.

An overlay may tighten a base rule or add a framework concern, but it must not
silently replace or weaken an applicable base mandatory rule. Framework presets
and third-party detectors are evidence inputs, not catalogue authority.

The repository owns framework-version policy. A pack must distinguish versions
whose semantics differ and must not force a migration to make a rule apply.
Adding or upgrading a framework, compiler, runtime, module mode, or strictness
policy requires operator authority unless the repository has already recorded
that decision.

The TypeScript pack follows this shape: Svelte is a conditional
TypeScript overlay and SvelteKit is its narrower server/application overlay.
Visual-design or copy-quality standards are outside this coding-quality
boundary. Overlay activation remains package- and path-scoped even though the
initial production workflow is explicit audit only.

## Initial Rust strict catalogue

The first production-valid Rust catalogue contains six approved normative
rules and one experimental input:

| Rule | Strict level | Default remediation authority |
| --- | --- | --- |
| `RUST-READ-001` | required | `review_required` |
| `RUST-API-001` | required | `review_required` |
| `RUST-ERR-001` | required | `review_required` |
| `RUST-UNSAFE-001` | mandatory | `report_only` |
| `RUST-ASYNC-001` | mandatory | `review_required` |
| `RUST-MSRV-001` | required | `review_required` |
| `RUST-SLOP-001` | evaluation only | `report_only` |

`RUST-ERR-001` keeps `review_required` as its default. Defining or changing
foreign error signaling, sentinel values, out-parameters, callbacks, or ABI
status semantics uses action `change_foreign_error_policy` and requires
`operator_decision`.

`RUST-MSRV-001` permits a reviewed, behaviorally equivalent replacement that
supports the repository-declared MSRV. Raising `rust-version`, changing the
edition or toolchain policy, dropping supported compilers, or otherwise
changing compatibility policy requires `operator_decision`.

`RUST-SLOP-001` never supplies independent repair authority. Code it flags may
change only when a separate approved normative rule establishes an actionable
violation and supplies the applicable authority.

Strict unsafe and FFI findings are mandatory to assess and report but remain
report-only. This contract does not activate high-assurance unsafe repair.

The Rust 1.95 benchmark floor is evidence infrastructure, not a Northstar MSRV.
The consumer repository owns its declared compiler floor.

Revision-E production evidence validates the v2 explicit-audit lifecycle across
worktree and repository scope, a nested mixed workspace, degraded evidence,
authorized repair, retained report-only work, and blind review. This validates
the frozen payload for distribution; it does not turn tool evidence into a
certification claim or expand audit authority.

The v2 detector ledger qualifies exact upstream diagnostics as enforcement or
evidence signals only under these existing rules. It adds no normative rule.
Unsafe structure and await-held guards are enforcement signals; public
`Debug`, incompatible MSRV items, and broken rustdoc links are evidence
signals. Contextual panic, cancellation, documentation, testing, architecture,
complexity, residue, and unfinished-code concerns remain evaluation-only,
manual, or rejected as recorded in the checked ledger. Diagnostic output never
creates a finding, plan, deviation, or repair authority.

## Initial TypeScript strict explicit-audit catalogue

The first promoted TypeScript catalogue contains nine normative rules and one
experimental input. It is valid only for explicit audit-and-repair:

| Rule | Overlay | Strict level | Default remediation authority |
| --- | --- | --- | --- |
| `TS-READ-001` | base | required | `review_required` |
| `TS-EVIDENCE-001` | base | mandatory | `review_required` |
| `TS-BOUNDARY-001` | base | mandatory | `review_required` |
| `TS-ASYNC-001` | base | mandatory | `review_required` |
| `TS-ERR-001` | base | required | `review_required` |
| `TS-ARCH-001` | base | required | `review_required` |
| `SVELTE-REACT-001` | Svelte | required | `review_required` |
| `SVELTE-A11Y-001` | Svelte | mandatory | `review_required` |
| `SVELTE-SSR-001` | SvelteKit | mandatory | `review_required` |
| `TS-SLOP-001` | base | evaluation only | `report_only` |

`TS-SLOP-001` never authorizes mutation. It may corroborate an independently
actionable normative finding but cannot fail an audit by itself. Production
evidence records its candidate identity and count as measurement only; no
expected candidate count is a conformance gate. Unknown evaluation rules and
mutation justified only by an evaluation signal remain invalid.

Repository-scope evidence distinguishes discovery-time inputs, generated audit
outputs, and tool runtime state. Every discovered input needs exact unit
ownership. A generated required output may be included when it exists at
recorder initialization, but its creation order cannot decide conformance.
Finalized audit records remain evidence; disposable graph and diagnostic-report
state does not enter the consumer file-set claim.

`TS-TOOLCHAIN-001`, `TS-TEST-001`, and `SVELTE-TEST-001` remain research
candidates. Source-only review could not determine them without owning package,
runtime, and test context. Production catalogues and projections must omit them
until package-backed evidence earns separate promotion.

The research cohort validates finding precision and bounded repair for the nine
normative source-local rules. Revision S separately validates the copied
production payload across three isolated subjects and blind reviewers. Exact
93-file source/install parity validates distribution of that payload. Neither
cohort validates everyday authoring, package-manager portability, or the
deferred toolchain and testing rules.

## Profile resolution

The consumer repository owns its selected profile. The initial Rust pack and
TypeScript explicit-audit pack expose only `strict` as production-valid, so
activation must resolve visibly to `strict` or stop on an unsupported
selection. It must not silently downgrade
to ordinary, upgrade to high assurance, or infer a different profile from the
workflow.

Activating ordinary or high assurance requires its own contract-backed evidence
and catalogue promotion. High assurance also needs risk-selected verification,
traceability, independent review, and pinned operation contracts; stricter
wording or more lints is insufficient.

## Agent-owned activation

Repository activation is part of the installed language pack, not a manual
operator installation procedure. When Northstar is requested for in-scope
language work and the scoped instruction block, profile, or deviations file is
missing, the agent runs that pack's skill-local setup task before editing or
auditing code.

Setup must be deterministic and idempotent. It discovers language packages,
framework overlays, and explicit toolchain files, appends a marked compact
activation block at the narrowest owning scope without overwriting existing
instructions, creates only missing contract files, and preserves an existing
valid profile or deviations file byte-for-byte. It fails closed on conflicting
or malformed existing setup. The Rust implementation discovers Cargo manifests
and explicit Rust toolchain files; later packs need equivalent evidence for
their ecosystems rather than assuming source lives at repository root.

Automation does not transfer repository policy ownership to Northstar. The
agent asks the operator only when policy cannot be recovered from the
repository, such as an undeclared effective MSRV or an uncertain generated or
vendored exclusion. It must not ask the operator to copy templates or fill
mechanically discoverable paths.

## Scope resolution

Worktree scope includes staged, unstaged, and relevant untracked language
source, manifests, build files, tests, and documentation relative to `HEAD`.
Repair may extend only to direct callers, tests, documentation, or contracts
needed to keep an in-scope correction coherent. Every extension is reported.

Repository scope includes every in-scope package, target, feature surface,
public API, and risk-bearing boundary. Generated and vendored code is excluded
only by explicit repository policy.

Both workflows preserve dirty user state. They must not clean, reset, discard,
or overwrite unrelated work. A repository-wide request does not authorize a
blanket rewrite, unrelated formatting, blanket automatic fixing, a breaking
interface change, or architecture replacement based on taste.

Worktree resolution must be anchor-based. Every initial assessment file is a
dirty language file or names its exact dirty anchor and direct relation, such
as owning manifest, caller, implementation, focused test, or governed
documentation. Read-only context is distinct from mutable ownership. If no
relevant dirty language anchor exists, the agent asks whether repository scope
is intended; it must not silently turn a worktree request into a repository
audit. Only repository scope may claim full package, target, feature, API, and
risk-boundary coverage.

## Everyday authoring

Everyday authoring uses a compact path-scoped projection. It re-enters at task
start and again at coherent batch closeout. Detailed rule references load only
for applicable domains.

The closeout check covers the changed tranche and its direct correctness
surface. It records applicable rules, unresolved findings or deviations, and
repository-native validation. It does not scan or mutate unrelated code merely
because the repository contains more Rust.

## Explicit audit-and-repair

Explicit audit first resolves scope and snapshots existing dirty state. It then
runs distinct correctness and assurance, architecture, and human-quality
passes. Mechanical tools provide evidence; they do not replace source review.

Every assessed unit records exactly one verdict for every applicable normative
rule: `pass`, `finding`, `not_applicable`, or `degraded`. A verdict names the
inspected surfaces and concise evidence. `not_applicable` binds the catalogue's
applicability condition; `degraded` names missing evidence and blocks a clean
claim for that rule. A finding verdict links the unit-local finding and its
disposition. Finalization rejects missing, duplicate, contradictory, or
evidence-free verdicts.

Each unit also records non-empty attestations for correctness and assurance,
architecture, and human quality. These are proof of the required passes, not a
second rule catalogue. A mechanical command may support an attestation but
cannot replace source or direct-call-path evidence where the applicable rule
requires judgment.

Mechanical evidence records the owning selector, actual execution environment,
exit status, warnings, and startup or collection failures. A zero exit status
with applicable warnings is not clean evidence. A routing, configuration, or
runner-startup failure is unavailable evidence, not a source pass or source
failure. Compiler, framework checker, lint, and tests remain distinct evidence
classes; one does not silently substitute for another.

Findings are recorded before mutation. Repair proceeds in coherent, reviewable
waves. Each wave stays within the finding's authority, preserves protected
behavior, and validates before the next wave. Missing external error policy,
breaking API decisions, compatibility-policy changes, and unauthorized
architecture decisions stop for the operator.

Audit result construction must be deterministic and case-local: each assessed
unit owns its findings, repair disposition, changed files, and changed-line
evidence. Final assembly derives aggregate scope from those local records and
rejects cross-unit evidence, unattributed mutation, applied repair on an
unchanged unit, or mutation without local repair authority.

## Findings, remediation, and deviations

Every finding must record:

- rule ID and lifecycle maturity;
- severity or enforcement level and confidence;
- exact file plus owning symbol or accepted line span;
- concise evidence and disposition;
- effective remediation authority, including the matched action override;
- changed scope and validation evidence when repaired.

Authority values mean:

- `report_only`: classify and explain; do not mutate for this rule;
- `review_required`: a bounded repair is allowed when the agent can show the
  rule, evidence, preserved behavior, and reviewable diff; an auditor may retain
  the finding as `reported` without a plan or mutation when repair or proof is
  unavailable;
- `operator_decision`: stop before mutation and present the decision and impact.

An action-specific override wins over a rule's default authority. No tool,
detector, profile, or audit request may broaden that authority silently.

A deviation records the rule, exact scope, reason, evidence, accepting owner,
and expiry or recheck trigger. Suppression without that record is not a
deviation. Repository policy may be stricter but may not silently weaken a
mandatory Northstar boundary.

## Ownership boundary

- Northstar owns the reusable schema, catalogue provenance, workflow contract,
  profile model, deviation shape, and copy-ready integration.
- Effigy resolves scope and orchestrates repository-native tasks. It is not a
  second rule authority.
- The consumer repository owns profile selection, MSRV and toolchain,
  generated/vendor exclusions, project architecture, and accepted deviations.
- The agent applies the effective rules, preserves current work, records
  judgment, and stops when repair needs authority it does not hold.

## Completion evidence and claims

A passing result names workflow, profile, resolved scope, catalogue version or
hash, findings and dispositions, deviations, changed scope, repository-native
validation, and remaining limitations. Explicit audit also reports scope
widening, preservation, and repair waves.

Remaining limitations are structured evidence, not summary-only prose. They
include degraded rule verdicts, report-only or retained findings, unresolved
policy, operator decisions, unavailable external services, and unrun applicable
selectors. The human report may compress that list but must not add or omit a
material limitation. A completed audit with degraded evidence may still report
bounded repairs; it cannot call the degraded rule or affected scope clean.

Candidate promotion evidence keeps subject, coordinator answer key, and blind
reviewer surfaces separate through enforced filesystem, container, or remote
workspace isolation. A fresh context governed only by instructions is useful
rehearsal, not independent evidence. Reviewers do not score their own work or
see track identity, rule IDs, expected dispositions, references, or prior
scores before returning their review.

Finding precision and repair quality are separate gates. A finding may enter
independent disposition from an isolated source specimen. A repair trial also
requires explicit protected behaviour, sufficient package or framework
context, repository-owned validation, bounded change scope, recorded authority,
and a blind baseline-versus-repair review. A cosmetic snippet rewrite without
those conditions is not repair evidence.

Production audit scoring is defect-first when approved partially decidable
rules overlap. The frozen answer key names required primary rule/file findings
and may name optional same-file corroborating rules with explicit primary
prerequisites. A pass requires every primary finding, rejects every finding
outside those two sets, and never allows corroboration to replace primary
recall, widen repair authority, or weaken locality and preservation gates.

The initial Rust evidence validates strict everyday authoring and strict
explicit audit separately. TypeScript revision S validates only the nine-rule
strict explicit repair surface, and the 93-file install matches that evidenced
payload. Neither evidence set validates the combined workflow as the
default, observable context-compaction resilience, ordinary or high-assurance
activation, certification, NASA compliance, a safety-integrity level, or a
safety case.

Convergence live use validates that v1 can find and repair feature compilation
and public-API defects. It does not validate repository-wide recall: the record
had no rule-by-rule or review-dimension attestations and silently widened a
`worktree` scope to 174 files. Revision E supplies the required fresh v2
evidence for anchor-based scope and complete unit-rule attestations, and the
exact 120-file payload is now distributed to the configured install. Candidate
panic/invariant, cancellation, documentation, testing, architecture/cohesion,
and complexity rules remain research-only until their own precision, repair,
preservation, and blind-review gates pass.

Production implementation requires roadmap cards derived from this contract.
The skill and Effigy selectors must not be scaffolded directly from the
prototype or research narrative.
