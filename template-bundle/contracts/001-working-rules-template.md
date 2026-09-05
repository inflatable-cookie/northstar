# 001 - Working Rules

**Type: TEMPLATE** -- Copy, remove this header, and adapt to your repo.

Status: active
Owner: <owner>
Updated: YYYY-MM-DD
Depends on: <docs/architecture/system-architecture.md>
Authority owners: <owners>
Affects: <surfaces>

## Problem

State why this repo needs an explicit execution grammar rather than relying on
informal habits.

## Contract

### Delivery grammar

- Material work should follow this chain:
  `vision -> research/specs -> architecture + contracts -> roadmap milestone -> execution -> evidence -> closeout`.
- Use separate contracts for stable seams, important boundaries, or durable
  rules that need their own authority surface.
- Use specs only while shaping material changes; promote durable outcomes into
  architecture and contracts before roadmap execution depends on them.
- Once those outcomes are promoted, treat specs as provisional planning history
  rather than canonical authority; keep, archive, or remove them based on
  whether they still help the active lane.
- A ready batch card should define scope, steps, governing refs, acceptance
  criteria, evidence requirements, stop conditions, and whether
  auto-continuation is allowed. Full field enumeration lives in the Northstar
  bundle at `bundle-docs/sections/07-delivery-framework-and-autonomy.md`
  (heading *Batch card rule*); keep this contract aligned with that section when
  you customize wording.
- When acceptance crosses concurrency, lifecycle, identity, persistence,
  security, public API, deployment, multi-version, or universal/exact/negative
  behavior, add a compact review oracle: invariant, adversarial counterexample,
  expected failure or stop point, and required proof. Do not preselect the edit.
- Before PR creation or revision, the worker tries to falsify the diff against
  that oracle and returns newly discovered product or contract choices to
  planning.
- Worker handoffs are dispatch overlays. Point to canonical cards and contracts;
  do not copy their steps, acceptance prose, or general doctrine.
- Classify blocking review findings as `execution-miss`, `oracle-gap`,
  `planning-change`, `validation-gap`, or `integration-drift`. Repair planning
  before worker revision when the finding is `planning-change`; raw review-cycle
  count alone does not diagnose handoff quality.
- Each active generation README should carry a `## Generation Runway`: a short,
  coarse list of generation goals, states, governing refs, and likely next
  milestones. Use it to choose the next milestone when a lane closes instead of
  inventing a new direction from recent context. It does not need to pre-plan
  every milestone, but it should be written to keep a significant generation
  moving across many roadmap files.
- Roadmap milestones are turnkey lane definitions: name a multi-batch execution
  plan (checkbox tasks), not one agent turn. Batch cards carry step detail.
  See `bundle-docs/sections/03-roadmaps.md` (*Scope and granularity rule*).
- A bare `continue` should resolve through the previous closeout's `Next Task`,
  which should normally point at the current ready card or an explicit
  stop/reassessment step.

### Papercuts feedback loop

- During execution, agents must append a short entry to the owning repository's
  root `PAPERCUTS.md` when they encounter small, solvable friction.
- If the file is missing, create it without asking the operator and continue the
  current task after recording the note.
- Seed the starter on adopt/upgrade before exact-SHA / clean-tree release prep;
  do not add it during tag closeout after that SHA is green.
- Capture friction, impact, a plausible smallest fix, and the affected tool,
  document, script, or workflow.
- Papercuts are observations for later maintenance, not automatic roadmap work;
  do not pause the task or fix them unless that work is already in scope.
- Skip ordinary one-off failures, external blockers, sensitive data, and
  duplicate open entries. Full detail lives in `bundle-docs/papercuts.md` when
  the Northstar source repo is available.

### Triage capture and cleanup

- `docs/triage/` is a standard temporary capture buffer for observations, ideas,
  plans, and questions surfaced during agent/operator conversation.
- Triage notes use the handoff filename shape
  `YYYYMMDD-HHMMSS-<slug>.md`. Their Markdown body is intentionally flexible;
  triage is for fast capture, not premature schema.
- Chatterbox, planning-delegate, refresh, and cleanup runs may capture useful
  unresolved threads. The mechanical coordinator does not load or reconcile
  triage during preflight and never chooses work from it.
