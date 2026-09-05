# 001 - Establish widget ids

Status: complete
Owner: catalog maintainers
Created: 2026-01-12
Master roadmap: g01.001
Governing refs: docs/contracts/001-working-rules.md
Auto-start next card: no

## Objective

Ship stable widget identifiers.

## Unique durable rule

UNIQUE-ORPHAN-RULE: Widget export keys must be signed by the owning team.
Ownership of this live rule is contested between Platform and Catalog. Neither
`docs/contracts/001-working-rules.md` nor `docs/architecture/system-architecture.md`
may receive it until that ownership is settled. This card is the only current
statement of the rule.

## Execution Plan

- [x] PROCEDURAL-STEP-DO-NOT-COPY: draft the identifier allocator
- [x] land the prefix check

## Evidence

- EVIDENCE-PR-101: https://example.invalid/widget-catalog/pull/101
- merge commit: `c0ffee101`

## Next Task

Generation closed. Do not execute from this card.
