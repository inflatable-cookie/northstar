# 059 - Apply Underlay Recovery Findings

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md
Roadmap refs: g02.015 batch 15.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md
Auto-start next card: no

## Objective

Apply the warranted Underlay recovery batch once the audit made the drift
explicit.

## Scope

- recover Underlay’s planning/currentness surfaces
- open one active Underlay lane for the real shared-surface overhaul
- avoid touching in-progress implementation or unrelated dirty files

## Steps

1. Confirm the Underlay drift is primarily planning/currentness, not missing
   doctrine.
2. Apply a narrow Underlay docs recovery batch on disjoint planning surfaces.
3. Revalidate Underlay’s docs/Northstar surfaces.

## Acceptance Criteria

- Underlay no longer claims there is no active roadmap
- the active Underlay overhaul has one explicit lane
- the next Underlay-owned move is explicit

## Evidence Required

- Underlay roadmap/currentness updates
- Underlay validation evidence
- Northstar log

## Stop Conditions

- the batch starts rewriting unrelated Underlay guides or implementation files
- the existing dirty Underlay guide file is touched without need

## Completion Notes

- Underlay’s issue was not lack of a Northstar docs spine. It was that the
  spine still advertised the old Poodle-contraction stop point while the real
  shared-surface overhaul continued.
- The warranted fix was a narrow planning/currentness recovery batch:
  `g01.098` now carries the live queue, and the dirty
  `docs/guides/110-admin.md` file was intentionally left untouched.
- The next honest question is not “is Underlay strict enough?” in the abstract.
  It is whether `g01.098` proves enough on the planning layer alone or whether
  its live execution now warrants a stricter execution lane too.

## Next Task

Let Underlay execute `g01.098` Batch 98.2, then reassess whether a stricter
execution-lane proof is warranted there.
