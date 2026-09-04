# 07 Delivery Framework and Autonomy

Status: active
Updated: 2026-09-01

## Why this section matters now

Northstar's planning spine is useful, but complex projects still drift when
agents can treat roadmap milestones as loose suggestions rather than tightly
defined delivery paths. The recurring failure mode is not only bad planning. It
is weak execution grammar: mockups pass as completion, UI complexity grows
without product need, partial work is treated as done, and operators have to
keep typing "continue" just to maintain momentum.

This section defines the delivery layer that sits underneath planning and makes
autonomy safer. The goal is to reduce improvisation after planning is complete
and make long agent runs possible without special prompting.

## Scope

Define the delivery artifacts, autonomy rules, and anti-failure guardrails that
turn approved planning into constrained execution.

This section governs:

- product guardrails
- definition of done
- execution autonomy policy
- master specs
- batch cards
- deviation and stop rules

It does not replace vision, specs, architecture, contracts, roadmaps,
research, or logs. It tightens what must happen between roadmap intent and
claimed completion.

## Repo posture classification

Northstar work gets easier when the repo's live state is named explicitly
before setup, planning, recovery, or execution continues.

Use this compact posture model:

- `baseline-routing`
  healthy baseline spine, no stricter execution lane claimed
- `strict-ready`
  stricter spine, active spec lane, and one honest ready card or ready chain
- `strict-paused`
  stricter spine, active lane, but no honest ready card yet; planning or
  intent must resolve first
- `migration`
  repo is moving from baseline or lane-first posture toward fuller strict
  compliance
- `drifted`
  front doors, canonical refs, or live planning surfaces are no longer
  trustworthy enough to continue execution

Whenever posture matters, also name:

- authority mode: root-owned or nested docs-authority
- current active lane
- whether a ready card exists
- whether an intent checkpoint still blocks the next move

## Delivery chain

For material work, the expected chain is:

`vision -> research/specs -> architecture + contracts -> roadmap milestone -> execution -> evidence -> closeout`

Specs are the planning layer here, not the final authority. Once a change is
accepted, its durable outcomes should be promoted into architecture/contracts
before roadmap execution relies on them.

## Canonical delivery artifacts

Projects using the stricter mode should carry these artifacts:

- `docs/architecture/product-guardrails.md`
- `docs/specs/NNN-<slug>.md` for master specs
- `docs/roadmaps/gNN/batch-cards/NNN-<slug>.md` for execution cards
- `docs/contracts/NNN-<slug>.md` only when a separate contract surface is worth
  the extra split

Use them as follows:

- `product-guardrails.md`
  locks simplicity, UX direction, anti-fake-work rules, and constraints that
  should apply across multiple milestones
- master specs
  define the provisional realization plan for a goal or epic before its durable
  outcomes are promoted
- batch cards
  define the exact execution unit an agent may work through without making fresh
  planning decisions
- separate contracts
  are reserved for durable seams, authority boundaries, or other rules that
  need to stand apart from architecture/specs

For many projects, definition of done and execution autonomy can live in a
compact working-rules artifact rather than as multiple separate contracts.

## Product guardrails rule

Every project should define a small set of cross-cutting rules that make bad
default behavior harder.

At minimum, product guardrails should explicitly cover:

- simplicity expectations for operator experience and UI
- anti-placeholder rules
- anti-mockup rules
- complexity caps or design constraints where relevant
- what should be treated as a stop condition rather than "good enough for now"

## Execution guardrail pack

For autonomy-sensitive projects, the guardrail pack should make five things
explicit:

- real over representational
  - do not stop at mockups, placeholders, or token scaffolding if the batch was
    supposed to land working behavior
- simplicity over flourish
  - do not add UI or interaction complexity unless the product need is explicit
    in the governing refs
- integration over isolated gesture work
  - partial seams, fake adapters, and disconnected surfaces do not count as
    completion for an end-to-end batch
- follow-through over convenient stopping points
  - when a batch promises a realized user or operator path, carry the work to
    the contract-valid end state or mark it incomplete
- explicit incompleteness over implied closure
  - if the remaining path is still scaffolded, mocked, or unproven, record that
    limit instead of claiming the milestone is effectively done

## Papercut feedback loop

Execution also carries a lightweight feedback loop. When an agent meets small,
solvable friction, it appends a short note to the owning repository's root
`PAPERCUTS.md` before continuing. The agent creates the file if it is missing;
no operator prompt is required. Adopt/upgrade installs must seed the starter
before release-candidate / exact-SHA prep so tag closeout does not dirty a
green clean-tree SHA. Papercuts do not pause the active task or become
automatic roadmap work. Use [`../papercuts.md`](../papercuts.md) for the entry
shape, exclusions, ownership rule, timing, and later triage path.

## Refactoring posture by release maturity

