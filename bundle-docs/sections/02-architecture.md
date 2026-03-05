# 02 Architecture

Status: draft
Updated: 2026-03-05

## Why this section matters now

Architecture translates vision into a concrete system shape and invariants.
It provides technical boundaries that roadmaps must implement against.

## Scope

Define system layers, authority boundaries, and non-negotiable contracts.
Keep milestone-level execution detail out of architecture docs.

## Template layout

- `docs/architecture/README.md` (index and architecture writing rules)
- `docs/architecture/system-architecture.md` (top-level stack and invariants)
- `docs/architecture/contracts/` (placeholder for explicit contract docs)

## Naming and ordering

- Top-level architecture docs use descriptive names.
- Contract docs should use 3-digit prefixes only when the project chooses sequential contract numbering.

## Content contract (`system-architecture.md`)

1. `## Top-Level Stack`
2. `## Data and Authority Flow`
3. `## Invariants`
4. `## Performance and Reliability Constraints`
5. `## Interfaces With Roadmaps`
6. `## Next Task`

## Dependencies

- Must reference current vision constraints directly.
- Should expose clear handoff points for roadmap milestones.

## Open decisions

- Should architecture docs enforce a required glossary file for shared terms?

## Next task

Draft `docs/architecture/system-architecture.md` with fixed section headers and short example content.
