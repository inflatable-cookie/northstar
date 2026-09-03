# 050 - Add Chatterbox Intake Channel

Status: ready; card 124 handoff published
Owner: repo maintainers
Created: 2026-09-03
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
- operator-visible note handoff with no automatic orchestrator turn in v1;
- keep promotion, dispatch, review, and merge with the orchestrator;
- drop the colliding "advisors" wording from research-subagent copy.

## Non-Goals

- no worktree, branch, or PR for chatterbox capture;
- no Paseo queue plugin, conditional send, or notify-only API in v1;
- no rename of `paseo-advisor`;
- no overlap with card 120's embedded-payload removal while that lane owns
  the skill/router/command surface.

## Execution Plan

- [x] **Wait for card 120 merge.** Chatterbox implementation shares the
      installable skill, router, command adapters, and several closeout
      front doors with the root-reduction lane. Do not launch this card
      while 120 is the ready/in-flight owner of those surfaces.
- [ ] **Card 124** implements the mode, adapter, spawn/notification boundary, doctrine,
      contracts, inventory, checker oracles, parity, and closeout from spec
      035.

## Acceptance Criteria

- [ ] structural rows have deterministic proof, shared-index Git behavior has
      an executable fixture, and semantic rows have exact-head review evidence;
- [ ] operator start and orchestrator spawn match the spec;
- [ ] unique-file git protocol is explicit and negatively tested;
- [ ] chatterbox v1 starts no orchestrator turn and intake-only handling is explicit;
- [ ] chatterbox cannot widen authority into planning or implementation;
- [ ] source/install parity and full Northstar QA pass.

## Review Oracle

Use the eight rows in spec 035. The reviewer must not invent extra
acceptance during review.

## Stop Conditions

- card 120 is still the owner of the skill/router/command surface;
- implementation attempts to emulate a non-atomic idle-only ping;
- shared-checkout git protocol cannot stay unique-file-only;
- chatterbox would require a handoff, worktree, or PR to be safe;
- validation changes the plan.

## Next Task

Launch card 124 from
`docs/handoffs/20260903-181459-add-chatterbox-intake-channel.md`, then stop for
its reviewable PR.
