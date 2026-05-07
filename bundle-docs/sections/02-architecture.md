# 02 Architecture

Status: active
Updated: 2026-03-05

## Why this section matters now

Architecture translates vision into a durable system shape and invariants.
It records the realized structure that roadmap batches must implement against.

## Scope

Define system layers, authority boundaries, full system coverage, and the
realized structure that has been promoted out of specs and research.
Use research translation memos as inputs when external comparisons materially shaped the boundary.
Keep milestone task sequencing out of architecture docs.

## Template layout

- `docs/architecture/README.md`
- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` (required for multi-repo systems)
- `docs/contracts/001-<slug>.md`
- `docs/contracts/00n-<slug>.md`

## Default vs optional

- `architecture/` and `contracts/` are default core sections.
- Add `docs/specs/` when a change needs provisional planning before its durable
  outcomes can be promoted into architecture/contracts.
- Add `docs/schemas/` only when formal modeling or schema artifacts are needed.

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
- Must absorb durable structural decisions from specs before roadmap execution
  proceeds on a material change.
- Must expose complete execution-relevant system coverage in `system-inventory.md`
  before roadmap work starts.
- Must define authority across repos in `repo-authority-map.md` when more than
  one repo or deployable owner exists.
- Must link to research translation memos when a boundary depends on comparative findings.
- Must expose clear handoff points for roadmap milestones.

## Quick reference

- [Glossary: Architecture](../glossary.md#core-concepts)
- [Glossary: Posture and adoption](../glossary.md#posture-and-adoption)
- [Cheat sheet: Folder structure](../cheat-sheet.md#folder-structure)

## Next task

Keep architecture clearly distinct from specs: planning may happen in specs, but
accepted structural outcomes must land here before roadmap work begins.
