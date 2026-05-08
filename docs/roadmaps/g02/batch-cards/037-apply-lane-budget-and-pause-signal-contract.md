# 037 - Apply Lane Budget And Pause-Signal Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/011-lane-budget-and-pause-signal-contract.md
Roadmap refs: g02.008 batch 8.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/011-lane-budget-and-pause-signal-contract.md, skills/northstar-handoff/SKILL.md
Auto-start next card: yes, if the re-proof batch is explicit

## Objective

Apply the lane-budget and pause-signal contract to the reusable Northstar
surfaces.

## Scope

- update the live and reusable doctrine/template surfaces
- align handoff/log surfaces with the same lane-budget and pause model
- keep the result compact and human-usable

## Steps

1. Update the relevant doctrine and template surfaces.
2. Update handoff/log surfaces that need to preserve lane-budget and pause state.
3. Refresh deterministic checks where expectations changed.

## Acceptance Criteria

- lane-budget and pause-signal behavior is explicit in the affected reusable
  surfaces
- the re-proof batch is explicit and ready

## Evidence Required

- updated doctrine, template, and handoff surfaces
- implementation batch log

## Stop Conditions

- the implementation starts introducing heavyweight run-state bookkeeping

## Completion Notes

Applied the lane-budget and pause-signal contract to the live working rules,
batch-card template, log guidance, and handoff surfaces. The model remains
lean: lane-level budget and pause state are explicit in file state, but there
is still no heavyweight run-state machinery.

## Next Task

Start `g02.008` batch `8.3` by re-proving the lane-budget and pause-signal
contract against another longer autonomous lane.
