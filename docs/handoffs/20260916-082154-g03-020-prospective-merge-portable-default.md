---
title: g03.020 — Make prospective merge the portable default
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
status: ready-to-launch
owner: Tom
created: 2026-09-16
updated: 2026-09-16
base_required: pushed-main
roadmap: docs/roadmaps/g03/020-prospective-merge-portable-default.md
queue_dispatch: northstar-queue
queue_approval: "Tom confirmed the Northstar v4 producer update and cross-project protocol rollout with 'Go for it' on 2026-09-16."
queue:
  capability: complex
  skipPRReview: false
  notifyOriginOnCloseout: true
---

## What This Thread Was Doing

Implement g03.020. Make the already-accepted prospective-merge Queue protocol
Northstar's portable default and provide the exact migration surface needed for
the authorized consumer rollout.

## Why It Matters

Northstar's hook can enforce the merge candidate correctly, but its dogfood,
template and bundle documentation still create v3 reviewed-head consumers.
Thirty repositories therefore retain the stale-branch false-refusal behavior
that v4 was built to remove.

## Current State

Northstar main is clean and synchronized at the planning commit containing this
handoff. g03.019 is terminal and the installed global skill matches its v4
schema and hook implementation. Bovine is the sole live v4 consumer; 30 other
manifests remain v3 with `reviewed_head`.

Read g03.020, contract 001, the lifecycle reference, Queue Spec 015, dogfood and
template manifests, lifecycle adoption fixtures, repository-contract oracle and
the lifecycle skill command router before editing. Required sibling worktree
links: none. Use the automatic complex-capable pool; frontier-worker
justification: none.

## Boundaries

Own only Northstar producer surfaces and the generic migration command named by
g03.020. Preserve strict old-version compatibility, candidate identity proofs,
hook semantics, raw transport, generated lifecycle state and installed-skill
resolution.

Do not edit a consumer repository, Queue, Effigy or provider settings. Do not
run a portfolio write loop, mutate live Queue tasks, release, edit CI, restart
Paseo or change thread/workspace disposition.

## Important Context

The migration is exactly schema v3 to v4 plus the pre-merge target from
`reviewed_head` to `prospective_merge`. It is safe only for the conforming
trusted-runner shape. Dry-run must precede write, divergent inputs fail closed,
and replay on compliant v4 is a no-op.

The command supplies evidence; it does not own Git or planning. Chatterbox will
create and dispatch repository-local follow-ons after this task merges and the
installed skill matches source.

## Suggested Next Move

Start by updating dogfood, template and their assertions together. Then add the
minimal migration command around the existing strict manifest schemas. Lock its
byte isolation and refusal cases down before changing doctrine or fixtures.

## Completion Protocol

Run focused lifecycle adoption, command and repository-contract tests, then
`effigy qa`, skill validation, source/installed parity and `git diff --check`.
Commit only owned paths, push one non-draft PR and report `ready_for_review`
through the authenticated Queue callback. Independent review must use another
provider/model identity.

Do not merge, refresh the installed skill, mutate consumers or begin the
portfolio rollout. Queue and Chatterbox own those steps after accepted review.
