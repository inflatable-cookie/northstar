# Northstar mode router

**Required first step** for every `northstar` invocation. Pick exactly one
route: a mode file under `references/modes/` (plus mode-specific refs under
`references/setup/` or `references/handoff-contract.md`), or — for a supported
language quality workflow — the installed-package route in
[`packages/installed-package-route.md`](./packages/installed-package-route.md)
via the language section below.

## Language quality workflow (explicit intent or existing activation)

Use only when the operator explicitly requests a language quality audit,
no-slop pass, whole-codebase review, audit-and-fix action, or everyday
authoring for a supported language — or when the consumer repository already
carries a registered activation marker for one. There is no embedded language
payload in core: the workflow routes through an installed package or stops.

Package selection is registry-owned and generic — routing never names a
package ID or a language branch. Supply explicit intent (language + workflow,
plus any requested overlay) or the consumer's exact activation marker to the
generic selection and installed-package route in
[`packages/installed-package-route.md`](./packages/installed-package-route.md).
A routed or newly activated result names the installed package's exact
`entrypoint_path`; open it and follow that package authority. Use the installed
skill's `northstar/language:route` task described in the package route. It owns
the durable per-user package store and verified first acquisition. A stopped
result scopes the failure to that language
workflow, reports the exact identity and the local installation route, and
leaves every other Northstar workflow usable. No embedded copy, alias, or
silent substitute exists.

## 1. Handoff (explicit only)

Use **only** when the user clearly wants a **fresh-thread artifact**, not
ordinary continuation:

- handoff, continuation brief, spin-off prompt, fresh thread, new thread, next
  agent thread, "write this up for the next agent"

**Do not** use handoff mode for:

- bare `continue`, "keep going", "context is full", compaction alone
- routine batch closeout without asking for a handoff file
- an orchestrator-owned planning delegate, implementation-worker, or
  orchestrator-continuation lane; use Orchestrator mode so the successor keeps
  planning, dispatch, PR review, merge, and promotion instead of writing another
  note or entering worker/delegate preflight

→ [`modes/handoff.md`](./modes/handoff.md)

## 2. Project refresh

Use when the operator wants one broad pass over an **existing project's current
Northstar state**, rather than one narrow review:

- `northstar refresh`;
- `northstar project refresh`;
- refresh, bring up to date, or check every Northstar facet.

This is normal mode. Do not run worker-mode worktree preflight, inspect
worker-local path configuration, start an orchestrator, or create a worker from
this route. Open `modes/project-refresh.md`; it checks instruction surfaces,
docs structure, architecture/authority, planning readiness, currentness,
validation, and distribution, then reuses one narrower route for the first
material blocker.

**Precedence:** An explicit worker/PR/orchestrator request wins. A specific
AGENTS review, planning-readiness review, or discovery request wins when the
operator does not ask for the broader refresh.

→ [`modes/project-refresh.md`](./modes/project-refresh.md)

## 3. Architecture refocus

Use when the operator wants a bounded review of current codebase architecture or
an improvement loop for a named subsystem, active lane, package, service, or
seam:

- `northstar architecture refocus`;
- `northstar codebase architecture review`;
- improve, challenge, or reassess the architecture of a named area.

Open `modes/architecture-refocus.md`. Inspect the selected area and produce a
small evidence-backed candidate set. Do not scan the whole codebase without a
scope, edit production code, start a worker, or promote a candidate silently.

→ [`modes/architecture-refocus.md`](./modes/architecture-refocus.md)

## 4. Planning readiness review

Use when the operator wants to test whether an **existing project's planning is
up to scratch** before continuing. The concise trigger is:

- `northstar planning readiness review`;

Start with a read-only planning-gate sweep. Inspect the current architecture,
inventory, repo authority, contracts, active roadmap, logs, research promotion,
and any readiness map. Classify the project as incomplete, drifted, materially
ambiguous, or coherent, then route to exactly one next mode: strict planning,
recovery/refocus, pre-execution discovery, architecture refocus, or roadmap
compilation. Do not edit production code or start a worker from this review.

