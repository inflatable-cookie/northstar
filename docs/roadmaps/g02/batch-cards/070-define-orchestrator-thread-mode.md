# 070 - Define Orchestrator Thread Mode

Status: complete
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `g02.025`
Auto-start next card: yes

## Objective

Define the conversational orchestrator role and add it as an internal mode of the
single public `northstar` skill.

## Scope

- promote the role boundary and state model
- add router activation and mode procedure
- keep provider-specific orchestration optional
- do not build automatic cross-session messaging

## Acceptance Criteria

- the mode asks questions before creating execution work
- the mode stops on planning gaps and unresolved intent
- the mode points to canonical files instead of pasting doctrine
- the mode names worker, operator, and orchestrator authority

## Evidence Required

- translation memo
- architecture and contract diffs
- routed mode file
- `effigy qa:docs`

## Continuation Envelope

- Auto-start next card: yes
- In-bounds next card: `g02.025/071`
- Remaining ready chain after this card: 1
- Transition proof required before auto-start: worker handoff contract is defined

## Lane Budget

- Current card ends budgeted run: no
- Further operator decision required after this card: no
- Pause signal if run stops here: none

## Stop Conditions

- stop if a second public skill or provider-specific protocol becomes required
- stop if role authority cannot be expressed in the existing planning spine

## Completion Notes

Added the promoted orchestrator design, skill routing, and mode procedure without
creating a second installable Northstar skill.

## Next Task

Complete `g02.025/071`: add the single-file worker handoff and PR review contract.
