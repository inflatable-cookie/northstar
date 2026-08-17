# {{PROJECT_NAME}} AGENTS

Scope: whole repository. If this is only a thin workspace container, keep this
file focused on orchestration and point to the nested docs-authority repository.

## Always-loaded boundaries

- Use the repository's canonical docs and ready-card surfaces; do not invent a
  parallel planning authority.
- In this repo, normal-mode agents use the current checkout and follow the
  task's canonical docs. Worker mode is activated only by an explicit
  orchestrator-dispatched handoff; read that handoff for its worker execution
  contract instead of inferring worker mode from a path, branch, or harness.
- If planning authority does not settle the next direction, stop and ask. Keep
  continuation inside the current bounded lane.
- Do not run release mutations or change CI/workflow files without an explicit
  request.

## Common commands

```sh
effigy tasks
effigy doctor       # only when routing or environment state is uncertain
effigy qa
```

Prefer `effigy <task>` for supported work and use `--repo <PATH>` only for a
different repository. Do not add package scripts that merely re-export Effigy.

## Docs authority

- `docs/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`
- `docs/contracts/001-working-rules.md`
- `docs/contracts/002-agent-local-paths.md`
- `docs/contracts/003-agent-instruction-surface.md`

During execution, record a small recurring solvable hurdle in the owning
repository's `PAPERCUTS.md` according to the working-rules contract; do not make
that observation unplanned work.

## Read on demand

Use nested `AGENTS.md` files for path-specific rules, contracts for durable
boundaries, guides for procedures, and skills for task-specific workflows. Keep
this root file limited to facts useful on most turns.
