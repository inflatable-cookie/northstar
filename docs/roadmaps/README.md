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
- `g02.025` is complete; batches 25.1, 25.2, 25.3, and 25.4 are complete.
- `g02.026` is active; card 075 is complete and card 076 remains planned until
  its exact checker command and ready-state evidence are explicit.

The preceding `g02.024` milestone was compiled from the consumer papercuts
evidence; that evidence remains the provenance for the current active lane.

## Next Task

`g02.025` is complete. Execute `g02.026/075` to promote the readiness-map file
contract through the existing worker/PR loop. Keep `g02.026/076` planned until
the contract and exact validation command are merged. The completed dogfood log
is `docs/logs/2026-08/16-181533-dogfood-orchestrator-worker-pr-loop.md`.
