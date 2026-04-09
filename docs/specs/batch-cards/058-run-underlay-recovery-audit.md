# 058 - Run Underlay Recovery Audit

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md
Roadmap refs: g02.015 batch 15.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md
Auto-start next card: no

## Objective

Audit Underlay’s current planning/currentness posture and recover the live next
lane from evidence.

## Scope

- inspect Underlay front doors, roadmap index, logs, and current consumer
  posture
- classify the active overhaul honestly
- decide whether Underlay needs:
  - front-door planning/currentness repair only
  - or a stricter execution lane as well

## Steps

1. Read Underlay’s active docs front doors and roadmap queue.
2. Compare the declared active queue with the real active cross-repo overhaul.
3. Identify the drift precisely.
4. Recommend or apply the smallest honest recovery batch.

## Acceptance Criteria

- [x] Underlay’s real active posture is explicit
- [x] the repo’s main drift mode is explicit
- [x] the next honest Northstar move for Underlay is explicit

## Evidence Required

- recovery audit log
- updated Northstar roadmap/spec state if the next move is clarified

## Stop Conditions

- the batch starts rewriting Underlay’s whole docs surface before the real
  active posture is frozen

## Next Task

Apply the warranted Underlay recovery batch and refresh its planning/currentness
surfaces so the active overhaul is explicit.
