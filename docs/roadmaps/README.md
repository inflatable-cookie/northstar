# Roadmaps

Roadmaps sequence approved Northstar work. Only the active sequential
generation remains expanded.

## Current state

- Active generation: [`g03`](./g03/README.md)
- Active milestone: [`g03.001`](./g03/001-compact-default-lifecycle.md)
- Active frontier: [`g03.001/131`](./g03/batch-cards/131-compact-g02-and-currentness.md) and [`g03.001/132`](./g03/batch-cards/132-make-compact-lifecycle-default.md) executing concurrently (card 130 merged)
- Closed generations: [`g01`](./archive/g01.md) and [`g02`](./archive/g02.md) roll-ups under `archive/`

## Rules

- Roadmaps sequence work already settled by architecture, contracts, and any
  required material spec.
- Batch cards are executable only in the active generation and only when marked
  ready in its approved frontier.
- Completed cards retain compact outcome and evidence until generation roll-up.
- Passive observations live in the active generation's bounded watchlist and do
  not keep old generations open.
- Stop when a planning, dependency, authority, or evidence gap changes the plan.

## Next task

Complete concurrent siblings `g03.001/131` and `g03.001/132`. Do not dispatch historical `g01` or `g02` instructions.