- Creating or updating a lightweight triage note is an allowed capture write;
  canonical promotion, rework, and removal still require the route's normal
  authorization boundary.
- Update the existing note when the same issue changes. Do not create a
  correction, addendum, or deprecation note merely to supersede content in an
  open note. Keep the original filename.
- Triage is not execution authority. Promote durable content into the normal
  architecture, contract, spec, roadmap, research, or log surface before using
  it to authorize work.
- Refresh and cleanup must give each note a disposition: promote or rework it,
  merge it, keep it explicitly open, or remove it when implemented, superseded,
  or no longer useful.
- Full promotion deletes the source note in the same coherent commit. Partial
  promotion edits it down to only unresolved meaning. Triage holds current open
  intake; Git history and logs hold history.
- Keeping a note explicitly open is an interim state, not a permanent home; give
  it a next check or owner when possible, then promote, implement, or remove it.
- Never delete an unclassified note or docs path based on age or filename alone.
  Ask the operator when the destination, ownership, meaning, or removal
  consequence is uncertain.

### Intent checkpoints

- When planning is needed and the next direction is not clearly determined by
  the current authority surfaces, stop and ask the operator for intent instead
  of inventing the next lane or batch.
- Treat competing plausible directions, milestone handoff choices, and still-open
  product tradeoffs as intent checkpoints rather than routine planning work.
- Do not mark a card `ready` while an unresolved intent checkpoint still
  governs its scope.

### Execution guardrail pack

- prefer real integrated behavior over mockups, placeholders, or token
  scaffolding
- prefer simplicity over decorative or architectural complexity that the
  governing refs do not require
- prefer end-to-end follow-through over convenient partial closure when a batch
  promised a working path
- prefer explicit incompleteness over implied completion when a path is still
  scaffolded or unproven
- treat disconnected gesture work as incomplete unless the batch was explicitly
  scoped as bounded substrate-only work

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

### Definition of done

- Do not call work done while it is still a mockup, placeholder, or partial
  token implementation.
- Update dependent refs, roadmap state, and logs so they match reality.
- Update any front-door or currentness surfaces that still name the active
  lane, current ready card, or recent evidence chain so they do not keep
  advertising stale authority after closeout.
- Run the required validation commands and record them in a log.
- Name unresolved blockers or limits explicitly instead of hiding them inside a
  completion claim.
- Keep one explicit next-task pointer in the roadmap front doors unless the
  lane is genuinely complete.
- Make that roadmap pointer explicit enough that a later bare `continue` stays
  unambiguous.

### Operator-facing reporting

- For the end-of-turn closeout or meaningful checkpoint reply, lead with what
  changed, what state the lane is now in, and what happens next.
- Mention validation only if it failed or materially affects confidence.
- Keep protocol bookkeeping concise and secondary.
- Do not make the operator reconstruct the real outcome from card ids, file
  updates, or long command lists.

### Selective compression

- Use compressed, information-dense writing for internal execution surfaces:
  agent chat, batch cards, roadmap milestones, logs, and internal contracts.
- Remove filler, repetition, and ceremonial transitions.
- Prefer short bullets, fragments, and dense phrasing when clarity survives.
- Do not force this style onto public-facing or teaching docs that need normal
  prose.

### Execution autonomy

- Agents may continue across consecutive ready batch cards without waiting for
  a manual prompt.
- Auto-continuation is allowed only when the cards stay inside the same active
  lane, the governing refs still match, and the prior card's evidence gate
  passed.
- Set a local upper bound for uninterrupted runs, such as a card limit or time
  limit, so autonomy remains bounded.

### Parallel lane scheduling

- Parallel dispatch is the default. The orchestrator maps ready work as a
  dependency graph, refreshes the ready frontier at every dispatch checkpoint,
  and launches every safe frontier lane without a global thread budget or a
  second operator request. It does not wait for another worker to finish before
  creating a new thread.
- A lane joins the frontier only with no shared mutable scope, no
  ordering/data/generated-artifact dependency, no overlapping authority
  decision, and its own ready cards, validation, evidence, stop conditions,
  worktree, branch, and handoff.
- Same-repository lanes must partition mutable and closeout/front-door surfaces
  or reserve one named orchestrator integration step. Two workers never own the
  same front door.
