---
title: g03.010 — Adopt the Effigy-hosted lifecycle hook
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-13
updated: 2026-09-13
base_required: pushed-main
roadmap: docs/roadmaps/g03/010-adopt-effigy-hosted-lifecycle-hook.md
queue_dispatch: northstar-queue
queue_approval: "Tom approved the Queue/Effigy/Northstar runtime direction and confirmed Queue g01.013 landed on 2026-09-13."
queue:
  capability: complex
  skipPRReview: false
---

## What This Thread Was Doing

Implement [`g03.010`](../roadmaps/g03/010-adopt-effigy-hosted-lifecycle-hook.md):
replace Northstar's copied repository hook runtime with Queue's trusted `effigy`
runner and the auto-resolved `northstar/queue:hook` skill selector.

## Why It Matters

Northstar should own lifecycle logic once, inside its portable skill. Queue should
execute a generic approved host tool, and consumer repositories should carry only
configuration and generated state. The current copied runtime makes upgrades and
portfolio adoption needlessly heavy.

## Current State

- Repository: `/Users/tom/Dev/projects/northstar`.
- Canonical task: [`g03.010`](../roadmaps/g03/010-adopt-effigy-hosted-lifecycle-hook.md),
  the sole approved frontier.
- Northstar main is clean at the planning commit derived from `c9e3533`.
- Queue `g01.013` is complete at `bd3eb8b`; Effigy skill resolution and exact
  stdio passthrough are accepted at `4f2b466`.
- Queue trusted runner `effigy` is healthy on host `srv_FQNrK3mv8-wL`, revision
  1, at digest `sha256:86994ae8cd0f6528d26dc2cdb1006973b828ff9adcb9fc368c7cbebdda27e749`.
- The current committed v1 launcher remains the bootstrap route until this PR
  merges. The merged closeout must use v2 and prove the new route.
- Worker capability: automatic `complex` pool. Independent review must use a
  distinct provider/model identity.
- Required sibling worktree links: none.

## Boundaries

Implement the complete `g03.010` task. Keep Queue generic, Effigy skill-generic,
Northstar provider-neutral, and standalone lifecycle maintenance available without
Queue.

Do not edit Queue or Effigy source, mutate Queue's trusted-runner registry, roll out
consumer repositories, open a new generation, compact `g03`, add a compatibility
launcher, edit CI, release, force-push, or remove any thread or workspace. Do not
perform manual post-merge closeout edits; the required hook owns the terminal
record, projections, and exact handoff deletion.

## Important Context

- The frozen Queue argv is exactly
  `["skill", "run", "northstar/queue:hook", "--stdio", "passthrough"]`.
- Use `{skill}` for skill-owned scripts. The repository remains Effigy's consumer
  target and cwd; no `--path` or `--json` is allowed on the hook route.
- Remove `.paseo/hooks/**`, the starter hook payload, and the runtime copier only
  when their callers, doctrine, and checks move in the same change.
- Retain strict v1 event/result behavior for existing consumers while adding v2
  control-manifest validation. Do not keep the retired deployment shape as a shim.
- The closeout transition crosses the boundary: pre-dispatch uses v1 from the
  planning base; post-merge closeout must use v2 from merged synchronized main.

## Suggested Next Move

Start with catalog resolution and v2 manifest parsing, then convert focused fixtures.
Only after project-local/global and exact-stdio proofs pass should you delete the
copied runtime and switch the live manifest.

## Completion Protocol

Use the Queue-provided worktree and verify its clean Queue-owned branch before
editing. Implement every work and oracle row in `g03.010`. Run focused catalog,
stdio, v1/v2 manifest, missing-prerequisite, standalone lifecycle, starter consumer,
and no-copied-runtime checks; then `effigy qa:docs`, `effigy qa`,
`effigy check:posture-advisory`, and `git diff --check`.

Commit only authorized paths, push the Queue-owned branch, open one non-draft PR
against `main`, and report `ready_for_review` through the supplied authenticated
Queue callback with the PR number and exact clean head. Stop after acceptance. Do
not merge, edit integration main, or write closeout evidence. Queue owns independent
review, merge, synchronized-main reconciliation, and the required v2 hook
publication.
