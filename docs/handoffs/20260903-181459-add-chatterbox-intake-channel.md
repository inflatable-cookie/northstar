---
title: Add chatterbox intake channel worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-09-03
updated: 2026-09-03
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260903-181459-add-chatterbox-intake-channel.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, chatterbox]
---

## What This Thread Was Doing

Northstar has compiled a secondary operator-facing chatterbox role in spec 035
and card 124. Card 120's generic-core reduction has merged, releasing the
installable skill, router, command adapter, and closeout surfaces this card
needs.

This dispatches one bounded implementation lane. No transcript or second prompt
is part of the authority chain.

## Why It Matters

Feature ideas and exploratory issues should not interrupt the orchestrator's
main runway. Chatterboxes give the operator several warm, long-running intake
conversations that write durable triage notes without acquiring planning or
execution authority.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `aa9a0058833fc93d118f8e1cf3129a4c61c9bd17`
- **Pushed main verification:** local `HEAD` and `origin/main` must equal the
  commit containing this handoff before launch; `aa9a005` must be an ancestor.
- **Planning checkout:** clean primary checkout at readiness refresh.
- **Planning artifacts included at the base:** spec 035, `g02.050`, card 124,
  PR-30 merge closeout, readiness log, and this handoff.
- **Worker branch:** `worker/add-chatterbox-intake-channel`
- **Worker worktree:** Paseo-managed dedicated worktree; accept the actual
  launcher path recorded by preflight.
- **Worktree creation command:** Paseo `branch-off` from pushed `main`, branch
  `worker/add-chatterbox-intake-channel`, slug
  `add-chatterbox-intake-channel`.
- **Worker worktree policy:** follow `Completion Protocol`; launcher worktree
  first, named/manual fallback only when required.
- **Required sibling worktree links:** none.
- **Active spec lane:** `docs/specs/035-chatterbox-intake-channel.md`
- **Roadmap milestone:** `docs/roadmaps/g02/050-add-chatterbox-intake-channel.md`
- **Ready cards, in order:**
  `docs/roadmaps/g02/batch-cards/124-add-chatterbox-intake-channel.md`
- **Allowed runway:** card 124 only.
- **Remaining card budget:** one card; stop after its reviewable PR.
- **Dispatch topology:** sole implementation lane for these surfaces.
- **Parallel safety check:** the completed card-120 worker owns no remaining
  mutable surface; the separate operator chatterbox-planning thread has
  published its canonical plan and is not an implementation lane.
- **Surfaces this lane owns:** chatterbox mode and command adapter; router,
  orchestrator mode, protocol/doctrine/working-rules/inventory/operator and
  triage guidance named by card 124; focused checker assertions; source/install
  parity; card, milestone, one closeout log, this handoff, and affected front
  doors.
- **Integration ownership:** worker owns the complete bounded implementation
  and closeout; orchestrator owns review, revision routing, merge, and live-skill
  refresh.
- **Merge ordering:** same-repository PRs merge one at a time; integrate current
  `main` and revalidate if it moves.
