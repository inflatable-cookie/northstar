# 001 - Working Rules

Status: active
Owner: repo maintainers
Updated: 2026-09-01
Depends on: docs/architecture/system-architecture.md
Authority owners: repo maintainers
Affects: bundle-docs, template-bundle, skills, docs, scripts

## Problem

Northstar needs a tighter execution grammar, but splitting every standing rule
into a separate contract makes the surface noisier than it needs to be for a
single-repo planning lane like this one.

## Contract

### Delivery grammar

- Material work should follow this chain:
  `vision -> research/specs -> architecture + contracts -> roadmap milestone -> execution -> evidence -> closeout`.
- Use a separate contract only when a stable seam, authority boundary, or
  reusable rule surface genuinely needs one.
- Use a master spec when a goal spans multiple meaningful batches, changes
  user-facing behavior, or introduces non-trivial operational policy.
- A ready batch card must define scope, exact steps, governing refs, acceptance
  criteria, validation, evidence requirements, stop conditions, and whether
  auto-continuation is allowed.
- Each active generation README should carry a `## Generation Runway`: a short,
  coarse list of generation goals, states, governing refs, and likely next
  milestones. Use it to choose the next milestone when a lane closes instead of
  inventing a new direction from recent context. It does not need to pre-plan
  every milestone, but it should be written to keep a significant generation
  moving across many roadmap files.
- When planning is required for a material lane, do not stop at one next card.
  Compile a bounded execution runway that names the generation-runway goal it
  advances, the next few meaningful batches or milestones, and the next
  planning checkpoint.
- Roadmap milestones are turnkey lane definitions: name a multi-batch execution
  plan with checkbox tasks, not one agent turn. Batch cards carry step detail.
  See `bundle-docs/sections/03-roadmaps.md` (*Scope and granularity rule*).
- In a strict lane, a bare `continue` should resolve through the previous
  closeout's `Next Task`, which should normally point at the current ready card
  or an explicit stop/reassessment step.
- When planning is needed and the next direction is still materially
  ambiguous, stop and ask for operator intent instead of inventing the next
  lane or batch.
- Specs are provisional. Before material implementation runs, durable
  structural outcomes should be promoted into architecture and durable
  behavioral or policy rules should be promoted into contracts.
- Keep `docs/specs/` tidy over time: retain active or still-useful planning
  history, but archive or remove stale specs once promoted canonical surfaces
  already carry the truth and the lane is no longer active.
- Treat specs and batch-card lanes as having explicit lifecycle states:
  `active`, `retired-in-place`, and `archived`.
- Use `retired-in-place` only as a short-lived holding state when a recently
  closed planning artifact still needs to remain near active work for
  traceability.
- Move closed planning artifacts to `docs/specs/archive/` when they still merit
  preservation but no longer belong in the active specs surface.
- Keep the archive lean and traceable. Do not treat archived specs as canonical
  execution authority once architecture and contracts carry the truth.

### Papercuts feedback loop

- During execution, agents must append a short entry to the owning repository's
  root `PAPERCUTS.md` when they encounter small, solvable friction.
- If the file is missing, the agent creates it without asking the operator and
  continues the current task after recording the note.
- Seed the starter during Northstar adopt/upgrade before release-candidate /
  exact-SHA prep; do not add it during tag closeout after a green clean-tree
  SHA. Full timing rule: `bundle-docs/papercuts.md`.
- Each entry captures friction, impact, a plausible smallest fix, and the
  affected tool, document, script, or workflow.
- Papercuts do not pause work, authorize unplanned fixes, or replace the normal
  backlog, roadmap, spec, architecture, or contract surfaces. Triage them in
  normal maintenance and promote repeated or material items as appropriate.
- Do not record ordinary one-off failures, external blockers, sensitive data, or
  duplicate open entries. Full detail lives in `bundle-docs/papercuts.md`.

- Live consumer-repository dogfooding is operator-owned and external to
  Northstar's execution loop. Northstar consumes feedback supplied by the
  operator as evidence or planning input; it does not select consumer targets,
  create dogfood handoffs, dispatch consumer workers, or manage those runs.

### Triage capture and cleanup

- `docs/triage/` is a standard temporary capture buffer for observations, ideas,
  plans, and questions surfaced during agent/operator conversation.
- Triage notes use the handoff filename shape
  `YYYYMMDD-HHMMSS-<slug>.md`. Their Markdown body is intentionally flexible;
  triage is for fast capture, not premature schema.
- Orchestrator and refresh runs should capture useful unresolved threads before
  following one branch deeply, then inspect triage at meaningful checkpoints.
- Creating or updating a lightweight triage note is an allowed capture write;
  canonical promotion, rework, and removal still require the route's normal
  authorization boundary.
- Triage is not execution authority. Promote durable content into the normal
  architecture, contract, spec, roadmap, research, or log surface before using
  it to authorize work.
