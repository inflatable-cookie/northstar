# 03 Roadmaps

Status: active
Updated: 2026-06-05

## Why this section matters now

Roadmaps convert strategy into executable short-term milestone blocks.
Generation segmentation keeps long-running programs manageable.

## Scope

Define milestone files, batch-oriented execution lists, acceptance criteria, and
sequencing rules.
Roadmaps must derive from vision, architecture, and contracts, plus research
translation memos when comparative work materially shaped the bet, unless a
documented exception exists.
Roadmaps must not invent behavior for unplanned repos or boundaries.

## Key format decision

Use generation key format `gNN` (for example `g01`, `g02`) in folders and references.

Rationale:
- concise references (`g01.105`)
- stable lexical sorting with zero padding
- clearer than `gen1` while staying explicit

## Template layout

- `docs/roadmaps/README.md`
- `docs/roadmaps/g01/001-<slug>.md`
- `docs/roadmaps/g01/00n-<slug>.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/backlog/README.md`
- `docs/roadmaps/backlog/backlog-item-template.md`
- `docs/logs/templates/roadmap-currentness-triage-template.md` (optional)

## Default vs optional

- `roadmaps/` and `roadmaps/backlog/` are default core sections.
- `docs/roadmaps/templates/` is core for roadmap authoring.
- Top-level `docs/templates/` remains optional and should not be seeded by default.

## Naming and ordering

- File pattern: `docs/roadmaps/gNN/NNN-<slug>.md`
- Numeric prefix increments per generation and resets on generation rollover.
- Cross-file references use `gNN.NNN`.

## Generation rollover rule

Start a new generation (`g02`) only when manually triggered.

Generations are meant to be substantial sequencing eras, not tiny buckets of
one or two milestone files. In a long-running repo, a healthy generation will
often cover tens of roadmap files before rollover becomes useful. By default,
expect roughly 20 to 50 milestone files inside one generation before rollover is
even worth considering. Treat that as a judgment guardrail, not an
automatic file-count trigger.

Typical manual triggers:
- a major vision, architecture, or contract shift requires a fresh sequencing
  baseline
- the current generation has been fully closed out and a fresh boundary is now
  genuinely clearer for execution
- the existing generation would become misleading if new work kept landing
  under its old sequencing assumptions

Do not roll a generation just because one milestone closed quickly or because a
single external proof lane completed. Finishing a batch, suite, or lane of
roadmaps does **not** mark the generation as complete. After closing one batch,
compile or continue the next batch inside the same generation. The generation
stays open until the rollover conditions above are met.

Generation rollover is a closeout event, not a convenience move. Before opening
`gNN+1` in sequential mode, all of the following must be true:

- every milestone in `gNN/` is explicitly closed, superseded, or moved to
  backlog so no roadmap file in the old generation still presents as active
- the roadmap front doors and generation README agree that `gNN` is fully
  closed and ready for rollover
- `docs/specs/` has been purged of stale specs from the closing generation so
  the active specs tree no longer carries obsolete planning debris. Batch cards
  stay with their generation under `docs/roadmaps/gNN/batch-cards/` and do not
  need separate archiving.

If those conditions are not met, stay in the current generation and repair the
lane state there first.

Record rollover reason in `docs/roadmaps/generation-index.md`.

## Closed-generation compaction without another rollover

Refresh, normalization, and authorized docs cleanup must inspect already-closed
sequential generations. They do not wait for a new rollover to replace a
safely closed expanded generation with `docs/roadmaps/archive/gNN.md`.

Inventory each expanded `gNN/` tree and classify it as active, safely closed,
or unresolved from content and references. A completed milestone does not close
a generation. Apply the preservation oracle before deletion: promote unique
authority, rehome open commitments, retain selected evidence, rewrite current
links, then remove only the classified sources. Leave ambiguous generations
intact. Explicit parallel active generations require inspection; do not close
them by counting folders.

Installed maintenance follows
[`skills/northstar/references/lifecycle-maintenance.md`](../../skills/northstar/references/lifecycle-maintenance.md).
Authorized repair includes this compaction; it does not require a second
blanket confirmation. Read-only cleanup reports the proposal only.

## Generation runway rule

Each active generation's `docs/roadmaps/gNN/README.md` should carry a
`## Generation Runway`: a short, coarse goal list for the generation.

Use it to steer the next milestone when a lane closes. Write it with the
express intent of keeping a significant generation moving for a long time. It
does not need to plan all 20 to 50 likely milestones in one pass, but it should
make the next several durable goal areas visible so agents do not treat four or
five completed roadmaps as a rollover signal.

The generation runway sits above individual milestones and batch cards:

- vision explains why the generation matters
- architecture and contracts define the allowed shape
- the generation runway names the main goals still governing this generation
- milestones turn those goals into executable slices
- batch cards carry step detail when batch cards are used
- `Next Task` remains the live continuation pointer in roadmap front doors

The runway is not a backlog, not a checkbox task list, and not a second current
queue. Keep it stable between real strategy, milestone, or rollover changes.
If an agent is rewriting the runway every turn, it is using the surface wrong.
If an agent wants to roll the generation after only a handful of milestones,
the runway should bias toward compiling the next milestone inside the current
generation unless a real sequencing reset is already documented.

Recommended shape:

| Goal | State | Governing refs | Next milestone |
| --- | --- | --- | --- |
| Establish the first contract-backed execution lane. | active | `<contract refs>` | `g01.001` |

Use a small state vocabulary such as `active`, `next`, `blocked`, `deferred`,
and `done`. Keep the list short enough to scan; three to seven goals is usually
enough.

### Parallel mode exception

Switch to parallel mode when genuinely independent work streams need separate
active generations without blocking each other. In parallel mode:

