# Example Repo Authority Map

Status: draft
Owner: Core Team
Updated: YYYY-MM-DD
Architecture refs: docs/architecture/system-architecture.md, docs/architecture/example-system-inventory.md

## Topology

This example system has three owned repos and one unresolved downstream sink:

- `product-web` for browser-facing product flows
- `product-api` for domain authority and synchronous write paths
- `product-worker` for asynchronous job execution
- `analytics-export` for downstream reporting, ownership still unresolved

## Repo Authorities

| Repo | Owns | Consumes | Authoritative decisions | Notes |
| --- | --- | --- | --- | --- |
| `product-web` | route composition, form UX, user navigation | auth/session claims, typed API responses | no authority over domain policy or role truth | Must render server-issued permissions, not derive its own |
| `product-api` | domain state transitions, policy checks, job creation | shared types, persistence, external auth provider | source of truth for roles, writes, and dispatch intent | Governs both sync and async boundaries |
| `product-worker` | job execution, retry semantics, side-effect ordering | dispatch payloads from API | authority over execution bookkeeping after dispatch acceptance | Must not reinterpret dispatch schema |
| `analytics-export` | unknown | export feed from API | unknown | Planning gap until ownership is confirmed |

## Cross-Repo Contracts

| Seam | Source repo | Consumer repo | Contract | Status |
| --- | --- | --- | --- | --- |
| Session and role claims | `product-api` | `product-web` | `001-session-and-role-contract.md` | ready |
| Job dispatch payload | `product-api` | `product-worker` | `002-job-dispatch-contract.md` | ready |
| Analytics export feed | `product-api` | `analytics-export` | `pending` | gap |

## Conflict Resolution Rules

- `product-api` is authoritative for role truth, mutation policy, and dispatch
  intent.
- `product-worker` is authoritative only for execution bookkeeping after a job
  is accepted under the dispatch contract.
- If `analytics-export` ownership remains unknown, roadmap execution must not
  include export behavior.

## Planning Gaps

- Determine whether the analytics sink is a first-party repo, external system,
  or out-of-scope integration.

## Next Task

Resolve the analytics seam authority, then convert the pending seam into an
explicit contract or drop it from active delivery.
