# Roadmap Generation Index

Status: active
Updated: 2026-03-05

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

Before opening the next generation:
- close, supersede, or rehome every milestone in the current generation.
- refresh the roadmap front doors so the old generation is visibly closed.
- purge stale specs and batch cards from `docs/specs/` so the active specs tree
  no longer carries debris from the closing generation.

If that cleanup has not happened, stay in the current generation and finish the
closeout there first.

## Next task

When opening `g02`, add a generation log row and record the manual rollover
trigger that justified a real sequencing reset.
