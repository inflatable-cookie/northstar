# 118 - Extract TypeScript/Svelte Language Package

Status: core fallback notice repaired; Jetstream forced-fallback rerun serial
Owner: repo maintainers
Updated: 2026-09-02
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, cards 116-117
Auto-start next card: no

## Ready-State Checks

- [x] cards 116-117 are merged and the accepted protocol is referenced exactly;
- [x] current TypeScript payload and consumer cohort are inventoried against
  the accepted package boundary;
- [x] TypeScript remains explicit-audit-only and carries Svelte/SvelteKit as
  conditional overlays;
- [x] existing profile, deviation, rule, scope, and evidence contracts remain
  unchanged;
- [x] Rust and root reduction are out of scope.

## Accepted Baseline

- Card 117 was accepted at `57f850a964ec5c735b22d590a64ab4ade366d0bf`
  and merged through PR 22 at `75db6f5`.
- The first canary is `@northstar/typescript-quality` `0.1.0`, compatible with
  core `>=0.2.0 <1.0.0`, at
  `inflatable-cookie/northstar-language-packs/packages/typescript`.
- The embedded extraction inventory is 17 files with aggregate source-list
  digest `7e3ff26cd9319743fee5b0433d79b0cea6515347aa5780f68f2fcbb6eb664d26`:
  three profile/activation templates, the command skill and its agent metadata,
  eight TypeScript reference files, the audit mode, and three Rhai scripts.
  The historical 93-file number is whole-skill distribution parity, not the
  extraction inventory.
- Jetstream is the current real-consumer canary at
  `ab6d2e6c82b54732c6bea4a61569c14a2a9a2991`. Its TypeScript profile digest is
  `9fcb6b8dd99ce09864a725a71167d63323cb495551e6e76f5c89dcf9113b2c7b`; its
  empty deviations digest is
  `131c912ee29ebf7811fcd3773b6575ee3f3aa62b87ae477a4985844d8572d445`.
  It has one independent `editor-ui` package and resolves `base` plus `svelte`.
  The previous ignored audit ledger is absent, so this card must create fresh
  installed-package evidence rather than claim ledger continuity.

## Objective

Publish, pin, install, and prove TypeScript/Svelte as the first independent
official language package under one bounded embedded-overlap window.

## Package Shape

The initial package contains 20 files: the 17 relocated embedded surfaces plus
`northstar-package.json`, package-local `effigy.toml`, and executable
`scripts/self-check.sh`. The existing command adapter becomes the package-root
`SKILL.md`; its agent metadata becomes package-root `agents/openai.yaml`.

The manifest exposes only `explicit_audit_repair`, declares TypeScript with
`base`, `svelte`, and `sveltekit` overlays, and declares `effigy` and `sh` as
runtime capabilities. Its direct self-check wrapper runs the package-owned
Effigy check against the installed package root. The Rhai setup, recorder, and
check scripts resolve package assets from Effigy's task-source/catalog context;
`repo_root` remains the consumer target. They must not infer package assets
from the consumer checkout.

## Lane Runway Context

- Higher-level lane owner: g02.048 Batch B and package-protocol canary.
- Next likely card: 119 Rust extraction.
- Next planning checkpoint: accept or repair protocol findings before Rust
  copies the package shape.

## Scope

- create the public shared source repository and the independently addressable
  `packages/typescript` package;
- relocate the exact TypeScript catalogue, overlays, schemas, mode, setup,
  recorder, fixtures, templates, and thin adapter without semantic edits;
- publish an immutable candidate and pin it through a reviewed Northstar core
  registry change;
- preserve existing consumer activation/profile/deviation/evidence paths;
- route explicit audit through the installed package and prove independent
  acquisition, self-check, rollback, offline, and visible frozen fallback;
- run package-scoped parity and a fresh Jetstream workflow.

Do not add TypeScript everyday authoring, alter rule meaning or authority,
install Rust, or remove the embedded fallback in this card. Repository creation,
publication, registry merge, and consumer PR merge remain orchestrator-owned
external mutations; workers must stop at reviewable heads.

## Execution Plan

1. The orchestrator creates the public shared repository if it is still absent,
   installs its Northstar/Paseo project surfaces, and records the immutable base.
