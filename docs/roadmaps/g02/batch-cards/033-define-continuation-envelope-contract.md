# 033 - Define Continuation Envelope Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/010-continuation-envelope-and-stop-signal-contract.md
Roadmap refs: g02.007 batch 7.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/010-continuation-envelope-and-stop-signal-contract.md
Auto-start next card: yes, if the implementation batch is explicit

## Objective

Define the compact continuation-envelope and stop-signal contract for longer
autonomous execution chains.

## Scope

- define what continuation actually means beyond a simple next-card flag
- define which stop signals override continuation immediately
- leave the implementation batch explicit and ready

## Steps

1. Define the continuation-envelope contract in the live spec.
2. Define the stop-signal rules that break continuation.
3. Leave the implementation batch explicit and ready.

## Acceptance Criteria

- the continuation-envelope contract is explicit
- stop-signal behavior is explicit
- the implementation batch is ready

## Evidence Required

- updated master spec
- definition batch log

## Stop Conditions

- the definition drifts into scheduler or workflow-engine design

## Completion Notes

Defined continuation as a bounded ready chain with explicit transition proof
and explicit stop signals. The next batch should apply that compact contract to
the reusable surfaces rather than adding a new control subsystem.

## Next Task

Start `g02.007` batch `7.2` by applying the continuation-envelope and
stop-signal contract to the working rules, templates, and handoff/planning
surfaces.
