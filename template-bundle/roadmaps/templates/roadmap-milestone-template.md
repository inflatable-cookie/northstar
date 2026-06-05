# <NNN> - <Milestone Title>

**Type: TEMPLATE** -- Copy and fill in for each roadmap milestone.

Status: draft
Owner: <owner>
Created: YYYY-MM-DD
Depends on: <gNN.NNN or none>
Vision tags: `<TAG1>`, `<TAG2>`
Contract refs: `<001-contract>`, `<002-contract>`
Planning state: <ready/blocked on planning>

Writing style: internal, compressed, glue-light. Keep milestone prose dense
and operational.

## Problem

Describe the specific short-term problem this milestone solves.

## Goals

- [ ] <goal 1>
- [ ] <goal 2>

## Non-Goals

- [ ] <non-goal 1>

## Contract Coverage

- [ ] Every execution-relevant behavior in this milestone is covered by an
      explicit contract.
- [ ] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [ ] Required research translation memos are linked where relevant.

## Execution Readiness

- [ ] Every batch intended for immediate execution has bounded scope and
      current governing refs.
- [ ] Every batch intended to be `ready` defines acceptance criteria,
      validation, evidence requirements, and stop conditions.
- [ ] Auto-continuation is allowed only where the next card is already defined
      and ready or the transition condition is explicit.
- [ ] The milestone leaves a visible runway beyond the immediate card: the
      higher-level lane owner, the next few meaningful batches or transitions,
      and the next planning checkpoint.

## Execution Plan

Roadmap batches are **broad execution chunks**, not agent-turn scratchpads.
Name at least two or three batches for non-trivial milestones. In strict
posture, most batches map to one or more batch cards; put step-by-step detail
in those cards, not here.

Use checkbox lines for every batch-level task. Tick them off during closeout.

### Batch <n.1> - <batch title>

- [ ] <executable task>
- [ ] <executable task>

### Batch <n.2> - <batch title>

- [ ] <executable task>
- [ ] <executable task>

## Acceptance Criteria

- [ ] <criterion 1>
- [ ] <criterion 2>

## Risks and Mitigations

- Risk: <risk>
- Mitigation: <mitigation>

## Planning Gaps

- <gap or `none`>

## Evidence Requirements

- [ ] <log or artifact for batch closure>
- [ ] <log cadence: one log per completed batch/update cycle>
- [ ] <manual validation checks and commands actually run>
- [ ] <if new checker script is proposed, record owner + cadence + sunset trigger>

## Runway Notes

- Higher-level lane owner: <owner>
- Immediate ready card or paused gate: <ref>
- Next likely batches or milestone transitions: <refs or none>
- Next planning checkpoint: <checkpoint or none>

## Next Task

State the next batch or dependent milestone unlocked by this file, or the next
planning artifact needed before execution can resume.
