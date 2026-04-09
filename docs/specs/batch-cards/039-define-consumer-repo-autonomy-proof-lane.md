# 039 - Define Consumer-Repo Autonomy Proof Lane

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md
Roadmap refs: g02.009 batch 9.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md
Auto-start next card: yes, if the proof batch is explicit

## Objective

Define the consumer-repo proof lane for the combined autonomy model.

## Scope

- define what qualifies as a valid consumer-repo proof target
- define the evidence the proof must capture
- leave the external-proof batch explicit and ready

## Steps

1. Define the proof lane and evidence contract in the live spec.
2. Define what counts as a valid active target repo/lane.
3. Leave the external-proof batch explicit and ready.

## Acceptance Criteria

- the consumer-repo proof lane is explicit
- the external-proof batch is ready

## Evidence Required

- updated master spec
- definition batch log

## Stop Conditions

- the definition drifts into another internal-only doctrine loop

## Completion Notes

Defined the external-proof lane and constrained it to active consumer repos
with real live Northstar lanes. The next step is to run the model against a
real external lane rather than refine it further in isolation.

## Next Task

Start `g02.009` batch `9.2` by running the combined autonomy model against a
real active consumer-repo lane and recording what still breaks outside
Northstar itself.
