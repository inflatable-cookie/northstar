# Generation Index

**Type: REQUIRED**

## Mode

- `sequential` (default)

## Active Generation

- `g01`
- Generation runway: `g01/README.md`

## Rollover History

None yet.

## Parallel Mode

Switch to `parallel` when independent work streams need separate generations
without blocking each other. Each generation operates as its own queue.

## Runway Rule

Each active generation's `gNN/README.md` owns its `## Generation Runway`.
Use it to choose the next milestone when a lane closes. Do not rewrite it as a
per-turn task list. It should be written for a significant 20-to-50-roadmap
generation, not a short sequence of four or five roadmaps.

## Next Task

Record rollover decisions here when a generation closes.
