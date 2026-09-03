# 050 - Add Chatterbox Intake Channel

Status: in review; card 124 reviewable PR pending
Owner: repo maintainers
Created: 2026-09-03
Updated: 2026-09-03
Depends on: `g02.049`, spec 026, spec 030, spec 035
Vision tags: `orchestration`, `triage`, `conversation`, `paseo`
Governing refs: `docs/specs/035-chatterbox-intake-channel.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/specs/030-conversational-triage-and-docs-cleanup.md`,
`docs/contracts/001-working-rules.md`,
`docs/architecture/system-architecture.md`

## Problem

Side issues and exploratory chats currently land on the orchestrator. The
operator needs independent, human chatterbox threads that identify problems
and write triage notes without interrupting the main runway.

## Goals

- add an internal chatterbox mode and thin `/northstar-chatterbox` adapter;
- let the operator start a thread with no handoff, and let the orchestrator
  spawn one on request;
- share the orchestrator checkout and write only unique triage files;
- idle-only Paseo ping to `Orchestrator=true`; never interrupt a running turn;
- keep promotion, dispatch, review, and merge with the orchestrator;
- drop the colliding "advisors" wording from research-subagent copy.

## Non-Goals

- no worktree, branch, or PR for chatterbox capture;
- no Paseo queue plugin or notify-only API as a blocker;
- no rename of `paseo-advisor`;
- no overlap with card 120's embedded-payload removal while that lane owns
  the skill/router/command surface.

## Execution Plan

- [x] **Wait for card 120 merge.** Chatterbox implementation shares the
      installable skill, router, command adapters, and several closeout
      front doors with the root-reduction lane. Do not launch this card
      while 120 is the ready/in-flight owner of those surfaces.
- [x] **Card 124** implements the mode, adapter, spawn/ping, doctrine,
      contracts, inventory, checker oracles, parity, and closeout from spec
      035.

## Acceptance Criteria

- [x] all eight spec-035 oracle rows have deterministic proof;
- [x] operator start and orchestrator spawn match the spec;
- [x] unique-file git protocol is explicit and negatively tested;
- [x] idle-only ping and intake-only orchestrator handling are explicit;
- [x] chatterbox cannot widen authority into planning or implementation;
- [x] source/install parity and full Northstar QA pass.

## Review Oracle

Use the eight rows in spec 035. The reviewer must not invent extra
acceptance during review.

## Stop Conditions

- card 120 is still the owner of the skill/router/command surface;
- implementation needs a Paseo product/API change or a queue plugin;
- shared-checkout git protocol cannot stay unique-file-only;
- chatterbox would require a handoff, worktree, or PR to be safe;
- validation changes the plan.

## Next Task

Launch card 124 from
`docs/handoffs/20260903-181459-add-chatterbox-intake-channel.md`, then stop for
its reviewable PR.
