# 130 - Establish Lifecycle and Roll Up g01

Status: ready
Owner: repo maintainers
Created: 2026-09-04
Master roadmap: `g03.001`
Governing refs: spec 038, contract 001
Auto-start next cards: yes — cards 131 and 132 as concurrent siblings

## Objective

Implement the lifecycle foundation in canonical Northstar authority and prove
the generation-closure contract by replacing expanded `g01` with one safe
roll-up.

## Approved dispatch manifest

- **Lane:** `g03.001/130`
- **State:** ready
- **Prerequisites:** planning commit opening `g03` is on `main`; no active work
  or unresolved commitment remains in `g01`
- **Completion:** lifecycle authority and structural proof are merged; `g01`
  exists only as a roll-up and all current references remain valid
- **Approved concurrent siblings:** none
- **Serial edges:** cards 131 and 132 require this card merged
- **Worker class:** economical general/day-to-day documentation implementation;
  not an auditor, planner, coordinator, or documentation-grind profile
- **Reviewer class:** independent semantic reviewer using a different
  provider/model identity from the worker
- **Escalation owner:** Chatterbox for meaning, retention, or deletion choices

Owned mutable paths:

- `docs/architecture/system-architecture.md`;
- `docs/contracts/001-working-rules.md` and its index;
- `docs/roadmaps/g01/**`;
- `docs/roadmaps/archive/g01.md`;
- direct current links whose only change is the `g01` destination;
- focused lifecycle structural checks and direct fixtures under `scripts/`;
- this card and its exceptional evidence only if the result cannot remain
  legible here.

Reserved shared closeout surfaces: `docs/README.md`, roadmap front doors, and
installed skill parity. Card 130 may update them only where required to keep a
changed `g01` link valid; card 131 owns their compaction.

## Required work

1. Promote spec 038's artifact classes, prune triggers, generation closure, and
   preservation oracle into durable architecture/contract authority.
2. Freeze every tracked `g01` deletion target and classify any unique current
   meaning before deletion.
3. Create one non-procedural `g01` roll-up with current authority destinations
   and selected material evidence.
4. Remove expanded `g01` milestones and cards from `HEAD`.
5. Add the smallest stable structural proof needed for the one-expanded-
   generation and archive non-authority rules.

## Acceptance evidence and review oracle

- [ ] frozen inventory accounts for every removed `g01` file;
- [ ] no current authority or unresolved commitment exists only in removed
      content;
- [ ] the roll-up contains outcomes and provenance, not runnable old steps;
- [ ] current links and deterministic structural checks pass;
- [ ] `git diff --check`, `effigy qa:docs`, and `effigy qa` pass;
- [ ] independent review falsifies each preservation-oracle row against the
      exact PR head.

## Stop conditions

- a `g01` file contains unique current authority or unresolved meaning without
  a confirmed destination;
- deletion scope extends beyond the frozen inventory;
- a checker requires prose snapshots or an arbitrary line-count score;
- validation changes the plan.
