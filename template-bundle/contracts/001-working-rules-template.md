# 001 - Working Rules

**Type: TEMPLATE** -- Required for strict posture. Copy, remove this header, and adapt to your repo.

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
- In a strict lane, a bare `continue` should resolve through the previous
  closeout's `Next Task`, which should normally point at the current ready card
  or an explicit stop/reassessment step.

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
- Long mechanical audits and documentation churn prefer fast/low-cost or
  mechanically oriented profiles even when their scope is broad.
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

- On operator request, the orchestrator may launch one frontier planning
  delegate for a named topic in an isolated branch/worktree while continuing
  unrelated work.
- Its handoff lists required sibling worktree links or `none`; setup creates
  them in the worktree container before use and stops on conflicts.
- The delegate talks directly with the operator and writes only a named
  triage/research packet. It separates confirmed decisions, recommendations,
  evidence, and open questions; it does not promote, decide readiness, edit
  product code, or launch implementation.
- Bounded research subagents are read-only and return sourced findings to the
  delegate. They do not write, contact the operator, or start nested lanes.
- The delegate opens a PR. An independent review child reviews it against the
  handoff and recorded operator confirmations; the coordinator merges after
  the gate, then reconciles current `main` and separately promotes settled
  meaning through an operator-confirmed lane. Packet merge is not promotion
  or execution authority.

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

### Mechanical documentation projection

- Keep promotion authority, readiness judgment, the merge gate, and merge with
  the orchestrator; route substantive review to independent review children.
- Same-checkout helper: after meaning is fully settled, a fast/low-cost
  subagent may serially apply an exact brief to genuinely non-semantic edits
  in the planning checkout — already-settled updates, exact wording sync, and
  deterministic checks. The orchestrator reviews the full diff before any Git
  mutation and owns those mutations. This helper carries no new product
  meaning.
- The brief must bound authority, settled meaning, canonical refs, allowed
  paths, evidence/state transitions, forbidden judgments, validation, and
  stop conditions. The subagent does not choose authority or state, edit
  product code, commit, push, review, or merge, and stops on ambiguity.
- Operator-confirmed promotion lane: materializing a decision-ready packet
  into canonical architecture, contracts, specs, roadmaps, and cards runs as
  a bounded branch/worktree/PR lane from an exact promotion brief. The
  projection worker stops on semantic ambiguity; an independent review child
  reviews the PR against the confirmed packet; the coordinator applies the
  normal merge gate.

### Chatterbox intake channel

- An operator may start a chatterbox directly without a handoff or worktree, or
  ask the orchestrator to spawn one for exploratory problem intake.
- In Paseo, create a `local` workspace for the same project and checkout, select
  from the adequate conversational pool, apply the capitalized
  `Chatterbox=true` label, and set `notifyOnFinish: false`.
- Chatterboxes share the orchestrator's checkout and write only unique
  `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` files, staged with `git add -- <exact-file>`
  and committed with `git commit -- <exact-file>`. They do not create worktrees,
  branches, or PRs.
- Chatterbox v1 starts no automatic orchestrator turn; it reports the absolute
  note path and summary to the operator in chat.
- The orchestrator treats surfaced triage notes as non-assignment intake, does
  not promote or change work from the intake, and inspects the note at its next
  triage checkpoint.
- A note may be marked decision-ready when it separates operator-confirmed
  decisions, recommendations not yet accepted, evidence and alternatives,
  unresolved questions, and affected authority surfaces; it stays
  non-authoritative until the operator confirms the meaning through the
  orchestrator.

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

### Independent review children

- Worker PRs normally receive an independent review child in direct PR-review
  mode unless the operator explicitly asks the orchestrator thread to review
  directly.
- Create a dedicated workspace at the PR head and launch the reviewer as a
  parent-attached child with finish notifications enabled; select an
  economical adequate review route under the diversified-routing rule.
- Give the reviewer the PR, canonical refs, and review oracle, not the
  worker's private transcript. The posted verdict names the exact reviewed
  head.
- Requested changes return to the same worker; the revised head returns to
  the same reviewer when available; a replacement reviewer starts a fresh
  complete review.
- The orchestrator does not duplicate the full diff review. Before merge it
  verifies the coordination gate: the verdict names the exact current head,
  blocking findings are resolved or superseded on the provider, required
  checks pass, base ancestry and mergeability are current, and no stricter
  rule or operator pause applies. Stale or ambiguous evidence stops merge.

### Orchestrator merge authority

- Starting an orchestrator-owned worker or planning-delegate lane pre-authorizes
  the orchestrator to merge that lane's PR after an independent review child —
  or an operator-requested direct review — accepts the exact current head; the
  posted verdict must name that head, and all required checks pass.
- Confirm the PR is mergeable into the intended base. A changed head requires
  another review; ambiguous merge state stops before retry.
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

### Generation posture

- Treat roadmap generations as substantial sequencing eras, not one-or-two-file
  buckets.
- Each active generation's `docs/roadmaps/gNN/README.md` owns its
  `## Generation Runway`.
- Keep the generation runway coarse and stable. Write it for a long-lived
  generation, not the next four or five roadmaps. Update it when
  generation-level intent changes, a milestone materially advances or closes a
  goal, or rollover is being considered.
- Do not use the generation runway as a backlog, checkbox task list, or
  per-turn currentness surface.
- Default to sequential mode: keep one generation active across many milestones
  until the sequencing baseline itself needs a reset.
- Treat roughly 20 to 50 milestones as the normal scale of a healthy
  generation before rollover is even worth discussing.
- Finishing a batch, suite, or lane of roadmaps does **not** close the
  generation. After one batch closes, compile or continue the next batch inside
  the same generation.
- Treat rollover as full generation closeout in sequential mode:
  - every roadmap in the old generation must be explicitly closed, superseded,
    or moved to backlog
  - the roadmap front doors must reflect that closed state before the next
    generation opens
  - stale specs from the closing generation must be archived or removed from
    `docs/specs/`
- If those closeout conditions are not satisfied in sequential mode, repair the
  current generation instead of opening a new one.
- Allow parallel mode when genuinely independent work streams need separate
  generations without blocking each other:
  - each generation operates as its own queue with distinct lane context
  - opening a new generation does not require closing prior active generations
  - each generation's `gNN/README.md` remains the authoritative front door for
    that thread
  - front doors must accurately name all active generations and their milestones

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
