# Roadmap g01.001 Task Closeout

**Type: EXAMPLE** -- Illustrates a completed task log. Remove from your project after reading.

Status: draft
Created: YYYY-MM-DD
Roadmap: g01.001
Task: g01.001 - Foundation setup and first closure loop
Cycle scope: established the baseline task/log workflow and closed the first execution task

## Summary

- Seeded the first task and log artifacts using Northstar templates.
- Confirmed task-level cadence and lean evidence posture.

## Changes

1. Added the first active task under `docs/roadmaps/g01/`.
2. Recorded architecture and vision linkage for traceability.
3. Published the initial task closure log structure.

## Validation Performed

1. Manual checks:
- Verified roadmap references use `gNN.NNN` format.
- Verified log contains `Validation Performed` and `Next Task` sections.

2. Commands executed:
- `rg -n "g01\.001|Validation Performed|Next Task" docs/roadmaps docs/logs`
- Result: pass

3. Automation changes (optional):
- none

## Evidence

- `docs/vision/001-example-project-vision.md`
- `docs/architecture/example-system-architecture.md`
- `docs/roadmaps/g01/001-example-foundation-task.md`

## Risks

- Team may overfit process before enough delivery evidence exists.

## Next Task

Execute the next task with a real product change and publish its closure evidence.
