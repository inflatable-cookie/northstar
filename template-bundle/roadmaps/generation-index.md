# Roadmap Generation Index

**Type: REQUIRED** -- Track active generation and rollover history.

Status: active
Updated: 2026-03-05

## Mode

- `sequential` (default)

## Active generation

- `g01`
- Generation runway: `g01/README.md`

## Generation log

| Generation | Started | Reason | Notes |
| --- | --- | --- | --- |
| `g01` | YYYY-MM-DD | Initial roadmap sequence | Baseline generation after planning gates and first contract chain were established |

## Rollover policy

Create a new generation when:
- manually triggered by maintainers based on sequencing needs.
- typically after a major vision/architecture or contract shift, or when
  roadmap scale warrants a new boundary.

Generations are expected to be long-lived. Do not open `g02` just because one
or two tasks landed; prefer rollover only when the sequencing baseline
itself needs a reset.

As a healthy default, expect roughly 20 to 50 tasks in one generation
before rollover is even worth considering. Treat that as a judgment guardrail,
not an automatic counter.

### Task completion does not close the generation

Finishing a task, suite, or lane of roadmaps does **not** mark the generation
as complete. The generation remains open until the rollover conditions above are
met. After closing one task, compile or continue the next task inside the same
generation. Do not treat the end of a planned sequence as a generation closeout
event. In a lifecycle-adopted repository, an exhausted runway projects as
`planning_required` — the open generation asking for its next planning
decision — and closure happens only when a rollover commits the explicit
closure record at `.northstar/lifecycle/v1/generations/gNN.closure.json`.

Before opening the next generation in sequential mode:
- close, supersede, or rehome every task in the current generation.
- refresh the roadmap front doors so the old generation is visibly closed.
- purge stale specs from `docs/specs/` so the active specs tree no longer
  carries debris from the closing generation. Tasks stay with their
  generation and do not need separate archiving.

If that cleanup has not happened, stay in the current generation and finish the
closeout there first.

### Closed generations still expanded

If this index already marks a generation closed but `gNN/` is still expanded,
that is maintenance drift, not a reason to open `gNN+1`. Refresh,
normalization, and authorized docs cleanup replace each safely closed
generation with `archive/gNN.md` using the same preservation rules as rollover.

### Parallel mode

Switch to `parallel` mode only when:
- genuinely independent work streams need separate generations without blocking
  each other
- each stream has distinct contracts, tasks, and lane context
- front doors can accurately track all active generations without collision

In parallel mode, each active generation operates as its own queue. Opening a
new generation does not require closing prior generations. Each generation's
`gNN/README.md` and task files remain the authoritative front door for
that thread.

## Runway rule

Each active generation's `gNN/README.md` owns its `## Generation Runway`: a
short, coarse goal list for the generation. Use it to choose the next task
when a lane closes instead of inventing a new direction from recent context.
Keep the runway stable between real strategy, task, or rollover changes.
It should be written for a significant generation, not a four-or-five-roadmap
sequence.

## Next task

When opening `g02`, add a generation log row and record the manual rollover
trigger that justified a real sequencing reset.
