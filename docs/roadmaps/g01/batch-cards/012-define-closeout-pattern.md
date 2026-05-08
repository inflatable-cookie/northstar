# 012 - Define Closeout Pattern

Status: archived
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/003-ready-state-and-closeout-mechanics.md
Roadmap refs: g01.003 batch 3.2
Governing refs: docs/contracts/001-working-rules.md, docs/logs/README.md, skills/northstar-handoff/SKILL.md
Auto-start next card: yes, if the closeout sequence is explicit across the relevant surfaces

## Objective

Make end-of-lane closeout mechanical enough that agents can update the batch
card, roadmap, log, and handoff state without improvising the sequence.

## Scope

- define the closeout sequence in doctrine and working rules
- update the relevant templates for logs, batch cards, and handoffs
- align `northstar-handoff` with the same closeout pattern

## Steps

1. Define the minimum closeout sequence and ordering.
2. Update reusable templates so the sequence is visible in the files.
3. Align handoff guidance with the same closeout rules.
4. Update the live repo wording so the closeout pattern is obvious.

## Acceptance Criteria

- the repo defines the minimum closeout sequence clearly
- the relevant reusable templates expose the closeout pattern
- `northstar-handoff` uses the same sequence
- the closeout pattern reduces end-of-lane ambiguity

## Evidence Required

- updated doctrine and template surfaces
- updated handoff skill/template surfaces

## Stop Conditions

- the closeout pattern still leaves ordering ambiguous
- the pattern adds ceremony without reducing manual coordination

## Completion Notes

The repo now defines a minimum closeout order: update the current batch card,
update the roadmap if its state changed, write the batch log, create a handoff
only when another thread truly needs it, and leave the next task in the
highest-authority active surface.

## Next Task

Apply the ready-state and closeout mechanics to the live repo checks and prove
them in one follow-on execution lane.
