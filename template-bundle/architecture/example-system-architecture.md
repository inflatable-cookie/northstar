# Example System Architecture

Status: draft
Owner: Core Team
Updated: YYYY-MM-DD
Vision refs: docs/vision/001-example-project-vision.md

## Top-Level Stack

1. Product surfaces (web/admin/automation touchpoints)
2. Application services and orchestration
3. Domain and policy layer
4. Data access and storage layer
5. Observability and operational tooling

## Data and Authority Flow

- User and automation intents enter through product surfaces.
- Application services validate and map intents to domain operations.
- Domain layer is the single authority for business rules and state transitions.
- Storage layer persists authoritative state and emits retrieval/query projections.

## Invariants

- Domain rules are enforced server-side, not only in UI layers.
- Roadmap changes must reference affected architecture boundaries.
- Reports must reflect real validation activity from completed batches.

## Performance and Reliability Constraints

- API and workflow latency targets should be explicit per milestone.
- Critical failure paths require clear rollback or containment behavior.
- Batch closures must identify residual risk and ownership.

## Interfaces With Roadmaps

- `g01.001` establishes core delivery and reporting foundation.
- Follow-on milestones may expand architecture depth only after foundational acceptance criteria pass.

## Next Task

Create the first contract doc under `docs/contracts/` for the highest-risk boundary.
