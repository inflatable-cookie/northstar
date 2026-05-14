# Roadmap Generation Index

Status: active
Updated: 2026-05-08

## Mode

- `sequential` (default)

## Active generation

- `g02`

## Generation log

| Generation | Started | Reason | Notes |
| --- | --- | --- | --- |
| `g01` | 2026-04-08 | Initial live Northstar-on-Northstar sequence | Establish the repo's own docs spine and pilot the delivery layer before promoting it into the reusable bundle and skills |
| `g02` | 2026-04-09 | Move from internal proof to external consumer-repo validation | Long-running external-proof and execution-hardening generation. Started with the first real consumer-repo pilot, then continues through operator simplification, stronger execution guardrails, and longer-autonomy improvement lanes |

## Rollover policy

Create a new generation when:

- the sequencing baseline itself materially changes
- the current generation has been fully closed out and a fresh boundary is now
  genuinely clearer for execution
- maintainers explicitly decide the queue needs a clean reset

Northstar generations should usually be substantial. The default expectation is
that one generation will cover many milestone files before rollover. As a
judgment guardrail, expect something closer to 20 to 40 milestones before
rollover is worth considering. Do not open `g03` just because `g02.001` closed
or because one pilot lane completed.

### Batch completion does not close the generation

Finishing a batch, suite, or lane of roadmaps does **not** mark the generation
as complete. The generation remains open until the rollover conditions above are
met. After closing one batch, compile or continue the next batch inside the same
generation. Do not treat the end of a planned sequence as a generation closeout
event.

Before opening the next generation in sequential mode:

- close, supersede, or rehome every milestone in the current generation
- refresh the roadmap front doors so the old generation is visibly closed
- purge stale specs from `docs/specs/` so the active specs tree
  no longer carries debris from the closing generation

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

## Next Task

Use `g02.019` to formalize repo-posture classification now that the setup
package has stronger concrete adoption examples.