2. A package worker relocates the 17-file baseline into the 20-file package,
   refactors only task-source resolution, proves source/self-check parity, and
   opens a source-package PR.
3. After exact-head acceptance, the orchestrator merges and records the source
   commit, package-tree digest, and manifest digest as the candidate identity.
4. A Northstar worker pins that exact candidate, adds installed-package routing
   plus the visible frozen-fallback route, and opens the core PR.
5. After the registry/routing PR merges, a Jetstream worker runs a fresh audit
   through the installed package and records consumer bytes, route identity,
   overlays, evidence, rollback, offline, and forced-fallback results.
6. The orchestrator reconciles both repositories and closes the overlap evidence
   without starting Rust extraction automatically.

## Acceptance Criteria

- [x] package source contains the exact 20-file shape and the installed payload
  contains only the named TypeScript/Svelte package;
- [x] revision-S behavior, nine normative rules, evaluation-only boundary,
  overlays, scope, and retained limitations remain exact;
- [ ] valid consumer files remain byte-identical and existing evidence remains
  readable;
- [x] package tasks resolve their installed source separately from the consumer
  target;
- [x] the declared direct self-check executes from the installed package with
  its runtime capabilities enforced;
- [x] package source/install parity and immutable registry promotion pass;
  replacement identity `d18dc33b` digest-proven and repinned at registry
  version `1.2.0`; PR 23 merged as `5951dfb` after exact-head review;
- [x] installed, offline, rollback, and acquisition-failure fallback routes
  pass, now including the non-vacuous installed setup/record proof through
  the exact public `effigy skill run --path <installed_path>` surface against
  a decoy consumer; the fresh Jetstream route remains serial;
- [x] all new TypeScript package development lands externally during overlap;
- [x] root fallback is frozen and visibly identified, not silently preferred;
- [ ] full Northstar, package, and consumer QA pass; Northstar and package QA
  pass on the replacement identity, consumer QA (Jetstream) remains serial.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Workflow availability is preserved. | Ordinary TypeScript coding triggers everyday package policy. | Route remains unavailable. | Negative activation fixture. |
| Overlays stay conditional. | Dependency exists without owned Svelte surface. | Do not activate overlay. | Existing overlay fixtures through package. |
| Package is independent. | Shared source repo also contains Rust. | TypeScript install retains no Rust payload. | Installed inventory. |
| Package source and consumer target stay distinct. | Recorder resolves its catalogue below the consumer root. | Stop before evidence creation. | Installed-source/consumer-target fixture. |
| Self-check is operational. | Manifest names a missing command or wrapper exits nonzero. | Stop before activation. | Installed direct self-check negatives. |
| Consumer policy survives. | Jetstream's strict profile and deviations predate extraction. | Preserve bytes and interpretation. | Pinned before/after hashes. |
| Fallback is visible and bounded. | Package acquisition fails during overlap. | Name package failure and frozen root fallback. | Forced-failure transcript through `fallback` on a stopped `acquire_activate` pair; host stop alone is not proof. |
| Evidence remains comparable. | A pre-extraction finalized audit is reopened/read. | Preserve schema and meaning. | Evidence compatibility fixture. |
| The canary is current. | Evidence is copied from the absent prior Jetstream ledger. | Reject as non-evidence. | Fresh installed-package audit identity. |

## Evidence Required

- accepted-protocol, 17-file source, and 20-file package inventories;
- package source commit, registry pin, tree digest, and manifest digest;
- source/install parity, direct self-check, and no-Rust inventory;
- existing production fixtures plus installed, rollback, offline, fallback, and
  fresh Jetstream runs;
- Jetstream profile/deviation hashes and evidence compatibility results;
- package QA, Northstar QA, consumer QA, `git diff --check`, PRs, exact heads,
  and limits.

## Continuation Envelope

- Auto-start next card: no.
- In-bounds next card: 119 only after canary review and protocol reconciliation.
- Remaining ready chain after this card: 0.
- Transition proof: accepted TypeScript package and no unresolved protocol finding.

## Lane Budget

- Current card ends budgeted run: yes.
- Further operator decision required after this card: if the canary requires a
  contract or package-shape change.
- Pause signal if run stops here: lane-complete.

## Stop Conditions

- extraction changes catalogue semantics, workflow availability, repair
  authority, or consumer policy;
- installed package requires Rust, a Northstar source checkout, or conflates
  its task source with the consumer target;
