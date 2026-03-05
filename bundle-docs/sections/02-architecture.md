# 02 Architecture

Status: active
Updated: 2026-03-05

## Why this section matters now

Architecture translates vision into a concrete system shape and invariants.
It provides technical boundaries that roadmap batches must implement against.

## Scope

Define system layers, authority boundaries, core invariants, and contract surfaces.
Keep milestone task sequencing out of architecture docs.

## Template layout

- `docs/architecture/README.md`
- `docs/architecture/system-architecture.md`
- `docs/contracts/001-<slug>.md`
- `docs/contracts/00n-<slug>.md`

## Default vs optional

- `architecture/` and `contracts/` are default core sections.
- Add `docs/specs/` or `docs/schemas/` only when formal modeling or schema contracts are needed.

## Naming and ordering

- Top-level architecture docs use descriptive names.
- Contract docs use 3-digit prefixes when maintained as a sequence.
- Contract file pattern: `NNN-<kebab-slug>.md`.

## Content contract (`system-architecture.md`)

1. `Status`, `Owner`, `Updated`, `Vision refs`
2. `## Top-Level Stack`
3. `## Data and Authority Flow`
4. `## Invariants`
5. `## Performance and Reliability Constraints`
6. `## Interfaces With Roadmaps`
7. `## Next Task`

## Content contract (contract docs)

1. `Status`, `Owner`, `Updated`, `Depends on`
2. `## Problem`
3. `## Contract`
4. `## Validation`
5. `## Migration Notes`
6. `## Roadmap Impact`
7. `## Next Task`

## Dependencies

- Must link directly to current vision artifact(s).
- Must expose clear handoff points for roadmap milestones.

## Glossary decision

A dedicated glossary file is optional, not required in v1.
Teams can add `docs/architecture/glossary.md` when term drift appears.

## Next task

Align architecture starter templates so metadata and section headers match this contract exactly.
