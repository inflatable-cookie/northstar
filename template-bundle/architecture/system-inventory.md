# System Inventory

**Type: REQUIRED** (strict posture) -- Enumerate all system elements and their planning coverage.

Status: draft
Owner: <owner>
Updated: YYYY-MM-DD
Architecture refs: <system-architecture.md>

## Coverage Summary

State whether planning coverage is complete, partial, or blocked and why.

## In-Scope System Elements

| Element | Type | Owner | Authority | Planned artifacts |
| --- | --- | --- | --- | --- |
| <name> | <repo/service/package> | <owner> | <what it controls> | <architecture/contract refs> |

## Interfaces and Dependencies

| Surface | Upstream | Downstream | Contract | Notes |
| --- | --- | --- | --- | --- |
| <surface> | <source> | <consumer> | <contract id or pending> | <notes> |

## Validation Surfaces

| Area | Evidence required | Owner | Status |
| --- | --- | --- | --- |
| <area> | <tests/logs/manual checks> | <owner> | <ready/pending> |

## Planning Gaps

- <missing repo, contract, authority, or validation surface>

## Next Task

Close the highest-risk planning gap or promote the next required contract so
roadmap work can start without inferred system behavior.
