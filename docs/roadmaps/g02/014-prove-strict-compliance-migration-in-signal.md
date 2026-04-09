# 014 - Prove Strict-Compliance Migration In Signal

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.013
Vision tags: `migration`, `signal`, `strict-compliance`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/017-signal-strict-compliance-migration-proof.md`
Planning state: ready

## Problem

Northstar's strict-compliance audit and rollout model is now defined, but it
still needs one real consumer-repo proof lane showing how a mature baseline
repo should be classified and advanced toward full strict compliance.

## Goals

- [x] capture Signal's current migration posture cleanly
- [ ] compile the first Signal strict-compliance migration tranche
- [ ] apply the proof findings to the correct next ownership surface

## Non-Goals

- [ ] migrating the whole Signal repo from inside this Northstar lane
- [ ] widening the doctrine again before the first consumer-proof tranche is
      planned

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 14.1 - Define Signal Migration Proof Lane

- [x] capture Signal's current posture and blocking gaps
- [x] define the next migration tranche
- [x] leave the tranche-planning batch explicit and ready

### Batch 14.2 - Compile Signal Migration Tranche Plan

- [x] define the first bounded lane-first stricter-adoption pack for Signal
- [x] keep the tranche scoped to the active `g09` lane
- [x] leave the application/proof batch explicit and ready

### Batch 14.3 - Apply Signal Migration Proof Findings

- [x] decide whether the next move belongs in Northstar, Signal, or both
- [x] open only the warranted next lane

## Acceptance Criteria

- [x] Signal's current migration posture is explicit.
- [x] The first Signal migration tranche is explicit.
- [x] The next ownership move after the proof is explicit.

## Planning Gaps

- none

## Evidence Requirements

- [x] re-proof log capturing the consumer-repo classification result
- [x] tranche-planning log for the first Signal migration pack
- [x] application log for the proof findings

## Next Task

Open a Signal-owned migration lane that installs the first strict tranche
around the active `g09` queue.