- **Canonical refs:** `docs/specs/035-chatterbox-intake-channel.md`,
  `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
  `docs/specs/030-conversational-triage-and-docs-cleanup.md`,
  `docs/architecture/system-architecture.md`,
  `docs/architecture/system-inventory.md`, and
  `docs/contracts/001-working-rules.md`.
- **Review oracle:** all eight rows in spec 035 and card 124; do not add
  material acceptance during implementation.
- **Model capability profile:** economical day-to-day implementation; semantics
  and failure boundaries are fully settled.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** use Effigy selectors; no workflow/release
  mutations; no Paseo plugin or API change; no live installed-skill refresh;
  no live chatterbox launch from the worker.
- **Required validation:** all eight oracle rows; `effigy
  check:command-skills`; `effigy check:repo-contract`; isolated `effigy
  check:skill-install skills/northstar`; `effigy qa:docs`; `effigy qa`; `git
  diff --check`.
- **PR base/head:** `main` <- `worker/add-chatterbox-intake-channel`
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/31
- **Review state:** revision 1 ready (PR #31 changes addressed: exact-path git commit isolation verified by fixture, prose-coupled checks removed from check:command-skills, settled notification boundary on origin/main integrated).
- **Merge path:** orchestrator after accepted exact-head review and passing
  checks.

## Boundaries

- **In scope:** card 124 only, including its deterministic oracle, parity, and
  closeout.
- **Out of scope:** card 120, a Paseo queue/plugin or product change, renaming
  `paseo-advisor`, research-subagent fan-out, a second public Northstar skill,
  live operator dogfood, or promotion of any chatterbox triage note.
- **Outcome shape:** smallest complete spec-035 implementation. The worker may
  encode settled semantics but cannot choose new role, git, notification,
  transport, or authority behavior.
- Work only in the clean launcher worktree. Do not mutate the planning checkout.
- Do not merge. The orchestrator owns exact-head review and merge.

## Important Context

- **Planning lineage:** spec 026 owns orchestrator coordination; spec 030 owns
  conversational triage; spec 035 distinguishes chatterbox from workers,
  planning delegates, orchestrator continuations, handoffs, and
  `paseo-advisor`.
- **Why this card is ready:** card 120 merged as `aa9a005`, the 111-file skill
  is installed, no overlapping worker remains, and spec 035 settles every
  implementation choice.
- **Decisions and preferences:** operator-started threads need no handoff;
  orchestrator-spawned Paseo threads use a same-checkout local workspace,
  `Chatterbox=true`, and `notifyOnFinish: false`; capture writes only unique
  triage files; v1 starts no orchestrator turn automatically.
- **Open tensions:** Paseo has no atomic notify-only or send-if-idle API.
  Report the note path to the operator and leave the queue/conditional-send
  idea as a separate triage note.
- **Report after:** coherent implementation plus falsification, then PR creation.
- **Report to:** the originating orchestrator through Paseo finish notification.

## Suggested Next Move

Run the worker preflight. Read `AGENTS.md`, card 124, milestone 050, spec 035,
specs 026/030, architecture, inventory, and working rules. Implement the mode,
adapter, spawn/intake rules, and deterministic oracle as one coherent batch.

## Completion Protocol

### Before you start

1. This handoff's worker metadata activates worker mode. Record repository root,
   branch, status, and worktree registration before broad reads.
2. Accept a clean registered non-`main` launcher worktree. Do not create another
   merely because its generated path differs from this handoff.
3. Fetch origin non-interactively. Confirm `HEAD == origin/main`, confirm
   `aa9a0058833fc93d118f8e1cf3129a4c61c9bd17` is an ancestor, and load this
   handoff from the selected `HEAD`. Stop if the absolute file differs from the
   tracked blob.
4. Required sibling links are `none`.
5. Read the assigned card and canonical refs. Run cheap orientation checks.

### While you work

- Execute card 124 only and keep commits aligned with meaningful chunks.
- Preserve one public Northstar skill. Chatterbox is an internal mode plus thin
  command adapter.
- Implement exact unique-file staging and exact-path commit semantics, with an
  executable shared-index fixture. Do not simulate an idle-only Paseo API,
  call `send_agent_prompt`, require a handoff/worktree for chatterbox capture,
  or turn a surfaced note into promotion authority.
- Stop if a product/API change, shared-file chatterbox protocol, or unresolved
  authority choice becomes necessary.

### When the assigned runway is complete

1. Run every required validation named above.
2. Falsify executable and structural oracle rows and map semantic rows to
   exact-head review evidence; do not mirror editorial prose into a checker.
3. Reconcile card 124, milestone 050, one closeout log, this handoff, and all
   affected front doors. Leave the queue-plugin triage note open.
4. Integrate current `main` if it moved, rerun validation, push the worker
   branch, and open a reviewable PR.
5. Report the PR URL and exact tested head through the finish notification. Do
   not merge.

### Review and merge path

The orchestrator independently reviews the exact head. Blocking findings use
`execution-miss`, `oracle-gap`, `planning-change`, `validation-gap`, or
`integration-drift`. Requested changes return to this same child agent and
branch. Accepted current-head review plus passing checks and mergeability lets
the orchestrator merge without another approval prompt.

### Handoff closeout

Keep the lane honest. On a stop condition, record the blocker and pause. Do not
start live chatterbox dogfood or the queue-plugin follow-up from this worker.
