# 052 - Apply Audit And Rollout Guidance

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/016-strict-compliance-audit-and-rollout.md
Roadmap refs: g02.013 batch 13.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/016-strict-compliance-audit-and-rollout.md
Auto-start next card: yes, if the re-proof surface is explicit

## Objective

Apply the strict-compliance audit and rollout guidance to Northstar's doctrine,
setup, and template surfaces.

## Scope

- make the audit and rollout surface reusable
- keep it compact enough to use across many projects
- leave the re-proof batch explicit and ready

## Steps

1. Apply the audit and rollout guidance to doctrine.
2. Apply the same guidance to setup and template surfaces.
3. Refresh any currentness or checker surfaces affected by those changes.

## Acceptance Criteria

- the audit and rollout guidance is materially reflected in Northstar
- the re-proof batch is explicit and ready

## Evidence Required

- consolidation log
- updated roadmap/spec state

## Stop Conditions

- the batch drifts into one project's concrete migration work

## Completion Notes

- Added a reusable strict-compliance migration pattern to doctrine, setup, and
  template surfaces.
- Made repo classification, checkpoint audit, current tranche, next tranche,
  and tranche-close evidence explicit in the setup guidance.
- Added a copy-ready strict-compliance migration master-spec template instead
  of leaving rollout representation to prose alone.

## Next Task

Start `g02.013` batch `13.3` by re-proving the strict-compliance audit and
rollout surface after the guidance update.
