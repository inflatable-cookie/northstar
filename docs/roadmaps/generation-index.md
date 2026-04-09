# Roadmap Generation Index

Status: active
Updated: 2026-04-09

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
- the current generation becomes misleading after contract/spec rewrites
- maintainers explicitly decide the queue needs a clean reset

Northstar generations should usually be substantial. The default expectation is
that one generation will cover many milestone files before rollover. Do not
open `g03` just because `g02.001` closed or because one pilot lane completed.

## Next Task

Open a Signal-owned migration lane that installs the first strict tranche
around the active `g09` queue while `g02` remains the active long-running
generation.
