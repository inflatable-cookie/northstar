# 001 - Compact Default Lifecycle

Status: active
Owner: repo maintainers
Created: 2026-09-04
Depends on: closed `g02` sequencing era
Governing authority: `docs/contracts/001-working-rules.md`, system architecture
Planning provenance: spec 038 (retirement pending final correction)
Vision tags: `clarity`, `autonomy`, `maintenance`, `traceability`

## Outcome

Northstar and its consumer bundle use one compact strict lifecycle. Only the
active generation remains expanded; completed transport and routine evidence
artifacts leave the live tree without losing current authority, unresolved
meaning, or material provenance.

## Sequence

1. Card 130 establishes the lifecycle and proves it by rolling up `g01`.
2. After 130 merges, cards 131 and 132 run concurrently:
   - 131 compacts Northstar's closed `g02` and currentness surfaces;
   - 132 makes the compact lifecycle the reusable default and retires posture
     variants.
3. Both siblings and the README follow-up merged. Card 132's final correction
   removes the remaining spec-038 checker/fixture coupling and retires that
   promoted spec with preservation proof.
4. Chatterbox closes the milestone after that correction merges.

## Non-goals

- no product/runtime feature work;
- no deletion before a frozen inventory and preservation proof;
- no retention of old procedural prose merely to preserve history;
- no second compact/full protocol;
- no consolidation of distinct Northstar modes in this milestone.

## Completion

- cards 130, 131, and 132 are merged after independent exact-head review;
- only `g03` is expanded in the live sequential roadmap tree;
- normal completed cards carry their own compact closeout evidence;
- consumed handoffs, routine old logs, and promoted specs follow explicit prune
  triggers;
- reusable doctrine, templates, skills, and checks expose one compact default;
- a fresh reader can identify authority, current state, approved parallelism,
  and next work without reading an archive.