→ [`modes/planning-readiness-review.md`](./modes/planning-readiness-review.md)

## 5. Atlas — long-horizon planning

Use Atlas when the operator wants discovery-first planning across a significant
project, product, platform, or portfolio horizon:

- `northstar atlas`;
- long-horizon planning, strategic runway, or multi-horizon direction;
- a request to connect vision, architecture, contracts, generation runway, and
  meaningful roadmap horizons.

Atlas is discovery-first, not prescriptive. It begins by eliciting and reflecting
operator direction before it offers horizon models, strategic options, or a
runway. It is not a readiness audit and not a short-term roadmap compiler. Once
operator direction is sufficiently grounded, it can shape strategic bets,
dependencies, non-goals, accepted uncertainty, and a coarse durable runway. It
remains plan-only and operator-owned. If the operator does not yet know the
project's aim, guide first-principles discovery or route away from Atlas rather
than inventing a destination.

If the request is an explicit orchestrator, worker, worktree, or PR loop, choose
**Orchestrator** mode instead. If the request is only to test existing planning
coherence, choose **Planning readiness review**. If coherent canonical surfaces
only need milestones, choose roadmap compilation.

→ [`modes/atlas.md`](./modes/atlas.md)

## 6. Pre-execution discovery

Use when the request explicitly concerns readiness mapping or the discovery
routes that precede ordinary planning:

- readiness mapping or a readiness frontier;
- intent rounds over the current frontier;
- destination-local project language;
- a decision prototype;
- an operator questionnaire for an unresolved decision;
- `northstar reframe` or a request to restate the current message in project
  language.

This is an internal mode of the single public `northstar` authority. It is
provider-neutral, plan-only, and non-mutating by default; it cannot clear a map,
make a card ready, or replace normal spec, promotion, roadmap, or operator gates.

**Precedence:** If the user explicitly asks for an orchestrator thread, separate
worker/worktree preparation, or PR review around a readiness/discovery lane,
choose **Orchestrator** mode even when the request also mentions readiness or
discovery; treat discovery as the Orchestrator's planning lane. Direct
readiness, intent, project-language, decision-prototype, questionnaire, or
reframe
requests without that orchestrator/worker/worktree/PR language remain
**Pre-execution discovery**.

→ [`modes/pre-execution-discovery.md`](./modes/pre-execution-discovery.md)

## 7. Direct PR review

Use when the user asks the current thread to review an existing pull request,
especially when a fresh thread receives only a PR URL or number. This route
reviews the PR independently and publishes the verdict on the hosting
provider. Every blocking finding must appear on the PR; chat is only the
operator summary.

An explicit request to manage the surrounding discovery, planning, worker, or
closeout loop remains **Orchestrator** mode. A direct review request does not
activate worker mode or the worker startup preflight.

Orchestrator-launched review children use this same mode in the worker's exact
existing workspace: creation passes the retained worker `workspaceId`, creates
no review workspace, and verifies the returned placement. Re-review resumes the
retained reviewer `agentId` in that workspace. The reviewer holds a serial clean
exact-head lease and posts a provider verdict naming the exact reviewed head.

→ [`modes/pr-review.md`](./modes/pr-review.md)

## 8. Orchestrator thread

Use when the user wants Northstar to coordinate a lane: consume the canonical
dispatch manifest, verify factual prerequisites, launch the approved frontier,
place cross-model review children (distinct underlying provider/model identity)
in worker workspaces with serial clean exact-head leases, advance continuously
across merge, closeout, and next-ready dispatch without an operator `continue`,
route a worker's pre-PR semantic decision blocker to Chatterbox instead of
questioning the operator directly, notify Chatterbox administratively only when
the runway is empty, and own the merge gate; or
continue from a committed `orchestrator-continuation` handoff. Canonical
planning and promotion belong to Chatterbox. This is an internal mode of the
single public authority; the operator relays messages between threads when no
control-plane tools are available. When Paseo injects its orchestration tools,
the mode uses them for routine dispatch without a separate permission prompt.

