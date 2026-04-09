# 013 - Define Strict-Compliance Audit And Rollout Surface

Status: active
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.012
Vision tags: `migration`, `audit`, `rollout`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/016-strict-compliance-audit-and-rollout.md`
Planning state: ready

## Problem

Northstar now defines the path to full strict compliance, but it still needs a
compact operational surface for auditing real projects and tracking rollout
toward that state.

## Goals

- [x] define the strict-compliance audit and rollout surface
- [ ] apply the audit and rollout guidance to Northstar surfaces
- [ ] re-prove the audit and rollout surface

## Non-Goals

- [ ] migrating any one consumer repo inside this lane
- [ ] replacing project-local planning with a central control board

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 13.1 - Define Strict-Compliance Audit Surface

- [x] define the audit surface
- [x] define the rollout surface
- [x] leave the application batch explicit and ready

### Batch 13.2 - Apply Audit And Rollout Guidance

- [x] apply the audit and rollout guidance to doctrine, setup, and template
      surfaces
- [x] refresh currentness/check surfaces affected by those changes
- [x] leave the re-proof batch explicit and ready

### Batch 13.3 - Reprove Audit And Rollout Surface

- [ ] re-prove the audit and rollout path after the guidance update
- [ ] open another slice only if a bounded problem remains

## Acceptance Criteria

- [x] The strict-compliance audit and rollout surface is explicit.
- [x] The audit and rollout guidance is materially reflected in Northstar.
- [ ] The strict-compliance audit and rollout surface is re-proved.

## Planning Gaps

- none

## Evidence Requirements

- [x] definition log for the audit and rollout surface
- [x] consolidation log for the audit and rollout guidance
- [ ] re-proof log for the audit and rollout surface

## Next Task

Start `g02.013` batch `13.3` by re-proving the strict-compliance audit and
rollout surface after the guidance update.
