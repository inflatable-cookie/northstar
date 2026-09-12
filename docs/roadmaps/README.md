# Roadmaps

Roadmaps sequence approved Northstar work. Only the active sequential
generation remains expanded.

## Current state

- Active generation: [`g03`](./g03/README.md)
- Last completed task: `g03.005` portable lifecycle core
- Active task: none; `g03.006` is planned and blocked on Queue generic hooks
- Approved frontier: none; Queue planning owns the prerequisite
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

Relay the frozen generic hook boundary to Queue planning. Revisit `g03.006`
only after the Queue prerequisite lands. The bounded watchlist is not execution
authority.
