# 071 - Add Worker Packet And PR Contract

Status: complete
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/contracts/001-working-rules.md`, `skills/northstar/assets/templates/northstar-orchestrator-run.md.template`, `g02.025`
Auto-start next card: no

## Objective

Give the orchestrator one compact, durable, committed run file and define the
worker, reporting, PR review, merge, and closeout boundaries.

## Scope

- one committed run-file path is the only external worker handoff
- the worker can re-enter from that path and canonical refs alone
- the worker has an explicit worktree, branch, pushed base, runway, and PR contract
- chunk reporting and stop conditions
- PR evidence and review outcomes
- operator-mediated relay and merge authorisation
- do not choose a default vendor adapter yet

## Acceptance Criteria

- a fresh worker can re-enter from the repository-relative run-file path alone
- the run file is committed on pushed `main` before the worker starts
- the worker has an explicit worktree, branch, pushed base, runway, and PR contract
- the orchestrator reviews the diff/checks rather than trusting narrative
- requested changes can return to the same worker branch
- merge is a separate authorised action

## Evidence Required

- active spec
- working-rules contract update
- packet template
- operator quick-start update
- `effigy qa`
- `effigy qa:docs`

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none until dogfood evidence exists
- Remaining ready chain after this card: 0
- Transition proof required before auto-start: real worker/PR run

## Lane Budget

- Current card ends budgeted run: yes
- Further operator decision required after this card: yes
- Pause signal if run stops here: budget-exhausted

## Stop Conditions

- stop if packet duplication becomes a second planning authority
- stop if PR review or merge semantics cannot be kept provider-neutral

## Completion Notes

Added the single-file worker handoff template and promoted the execution/review
boundaries. The first dogfood remains intentionally separate so the design is
tested before more adapter automation is added.

## Next Task

Dogfood `g02.025/072` with one fresh worker thread and one isolated worktree.
