# Roadmaps

Roadmaps sequence approved Northstar work. Only the active sequential
generation remains expanded.

## Current state

- Active generation: [`g03`](./g03/README.md)
- Last completed task: `g03.002` consumer compaction
- Active task: [`g03.003`](./g03/003-flatten-execution-tasks.md)
- Approved frontier: `g03.003` only
- Closed generations: [`g01`](./archive/g01.md) and [`g02`](./archive/g02.md) roll-ups under `archive/`

## Rules

- The active generation README owns the roadmap; `gNN.NNN` files are the sole
  executable Northstar tasks.
- Tasks execute only when marked ready in the approved frontier.
- Completed tasks retain compact outcome and evidence until generation roll-up.
- Passive observations live in the active generation's bounded watchlist and do
  not keep old generations open.
- Stop when a planning, dependency, authority, or evidence gap changes the plan.

## Next task

Execute `g03.003`. The bounded watchlist is not execution authority.