Agents often add compatibility aliases, shims, and silent fallbacks during
refactors. That is usually wrong noise **before v1.0**, and often mandatory care
**once a product or library has shipped v1.0-level stability expectations**.

- **Pre-1.0:** forbid opportunistic compatibility layers. Prefer clean migration:
  update references, rename in place, delete superseded paths in the same batch.
  If a change is breaking or needs a phased rollout, **stop and ask the
  operator** for a decision instead of inventing a shim.
- **v1.0 and later:** default to preserving expected behavior for stable,
  user-visible, or externally depended surfaces. Compatibility or deprecation
  timelines are owner decisions, but agents should not casually narrow behavior
  or delete supported paths without explicit policy.

## Definition of done rule

Completion should be evidence-based, not prose-based.

Work should not be marked done unless:

- the intended behavior exists for real, not as a mockup or placeholder
- dependent files and references are updated coherently
- required validation was actually run
- the relevant roadmap/spec/card state was updated
- a batch log or equivalent evidence exists
- the next task is clear

## Continue semantics

In a strict repo, the operator should not need a giant reminder prompt just to
keep a lane moving.

The intended default is:

- the operator says `continue`
- the thread resolves that through the previous closeout's `Next Task`
- that `Next Task` normally points at the current ready batch card
- the ready batch card defines the bounded work, stop conditions, validation,
  and closeout requirements

That means a bare `continue` is valid only when the file state already makes
the next move explicit.

If the previous `Next Task` does not point at a real ready card or explicit
stop/reassessment step, the lane is not continuation-ready.

## Runway rule

Northstar planning should not produce a one-card-at-a-time fake runway.

Generation READMEs own the coarse `## Generation Runway`; roadmap milestones
own lane shape; batch cards own step detail. A material roadmap should derive
from the generation runway, then name several batches (and, in strict posture,
several batch cards) — not one agent turn. Checkbox task lists in roadmap
execution plans make that lane runway scannable. Full granularity doctrine:
[03-roadmaps.md](./03-roadmaps.md) (*Scope and granularity rule*).

When a material lane needs planning, the output should usually include:

- the generation runway goal the lane is trying to realize
- the current ready card or paused gate
- the next few meaningful batches or milestone transitions beyond that card
- the next planning checkpoint where strategy or intent may need to be
  reconsidered

The point is not to pretend the whole program is fully known. The point is to
avoid a loop where the thread executes one card, then makes up the next card,
then repeats that cycle indefinitely under stricter-looking paperwork.

Good planning leaves both a generation runway and a bounded execution runway.
Both may still contain uncertainty, but they should make the program shape and
lane shape visible beyond the immediate card.

## Intent checkpoint rule

Planning should not pretend to know the user's preference when the path is
still materially ambiguous.

When planning is needed and the next direction is not clearly determined by
the existing authority surfaces, the thread should:

- stop before inventing the next lane or batch
- name the main plausible directions briefly
- ask the operator for intent or priority

Use this intent checkpoint especially when:

- more than one reasonable next lane or batch exists
- a milestone may close, continue, or hand off
- the choice depends on product tradeoffs or prioritization rather than missing
  file updates

Do not hide this ambiguity behind overconfident planning churn.

## Closeout pattern

Closeout should be an ordered sequence, not a loose reminder to "update the
docs."

For a meaningful completed batch or stopping point, the minimum closeout order
is:

1. update the current batch card so its status and completion notes reflect the
   truth
2. update the active roadmap milestone if the batch changed milestone progress,
   readiness, or the next batch
3. refresh any front-door or currentness surfaces that still name the active
   lane, current ready card, or recent evidence chain
4. write the batch log with the evidence, validation actually run, and any
   unresolved blockers or limits
5. update or create a handoff only when another thread really needs to take
   over
6. leave one explicit next task in the highest-authority active surface that
   still governs the lane

If the lane is stopping because the next work is not ready, the closeout should
say that explicitly rather than pretending the sequence naturally continues.

## Operator-facing summary rule

Northstar closeout should not read like compliance theatre.

The normal operator-facing message should make three things easy to scan:

- what changed
- what state the lane is now in
- what the next move is

Validation and protocol detail still matter, but they should sit underneath
that summary rather than replace it.

Bad pattern:

- lead with card ids, file churn, and long validation lists
- make the operator infer the actual outcome from the paperwork

Better pattern:

- one or two plain sentences on the achieved result
- one short statement of current lane state
- short validation note only when it failed or materially affects confidence
- one short statement of the next move

Use that as the closeout or meaningful checkpoint shape, not as a script for
every small in-thread message.

## Conversation and selective compression rule

Northstar should use a natural, human conversational tone in agent chat and
normal thread replies. Keep useful recommendations and next steps, and make it
easy for the operator to respond, think aloud, or redirect.