- A serial decision must name the dependency, shared surface, or unresolved
  authority. Do not serialize unrelated ready work around one blocked edge,
  invent a speculative card, or split one coherent issue-fix lane.
- Provider, model, or profile quota, spend, rate, or availability failure is
  not a control-plane capacity signal. Preserve returned workspace and agent
  identities so an ambiguous attempt is not duplicated, then continue unrelated
  clear lanes. Choose another adequate route from the lane's diversified pool;
  do not promote an ordinary lane to frontier merely because its
  day-to-day route is unavailable. If no suitable route remains, pause only that
  lane, preserve its handoff and workspace, and continue every unrelated ready
  lane. With no control plane or when scoped tools are absent, publish every
  selected handoff at once for manual launch without pretending parentage
  exists. Do not record a fixed worker count, provider, or model.
- Workspace placement and agent parentage are separate axes: with Paseo,
  create the dedicated worktree workspace first, then create the worker from the
  orchestrator's agent-scoped tool context with that returned workspace ID.
  Workspace placement does not detach parentage. Detached root, schedule,
  generic detached, or unproven CLI launches are rejected. Finish
  notifications remain enabled and review follow-up resumes the same child.
- A worker-finish notification starts review of that lane; it does not refill a global launch queue.
  Keep doing non-overlapping planning, review, and closeout while workers run.
- Same-repository PRs merge one at a time. Refresh the remaining heads against
  current `main` after each merge and re-review any head that changed.

### Economical worker routing

- Worker routing is economical and diversified by default. Build the adequate
  pool from current adapter notes and explicit adapter cost metadata, prefer
  the cheapest adequate tier, then vary provider/model identity before
  reusing a recent route. Adequacy filters before price or rotation.
- Use adapter-visible recent-agent history when it exists; otherwise remember
  only routes launched in the current orchestrator run. Do not create a
  durable usage ledger or encode local profile, provider, model, price,
  balance, or allowance values.
- Implementation profiles must explicitly fit implementation or general
  day-to-day work. Audit, documentation-grind, review, planning, and coordinator
  profiles do not qualify merely because an implementation lane is long,
  documentation-heavy, or touches many files. Mechanically oriented profiles
  are for actual audits or exact non-semantic projection with settled decisions
  and repair boundaries.
- A frontier implementation worker requires both exceptional reasoning
  difficulty after planning and highest priority or material consequence,
  plus an explanation of why planning, the review oracle, exact-head review,
  and repository validation cannot adequately bound the remaining reasoning.
  Record both reasons in the handoff and rotate within the frontier pool too.
  Priority alone, complexity alone, file count, duration, or a risk-domain
  label is insufficient.
- Risky surfaces still need an explicit review oracle and material independent
  review. A material but settled change may use a capable non-frontier worker
  while its independent review child keeps material review; worker price is
  not the review-strength control.
- Unresolved designs return to planning. A refused route is removed only for
  that attempt; choose another adequate route from the lane's pool. If no
  adequate route remains, report the gap; do not silently escalate. An
  operator-named profile remains an explicit override.
- The orchestrator's normal route is an economical coordinator; higher
  reasoning effort is an escalation. Review children select from their own
  adequate review pools; a frontier review route is reserved for residual
  risk that settled planning, explicit oracles, and tests cannot bound.

### Conversational planning delegation

- An operator may start a lightweight planning delegate for one issue in
  parallel. In Paseo it is a visible agent tab in the current project
  workspace, not a new worktree workspace.
- The delegate creates one unique timestamped
  `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` file and may update that same note for
  its current bounded issue using exact-path Git isolation.
- It talks directly with the operator and separates confirmed decisions,
  recommendations, evidence, and open questions; it does not edit canonical
  planning, open a planning PR, promote, decide readiness, or contact the
  coordinator.
- Bounded research subagents are read-only and return sourced findings to the
  delegate. They do not write, contact the operator, or start nested lanes.
- When ready, the delegate sends Chatterbox the absolute note path and summary
  (or uses manual operator relay). Chatterbox reconciles the note against
  current authority and promotes, retains, splits, or removes it.

### Fresh orchestrator continuation

- On operator request, the source orchestrator may transfer its whole live
  lane to a fresh orchestrator through the generic seven-section handoff with
  `handoff_mode: orchestrator-continuation`,
  `orchestrator_mode: economical-coordination`, and
  `dispatch_authority: orchestrator`.
