# Roadmaps

Roadmaps sequence approved Northstar work. Only the active sequential
generation remains expanded.

## Current state

- Active generation: [`g03`](./g03/README.md)
- Closed generations: [`g01`](./archive/g01.md) and [`g02`](./archive/g02.md) roll-ups under `archive/`
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

An open lane runs until the closeout hook publishes its terminal record into
the generated block below; no successor is automatic. After a lane closes,
return to Chatterbox for direction. The bounded watchlist is not execution
authority.
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v1 digest=sha256:b61aa082aa7612cc3d8848350f8e5de1ab59472b2c4f7b4c6cba74ae9d93228a -->
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
<!-- northstar:lifecycle:end -->