- package protocol findings would be copied into Rust;
- revision-S or fresh Jetstream evidence cannot be preserved;
- validation changes the plan.

## Completion Notes

Readiness refreshed on 2026-09-02 after PR 22 merged. The operator selected the
public shared-repository topology and Jetstream canary. The public repository
was bootstrapped at source base `9e307f5`; its committed worker handoff is at
`ad5db1b`. Package PR 1 was accepted at exact head
`2982d0e40f1ded9d96975b1dd53d6feec5d2a26d` and squash-merged as
`09ef1743dd8fc18bae3bf04fae791f1d7d4e5daf`. The accepted package identity is
tree digest
`sha256:0fcd5c58296f168895b66f2472621d49761f7786ea2ad1ebeefb801040967d6b`
and manifest digest
`sha256:ed95883c428ef43f0f02d38d60bf8d50e6e29313f5751c1b2a5744157a5b5362`.
The source-list digest remains
`7e3ff26cd9319743fee5b0433d79b0cea6515347aa5780f68f2fcbb6eb664d26`.
The source worker workspace was archived and its Paseo-owned worktree removed.
No registry pin or consumer branch exists.

Registry/routing worker (2026-09-02): the official registry pins the accepted
canary identity at registry version `1.1.0`; the generic
installed-package route (`references/packages/installed-package-route.md`) and
the router's TypeScript audit route send explicit audit intent through the
installed package with the frozen embedded payload as a visibly announced
fallback. The canary exposed and fixed a card-117 defect: self-check receipts
(`.effigy/`) polluted the installed tree and broke selection re-verification;
the reference surface now executes the self-check on a byte-identical
throwaway copy, proven by an oracle-11 pollution regression. Falsified with
`oracle-14 official-pin-route`, an independent spec-034 digest implementation
over the materialized accepted commit, and a real-package transcript
(visible fallback trigger, detection never acquires, install with real
self-check, offline routing, drift stop, byte-exact restore, consumer
preservation). Validation: standalone oracle, `effigy check:language-packages`,
isolated skill-install parity, `effigy qa:docs`, `effigy qa`,
`git diff --check`. Evidence: `docs/logs/2026-09/02-201200-pin-typescript-package-canary.md`.
The embedded TypeScript payload files remain byte-identical to `origin/main`.

Exact-head review (2026-09-02, PR 23 at `057dd28`): CHANGES REQUIRED. The
registry pin, generic route, fallback wording, self-check isolation repair,
and provenance repair were not disputed. Blocking findings, all upstream of
this branch's authority: the pinned `09ef1743` package cannot perform its
installed setup/record workflow — its embedded-catalogue command identity
(`northstar/...` prefixes) is wrong for the installed package, and the
relocated setup/recorder scripts do not normalize Effigy's relay sentinel
args; and the submitted evidence never executed the package's declared
setup/record route against a separate consumer, so the installed-workflow
claims were accepted as unproven. The handoff forbids editing the public
package source, so this stops here as a planning stop, not a branch repair.
The orchestrator is dispatching an external package-source repair producing a
replacement source commit and tree digest; this branch then repins the
replacement identity, adds the non-vacuous installed setup/record oracle
through the exact public consumer surface, and revalidates. PR 23 stays open;
the frozen fallback must not be used to hide the failure.

Replacement-identity worker (2026-09-02): the external installed-invocation
repair merged as `d18dc33b` (language-packs PR 2). This branch repinned the
registry to `sha256:7676713…334a` / `sha256:e5e32f2b…85ca` at registry version
`1.2.0` and updated the checker's exact-pin assertions and the oracle's
provenance expectation. The `oracle-gap` is repaired with the replacement
package's reviewed proof harness (`scripts/prove-installed-invocation.sh`,
pinned in the package at `d18dc33b`) executed against the lifecycle
`installed_path`: through the exact public
`effigy skill run --path <installed_path> typescript-quality:{setup,record}
--repo <consumer> -- …` surface it proves the old embedded-catalogue command
identity fails against the installed package, a decoy consumer `northstar`
catalogue wins the old prefix but never the new surface, relay sentinel args
appear verbatim in the machine output, setup writes the activation block and
profile only to the consumer, recorder init/assess/complete/finalize writes
audit records only under the consumer target with the package catalogue
digest, and the installed package tree is byte-identical before and after.
Reran the full canary transcript against the replacement identity
(fallback trigger, detection stop, install with real self-check, offline
routing, drift stop, restore, refused version-drifted variant, consumer
preservation) and the independent digest proof (21 files). Validation:
standalone oracle, `effigy check:language-packages`, isolated skill-install
parity, pinned-package `effigy qa`, `effigy qa`, `git diff --check`.
Evidence: `docs/logs/2026-09/02-201200-pin-typescript-package-canary.md`.

