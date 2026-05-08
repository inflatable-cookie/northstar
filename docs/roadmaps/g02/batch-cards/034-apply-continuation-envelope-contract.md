# 034 - Apply Continuation Envelope Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/010-continuation-envelope-and-stop-signal-contract.md
Roadmap refs: g02.007 batch 7.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/010-continuation-envelope-and-stop-signal-contract.md, skills/northstar-plan/SKILL.md, skills/northstar-handoff/SKILL.md
Auto-start next card: yes, if the re-proof batch is explicit

## Objective

Apply the continuation-envelope and stop-signal contract to the reusable
Northstar surfaces.

## Scope

- update the working rules and batch-card template
- align planning and handoff surfaces with the same continuation model
- keep the result compact rather than orchestration-heavy

## Steps

1. Update the live and reusable doctrine surfaces.
2. Update planning and handoff surfaces where continuation state is carried.
3. Refresh deterministic checks where expectations changed.

## Acceptance Criteria

- continuation-envelope behavior is explicit in the affected reusable surfaces
- the re-proof batch is explicit and ready

## Evidence Required

- updated doctrine, template, and skill surfaces
- implementation batch log

## Stop Conditions

- the implementation starts introducing orchestration machinery instead of
  compact docs/state rules

## Completion Notes

Applied the continuation-envelope and stop-signal contract to the live working
rules, reusable batch-card and log templates, and the planning/handoff
surfaces that carry continuation state between cards and threads. The model
remains intentionally simple: explicit bounded continuation in file state, not
orchestration machinery.

## Next Task

Start `g02.007` batch `7.3` by re-proving the continuation-envelope contract
against a longer autonomous lane.
