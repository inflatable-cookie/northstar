# Example System Inventory

Status: draft
Owner: Core Team
Updated: YYYY-MM-DD
Architecture refs: docs/architecture/system-architecture.md

## Coverage Summary

Planning coverage is partial. The web app, API, worker, and shared contracts are
enumerated, but analytics export ownership remains a planning gap until the data
sink repo is confirmed.

## In-Scope System Elements

| Element | Type | Owner | Authority | Planned artifacts |
| --- | --- | --- | --- | --- |
| `product-web` | repo | Web Team | user-facing flows and input validation UX | `system-architecture.md`, `001-session-and-role-contract.md` |
| `product-api` | repo | Platform Team | domain rules, write APIs, and policy checks | `system-architecture.md`, `001-session-and-role-contract.md`, `002-job-dispatch-contract.md` |
| `product-worker` | repo | Platform Team | asynchronous execution and retry semantics | `system-architecture.md`, `002-job-dispatch-contract.md` |
| `shared-types` | package | Platform Team | canonical request/response shapes | `001-session-and-role-contract.md`, `002-job-dispatch-contract.md` |
| `analytics-export` | external repo | Unknown | downstream reporting sink | `pending` |

## Interfaces and Dependencies

| Surface | Upstream | Downstream | Contract | Notes |
| --- | --- | --- | --- | --- |
| Session and role claims | `product-api` | `product-web`, `shared-types` | `001-session-and-role-contract.md` | UI must not invent permissions client-side |
| Job dispatch payload | `product-api` | `product-worker` | `002-job-dispatch-contract.md` | Worker retry behavior depends on payload guarantees |
| Analytics export feed | `product-api` | `analytics-export` | `pending` | Sink ownership unresolved |

## Validation Surfaces

| Area | Evidence required | Owner | Status |
| --- | --- | --- | --- |
| Auth/session contract | API tests, UI integration checks, roadmap log evidence | Platform Team | ready |
| Job dispatch contract | worker integration checks, retry-path validation, roadmap log evidence | Platform Team | ready |
| Analytics export seam | authority confirmation, contract draft, validation owner | Unknown | pending |

## Planning Gaps

- Confirm whether `analytics-export` is an owned repo, a vendor sink, or a
  deferred integration before roadmap work touches export behavior.

## Next Task

Close the analytics export ownership gap, then add the missing seam contract or
remove export work from active roadmap scope.
