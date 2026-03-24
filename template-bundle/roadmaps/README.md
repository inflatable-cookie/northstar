# Roadmaps

Roadmaps are executable milestone plans derived from vision and architecture.
They compile contract-approved work into execution batches.

## Generation model

- Use generation folders: `g01`, `g02`, `g03`.
- Use milestone files inside each generation: `001-<slug>.md`.
- Reference milestones as `gNN.NNN` (example: `g01.001`).
- Trigger generation rollover manually; do not use automatic file-count limits.
- When refocus invalidates the sequencing baseline across multiple milestones,
  prefer a clean new generation over patching stale work in place.

## Layout

- `g01/` first generation milestones
- `generation-index.md` active generation and rollover history
- `backlog/` deferred items with promotion criteria
- `templates/roadmap-milestone-template.md` milestone starter contract

## Batch and logging rule

- Execute milestones in meaningful batches.
- Create logs per completed batch/update cycle, not per individual task.
- Stop execution when a batch reveals a missing contract, missing repo
  authority, or other planning gap.

## Lean governance rule

- Keep one active queue and use backlog for deferred scope.
- Run currentness triage only when queue clarity degrades.
- Prefer manual evidence over new checker scripts unless repetition clearly justifies automation.
- Do not use roadmap prose to guess what an unplanned system surface probably
  does; repair the planning surface first.

## Next task

Create the first milestone in `g01/` only after the relevant contracts exist
and define its first executable batch from those contracts.
