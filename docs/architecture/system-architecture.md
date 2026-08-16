# System Architecture

Status: active
Owner: repo maintainers
Updated: 2026-08-16
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
- Agents append execution friction to root `PAPERCUTS.md`; maintenance promotes
  repeated or material items into the normal planning spine.
- `bundle-docs/`, `template-bundle/`, and `skills/` should be updated from this
  planning spine rather than by ad hoc repo edits.
- published skill propagation and source/install parity should remain explicit
  so multi-harness installs do not depend on manual operator memory.

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
published `main` and the operator has a repository-relative handoff path to give
the new thread. The worker must then run a quick startup worktree check. It reuses
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
- Before dispatch, the planning checkout must publish canonical planning state
  and one concrete worker handoff per approved worker lane under
  `docs/handoffs/` on `main`; local-only state is not a valid worker base.
- Parallel worker lanes are allowed only when their scopes, dependencies, and
  authority decisions are independent; otherwise the orchestrator keeps the run
  serial and records the reason.
- Each worker handoff is exactly one repository-relative path; no second prompt or
  copied private context is required.
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
- Merge remains a separate operator-authorized action.
- Provider-native subagents, session messaging, and hosted agents are optional
  adapters, not Northstar protocol dependencies.
- Papercuts remain an observation queue, not a competing planning authority or
  automatic work queue.

## Performance and Reliability Constraints

- Operator-facing docs should stay readable and direct.
- The repo should default to manual, concrete evidence before adding more
  automation.
- Validation should stay cheap enough that batch-level checks remain normal.
- Autonomy should increase only when the repo's planning artifacts make it safe.

## Interfaces With Roadmaps

- `g01.001` uses this architecture to enact Northstar on Northstar and pilot
  the delivery layer inside this repo.
