# Roadmaps

Roadmaps are executable milestone plans derived from vision and architecture.

## Generation model

- Use generation folders: `g01`, `g02`, `g03`.
- Use milestone files inside each generation: `001-<slug>.md`.
- Reference milestones as `gNN.NNN` (example: `g01.001`).
- Trigger generation rollover manually; do not use automatic file-count limits.

## Layout

- `g01/` first generation milestones
- `generation-index.md` active generation and rollover history
- `backlog/` deferred items with promotion criteria
- `templates/roadmap-milestone-template.md` milestone starter contract

## Batch and logging rule

- Execute milestones in meaningful batches.
- Create logs per completed batch/update cycle, not per individual task.

## Lean governance rule

- Keep one active queue and use backlog for deferred scope.
- Run currentness triage only when queue clarity degrades.
- Prefer manual evidence over new checker scripts unless repetition clearly justifies automation.

## Next task

Create the first milestone in `g01/` and define its first executable batch.
