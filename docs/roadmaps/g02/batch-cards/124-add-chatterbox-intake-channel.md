# 124 - Add Chatterbox Intake Channel

Status: in review; revision 1 pending planning resolution on Paseo ping
Owner: repo maintainers
Created: 2026-09-03
Updated: 2026-09-03
Master roadmap: `g02.050`
Governing refs: `docs/roadmaps/g02/050-add-chatterbox-intake-channel.md`,
`docs/specs/035-chatterbox-intake-channel.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/specs/030-conversational-triage-and-docs-cleanup.md`,
`docs/architecture/system-architecture.md`,
`docs/architecture/system-inventory.md`,
`docs/contracts/001-working-rules.md`
Auto-start next card: no

## Objective

Add chatterbox as a secondary Northstar communication mode: human intake
chat, unique triage-file capture on the shared checkout, and an idle-only
Paseo ping to the orchestrator.

## Scope

- add `references/modes/chatterbox.md` and route it from `router.md`;
- add thin `/northstar-chatterbox` command adapter;
- teach orchestrator mode to spawn chatterboxes and treat intake pings as
  non-assignments;
- propagate the compact rule through spec 026 roles, working-rules (live and
  copy-ready), bundle-docs section 07, protocol kernel, skill outcomes,
  inventory, triage README, operator quick start, and glossary;
- drop "or advisors" from research-subagent wording;
- add deterministic checker assertions for every spec-035 oracle row;
- raise the command-skills aggregate description budget only if the tenth
  adapter requires it;
- update source/install parity, card, milestone, log, and front doors;
- open a reviewable PR and stop for orchestrator exact-head review.

Out of scope: card 120 work, a Paseo plugin or queue, renaming
`paseo-advisor`, worktrees/branches/PRs for capture, research-subagent
fan-out, or promoting any triage note.

## Ready-State Checks

- [x] operator settled the name, shared checkout, and idle-only ping;
- [x] spec 035 records authority, git protocol, spawn, and ping;
- [x] card 120 has merged and no longer owns the skill/router/command
      surface or shared closeout front doors;
- [x] no other worker owns orchestrator mode, router, command adapters, or
      this card's closeout surfaces.

## Lane Runway Context

- Higher-level lane owner: `g02.050`.
- Next likely milestone: live operator use of chatterbox beside an active
  orchestrator; optional queue-plugin adapter if the operator drops one.
- Next planning checkpoint: after merge, refresh triage capture wording
  from live use if the enough-bar or ping is awkward.

## Acceptance Criteria

- [x] chatterbox mode and thin adapter exist; public skill count stays one;
- [x] operator start needs no handoff;
- [x] Paseo spawn uses a same-checkout `local` workspace,
      `Chatterbox=true`, and `notifyOnFinish` false;
- [x] git protocol isolates exact-path commit of unique triage notes and
      fails closed against pre-existing staged files (proven with temporary
      repository fixture);
- [ ] idle-only ping (paused at planning: status check plus send_agent_prompt is
      non-atomic and cannot guarantee never prompting a running orchestrator
      pending an atomic queue);
- [x] orchestrator intake handling does not change current work;
- [x] chatterbox refuses implement/promote/dispatch/review/merge;
- [x] research-subagent copy no longer says "advisors";
- [x] adapter/router wiring checks, fixture tests, docs QA, full QA, and
      `git diff --check` pass.

## Review Oracle

Copy the eight rows from spec 035. Do not add material acceptance during
review.

## Evidence Required

- before/after router, adapter, and role-table inventory;
- all eight oracle scenarios with expected failures named;
- command-skills and skill-install transcripts;
- `effigy qa:docs`, `effigy qa`, and `git diff --check`;
- closeout log, reviewable PR, and exact tested head.

## Stop Conditions

- card 120 still owns overlapping skill or closeout surfaces;
- implementation needs a Paseo product/API change or queue plugin;
- unique-file git protocol cannot be kept;
- a handoff, worktree, or PR becomes required for capture;
- validation changes the plan.

## Next Task

Launch one worker from
`docs/handoffs/20260903-181459-add-chatterbox-intake-channel.md`. Stop for
orchestrator exact-head review of its PR; do not begin a queue plugin or live
operator-use follow-up from this card.
