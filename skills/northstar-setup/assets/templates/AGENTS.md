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
