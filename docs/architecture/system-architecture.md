# System Architecture

Status: active
Owner: repo maintainers
Updated: 2026-09-02
Vision refs: docs/vision/001-northstar-delivery-vision.md

## Top-Level Stack

- `bundle-docs/`
  is the doctrine authority for how Northstar is supposed to work
- `template-bundle/`
  is the copy-ready product artifact that downstream repos adopt
- `skills/`
  is the installable behavior surface for agent workflows
- `docs/`
  is the live Northstar planning spine for developing this repo itself
- `scripts/` plus `effigy`
  provide repo validation and maintenance checks
- published skill updates use the Skills CLI; source checkouts can verify an
  installed skill with the local parity checker
- root `PAPERCUTS.md`
  records small, solvable execution friction for later maintenance

## Data and Authority Flow

- Vision in `docs/vision/` sets the destination for Northstar's next evolution.
- Architecture plus a compact working-rules contract define the rules the repo
  should follow while changing itself.
- Specs and batch cards in `docs/specs/` define the detailed path for material
  changes.
- Roadmaps in `docs/roadmaps/` sequence approved work.
- Logs in `docs/logs/` provide batch-level evidence.
- Temporary observations and unresolved conversational threads land in
  `docs/triage/` before they are promoted into canonical planning surfaces or
  removed during refresh/cleanup.
- Agents append execution friction to root `PAPERCUTS.md`; maintenance promotes
  repeated or material items into the normal planning spine.
- `bundle-docs/`, `template-bundle/`, and `skills/` should be updated from this
  planning spine rather than by ad hoc repo edits.
- published skill propagation and source/install parity should remain explicit
  so multi-harness installs do not depend on manual operator memory.
- Live consumer dogfooding is operator-owned outside Northstar's execution loop;
  consumer feedback enters Northstar through the operator as evidence,
  papercuts, research, or planning input. Northstar does not select, dispatch,
  or manage consumer runs.

## Language quality packs

Northstar core routes to optional language quality packages, but the root
payload remains useful without them. Core owns a provider-neutral manifest,
discovery, compatibility, trust, installation, activation, and routing
protocol. Each package owns its language catalogue, projections, overlays,
schemas, setup, tooling, fixtures, self-check, version, release evidence, and
independently addressable installed payload.

The initial official Rust and TypeScript packages share the public sibling
source repository `inflatable-cookie/northstar-language-packs`, but they remain
separate release, acquisition, installation, and activation units. Installing
one never loads or retains every sibling. The protocol permits later official
split repos and third-party sources without changing core or consumer
activation files.

### Package registration and runtime boundary

Every package is a normal skill bundle with an agent-facing `SKILL.md` and a
machine-readable `northstar-package.json`. The manifest declares its schema,
stable namespaced identity, version, `language-quality` kind, compatible core
range, languages and overlays, workflows, runtime capabilities and optional
Effigy selectors, self-check, profile and schema versions, and optional
evidence providers. Acquisition receipts, rather than the package manifest,
record source, digest, and trust provenance.

Core discovers packages through the host's available-skill catalogue or an
acquisition adapter's resolved installed path. Routing is generic over package
kind, language, workflow, and compatibility; it does not add a core branch for
each language. Thin language command skills may live with a package. `effigy
skill run` may execute a resolved package in a consumer repo, but Effigy is an
optional adapter rather than the package transport or a core dependency.

The portable runtime boundary is the versioned `language-package-host.v1`
request/result protocol, not a bundled language-runtime executable. A host
adapter supplies its native catalogue, byte/file metadata, atomic state,
transport, and process-execution capabilities behind that protocol. The core
operations are resolve, acquire-and-activate, and rollback; requests bind a
caller-generated request ID, intent, package identity, language, workflow, core
version, consumer scope, and the operator-supplied state root. Results echo the
request ID and carry a bounded status, exact identity, resolved path or receipt
where applicable, and visible notice; mixed request/result pairs fail closed.
Effigy, Bun, Node, Python, POSIX shell, and provider APIs may implement an
adapter or reference harness, but none is a Northstar consumer prerequisite.
When no conforming host adapter is available, only the requested package
workflow stops with a visible capability notice; ordinary Northstar routing
continues.

Core carries a small official registry that pins each approved package version
to an immutable repository and subpath, commit and tree digest, manifest
digest, and compatible core range. The installer verifies those identities
before executing package code or self-checks, records them in an installation
receipt, and re-verifies retained content before routing. A registry review,
not a moving branch, tag, package self-claim, or newly published version,
changes the official automatic choice.

