# 002 - Agent Local Paths and Manual Worktree Locations

**Type: TEMPLATE** -- Copy into `docs/contracts/002-agent-local-paths.md` when a
project uses agent-managed local paths or manual worktrees.

Status: active
Owner: <owner>
Updated: YYYY-MM-DD
Depends on: `docs/contracts/001-working-rules.md`

## Purpose

Agents sometimes need local paths that are valid on one machine but must never
be committed. Keep those values in the ignored `.agents.local.env` file rather
than in tracked docs, shell history, or ad hoc prompts.

## Files

- `.agents.local.env.example` is tracked and documents supported keys.
- `.agents.local.env` is local-only, ignored by Git, and created on first need.
- `AGENTS.md` references this contract and the first-use procedure.

## Supported keys

| Key | Required when | Meaning |
| --- | --- | --- |
| `AGENTS_WORKTREE_CONTAINER_DIR` | a manual worktree is required | Absolute directory under which agent-created worktrees live. |
| `AGENTS_SCRATCH_DIR` | shared scratch is useful | Optional absolute directory for temporary reports and scratch files. |
| `AGENTS_ARTIFACT_DIR` | large local outputs stay outside the repo | Optional absolute directory for generated local artifacts. |

This file is path-only. Never put API keys, tokens, passwords, credentials,
connection strings, or commands in it. Read simple `KEY=VALUE` entries as data;
do not execute or `source` the file.

## First-use procedure

- Prefer a harness-managed worktree or artifact location when one is supplied.
- Before creating a manual worktree, read `.agents.local.env`.
- If it is absent or `AGENTS_WORKTREE_CONTAINER_DIR` is empty/invalid, stop and
  ask the operator:

  > What absolute directory should this repository use as its manual worktree
  > container? I will store it in untracked `.agents.local.env` as
  > `AGENTS_WORKTREE_CONTAINER_DIR=...` and use a separate subdirectory per
  > repository and lane.

- After the operator answers, create the file, validate/create the directory,
  and use `<container>/<repository-slug>-<lane-slug>` for manual worktrees.
- Never guess a path or fall back to `/tmp`, `TMPDIR`, a repository child, or an
  arbitrary sibling directory.
- If validation or creation fails, stop and report the boundary failure.

A worker or subagent must not start a second orchestrator workflow or create a
nested worktree when a parent harness/orchestrator already owns the lane.