- After that handoff is pushed and dispatched, the source yields planning,
  dispatch, review, and merge mutations for the transferred lane. The successor
  enters normal orchestrator mode and does not run worker or planning-delegate
  preflight.
- With Paseo, create a separate `local` workspace for the same project and
  checkout, copy a current orchestrator-role profile, apply the capitalized
  `Orchestrator=true` label, and use only the absolute handoff path as the
  prompt. Reject a `branch-off` worktree or a different project path. Preserve
  returned identities and do not retry an ambiguous creation.
- Missing pin/reorder support is not a launch failure; placement stays manual.
  Never use browser, computer-use, or other UI automation. Without Paseo,
  return the absolute handoff path. Do not archive the source workspace as
  part of the transfer.

### Chatterbox planning and canonical promotion

- **Chatterbox** is the primary operator-facing planning authority. It owns
  discovery, research direction, triage reconciliation, canonical planning
  promotion, lane/dependency design, and the approved parallel frontier.
- After explicit operator confirmation, Chatterbox edits, validates, commits,
  and pushes the coherent canonical planning batch directly on the integration
  branch. It does not dispatch a promotion worker and does not implement
  product/runtime changes, accept reviews, or merge implementation PRs.
- Chatterboxes share the checkout. They create unique
  `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` files for new issues and update
  existing notes in place as those issues change, staged with
  `git add -- <exact-file>` and committed with `git commit -- <exact-file>`.
  Full promotion deletes the source note; partial promotion leaves only the
  unresolved remainder. They do not create worktrees, branches, or PRs.
- Chatterbox may send the named coordinator one provenance-labelled background
  message: `operator-confirmed direction` (changes planning/priority/pause),
  `Chatterbox ruling` (a cited answer already fixed by canonical or delegated
  planning authority), `Chatterbox recommendation` (unconfirmed intake), or
  `administrative notice` (routing facts). Chatterbox inspects coordinator
  state once, sends once, reports delivery, and does not poll.
- Raw triage and external intake are never coordinator execution authority.
  Chatterbox reconciles them against current authority.

### Mechanical coordination and dispatch

- The **coordinator** checks only current facts: promoted commit, prerequisite
  completion, path/workspace/branch collisions, transport/profile availability,
  repository gates, and operator pauses.
- It loads only the instructions, promoted commit, selected cards, manifest,
  and named refs needed for factual preflight (narrow fast path), not open
  triage. It never reconciles triage or chooses a planning branch from it.
- It launches the complete approved ready frontier published in the dispatch
  manifest; it does not design lanes, dependency edges, or parallel groups.
- Coordinator turns are event-bounded: perform all immediately available
  coordination, report state and identities, and continue across merge,
  closeout, and card boundaries while the canonical runway names another ready
  mechanical action. Yield only for a child or external result, new authority,
  or an empty runway. Never poll, invoke a wait primitive, hold a turn open, or
  repeatedly rescan unchanged state. `notifyOnFinish: true` drives the next
  bounded turn. Waiting for a child does not notify Chatterbox; an empty runway
  sends Chatterbox one administrative notice with completed state. A worker's
  complete pre-PR decision request is the explicit blocked-child exception, not
  a waiting notice. Do not require an operator `continue` between actionable
  steps.
- A refused connector or provider write may use an already-authenticated,
  repository-approved native write transport when the verified gate remains
  current. Re-verify provider state afterward. Do not solicit credentials,
  weaken the gate, or improvise an undeclared transport.

### Issue-fix dispatch

- Dispatch a reported defect as one outcome-scoped lane covering reproduction,
  diagnosis, the smallest complete contract-valid repair, cleanup of temporary
  diagnostics, validation, evidence, and a reviewable PR.
- A fix card may be ready without a known root cause or exact edit when the
  observed failure, expected behavior, reproduction or acceptance evidence,
  boundaries, validation, and stop conditions are clear.
- Let the worker make ordinary causal and code-level choices inside that
  envelope. Stop only when diagnosis exposes a material scope, contract,
  product-choice, access, safety, or plan change.
- Use a diagnostics-only lane only when the operator explicitly asks for
  evidence without a fix, or a named blocker makes safe implementation
  impossible. Do not present temporary instrumentation as completion of a fix
  lane.