Orchestrator threads stay direct and human — explain state, trade-offs, and
next dispatches without protocol recitation — but material product exploration
is chatterbox work, not coordinator work.

Use compressed, high-density writing for internal execution artifacts:

- batch cards
- roadmap milestones
- logs
- internal contracts and working rules

That means:

- no filler intros
- no ceremonial politeness
- no repeated restatement of the same point
- prefer short bullets and clear structure when still readable
- do not force telegraphic fragments or dry status-report language into thread
  conversation

Do not apply that style blindly to public-facing or explanatory material.
User-facing docs, onboarding, tutorials, and rich architectural explanation may
still need normal prose.

The goal is not caveman performance art or status-report theatre. The goal is
clear thinking, useful recommendations, and enough signal without losing the
human conversation.

## Master spec rule

Use a master spec when a goal:

- spans more than one meaningful batch
- changes user-facing behavior
- introduces new contracts or operational policy
- requires non-trivial rollout, migration, or validation planning
- affects more than one repo, package, or authority surface

The master spec should define:

- the problem
- target operating model
- goals and non-goals
- artifact set and dependencies
- phased delivery plan
- validation strategy
- stop conditions and open questions

Before execution of material implementation work, the spec should no longer be
the only place that durable structure or behavior is defined.

## Batch card rule

Batch cards are the paint-by-numbers execution unit.

Every ready batch card should define:

- exact objective
- governing spec, roadmap, and other authority refs
- scope boundaries
- ordered implementation steps
- acceptance criteria
- validation commands
- evidence required for closure
- stop conditions
- whether the next card should auto-start (default: yes if ready)

For an issue-fix card whose root cause is not yet known, those steps define the
bounded problem-solving loop, not a guessed patch. The card is ready when it
states the observed failure, expected behavior, reproduction or acceptance
evidence, scope boundaries, validation, and stop conditions. It does not need to
preselect the root cause or exact files to edit. Inside that envelope, the worker
may reproduce, instrument, diagnose, choose the smallest complete contract-valid repair,
remove temporary diagnostics, and validate the result.

Batch cards sit inside a larger lane runway.
They should not be treated as the only visible planning horizon when a lane is
large enough to justify a master spec and roadmap milestone.

If a batch card still requires material product or system decisions, it is not
ready.

## Review oracle rule

A ready card needs a review oracle when acceptance depends on a high-risk seam
or a universal, exact, or negative claim. Typical triggers are concurrency,
lifecycle, identity, persistence, security, public APIs, deployment,
multi-version behavior, or words such as `all`, `every`, `never`, `exact`,
`stale`, `foreign`, and `mismatch`.

Keep the oracle compact. For each exposed invariant, name:

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| `<claim>` | `<smallest case that would falsify it>` | `<where rejection or containment occurs>` | `<test, check, or evidence>` |

The oracle operationalizes acceptance; it does not preselect the implementation.
A card is not ready when the reviewer would have to invent a material acceptance
condition during review.

## Ready-state rubric

Treat `ready` as a real execution state, not a hopeful label.

A single batch card is ready only when all of the following are true:

- the card status is explicitly `ready`
- the objective is bounded enough to finish without fresh design or planning
  decisions
- the governing refs point at current canonical surfaces rather than only
  provisional planning notes
- scope boundaries and stop conditions are explicit
- acceptance criteria, validation, and evidence requirements are explicit
- a review oracle is present when high-risk or universal acceptance needs one
- no unresolved planning gap still governs the card's scope
- no unresolved intent checkpoint still governs the card's scope
- the next task points either to the next ready card or to the correct stop or
  promotion step
- the previous closeout leaves a `Next Task` that makes a bare `continue`
  unambiguous

A short autonomous chain is ready only when:

- each card in the chain is individually ready
- the cards all belong to the same active roadmap/spec lane
- the card order is explicit
- each handoff between cards is already represented in file state rather than
  depending on fresh judgment
- auto-start is allowed on each transition that should continue without
  operator intervention
- the chain stays inside the project's autonomy envelope

If any of these checks fail, the work is not ready for hands-off execution.

## Worker pre-PR adversarial pass

After normal validation and before opening or updating a PR, the worker rereads
the diff against the card and tries to falsify it. Enumerate universal, exact,
and negative claims; map each review-oracle row to proof; exercise the named
counterexamples; and reconcile card, roadmap, log, handoff, and front-door state.
If this exposes a new product threshold, contract choice, or acceptance rule,
stop and return it to planning instead of choosing it in implementation.

## Review finding classification

Classify each merge-blocking finding so revision evidence distinguishes worker
execution from planning quality:

- `execution-miss`: the worker missed explicit authority or acceptance;
- `oracle-gap`: the card did not operationalize a foreseeable counterexample;
- `planning-change`: review introduced or changed product or contract intent;
- `validation-gap`: required proof was absent or falsely green;
- `integration-drift`: surrounding callers, generated state, or closeout surfaces
  no longer agreed.

