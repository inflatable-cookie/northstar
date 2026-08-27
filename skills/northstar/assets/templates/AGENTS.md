# {{PROJECT_NAME}}

<!-- Replace this comment with two or three sentences: what the project is, who
it serves, and the simplest useful mental model. Write as a maintainer speaking
to a capable collaborator, then remove the comment. -->

## What must stay true

<!-- Name the few product or system properties every change should preserve.
Include the shortest reason that helps an agent apply each invariant to a new
case. Distinguish hard boundaries from normal defaults and engineering taste. -->

- Use the repository's canonical docs and ready-card surfaces. Do not invent a
  parallel planning authority.
- Keep the implementation real and end-to-end. Prefer explicit incompleteness
  over a placeholder that looks finished.
- Do not run release mutations or change CI/workflow files without an explicit
  operator request.

## How work moves here

In this repo, normal-mode agents use the current checkout and follow the task's
canonical docs. Worker mode is activated only by an explicit
orchestrator-dispatched handoff; read that handoff instead of inferring worker
mode from a path, branch, or harness.

Work in meaningful batches. If planning authority does not settle the next
direction, stop and ask. Keep continuation inside the current bounded lane.
Treat `docs/triage/` as a buffer of leads to promote or remove, never as
execution authority.

## Sharp edges

<!-- Keep this list short and project-specific. Explain how each costly mistake
happens and what it harms; do not paste an exhaustive security catalogue. -->

- Do not weaken a safety, compatibility, data, or authority boundary to make a
  local change easier. Raise the trade-off with its impact and options.

## Finding your way

Start with `effigy tasks`. Use `effigy doctor` only when routing or environment
state is uncertain; doctor is orientation, not the validation board. Prefer
`effigy <task>` for supported work and use `--repo <PATH>` only for another
repository. Do not add package scripts that merely re-export Effigy.

The common authority map is:

- `docs/README.md` — project and docs front door;
- `docs/roadmaps/README.md` — active work and next-task pointer;
- `docs/logs/README.md` — recent evidence;
- `docs/triage/README.md` — unresolved capture;
- `docs/contracts/001-working-rules.md` — delivery and closeout;
- `docs/contracts/002-agent-local-paths.md` — machine-local paths;
- `docs/contracts/003-agent-instruction-surface.md` — AGENTS design.

Use nested `AGENTS.md` files for path-specific rules, contracts for durable
boundaries, guides for procedures, and skills for task-specific workflows.

## What complete means

<!-- Add the smallest project-specific coverage lens: clients, reverse states,
connection modes, contracts, or other surfaces commonly missed by a plausible
partial change. A conscious “not supported here” decision can be complete. -->

Run `effigy qa` for normal validation. During execution, record a small,
recurring, solvable hurdle in `PAPERCUTS.md` under the working-rules contract;
do not turn it into unplanned work.
