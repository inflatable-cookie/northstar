# 002 - Agent Local Paths and Manual Worktree Locations

Status: active
Owner: repo maintainers
Updated: 2026-08-16
Depends on: `docs/contracts/001-working-rules.md`
Affects: `AGENTS.md`, `skills/northstar/`, `template-bundle/`,
`docs/handoffs/`, and manual worker launch procedures

## Purpose

Agents sometimes need local paths that are valid on one machine but must never
be committed into a repository. The repository needs one predictable place for
those values, especially when a subagent has to create a Git worktree manually.

The local path registry is deliberately separate from the planning spine and
from credentials. It is a small dotenv-shaped file for paths only, not a shell
script and not a secret store.

## Files

- `.agents.local.env.example` is tracked and documents the supported keys.
- `.agents.local.env` is local-only, ignored by Git, and created on first need.
- `AGENTS.md` is the required discovery point for the contract.

Worker-mode agents must read `.agents.local.env` when a worker task needs a
manual local path. Normal-mode agents must not inspect or require it merely
because the repository supports worker lanes. A valid harness-provided worker
location is sufficient and does not require this file.

## Supported keys

| Key | Required when | Meaning |
| --- | --- | --- |
| `AGENTS_WORKTREE_CONTAINER_DIR` | a manual worktree is required | Absolute directory under which agent-created worktrees live. |
| `AGENTS_SCRATCH_DIR` | a shared scratch location is useful | Optional absolute directory for temporary reports and non-repository scratch files. |
| `AGENTS_ARTIFACT_DIR` | large local outputs should stay outside the repo | Optional absolute directory for generated artifacts that are not part of the commit. |

Only path-valued, namespaced `AGENTS_*` keys belong in this file. Do not put API
keys, tokens, passwords, credentials, connection strings, or arbitrary commands
in it. Read `KEY=VALUE` entries as data; never execute or `source` the file.

## Worker-mode first-use procedure

1. Prefer the worktree, scratch area, or artifact location supplied by the
   harness. A clean, dedicated, non-`main` worktree registered by Git in the
   current launch context is sufficient evidence that the harness owns it, even
   when its generated path or branch differs from a handoff placeholder. Record
   the actual path/branch and do not create a second manual location.
2. If a manual worktree is required, read `.agents.local.env`.
3. If the file is absent or `AGENTS_WORKTREE_CONTAINER_DIR` is empty/invalid,
   stop before creating a worktree and ask the operator exactly:

   > What absolute directory should this repository use as its manual worktree
   > container? I will store it in untracked `.agents.local.env` as
   > `AGENTS_WORKTREE_CONTAINER_DIR=...` and use a separate subdirectory per
   > repository and lane.

4. After the operator supplies the path, create `.agents.local.env` with the
   chosen value, create or validate the container directory, and record the
   resolved path in the handoff or launch report.
5. Create each manual worktree below that container, using a stable path such
   as `<container>/<repository-slug>-<lane-slug>`. The path must not be the
   current checkout, a repository child, an arbitrary `/tmp` path, or a guessed
   sibling directory.
6. If the directory cannot be validated or created, stop and report the
   boundary failure. Do not fall back to `TMPDIR`, `/tmp`, or another guessed
   location.

## Worker-mode nested-agent boundary

A worker or subagent must not start a second orchestrator workflow, dispatch a
new worker, or create a nested worktree unless the operator explicitly assigned
that separate lane and the local-path contract is satisfied. When a harness or
parent orchestrator already owns the worktree, use it and do not create another
one.

## Handoff requirements

A worker handoff must state whether the worktree is harness-managed or manual. For
a manual fallback it must point to the resolved local container path, not a
hard-coded temporary directory. A worker that cannot establish this boundary
stops before editing.