- Refresh and cleanup must give each note a disposition: promote or rework it,
  merge it, keep it explicitly open, or remove it when implemented, superseded,
  or no longer useful.
- Keeping a note explicitly open is an interim state, not a permanent home; give
  it a next check or owner when possible, then promote, implement, or remove it.
- Never delete an unclassified note or docs path based on age or filename alone.
  Ask the operator when the destination, ownership, meaning, or removal
  consequence is uncertain.

### Execution guardrail pack

- Prefer real integrated behavior over mockups, placeholders, or token
  scaffolding.
- Prefer simplicity over decorative or architectural complexity that the
  governing refs do not require.
- Prefer end-to-end follow-through over convenient partial closure when a batch
  promised a working path.
- Prefer explicit incompleteness over implied completion when a path is still
  scaffolded or unproven.
- Treat disconnected gesture work as incomplete unless the batch was explicitly
  scoped as a bounded substrate-only step.

### Refactoring and release maturity

- **Before v1.0:** do not add compatibility aliases, shims, re-export layers,
  deprecated stubs, or silent fallbacks to keep obsolete paths working. Prefer
  direct migrations: update call sites and remove superseded surfaces in the
  same batch unless the operator directs a different shape.
- **Breaking changes:** when a refactor would break callers, contracts, or
  documented behavior, stop and raise it with the operator with a short impact
  summary and options. Do not unilaterally add a compatibility layer to avoid
  that conversation.
- **At v1.0 maturity and beyond:** default stance is maintaining expected
  functionality for stable, user-visible, or externally depended behavior.
  Deprecation windows, adapters, or other compatibility work may be required;
  still coordinate material breaks with the operator, but do not treat "delete
  the old path in one batch" as the automatic default when it would abandon
  supported behavior without an explicit decision.

### Ready-state rubric

- Full doctrine enumerations for batch-card fields and card-level readiness live
  in [`bundle-docs/sections/07-delivery-framework-and-autonomy.md`](../../bundle-docs/sections/07-delivery-framework-and-autonomy.md)
  under **Batch card rule** and **Ready-state rubric**. This subsection stays the
  compact binding surface for the northstar repo.
- Treat `ready` as a constrained execution state, not a placeholder label.
- A card is ready only when:
  - its objective is bounded enough to complete without fresh planning
    decisions
  - its governing refs point at current canonical surfaces
  - its scope boundaries, acceptance criteria, validation, evidence
    requirements, and stop conditions are explicit
  - high-risk, universal, exact, or negative acceptance includes a compact
    review oracle: invariant, adversarial counterexample, expected failure or
    stop point, and required proof
  - no unresolved planning gap still governs the card's scope
  - no unresolved intent checkpoint still governs the card's scope
- A short auto-continuation chain is ready only when:
  - each card in the chain is individually ready
  - the cards belong to the same active roadmap/spec lane
  - the order is explicit and the next transition is already represented in
    file state
  - the chain stays inside the project's autonomy envelope
- A lane is planning-coherent only when:
  - the current roadmap/spec surfaces name the higher-level owner of the lane
  - the next likely batches or milestone handoff are visible beyond the
    immediate ready card
  - the next planning checkpoint is explicit rather than deferred until the
    current card finishes

### Readiness-map and decision-record contract

Readiness mapping uses a bounded destination subdirectory under `docs/specs/`.
For `<destination-slug>`, the map is
`docs/specs/<destination-slug>/README.md`; records are
`docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md`. Both are
Markdown with YAML frontmatter and explicit relative links.

The map frontmatter requires:

- `kind: readiness-map`
- stable `id`, human-readable `title`, `destination`, and `owner`
- `status: active|cleared|paused`
- `master_spec` and `roadmap` links to the governing spec and current roadmap lane

The map body requires `## Destination`, `## Decision index`, `## Current frontier`,
and `## Readiness gate`. The map is an index and summary surface.
It links each record and may summarise state or blockers, but canonical decision
rationale appears once in the linked record.

Each decision record frontmatter requires:

- stable `id` and `kind: decision|research|prototype|task`
- `mode: operator|research|prototype|task`
- `status: open|in-progress|resolved|out-of-scope`
- `title`, `owner`, and `authority`
- `blocked_by`, containing stable decision IDs or an empty list
- exactly one of `resolution_evidence` or `accepted_uncertainty` when `status`
  is `resolved`

IDs are stable lowercase kebab-case values, unique within the destination. The
record filename starts with the exact ID and then a descriptive slug. Relative
links stay inside the destination subtree or target named canonical docs
surfaces: the governing spec, architecture, contract, roadmap, or log.

