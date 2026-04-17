# Roadmap Generation Index

Status: active
Updated: 2026-04-10

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
- the current generation has been fully closed out and becomes misleading for
  new work after contract/spec rewrites
- maintainers explicitly decide the queue needs a clean reset

Northstar generations should usually be substantial. The default expectation is
that one generation will cover many milestone files before rollover. As a
judgment guardrail, expect something closer to 20 to 40 milestones before
rollover is worth considering. Do not open `g03` just because `g02.001` closed
or because one pilot lane completed.

Before opening the next generation:

- close, supersede, or rehome every milestone in the current generation
- refresh the roadmap front doors so the old generation is visibly closed
- purge stale specs and batch cards from `docs/specs/` so the active specs tree
  no longer carries debris from the closing generation

If that cleanup has not happened, stay in the current generation and finish the
closeout there first.

## Next Task

Use `g02.019` to formalize repo-posture classification now that the setup
package has stronger concrete adoption examples.