Content identity is portable and transport-independent. V1 uses required
`sha256:` digests: raw manifest bytes for manifest identity and a sorted,
length-framed stream of regular package files for tree identity. Paths use the
portable package grammar; case-fold collisions, symlinks, special files, and
escapes are rejected. Core state lives in a host-supplied operator-owned root,
never the consumer repository. Immutable receipts, exact trust/revocation
records, and a revisioned lifecycle index separate retained installs from the
single selected receipt. Activation replaces that index only after verification
and self-check; rollback reselects retained verified content without fetching.

Self-check invocation is explicit rather than inferred from capability-list
order. The manifest chooses `direct` or `command`. Direct invocation executes
the verified package-relative entrypoint with the package root as its sole
argument. Command invocation names one required host command and executes it
with the resolved entrypoint and package root as fixed arguments. Both run with
the package root as working directory, use no shell interpolation, and stop
activation on launch failure or non-zero exit. A command runner must also
appear in `runtime_capabilities.required_commands`; list order has no meaning.

The language-package source repository owns package source, manifest,
self-check, package fixtures, artifacts, digests, changelog, and release
evidence. Northstar core owns the manifest schema, official registry, generic
resolver and installer, digest framing, trust and lifecycle-state schemas,
compatibility fixtures, and consumer migration rules.
An immutable package candidate publishes first; a reviewed registry change
then proves installation and consumer compatibility before making it the
official default.

Rust and TypeScript remain embedded in the root skill while their ordered
extraction runs. The external package becomes authoritative at the start of
one bounded overlap window; the embedded copy is then frozen and available
only as a visibly named migration fallback. The next migration milestone
removes that fallback after parity, install, self-check, routing, rollback,
offline, activation, and real-consumer proof. No new language package starts
until both existing payloads are independently distributed and removed from
core.

Contract [`004-language-quality-pack`](../contracts/004-language-quality-pack.md)
governs package behavior, profiles, authority, deviations, evidence, trust,
and migration. Each pack has two workflow projections:

- everyday authoring uses a compact, path-scoped activation, loads detailed
  rules only for relevant domains, and rechecks the changed tranche at exit;
- explicit audit-and-repair runs only on operator request, resolves either
  worktree or repository scope, and repairs findings in reviewable waves.

Workflow and assurance are separate axes; both workflows consume one profile
from the same catalogue. The initial Rust pack validates only `strict`.
Ordinary and high assurance remain modelled but cannot be activated as validated
production profiles. Northstar owns the reusable rule schema, provenance,
deviation, and workflow contracts. Effigy resolves scope and orchestrates
repository-native tools. The consumer repository owns its profile, toolchain
and MSRV, exclusions, project architecture, and accepted deviations. The agent
preserves dirty state and stops when repair needs a breaking or architectural
decision not already authorised.

Compiler, lint, test, analysis, and benchmark results are evidence. They do not
prove architecture quality, certify a system, or turn a coding skill into a
safety case.

### Conditional framework overlays

A language pack may project conditional framework rules from the same catalogue
and workflows. Repository dependencies and configuration identify candidates;
framework version plus an owned semantic surface resolve applicability.
Dependency presence alone does not activate an application overlay. Root and
declared-workspace ownership keep ancestor configs out of fixtures,
documentation examples, generated output, and vendored resources. The everyday
route loads only the base projection plus the overlay needed by the current
path. Explicit audit resolves all applicable overlays once and reports them
with scope. Overlays do not get parallel standards, profiles, or top-level audit
commands.

TypeScript is the second production pack. Svelte belongs inside it as a
framework overlay; SvelteKit is a narrower sub-overlay for routes, server state,
load functions, and server/client import boundaries. A future visual-design or
copy-quality system would be a separate concern, not a Svelte coding overlay.

Its first production lane is explicit audit only. Nine source-local rules have
replicated research repair evidence; one slop signal remains evaluation-only.
Everyday authoring failed its no-regression gate and is unavailable. Toolchain
and testing rules remain unpromoted pending package-backed evidence. This split
does not create a second catalogue or command family: the existing Northstar
skill router loads TypeScript detail only after explicit audit intent, then
resolves Svelte and SvelteKit overlays by owning package, version, and path.

