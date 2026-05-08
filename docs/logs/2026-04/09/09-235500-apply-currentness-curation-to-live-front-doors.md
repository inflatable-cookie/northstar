# Apply Currentness Curation To Live Front Doors

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.004 batch 4.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/007-currentness-curation-and-evidence-window.md

## Summary

Applied the currentness curation rule to the live repo surfaces. The front
doors keep one active spec and one active milestone, and `docs/logs/README.md`
now presents a bounded evidence window instead of a growing month dump.

## Findings

The live repo no longer needs a broad current-month log list on the front door.
For the active lane, the useful evidence chain is:

- one still-governing context log for the active generation boundary
- the recent active-lane logs from the currentness/alignment and curation work

That is enough to reach the current lane quickly without pretending the log
README is a full archive index.

## Files Changed

- added `docs/roadmaps/g02/batch-cards/025-apply-currentness-curation-to-live-front-doors.md`
- added `docs/roadmaps/g02/batch-cards/026-reprove-front-door-path-after-curation.md`
- updated `docs/specs/archive/007-currentness-curation-and-evidence-window.md`
- updated `docs/README.md`
- updated `docs/roadmaps/README.md`
- updated `docs/roadmaps/g02/README.md`
- updated `docs/roadmaps/generation-index.md`
- updated `docs/contracts/contract-index.md`
- updated `docs/logs/README.md`
- updated `docs/roadmaps/g02/004-define-currentness-curation-and-evidence-window.md`
- updated `scripts/check-northstar-repo-contract.ts`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the live front doors now follow the one-spec and one-active-milestone rule
- the live log front door now uses a bounded evidence window
- the checker remains bounded to deterministic alignment around the live
  currentness surface

## Unresolved

- the front-door path still needs one more re-proof pass after this curation
  update

## Next Task

Start `g02.004` batch `4.3` by re-running the front-door path after the
curation update and recording what ambiguity still remains acceptable.
