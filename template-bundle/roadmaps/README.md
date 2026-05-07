# Roadmaps

**Type: REQUIRED** -- Every Northstar project needs this folder.

Roadmaps are executable milestone plans derived from vision, architecture, and
contracts.
They compile contract-approved work into execution batches after durable
planning outcomes have been promoted out of specs.

## Generation model

- Use generation folders: `g01`, `g02`, `g03`.
- Use milestone files inside each generation: `001-<slug>.md`.
- Reference milestones as `gNN.NNN` (example: `g01.001`).
- Trigger generation rollover manually; do not use automatic file-count limits.
- Treat generations as substantial sequencing eras, not one-or-two-file buckets.
  In long-running repos, one generation will often hold many milestones before
  a clean rollover is warranted. A healthy default is roughly 20 to 40
  milestone files before rollover is even worth discussing.
- When refocus invalidates the sequencing baseline across multiple milestones,
  prefer a clean new generation over patching stale work in place.
- Treat rollover as full generation closeout, not a convenience reset:
  close or rehome every milestone in the current generation first, then purge
  stale specs and batch cards from `docs/specs/` before opening the next
  generation.

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
- Do not execute long-running implementation directly from a raw spec once its
  durable outcomes should have been promoted into architecture/contracts.

## Lean governance rule

- Keep one active queue and use backlog for deferred scope.
- Run currentness triage only when queue clarity degrades.
- Prefer manual evidence over new checker scripts unless repetition clearly justifies automation.
- Do not use roadmap prose to guess what an unplanned system surface probably
  does; repair the planning surface first.

## Currentness surfaces

Treat these as the normal roadmap front doors:

- `docs/roadmaps/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/gNN/README.md` for the active generation

Keep them aligned to the active generation and milestone so operators can reach
the live lane quickly without reconstructing it from stale prose.

## Currentness curation

- Name one active generation and one active milestone across the roadmap front
  doors.
- If `docs/README.md` also surfaces an active spec, keep that to one spec and
  only when it still governs the next planning or execution decisions.
- Prefer omitting the spec link over surfacing a stale or already-superseded
  planning artifact.

## Next task

Create the first milestone in `g01/` only after the relevant contracts exist,
and keep the same generation active until a real sequencing reset makes a new
boundary worthwhile.
