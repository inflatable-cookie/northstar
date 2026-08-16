# 026 - Orchestrator Thread And Worker PR Loop

Status: active
Owner: repo maintainers
Created: 2026-08-16
Updated: 2026-08-16
Related research: `bundle-docs/research/translation-memos/northstar-orchestrator-thread.md`
Governing architecture: `docs/architecture/system-architecture.md`
Governing contract: `docs/contracts/001-working-rules.md`

## Problem

Northstar can plan a strict runway and can continue through ready cards, but it
does not yet define the most useful split for current coding agents:

- a conversational orchestrator thread that asks questions, explores edges,
  settles intent, maintains the planning runway, and reviews delivery;
- a fresh worker thread that receives a durable file-based brief, works in its
  own worktree, reports bounded chunks through the operator, and creates a PR;
- an explicit review loop that ends in approval/merge or precise requested
  changes.

## Target operating model

The operator starts or resumes one Northstar `orchestrator` mode in the planning
checkout. The orchestrator owns discovery, planning, architecture/contracts,
roadmap readiness, launch preparation, and PR review. It does not implement the
feature in the planning checkout once the worker boundary is declared.

The operator creates a fresh worker thread in a dedicated worktree from the
pushed `main` commit. The orchestrator has already committed and pushed the
planning artifacts and one concrete run file. The worker receives only the
repository-relative path to that file; the file contains the complete worker
instructions and canonical references. The worker owns only the ready cards
named in that file. It can execute several bounded cards in one thread, reports
after each meaningful chunk, updates execution evidence, and stops whenever the
contract says planning or operator intent is required. When the assigned runway
is complete, it opens a PR against the prepared base and returns the URL plus
evidence.

The operator relays worker reports and the PR URL to the orchestrator. The
orchestrator reviews the exact diff and checks against the canonical refs, then
returns one of: approve/merge when explicitly authorised, request changes with
line-specific or card-specific comments, or pause with a named planning gap.

## Goals

- Keep exploratory conversation and implementation context separate.
- Make the worker handoff a single committed, pushed, self-contained file path.
- Reuse existing Northstar specs, roadmaps, batch cards, logs, and handoff rules.
- Make worktree, branch, PR, review, stop, and merge boundaries explicit.
- Route model effort by role and risk without hard-coding provider model IDs.
- Preserve a provider-neutral protocol while allowing Codex, Claude Code, or
  OpenCode adapters.

## Non-goals

- automatic cross-session messaging;
- a second public Northstar skill;
- parallel write-heavy workers in one active lane;
- automatic merge without a review/check gate and operator authorisation;
- replacing Effigy, Git, or the hosting provider's PR system;
- a universal provider-specific command wrapper.

## Roles and authority

| Role | Owns | Must not assume |
| --- | --- | --- |
| Operator | answers unresolved questions, starts the worker thread, relays reports/PR URLs, grants merge authority | that one thread can see another thread's private history |
| Orchestrator | discovery, intent summary, promoted planning, ready runway, single-file handoff, PR review verdict, closeout | that a worker's narrative substitutes for diff/check evidence |
| Worker | implementation in its worktree, bounded card execution, tests, commits, evidence, PR creation | new architecture, missing contracts, or scope expansion |

## State model

Use these states in the single run file or log when the run spans turns:

- `discovery` — questions and edge cases are still being surfaced;
- `planning` — spec/architecture/contracts/roadmap are being aligned;
- `ready-to-launch` — base and cards are ready; the single run-file path can be
  handed to a worker;
- `worker-in-flight` — worker is executing the assigned runway;
- `awaiting-review` — worker has opened a PR and returned evidence;
- `changes-requested` — orchestrator review found required fixes;
- `merged` — PR is merged and Northstar closeout is complete;
- `paused` — a named stop condition, planning gap, or operator decision blocks work.

## Dispatch protocol

The orchestrator/worker boundary is a strict sequence:

1. finish discovery and promote the spec, architecture, contract, and ready cards;
2. put the planning checkout on `main` and remove unrelated changes;
3. run required QA;
4. commit all planning and roadmap artifacts to `main`;
5. create one concrete run file from the packet template under
   `docs/logs/YYYY-MM/`;
6. commit that run file to `main`, push `main`, and verify local `HEAD` equals
   `origin/main`;
7. create the worker branch/worktree from that pushed commit;
8. give the worker thread only the repository-relative run-file path.

