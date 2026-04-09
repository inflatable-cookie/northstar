# 035 - Re-Prove Continuation Envelope Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/010-continuation-envelope-and-stop-signal-contract.md
Roadmap refs: g02.007 batch 7.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/010-continuation-envelope-and-stop-signal-contract.md, skills/northstar-plan/SKILL.md, skills/northstar-handoff/SKILL.md
Auto-start next card: yes, if the next slice is explicit

## Objective

Re-prove that the continuation-envelope contract helps longer autonomous lanes
without weakening stop conditions.

## Scope

- inspect one longer Northstar lane through the updated continuation model
- record where continuation still stops too early or overruns
- compile the next slice only if a bounded problem remains

## Steps

1. Re-run the relevant live path with the updated continuation surfaces.
2. Record any remaining bounded ambiguity or failure mode.
3. Open another slice only if it is justified.

## Acceptance Criteria

- the continuation-envelope contract is re-proved
- remaining ambiguity is explicit and bounded
- another slice opens only if warranted

## Evidence Required

- re-proof log
- updated roadmap/spec state if another slice opens

## Stop Conditions

- the re-proof becomes another speculative autonomy essay

## Completion Notes

Re-proof showed the continuation-envelope contract is now good enough for
bounded ready chains: the next-card envelope, transition proof, and stop
signals are explicit and survive across closeout and handoff. The remaining
gap is no longer card-local continuation. It is lane-level budgeting and clear
pause reasons once a bounded run stops cleanly, so a new slice is justified.

## Next Task

Start `g02.008` batch `8.2` by applying the lane-budget and pause-signal
contract to the reusable doctrine, template, and handoff/log surfaces.