A `planning-change` returns to the planning/card boundary before worker revision.
Track codes per finding or review cycle; do not infer handoff quality from raw
cycle count alone.

## Issue-fix dispatch rule

Dispatch issue fixes by outcome, not by the first investigative step. When the
operator reports a defect and asks for a fix, the assigned worker lane includes
reproduction, diagnosis, implementation, cleanup of temporary instrumentation,
validation, evidence, and a reviewable PR. Investigation is work inside that
lane; it is not a completed deliverable by itself.

An orchestrator may dispatch a diagnostics-only lane only when the operator
explicitly asks for evidence without a fix, or when a named authority, access,
planning, or safety blocker makes implementation impossible inside the current
envelope. The handoff must say that the outcome is diagnostic and must not
present temporary instrumentation or a root-cause report as completion of a fix
lane.

The worker owns bounded causal and implementation judgment inside a ready fix
card. It should continue from diagnosis into the smallest complete contract-valid repair
without asking the operator to approve ordinary code-level choices. It stops
when the diagnosis reveals a material scope expansion, contract change,
unresolved product choice, missing authority/access, or validation result that
changes the plan.

In a strict lane, the normal operator shortcut should be:

- `continue`

not:

- a long recap prompt that restates the card, closeout protocol, and boundaries

If a lane still needs giant continuation prompts in ordinary use, the repo
surfaces or local agent contract are under-specified and should be tightened.

## Autonomy support levels

Northstar supports more than one useful operating mode.

- baseline roadmap mode
  - a repo using the baseline spine can still support healthy active-lane
    routing, clear milestone sequencing, and shorter bounded runs driven by
    roadmap, contract, and log surfaces
- lane-first stricter mode
  - a mature baseline repo may add `docs/specs/` and batch cards for one active
    lane when that lane needs explicit continuation-envelope, lane-budget, and
    pause-signal state without forcing a repo-wide rewrite first
- stricter delivery mode
  - a repo that broadly wants the fuller paint-by-numbers execution layer
    should adopt `docs/specs/` and batch cards as a standing surface

Lane-first stricter adoption is the migration entry point, not the long-term
doctrinal destination. When a project is expected to live under the strict
Northstar framework, the intended end state is full stricter compliance across
the project rather than a permanent mixed posture.

Do not over-promise autonomy from a roadmap-only repo. The baseline spine can
be valid and productive, but it is not the same thing as the stricter
paint-by-numbers execution layer.

Do not install the stricter layer mechanically either. Use it when longer
hands-off runs, tighter anti-drift guardrails, or more explicit execution state
are actually needed. In a mature baseline repo, prefer lane-first adoption
before a full repo-wide rewrite when the need is local to one active lane.

## Full strict compliance

For projects that are meant to live under the strict Northstar framework, full
strict compliance should mean all of the following are true:

- the project carries the stricter docs spine as a normal working surface, not
  only on one provisional lane
- active material work is governed through specs and batch cards rather than
  roadmap prose alone
- architecture and contracts are current enough that roadmap execution is
  compiled from canonical surfaces rather than inferred later
- product guardrails, working rules, and closeout expectations are explicit and
  used in normal execution
- currentness surfaces, spec hygiene, and archive posture are maintained as
  routine work rather than occasional cleanup

Treat this as a project-level operating state, not just the presence of a few
files.

## Migration phases

Mature projects moving to full strict compliance should usually pass through
these phases:

1. baseline posture
   - the repo has the baseline spine and coherent active-lane routing
2. lane-first stricter adoption
   - one active lane uses specs and batch cards to prove the stricter surface
     works in the real project
3. expanding strict coverage
   - the stricter spine becomes the default for new material lanes and the
     standing project surfaces are upgraded accordingly
4. full strict compliance
   - mixed-mode operation is no longer the norm and active work runs under the
     strict delivery layer by default

Projects should not remain in phase 2 or 3 indefinitely without an explicit
reason. Once the stricter surface is proven and the project is meant to live
there, mixed posture should be treated as migration debt rather than a stable
operating model.

## Migration checkpoints

Before a project claims full strict compliance, the minimum checkpoints should
be true:

- the stricter spine is present at project level, not only in a one-off lane
- at least the active material lanes use specs and batch cards as the execution
  unit
- product guardrails, working rules, and contract indexing are explicit and
  current
- roadmap milestones point at canonical architecture/contracts and ready cards
  rather than relying on prose-only next steps
- logs and handoffs reflect the closeout sequence and execution state expected
  by the strict doctrine
- closed planning artifacts are archived or retired cleanly enough that
  `docs/specs/` still reflects live planning

## Autonomy rule

Autonomy should be pre-authorized through artifacts, not recreated by operator
intervention.

When a thread has a ready runway of multiple cards, the default behavior is to
continue through them without pausing for operator acknowledgment at every
boundary.

