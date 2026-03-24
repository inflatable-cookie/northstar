# Contract Index

Status: draft
Owner: <owner>
Updated: YYYY-MM-DD

## Coverage Rules

- Every execution-relevant boundary should map to a contract or an explicit
  pending item below.
- Roadmap milestones must reference the governing contract ids directly.
- If a required boundary has no contract, mark the roadmap blocked and close the
  gap before execution continues.

## Contract Register

| Contract | Boundary | Owning surface | Dependent roadmaps | Status |
| --- | --- | --- | --- | --- |
| <001-...> | <boundary> | <repo/service/domain> | <gNN.NNN> | <draft/active/superseded> |

## Missing or Pending Contracts

| Boundary | Why needed | Blocking roadmaps | Next action |
| --- | --- | --- | --- |
| <boundary> | <reason> | <gNN.NNN> | <create/update contract> |

## Roadmap Readiness

State which roadmap milestones are fully contracted and which remain blocked on
planning work.

## Next Task

Remove the highest-risk item from `Missing or Pending Contracts` so active
roadmap work has a complete contract chain.
