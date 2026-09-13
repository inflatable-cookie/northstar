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
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v1 digest=sha256:7a403d04c442c6d5f2b982e60644fd318f2ff7cb6241afbbbb6ff7f9bac44e9b -->
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
| g03.007 | complete | none | 8 | sha256:a5b8006f700e791ff4bb68f504746a9f2431bb1711abd70292673e536a80b9ad |
| g03.008 | complete | none | 8 | sha256:888d75786d747f9965efa51b4b492c005aaf967a8f6504715e3b6be0f2760099 |
<!-- northstar:lifecycle:end -->