An agent must continue across consecutive ready batch cards when all of the
following are true:

- the cards belong to the same active spec/roadmap lane
- the governing architecture/contracts exist
- the prior card's evidence gate passed
- the execution policy for the project allows auto-continuation
- no stop condition has been triggered

The agent should only pause and wait for operator input when:

- the next card is not yet ready
- a stop condition is triggered
- the runway ends and planning is needed to generate the next batch
- an intent checkpoint requires operator direction

Operators should not need to keep sending "continue" when the next ready card
is already defined and permitted.
They also should not have to re-invent the lane shape after every completed
card because planning failed to leave a longer-horizon runway.

## Parallel lane scheduling

Parallelism is a scheduling default, not an operator-requested optimization. An
orchestrator maps the runway's meaningful lanes as a dependency graph, keeps a
current ready frontier, and refreshes that frontier at every dispatch
checkpoint. It launches every safe frontier lane without a global worker-slot budget
instead of following one lane through dispatch, review, and merge.

A lane belongs on the frontier only when it has:

- no shared mutable files or overlapping write scope;
- no ordering, data, or generated-artifact dependency;
- no overlapping authority decision or unresolved intent;
- its own ready cards, acceptance, validation, evidence, and stop conditions;
- its own worktree, branch, and committed handoff.

Same-repository lanes must additionally partition their mutable and
closeout/front-door surfaces, or reserve one named orchestrator integration
step before launch. Two workers never own the same front door.

When a condition fails, keep only that edge or lane serial and record the exact
dependency, shared surface, or unresolved authority. Unrelated ready work is
not serialized around one blocked edge. A provider, model, or profile quota,
spend, rate, or availability failure is lane-local routing state,
not a reason to serialize the rest of the frontier. Parallelism is never a
reason to invent
a speculative card, or to split one coherent issue-fix lane into diagnosis and
repair workers.

Paseo workspace isolation and agent parentage are separate axes. The
orchestrator creates each worker lane's dedicated `branch-off` worktree
workspace first, then creates the worker as a child agent from its own
agent-scoped surface using that returned workspace ID. Workspace placement
does not detach parentage: the child remains attached to the orchestrator, and
Paseo delivers finish, error, and permission notifications to the parent. A
top-level/root-agent launch, schedule, generic detached run, or unproven CLI
path is rejected for automatic worker dispatch. Finish notifications remain
structural and enabled; reject launch configuration before creation if
notifications are disabled. Review follow-ups resume the same child agent
identity rather than creating a detached replacement.

A control-plane workspace or agent creation failure belongs to that lane's
transport state. Preserve every returned workspace or agent identity so an
ambiguous attempt is not duplicated, then continue launching unrelated lanes
whose transport state is clear. Mark only the refused provider or profile route
unavailable and choose another adequate route from the lane's diversified pool.
Do not promote an ordinary lane to frontier merely
because its day-to-day route is unavailable. If no suitable route remains,
pause only that lane, preserve its committed handoff and workspace state,
report the provider/profile gap, and continue every unrelated ready lane.
Recovery reuses the retained authority chain; it does not trigger compensating
polls, create a duplicate worker, or require a rebrief.

Where no control plane or scoped tools are available, return the committed
handoff's absolute path for manual launch without pretending parentage exists.
Northstar names no fixed worker count, provider, model, or scheduler daemon,
and never asks the operator to guess a count.

While workers run, the orchestrator continues non-overlapping planning, review,
revision routing, merge, and closeout rather than idling on one lane. A
worker-finish notification starts review of that lane; it does not refill a global launch queue.

Every gate survives concurrency. Each worker keeps its own worktree, branch,
handoff, PR, review loop, and exact-head merge gate. Same-repository PRs merge
one at a time; after each merge the remaining heads are refreshed against
current `main` and any changed or conflict-resolved head is reviewed again.

## Economical worker routing

Worker routing is economical and diversified by default. Select by current
role-profile notes, not stored model IDs. For every worker, planning-delegate,
or fresh-orchestrator run, build the adequate pool for the role from those
notes and any explicit adapter cost metadata, prefer the cheapest adequate
tier, then vary provider/model identity before reusing a recent route.
Adequacy comes before price or rotation: an inadequate cheap route is
excluded, never rotated into. Adapter-visible recent-agent history is
evidence when available; otherwise the orchestrator remembers only the routes
it launched in the current run. Northstar keeps no durable usage ledger and
stores no profile, provider, model, price, balance, or allowance value.

Task size, file count, duration, documentation churn, or the bare presence of a
security, persistence, concurrency, public-API, deployment, or multi-version
surface does not by itself make a worker lane frontier work. Long mechanical
audits and broad documentation jobs prefer fast/low-cost or mechanically
oriented profiles when their decisions and repair boundaries are already
settled.

