# System Architecture

Status: active
Owner: repo maintainers
Updated: 2026-08-27
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

Northstar may extend `skills/` with optional language quality packs. Rust is the
first planned pack. Contract
[`004-language-quality-pack`](../contracts/004-language-quality-pack.md) governs
the shared catalogue, profiles, authority, deviations, and evidence. Each pack
has two workflow projections:

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

`operator ↔ orchestrator thread -> canonical plan/runway -> worker thread/worktree -> PR -> orchestrator review -> merge/closeout`

A fresh direct-review thread uses the smaller path:

`operator -> existing PR -> direct review thread -> provider review record`

The orchestrator owns question-led discovery, promoted planning, ready-state,
launch preparation, and review. Each worker owns only the assigned ready cards in
its dedicated worktree and branch. Independent roadmap lanes may use parallel
worker threads, each with its own worktree, branch, handoff, PR, and closeout.
When a harness has already placed a worker thread in a clean, dedicated,
non-`main` registered worktree, that current context is authoritative; the worker
reuses it even when the generated path or branch differs from the handoff
placeholder.
The operator relays reports and PR URLs while Northstar remains independent of
provider-specific session messaging.

The durable boundary is the repository: architecture, contracts, specs, roadmap
cards, one committed worker handoff per worker lane under `docs/handoffs/`, pushed
`main`, commits, validation, and PR review. Private model conversation is not an
authority surface. A worker launch is valid only after the planning checkout has
published `main` and the operator has the handoff's absolute path to give
the new thread. The handoff must declare `handoff_mode: worker-pr-loop`,
`worker_mode: implementation`, and `dispatch_authority: orchestrator`; those
fields activate worker mode. Only then does the worker run a quick startup
worktree check. Normal-mode agents and the orchestrator do not run this check. It reuses
a clean, dedicated, non-`main` registered current worktree supplied by the
harness; only an unusable current context may proceed to a named worktree or a
worktree under the operator-selected `AGENTS_WORKTREE_CONTAINER_DIR` from pushed
`origin/main` before editing.

## Local agent path registry

Repositories may keep machine-specific agent paths in ignored
`.agents.local.env`, copied from tracked `.agents.local.env.example`. The file is
path-only and is not a credential store. `AGENTS_WORKTREE_CONTAINER_DIR` is the
only required key for manual worktree creation; harness-managed worktrees do not
need it. Agents ask the operator for the absolute container directory before
creating the file or any manual worktree, then use one repository/lane
subdirectory below it. `/tmp`, `TMPDIR`, guessed siblings, and repository-child
worktrees are not valid fallbacks. A worker/subagent must not create a nested
orchestrator lane when a parent harness already owns the worktree.

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
  copied private context is required. The file lists required sibling
  worktree links or `none`.
- A worker must quickly verify that its current context is a clean, dedicated,
  non-`main` registered worktree before broad reads or edits. If so, it reuses
  that launcher-provided worktree regardless of handoff path/branch placeholders.
  If not, it reads `.agents.local.env`, requires `AGENTS_WORKTREE_CONTAINER_DIR`, and
  creates a unique worktree and branch under that container from pushed
  `origin/main`, recording the resolved path. It never cleans, resets, or
  discards a dirty checkout.
- Orchestrator and worker threads must use separate worktree/branch boundaries;
  a worker may not edit the orchestrator's planning checkout.
- A worker's completion authority is a reviewable PR plus evidence, not a chat
  claim. The orchestrator reviews the diff and checks against canonical refs and
  records the verdict in the provider review surface; same-identity GitHub runs
  use a PR comment because formal self-approval is unavailable.
- A direct PR-review request authorizes review mutations on the named PR only.
  Every merge-blocking finding is posted on the provider review surface; chat
  summarizes that record and never becomes the only home of a required change.
- Merge remains a separate operator-authorized action.
- Provider-native subagents, session messaging, and hosted agents are optional
  adapters, not Northstar protocol dependencies.
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

## Interfaces With Roadmaps

- `g01.001` uses this architecture to enact Northstar on Northstar and pilot
  the delivery layer inside this repo.
- `docs/contracts/004-language-quality-pack.md` governs the first language
  quality pack. Completed roadmap `g02.030` records production-boundary proof,
  implementation, fresh evidence, and distribution.