→ [`modes/orchestrator.md`](./modes/orchestrator.md)

## 9. Agent instruction review

Use when the user explicitly asks for an always-loaded instruction-surface
review, especially:

- `northstar AGENTS file review`;
- review, audit, optimize, or compact `AGENTS.md`;
- review the root `CLAUDE.md` bridge alongside `AGENTS.md`;
- reduce agent-context noise or improve agent-run efficiency.

This mode is target-repository-aware and docs-only. It must not inspect
Northstar's own files when the target is a consumer repository.

→ [`modes/agent-instruction-review.md`](./modes/agent-instruction-review.md)

## 10. Docs cleanup

Use when the operator wants an active inventory of files or folders under
`/docs` that do not fit Northstar, with clear drift reworked into canonical
homes rather than blindly purged:

- `northstar cleanup`;
- `northstar docs cleanup`;
- inspect, classify, normalize, or prune an existing `/docs` tree.

This is a docs-only maintenance route. Inspect unfamiliar paths and their
references before proposing a move or removal. Ask the operator whenever the
destination, ownership, meaning, or deletion consequence is uncertain. Include
`docs/triage/` in the inventory and give every triage note a disposition.

→ [`modes/cleanup-docs.md`](./modes/cleanup-docs.md)

## 11. Normalize docs posture

Use when the job is **repo shape and spine health** (initial or ongoing):

- set up / bootstrap / migrate / normalize under Northstar
- fix or refresh docs front doors, generation index, Effigy wiring
- lane-first strict adoption, install working-rules / specs / archive surfaces
- keep the docs tree aligned with doctrine over time

→ [`modes/normalize-docs.md`](./modes/normalize-docs.md)

## 12. Research

Use when **external evidence** must become architecture or contracts before
roadmap work bets on it.

→ [`modes/research.md`](./modes/research.md)

## 13. Recovery

Use when planning **was valid but state is now untrustworthy**:

- drifted, stale, contradictory front doors or roadmaps
- replan after contract or boundary change
- sweep-led audit/repair of the docs spine

If planning coverage is **still missing**, use plan-from-scratch instead.

→ `replan-after-change.md`, `refocus-drifted-project.md`, or
`sweep-audit-repair.md`

## 14. Planning (default for implicit work)

Use when the job is **planning or sequencing** and recovery is not the main
problem:

- plan from scratch, contracts, specs, promotion, compile roadmaps/milestones
- next milestone, next batch, readiness, continuation envelope
- tighten guardrails so execution cannot outrun contracts

Choose one:

| Situation | Mode file |
| --- | --- |
| Missing architecture/inventory/contracts | [`plan-from-scratch.md`](./modes/plan-from-scratch.md) |
| Change still in provisional specs | [`shape-with-specs-and-promote.md`](./modes/shape-with-specs-and-promote.md) |
| Canonical surfaces exist; need milestones/cards | [`compile-roadmaps.md`](./modes/compile-roadmaps.md) |

## 15. Chatterbox planning and intake

Use when the operator wants to explore problems, plan, reconcile triage notes,
promote canonical planning directly after confirmation, or send direction to
the coordinator; or when the thread is already a chatterbox:

- `northstar chatterbox`;
- `/northstar-chatterbox`;
- "you're a chatterbox on X", or exploratory intake/planning chat;
- an already-spawned chatterbox thread.

This is an internal mode of the single public `northstar` authority. A chatterbox
is the primary human-facing planning authority. It shares the checkout, creates
unique timestamped `docs/triage/` notes for new issues, updates existing notes
in place, and prunes them during promotion with exact-path git isolation. It
reconciles triage notes and directly promotes canonical planning on the
integration branch after explicit operator confirmation, and sends
provenance-labelled direction to the coordinator. It does not implement
product/runtime code, supervise workers, review PRs, or merge.

