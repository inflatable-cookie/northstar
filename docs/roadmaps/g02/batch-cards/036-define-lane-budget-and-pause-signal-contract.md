# 036 - Define Lane Budget And Pause-Signal Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/011-lane-budget-and-pause-signal-contract.md
Roadmap refs: g02.008 batch 8.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/011-lane-budget-and-pause-signal-contract.md
Auto-start next card: yes, if the implementation batch is explicit

## Objective

Define the compact lane-budget and pause-signal contract for longer autonomous
lanes.

## Scope

- define what lane-level autonomy budget should mean in file state
- define a compact pause-signal vocabulary for clean stops
- leave the implementation batch explicit and ready

## Steps

1. Define the lane-budget contract in the live spec.
2. Define the pause-signal categories and their purpose.
3. Leave the implementation batch explicit and ready.

## Acceptance Criteria

- the lane-budget contract is explicit
- pause-signal behavior is explicit
- the implementation batch is ready

## Evidence Required

- updated master spec
- definition batch log

## Stop Conditions

- the definition drifts into operational telemetry or orchestration design

## Completion Notes

Defined lane-level budget as a compact complement to the continuation envelope,
plus a short pause-signal vocabulary for clean stop reporting. The next batch
should apply that model to the reusable surfaces without adding heavy run-state
machinery.

## Next Task

Start `g02.008` batch `8.2` by applying the lane-budget and pause-signal
contract to the reusable doctrine, template, and handoff/log surfaces.