Orchestrator closeout (2026-09-02): exact-head re-review accepted PR 23 at
`d4c23816e9995cdc358a70b53acd50648a1f5e9a`; it merged as
`5951dfb46eb5ba11cc933a225c3dd0d2a10a1bbe`. The serial Jetstream edge was
promoted without changing its product roadmap. Handoff
`docs/handoffs/20260902-jetstream-installed-typescript-package-canary.md` was
committed to Jetstream `main` at `7c2cf010`; Paseo worker
`f40afdd6-5597-4405-a7fc-63e6a0869e21` runs in workspace
`wks_250577a54e82f464` with read-only Northstar and language-pack siblings.

Jetstream exact-head review (2026-09-02, PR 4 at `8420f9d1`): CHANGES
REQUIRED. The installed path, fresh five-unit audit, policy preservation,
offline route and drift recovery passed. The forced-failure transcript stopped
at the reference host's manual/local-install result; it never emitted the
required frozen-fallback notice, and that host prose omitted the package
version. This is an upstream Northstar execution miss. A separate validation
gap also classified editor tasks as unavailable from an unhydrated worker even
though they execute on the base checkout. Jetstream stays on the same branch
while handoff `20260902-212756` repairs the core fallback seam; after merge the
same consumer worker reruns fallback and hydrated editor evidence.

Core fallback-notice repair (2026-09-02): the generic lifecycle surface now
owns `decideFrozenFallback` and a `fallback` CLI. It consumes a stopped
`acquire_activate` request/result pair plus registered overlap windows and
emits the exact notice naming `package-id@version`, the host stop reason, and
the frozen embedded payload. The host status grammar is unchanged; a host
`stopped` result is not fallback evidence. Host catch prose now includes
`@version`. Pre-fix Jetstream-shaped pair recorded: stopped
`@northstar/typescript-quality` `0.1.0` with
`manual or local-path installation route required`, no `@0.1.0`, no frozen
clause. `oracle-15` and the checker CLI convert that pair into
`@northstar/typescript-quality@0.1.0` plus the frozen TypeScript payload
clause, and fail closed on missing version, wrong identity, non-stopped
results, disagreeing operations, a closed window, and a language with no
frozen payload. Jetstream remains paused on PR 4 until this Northstar PR
merges; then the same worker reruns forced fallback and hydrated editor
validation. Cards 119-120 stay closed.

Fallback repair review (2026-09-02, Northstar PR 24 at `7a240ca`): CHANGES
REQUIRED. The separate core decision and notice text are sound, but the frozen
v1 result grammar carries no request correlation, so unrelated stopped results
can be paired and accepted. The decision also accepts detection intent and any
syntactically valid TypeScript package version; its new overlap registry has no
schema. The orchestrator settled the pre-release correction on `main`: every
host request/result now shares a caller-generated `request_id`; the overlap
registry is schema-validated and binds exact package version; detection and
mismatches fail closed. The same PR 24 worker integrates that authority and
repairs only these findings.

Protocol-correction repair (2026-09-02): every host request/result now carries
a caller-generated `request_id`; both reference hosts echo it; fallback rejects
a mismatched pair before the notice. The overlap registry is schema-validated
and binds exact package version `0.1.0`. Detection intent and a request version
outside that window fail closed. Non-vacuous fixtures cover mismatched
`request_id`, detection, wrong version, extra overlap properties, and a missing
window version. Jetstream remains paused on PR 4 until this Northstar PR
merges. Cards 119-120 stay closed.

## Next Task

Review and merge the Northstar fallback-notice PR. Resume the existing
Jetstream PR 4 worker for forced-fallback and hydrated editor validation, then
re-review its exact head. Do not create a replacement Jetstream lane. Cards
119-120 remain closed.
