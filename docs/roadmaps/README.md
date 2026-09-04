# Roadmaps

Roadmaps sequence approved Northstar work. Only the active sequential
generation remains expanded.

## Current state

- Active generation: [`g03`](./g03/README.md)
- Active milestone: [`g03.001`](./g03/001-compact-default-lifecycle.md)
- Ready card: [`g03.001/130`](./g03/batch-cards/130-establish-lifecycle-and-roll-up-g01.md)
- Approved next frontier: cards 131 and 132 concurrently after card 130 merges
- Closed generations: historical until cards 130 and 131 replace them with
  compact roll-ups under `archive/`

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

Dispatch card 130. Do not dispatch historical `g01` or `g02` instructions.
