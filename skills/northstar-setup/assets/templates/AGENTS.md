# {{PROJECT_NAME}} AGENTS

This file applies to the whole repository.

If this repo is only a thin workspace container, keep the top-level AGENTS
focused on orchestration and route the real docs contract through the nested
docs-authority repo instead of copying the full single-repo contract here.

## Start Here

```sh
effigy tasks
effigy doctor
effigy test --plan
```

Then prefer `effigy <task>` for supported repo work before falling back to raw
tools.

## Default Loop

```sh
effigy tasks
effigy doctor
effigy test --plan
effigy qa
```

Use `--repo <PATH>` only when you intentionally want to target a different
repository.

## Docs Authority

- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

If those files live in a nested docs-authority repo instead of this root, point
agents there explicitly and keep this root focused on orchestration tasks.

## Continuation Rule

In a strict Northstar lane, a bare `continue` should be enough.

Treat it as:

- resume from the previous closeout's `Next Task`
- re-anchor on the current ready card or explicit stop/reassessment step
- stay inside that bounded lane unless the file state itself requires a stop

Do not rely on giant continuation prompts if the repo surfaces already carry
the active card, boundaries, validation, and closeout requirements.

## Planning Ambiguity Rule

When planning is needed and the next direction is not clearly settled in the
repo's authority surfaces, stop and ask for operator intent instead of
guessing.

Do this especially when:

- more than one reasonable next lane or batch exists
- a milestone may close, continue, or hand off
- the choice depends on product priority rather than missing file updates
