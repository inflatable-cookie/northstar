# Example Contract Index

**Type: EXAMPLE** -- Illustrates a completed contract index. Remove from your project after reading.

Status: draft
Owner: Core Team
Updated: YYYY-MM-DD

## Coverage Rules

- Every active roadmap dependency should appear here as an active contract or a
  visible pending item.
- Multi-repo seams stay blocked until the source and consumer repos are explicit.
- Roadmap milestones should reference contract ids directly rather than naming
  vague “integration work.”

## Contract Register

| Contract | Boundary | Owning surface | Dependent roadmaps | Status |
| --- | --- | --- | --- | --- |
| `001-session-and-role-contract.md` | session payloads and role authority | `product-api` | `g01.001` | active |
| `002-job-dispatch-contract.md` | job dispatch payload and retry semantics | `product-api` + `product-worker` | `g01.001` | active |

## Missing or Pending Contracts

| Boundary | Why needed | Blocking roadmaps | Next action |
| --- | --- | --- | --- |
| analytics export feed | export behavior crosses an unresolved repo seam | `g01.002` | confirm authority, then draft `003-analytics-export-contract.md` or defer scope |

## Roadmap Readiness

`g01.001` is ready because its contract chain is complete.
`g01.002` is blocked until the analytics export seam is either contracted or
removed from scope.
