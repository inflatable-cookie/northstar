# Repo Contract

Use this contract when a repo should mean the same thing when an agent is told
"use Northstar and Effigy."

## Minimum Files

- `AGENTS.md`
- `effigy.toml`
- `CHANGELOG.md`
- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

For workspace-container repos, keep the workspace root lean and apply this full
file set inside the nested docs-authority repo instead of duplicating it at the
top level.

Do not force `CHANGELOG.md` and release config onto the workspace root or the
docs-authority repo unless one of those repos is actually a releasable artifact.
Keep release posture on the repos that really ship code or packages.

## Minimum Semantics

- `effigy tasks`
- `effigy doctor` or `effigy health`
- `effigy test --plan`
- `effigy qa`
- `qa:docs`
- `qa:northstar`

## Minimum Docs Model

- `vision` defines long-horizon outcome and strategic constraints
- `roadmaps` define milestone queue and execution batches
- `logs` record meaningful evidence and decisions

Do not collapse all three into a single generic planning note.

## Minimum Agent Contract

- start with Effigy, not raw shell commands
- prefer built-in `effigy test` unless the repo intentionally overrides it
- use `--repo <PATH>` only for a different repo
- leave one explicit next task in the current planning surface

## Minimum Release Posture

- maintain `CHANGELOG.md`
- define a release-readiness validation path
- use native Effigy release config when the installed surface supports it
- otherwise keep release posture explicit through changelog plus QA tasks

For workspace-container repos, add release posture only to the repos that are
actually releasable. Do not force a docs-only authority repo to pretend it
ships releases if that is not true.
