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
  a clean rollover is warranted. A healthy default is roughly 20 to 50
  milestone files before rollover is even worth discussing.
- Finishing a batch, suite, or lane of roadmaps does **not** close the
  generation. After one batch closes, compile or continue the next batch inside
  the same generation. The generation stays open until the rollover conditions
  above are met.
- When refocus invalidates the sequencing baseline across multiple milestones,
  prefer a clean new generation over patching stale work in place.
- Treat rollover as full generation closeout, not a convenience reset:
  close or rehome every milestone in the current generation first, then purge
  stale specs from `docs/specs/` before opening the next generation. Batch cards
  stay with their generation under `docs/roadmaps/gNN/batch-cards/` and do not
  need separate archiving.
- Refresh, normalization, and authorized docs cleanup compact already-closed
  generations the same way, without opening a new generation. Leave unresolved
  generations expanded and name the blocker.

## Layout

- `g01/` first generation milestones
- `g01/batch-cards/` execution cards for the active generation (when batch-card detail is needed)
- `generation-index.md` active generation and rollover history
- `archive/` closed-generation roll-ups (`gNN.md`) after a generation is safely closed
- `backlog/` deferred items with promotion criteria
- `templates/roadmap-milestone-template.md` milestone starter contract

## Roadmap vs batch card

Roadmaps are turnkey milestone plans. Batch cards are the smaller execution
units inside them.

- **Roadmap milestone** — problem, goals, acceptance, and the **batch
  sequence** for a material slice of work. Should span multiple batches and,
  when batch cards are used, multiple batch cards — not one agent turn.
- **Batch card** — bounded step-by-step instructions for the current batch.
  Create or update cards as execution proceeds; do not recreate the roadmap
  each turn.

### Generation runway

Each active generation's `gNN/README.md` owns a `## Generation Runway`: a short,
coarse goal list for the generation. Use it to steer the next milestone when a
lane closes, before inventing a new direction from recent context.

Keep the generation runway stable. Update it when generation-level intent
changes, a milestone materially advances or closes a goal, or rollover is being
considered. Do not use it as a backlog, checkbox list, or per-turn task queue.
It does not need to pre-plan every milestone, but it should be written to keep
a significant 20-to-50-roadmap generation moving for a long time.

### Minimum runway

For non-trivial work, `## Execution Plan` should name at least two or three
batches before execution starts. When batch cards are used, a freshly compiled
material milestone should normally anticipate several batch cards across the
visible runway (three or more is a useful default), not one card plus implied
follow-on work.

### Checkbox format

Use actionable checkbox lines (`- [ ]` / `- [x]`) in `## Execution Plan`,
`## Goals`, and `## Acceptance Criteria` so milestone progress is scannable at
a glance.

### Anti-patterns

- A new roadmap file per agent turn instead of updating the active milestone
- A roadmap that only mirrors one batch card
- Micro-batches sized to a single trivial task

Full doctrine: `bundle-docs/sections/03-roadmaps.md` (*Scope and granularity
rule*).

## Batch and logging rule

- Execute milestones in meaningful batches.
- Create logs per completed batch/update cycle, not per individual task.
- Stop execution when a batch reveals a missing contract, missing repo
  authority, or other planning gap.
- Do not execute long-running implementation directly from a raw spec once its
  durable outcomes should have been promoted into architecture/contracts.

## Lean governance rule

- Keep one active queue per generation and use backlog for deferred scope.
- In sequential mode, maintain exactly one active generation.
- In parallel mode, each active generation is its own queue; keep each queue's
  front doors accurate for that thread.
- Run currentness triage only when queue clarity degrades.
- Prefer manual evidence over new checker scripts unless repetition clearly justifies automation.
- Do not use roadmap prose to guess what an unplanned system surface probably
  does; repair the planning surface first.

## Batch cards

When batch-card execution detail is used, batch cards live inside each generation:

- `docs/roadmaps/gNN/batch-cards/NNN-<slug>.md`
- numbered per-generation so parallel generations never collide
- stay with their generation; no need to archive or purge on rollover

## Currentness surfaces

Treat these as the normal roadmap front doors:

- `docs/roadmaps/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/gNN/README.md` for each active generation

Keep them aligned to the active generation and milestone so operators can reach
the live lane quickly without reconstructing it from stale prose.
The active `gNN/README.md` owns the generation runway; the other front doors
may point to it but should not duplicate the full table.

## Currentness curation

- In sequential mode, name one active generation and one active milestone across
  the roadmap front doors.
- In parallel mode, name all active generations and their active milestones.
  Each generation's `gNN/README.md` remains the authoritative front door for its
  thread.
- If `docs/README.md` also surfaces an active spec, keep that to one spec and
  only when it still governs the next planning or execution decisions.
- Prefer omitting the spec link over surfacing a stale or already-superseded
  planning artifact.

## Next task

Create the first milestone in `g01/` only after the relevant contracts exist,
and keep the same generation active until a real sequencing reset makes a new
boundary worthwhile.
