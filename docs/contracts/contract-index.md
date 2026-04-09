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
| `001-working-rules` | compact delivery grammar, done-ness, guardrail pack, spec-hygiene rule, currentness-surface rules, autonomy rules, automation runtime policy, and the live ready-state/closeout rules for the repo | `docs/`, `bundle-docs/`, `template-bundle/`, `skills/`, `scripts/` | `g01.001`, `g01.002`, `g01.003`, `g02.001`, `g02.002`, `g02.003`, `g02.004`, `g02.005`, `g02.006`, `g02.007`, `g02.008`, `g02.009`, `g02.010`, `g02.011`, `g02.012`, `g02.013` | active |

## Missing or Pending Contracts

No active contract gaps are blocking the current `g02` lane.

## Roadmap Readiness

`g01.001`, `g01.002`, `g01.003`, `g02.001`, `g02.002`, `g02.003`, `g02.004`,
`g02.005`, `g02.006`, `g02.007`, `g02.008`, `g02.009`, `g02.010`, `g02.011`, and `g02.012` are complete.
`g02.013` is the current lane, and it can continue to rely on
`001-working-rules` unless a new stable seam needs its own contract.

## Next Task

Keep using `001-working-rules` for `g02.013` while re-proving the strict-
compliance audit and rollout surface after the guidance update.
