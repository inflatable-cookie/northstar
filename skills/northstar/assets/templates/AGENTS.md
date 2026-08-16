# {{PROJECT_NAME}} AGENTS

Scope: whole repository. If this is only a thin workspace container, keep this
file focused on orchestration and point to the nested docs-authority repository.

## Always-loaded boundaries

- Use the repository's canonical docs and ready-card surfaces; do not invent a
  parallel planning authority.
- Prefer harness-managed worktrees. Manual worktrees require the operator's
  absolute `AGENTS_WORKTREE_CONTAINER_DIR` in ignored `.agents.local.env`; never
  guess a path, use `/tmp`/`TMPDIR`, or create a repository-child worktree.
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