A frontier implementation worker is a conjunctive exception. Use it only when
the lane is both highest-priority or materially consequential **and** the
handoff explains why planning, the review oracle, exact-head review, and
repository validation cannot adequately bound the remaining reasoning, and
the selected profile's notes explicitly fit that combination. Record both
reasons in the handoff and rotate within the adequate frontier pool too.
Priority alone, complexity alone, broad scope, or a risk-domain label is
insufficient.

Keep frontier/high effort for material operator-facing discovery, review-
oracle design, and operator-facing planning delegates; the coordinator's own
normal route is economical. Risky surfaces still require a clear review
oracle and material independent review; a material but settled lane may use a
capable non-frontier worker while its independent review child keeps material
review. Worker price is not the review-strength control. Pause before dispatch
when the review oracle is not explicit.

When multiple plausible designs or an unresolved contract choice remain, return
to planning rather than spending a frontier worker to choose architecture. A
refused route is removed only for that attempt; choose another adequate route
from the lane's diversified pool instead of treating the refusal as global
capacity. If no adequate route remains, report the profile gap instead of
silently promoting the lane to frontier. An operator-named profile remains an
explicit override even when rotation would choose differently.

## Economical orchestrator coordination

Coordination is the orchestrator's default job: mechanical delivery
management. It maintains the approved ready frontier from the canonical
dispatch manifest, launches every safe ready lane, creates and resumes child
workers in dedicated worktree workspaces, creates review children in the
existing worker workspace under a serial clean exact-head lease, verifies the
coordination gate, merges, and closes out. It does not repeat full planning or
semantic review for a settled lane; it escalates when a factual conflict,
review, or repository state leaves a real judgment unresolved. Small
operational clarifications that cannot change behavior, acceptance, public
contract, or sequencing stay with the coordinator.

Planning path: Chatterbox is the primary planning authority and promotes
confirmed canonical planning directly on the integration branch. The
coordinator loads only the instructions, promoted commit, selected cards,
dispatch manifest, and named refs needed for factual preflight (narrow fast
path). It does not sweep unrelated planning, design dependency edges, compile a
duplicate semantic handoff, or launch promotion-only workers.

Review path: every worker PR gets an independent review child in the existing
worker workspace with finish notifications enabled (`notifyOnFinish: true`),
selecting an economical adequate review route under the diversified-routing
rule, and handing over the PR, canonical refs, and review oracle — not the
worker's transcript. The worker and reviewer hold a serial clean exact-head
lease: the worker is idle, workspace `HEAD` equals the PR head, and
index/tracked worktree are clean before review. The reviewer may inspect and run
checks but cannot edit tracked files, commit, push, or change branches. It
posts a provider verdict naming the exact head. Requested changes return to the
same worker; the revised exact head returns to the same reviewer when available;
a replacement reviewer starts a fresh complete review. Before merge the
coordinator independently verifies only the coordination gate: the durable
accepted verdict names the exact current head, every blocking finding is
resolved or explicitly superseded on the provider, required checks pass, base
ancestry and mergeability are current, and no stricter repository rule or
operator pause applies. Ambiguous, contradictory, missing, or stale review
evidence stops merge.

Coordinator turns are event-bounded: an operator message or child notification
starts a turn. The coordinator performs every immediately available dispatch,
revision, review, merge-gate, or closeout action, reports identities and state,
then yields. It never polls, calls a wait primitive, holds a turn open for a
child, or rescans unchanged state to appear busy.

Model posture: the coordinator's normal route is an economical coordinator
class — reliable tool use, concise state tracking, bounded verification.
Expensive conversational routes are reserved for material operator-facing
discovery, and frontier review for diffs whose residual risk planning,
explicit oracles, tests, and an economical independent review cannot bound.
Capability classes stay portable; no local profile, model, price, or allowance
enters reusable policy. The separate ten-PR observation cohort decides
whether the split holds; one anecdote never rewrites it.

## Conversational planning delegation

An operator may start a lightweight planning delegate for one issue in parallel
while unrelated work continues. This is an optional same-workspace conversation,
not an implementation worker and not a separate worktree workspace. In Paseo it
is a visible agent tab in the current project workspace. It writes only unique
timestamped `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` files using exact-path Git
isolation.

The delegate talks directly with the operator, separates evidence,
alternatives, operator-confirmed statements, recommendations, constraints,
non-goals, and unresolved questions. It may spawn bounded read-only research
subagents that return sourced findings to it. They do not write to the
repository, contact the operator, or create nested lanes. The delegate does not
edit product code or canonical planning, open a planning PR, promote, decide
readiness, or contact the coordinator.

When ready, the delegate sends Chatterbox the absolute note path and summary;
manual operator relay is the fallback. Chatterbox reconciles the note against
current authority and promotes, retains, splits, or removes it.