The worker must not require a separately copied prompt, transcript, or list of
canonical refs. The run file may point at canonical repository files, but it is
the only external handoff artifact.

## Required single-file handoff

The orchestrator must create one concrete run file from
`skills/northstar/assets/templates/northstar-orchestrator-run.md.template` before
the worker starts. It must be committed to `main`, pushed, and verified against
`origin/main`. The worker receives only its repository-relative path.

The file must contain or point to all information required for execution:

- target repository, pushed base commit, worker branch, and worktree command;
- active vision/architecture/contract refs;
- active master spec and roadmap milestone;
- ordered ready batch cards and allowed runway length;
- acceptance, validation, evidence, and stop conditions;
- worker model capability profile and tool restrictions;
- chunk-reporting cadence and operator relay rule;
- PR base/head requirements and expected PR body contents;
- explicit out-of-scope boundaries.

## Worker protocol

1. Read the supplied repository-relative run-file path first. Verify the
   worktree, branch, pushed base ref, clean starting state, and loaded repo
   instructions before editing.
2. Read the active milestone, every assigned card, and governing refs.
3. Run the repo's cheap orientation and relevant graph/query commands before code
   changes.
4. Execute only ready cards in the stated order. Keep commits and reports aligned
   to meaningful chunks, not arbitrary model turns.
5. After each chunk, report changed surfaces, validation, remaining cards, and
   blockers for the operator to relay. Do not require live agent-to-agent access.
6. Stop on a planning gap, contract contradiction, unresolved product choice,
   failed validation that changes the plan, missing authority/access, or scope
   expansion. Record the stop in the card/log state.
7. When the assigned runway is complete, run the required final checks, update
   evidence and closeout surfaces, push the branch, and create a PR. Do not merge.

## Review protocol

The orchestrator must review from the PR and canonical refs, not only from the
worker's report:

1. inspect PR metadata, commits, changed files, and checks;
2. compare implementation to the active spec, milestone, cards, and contracts;
3. check that out-of-scope files, hidden planning decisions, and missing tests are
   not smuggled into the diff;
4. run or inspect the relevant validation independently where practical;
5. leave specific comments or return an approval verdict;
6. merge only when checks and review are satisfactory and the operator has
   authorised the merge action;
7. after merge, update roadmap/card/log/currentness surfaces and identify the next
   planning or execution move.

If changes are requested, the operator relays the review to the same worker
branch/thread. The worker fixes only the requested scope, pushes again, and the
orchestrator repeats the review. A new worker thread is not required unless the
original worktree or branch is no longer usable.

## Model and runtime policy

Model IDs are runtime configuration, not Northstar contract values. Select by
capability:

- frontier/high effort for the orchestrator and material review;
- capable/medium effort for bounded implementation;
- fast/low effort for read-only reconnaissance and log reduction;
- raise effort or escalate when a card touches security, persistence,
  concurrency, public APIs, deployment, or multiple plausible designs.

Use deterministic Effigy, Git, test, diff, and PR-check commands for evidence.
Provider-native subagents, worktree managers, JSON output, resume, and PR helpers
are adapters that may improve ergonomics but must not change the protocol.

## Validation strategy

The initial Northstar dogfood must prove:

- the single run-file path can be handed to a fresh thread without private chat
  context;
- the worker remains in the dedicated worktree and branch;
- the worker completes at least one bounded card and reports evidence;
- the worker opens a reviewable PR against the prepared base;
- the orchestrator can find at least one real issue or explicitly record a clean
  review;
- the requested-changes loop or approval path is exercised;
- roadmap, card, log, and next-task surfaces remain coherent after closeout.

Record elapsed time, worker rework, number of review cycles, validation outcome,
and operator relay burden. Do not generalise from one run without this evidence.

## Open questions

- Which worker CLI should be the default local adapter for the first dogfood?
- What is the minimum provider-neutral PR metadata contract for non-GitHub hosts?
- Which merge permissions should be required in consumer repositories?

These questions do not block the protocol shape; they block only adapter and
rollout defaults.

## Promotion notes

Durable role and boundary rules are promoted into the live architecture and
working-rules contract. This spec remains active until the dogfood evidence
settles the run-file placement, adapter defaults, and review-cycle ergonomics.

## Next task

Dogfood one low-risk lane with a fresh worker thread, one dedicated worktree, and
one reviewable PR. Capture the result in a batch log before adding automation.
