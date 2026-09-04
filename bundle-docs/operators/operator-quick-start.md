# Operator Quick Start

Use this page when you want to decide what to do next without wading through
the rest of the docs.

For the **one-page map** from posture to canonical doctrine files (before you
open long sections), read [`../protocol-kernel.md`](../protocol-kernel.md), then
[`../visual-map.md`](../visual-map.md) if you still need the hierarchy picture.

## Start With The Real First Question

Is this repo healthy and actively moving, or unclear and drifting?

### Healthy And Active

If the repo already has live docs and an active roadmap lane:

1. open the repo docs front door
2. open the generation index
3. open the active milestone
4. open the latest relevant log
5. use the governing contracts only when the milestone or log points at them

This is the shortest normal path to a valid next batch.

### Unclear, Missing, Or Drifted

If you cannot trust the current state:

- if contracts, authority, or system coverage are missing, the project still
  needs planning
- if the roadmap exists but no longer feels trustworthy, it needs recovery
- if you are not sure which of those is true, run the sweep pack first

- [sweeps/README.md](../sweeps/README.md)
- [08-planning-gate-sweep.md](../sweeps/08-planning-gate-sweep.md)

## Then Choose The Right Kind Of Work

Invoke the **`northstar`** skill and open
[`skills/northstar/references/router.md`](../../skills/northstar/references/router.md)
to pick one mode:

- No real planning yet -> planning: `plan-from-scratch`
- Existing project, planning quality uncertain -> planning readiness review:
  `northstar planning readiness review`
- Significant project/product/portfolio, long-horizon direction or strategic
  discovery -> Atlas: `northstar atlas`
- Existing project, all Northstar facets need checking -> project refresh:
  `northstar refresh`
- `/docs` has unexplained or legacy files/folders -> docs cleanup:
  `northstar cleanup` (inspect first; ask before uncertain rework or removal)
- Active codebase seam or architecture pressure -> architecture refocus:
  `northstar architecture refocus`
- A request needs clearer shared wording without advancing the work -> reframe:
  `northstar reframe`
- Planning, problem exploration, canonical promotion, or intake chat -> chatterbox:
  `northstar chatterbox` or `/northstar-chatterbox`
- Sound planning; need milestones or batches -> planning: `compile-roadmaps`
- Plan was right but changed -> recovery: `replan-after-change`
- Drifted or messy state -> recovery: `refocus-drifted-project` or `sweep-audit-repair`
- Research -> contracts/architecture -> `research`
- Bootstrap, migrate, or spine hygiene -> `normalize-docs`
- **Explicit** continuation brief / fresh thread -> `handoff` only (not bare `continue`)
- Rust quality during ordinary coding -> ask Northstar to use strict Rust
  quality; the agent installs missing activation, then continues the task
- Explicit Rust worktree or whole-repository audit-and-repair ->
  `/northstar-rust-audit worktree` or `/northstar-rust-audit repository`
- Explicit TypeScript/Svelte worktree or whole-repository audit-and-repair ->
  `/northstar-typescript-audit worktree` or
  `/northstar-typescript-audit repository`

## If You Want Clear Prompting, Say It Plainly

- “Plan this system before we build” -> `northstar` (plan-from-scratch)
- “Refresh this project under Northstar” -> `northstar` (project-refresh)
- “Refocus this subsystem's architecture” -> `northstar` (architecture-refocus)
- “Restate that in project language” -> `northstar` (reframe)
- “Explore this problem or side idea with me” -> `/northstar-chatterbox`
- “Run a planning readiness review on this existing project” -> `northstar`
  (planning-readiness-review)
- “Shape the long-horizon direction for this project with me” -> `northstar`
  (Atlas discovery first; do not ask Atlas to invent the strategy)
- “Lay out the next few roadmaps from the current contracts” -> `northstar` (compile-roadmaps)
- “Replan this after the contract change” -> `northstar` (replan-after-change)
- “Refocus this project under Northstar” -> `northstar` (refocus-drifted-project)
- “Turn this memo into contracts” -> `northstar` (research)
- “Audit and fix the current Rust tranche with no slop” ->
  `/northstar-rust-audit worktree`
- “Audit and fix this entire Rust repository” ->
  `/northstar-rust-audit repository`
- “Audit and fix the current TypeScript/Svelte tranche with no slop” ->
  `/northstar-typescript-audit worktree`
- “Audit and fix this entire TypeScript/Svelte repository” ->
  `/northstar-typescript-audit repository`
- **Coordinate a Northstar lane (runway, dispatch, gated merge)** -> `northstar` (orchestrator mode)

Rust activation is agent-installed and repository-owned. The agent discovers
Cargo and explicit toolchain paths, preserves existing instructions and
contracts, and asks only when repository policy such as MSRV or exclusions is
unresolved. Only `strict` is production-valid. Ordinary and high-assurance
profiles, a combined default, observable compaction resilience, and
certification remain unsupported.

TypeScript/Svelte activation is also agent-installed, but only after an explicit
audit request. The agent discovers root and nested package ownership, resolves
Svelte 5 and SvelteKit 2 overlays per owning package, and installs no
dependencies. Everyday TypeScript authoring, deferred toolchain/testing rules,
unsupported framework versions, slop-only mutation, and certification remain
unavailable.

During an orchestrator or refresh conversation, ask the agent to check
`docs/triage/` for open capture notes. Useful unresolved observations should be
written there before the agent follows one branch deeply; refresh and cleanup
should give each note a disposition.

