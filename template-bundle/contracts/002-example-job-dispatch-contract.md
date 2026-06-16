# 002 Example Job Dispatch Contract

**Type: EXAMPLE** -- Illustrates a completed contract. Remove from your project after reading.

Status: draft
Owner: Platform Team
Updated: YYYY-MM-DD
Depends on: docs/architecture/system-architecture.md, 001-session-and-role-contract.md
Authority owners: `product-api`, `product-worker`
Affects: `product-api`, `product-worker`, `shared-types`

## Problem

The API and worker repos share asynchronous job execution, but retries and
payload interpretation become unreliable if the dispatch boundary is implied
instead of explicitly contracted.

## Contract

- `product-api` is the only producer of accepted job-dispatch payloads.
- The payload schema is versioned in `shared-types` and must include job id,
  actor context, operation type, and retry class.
- `product-worker` must reject payloads that do not conform to the published
  schema instead of repairing them locally.
- Retry eligibility is decided by the retry class emitted by `product-api`;
  workers may delay or schedule retries but may not widen eligibility rules.
- Breaking schema changes require a contract update and coordinated roadmap
  batch, not silent rollout.

## Validation

- contract test covering dispatch payload schema generation
- worker integration test covering rejection of malformed payloads
- roadmap batch log confirming the shared schema version used in both repos

## Migration Notes

Move any ad hoc worker-side payload defaults into the shared schema and remove
repo-local repair logic in the same batch.

## Roadmap Impact

Affected roadmap keys:
- `g01.001` foundation planning and first dispatch-safe batch
- `g01.002` async execution improvements after the seam is stable

## Planning Notes

This contract closes the core async seam between API and worker repos.
Further work that touches downstream analytics export remains blocked until that
separate seam has an owner and contract.