### Independent review children and serial workspace lease

- Worker PRs normally receive an independent review child in direct PR-review
  mode unless the operator explicitly asks the orchestrator thread to review
  directly.
- In Paseo, create the reviewer child with the worker `workspaceId`, preserving
  parentage, visible tab placement, and `notifyOnFinish: true`. Do not create a
  review-only workspace.
- Worker and reviewer hold a serial clean exact-head lease: the worker is idle,
  `HEAD` equals the PR head, and index/tracked worktree are clean before and
  after review.
- The reviewer inspects and runs checks but cannot edit tracked files, commit,
  push, or change branches. It posts a provider verdict naming the exact head.
- The review child must use a different underlying provider/model identity from
  the authoring worker. Profile renames, effort changes, and fresh threads do
  not establish independence. Record both identities in the review handoff; if
  no qualified distinct reviewer exists, fail closed and escalate
  context-completely.
- Requested changes return to the same worker; the revised head returns to the
  same distinct reviewer when available; a replacement reviewer starts a fresh
  complete review.
- The orchestrator does not duplicate the full diff review. Before merge it
  verifies the coordination gate: the verdict names the exact current head,
  blocking findings are resolved or superseded on the provider, required
  checks pass, base ancestry and mergeability are current, and no stricter
  rule or operator pause applies. Stale or ambiguous evidence stops merge.

### Context-complete operator escalations

- The agent discovering an operator-owned blocker supplies a self-contained
  10-part capsule (headline, lane/PR/head state, observed vs intended behavior,
  why operator authority is required, impact, options, recommendation when
  supported, exact question, paused state/next action, supporting links).
- If an implementation worker stopped before opening a PR, the coordinator
  sends the complete capsule to the named Chatterbox as a `pre-PR decision
  request`, starts an idle Chatterbox turn through the available follow-up
  surface, records the lane as paused, and yields. It does not interpret the
  choice or ask the operator directly.
- Chatterbox returns a `Chatterbox ruling` only when cited canonical or
  delegated planning authority already fixes the answer. Otherwise it explains
  the issue to the operator, obtains the choice, promotes any durable planning
  change, and returns `operator-confirmed direction`. The coordinator resumes
  the same worker.
- Other blockers follow their named escalation path. The operator must be able
  to answer without opening a blocker log or PR thread. Missing or opaque
  capsules return to the discovering child.

### Orchestrator merge authority

- Starting an orchestrator-owned worker lane pre-authorizes the orchestrator to
  merge that lane's PR after an independent review child — or an
  operator-requested direct review — accepts the exact current head; the posted
  verdict must name that head, and all required checks pass.
- Confirm the PR is mergeable into the intended base. A changed head requires
  another review; ambiguous merge state stops before retry.
- When a connector write is refused while the gate remains current, the
  coordinator may use an already-authenticated, repository-approved native
  write transport and re-verify provider state; it never weakens the gate or
  solicits credentials.
- Merge, post-merge reconciliation, closeout, frontier recomputation, and
  next-ready dispatch form one continuous coordinator action chain.
- Post-merge local integration reconciliation is mandatory before card closeout,
  frontier recomputation, or another worker dispatch:
  - resolve and verify the provider's merged PR and resulting `origin/main`;
  - fetch the integration remote, fast-forward the project's local `main` checkout
    to `origin/main`, and assert that local and remote heads match;
  - base all later closeout, frontier recomputation, and worker dispatch facts on
    that verified synchronized head;
  - fail closed on dirty checkout, wrong branch, divergence, fetch failure, or head
    mismatch: stop immediately, preserve the local integration checkout completely
    untouched, and return a context-complete reconciliation blocker to Chatterbox;
    never reset, stash, rebase, discard changes, or dispatch from stale local state.
- A stricter repository rule or explicit operator pause still wins.
- Workers, planning delegates, and standalone direct-review threads never merge.

### Direct PR review boundary

- An explicit request to review an existing PR authorizes posting the review
  and review comments on that PR, but not editing its branch or merging it.
- Put every merge-blocking finding on the provider review surface with concrete
  evidence and a precise changed surface. Chat is only the summary.
- Request changes formally when permitted. If same-identity review is blocked,
  post one canonical PR comment headed `Changes required` instead.
- Treat authentication, permission, or posting failure as a blocked review; do
  not claim a chat-only review is complete.

