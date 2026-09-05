# Roadmaps

Roadmaps sequence approved Northstar work. Only the active sequential
generation remains expanded.

## Current state

- Active generation: [`g03`](./g03/README.md)
- Last completed milestone: [`g03.001`](./g03/001-compact-default-lifecycle.md)
- Approved frontier: none
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

Chatterbox and the operator should select the next `g03` simplification tranche.
Do not dispatch historical `g01` or `g02` instructions or invent work from the
bounded watchlist.
