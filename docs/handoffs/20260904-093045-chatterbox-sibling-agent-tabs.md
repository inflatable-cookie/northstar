---
title: Chatterbox sibling-agent topology handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: complete; merged through PR 33 as 7d3bfd1
owner: repo maintainers
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-093045-chatterbox-sibling-agent-tabs.md
base_required: pushed-main
tags: [chatterbox, paseo, workspace, orchestration]
---

## What This Thread Was Doing

The operator confirmed one correction to the Chatterbox topology. In Paseo,
the coordinator and its Chatterbox threads should be sibling agent tabs inside
the coordinator's existing workspace. The current installed skill instead
creates a separate `local` workspace for every Chatterbox.

This is an operator-confirmed promotion and implementation brief. Do not reopen
the product decision.

## Why It Matters

Chatterbox is the coordinator's nearby operator-facing planning channel. A new
workspace separates the two tabs in the sidebar and misstates the intended
relationship. Keeping them in one workspace also preserves one shared checkout
without inventing another workspace lifecycle.

## Current State

- Planning base: `862b1ab26343a8763607d13392422b714d9ca696` on pushed `main`.
- Installed and source orchestration currently say to create a separate
  `local` workspace for Chatterbox.
- The economical coordinator split is complete through PR 32.
- Card 126 remains blocked on its observation packet and stop date and is not
  part of this lane.
- No sibling worktree links are required.

## Decisions Already Made

- In Paseo, create Chatterbox as a parent-attached child agent in the
  coordinator's current workspace. It appears as a sibling agent tab beside
  the coordinator.
- Do not create a new workspace for Chatterbox.
- Keep `Chatterbox=true`, `notifyOnFinish: false`, the conversational profile
  selection rule, direct operator conversation, shared checkout, and exact-file
  triage-note Git isolation.
- Multiple independent Chatterboxes may coexist as sibling agent tabs in that
  workspace.
- Worker workspaces, review-child PR-head workspaces, fresh-orchestrator
  continuation workspaces, and their parentage rules do not change.
- Without Paseo, retain the manual same-checkout Chatterbox instruction.

## Open Questions

None. If the available Paseo child-agent API cannot attach a new agent to the
current workspace without creating a workspace, stop with the exact adapter
gap rather than restoring the separate-workspace behavior.

## Suggested Next Move

Implement the correction as one bounded Northstar PR. Use the next available
g02 milestone/card numbers, update the canonical and copy-ready surfaces that
describe Chatterbox launch, add structural validation only where it helps, and
record one closeout log. Keep the prose compact and remove the superseded
separate-workspace instruction everywhere live.

## Completion Protocol

1. Run the worker startup safety check and use the launcher-provided dedicated
   worktree/branch.
2. Read `AGENTS.md`, specs 035/036, working rules, orchestrator and Chatterbox
   modes, architecture inventory/topology, reusable doctrine, copy-ready
   template, and current command-skill checks.
3. Reproduce the current separate-workspace instruction before mutation.
4. Implement only the confirmed topology above. Do not alter Chatterbox
   authority, notification behavior, Git isolation, model routing, or other
   agent roles.
5. Reconcile the new milestone/card, one dated log, this handoff, and affected
   front doors. Leave card 126 unchanged and blocked.
6. Run `effigy check:command-skills`, isolated
   `effigy check:skill-install skills/northstar`, `effigy qa:docs`, `effigy qa`,
   and `git diff --check`.
7. Commit, push, open a review-only PR against `main`, and report its URL and
   exact tested head. Do not merge.

## Outcome Record

- **Worker branch:** `worker/chatterbox-sibling-agent-tabs`; Paseo-managed
  dedicated worktree based on pushed `main` at `862b1ab`.
- **Roadmap milestone:** `docs/roadmaps/g02/052-chatterbox-sibling-agent-tabs.md`
- **Ready card:** `docs/roadmaps/g02/batch-cards/127-chatterbox-sibling-agent-tabs.md`
- **Closeout log:** `docs/logs/2026-09/04-093820-chatterbox-sibling-agent-tabs.md`
- **PR base/head:** `main` <- `worker/chatterbox-sibling-agent-tabs`
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/33
- **Review state:** accepted by an independent review child at exact head
  `fcd882a6`; zero blocking findings.
- **Merge:** PR 33 merged as `7d3bfd1`; the installed 113-file skill payload
  matches the tracked merge archive.
- **Card 126:** unchanged and still blocked.