The production boundary must remain consumer-runtime-neutral. Northstar may use
its skill-local Effigy/Rhai substrate for setup, recording, and deterministic
checks, while repository-owned TypeScript, framework, lint, and test selectors
remain external evidence. The pack must not require Bun, Node, npm, pnpm, or a
Northstar source checkout merely to resolve scope and record an audit.

### TypeScript explicit-audit production boundary

Card `g02.031/089` selects a TypeScript-specific Effigy/Rhai implementation at
minimum Effigy `0.8.4`. It preserves the Rust recorder's finding-first,
case-local lifecycle without extracting a shared core from the stable Rust
implementation. Production surfaces are frozen as:

| Surface | Canonical path |
| --- | --- |
| catalogue, schemas, and strict audit projection | `skills/northstar/references/language-quality/typescript/` |
| explicit audit mode | `skills/northstar/references/modes/typescript-quality-audit.md` |
| setup, recorder, and package check | `skills/northstar/scripts/typescript-quality-setup.rhai`, `typescript-quality-recorder.rhai`, `check-typescript-quality.rhai` |
| thin explicit adapter | `skills/northstar/commands/northstar-typescript-audit/SKILL.md` |
| copy-ready activation and profile templates | `skills/northstar/assets/templates/language-quality/typescript/` |

The consumer profile and deviations live at
`docs/contracts/typescript-quality-profile.json` and
`docs/contracts/typescript-quality-deviations.json`; evidence lives below
`.effigy/typescript-quality/audits/<audit-id>/`. A root package owns itself and
declared workspaces while reporting other nested manifests. Without a root
package, discovered subpackage manifests are independent owning roots. This
supports mixed repositories without assuming TypeScript lives at the root.

The first external package is `@northstar/typescript-quality` version `0.1.0`
at `packages/typescript` in `inflatable-cookie/northstar-language-packs`. It
supports core `>=0.2.0 <1.0.0`, owns TypeScript with `base`, `svelte`, and
`sveltekit` overlays, and exposes only `explicit_audit_repair`. The package
relocates the 17 embedded TypeScript surfaces and adds only its manifest,
Effigy catalogue, and direct self-check wrapper. Effigy remains the declared
Rhai runtime; package tasks resolve their installed source through Effigy's
task-source context while the consumer repository remains the target.

The initial boundary supports package-json ownership, Svelte 5, and SvelteKit
2. Deno-only/source-only roots and older or unresolved framework overlays remain
unsupported or degraded rather than silently misclassified. Repository-owned
compiler, framework, lint, and test routes are recorded as separate evidence
classes; unavailable routing or startup is not a source pass.

Revision S passed three copied-payload subjects and blind reviewers with
`30/30` primary findings, `96/96` review dimensions, and `24/24` accepted
repairs. The frozen payload is distributed inside the single 93-file Northstar
install with exact source parity. Its minimal installed Effigy catalogue exposes
only package checks, setup, recorder self-tests, recorders, and the shared
agent-instruction check; it does not expose Northstar's source QA board.

### Rust production boundary

Rust quality ships inside the existing `skills/northstar/` artifact. It does
not create a second installable skill. The production surfaces are:

| Surface | Canonical path |
| --- | --- |
| catalogue, schemas, and checked projections | `skills/northstar/references/language-quality/rust/` |
| everyday mode | `skills/northstar/references/modes/rust-quality-authoring.md` |
| explicit audit mode | `skills/northstar/references/modes/rust-quality-audit.md` |
| activation setup and package check | `skills/northstar/scripts/rust-quality-setup.rhai`, `skills/northstar/scripts/check-rust-quality.rhai` |
| Cargo-native audit engine | `skills/northstar/tools/rust-quality/` |
| thin explicit adapter | `skills/northstar/commands/northstar-rust-audit/SKILL.md` |
| copy-ready activation and profile templates | `skills/northstar/assets/templates/language-quality/rust/` |

Card `g02.032/095` replaces the source v1 Rhai recorder with one locked
Cargo-native engine. The agent installs it into a payload-addressed Northstar
cache, verifies the embedded source checksum, and invokes its absolute path.
It does not alter global Cargo state or require a consumer Effigy catalogue.
The earlier three-task Effigy/Rhai split is rejected research, not a
compatibility route.