`kind`, `mode`, and `authority` remain separate fields. Operator-owned decisions
cannot be resolved by agent inference; research, prototype, and task records
provide their distinct evidence or execution context and do not grant operator
authority. The map is plan-only: `status: cleared` does not override the normal
spec, promotion, roadmap, or operator-owned readiness gates.

### Pre-execution discovery route contract

Batch 26.2 adds four bounded routes to the readiness-mapping workflow. They are
planning instruments, not execution permissions:

- **Intent rounds** ask a small, breadth-first set of questions over the current
  decision frontier. Before asking the operator, resolve facts that repository
  inspection, deterministic commands, or bounded research can answer. Link each
  question to a canonical decision record or explicitly record why it is
  non-material. Do not turn an intent round into an exhaustive questionnaire.
- **Project language** is destination-local by default. A linked project-language
  surface records preferred terms, aliases, meaning, authority, status, and
  rejected ambiguity. Stable terms may later be promoted to the global glossary;
  local wording does not become global doctrine automatically.
- **Decision prototypes** are throwaway, question-specific evidence. A prototype
  records the question, hypothesis or options, bounded scope, evaluation method,
  evidence, verdict, limitations, and promotion target. It may inform a decision
  but cannot resolve an operator-owned decision by itself or edit production code
  as part of the route.
- **Questionnaires** preserve operator-owned questions across turns or sessions.
  They record context, constraints, options or recommendation, operator response,
  authority, and unresolved state in the canonical decision record. They do not
  use an external tracker and do not silently substitute an agent answer.

All four routes are provider-neutral, plan-only, non-mutating by default, and
must leave a traceable path back to the readiness map and its canonical decision
records. A route may update planning evidence, but it cannot mark a map cleared,
make a card ready, or bypass normal spec, promotion, roadmap, or operator gates.

### Continuation envelope

- Treat auto-continuation as a bounded envelope, not an open-ended permission.
- A continuation envelope must make explicit:
  - which next card may auto-start
  - how many already-defined ready cards remain in-bounds
  - what proof must pass before each transition stays valid
- The continuation envelope may stay active only while:
  - the completed card's evidence gate passed
  - the next card is already defined and still marked ready
  - the governing refs still match the live lane
  - no stop signal has been triggered
- If any part of that envelope is no longer explicit in file state, treat
  continuation as exhausted rather than implied.

### Lane budget and pause signals

- Treat lane budget as the lane-level answer to whether a run should keep
  spending autonomy budget even when another card is technically in-bounds.
- A lane-level budget should make explicit:
  - whether the current card is the end of the budgeted run
  - whether another operator decision is required before more autonomy is spent
  - which compact pause signal explains a clean stop
- Low context or normal thread compaction is not a pause signal. Treat it as a
  normal runtime event and let the same thread continue when the lane is still
  active.
- Use these pause-signal categories when a run stops cleanly:
  - `budget-exhausted`
  - `stop-signal-fired`
  - `lane-complete`
  - `handoff-required`
- Pause signals do not weaken hard stop conditions. They explain why a run
  stopped once the stop or budget boundary has been reached.

### Definition of done

Work in this repo is not done unless:

- the intended behavior or documentation change exists for real, not as a
  placeholder, mockup, or token partial implementation
- dependent references and planning surfaces are updated coherently
- required validation commands were actually run
- the relevant spec, batch card, roadmap milestone, and log state reflects the
  current truth
- unresolved blockers or limits are named explicitly instead of hidden inside a
  completion claim
- the roadmap front doors carry one clear next-task pointer unless the lane is
  genuinely complete
- that roadmap pointer is explicit enough that a later bare `continue` does not
  need a recap prompt to find the correct next move

### Operator-facing reporting

- Closeout summaries should be written for operator comprehension first, not as
  a protocol dump.
- Lead with:
  - what was actually achieved
  - what the current lane state is now
  - what happens next
- Compress validation and protocol bookkeeping into short secondary detail.
- Mention roadmap/card/log ids only when they clarify the current state, not as
  the main story.
- Do not make the operator reconstruct the actual outcome from a list of file
  updates, card numbers, or validation commands.
- A good default closeout shape is:
  - outcome in plain language
  - current lane state
  - validation, only if it failed or materially affects confidence
  - concise next move
- Treat that as an end-of-turn closeout shape, not a structure that every
  short in-thread message must repeat.

### Compression policy

- Use a natural, human conversational tone in agent chat and normal thread
  replies. Keep recommendations and next steps, and make the exchange easy to
  respond to or redirect.
- Orchestrator threads should be creative and exploratory: ask focused
  questions, explore alternatives, explain trade-offs, and welcome tentative
  ideas without weakening authority boundaries.
- Internal execution artifacts should remain compact and information-dense:
  - batch cards
  - roadmap milestones
  - logs
  - working rules and similar internal contracts
