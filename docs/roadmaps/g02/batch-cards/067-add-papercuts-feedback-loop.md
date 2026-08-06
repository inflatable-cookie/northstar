# 067 - Add Papercuts Feedback Loop

Status: complete
Owner: repo maintainers
Updated: 2026-08-06
Master spec refs: `docs/specs/024-papercuts-feedback-loop.md`
Governing refs: `docs/contracts/001-working-rules.md`, `bundle-docs/papercuts.md`,
`g02.023`
Auto-start next card: no

## Ready-State Checks

- [x] Objective was bounded enough to finish without fresh planning decisions.
- [x] Governing refs pointed at current canonical surfaces.
- [x] Scope boundaries and stop conditions were explicit.
- [x] Acceptance criteria, validation, and evidence requirements were explicit.
- [x] No unresolved planning or intent gap governed this card.
- [x] Auto-start was disabled at lane closeout.

## Objective

Make agents capture small, solvable execution friction in a root-level
`PAPERCUTS.md` queue without operator intervention or interruption of the active
task.

## Lane Runway Context

- Higher-level lane owner: g02 reusable bundle and skill hardening runway
- Next transition: consumer-repo proof and first papercut triage
- Next planning checkpoint: after the first consumer queue is reviewed

## Scope

- define the queue contract and starter shape
- wire doctrine, contracts, skill, templates, and source-repo QA
- record one real papercut from this implementation run
- do not build automatic triage, prioritization, or issue creation

## Steps

1. Add the canonical papercut rule, queue starter, and template.
2. Update agent-facing skill, prompt, contract, architecture, and entry surfaces.
3. Add bounded required-file/content checks and run Effigy QA.
4. Close the roadmap and evidence surfaces with the consumer proof as next task.

## Acceptance Criteria

- agents create or append to root `PAPERCUTS.md` at encounter time
- agents continue without operator permission or unplanned scope expansion
- papercuts remain observations until normal maintenance triage
- source QA passes and the first real note is preserved

## Evidence Required

- `PAPERCUTS.md` first live entry
- `effigy qa`
- `effigy qa:docs`
- roadmap, card, and batch log closeout

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none
- Remaining ready chain after this card: 0
- Transition proof required before auto-start: consumer-repo proof requires a new card

## Lane Budget

- Current card ends budgeted run: yes
- Further operator decision required after this card: yes
- Pause signal if run stops here: lane-complete

## Stop Conditions

- Stop if the queue becomes a second planning authority or requires a runtime
  hook to work.
- Stop if a consumer-repo proof needs a product or triage policy decision not
  covered by the current contract.

## Completion Notes

Implemented the root queue, canonical contract, skill behavior, generated agent
starter, template, live architecture/contract promotion, and bounded QA checks.
The live queue contains the first orientation papercut from this batch.

## Next Task

Run one consumer-repo proof and triage its first papercut entries.
