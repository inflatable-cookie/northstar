# 127 - Chatterbox Sibling Agent Tabs

Status: complete; reviewable PR pending
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Master roadmap: `g02.052`
Governing refs: `docs/roadmaps/g02/052-chatterbox-sibling-agent-tabs.md`,
`docs/specs/035-chatterbox-intake-channel.md`,
`docs/contracts/001-working-rules.md`
Auto-start next card: no

## Objective

Correct the Paseo chatterbox spawn topology: the chatterbox is a
parent-attached child agent in the coordinator's current workspace (a sibling
agent tab), never a separate workspace.

## Scope

- spec 035 start paths, acceptance criterion, and review-oracle row;
- orchestrator mode `## Chatterbox spawn and intake` bullets;
- working rules chatterbox paragraph (live and copy-ready template);
- doctrine 07 chatterbox intake channel spawn bullet;
- architecture chatterbox paragraph;
- `check:command-skills` structural assertion for the sibling-tab rule;
- card, milestone, one closeout log, handoff, and front doors.

Out of scope: chatterbox authority, notification boundary, Git isolation,
model routing, worker/review-child/continuation workspaces, card 126.

## Ready-state checks

- [x] operator confirmed the sibling-tab correction;
- [x] no active worker owns the touched surfaces;
- [x] card 126 remains separate and blocked.

## Acceptance criteria

- [x] every live launch surface names the current-workspace sibling child and
      rejects a separate, `branch-off`, or different-project transport;
- [x] the manual same-checkout start instruction is retained;
- [x] `Chatterbox=true`, `notifyOnFinish: false`, conversational routing,
      identity retention, and exact-file Git isolation are unchanged;
- [x] worker, review-child, and continuation workspace parentage untouched;
- [x] the structural checker proves the chatterbox section requires the
      sibling child and no longer creates a workspace;
- [x] command-skills, isolated skill-install, docs QA, full QA, and
      `git diff --check` pass.

## Evidence required

- before/after spawn-wording map across the touched surfaces;
- checker result proving the chatterbox section requires the sibling child
  and rejects the separate workspace;
- `effigy check:command-skills`, isolated `effigy check:skill-install
  skills/northstar`, `effigy qa:docs`, `effigy qa`, and `git diff --check`;
- reviewable PR and exact tested head.

## Stop conditions

- Paseo cannot attach a child to the current workspace without creating one;
- the correction drifts into authority, notification, routing, or Git
  isolation changes;
- validation changes the plan.

## Next task

Exact-head review and merge of this PR; installed-skill refresh follows
merge. Card 126 stays blocked on its observation packet and stop date.