If Paseo manages the project, copy or merge the optional `paseo.json` starter
from `skills/northstar/assets/templates/`. Its lifecycle invokes the helper in
the installed Northstar skill through `effigy skill run`; do not copy the Rhai
implementation into the project. The hook prepares sibling repos, runs the
project's real idempotent setup task, then replays machine-local
`effigy deps link` state. Tailor scripts and metadata instructions to the
repository rather than treating the starter wording as doctrine.

In this mode, the orchestrator commits and pushes the planning state and one
worker handoff under `docs/handoffs/` per dispatched lane before dispatch. The
operator receives each handoff's absolute path; no second prompt or copied
context is needed. Each handoff lists sibling repos to symlink into the worktree
container directory before project setup needs them.

In Paseo, workspace isolation and agent parentage are separate: the
orchestrator creates each lane's dedicated worktree workspace first, then
creates the worker as a child agent from its own scoped surface using that
returned workspace ID. Workspace placement does not detach parentage. Detached
root launches, schedules, generic detached runs, or unproven CLI substitutes are
rejected. Finish notifications remain enabled so the orchestrator receives
completion and resumes the same child for revisions. Without Paseo or when
scoped tools are absent, you get every absolute handoff path for manual launch
without pretended parentage.

You do not have to ask for parallel workers. The coordinator consumes the
canonical dispatch manifest and launches every approved ready-frontier lane
without a global thread budget.
A provider spend cap, quota, rate limit, or unavailable profile pauses
or reroutes only that lane; unrelated ready work keeps launching. If the
selected day-to-day route is unavailable, the orchestrator chooses another
adequate route from that lane's diversified pool rather than spending a
frontier worker. If
no suitable route remains, that lane keeps its handoff and workspace so recovery
does not duplicate the agent. Without a control plane you simply get every
absolute handoff path at once and launch as many as you want. You are never
asked to guess a worker count. A lane that stays serial must come with a named
reason — a dependency edge, a shared mutable or closeout surface, or unresolved
authority. Same-repo PRs still merge one at a time, and a changed or
conflict-resolved remaining head goes back to review before it can merge.

Ordinary workers draw from the cheapest adequate day-to-day pool, and the
orchestrator varies provider/model identity between runs instead of reusing
one remembered route. Frontier workers are rare: the lane must be both
exceptionally difficult after planning and highest-priority or materially
consequential, and the handoff records both
reasons. A risky but well-specified change can still use a capable non-frontier
worker; its independent review child keeps material review. A frontier review
route is reserved for residual risk that settled planning, explicit oracles,
and tests cannot bound. You can name a profile to
override. If no adequate profile fits, the orchestrator reports that gap
instead of silently spending the expensive one.

You can also spin off a lightweight planning delegate for one topic. It runs as
a same-workspace conversation, captures unique triage notes, and reports them to
Chatterbox for reconciliation and direct promotion.

Worker PRs normally receive an independent review child: the coordinator
creates it in the existing worker workspace with finish notifications and a
serial clean exact-head lease, and hands it the PR, canonical refs, and review
oracle. The reviewer posts the verdict on the provider, naming the exact
reviewed head. The coordinator does not duplicate the review; it verifies the
verdict head, findings, checks, ancestry, mergeability, and pause state before
merging. You can still ask the orchestrator thread to review a PR directly.

You can also ask the current orchestrator to hand its live lane to a fresh
orchestrator. It writes and pushes one ordinary seven-section handoff, then
yields that lane. With Paseo, the successor starts in a separate local workspace
for the same project, with a current orchestrator profile, the capitalized
`Orchestrator` label, and only the absolute handoff path as its prompt. Sidebar
pinning stays a manual click unless Paseo later exposes a native pin control.
Without Paseo you still get that absolute path and can launch the successor
yourself. The old thread is not archived or deleted as part of the transfer.

After a review requests changes, provider comments record the findings but do
not wake a finished worker. A Paseo-backed orchestrator must prompt the same
originating agent to read the comments, revise, validate, and push. It must not
silently launch a replacement.

When an independent review child accepts the exact current worker PR head and
the coordinator's merge gate holds, the orchestrator may merge that lane
without asking the operator again. A changed head, failed or pending check,
stricter repository rule, explicit operator pause, or ambiguous merge state
stops that path.

Chatterbox directly promotes operator-confirmed canonical planning and sends
the coordinator a provenance-labelled direction naming the promoted commit and
approved ready frontier. The coordinator verifies factual preflight, dispatches
workers, reports, and yields.

- “Create a handoff for the next thread” -> `northstar` (handoff mode)

Handoff mode writes a plain-spoken note to `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md`
and returns its absolute path. The operator should pass that path to the next
thread rather than copying the whole note into chat.

If humans are going to reuse the same opener across multiple threads, use:

- [strict-planning-starter-prompt.md](./strict-planning-starter-prompt.md)
- [project-refocus-starter-prompt.md](./project-refocus-starter-prompt.md)

## If You Need An Example

- Use [live-project-refocus-specimen.md](./live-project-refocus-specimen.md)
  to see what recovery looks like in practice.

## If You Are New To Northstar

Start here instead of wading through all docs:

1. [Visual Map](../visual-map.md) -- one-page overview of how everything fits
2. [Glossary](../glossary.md) -- terminology reference
3. [Cheat Sheet](../cheat-sheet.md) -- naming conventions and quick rules

## Normal Loops

Healthy active repo:

`repo docs -> generation index -> active milestone -> latest log -> next batch`

Drifted or unclear repo:

`sweep -> choose entry point -> repair/complete planning -> compile roadmap -> execute batch -> log -> handoff`

## Maintenance-Only Support

These are for maintaining Northstar itself, not for normal repo operation:

- [maintenance/README.md](../maintenance/README.md)

## Next task

Validate whether the new visual map and glossary actually reduce the time from
"open repo" to "start next batch" for active operators.