The engine uses Git for repository identity, dirty state, audit-record storage,
and file provenance. It uses Cargo's versioned CLI for recursive mixed-repo
workspace, package, feature, target, and MSRV discovery. Worktree scope requires
a dirty Rust anchor; repository scope requires an exact Cargo-derived coverage
claim. Context stays read-only unless `extend` ties it to one existing repair
plan before mutation.

The record lifecycle is `inspect`, `plan`, `init`, `assess`, `extend`,
`complete`, and `finalize`. Every assessed unit carries one verdict for each of
the six approved normative rules plus correctness-assurance, architecture, and
human-quality attestations. Findings, repair plans, accepted deviations,
repository policy, fingerprints, and mutation attribution are checked. Final
`result.json` and `report.md` derive from the same unit-local records; empty
findings cannot imply completed review.

The agent installs missing Rust activation through
`northstar/rust-quality:setup`, choosing the narrowest Rust-owning instruction
scope and discovering Cargo and explicit toolchain files. The task preserves
existing instructions and valid contracts and is byte-idempotent. Consumers
still own `strict` profile policy, accepted deviations, exclusions, and all
compatibility inputs. Case-local evidence lives under the target repository's
Git metadata at `northstar/rust-quality/audits/<audit-id>/`, so no worktree
ignore entry is needed.

The Rust boundary was first distributed in a 76-file `northstar` artifact.
Revision E is now the configured 120-file combined install with exact source
parity. This is a local development distribution, not a published release or a
consumer-system assurance claim.

### Rust v2 frozen tool boundary

Card `g02.032/094` froze the Cargo-native boundary; cards 095-099 implement and
distribute its
scope, ledger, lifecycle, bootstrap, deterministic report, immutable mechanical
evidence, compact everyday closeout, detector qualification, and production
proof in source.

The binary uses Git for immutable dirty-scope evidence and Cargo's versioned CLI
interfaces for recursive workspace, package, target, feature, and toolchain
evidence. It owns scope validation, the complete unit-rule ledger,
three review attestations, findings and repair authority, fingerprints, derived
limitations, `result.json`, and deterministic `report.md`. It does not link
Cargo internals or require a consumer Effigy catalogue.

Explicit plans resolve profile, repository-task, Cargo-native, or agent-owned
selectors and execute program/argument arrays without a shell. Raw streams live
as hashed Git-metadata artifacts. Every unit completion cites the full immutable
evidence inventory; diagnostics remain evidence-only.

Everyday authoring may consume the compact worktree snapshot and normalized
evidence at changed-tranche closeout. It does not initialize the full audit
ledger or load the explicit procedure. Main skill and router byte size remain
fixed; all new schema and tool detail stays on-demand.

## Readiness-mapping artifact contract

Readiness mapping is a plan-only index for a bounded destination. It does not
replace the existing spec, contract, roadmap, or log surfaces. For a destination
named `<destination-slug>`, the repository-native surfaces are:

| Surface | Path | Role |
| --- | --- | --- |
| readiness map | `docs/specs/<destination-slug>/README.md` | index, summary, and current frontier |
| decision record | `docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md` | one canonical record for one decision, research item, prototype, or task |

Both surfaces are Markdown with YAML frontmatter and explicit relative links.
The map frontmatter requires `kind: readiness-map`, stable `id`, `title`,
`destination`, `owner`, `status`, `master_spec`, and `roadmap`. Map `status` is
one of `active`, `cleared`, or `paused`. Its body has four required sections:
`## Destination`, `## Decision index`, `## Current frontier`, and
`## Readiness gate`. The decision index may summarise state and blockers, but
must link each record and must not copy its rationale.

Each record frontmatter requires stable `id`, `kind` (`decision`, `research`,
`prototype`, or `task`), `mode` (`operator`, `research`, `prototype`, or `task`),
`status` (`open`, `in-progress`, `resolved`, or `out-of-scope`), `title`,
`owner`, `authority`, and `blocked_by`. `blocked_by` contains stable decision
IDs and is empty when there are no blockers. A resolved record must expose
exactly one of `resolution_evidence` or `accepted_uncertainty`; neither may be
inferred from the map or from agent preference.

Map and record IDs are stable lowercase kebab-case identifiers, unique within
the destination. A record filename begins with its exact decision ID followed
by a descriptive slug; changing a title or slug does not change the ID. Links
must stay inside the destination subtree or target named canonical docs surfaces
(the governing spec, architecture, contract, roadmap, or log). Operator-owned
decisions cannot be resolved by agent inference, and research, prototype, and
task records remain distinct from operator decisions. A `cleared` map never
authorises execution by itself; the explicit operator-owned readiness decision
and normal spec/promotion/roadmap gates remain authoritative.

