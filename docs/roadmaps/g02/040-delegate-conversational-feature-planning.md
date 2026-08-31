# 040 - Delegate Conversational Feature Planning

Status: complete
Owner: repo maintainers
Created: 2026-08-31
Depends on: `g02.039`, `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Vision tags: `orchestration`, `planning`, `conversation`, `paseo`
Governing refs: `docs/contracts/001-working-rules.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`skills/northstar/references/modes/orchestrator.md`
Planning state: card 108 complete

## Problem

An orchestrator may need a separate operator-facing planning conversation while
continuing unrelated work. The conversation needs isolation and a reviewable
planning packet without handing canonical promotion or implementation authority
to the delegate.

## Goals

- [x] support an operator-requested conversational planning delegate;
- [x] dispatch it from a committed planning-delegate handoff in an isolated
  branch/worktree with explicit triage/research-only write paths;
- [x] permit bounded read-only research subagents without nested orchestration;
- [x] preserve orchestrator ownership of review, merge, promotion, readiness,
  and implementation dispatch;
- [x] project the settled promotion map mechanically only after promotion is
  decided by the orchestrator.

## Non-goals

- no provider, model, Paseo, or local profile dependency;
- no delegate-owned canonical promotion, readiness, implementation, review, or
  merge decisions;
- no implementation worker lane or nested orchestrator from the delegate;
- no inference of live dogfood beyond the supplied evidence.

## Execution plan

Card `g02.040/108` scopes the protocol, handoff template, source/install
surfaces, documentation projection, and validation. Sol reviewed the semantic
source, corrected the cross-protocol boundaries, and accepted the final full QA
and install-parity evidence.

## Acceptance criteria

- [x] planning-delegate metadata and authority split are consistent across the
  named source/install surfaces;
- [x] the delegate receives a committed handoff and writes only named
  triage/research paths;
- [x] bounded research subagents remain read-only and cannot create lanes or
  contact the operator;
- [x] exact-head review, same-delegate follow-up, and check-gated merge are
  explicit, with merge separate from promotion;
- [x] Sol reviews the full diff and completes QA and install parity.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Orchestrator retains authority. | Delegate promotes a decision or dispatches implementation. | Review blocks the lane. | Source/install and handoff inspection. |
| Conversation is isolated. | Delegate edits an unlisted path or shares a worker lane. | Stop before PR. | Worktree, handoff, and diff evidence. |
| Research is bounded. | Research subagent edits, contacts the operator, or starts nested work. | Delegate stops and reports. | Handoff and mode inspection. |
| Merge is not promotion. | Accepted PR is treated as canonical readiness. | Promotion remains pending. | Mode/contract review. |
| Installed skill is faithful. | Source and installed surfaces drift. | Closeout fails. | Exact path-by-path diff. |

## Stop Conditions

- missing or contradictory authority, metadata, path, or profile choice;
- required write outside named triage/research paths;
- delegate or research subagent needs implementation, promotion, review, or
  merge authority;
- source/install mismatch, failed validation, or unverified PR head;
- Sol has not reviewed the full diff.

## Current state

The lane is complete. Canonical policy, template, source skill, installed skill,
doctrine, architecture, contracts, operator, and validation surfaces are
aligned. The later `g02.038/106` lifecycle proof is also complete. No live
planning-delegate or planning PR dogfood was performed in this lane.

## Next task

None. Return to generation planning.