Select the delegate from the adequate frontier conversational-planning pool
under the diversified-routing rule, rotating recent use like every other
dispatch class. A locally preferred model is configuration, not
Northstar doctrine. Without a control plane, the operator conducts the
conversation on the shared checkout.

## Fresh orchestrator continuation

An operator may ask the current orchestrator to transfer its whole live lane to
a fresh orchestrator thread. This is continuity, not parallel ownership. The
source fills the generic seven-section handoff with
`handoff_mode: orchestrator-continuation`,
`orchestrator_mode: economical-coordination`, and
`dispatch_authority: orchestrator`, pushes that coherent stopping state, then
stops planning, dispatch, review, and merge mutations for the transferred lane.
The successor re-enters normal orchestrator mode from the absolute handoff
path. It does not enter worker mode, run worker preflight, or use the
handoff-writing route.

When Paseo is available, create a separate `local` workspace for the same
project and checkout, select from the adequate orchestrator-role pool under
the diversified-routing rule, apply the
capitalized `Orchestrator=true` agent label, and use only the absolute handoff
path as the launch prompt. Reject a `branch-off` worktree or a different
project path. If creation returns an identity with an ambiguous error, preserve
it and stop that attempt. Missing sidebar pin/reorder support is not a launch
failure: report that placement is manual. Never use browser, computer-use, or
other UI automation to arrange the sidebar. Without Paseo, return the absolute
handoff path for manual launch. Do not archive or delete the source workspace as
part of the transfer.

## Chatterbox planning and promotion

Chatterbox is the primary human-facing planning authority. It owns discovery,
research direction, triage reconciliation, canonical planning promotion, lane
graph design, and the approved parallel frontier.

- **Direct promotion:** After explicit operator confirmation, Chatterbox
  directly updates canonical planning on the integration branch (architecture,
  contracts, specs, roadmaps, ready cards, dispatch manifest, indexes, triage
  dispositions). It validates and reviews the complete semantic diff, commits,
  pushes, then sends the coordinator a provenance-labelled direction naming the
  promoted commit and approved ready frontier. It does not launch a promotion
  worker or implement product/runtime changes.
- **Direction channel:** Chatterbox may discover the named coordinator and send
  it one background, provenance-labelled message:
  - `operator-confirmed direction` changes planning, priority, pause, reroute,
    or accepted escalation state;
  - `Chatterbox recommendation` is unconfirmed intake and cannot change active
    work;
  - `administrative notice` carries a note, commit, supersession, or routing
    fact.
  The coordinator reconciles confirmed direction with current state without
  asking the operator to repeat it. Chatterbox inspects coordinator state once
  to avoid duplicate messages, sends once, reports delivery, and does not poll.
  When no unambiguous coordinator or background messaging route exists,
  Chatterbox gives the operator a complete manual-relay message and absolute
  path.
- **Shared checkout and Git:** Chatterboxes share the checkout. They write
  only unique `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` files, check
  `git diff --cached --name-only` to fail closed if pre-existing staged files
  exist, stage with `git add -- <exact-file>`, and commit with
  `git commit -- <exact-file>`. They never use `git add .`, edit `README.md` or
  code, create worktrees/branches/PRs, or modify non-triage files.
- **Authority boundary:** Chatterbox does not implement product/runtime code,
  supervise workers, review PRs, or merge.

## Review children and serial workspace lease

Review remains independent but uses the existing worker workspace. The
coordinator creates a child reviewer with the worker `workspaceId`,
preserving coordinator parentage, a visible agent tab, and
`notifyOnFinish: true`. It does not create a review-only workspace or fall back
to the coordinator checkout.

The worker and reviewer hold a serial workspace lease:
1. Before review, the worker is idle, workspace `HEAD` equals the PR head SHA,
   and index and tracked worktree are clean.
2. The reviewer may inspect files and run test/check commands but cannot edit
   tracked files, commit, push, or change branches.
3. The reviewer posts a provider verdict naming the exact head SHA and finishes.
4. The coordinator verifies the same clean exact-head state before returning the
   lease to the worker for revisions.
Wrong head, dirty state, concurrent access, missing parentage/notification, or a
need for branch mutation stops review.

## Context-complete operator escalations

The agent that discovers an operator-owned blocker supplies a self-contained
capsule containing:

1. plain-language headline;
2. lane, PR, exact head, and lifecycle state;
3. observed versus intended behavior;
4. why operator authority is required;
5. practical impact;
6. concrete options and consequences;
7. recommendation when evidence supports one;
8. one exact question;
9. paused state and next action;
10. supporting links after the explanation.

The coordinator verifies current identities/state and relays the capsule. An
operator must be able to understand and answer without opening a blocker log,
PR thread, or file. Missing or opaque capsules return to the discovering child;
the coordinator does not reconstruct their semantics.

## Orchestrator merge authority

