# 037 - Chatterbox-Led Planning and Mechanical Coordination

Status: active; canonical planning promoted, implementation card 128 ready
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Supersedes: specs 026, 035, and 036 for current planning, promotion,
coordination, review-child placement, and planning-delegate behavior
Governing architecture: `docs/architecture/system-architecture.md`
Governing contracts: `docs/contracts/001-working-rules.md`

## Problem

The economical-coordinator rollout left semantic work in the coordinator path.
Luna compiled exact promotion briefs, launched promotion-only workers, decided
dependency frontiers, and remained active while children ran. Live use spent
roughly twenty minutes in planning recursion before an implementation worker
could start. The promotion worker then stopped fail-closed and the coordinator
was about to start another loop; the operator stopped both.

Operator questions also arrived without enough context, review children created
unnecessary workspaces, and Chatterbox could see but was forbidden to message
the coordinator directly.

## Goal

Make Chatterbox the primary human-facing planning authority and make the
coordinator a mechanical delivery manager.

The normal path is:

`operator <-> Chatterbox -> canonical ready plan + approved frontier -> coordinator dispatches workers -> review children -> coordinator gate/merge`

Optional side planning is:

`operator <-> planning delegate -> unique triage note -> Chatterbox reconciliation/promotion`

There is no normal promotion-worker hop.

## Roles and authority

| Role | Owns | Must not assume |
| --- | --- | --- |
| Operator | material intent, confirmation, priorities, pauses, destructive choices | that a child report or recommendation is confirmed meaning |
| Chatterbox | primary operator conversation, research direction, planning, canonical promotion, triage reconciliation, lane graph, approved parallel frontier, direction to coordinator | product/runtime implementation, worker supervision, PR acceptance, merge |
| Planning delegate | one optional parallel operator conversation, bounded read-only research, unique triage capture, notice to Chatterbox | canonical edits, promotion, coordinator direction, implementation, review, merge |
| Coordinator | factual prerequisite checks, worker/reviewer dispatch, identity/state tracking, revision routing, merge gate, merge, closeout, contextual operator relay | product meaning, canonical promotion, lane design, dependency edges, parallel groups, substantive review |
| Worker | implementation inside a ready card and isolated workspace, validation, evidence, commits, PR | planning or scope expansion |
| Review child | independent exact-head review and provider verdict | branch mutation, implementation, merge, acceptance of a later head |

## Chatterbox planning and promotion

Chatterbox owns material discovery and planning with the operator. It may run
bounded read-only research subagents and reconcile delegate or external triage.
After explicit operator confirmation, it directly updates canonical planning on
the integration branch: architecture, contracts, specs, roadmaps, ready cards,
dispatch manifest, indexes, and triage dispositions.

It validates and reviews the complete semantic diff, commits, pushes, then sends
the coordinator a provenance-labelled direction naming the promoted commit and
approved ready frontier. It does not launch a promotion worker or implement
runtime/product changes.

Independent planning review is exceptional: use it only on operator request or
when Chatterbox names material residual planning risk. It must not become a
routine second promotion lane.

## Triage and planning delegates

Chatterbox owns triage disposition. Raw triage is never coordinator execution
authority.

An operator may start a lightweight planning delegate for one issue in parallel.
In Paseo it is a visible agent tab in the current project workspace, not a new
worktree workspace. It writes only unique timestamped triage files using the
existing exact-path Git isolation. It may use bounded read-only research
subagents, but it does not open a planning PR or contact the coordinator.

The note separates evidence, alternatives, operator-confirmed statements,
recommendations, constraints, non-goals, and unresolved questions. It need not
contain a full destination map or execution packet. When ready, the delegate
sends Chatterbox the absolute path and summary; manual operator relay is the
fallback. Chatterbox reconciles the note against current authority and promotes,
retains, splits, or removes it.

## Dispatch manifest and parallelism

Chatterbox publishes lane design in canonical planning. Every dispatchable lane
names:

- card/outcome and readiness state;
- prerequisites and completion conditions;
- owned mutable paths and reserved shared closeout surfaces;
- approved concurrent siblings and explicit serial edges;
- worker capability class;
- acceptance evidence and review oracle;
- stop conditions and escalation owner.

Chatterbox names the approved current frontier. The coordinator verifies only
current facts: promoted commit, prerequisite completion, workspace/branch/path
collisions, transport/profile availability, repository gates, and operator
pauses. It launches every approved ready lane; it neither selects a convenient
subset nor invents extra concurrency.

Worker-profile selection is role-first. A profile qualifies only when its live
description explicitly fits implementation or general day-to-day work at the
capability named by the manifest. Audit, documentation-grind, review, planning,
and coordinator profiles do not qualify for implementation lanes merely because
the lane is large, documentation-heavy, or expected to consume many tokens.
Among role-adequate profiles, the coordinator prefers the cheapest fast option
that meets the named capability.

Unexpected factual conflicts pause only affected lanes and return to Chatterbox
through a context-complete escalation. Downstream launch evaluates published
boolean prerequisites. Missing or ambiguous dependency design is planning and
returns to Chatterbox.

## Coordinator direction channel

Chatterbox may discover the named coordinator and send it one background,
provenance-labelled message:

- **operator-confirmed direction** changes planning, priority, pause, reroute,
  or accepted escalation state;
- **Chatterbox recommendation** is unconfirmed intake and cannot change active
  work;
- **administrative notice** carries a note, commit, supersession, or routing
  fact.

