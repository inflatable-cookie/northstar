# 072 - Dogfood Orchestrator Worker PR Loop

Status: ready
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `skills/northstar/references/modes/orchestrator.md`, `g02.025`
Auto-start next card: no

## Ready-State Checks

- [x] Objective is bounded enough to finish without fresh planning decisions.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope boundaries and stop conditions are explicit.
- [x] Acceptance, validation, and evidence requirements are explicit.
- [x] No unresolved planning gap governs the dogfood shape.
- [x] No unresolved intent checkpoint governs the dogfood shape.
- [x] Auto-start is disabled because a fresh worker/operator decision is required.

## Objective

Run one low-risk Northstar lane through the orchestrator mode, a fresh worker
thread in a dedicated worktree, an operator-relayed chunk report, a reviewable PR,
and orchestrator closeout.

## Lane Runway Context

- Higher-level lane owner: prove the new execution boundary before adding adapters
- Next likely transition: choose adapter/default packet persistence from evidence
- Next planning checkpoint: after the first PR review cycle

## Scope

- prepare and publish `main` with the planning artifacts;
- create one mandatory run file and commit/push it on `main`;
- create a fresh worker thread in a dedicated worktree from pushed `main`;
- give the worker only the repository-relative run-file path;
- exercise approval or requested-changes review
- measure elapsed time, rework, review cycles, validation, and relay burden
- do not add automatic cross-session messaging or CI workflows

## Steps

1. Select a low-risk ready card and record why it is suitable.
2. Start the orchestrator mode and complete the question/plan/base checks.
3. Commit and push the planning artifacts to `main`.
4. Create the single run file, commit and push it to `main`, and verify local
   `HEAD` equals `origin/main`.
5. Create the worker branch/worktree from pushed `main` and give the new worker
   thread only the repository-relative run-file path.
6. Relay at least one worker chunk report; reconcile card/log state.
7. Receive the PR URL; review diff, checks, and canonical-plan fit.
8. Request changes or approve/merge with explicit operator authorisation.
9. Close the card, milestone, log, and front-door next-task state.
10. Record measured friction and adapter observations.

## Acceptance Criteria

- planning and roadmap artifacts are committed and pushed to `main` before dispatch
- the run file is committed and pushed to `main` before dispatch
- worker reads the run file from its repository-relative path without any other
  prompt, transcript copy, or manually copied refs
- worker never edits the planning checkout
- at least one bounded chunk is reported with real validation evidence
- worker opens a PR against the prepared base
- orchestrator review records an evidence-backed verdict
- requested-changes loop or clean approval path is exercised
- closeout surfaces remain coherent and the next task is explicit

## Evidence Required

- single run-file path
- pushed main commit and remote verification
- worktree and branch refs
- worker report(s)
- PR URL and review verdict
- validation output
- batch log with measurements and unresolved friction

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none
- Remaining ready chain after this card: 0
- Transition proof required before auto-start: dogfood analysis and operator decision

## Lane Budget

- Current card ends budgeted run: yes
- Further operator decision required after this card: yes
- Pause signal if run stops here: handoff-required

## Stop Conditions

- stop if the chosen lane reveals missing contracts or architecture
- stop if the worker needs a material design choice not in the cards
- stop if base/worktree/branch isolation fails
- stop if the PR cannot be reviewed against canonical refs
- stop if merge authority is not explicit

## Next Task

After closeout, decide whether to add a provider adapter, revise packet placement,
or keep the manual operator-mediated path as the default.
