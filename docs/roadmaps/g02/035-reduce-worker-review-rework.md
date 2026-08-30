# 035 - Reduce Worker Review Rework

Status: complete
Owner: repo maintainers
Created: 2026-08-30
Depends on: `g02.025`, contract `001-working-rules`
Vision tags: `orchestration`, `review`, `handoff`, `code-quality`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Planning state: card 103 complete

## Problem

Figmatic and Swallowtail code PRs commonly need a blocking revision. The
longest worker handoffs did not prevent multi-round review. Rework mixed worker
misses, weak acceptance oracles, validation gaps, and late planning changes,
while raw cycle counts made those causes indistinguishable.

## Goals

- [x] operationalize risky acceptance with compact adversarial review oracles;
- [x] add a worker pre-PR falsification pass;
- [x] classify blocking review findings by cause;
- [x] route high-risk implementation to frontier/high workers before dispatch;
- [x] make worker handoffs short dispatch overlays, not duplicate authority;
- [x] update copy-ready templates and distributed skill sources together.

## Non-goals

- no promise of zero review revisions;
- no hard handoff line limit or review-cycle quality score;
- no implementation-specific patch prescribed by planning;
- no consumer-repo mutation or retrospective PR relabeling.

## Execution plan

Card `g02.035/103` updates doctrine, the binding contracts, batch-card and
handoff templates, orchestrator routing, and the evidence chain in one batch.

## Acceptance criteria

- [x] risky or universal acceptance names counterexample and proof;
- [x] workers try to falsify the diff before PR creation and revision;
- [x] blocking findings distinguish execution, oracle, planning, validation,
  and integration causes;
- [x] handoffs point to canonical authority instead of pasting it;
- [x] model routing escalates risky workers before review;
- [x] docs and full QA pass.

## Next task

Lane complete. Use finding codes and revision evidence in future Figmatic and
Swallowtail runs; revise doctrine only when that evidence shows a repeatable gap.
