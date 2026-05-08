# 041 - Apply Consumer-Repo Autonomy Findings

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md
Roadmap refs: g02.009 batch 9.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md
Auto-start next card: yes, if the next slice is explicit

## Objective

Apply only the bounded findings from the consumer-repo autonomy proof.

## Scope

- consolidate the real external failures
- avoid speculative internal cleanup not justified by the proof
- open another slice only if a bounded issue still remains

## Steps

1. Apply the bounded findings from the proof batch.
2. Refresh any currentness or checker surfaces affected by those changes.
3. Open another slice only if the proof leaves a real bounded problem.

## Acceptance Criteria

- the proof findings are materially reflected in Northstar
- another slice opens only if warranted

## Evidence Required

- consolidation log
- updated roadmap/spec state if another slice opens

## Stop Conditions

- the consolidation batch starts adding unrelated autonomy features

## Completion Notes

The proof-backed change was narrower than another autonomy abstraction.

Northstar now says explicitly:

- roadmap-only repos are still valid and useful
- the full continuation-envelope, lane-budget, and pause-signal model belongs
  with the stricter `specs/` and batch-card layer

This batch also opened the next proof lane so the stricter adoption threshold
can be tested in a real consumer repo instead of remaining a doctrine claim.

## Next Task

Start `g02.010` batch `10.2` by testing the stricter delivery-layer adoption
threshold against a real active consumer-repo lane.