An operator who starts a Northstar orchestrator-owned worker lane pre-authorizes
the orchestrator to merge that lane's PR after independent review. This is not
auto-merge on PR creation. Merge is allowed only when:

- the provider records an accepted review verdict for the exact current PR
  head; the verdict names that head and comes from an independent review child
  unless the operator explicitly asked the orchestrator thread to review
  directly; a same-identity provider may use the canonical review comment;
- every required check passes and the PR is mergeable into its intended base;
- no head commit arrived after review;
- no stricter repository rule or explicit operator pause requires human action.

A changed head requires another review. Ambiguous provider or merge state stops
before retry. Workers and planning delegates never merge. A standalone direct-
review thread does not inherit orchestrator merge authority.

## Direct PR review boundary

When an operator asks a thread to review an existing PR, the review is not
complete until its verdict is recorded on the hosting provider. That request
authorizes only review mutations on the named PR: a formal review, inline review
comments, or a top-level fallback comment. It does not authorize branch edits,
commits, pushes, merge, or unrelated provider changes.

Inspect the PR metadata, commits, changed files, diff, existing discussion, and
checks against the applicable repository instructions and canonical refs. Every
finding that blocks merge must appear on the provider review surface with its
impact, evidence, precise path/line or changed surface, and resolution
condition. Prefer one coherent changes-requested review. When reviewer and
author share a GitHub identity and formal changes-requested review is blocked,
post one canonical PR comment headed `Changes required` containing every
blocking finding.

Chat reports the verdict, finding count, and review link. It must not introduce
a required change that is absent from the PR. Authentication, permission, or
provider failure leaves the review blocked; it is not permission to claim a
chat-only review as complete.

## Stop conditions

Execution must stop and return to planning or operator review when:

- a required contract is missing or contradictory
- a batch reveals a planning gap
- operator intent or prioritization is still unresolved across multiple
  plausible planning directions
- user-facing design ambiguity exceeds the product guardrails
- validation fails in a way that changes the plan
- required access, dependency, or repo authority is missing
- the work no longer matches the current master spec or roadmap intent

## Deviation protocol

When work deviates from the planned path:

1. stop execution on the affected card
2. record the deviation in the active card/spec/log flow
3. decide whether the issue is:
   - a card rewrite
   - a spec rewrite
   - a contract change
   - a roadmap recompile
4. resume only after the execution path is valid again

## Strict-compliance audit and rollout

For mature projects moving toward full strict compliance, Northstar should make
the migration operational rather than rhetorical.

The audit surface should make these questions explicit:

- what posture the project is currently in:
  `baseline`, `lane-first stricter adoption`, `expanding strict coverage`, or
  `full strict compliance`
- which strict-compliance checkpoints are already satisfied
- which gaps still block the next migration phase
- whether mixed posture is still deliberate migration state or has drifted into
  unowned inconsistency

The rollout surface should make these questions explicit:

- what the current migration tranche is
- what the next migration tranche is
- what evidence proves the current tranche is complete
- which project-level surfaces still need to change before full strict
  compliance can be claimed

Keep that migration state inside the normal planning spine:

- use one active migration master spec to carry the audit posture, checkpoint
  state, blocking gaps, and tranche plan
- use one active roadmap milestone to sequence the migration work
- use batch logs to prove completed tranches and rollout decisions

Do not invent a separate governance board or detached tracker for this. Strict
compliance migration should live in the same docs surfaces that already govern
the repo.

## Automation posture

The framework should work as much as possible without special phrasing from the
operator.

That means the installable skills should eventually behave like this:

- `northstar-setup`
  installs the guardrail pack by default for stricter projects
- `northstar-plan`
  produces specs and batch cards when needed, then promotes settled outcomes
  into architecture/contracts before roadmap execution
- `northstar-recover`
  repairs specs, architecture, contracts, and roadmaps when execution drifts
- `northstar-research`
  promotes findings into specs, architecture, and contracts
- `northstar-handoff`
  carries forward the active spec, canonical refs, current card, and remaining
  autonomy envelope

The aim is fewer special instructions in conversation and more behavior driven
by the repo's own planning surfaces.

## Dependencies

- Vision defines longer-term goals and constraints.
- Specs define provisional realization strategy for material goals.
- Architecture defines realized system shape and invariants.
- Contracts define enforced boundaries and execution rules.
- Batch cards define the exact execution unit.
- Roadmaps sequence the cards into milestone lanes.
- Logs prove what was completed and why.

## Quick reference

- [Glossary: Batch card, continuation envelope, stop/pause signals](../glossary.md#agent-and-thread-concepts)
- [Glossary: Lane budget](../glossary.md#agent-and-thread-concepts)

## Next task

Keep the strict-compliance audit and rollout surface compact: one active
migration spec, one active roadmap milestone, and batch logs that prove each
completed tranche.
