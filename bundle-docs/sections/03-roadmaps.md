# 03 Roadmaps

Status: active
Updated: 2026-06-05

## Why this section matters now

Roadmaps convert strategy into executable short-term task blocks.
Generation segmentation keeps long-running programs manageable.

## Scope

Define task files, dependency-linked sequencing, acceptance criteria, and
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
one or two task files. In a long-running repo, a healthy generation will
often cover tens of roadmap files before rollover becomes useful. By default,
expect roughly 20 to 50 task files inside one generation before rollover is
even worth considering. Treat that as a judgment guardrail, not an
automatic file-count trigger.

Typical manual triggers:
- a major vision, architecture, or contract shift requires a fresh sequencing
  baseline
- the current generation has been fully closed out and a fresh boundary is now
  genuinely clearer for execution
- the existing generation would become misleading if new work kept landing
  under its old sequencing assumptions

Do not roll a generation just because one task closed quickly or because a
single external proof lane completed. Finishing a task, suite, or lane of
roadmaps does **not** mark the generation as complete. After closing one task,
compile or continue the next task inside the same generation. The generation
stays open until the rollover conditions above are met.

Generation rollover is a closeout event, not a convenience move. Before opening
`gNN+1` in sequential mode, all of the following must be true:

- every task in `gNN/` is explicitly closed, superseded, or moved to
  backlog so no roadmap file in the old generation still presents as active
- the roadmap front doors and generation README agree that `gNN` is fully
  closed and ready for rollover
- `docs/specs/` has been purged of stale specs from the closing generation so
  the active specs tree no longer carries obsolete planning debris.

If those conditions are not met, stay in the current generation and repair the
lane state there first.

Record rollover reason in `docs/roadmaps/generation-index.md`.

## Closed-generation compaction without another rollover

Refresh, normalization, and authorized docs cleanup must inspect already-closed
sequential generations. They do not wait for a new rollover to replace a
safely closed expanded generation with `docs/roadmaps/archive/gNN.md`.

Inventory each expanded `gNN/` tree and classify it as active, safely closed,
or unresolved from content and references. A completed task does not close
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

Use it to steer the next task when a lane closes. Write it with the
express intent of keeping a significant generation moving for a long time. It
does not need to plan all 20 to 50 likely tasks in one pass, but it should
make the next several durable goal areas visible so agents do not treat four or
five completed tasks as a rollover signal.

The generation runway sits above individual tasks:

- vision explains why the generation matters
- architecture and contracts define the allowed shape
- the generation runway names the main goals still governing this generation
- tasks turn those goals into executable slices with their own steps,
  acceptance, and closeout
- `Next Task` remains the live continuation pointer in roadmap front doors

The runway is not a backlog, not a checkbox task list, and not a second current
queue. Keep it stable between real strategy, task, or rollover changes.
If an agent is rewriting the runway every turn, it is using the surface wrong.
If an agent wants to roll the generation after only a handful of tasks,
the runway should bias toward compiling the next task inside the current
generation unless a real sequencing reset is already documented.

Recommended shape:

| Goal | State | Governing refs | Next task |
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
  tasks

Use parallel mode only when the work streams are truly independent. Do not use
it to bypass closeout discipline for related work that should share a queue.

## Content contract (per task file)

1. `Status`, `Owner`, `Created`, `Depends on`, `Governing refs`,
   `Dispatch manifest`
2. `## Outcome`
3. `## Decisions` (when the task settles provisional design)
4. `## Work` (ordered steps with checkboxes)
5. `## Acceptance and review oracle`
6. `## Stop conditions`
7. `## Evidence` (on completion: PR, head, merge, validation, limits)
8. `## Next task`

## Scope and granularity rule

Tasks are **turnkey execution definitions**, not thread-scoped planning
notes. A task should survive closeout and handoff without the originating
agent chat.

### Task owns the work

- A task names the outcome, governing refs, ordered work steps, acceptance
  oracle, and stop conditions for one reviewable slice of work.
- `## Work` groups work into ordered steps. Each step is concrete enough to
  tick off during closeout, but the task stays one coherent outcome — not
  one agent turn and not a vague multi-month bucket.
- Size a task by coherent ownership and a reviewable outcome. Model a
  long-running outcome as a dependency-linked sequence of meaningful tasks
  in one generation, with the generation runway showing the dependency order
  and the next planning checkpoint.

### Checkbox format

Write `## Work` and acceptance rows as actionable checkbox lines
(`- [ ]` / `- [x]`). That keeps task progress scannable at a glance.

### Anti-patterns

- Creating a new task file each agent turn instead of updating the active task.
- A task whose entire work section is one vague bucket with no ordered steps.
- Micro-tasks sized to a single trivial edit.
- Prose-only bullet lists where checkbox progress would be clearer.

See also the runway rule in
[07-delivery-framework-and-autonomy.md](./07-delivery-framework-and-autonomy.md).

## Task rule

- Plan and execute in meaningful tasks (not micro-tasks).
- Evidence must be recorded on the completed task, not per individual step.
- If a task uncovers a missing contract or unplanned repo behavior, stop and
  close the planning gap before continuing execution.
- Do not run task execution directly from a raw spec once the spec's durable
  outcomes should have been promoted into architecture/contracts.
- For a material lane, do not leave the generation at one immediate task plus
  guesswork. Show the runway goal, the next few meaningful tasks or
  transitions, and the next planning checkpoint.

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
- Refresh those surfaces whenever the active task or generation changes so
  operators do not have to reconstruct the live lane from stale front doors.

## Currentness curation rule

- In sequential mode, `docs/roadmaps/README.md`,
  `docs/roadmaps/generation-index.md`, and the active
  `docs/roadmaps/gNN/README.md` should each name one active generation and one
  active task, not a cluster of competing "current" lanes.
- Keep the live `## Next Task` pointer only in those roadmap front doors.
  Non-roadmap docs may describe active state, but should not each own the
  current thread pointer.
- In parallel mode, front doors must name all active generations and their
  active tasks. Each generation's `gNN/README.md` remains the
  authoritative front door for that thread.
- `docs/README.md` may surface one active spec alongside the active roadmap,
  but only when that spec still materially governs the next planning or
  execution decisions for the current lane.
- Do not keep a completed or no-longer-governing spec on the main front door
  just because it is recent; prefer no spec link over a misleading one.

## Lean governance rule

Default posture is manual-first evidence, not checker-script proliferation.

Only add a new script/checker when all are true:
- the same check has repeated in at least 3 tasks, or across at least 2 projects
- pass/fail is deterministic and not primarily judgement-based
- an owner and expected run cadence are explicitly assigned
- a removal/sunset trigger is recorded

If these conditions are not met, keep validation in task logs as human-run checks.

## Quick reference

- [Glossary: Generation, task, lane](../glossary.md#execution-and-workflow)
- [Glossary: Currentness, backlog](../glossary.md#execution-and-workflow)
- [Cheat sheet: Reference keys](../cheat-sheet.md#reference-keys)

## Next task

Keep roadmap doctrine, templates, and currentness surfaces aligned around the
active lane so rollover and task changes do not leave stale front doors
behind.
