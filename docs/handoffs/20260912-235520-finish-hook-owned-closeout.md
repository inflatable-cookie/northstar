---
title: g03.007 — Finish hook-owned closeout
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-12
updated: 2026-09-12
base_required: pushed-main
roadmap: docs/roadmaps/g03/007-finish-hook-owned-closeout.md
queue_dispatch: northstar-queue
queue_approval: "Tom said 'Continue' after Queue g01.010 landed and the plugin-only reload succeeded on 2026-09-12, authorizing the remaining bounded live hook proof."
queue:
  capability: complex
  skipPRReview: false
---

## What This Thread Was Doing

Implement [`g03.007`](../roadmaps/g03/007-finish-hook-owned-closeout.md):
finish Northstar's hook-owned closeout so this task itself closes with terminal
JSON, current projections, and exact handoff consumption, without a closeout
agent or a manual integration edit.

## Why It Matters

Queue now selects closeout authority correctly per repository. Northstar's hook
can publish terminal records, but its templates and front doors still ask
humans or agents to maintain duplicate status, evidence, and frontier prose,
and the hook leaves the transient handoff behind. The cutover is incomplete
until those writes disappear and one natural task proves the whole route live.

## Current State

- Repository: `/Users/tom/Dev/projects/northstar`.
- Canonical task: [`g03.007`](../roadmaps/g03/007-finish-hook-owned-closeout.md),
  the sole approved frontier.
- Governing sources: spec 040, system architecture, contract 001, reusable
  section 12, and the installed lifecycle reference.
- Queue g01.010 merged in PR #11 as `bddc8fb`; canonical Queue closeout is
  `ba6951c`. `northstar-queue` was typechecked, reloaded, and is running.
- Northstar's committed manifest has one required integration-write
  `task.closeout` hook, so Queue must select hook authority for this task.
- `g03.006` is the only current lifecycle record. Earlier g03 tasks retain
  their existing Git and task evidence without synthetic records.
- Worker capability: automatic `complex` pool. No by-request frontier profile
  is required. Independent review must use a distinct provider/model identity.
- Required sibling worktree links: none.

## Boundaries

Implement the complete g03.007 task and its self-hosting proof. Preserve
portable standalone operation, Queue's generic event boundary, evidence levels,
human semantic planning, exact-path containment, deterministic output, and all
existing consumer lifecycle behavior.

Do not edit Queue source or live database state, change Queue fallback
behavior, fabricate historical records, automate semantic priority, roll or
compact g03, migrate consumer repositories, add UI, edit CI, release, restart
Paseo, force-push, or remove any thread/workspace. Do not perform post-merge
closeout edits; the required hook owns them.

## Important Context

- The closeout hook runs from the exact synchronized integration commit in a
  Queue-owned isolated clone. Its manifest and executable are pinned from that
  commit, so this PR may safely update its own closeout behavior and allow-list.
- The task's instruction path and blob are already pinned in Queue delivery.
  Use those facts to remove only the consumed handoff. Git retains the blob;
  the lifecycle receipt retains its identity.
- The active generation README must become a declared projection target.
  Human text outside generated blocks must retain meaning without restating
  mutable lifecycle state.
- Task Markdown remains the semantic contract. Mechanical status, PR/review/
  merge identities, validation receipt, and completion live in JSON and
  deterministic projections.
- Spec 040 is active only because its lasting clauses were not fully repointed.
  Audit before deletion; do not discard unique meaning.
- After merge, success requires Queue detail to show a published required hook,
  terminal task state, no closeout run, and no closeout workspace. Any hold is
  repaired through the same hook event.

## Suggested Next Move

Start with the authority inventory: identify every mutable duplicate and every
unique spec 040 clause. Update the durable doctrine and templates, then extend
the hook's exact handoff cleanup and projection targets with real-Git failure
fixtures. Finish by making the merged tree ready for its own hook closeout;
avoid a separate manual closeout path in tests or documentation.

## Completion Protocol

Use the launcher-provided worktree and verify its clean Queue-owned branch
before editing. Implement every work and oracle row in g03.007. Run focused
lifecycle, installed-consumer, projection, containment, and Queue-contract
fixtures; then `effigy qa:docs`, `effigy qa`,
`effigy check:posture-advisory`, and `git diff --check`.

Commit only authorized paths, push the Queue-owned branch, open one non-draft PR
against `main`, and report `ready_for_review` through the supplied authenticated
Queue callback with the PR number and exact clean head. Stop after acceptance.
Do not merge, reload plugins, edit integration main, or write closeout evidence.
Queue owns independent review, merge, synchronized-main reconciliation, and the
required hook publication. Chatterbox inspects the final live proof only after
Queue reaches a terminal state.
