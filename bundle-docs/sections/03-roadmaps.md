# 03 Roadmaps

Status: active
Updated: 2026-03-05

## Why this section matters now

Roadmaps convert strategy into executable short-term milestone blocks.
Generation segmentation keeps long-running programs manageable.

## Scope

Define milestone files, batch-oriented execution lists, acceptance criteria, and sequencing rules.
Roadmaps must derive from vision and architecture unless a documented exception exists.

## Key format decision

Use generation key format `gNN` (for example `g01`, `g02`) in folders and references.

Rationale:
- concise references (`g01.105`)
- stable lexical sorting with zero padding
- clearer than `gen1` while staying explicit

## Template layout

- `docs/roadmaps/README.md`
- `docs/roadmaps/g01/001-<slug>.md`
- `docs/roadmaps/g01/00n-<slug>.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/backlog/README.md`
- `docs/roadmaps/backlog/backlog-item-template.md`
- `docs/logs/templates/roadmap-currentness-triage-template.md` (optional)

## Naming and ordering

- File pattern: `docs/roadmaps/gNN/NNN-<slug>.md`
- Numeric prefix increments per generation and resets on generation rollover.
- Cross-file references use `gNN.NNN`.

## Generation rollover rule

Start a new generation (`g02`) when either is true:
- current generation reaches 120 roadmap files, or
- a major vision/architecture shift requires a fresh sequencing baseline.

Record rollover reason in `docs/roadmaps/generation-index.md`.

## Content contract (per roadmap file)

1. `Status`, `Owner`, `Created`, `Depends on`, `Vision tags`
2. `## Problem`
3. `## Goals`
4. `## Non-Goals`
5. `## Execution Plan` (batch-based executable task lists)
6. `## Acceptance Criteria`
7. `## Risks and Mitigations`
8. `## Evidence Requirements`
9. `## Next Task`

## Batch rule

- Plan and execute in meaningful batches (not micro-tasks).
- Logs must be created per completed batch/update cycle, not per individual task.

## Currentness rule

- Keep one clearly identified active queue.
- Move deferred items into backlog with promotion criteria.
- Use lightweight currentness triage logs only when queue clarity degrades.

## Lean governance rule

Default posture is manual-first evidence, not checker-script proliferation.

Only add a new script/checker when all are true:
- the same check has repeated in at least 3 batches, or across at least 2 projects
- pass/fail is deterministic and not primarily judgement-based
- an owner and expected run cadence are explicitly assigned
- a removal/sunset trigger is recorded

If these conditions are not met, keep validation in batch logs as human-run checks.

## Next task

Align roadmap templates with backlog/currentness artifacts and keep automation optional by default.