- each generation operates as its own queue with distinct lane context
- opening a new generation does not require closing prior active generations
- each generation's `gNN/README.md` remains the authoritative front door for
  that thread
- front doors must accurately name all active generations and their active
  milestones

Use parallel mode only when the work streams are truly independent. Do not use
it to bypass closeout discipline for related work that should share a queue.

## Content contract (per roadmap file)

1. `Status`, `Owner`, `Created`, `Depends on`, `Vision tags`, `Contract refs`,
   `Planning state`
2. `## Problem`
3. `## Goals`
4. `## Non-Goals`
5. `## Contract Coverage`
6. `## Execution Plan` (batch-based executable task lists with checkboxes)
7. `## Acceptance Criteria`
8. `## Risks and Mitigations`
9. `## Planning Gaps`
10. `## Evidence Requirements`
11. `## Next Task`

## Scope and granularity rule

Roadmaps are **turnkey milestone definitions**, not thread-scoped planning
notes. A roadmap should survive closeout and handoff without the originating
agent chat.

### Roadmap owns the lane shape

- A roadmap milestone names the problem, goals, acceptance, and **batch
  sequence** for a material slice of work.
- `## Execution Plan` groups work into named batches (`### Batch n.m`). Each
  batch is a meaningful execution chunk, not a single agent turn.
- When batch cards are used, most batches map to one or more **batch cards**
  under `docs/roadmaps/gNN/batch-cards/`. The roadmap defines the sequence;
  batch cards define the step-by-step instructions for the current batch.

### Batch cards own the steps

- Do not put batch-card-level steps only in roadmap prose and then recreate the
  roadmap on the next thread.
- Do not use a roadmap as a one-card scratchpad. When batch cards are used,
  promote the immediate work into a batch card and keep the roadmap at milestone
  granularity.

### Minimum runway inside a milestone

For a non-trivial lane:

- `## Execution Plan` should name **at least two or three batches** before
  execution starts, or name the immediate batch plus explicit runway notes that
  list the next few batches or milestone transitions.
- When batch cards are used, a freshly compiled material milestone should
  normally anticipate **several batch cards** across the visible runway (a
  useful default is three or more), not a single card with implied follow-on
  work.
- One batch in the execution plan may span multiple batch cards when the scope
  is still one meaningful chunk.

### Checkbox format

Write `## Execution Plan`, `## Goals`, and `## Acceptance Criteria` as
actionable checkbox lines (`- [ ]` / `- [x]`). That keeps milestone progress
scannable at a glance. Batch-level tasks inside `## Execution Plan` should be
concrete enough to tick off during closeout.

### Anti-patterns

- Creating a new roadmap file each agent turn instead of updating the active
  milestone and batch cards.
- A roadmap whose entire execution plan is one batch that duplicates a single
  batch card.
- Micro-batches sized to a single trivial task.
- Prose-only bullet lists where checkbox progress would be clearer.

See also the runway rule in
[07-delivery-framework-and-autonomy.md](./07-delivery-framework-and-autonomy.md).

## Batch rule

- Plan and execute in meaningful batches (not micro-tasks).
- Logs must be created per completed batch/update cycle, not per individual task.
- If a batch uncovers a missing contract or unplanned repo behavior, stop and
  close the planning gap before continuing execution.
- Do not run roadmap execution directly from a raw spec once the spec's durable
  outcomes should have been promoted into architecture/contracts.
- For a material lane, do not leave the roadmap at one immediate card plus
  guesswork. Show the higher-level owner, the next few meaningful batches or
  milestone transitions, and the next planning checkpoint.

## Currentness rule

- Keep one clearly identified active queue per generation.
- In sequential mode, maintain exactly one active generation.
- In parallel mode, each active generation is its own queue.
- Move deferred items into backlog with promotion criteria.
- Use lightweight currentness triage logs only when queue clarity degrades.
- Keep the roadmap currentness surfaces aligned to the active lane:
- `docs/roadmaps/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/gNN/README.md` for each active generation
- `docs/roadmaps/gNN/batch-cards/` when batch cards are in use
- Refresh those surfaces whenever the active milestone or generation changes so
  operators do not have to reconstruct the live lane from stale front doors.

## Currentness curation rule

- In sequential mode, `docs/roadmaps/README.md`,
  `docs/roadmaps/generation-index.md`, and the active
  `docs/roadmaps/gNN/README.md` should each name one active generation and one
  active milestone, not a cluster of competing "current" lanes.
- Keep the live `## Next Task` pointer only in those roadmap front doors.
  Non-roadmap docs may describe active state, but should not each own the
  current thread pointer.
- In parallel mode, front doors must name all active generations and their
  active milestones. Each generation's `gNN/README.md` remains the
  authoritative front door for that thread.
- `docs/README.md` may surface one active spec alongside the active roadmap,
  but only when that spec still materially governs the next planning or
  execution decisions for the current lane.
- Do not keep a completed or no-longer-governing spec on the main front door
  just because it is recent; prefer no spec link over a misleading one.

## Lean governance rule

Default posture is manual-first evidence, not checker-script proliferation.

Only add a new script/checker when all are true:
- the same check has repeated in at least 3 batches, or across at least 2 projects
- pass/fail is deterministic and not primarily judgement-based
- an owner and expected run cadence are explicitly assigned
- a removal/sunset trigger is recorded

If these conditions are not met, keep validation in batch logs as human-run checks.

## Quick reference

- [Glossary: Generation, milestone, lane](../glossary.md#execution-and-workflow)
- [Glossary: Currentness, backlog](../glossary.md#execution-and-workflow)
- [Cheat sheet: Reference keys](../cheat-sheet.md#reference-keys)

## Next task

Keep roadmap doctrine, templates, and currentness surfaces aligned around the
active lane so rollover and milestone changes do not leave stale front doors
behind.