## Pre-execution discovery routes

The readiness map is extended by four planning routes without creating a second
planning authority:

| Route | Durable home | Role |
| --- | --- | --- |
| Intent rounds | readiness map plus linked decision records | breadth-first questions over the live frontier |
| Project language | destination-local project-language surface linked from the map | preferred terms, aliases, meanings, authority, and rejected ambiguities |
| Decision prototype | canonical `kind: prototype` decision record plus linked evidence | bounded throwaway evidence for questions conversation cannot settle |
| Questionnaire | canonical operator-owned decision record | durable questions and explicit operator responses across turns or sessions |

Project language stays local unless a stable term earns promotion to the global
glossary. Prototypes and questionnaires can inform decisions but cannot change
execution authority. All four routes remain provider-neutral, plan-only, and
non-mutating by default.

## Thread topology

For material work that benefits from a separate implementation context, the
preferred split is:

`operator ↔ orchestrator thread -> canonical plan/runway -> worker thread/worktree -> PR -> independent review child -> coordinator gate -> merge/closeout`

A parallel planning-only branch is:

`operator ↔ planning delegate/worktree -> triage/research PR -> review child -> coordinator merge -> operator-confirmed promotion lane`

An explicit fresh-orchestrator transfer uses:

`operator ↔ source orchestrator -> committed continuation handoff -> fresh orchestrator/local workspace`

A secondary conversational intake channel is:

`operator ↔ chatterbox thread (shared checkout) -> unique docs/triage/ note (file-on-disk intake)`

A fresh direct-review thread uses the smaller path:

`operator -> existing PR -> direct review thread -> provider review record`

The normal worker-PR review path routes through an independent child:

`worker PR -> review child (dedicated PR-head workspace) -> provider verdict naming the head -> coordinator merge gate -> merge/closeout`

The orchestrator owns economical coordination: operator-routed discovery, promoted
planning bounded by operator-confirmed authority, ready-state, launch
preparation, revision routing, the merge gate, and merge. Substantive
exact-head semantic review belongs to independent review children. After
settling meaning, the coordinator may run one fast/low-cost documentation
projection subagent serially in the planning context for genuinely
non-semantic edits. That subagent applies an exact brief to named docs and
deterministic checks; it does not choose authority, invent planning, decide
state, touch product code, or perform Git/provider mutations, and it stops on
semantic ambiguity. The coordinator reviews the resulting helper diff and owns
its Git mutations. A promotion batch driven by an operator-confirmed packet is
different: it runs as a bounded branch/worktree/PR lane, where an independent
review child checks the PR against the packet before the coordinator applies
the merge gate.

On explicit operator request, it may also launch one frontier planning delegate
for a named topic. That delegate talks directly with the operator and owns only
a bounded triage/research packet in an isolated branch. It may use read-only
research subagents. The orchestrator reserves that topic, continues only
non-overlapping work, routes the planning PR to an independent review child,
merges after the coordination gate, then separately promotes settled meaning
through an operator-confirmed lane against current `main`.

On explicit operator request, an orchestrator may transfer its current
coordination lane to one fresh orchestrator thread. The source closes the live
state into a committed, pushed seven-section handoff, launches the successor as
normal orchestrator mode, then stops mutating or dispatching that transferred
lane. This is continuity, not parallel ownership: a genuinely concurrent
orchestrator needs a separately partitioned authority scope.

With Paseo available, the successor gets a separate local workspace for the
same project and repository checkout, a current profile selected from the
eligible orchestrator-role pool under the diversified-routing rule, and the
capitalized `Orchestrator` agent label. It does
not get a worktree or worker preflight. Sidebar pin position is optional adapter
state: use a native pin/reorder control only when one is explicitly exposed;
otherwise tell the operator to place it manually and do not use browser,
computer-use, or other UI automation.

