# 03 Format and Sections Sweep

## Goal

Ensure canonical doc types include required metadata and section headers from Northstar doctrine.

## Required Content Contracts

### Vision artifacts

1. `Status`, `Owner`, `Purpose`
2. `## Long-Term Outcome`
3. `## Strategic Constraints`
4. `## Target Envelopes`
5. `## Alignment Signals`
6. `## Next Task`

### `system-architecture.md`

1. `Status`, `Owner`, `Updated`, `Vision refs`
2. `## Top-Level Stack`
3. `## Data and Authority Flow`
4. `## Invariants`
5. `## Performance and Reliability Constraints`
6. `## Interfaces With Roadmaps`
7. `## Next Task`

### Contract docs (when present)

1. `Status`, `Owner`, `Updated`, `Depends on`
2. `## Problem`
3. `## Contract`
4. `## Validation`
5. `## Migration Notes`
6. `## Roadmap Impact`
7. `## Next Task`

### Roadmap files

1. `Status`, `Owner`, `Created`, `Depends on`, `Vision tags`
2. `## Problem`
3. `## Goals`
4. `## Non-Goals`
5. `## Execution Plan`
6. `## Acceptance Criteria`
7. `## Risks and Mitigations`
8. `## Evidence Requirements`
9. `## Next Task`

### Log files

1. `Status`, `Created`, `Roadmap`, `Batch`
2. `## Summary`
3. `## Changes`
4. `## Validation Performed`
5. `## Evidence`
6. `## Risks`
7. `## Next Task`

## Drift Patterns

- Missing section headers
- Missing metadata labels
- Ad-hoc structure replacing required contract

## Fix Rules

- Add missing required sections before optional sections.
- Keep edits minimal and diff-friendly.
- Do not remove meaningful historical context unless explicitly requested.

## Fast Checks

```bash
rg -n "^## (Long-Term Outcome|Problem|Execution Plan|Validation Performed|Next Task)$" docs
```

## Completion Criteria

- All audited canonical docs satisfy required section contracts.
