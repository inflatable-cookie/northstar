# Roadmaps

Roadmaps sequence contract-backed work for Northstar itself.

## Generation model

- Use generation folders: `g01`, `g02`, `g03`
- Use milestone files inside each generation: `001-<slug>.md`
- Reference milestones as `gNN.NNN`

## Rules

- Roadmaps sequence work already backed by contracts and, for material goals,
  by promoted master-spec outcomes.
- In strict posture, batch cards live under
  `docs/roadmaps/gNN/batch-cards/`.
- Execute milestones in meaningful batches and log completed batches.
- Stop execution when a planning gap or contract gap appears.

## Current lane

- `g02` is the active generation
- `g02/README.md` owns the active generation runway
- `g02.020` and `g02.021` are complete
- `g02.022` is complete
- `g02.023` is complete
- `g02.024` is complete
- `g02.025` is active; batches 25.1, 25.2, and 25.4 are complete. Dogfood card
`g02.025/072` is ready.

The preceding `g02.024` milestone was compiled from the consumer papercuts
evidence; that evidence remains the provenance for the current active lane.

## Next Task

Complete `g02.025/073` first: repair the parity-checker runtime path and refresh
the installed skill. Then dogfood `g02.025/072` with one fresh worker thread,
one dedicated worktree, and one reviewable PR.