An operator may also start or request independent **chatterbox** threads for
exploratory feature ideas, issues, or intake discussions. Chatterboxes share the
orchestrator's checkout, create unique timestamped `docs/triage/` notes, and
isolate commits to exact paths after verifying clean pre-stage index state.
They do not create worktrees, branches, or PRs. In Paseo, the orchestrator
spawns a chatterbox in a `local` workspace for the same project/checkout, with
label `Chatterbox=true` and `notifyOnFinish: false`. Chatterbox v1 starts no
automatic orchestrator turn; it reports the absolute note path and summary in
chat, and the orchestrator inspects `docs/triage/` at normal triage checkpoints.
A note may be decision-ready when it separates operator-confirmed decisions,
recommendations not yet accepted, evidence and alternatives, unresolved
questions, and affected authority surfaces; only operator confirmation through
the orchestrator makes it promotable.

Chatterboxes have no planning, readiness, implementation, review, merge, or
dispatch authority.

Each worker owns only the assigned ready cards in its dedicated worktree and
branch. Model routing treats current profiles as a portfolio. For each run the
orchestrator builds the adequate pool from current role notes and any explicit
adapter cost metadata, prefers the cheapest adequate tier, then varies
provider/model identity before reusing a recent route. Adapter-visible recent
agent history is evidence when available; otherwise the orchestrator remembers
only the routes it launched in the current run. Northstar keeps no durable usage
ledger and stores no provider or model names.

The coordinator's own route is an economical coordinator class; higher
reasoning effort is an escalation, not the default. Review children select
from their own adequate pools under the same rule.

Ordinary implementation, bounded audits, mechanical work, and most settled
material lanes use that economical pool. A frontier worker is a rare residual
exception: the handoff must explain both material consequence and why planning,
the review oracle, exact-head review, and repository validation cannot bound the
remaining reasoning adequately. Risk labels, priority, complexity, or breadth
alone do not select an expensive worker. Even frontier and fresh-orchestrator
runs rotate across their own adequate pools. An operator-selected profile still
wins. Unresolved designs return to planning.
Scheduling is parallel-first: the orchestrator plans lanes as a
dependency graph and dispatches the whole safe ready frontier without a global thread budget,
each lane with its own worktree, branch, handoff, PR, and closeout.
A control-plane workspace or agent creation failure belongs to that lane's
transport state; preserve every returned identity so an ambiguous attempt is not duplicated,
then continue launching unrelated lanes whose transport state is clear. A
provider, model, or profile quota, spend, rate, or availability failure is
not a control-plane capacity signal: mark only that route unavailable, try
another configured profile that fits the same role and capability, and never
promote an ordinary lane to frontier merely because its day-to-day route is
unavailable.
If no suitable route remains, pause only that lane, preserve its handoff and
workspace, report the gap, and continue every unrelated ready lane. The
topology encodes no fixed worker count.
A lane stays serial only for a named dependency, shared mutable or
closeout/front-door surface, or unresolved authority, and
same-repository lanes partition those surfaces or reserve one named
orchestrator integration step. Same-repository PRs still merge one at a time,
with remaining heads refreshed against current `main` and re-reviewed when they
change.
When a harness has already placed a worker thread in a clean, dedicated,
non-`main` registered worktree, that current context is authoritative; the worker
reuses it even when the generated path or branch differs from the handoff
placeholder.
A control plane whose orchestration tools are injected into the current
orchestrator thread may launch ready workers and return reports or PR URLs
directly without another permission prompt. Otherwise the operator relays them.
Northstar remains independent of provider-specific session messaging either way.

The durable boundary is the repository: architecture, contracts, specs, roadmap
cards, one committed handoff per dispatched lane under `docs/handoffs/`, pushed
`main`, commits, validation, and PR review. Private model conversation is not an
authority surface. A worker launch is valid only after the planning checkout has
published `main` and the handoff's absolute path is available to the operator
and any active adapter. The handoff must declare `handoff_mode: worker-pr-loop`,
`worker_mode: implementation`, and `dispatch_authority: orchestrator`; those
fields activate worker mode. Only then does the worker run a quick startup
worktree check. Normal-mode agents and the orchestrator do not run this check. It reuses
a clean, dedicated, non-`main` registered current worktree supplied by the
harness; only an unusable current context may proceed to a named worktree or a
worktree under the operator-selected `AGENTS_WORKTREE_CONTAINER_DIR` from pushed
`origin/main` before editing.

## Optional Paseo project lifecycle adapter

A Paseo-managed repository may commit project-root `paseo.json` for worktree
hooks, supervised scripts, and metadata-generation guidance. Northstar ships a
copy-ready config and owns the worktree helper inside its installed skill. The
consumer invokes that task through `effigy skill run`, remains the runtime
target, and does not copy the helper. Paseo remains optional and the repository
owns the final commands and wording.

