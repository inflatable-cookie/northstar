# 052 - Chatterbox Sibling Agent Tabs

Status: complete; card 127 merged through PR 33 as `7d3bfd1`
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Depends on: `g02.050`, `g02.051`, spec 035
Vision tags: `chatterbox`, `paseo`, `orchestration`
Governing refs: `docs/specs/035-chatterbox-intake-channel.md`,
`docs/specs/036-economical-orchestrator-coordination.md`,
`docs/contracts/001-working-rules.md`

## Problem

The installed chatterbox spawn instruction creates a separate `local`
workspace for every chatterbox. That separates the coordinator and its
chatterbox tabs in the sidebar and invents a workspace lifecycle the role does
not need, because chatterboxes already share the coordinator's checkout.

## Goals

- spawn Paseo chatterboxes as parent-attached child agents in the
  coordinator's current workspace, visible as sibling agent tabs;
- allow several independent chatterboxes as sibling tabs in that workspace;
- reject any chatterbox transport that creates a new workspace, uses
  `branch-off` worktree isolation, or attaches a different project path.

## Non-goals

- no change to worker, review-child, or fresh-orchestrator-continuation
  workspace parentage rules;
- no change to chatterbox authority, notification behavior, conversational
  routing, manual fallback, or exact-file triage Git isolation;
- no new public skill, mode, template, or command;
- no card 126 work.

## Execution plan

- [x] **Card 127** applies the sibling-tab spawn rule across spec 035,
      orchestrator mode, working rules (live and copy-ready), doctrine 07,
      architecture, and the command-skills checker.

## Review oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Chatterbox stays in the coordinator workspace. | Spawn creates a separate `local` workspace for the chatterbox. | Reject the transport plan; attach the child agent to the current workspace. | `check:command-skills` chatterbox-spawn assertion; exact-head review. |
| Other workspace parentage unchanged. | Review child, worker, or successor loses its dedicated workspace rule. | Worker, review-child, and continuation workspace rules stay as written. | Exact-head diff review of the touched sections. |
| Spawn contract otherwise unchanged. | Label, notification, routing, prompt, or identity-retention rule drifts. | Keep `Chatterbox=true`, `notifyOnFinish: false`, diversified conversational routing, topic prompt, and identity retention. | Exact-head review of the touched bullets. |

## Stop conditions

- the Paseo adapter cannot attach a child agent to the current workspace
  without creating a workspace;
- the correction would alter chatterbox authority, notifications, Git
  isolation, or model routing;
- validation changes the plan.

## Next task

Complete. Card 126's observation packet and stop date remain the following
open task.
