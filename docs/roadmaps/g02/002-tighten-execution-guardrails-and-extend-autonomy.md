# 002 - Tighten Execution Guardrails And Extend Autonomy

Status: complete
Owner: repo maintainers
Created: 2026-04-09
Depends on: g02.001
Vision tags: `guardrails`, `autonomy`, `delivery`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md`
Planning state: ready

## Problem

Northstar's first external pilot improved the operator front door, but it also
confirmed the larger problem remains: execution still needs stronger guardrails
against fake completion, unnecessary complexity, and shallow follow-through if
agents are going to run longer with less operator babysitting.

## Goals

- [x] define an explicit execution guardrail pack
- [x] promote those guardrails into the reusable bundle and skill surfaces
- [ ] make regular spec hygiene explicit so `docs/specs/` stays focused on
      active planning
- [ ] run another longer autonomy lane under the tightened rules

## Non-Goals

- [ ] opening `g03` just because the first `g02` milestone closed
- [ ] adding more public skills instead of tightening the current ones

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 2.1 - Define Guardrails And Correct Generation Posture

- [x] define the execution guardrail pack in doctrine and the live working rules
- [x] codify long-lived generation posture in roadmap doctrine and templates
- [x] keep `g02` open and open the next milestone inside the same generation

### Batch 2.2 - Promote Guardrails Into Bundle And Skills

- [x] update the template bundle surfaces that should carry the guardrail pack
- [x] align the installed Northstar skill wording with the new posture
- [x] keep the operator front door short while moving the real rules into
      canonical bundle and skill surfaces

### Batch 2.3 - Make Spec Hygiene Explicit

- [x] make regular spec hygiene explicit in the doctrine, bundle, and live
      planning lane
- [x] define how specs should be archived or removed as lanes close
- [x] leave one explicit next batch for the longer autonomy run

### Batch 2.4 - Run A Longer Autonomy Lane

- [x] run a longer live Northstar lane under the tightened guardrails
- [x] capture where autonomy still drifts or stops too early
- [x] compile the next improvement slice from that evidence

## Acceptance Criteria

- [x] The execution guardrail pack is explicit in doctrine and the live working rules.
- [x] The reusable bundle and installed skills inherit the new guardrails.
- [x] Regular spec hygiene is explicit in the protocol and live lane.
- [x] Another longer autonomy lane is run and logged.
- [x] `g02` remains the active generation throughout this milestone.

## Risks and Mitigations

- Risk: the work becomes abstract doctrine again.
- Mitigation: make bundle, skill, and pilot promotion explicit milestone batches.

- Risk: `g02` still behaves like a short-lived bucket in practice.
- Mitigation: open the next lane immediately inside `g02` and codify the
  generation posture in doctrine and templates.

## Planning Gaps

- none

## Evidence Requirements

- [x] doctrine and live working-rules updates for batch 2.1
- [x] batch-level logs for bundle and skill promotion
- [x] batch-level logs for the spec-hygiene protocol update
- [x] batch-level logs for the longer autonomy lane
- [x] validation commands actually run after each meaningful batch

## Next Task

Decide the next `g02` improvement slice from the autonomy findings now that
this milestone is complete.
