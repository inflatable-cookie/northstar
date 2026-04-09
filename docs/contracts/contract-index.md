# Contract Index

Status: active
Owner: repo maintainers
Updated: 2026-04-10

## Coverage Rules

- Every separate contract used by this repo should be listed here.
- Roadmap milestones should reference their governing artifacts directly.
- If a boundary genuinely needs its own contract and none exists yet, mark the
  roadmap blocked and close the gap before execution continues.

## Contract Register

| Contract | Boundary | Owning surface | Dependent roadmaps | Status |
| --- | --- | --- | --- | --- |
| `001-working-rules` | compact delivery grammar, done-ness, guardrail pack, spec-hygiene rule, currentness-surface rules, autonomy rules, automation runtime policy, and the live ready-state/closeout rules for the repo | `docs/`, `bundle-docs/`, `template-bundle/`, `skills/`, `scripts/` | `g01.001`, `g01.002`, `g01.003`, `g02.001`, `g02.002`, `g02.003`, `g02.004`, `g02.005`, `g02.006`, `g02.007`, `g02.008`, `g02.009`, `g02.010`, `g02.011`, `g02.012`, `g02.013`, `g02.014` | active |

## Missing or Pending Contracts

No active contract gaps are blocking the current `g02` lane.

## Roadmap Readiness

`g01.001`, `g01.002`, `g01.003`, `g02.001`, `g02.002`, `g02.003`, `g02.004`,
`g02.005`, `g02.006`, `g02.007`, `g02.008`, `g02.009`, `g02.010`, `g02.011`,
`g02.012`, `g02.013`, and `g02.014` are complete.
`g02.014` is the current lane for the completed consumer-repo migration proof.
The next move belongs in Signal rather than another Northstar lane, so
`001-working-rules` remains sufficient for the completed proof set.

## Next Task

Use this completed proof set to open a Signal-owned migration lane for the
first strict tranche around `g09`.