The setup hook has three ordered phases: prepare sibling repos in the generated
worktree's container directory, run the repository's real idempotent setup task,
then replay machine-local `effigy deps link` state from the primary checkout.
Preparation creates an absent symlink, reuses only an already-correct symlink,
and stops on any conflicting path. Teardown unlinks only Effigy state recorded
by that worktree. It retains sibling symlinks because concurrent Paseo
worktrees may share their parent directory.

## Local agent path registry

Repositories may keep machine-specific agent paths in ignored
`.agents.local.env`, copied from tracked `.agents.local.env.example`. The file is
path-only and is not a credential store. `AGENTS_WORKTREE_CONTAINER_DIR` is the
only required key for manual worktree creation; harness-managed worktrees do not
need it. Agents ask the operator for the absolute container directory before
creating the file or any manual worktree, then use one repository/lane
subdirectory below it. `/tmp`, `TMPDIR`, guessed siblings, and repository-child
worktrees are not valid fallbacks. A worker/subagent must not create a nested
orchestrator lane when a parent harness already owns the worktree. The only
exception is a planning delegate's explicitly bounded read-only research
subagent, which gets no worktree or Git/provider authority.

## Invariants

- `bundle-docs/` remains the doctrine authority for the reusable system.
- `template-bundle/` remains generic and copy-ready; repo-specific planning
  lives in `docs/`, not in the bundle.
- `docs/` is the authority for Northstar's own development process.
- Material delivery work should flow through contracts, master specs, batch
  cards, roadmaps, and logs rather than jumping straight from idea to edits.
- The public skill surface should remain small and deliberately routed.
- Everyday authoring and explicit audit-and-repair must not drift into separate
  rule catalogues or conflicting quality standards.
- Write-heavy repository-wide repair requires explicit operator intent and
  bounded, reviewable repair waves.
- Language quality packs must not claim certification, standards compliance, or
  a safety integrity level from tool success alone.
- Before dispatch, the planning checkout must publish canonical planning state
  and one concrete worker handoff per approved worker lane under
  `docs/handoffs/` on `main`; local-only state is not a valid worker base.
- Parallel worker lanes are allowed only when their scopes, dependencies, and
  authority decisions are independent; otherwise the orchestrator keeps the run
  serial and records the reason.
- Each worker handoff is exactly one absolute path; no second prompt or
  copied private context is required. The committed `HEAD` copy is
  canonical before any sibling-path mutation. The file lists required
  sibling worktree links or `none`; each destination lives in the worktree
  container directory, and setup is create-if-absent,
  reuse-if-already-correct, stop-on-conflict. Launcher-managed setup creates
  required links before project bootstrap; manual workers do so after preflight.
- A worker must quickly verify that its current context is a clean, dedicated,
  non-`main` registered worktree before broad reads or edits. If so, it reuses
  that launcher-provided worktree regardless of handoff path/branch placeholders.
  If not, it reads `.agents.local.env`, requires `AGENTS_WORKTREE_CONTAINER_DIR`, and
  creates a unique worktree and branch under that container from pushed
  `origin/main`, recording the resolved path. It never cleans, resets, or
  discards a dirty checkout.
- Orchestrator and worker threads must use separate worktree/branch boundaries;
  a worker may not edit the orchestrator's planning checkout.
- A planning delegate uses its own branch/worktree and writes only the handoff-
  named triage/research packet. It separates confirmed decisions from advice and
  open questions, verifies any handoff-named sibling links in the worktree
  container, does not promote or implement, and finishes with a PR. The
  orchestrator reserves the topic, an independent review child reviews the
  packet PR, the coordinator merges after the gate, and an operator-confirmed
  promotion lane owns the separate promotion batch against current `main`.
- A mechanical documentation projection subagent may edit only the named paths
  in the orchestrator's planning context from an exact settled brief. It is not
  worker mode, runs serially, stops on semantic ambiguity, and cannot choose
  authority, readiness, completion, or next work. The orchestrator captures
  dirty state first, reviews the full diff, and owns commit/push.
- A worker's completion authority is a reviewable PR plus evidence, not a chat
  claim. An independent review child reviews the diff and checks against
  canonical refs and records the verdict in the provider review surface,
  naming the exact reviewed head; same-identity GitHub runs use a PR comment
  because formal self-approval is unavailable. The coordinator verifies the
  verdict head, findings, checks, ancestry, mergeability, and pause state and
  does not duplicate the full review; a replacement reviewer starts a fresh
  complete review.