- Public-facing or explanatory surfaces should keep normal prose:
  - user-facing documentation
  - marketing or onboarding copy
  - tutorial or teaching material
  - architecture or vision prose when richer explanation is part of the job
- Compression should remove filler, repetition, and ceremonial transitions, not
  warmth, connective reasoning, or meaning.
- Prefer short bullets and clear structure when the result stays readable to an
  informed operator; do not force telegraphic fragments into conversation.
- Do not force dry status-report language when it harms comprehension,
  exploration, or traceability.

### Closeout pattern

- Closeout is an ordered sequence, not a generic reminder to update docs.
- For a meaningful completed batch or stopping point:
  - update the current batch card status and completion notes first
  - update the active roadmap milestone if progress, readiness, or the next
    batch changed
  - refresh any front-door or currentness surfaces that still name the active
    lane, current ready card, or recent evidence chain
  - write the batch log with evidence, validation actually run, and unresolved
    blockers or limits
  - record whether the continuation envelope still holds or whether a stop
    signal exhausted it
  - record the lane budget state and the pause signal when the run is not
    simply continuing in-bounds
  - update or create a handoff only when another thread truly needs to take
    over or the user explicitly asks for one
  - leave one explicit next-task pointer in the roadmap front doors:
    `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, and the
    active `docs/roadmaps/gNN/README.md`
- If the next work is not ready, say so explicitly in closeout rather than
  implying continuation.
- Do not declare the lane complete or create a handoff merely because context
  is low or the runtime may compact the thread. If the same thread can keep
  going after compaction, normal closeout plus `Next Task` is the correct path.
- In the operator-facing summary for that closeout, state the achieved change
  and the lane state before listing protocol artifacts or validation commands.

### Execution autonomy

- When a thread has a ready runway of cards, the default behavior is to
  continue through them without pausing for operator acknowledgment at every
  boundary.
- Baseline roadmap-only repos can still support healthy routing and shorter
  bounded runs, but the fuller continuation-envelope, lane-budget, and
  pause-signal model should be treated as a stricter `specs/` plus batch-card
  capability.
- Auto-continuation is allowed only when:
  - the next card is already defined and marked ready
  - the cards belong to the same active roadmap/spec lane
  - the governing refs still match the work
  - the prior card's evidence gate passed
  - the remaining continuation envelope is explicit in file state
  - no stop condition below has been triggered
- In a strict lane, a later bare `continue` should normally be enough because
  the prior closeout already named the next task and the current ready card.
- That should not collapse the lane into one-card improvisation. Planning work
  should leave enough runway that execution can see the broader lane shape and
  the next planning checkpoint without reopening strategy from scratch after
  every card.
- If a thread still needs a giant continuation prompt in ordinary use, treat
  that as a repo-surface or local-agent-contract failure worth tightening.
- Context compaction is compatible with that model. It should not be treated as
  a handoff-required boundary when the same thread can continue from the prior
  `Next Task`.
- Default upper bound for one uninterrupted run:
  - up to 3 consecutive ready batch cards
  - or roughly 90 minutes of focused work
  - whichever limit is hit first
- When that upper bound is reached cleanly, use `budget-exhausted` instead of
  implying that a hard stop condition fired.

### Orchestrator and worker boundary

For material work that benefits from a separate implementation context, use the
following authority split:

- the **orchestrator thread** owns question-led discovery, intent summary,
  promoted architecture/contracts, roadmap readiness, worker launch preparation,
  PR review, gated merge, and closeout;
- the **worker thread** owns implementation only inside its dedicated worktree
  and branch, including bounded diagnosis and implementation judgment inside
  the assigned ready cards, tests, commits, evidence, and PR creation;
- a **planning delegate** owns one operator-facing discovery conversation and
  its bounded triage/research packet in an isolated branch; it does not promote
  canonical planning, decide readiness, or implement;
- the **operator** answers unresolved questions, may override worker-profile
  selection, starts or relays manual runs, resolves material permission
  requests, and may pause or override the lane before merge.

Starting an orchestrator-owned worker or planning-delegate lane pre-authorises
the orchestrator to merge that lane's PR once it has reviewed the exact current
head, recorded an accepted verdict on the provider, and confirmed every required
check passes. A stricter repository rule or explicit operator pause still wins.

Model routing is diversified and economical by default. Build the adequate
profile pool from current adapter notes and explicit adapter cost metadata when
available, prefer the cheapest adequate tier, then vary provider/model identity
before reusing a recent route. Use adapter-visible recent-agent history when it
exists; otherwise remember only routes launched in the current orchestrator
run. Do not create a durable Northstar usage ledger or encode local profile,
provider, model, price, balance, or allowance values.

Ordinary implementation, bounded audits, mechanical work, and most settled
material lanes use that economical pool. A frontier implementation worker is a
rare exception: record the material consequence and why planning, the review
oracle, exact-head review, and repository validation cannot adequately bound
the remaining reasoning. Priority, complexity, file count, duration, broad
scope, or a risk-domain label is insufficient. Rotate eligible frontier and
fresh-orchestrator profiles too; an operator-named profile still overrides.

Risky surfaces still need an explicit review oracle and frontier review. A
well-specified persistence or public-API change may use a small economical
worker while the orchestrator keeps material review. Unresolved designs return
to planning. A refused route is removed only for that attempt; select another
adequate route without treating the refusal as global capacity. If no adequate
profile remains, preserve and pause only that lane.

An operator may ask the orchestrator to spin off a frontier planning delegate
for a named topic while the orchestrator continues unrelated work. The
orchestrator publishes one handoff declaring `handoff_mode: planning-delegate`,
`planning_mode: conversational-discovery`, `dispatch_authority: orchestrator`,
and `promotion_authority: orchestrator`, then launches it in a separate
worktree/branch using a current frontier conversational-planning profile. The
delegate talks directly with the operator, captures confirmed decisions,
recommendations, alternatives, evidence, and open questions in named
`docs/triage/` and optional `docs/research/` paths, and opens a PR containing
only that packet. Its handoff lists required sibling worktree links or `none`;
launcher lifecycle creates them in the worktree container before setup and the
delegate verifies them without overwriting conflicts.

The planning delegate may spawn bounded read-only research subagents that
return sourced findings to it. Those subagents do not edit, create branches or
PRs, contact the operator, or start nested orchestrator/implementation lanes.
The delegate itself does not edit product or canonical planning surfaces,
promote, decide readiness, or launch implementation. The orchestrator does not
start work that depends on the topic while its planning PR is open.

After exact-head review and checks, the orchestrator merges the planning PR,
reconciles it against current `main`, and separately promotes settled meaning
into architecture, contracts, specs, roadmaps, or cards. It removes or splits
resolved triage notes during promotion. Merge of a planning packet is intake,
not promotion or execution authority.

An operator may instead ask the current orchestrator to transfer its whole live
lane to a fresh orchestrator thread. The source writes the normal seven-section
handoff with `handoff_mode: orchestrator-continuation`,
`orchestrator_mode: planning-and-review`, and
`dispatch_authority: orchestrator`, reconciles and pushes the stopping state,
then stops planning, dispatch, review, and merge mutations for that lane. The
successor re-enters normal orchestrator mode from the absolute handoff path; it
does not enter worker mode or run the worker worktree preflight.

When Paseo supplies the transport, create a separate local workspace for the
same project and checkout, select a current orchestrator-role profile, and pass
the capitalized `Orchestrator` label through the supported agent-label field.
Use only the absolute handoff path as the initial prompt. Preserve returned
workspace and agent identities and do not retry ambiguously. If Paseo exposes a
native sidebar pin/reorder surface, place the successor beside the source;
otherwise report that pinning is manual. Never use browser, computer-use, or
other UI automation to arrange the sidebar. Without Paseo, return the absolute
handoff path for manual launch. Do not archive or delete the source workspace as
part of the transfer.

The orchestrator may delegate a meaningful batch of mechanical documentation
projection to a fast, low-cost subagent after it has settled every planning
decision. The projection brief must name the authority owner, settled meaning,
canonical refs, allowed paths, exact evidence and state transitions, forbidden
judgments, validation, and stop conditions. The subagent may materialize or
synchronize named roadmap, card, log, front-door, index, handoff, template, and
evidence surfaces. It must not choose a canonical home, invent or reinterpret
intent, add acceptance or stop rules, decide readiness/completion/next work,
resolve contradictions, edit product code, commit, push, review, or merge.

Documentation projection runs serially in the orchestrator's planning context;
it is not worker mode and needs no worker handoff or worktree. Capture existing
dirty state and allowed paths before dispatch. The orchestrator reviews the full
diff for semantic fidelity and owns commit/push. Keep tiny edits local when
dispatch and review would cost more than the projection.

The repository is the durable communication boundary. A worker must be able to
re-enter from its worker handoff, `AGENTS.md`, canonical refs, cards, commits,
tests, and PR metadata; private conversation history is not required authority.

Parallel dispatch is the default schedule, not an operator-requested option.
While compiling a runway and again at every dispatch checkpoint, the
orchestrator maps the meaningful lanes as a dependency graph, identifies the
current ready frontier, and launches every safe frontier lane without a global thread budget
or a second operator request. It does not wait for another worker to finish
before creating a new thread.

A lane belongs on that frontier only when it has no shared mutable scope,
no ordering/data/generated-artifact dependency, and no overlapping authority
decision, and when it has its own ready cards, validation, evidence, stop
conditions, worktree, branch, and handoff. Same-repository lanes must also
partition their mutable and closeout/front-door surfaces or reserve one named
orchestrator integration step; two workers never own the same front door.

When a condition fails, keep only that edge or lane serial and record the exact
dependency, shared surface, or unresolved authority. Unrelated ready work is
not serialized around one blocked edge. A provider, model, or profile quota,
spend, rate, or availability failure is not a control-plane capacity signal and
must not serialize unrelated ready work. Parallelism is never a reason to invent
a speculative card or to split one coherent issue-fix lane.

A control-plane workspace or agent creation failure belongs to that lane.
Preserve every returned workspace or agent identity so an ambiguous attempt is not duplicated,
then continue launching unrelated lanes whose transport state is clear. Mark only the refused route unavailable and choose another configured
profile from the lane's adequate diversified pool. Do not
promote an ordinary lane to frontier merely because its day-to-day route is
unavailable. If no suitable route remains, pause only that lane, preserve its
handoff and workspace, report the provider/profile gap, and continue every
unrelated ready lane. Recovery reuses the retained authority chain; it does not
create a duplicate worker. With no control plane the orchestrator publishes a
handoff per selected lane and gives the operator every absolute path at once.
Northstar does not encode a fixed worker count, provider, or model, and does not
ask the operator to guess one.

The orchestrator continues non-overlapping planning, review, revision routing,
merge, and closeout while workers run. A worker-finish notification starts
review of that lane; it does not refill a global launch queue.

Same-repository PRs merge one at a time. After each merge the orchestrator
refreshes every remaining head against current `main` and re-reviews any head
that changed or needed conflict resolution.

The following worker-start conditions apply only after a worker thread has been
explicitly dispatched by the orchestrator with a handoff declaring
`handoff_mode: worker-pr-loop`, `worker_mode: implementation`, and
`dispatch_authority: orchestrator`. They do not apply to normal-mode agents,
planning/orchestrator threads, or review threads.

Before a worker starts:

- the planning checkout is on `main` and has no unrelated changes;
- required QA has passed;
- all planning and roadmap artifacts are committed to `main`;
- one concrete worker handoff for that lane is committed to `main`;
- `main` is pushed and local `HEAD` equals `origin/main`;
- the operator receives that handoff's absolute path as the only dispatch
  artifact;
- when the current orchestrator thread exposes the required control-plane
  tools, the orchestrator gives that same path to a worker created in one
  isolated workspace for the lane without another permission prompt; otherwise
  the operator launches the worker manually;
- the handoff lists required sibling worktree links (absolute primary
  checkouts and the link name in the worktree container directory) or `none`;
- the worker performs a quick startup preflight before broad reads: repository
  root, current worktree, branch, and `git status --porcelain`;
- a clean, dedicated, non-`main` registered current worktree supplied by the
  harness is authoritative, even when its generated path or branch differs from
  the handoff; record the actual path/branch and reuse it;
- after the worktree is selected, confirm `HEAD == origin/main`, the
  planning base is an ancestor, and the repository-relative handoff exists
  in that `HEAD`; load the tracked blob and stop if the absolute dispatch
  file differs;
- ensure each listed sibling checkout is symlinked into the worktree container
  directory (the worktree's parent): canonicalize source and destination;
  create when absent; reuse only a symlink that already resolves to the declared
  source; stop on any other existing path; never delete, replace, or overwrite;
  skip only when the list is `none`; stop if a listed source is missing. A
  launcher-managed lifecycle does this before project bootstrap needs the
  sibling and the worker verifies it; the manual fallback worker creates it
  after its startup preflight;
- only if the current context is `main`, dirty, unregistered, or otherwise
  unsuitable does the worker consider the named handoff worktree and then create
  a unique manual worktree and branch from pushed `origin/main`, recording the
  actual path/branch;
- the worker never cleans, resets, or discards a dirty checkout while creating
  or selecting the fallback;
- the selected worker worktree has a separate branch created from pushed `main`;

During execution:

- every assigned card is already ready, ordered, and inside the continuation
  envelope;
- issue-fix dispatches are outcome-scoped: when the operator asks to fix a
  reported defect, the same worker lane owns reproduction, diagnosis, the
  smallest complete contract-valid repair, removal of temporary diagnostics, validation,
  evidence, and PR creation;
- a fix card may be ready without a known root cause or preselected edit when it
  defines the observed failure, expected behavior, reproduction or acceptance
  evidence, scope boundaries, validation, and stop conditions;
- the orchestrator must not split diagnosis into a separate completed lane or
  accept temporary instrumentation as the result of a fix dispatch. A
  diagnostics-only lane requires an explicit operator request for evidence
  without a fix, or a named authority, access, planning, or safety blocker that
  makes implementation impossible inside the current envelope;
- the worker handoff names scope, acceptance, validation, evidence, stop conditions,
  report cadence, and PR base/head expectations;
- the handoff is a dispatch overlay: it points to canonical cards and contracts
  instead of copying their steps, acceptance prose, or general doctrine;
- the worker reports after meaningful chunks with changed surfaces, validation,
  remaining cards, blockers, and new risks; an active adapter may return the
  report directly, otherwise the operator relays it;
- the worker stops on a planning gap, contract contradiction, unresolved product
  choice, scope expansion, missing authority/access, or validation failure that
  changes the plan;
- the worker may continue through in-bounds ready cards without a new operator
  prompt, but may not invent the next card or architecture.

Before opening or updating a PR, the worker performs an adversarial pass over
the diff: enumerate universal, exact, and negative claims, try the card's named
counterexamples, map every review-oracle row to proof, and reconcile execution
and closeout surfaces. A newly discovered product threshold, contract choice,
or acceptance rule returns to planning.

A worker completes the assigned runway with a pushed branch, evidence, and a
reviewable PR. PR creation is not approval or merge. The orchestrator reviews the
actual diff, changed files, commits, and checks against canonical refs. It records
an evidence-backed verdict in the provider review surface; on same-identity
GitHub runs, it posts that verdict as a PR comment because formal self-approval
is unavailable. After an accepted verdict, the orchestrator may merge without a
second operator prompt only when the reviewed head is still current, required
checks pass, the PR is mergeable into the intended base, and no repository rule
or operator instruction requires a human merge. A changed head invalidates the
verdict and requires another review. Merge failure or ambiguous provider state
stops before retry. Requested changes return to the same worker branch when
possible, followed by another review cycle. Provider review comments are durable
evidence, not a worker wake-up mechanism: after posting a `changes requested`
verdict, an orchestrator with an active control plane sends an explicit follow-up
to the originating agent. Paseo uses `send_agent_prompt` with the retained agent
ID. The orchestrator does not silently replace an unavailable worker.

Every merge-blocking finding is classified as `execution-miss`, `oracle-gap`,
`planning-change`, `validation-gap`, or `integration-drift`. A
`planning-change` repairs canonical planning before implementation resumes.
Review-cycle counts without these reasons are not evidence that the handoff was
too short or too long.

### Direct PR review boundary

An explicit operator request to review an existing PR authorizes the review
thread to post its verdict and review comments on that PR. It does not authorize
branch edits, commits, pushes, merge, or unrelated provider mutations.

The provider review surface is the durable review record. Every finding that
blocks merge must be posted there with concrete evidence and a precise changed
surface. Use a formal changes-requested review when permitted. When the reviewer
and author share a GitHub identity, post one canonical PR comment headed
`Changes required` instead. Chat should summarize the posted verdict and must
not be the only home of a required change. If authentication, permissions, or a
provider failure prevents posting, report the review as blocked rather than
claiming a chat-only review is complete.

Northstar does not require live cross-session messaging, provider subagents, or
hosted coding agents. Those are optional adapters; they must not weaken the
file-based planning, worktree, PR, and review boundaries. When the current
orchestrator thread exposes the required control-plane tools, their injection
authorizes routine transport for ready worker lanes: the orchestrator selects a
current role profile, creates the lane's worktree workspace, launches a worker
with the single absolute handoff path, trusts finish notifications instead of
polling, and sends bounded follow-ups to the same agent without another
permission prompt. An operator-named profile overrides automatic profile
selection. A repository `paseo.json` configures project lifecycle capability;
it is not a substitute runtime signal. Adapter profile names, IDs, messages,
and status are transport metadata, never repository authority. A generic
task-handoff helper must not generate a second briefing for a Northstar worker.
Tool injection does not independently authorize unready work, missing product or
contract choices, material permission requests, destructive workspace cleanup,
review, merge, or duplicate retries. Merge authority comes from the active
orchestrator lane and its accepted review/check gate, not from Paseo. Permission
requests return to the operator unless existing explicit authority settles the
exact action. Manual launch and operator relay remain the required fallback.

### Automation runtime policy

- Prefer `effigy` when it already covers the repo operation.
- When repo-owned script logic is still needed, default to `TypeScript` run
  with `bun`.
- Use `bash` only for thin glue or compatibility boundaries that Effigy or
  Bun/TypeScript cannot own cleanly.
- Use `python` or another runtime only when a concrete technical requirement
  justifies it.

### Generation posture

- Treat roadmap generations as substantial sequencing eras, not tiny buckets of
  one or two milestone files.
- Each active generation's `docs/roadmaps/gNN/README.md` owns its
  `## Generation Runway`.
