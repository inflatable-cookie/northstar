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