- A decision-ready chatterbox packet separates operator-confirmed decisions
  from recommendations; only operator-confirmed meaning enters a promotion
  brief, and the bounded projection stops on semantic ambiguity.
- A direct PR-review request authorizes review mutations on the named PR only.
  Every merge-blocking finding is posted on the provider review surface; chat
  summarizes that record and never becomes the only home of a required change.
- Workers and planning delegates never merge. The orchestrator may merge their
  PRs without a second operator prompt after an independent review child
  records an accepted verdict naming the exact current head — or the
  orchestrator does so on an operator-requested direct review — all required
  checks pass, the PR is mergeable into the intended base, and no stricter
  repository rule or explicit operator pause applies. A changed head requires
  another review; ambiguous merge state stops before retry. A merged planning
  packet remains non-authoritative until it is promoted through an
  operator-confirmed promotion lane.
- Provider-native subagents, session messaging, and hosted agents are optional
  adapters, not Northstar protocol dependencies.
- Project-root Paseo settings are optional project lifecycle configuration. They
  may expose Effigy tasks and worktree lifecycle hooks but do not become planning,
  dependency, branch, commit, PR, or merge authority. Their presence does not
  prove that the current thread is running inside Paseo.
- Injected control-plane orchestration tools authorize routine transport for
  ready worker lanes and explicitly requested planning delegates without a
  second permission prompt. The orchestrator may select a current role profile,
  create one dedicated worktree workspace per worker lane, create the worker as
  a child agent from its scoped surface with that returned workspace ID and
  finish notifications enabled, and carry notifications or follow-ups.
  Workspace placement does not detach parentage: detached root launches,
  schedules, generic detached runs, or unproven CLI substitutes are rejected for
  worker dispatch. Its IDs, profiles, messages, and lifecycle state are
  transport metadata, not planning or completion authority. This does not
  authorize unready work, material permission requests, destructive workspace
  cleanup, review, merge, or duplicate retries. Orchestrator merge authority
  comes from the accepted review/check gate, not tool injection. Manual launch
  and operator relay remain the fallback when scoped tools are absent,
  returning the absolute handoff path without pretending parentage exists.
- A generic task-handoff helper must not expand a Northstar worker handoff into
  a second briefing. Adapters launch from the committed file path directly.
- Posting requested changes on a PR does not wake a finished worker. The
  orchestrator retains the originating adapter identity and explicitly prompts
  that same worker after the provider review is recorded. Revisions resume the
  same child agent; it never silently launches a replacement when the original
  worker is unavailable.
- Papercuts remain an observation queue, not a competing planning authority or
  automatic work queue.
- Triage notes remain a temporary capture buffer, not a competing planning
  authority or automatic work queue; every note needs a promote, merge, open,
  or remove disposition over time.

## Performance and Reliability Constraints

- Operator-facing docs should stay readable and direct.
- The repo should default to manual, concrete evidence before adding more
  automation.
- Validation should stay cheap enough that batch-level checks remain normal.
- Autonomy should increase only when the repo's planning artifacts make it safe.

### Validation boundary

Repository validation protects structural invariants: stable entry points,
links, identifiers, executable state, and canonical/mirror parity. Editorial
wording and the continued presence of individual historical artifacts are not
schema. Exact text checks need an independently stable machine contract; they
must not mirror prose merely to detect currentness drift.

Human review still owns semantic contradiction, misleading currentness, and
historical-authority judgment that has no structural representation. A future
structured state field may move one of those decisions into validation, but the
checker must not invent that schema to preserve an old substring assertion.

## Interfaces With Roadmaps

- `g01.001` uses this architecture to enact Northstar on Northstar and pilot
  the delivery layer inside this repo.
- `docs/contracts/004-language-quality-pack.md` governs the first language
  quality pack. Completed roadmap `g02.030` records production-boundary proof,
  implementation, fresh evidence, and distribution.
- `g02.045` reduces Northstar's prose-coupled repository checker while keeping
  structural negative proof.
- Spec 034 records the promoted package design. Roadmap `g02.048` sequences the
  fixture protocol, TypeScript, Rust, and embedded-payload removal; only its
  current ready card authorizes implementation.
