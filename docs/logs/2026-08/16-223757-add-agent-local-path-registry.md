# Add an agent-local path registry and manual-worktree boundary

Date: 2026-08-16
Status: applied directly on `main`

## Context

A subagent run created a manual worktree under an awkward temporary path while
an orchestrator thread already owned the lane. That made Git and repository
search behavior harder to reason about and exposed a gap between the normal
harness-managed path and the manual fallback described by Northstar.

## Decision

Northstar now uses an ignored, dotenv-shaped path registry:

- tracked `.agents.local.env.example` documents the supported path keys;
- ignored `.agents.local.env` stores machine-local path values only;
- `AGENTS_WORKTREE_CONTAINER_DIR` is required before manual worktree creation;
- `AGENTS_SCRATCH_DIR` and `AGENTS_ARTIFACT_DIR` are optional extensions;
- agents prefer harness-managed locations and do not create a second worktree;
- when the manual container is missing, the agent stops and asks the operator for
  an absolute directory before creating the file or worktree;
- `/tmp`, `TMPDIR`, guessed siblings, and repository-child worktrees are not
  valid fallbacks;
- workers and subagents do not start nested orchestrator/worker lanes when a
  parent harness or orchestrator already owns the lane.

The canonical contract is `docs/contracts/002-agent-local-paths.md`. The rules
are surfaced in `AGENTS.md`, the orchestrator protocol, the handoff template,
the copy-ready template bundle, and the distributed Northstar skill.

## Cleanup

The clean, stopped card-078 worktree created during the earlier mistaken launch
was removed. No Poodle or Figmatic files were changed, and no PR was opened or
merged for that lane.

## Validation

- `git diff --check` — passed
- `effigy qa` — passed
- `effigy qa:docs` — passed
- `effigy check:readiness-map` — passed
- `effigy test:readiness-map` — passed, 5 fixtures
- `effigy doctor` — passed, 19 OK / 0 warnings / 0 errors
- installed Northstar skill parity — passed for `/Users/tom/.agents/skills/northstar` and `/Users/tom/.hermes/skills/northstar`, 34 files each
