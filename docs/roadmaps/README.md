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
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v2 digest=sha256:7462ffd84a47570b2387ade319b3bb05ae7df9cb3e5825a297d7c8597caeda74 -->
| Generation | Disposition | Runway state |
| --- | --- | --- |
| g03 | open | planning_required |
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
| g03.007 | complete | none | 8 | sha256:a5b8006f700e791ff4bb68f504746a9f2431bb1711abd70292673e536a80b9ad |
| g03.008 | complete | none | 8 | sha256:888d75786d747f9965efa51b4b492c005aaf967a8f6504715e3b6be0f2760099 |
| g03.009 | complete | none | 8 | sha256:c8a09f2d3daad05e3b90235bc50f256c3932eeddaee668adecd9dad1183ac8e2 |
| g03.010 | complete | none | 8 | sha256:109f4252bc5259b1cc87938aed24095f99dcf687d9236c93b32d1bd5e7ce537d |
| g03.011 | complete | none | 8 | sha256:b006beb373606185905bfa5b56fd4a1f87dc3accb80141a82be312efdd5206dc |
| g03.012 | complete | none | 8 | sha256:2ea341f845521a3162fc405e6528fb40d08b4e30b555b3de3af819f3c8bfc649 |
| g03.013 | complete | none | 8 | sha256:b04543c372ffeb75b3fd0813e7f541f216d22f3c6bd3cb03dcd5e175ea225374 |
| g03.014 | complete | none | 8 | sha256:625cb1913c3e02eedff7bfde13b7739bab45ac45d5017c550df775b210ab95dd |
| g03.015 | complete | none | 8 | sha256:c1035ad4e0adc5dec9a9723c622acadf1e2ab689883f1711e4f2c435ac519df8 |
| g03.016 | complete | none | 8 | sha256:a841a07bb97a64cf4d2bc3f5d3fb4f76c990d07c46d47fded5db68aa6c9c16be |
<!-- northstar:lifecycle:end -->