**Precedence:** Explicit orchestrator, worker, planning-delegate, continuation,
or PR-review requests keep those routes. A chatterbox asked to implement product
code, review PRs, or merge refuses and points at the orchestrator.

→ [`modes/chatterbox.md`](./modes/chatterbox.md)

## Orchestrator-continuation activation

This path applies **only** when a committed handoff declares all three fields:

```yaml
handoff_mode: orchestrator-continuation
orchestrator_mode: economical-coordination
dispatch_authority: orchestrator
```

The successor opens [`modes/orchestrator.md`](./modes/orchestrator.md) and
continues as a normal orchestrator thread. It does not run the worker startup
fast path, planning-delegate preflight, or generic handoff-writing mode. Reject
the launch before those other routes if the successor was aimed at worker,
planning-delegate, or handoff mode.

## Worker startup fast path

This fast path applies **only** to worker mode. Activate worker mode by first
reading the handoff path supplied by the orchestrator — the operator-facing
path is always absolute — and confirming its frontmatter declares:

```yaml
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
```

Normal-mode agents, planning/orchestrator threads, review threads, and agents
that merely happen to be inside a worktree do not run this probe and do not
inspect `.agents.local.env` for worker purposes. Do not infer worker mode from a
branch name, filesystem path, or harness presence. If the dispatch metadata is
absent, stop the worker launch and report the missing handoff boundary.

A planning delegate is an optional same-workspace conversation that captures
unique triage notes and reports to Chatterbox. It does not activate this
implementation worker fast path. An `orchestrator-continuation` handoff follows
Orchestrator mode and does not activate this path.

After worker mode is activated, before broad repository reads, run one quick
read-only probe from the current context:

```sh
git rev-parse --show-toplevel
git branch --show-current
git status --porcelain
git worktree list --porcelain
```

If the current root is a registered worktree, the status is empty, and the branch
is not `main`, reuse it as the launcher-provided worktree. Record its actual
root/branch and do not compare generated path or branch names with a handoff
placeholder. Do not create another worktree merely because those values differ.
Only a `main`, dirty, unregistered, or otherwise unusable current context may
proceed to the named handoff worktree and then the manual local-path fallback.

Do not run `effigy tasks`, `effigy doctor`, broad repository reads, or discovery
commands before this decision. After the worktree is selected, run
`GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`,
then confirm `HEAD == origin/main`, the planning base is an ancestor, and the
repository-relative handoff exists in that `HEAD`. Load the tracked handoff
from `HEAD`; if the absolute dispatch file differs, stop. That `HEAD` copy is
canonical. Only then verify **required sibling worktree links** from it in the
worktree container directory. In a launcher-managed worktree they must already
exist before project setup; stop if one is absent. In a manual fallback,
canonicalize source and destination and create an absent link. Reuse only a
symlink that already resolves to the declared source; stop on any other
existing path; never delete, replace, or overwrite. If a listed source is
missing, stop and report; do not skip a catalog member. Then continue with the
normal mode-specific checks.

## Posture label (all modes except handoff)

Name repo posture early: `baseline-routing`, `strict-ready`, `strict-paused`,
`migration`, or `drifted`.

## Shared reads

After choosing a mode (and after the worker startup fast path when applicable):

```sh
effigy tasks
effigy doctor
```

Then read the target repo's available `README.md`, `AGENTS.md`,
`docs/README.md`, and `docs/contracts/001-working-rules.md` before loading
mode-specific paths.

Repo paths written as code literals are resolved from the target workspace,
not from this installed skill folder. When the target is the Northstar source
repo, also read `bundle-docs/protocol-kernel.md`. Consumer repos normally do
not contain `bundle-docs/`; its absence is not a contract gap.
