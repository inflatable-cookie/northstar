# 038 - Re-Prove Lane Budget And Pause-Signal Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/011-lane-budget-and-pause-signal-contract.md
Roadmap refs: g02.008 batch 8.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/011-lane-budget-and-pause-signal-contract.md, skills/northstar-handoff/SKILL.md
Auto-start next card: yes, if the next slice is explicit

## Objective

Re-prove that the lane-budget and pause-signal contract helps longer
autonomous lanes stop cleanly without weakening the stop model.

## Scope

- inspect another longer live lane through the updated budget/pause model
- record where pause reporting still feels too vague or too heavy
- compile the next slice only if a bounded problem remains

## Steps

1. Re-run the relevant live path with the updated lane-budget and pause
   surfaces.
2. Record any remaining bounded ambiguity or failure mode.
3. Open another slice only if it is justified.

## Acceptance Criteria

- the lane-budget and pause-signal contract is re-proved
- remaining ambiguity is explicit and bounded
- another slice opens only if warranted

## Evidence Required

- re-proof log
- updated roadmap/spec state if another slice opens

## Stop Conditions

- the re-proof becomes another speculative autonomy essay

## Completion Notes

Re-proof showed the combined continuation and lane-budget model is now clean
enough for routine bounded use inside Northstar itself. The next meaningful
gap is external proof in a real consumer repo, not another internal doctrine
slice.

## Next Task

Start `g02.009` batch `9.2` by running the combined autonomy model against a
real active consumer-repo lane and recording what still breaks outside
Northstar itself.
