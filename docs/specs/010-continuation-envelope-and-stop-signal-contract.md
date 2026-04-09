# 010 - Continuation Envelope And Stop-Signal Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.007

## Problem

Northstar now has stronger planning, closeout, currentness, and spec-lifecycle
surfaces, but agents still depend too much on ad hoc operator nudges to keep
working through longer valid chains. The existing `Auto-start next card` flag
helps, yet it does not define a clear continuation envelope: how far the agent
may keep going, what proof each transition requires, and which stop signals
override the default continuation path.

## Target Operating Model

Northstar should make autonomous continuation explicit enough that an agent can
keep moving through a well-defined chain without needing a human to type
`continue` after every card.

That means:

- each active batch card should expose whether it is the end of the permitted
  continuation envelope or part of a bounded ready chain
- continuation should only survive while validation, contract coverage, and
  stop conditions remain satisfied
- logs and handoffs should preserve the remaining continuation envelope instead
  of reducing the state to only the immediate last task

## Goals

- define a compact continuation-envelope contract for live batch-card chains
- define explicit stop-signal rules that override auto-continuation
- align batch-card, log, and handoff surfaces around the same model
- prove that the resulting contract supports longer autonomous lanes without
  adding a heavy orchestration subsystem

## Non-Goals

- building a scheduler or persistent job runner
- removing human control over replans, contract gaps, or design ambiguity
- turning every repo into a fully autonomous agent system

## Artifact Set

- docs/contracts/001-working-rules.md
- template-bundle/specs/templates/batch-card-template.md
- template-bundle/logs/README.md
- skills/northstar-plan/SKILL.md
- skills/northstar-handoff/SKILL.md
- skills/northstar-handoff/references/handoff-contract.md
- docs/roadmaps/g02/007-define-continuation-envelope-and-stop-signal-contract.md

## Continuation Contract

### Envelope

Each ready batch card or short chain should make the continuation envelope
explicit:

- what next card may auto-start
- how many linked cards remain within the already-approved chain
- what proof must pass before each transition is still valid

### Stop Signals

Continuation must stop immediately when any of these occur:

- a validation step or evidence gate fails
- the next card depends on fresh planning or contract judgment
- a new ambiguity changes user-facing behavior or system boundaries
- the active lane no longer matches the canonical promoted refs

### Closeout And Continuation

Closeout should preserve remaining continuation state rather than erase it:

- the completed card should say whether the continuation envelope still holds
- the batch log should state whether another ready card remains in-bounds
- a handoff should carry the remaining continuation envelope only when another
  thread actually needs to continue

## Phased Delivery

### Phase 1

Define the continuation-envelope and stop-signal contract.

### Phase 2

Apply the contract to templates, working rules, and handoff/planning surfaces.

### Phase 3

Re-prove the contract against a longer autonomous lane.

## Acceptance Criteria

- the continuation-envelope contract is explicit in Northstar's live doctrine
- the reusable surfaces reflect the same continuation and stop-signal posture
- the contract is re-proved as sufficient for bounded ready chains without
  weakening stop conditions

## Stop Conditions

- the lane starts inventing a heavy control plane instead of a compact docs
  contract
- the continuation envelope weakens the existing stop conditions around
  planning gaps or failed validation

## Next Task

Start `g02.008` batch `8.2` by applying the lane-budget and pause-signal
contract to the reusable doctrine, template, and handoff/log surfaces.
