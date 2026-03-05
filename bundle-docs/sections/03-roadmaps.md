# 03 Roadmaps

Status: draft
Updated: 2026-03-05

## Why this section matters now

Roadmaps convert direction into executable short-term milestone blocks.
Without segmentation they become unbounded and hard to navigate.

## Scope

Define milestone files, task lists, acceptance criteria, and sequencing rules.
Roadmaps must derive from vision and architecture unless a documented exception exists.

## Key recommendation

Use generation key format `gNN` (for example `g01`, `g02`) both in folder names and references.

Rationale:
- concise in written references (`g01.105`)
- lexicographically stable due to zero padding
- clearer and shorter than `gen1` while still explicit

## Template layout

- `docs/roadmaps/README.md`
- `docs/roadmaps/g01/001-<slug>.md`
- `docs/roadmaps/g01/00n-<slug>.md`
- `docs/roadmaps/generation-index.md` (active generation, rollover notes)

## Naming and ordering

- File pattern: `docs/roadmaps/gNN/NNN-<slug>.md`
- Numeric prefix increments per generation and resets when generation increments.
- Cross-file reference format: `gNN.NNN` (example: `g01.105`).

## Generation rollover rule (starter)

Start a new generation (`g02`) when either is true:
- current generation reaches 120 roadmap files, or
- there is a major architecture/vision shift that invalidates prior sequencing assumptions.

Record rollover reason in `docs/roadmaps/generation-index.md`.

## Content contract (per roadmap file)

1. `Status`, `Owner`, `Created`, `Depends on`, `Vision tags`
2. `## Problem`
3. `## Goals`
4. `## Non-Goals`
5. `## Execution Plan` (batches with executable task lists)
6. `## Acceptance Criteria`
7. `## Risks and Mitigations`
8. `## Evidence Requirements`
9. `## Next Task`

## Next task

Draft the roadmap file template and generation index template with the `gNN.NNN` reference convention baked in.