### Automation runtime policy

- Prefer `effigy` when it already covers the repo operation.
- When repo-owned script logic is still needed, default to `TypeScript` run
  with `bun`.
- Use `bash` only for thin glue or compatibility boundaries that Effigy or
  Bun/TypeScript cannot own cleanly.
- Use `python` or another runtime only when a concrete technical requirement
  justifies it.

### Compact lifecycle, artifact lifecycle classes, and prune triggers

- Northstar operates under one compact strict lifecycle. Light, baseline,
  lane-first, mixed, and full-strict labels describe historical or migration
  state, not alternative supported steady-state protocols.
- Treat the live docs tree as working memory. Git retains full history; HEAD
  retains current authority, actionable work, unresolved meaning, and material
  evidence only.
- Treat roadmap generations as substantial sequencing eras (roughly 20 to 50
  milestones), not one-or-two-file buckets.
- Each active generation's `docs/roadmaps/gNN/README.md` owns its stable
  `## Generation Runway`.
- Finishing a batch, suite, or lane of roadmaps does not close the generation;
  stay inside the active generation until the sequencing baseline needs a reset.

Every planning artifact belongs to one lifecycle class with a default disposition:

| Class | Examples | Live-tree rule | Disposition trigger |
| --- | --- | --- | --- |
| durable authority | vision, architecture, contracts | retain while authoritative | replace or delete with all callers when superseded |
| active execution | active roadmap, ready/in-flight cards | retain only while actionable | fold outcome/evidence into closure, then generation roll-up |
| transient transport | triage notes, worker handoffs, questionnaires | retain only while carrying unresolved or unconsumed meaning | delete after promotion, consumption, abandonment, or transfer |
| exceptional evidence | releases, incidents, material migrations | retain when operationally useful | roll up only when durable value is preserved |
| derived currentness | indexes, status tables, projections | generate, bound, or remove | rebuild from canonical current state |

- Normal delivery evidence belongs on the completed card: outcome, validation,
  PR, commit, and material limits.
- Separate logs are justified only for incidents, releases, migrations,
  cross-lane decisions, or oversized evidence sets.
- Consumed worker handoffs are deleted after merge, abandonment, or ownership
  transfer.
- Promoted specs are removed or reduced to a non-procedural tombstone once
  durable outcomes are promoted into architecture/contracts.
- Rollover replaces each closed generation with one non-authoritative
  `docs/roadmaps/archive/gNN.md` roll-up and purges closed/stale specs.
- Refresh, normalization, and authorized docs cleanup inspect already-closed
  expanded generations and apply the same preservation-led roll-up. A fresh
  rollover is not required. Leave unresolved generations intact. Read-only
  cleanup reports the proposal only; authorized repair does not need a second
  confirmation for this compaction.
- Allow parallel mode when genuinely independent work streams need separate
  generations without blocking each other; front doors must name all active
  generations and milestones.

### Stop conditions

- stop on planning gaps, contradictions, or missing authority
- stop when operator intent or prioritization is still unresolved across
  multiple plausible planning directions
- stop when user-facing ambiguity exceeds the project guardrails
- stop when validation fails in a way that changes the plan
- stop when the current card is complete and the next one is not already ready

### Currentness surfaces

- Keep the repo's front-door currentness surfaces aligned to the active lane:
  - `docs/README.md`
  - `docs/contracts/contract-index.md`
  - `docs/roadmaps/README.md`
  - `docs/roadmaps/generation-index.md`
  - `docs/roadmaps/gNN/README.md` for the active generation
  - `docs/specs/README.md` when specs are part of the lane
  - `docs/logs/README.md`
- When a card closes, those surfaces must either:
  - point at the next ready card or active milestone state
  - or explicitly say the lane is awaiting reassessment
- Keep the live next-task pointer only in the roadmap front doors. Other docs
  surfaces may summarize state or dependencies, but should not own the active
  thread pointer.
- The active `docs/roadmaps/gNN/README.md` owns the full generation runway.
  Other front doors may point to it, but should not duplicate the runway table.
- Do not leave a completed card named as the current ready card after closeout.

## Validation

- <validation command>

## Roadmap Impact

- <gNN.NNN>

## Planning Notes

Record the practical reason these working rules exist in this repo.