The coordinator reconciles confirmed direction with current state without
asking the operator to repeat it. Chatterbox does not dispatch, cancel, resume,
review, or merge children itself. It inspects coordinator state once to avoid an
obvious duplicate, sends once, reports delivery, and does not poll.

When no unambiguous coordinator or background messaging route exists,
Chatterbox gives the operator a complete manual-relay message and absolute path.

## Coordinator fast path and turn lifecycle

Canonical ready cards and the approved frontier are the coordinator's dispatch
authority. It loads only the instructions, promoted commit, selected cards,
manifest, and named refs needed for factual preflight. It does not sweep
unrelated planning or compile a duplicate semantic handoff.

Normal ready-lane target: less than two minutes from receipt to child creation
when no conflict or transport failure exists. This is a dogfood diagnostic, not
a hard provider timeout.

Coordinator turns are event-bounded. An operator message or child notification
starts a turn. The coordinator performs every immediately available dispatch,
revision, review, merge-gate, or closeout action, reports identities/state, then
yields. It never polls, calls a wait primitive, holds a turn open for a child, or
rescans unchanged state to appear busy. `notifyOnFinish: true` starts the next
turn.

## Review children

Review remains independent but uses the existing worker workspace. The
coordinator creates a child reviewer with the worker `workspaceId`, preserving
coordinator parentage, a visible agent tab, and `notifyOnFinish: true`. It does
not create a review-only workspace.

The worker and reviewer hold a serial workspace lease. Before review, the
worker is idle, workspace `HEAD` equals the PR head, and index/tracked worktree
are clean. The reviewer may inspect and run checks but cannot edit tracked files,
commit, push, or change branches. It posts a provider verdict naming the exact
head and finishes. The coordinator verifies the same clean exact-head state
before returning the lease to the worker for revisions.

Wrong head, dirty state, concurrent access, missing parentage/notification, or a
need for branch mutation stops review. Do not fall back to a coordinator or new
review workspace.

## Context-complete operator escalations

The agent that discovers an operator-owned blocker supplies a capsule containing:

1. plain-language headline;
2. lane, PR, exact head, and lifecycle state;
3. observed versus intended behavior;
4. why operator authority is required;
5. practical impact;
6. concrete options and consequences;
7. recommendation when evidence supports one;
8. one exact question;
9. paused state and next action;
10. supporting links after the explanation.

The coordinator verifies current identities/state and relays the capsule. An
operator must be able to understand and answer without opening a blocker log,
PR thread, or file. Missing or opaque capsules return to the discovering child;
Luna does not reconstruct their semantics.

## Non-goals

- no promotion-only worker in the normal path;
- no Chatterbox runtime/product implementation, PR acceptance, or merge;
- no planning-delegate canonical edits, worktree/PR, or coordinator direction;
- no coordinator lane design, semantic promotion, or substantive PR review;
- no review-only workspace;
- no polling or idle open coordinator turn;
- no raw triage execution authority;
- no provider/profile names in reusable policy;
- no weakening of exact-head review, checks, mergeability, or operator pauses.

## Review oracle

| Invariant | Counterexample | Expected response | Proof |
| --- | --- | --- | --- |
| Chatterbox promotes planning. | Coordinator launches a promotion child from confirmed triage. | Stop; Chatterbox promotes directly, then sends actual-worker frontier. | Route scenario and exact diff. |
| Delegate stays lightweight. | Delegate edits a spec or opens a planning PR. | Stop before mutation; emit unique triage only. | Git-isolation fixture. |
| Parallelism is planned. | Luna invents an edge or chooses only one of two approved lanes. | Launch the full verified frontier or return factual conflict. | Dependency fixture. |
| Direction keeps provenance. | Recommendation changes active scope as operator authority. | Record intake; require confirmation. | Message-class fixture. |
| Coordinator yields. | It polls or waits after child creation. | Report identities and end the turn. | Lifecycle trace. |
| Review reuses worker workspace safely. | New review workspace or concurrent worker/reviewer access. | Stop; enforce serial lease in existing workspace. | Paseo launch and Git-state fixture. |
| Questions carry context. | Operator receives only a finding ID and log path. | Return capsule for clarification. | Blind-reader scenario. |
| Merge gate stays exact. | Accepted verdict names an old head. | Re-review current head. | Exact-head scenario. |

## Acceptance criteria

- [ ] reusable doctrine, template contracts, architecture, inventory, router,
      Chatterbox, orchestrator, delegate, and PR-review modes implement this role
      split;
- [ ] Chatterbox can promote confirmed planning directly and notify the named
      coordinator without gaining worker/review/merge authority;
- [ ] planning delegates are same-workspace triage-only conversations;
- [ ] coordinator consumes an approved frontier and cannot design it;
- [ ] no promotion-only worker or duplicate promotion handoff remains;
- [ ] coordinator launches actual workers promptly, reports, and yields;
- [ ] review children appear in worker workspaces with serial clean-head leases;
- [ ] every operator escalation is self-contained;
- [ ] card 126 records dispatch latency, time-to-actual-worker, polling, context,
      scheduling, and workspace evidence;
- [ ] source/install parity, docs QA, full QA, and exact-head review pass.

## Stop conditions

- a required planning or authority decision remains unresolved;
- current canonical surfaces contradict the approved frontier;
- the migration would weaken review or merge safety;
- Paseo cannot preserve reviewer parentage in the worker workspace;
- direct Chatterbox messaging cannot distinguish confirmed direction from
  recommendation;
- validation changes this plan.

## Next task

Execute card 128. Update every runtime/doctrine/template/check caller together,
remove superseded promotion and planning-delegate worktree paths, validate the
complete batch, and open one implementation PR.
