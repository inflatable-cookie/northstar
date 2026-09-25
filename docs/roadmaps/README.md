# Roadmaps

Roadmaps sequence approved Northstar work. Only the active sequential
generation remains expanded.

## Current state

- Active generation: [`g04`](./g04/README.md)
- Closed generations: [`g01`](./archive/g01.md), [`g02`](./archive/g02.md) and [`g03`](./archive/g03.md) roll-ups under `archive/`
- Mechanical task state and delivery evidence are projected in the generated
  lifecycle block below, refreshed by the closeout hook at publication; the
  prose here is semantic and is not hand-updated at closeout. An open lane's
  dispatch authorization is its committed handoff and dispatch manifest.

## Rules

- The active generation README owns the roadmap; `gNN.NNN` files are the sole
  executable Northstar tasks.
- Tasks execute only from an approved dispatch: a committed handoff plus the
  task's own dispatch manifest. Mechanical readiness is the projected record
  state, not a prose claim.
- Completed tasks retain compact outcome and evidence until generation roll-up.
- Passive observations live in the active generation's bounded watchlist and do
  not keep old generations open.
- Stop when a planning, dependency, authority, or evidence gap changes the plan.

## Next task

No lane is dispatched. `g04` opened on 2026-09-25; spec 042 is approved;
the next move is agreeing Queue's changes with the Queue Chatterbox. Consumer repository maintenance stays a separate
per-project Queue task, not a Northstar lane.
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v2 digest=sha256:7b5d17b0bceb075bdacb18273d08eb1ce6c375375e4838c5adebf975b3b24495 -->
| Generation | Disposition | Runway state |
| --- | --- | --- |
| g04 | open | planning_required |
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
<!-- northstar:lifecycle:end -->
