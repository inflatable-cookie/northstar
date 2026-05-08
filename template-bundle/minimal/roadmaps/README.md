# Roadmaps

**Type: REQUIRED**

Roadmaps are executable milestone plans derived from vision, architecture, and contracts.

## Generation model

- Use generation folders: `g01`, `g02`, `g03`.
- Use milestone files inside each generation: `001-<slug>.md`.
- Reference milestones as `gNN.NNN`.

## Layout

- `g01/` first generation milestones
- `generation-index.md` active generation and rollover history
- `backlog/` deferred items (create when needed)

## Rule

- Execute milestones in meaningful batches.
- Create logs per completed batch, not per individual task.
- Stop execution when a batch reveals a missing contract or planning gap.
- In parallel mode, each generation operates as its own queue.

## Next Task

Create the first milestone in `g01/` only after the relevant contracts exist.