- Keep the generation runway coarse and stable. Write it for a long-lived
  generation, not the next four or five roadmaps. Update it when
  generation-level intent changes, a milestone materially advances or closes a
  goal, or rollover is being considered.
- Do not use the generation runway as a backlog, checkbox task list, or
  per-turn currentness surface.
- In long-running repos, expect one generation to hold many milestones before a
  new generation is useful.
- Treat roughly 20 to 50 milestones as the normal scale of a healthy
  generation before rollover is even worth discussing.
- Roll to a new generation only when the sequencing baseline itself needs a
  reset, not merely because one lane or batch closed quickly.
- Finishing a batch, suite, or lane of roadmaps does **not** close the
  generation. After one batch closes, compile or continue the next batch inside
  the same generation.
- Treat rollover as full generation closeout:
  - every roadmap in the old generation must be explicitly closed, superseded,
    or moved to backlog
  - the roadmap front doors must reflect that closed state before the next
    generation opens
  - stale specs from the closing generation must be archived or removed from
    `docs/specs/` so the new generation does not inherit old lane debris. Batch
    cards stay with their generation under `docs/roadmaps/gNN/batch-cards/` and
    do not need separate archiving.
- If those closeout conditions are not satisfied, repair the current generation
  instead of opening a new one.

### Strict-compliance audit and rollout

