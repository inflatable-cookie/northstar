# Roadmap Generation Index

**Type: REQUIRED** -- Track active generation and rollover history.

Status: active
Updated: 2026-03-05

## Mode

- `sequential` (default)

## Active generation

- `g01`

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
or two milestones landed; prefer rollover only when the sequencing baseline
itself needs a reset.

As a healthy default, expect roughly 20 to 40 milestones in one generation
before rollover is even worth considering. Treat that as a judgment guardrail,
not an automatic counter.

### Batch completion does not close the generation

Finishing a batch, suite, or lane of roadmaps does **not** mark the generation
as complete. The generation remains open until the rollover conditions above are
met. After closing one batch, compile or continue the next batch inside the same
generation. Do not treat the end of a planned sequence as a generation closeout
event.

Before opening the next generation in sequential mode:
- close, supersede, or rehome every milestone in the current generation.
- refresh the roadmap front doors so the old generation is visibly closed.
- purge stale specs from `docs/specs/` so the active specs tree no longer
  carries debris from the closing generation. Batch cards stay with their
  generation under `docs/roadmaps/gNN/batch-cards/` and do not need separate
  archiving.

If that cleanup has not happened, stay in the current generation and finish the
closeout there first.

### Parallel mode

Switch to `parallel` mode only when:
- genuinely independent work streams need separate generations without blocking
  each other
- each stream has distinct contracts, milestones, and lane context
- front doors can accurately track all active generations without collision

In parallel mode, each active generation operates as its own queue. Opening a
new generation does not require closing prior generations. Each generation's
`gNN/README.md` and milestone files remain the authoritative front door for
that thread.

## Next task

When opening `g02`, add a generation log row and record the manual rollover
trigger that justified a real sequencing reset.
