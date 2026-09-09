# Roadmaps

**Type: REQUIRED** -- Every Northstar project needs this folder.

Roadmaps are executable task plans derived from vision, architecture, and
contracts.
They compile contract-approved work into `gNN.NNN` tasks after durable
planning outcomes have been promoted out of specs.

## Generation model

- Use generation folders: `g01`, `g02`, `g03`.
- Use task files inside each generation: `001-<slug>.md`.
- Reference tasks as `gNN.NNN` (example: `g01.001`).
- Trigger generation rollover manually; do not use automatic file-count limits.
- Treat generations as substantial sequencing eras, not one-or-two-file buckets.
  In long-running repos, one generation will often hold many tasks before
  a clean rollover is warranted. A healthy default is roughly 20 to 50
  task files before rollover is even worth discussing.
- Finishing a task, suite, or lane of roadmaps does **not** close the
  generation. After one task closes, compile or continue the next task inside
  the same generation. The generation stays open until the rollover conditions
  above are met.
- When refocus invalidates the sequencing baseline across multiple tasks,
  prefer a clean new generation over patching stale work in place.
- Treat rollover as full generation closeout, not a convenience reset:
  close or rehome every task in the current generation first, then purge
  stale specs from `docs/specs/` before opening the next generation.
- Refresh, normalization, and authorized docs cleanup compact already-closed
  generations the same way, without opening a new generation. Leave unresolved
  generations expanded and name the blocker.

## Layout

- `g01/` first generation tasks
- `generation-index.md` active generation and rollover history
- `archive/` closed-generation roll-ups (`gNN.md`) after a generation is safely closed
- `backlog/` deferred items with promotion criteria
- `templates/task-template.md` task starter contract

## Generation runway and tasks

The generation README owns the durable runway and approved frontier; each
`gNN.NNN` task file carries implementation and closeout detail.

- **Generation runway** — coarse goal list in `gNN/README.md`. Use it to steer
  the next task when a lane closes, before inventing a new direction from
  recent context. Keep it stable; update it when generation-level intent
  changes, a task materially advances or closes a goal, or rollover is being
  considered.
- **Task** — outcome, governing refs, ordered work steps, acceptance oracle,
  stop conditions, and closeout evidence for one reviewable slice of work.
  Size by coherent ownership and a reviewable outcome, not by one agent turn.
  Model long work as dependency-linked tasks in one generation.

### Minimum runway

For non-trivial work, compile a bounded runway: the runway goal the lane
advances, the next few meaningful tasks beyond the immediate one, and the
next planning checkpoint. Do not leave the generation at one immediate task
plus guesswork.

### Checkbox format

Use actionable checkbox lines (`- [ ]` / `- [x]`) in `## Work` and
acceptance rows so task progress is scannable at a glance.

### Anti-patterns

- A new task file per agent turn instead of updating the active task
- A task that is one vague multi-month bucket with no ordered steps
- Micro-tasks sized to a single trivial edit

Full doctrine: `bundle-docs/sections/03-roadmaps.md` (*Scope and granularity
rule*).

## Task and logging rule

- Execute tasks in a reviewable order.
- Record evidence on the completed task, not per individual step.
- Stop execution when a task reveals a missing contract, missing repo
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
- Do not use task prose to guess what an unplanned system surface probably
  does; repair the planning surface first.

## Currentness surfaces

Treat these as the normal roadmap front doors:

- `docs/roadmaps/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/gNN/README.md` for each active generation

Keep them aligned to the active generation and task so operators can reach
the live lane quickly without reconstructing it from stale prose.
The active `gNN/README.md` owns the generation runway; the other front doors
may point to it but should not duplicate the full table.

## Currentness curation

- In sequential mode, name one active generation and one active task across
  the roadmap front doors.
- In parallel mode, name all active generations and their active tasks.
  Each generation's `gNN/README.md` remains the authoritative front door for its
  thread.
- If `docs/README.md` also surfaces an active spec, keep that to one spec and
  only when it still governs the next planning or execution decisions.
- Prefer omitting the spec link over surfacing a stale or already-superseded
  planning artifact.

## Next task

Create the first task in `g01/` only after the relevant contracts exist,
and keep the same generation active until a real sequencing reset makes a new
boundary worthwhile. New consumers get `roadmaps/g01/001-<slug>.md`; there is
no `batch-cards/` scaffold.
