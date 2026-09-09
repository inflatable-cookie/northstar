# Roadmaps

**Type: REQUIRED**

Roadmaps are executable task plans derived from vision, architecture, and contracts.

## Generation model

- Use generation folders: `g01`, `g02`, `g03`.
- Use task files inside each generation: `001-<slug>.md`.
- Reference tasks as `gNN.NNN`.

## Layout

- `g01/` first generation tasks
- `generation-index.md` active generation and rollover history
- `docs/triage/` holds unresolved or deferred candidates until promotion

## Rule

- Execute tasks in a reviewable order.
- Keep a `## Generation Runway` in each active `gNN/README.md` so the next
  task comes from generation intent, not ad-hoc planning after a lane
  closes.
- Update the generation runway only when strategy, task state, or rollover
  state changes materially.
- Write the runway for a significant 20-to-50-task generation; it does not
  need to pre-plan every task up front.
- Record evidence on each completed task, not per individual step.
- Stop execution when a task reveals a missing contract or planning gap.
- In parallel mode, each generation operates as its own queue.

## Next Task

Create the first task in `g01/` only after the relevant contracts exist.