- When a mature repo is moving toward full strict compliance, keep that
  migration inside the normal planning spine.
- Use one active migration spec to record:
  - current posture
  - satisfied checkpoints
  - blocking gaps
  - whether mixed posture is still valid migration state or has become drift
  - current tranche
  - next tranche
  - the evidence needed to close the current tranche
- Use one active roadmap milestone to sequence the migration batches.
- Use normal batch logs to prove completed migration tranches.
- Do not invent a detached governance tracker for this.

### Currentness surfaces

- Keep the repo's front-door currentness surfaces aligned to the active lane:
  - `docs/README.md`
  - `docs/roadmaps/README.md`
  - `docs/roadmaps/generation-index.md`
  - `docs/roadmaps/gNN/README.md` for the active generation
  - `docs/contracts/contract-index.md`
  - `docs/logs/README.md`
- Refresh those surfaces whenever the active milestone, generation, or recent
  evidence chain changes materially.
- When currentness drift repeats enough to become predictable, add lightweight
  deterministic checks instead of relying only on manual cleanup.
- `docs/README.md` may surface one active spec alongside the active roadmap,
  but only when that spec still materially governs the next planning or
  execution decisions for the current lane.
- `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, and the
  active `docs/roadmaps/gNN/README.md` should each point to one active
  milestone, not a list of competing "current" lanes.
- The active `docs/roadmaps/gNN/README.md` owns the full generation runway.
  Other front doors may point to it, but should not duplicate the runway table.
- Keep the live next-task pointer only in those roadmap front doors. Other
  docs surfaces may describe current state or dependencies, but should not own
  the active thread pointer.
- `docs/logs/README.md` should keep a bounded recent-evidence window, usually
  the most recent 5 active-lane logs plus any still-governing rollover or
  decision log needed to explain the current state.
- Use a dedicated currentness-triage log only when currentness cleanup is
  itself the batch, or when multiple stale front-door/evidence surfaces need a
  short explicit cleanup record beyond ordinary batch closeout.

### Stop conditions

Execution must stop when:

- a planning gap or contradiction appears
- operator intent or prioritization is still unresolved across multiple
  plausible planning directions
- user-facing design ambiguity exceeds the product guardrails
- validation fails in a way that changes the plan
- required access, dependency, or authority is missing
- the work no longer matches the current master spec or roadmap intent
- the current batch card is exhausted and the next one is not already ready
- the remaining continuation envelope is missing, contradicted, or no longer
  justified in file state

## Validation

- Repository checks protect structure, references, identifiers, executable
  state, and canonical/mirror parity. They should not treat editorial wording
  or individual historical artifacts as schema.
- Keep exact-content checks only when an independently stable machine contract
  requires that exact content. Do not mirror prose to enforce currentness.
- Semantic contradiction, misleading currentness, and historical-authority
  judgment remain review responsibilities until a real structured contract
  exists.
- `docs/specs/archive/001-northstar-delivery-layer.md` exists and matches these rules.
- at least one live batch card exists and is tied to an active roadmap
  milestone
- `effigy qa`
- `effigy qa:docs`

## Migration Notes

This repo is running in a compact contract mode. The live delivery layer is
still strict, but the standing rules are intentionally consolidated into one
working-rules contract until separate seam contracts become necessary.

## Roadmap Impact

- `g01.001`
- later batches that promote the live repo pilot into the bundle and skills
- `g02.001`
- `g02.002`
- `g02.003`
- `g02.004`
- `g02.005`
- `g02.006`
- `g02.007`
- `g02.008`
- `g02.009`
- `g02.010`
- `g02.024` through `g02.045` where this contract directly governs the lane

## Planning Notes

This contract closes the repo's immediate planning gap around how material work
should execute while keeping the active surface smaller and more focused than a
split contract stack.
