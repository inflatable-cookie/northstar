# 001 - Compact Default Lifecycle

Status: complete
Owner: repo maintainers
Created: 2026-09-04
Depends on: closed `g02` sequencing era
Governing authority: `docs/contracts/001-working-rules.md`, system architecture
Planning provenance: retired spec 038; durable meaning is promoted
Vision tags: `clarity`, `autonomy`, `maintenance`, `traceability`

## Outcome

Northstar and its consumer bundle use one compact strict lifecycle. Only the
active generation remains expanded; completed transport and routine evidence
artifacts leave the live tree without losing current authority, unresolved
meaning, or material provenance.

## Sequence

1. Establish the lifecycle and prove it by rolling up `g01` (PR 36, accepted
  head `8956c5c1e71e9475fdd90fbfc03fd60ecfdc17ed`, merged as
  `e8637b3d74db63c5d805f6726d4e59dd37a49da9`; frozen 18-file `g01` deletion
  manifest and six-row preservation oracle proof formerly on card 130).
2. Compact Northstar's closed `g02` and currentness surfaces (PR 37, accepted
  head `597b89d654ea5d83a42c5a9951a3f7218ffa1752`, merged as
  `4b2e3dd5339d44a5410dea33fb9e528a8046a0ce`; frozen 359-file classified
  deletion manifest and checker modernization formerly on card 131).
3. Make the compact lifecycle the reusable default and retire posture variants
  (PR 38 lifecycle implementation, accepted head
  `6cc2ac0f4443922cb5e209bb072a1130b6b857ab`, merged as
  `8de64926351a47273cd4be66c51f3708888899ef`; PR 39 root README correction,
  accepted head `8a7eff1958e9c3381e719b680561655ef5d65b29`, merged as
  `b0d87d92daf8996ca8e3daac35c28bd7084af59f`; PR 40 spec-038 retirement,
  accepted head `2d3c1a7577f07cf28010cd6c8ef90f5d09e091a8`, merged as
  `e9874ef2c41380460f5595ca82792c7a59c7c980`; mandatory post-merge
  reconciliation proof and template reduction inventory formerly on card 132).
4. Chatterbox closes the task after that correction merges.

## Non-goals

- no product/runtime feature work;
- no deletion before a frozen inventory and preservation proof;
- no retention of old procedural prose merely to preserve history;
- no second compact/full protocol;
- no consolidation of distinct Northstar modes in this milestone.

## Completion
- [x] lifecycle foundation tasks merged after independent exact-head review
  (PRs 36, 37, 38, 39, 40; heads and merges recorded in Closeout);
- [x] only `g03` is expanded in the live sequential roadmap tree;
- [x] normal completed tasks carry their own compact closeout evidence;
- [x] consumed handoffs, routine old logs, and promoted specs follow explicit
      prune triggers;
- [x] reusable doctrine, templates, skills, and checks expose one compact
      default;
- [x] a fresh reader can identify authority, current state, approved
      parallelism, and next work without reading an archive.
## Closeout

- Lifecycle foundation and `g01` roll-up: PR 36, accepted head
  `8956c5c1e71e9475fdd90fbfc03fd60ecfdc17ed`, merged as
  `e8637b3d74db63c5d805f6726d4e59dd37a49da9` (frozen 18-file manifest,
  six-row oracle proof).
- `g02` compaction and currentness: PR 37, accepted head
  `597b89d654ea5d83a42c5a9951a3f7218ffa1752`, merged as
  `4b2e3dd5339d44a5410dea33fb9e528a8046a0ce` (frozen 359-file classified
  manifest: 172 expanded `g02` files, 37 pre-`g03` specs, 34 consumed
  handoffs, 116 routine logs).
- Lifecycle-as-default implementation: PR 38, accepted head
  `6cc2ac0f4443922cb5e209bb072a1130b6b857ab`, merged as
  `8de64926351a47273cd4be66c51f3708888899ef`.
- Root README correction: PR 39, accepted head
  `8a7eff1958e9c3381e719b680561655ef5d65b29`, merged as
  `b0d87d92daf8996ca8e3daac35c28bd7084af59f`.
- Spec-038 retirement: PR 40, accepted head
  `2d3c1a7577f07cf28010cd6c8ef90f5d09e091a8`, merged as
  `e9874ef2c41380460f5595ca82792c7a59c7c980`.
- Final verification: local `main` clean and equal to `origin/main`; independent
  cross-model review accepted the final head; `git diff --check`, repo-contract
  and readiness tests, `effigy qa:docs`, and `effigy qa` passed.
- The non-blocking readiness-map fixture-authority limitation moved to current
  triage. It does not weaken the five proved fixture behaviors or reopen this
  task.
- Pre-flattening provenance: batch cards 130–132 carried the delivery above;
  their files were consumed by `g03.003` after this absorption. Historical
  card numbers above are provenance only and grant no execution authority.
## Next task

No task is ready from this lane. Chatterbox and the operator should choose the next `g03`
simplification tranche.
