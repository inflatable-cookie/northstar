# 044 - Remove Global Capacity Gating

Status: complete
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.042`, `g02.043`
Vision tags: `orchestration`, `parallelism`, `paseo`, `provider-routing`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Planning state: card 112 merged through PR 17 at `e5e8060`; skill installed and
active orchestrators notified

## Problem

Northstar currently tells an orchestrator to treat the first explicit launch
refusal as a global capacity answer, queue the remaining frontier, and wait for
a worker to finish before retrying. Paseo has no global thread-count limit.
Provider or profile spend, quota, rate, and availability failures are route-local
conditions. The current wording therefore turns one unavailable provider route
into false global serialization and has caused unrelated ready work to stop.

## Goals

- launch every safe ready lane without a global worker-slot budget;
- keep provider/model/profile availability failures local to the affected lane;
- try another configured profile that fits the same role and capability;
- pause only the affected lane when no suitable route remains;
- preserve workspace and agent identities after ambiguous transport failures so
  retries do not duplicate workers;
- continue unrelated planning, dispatch, review, and closeout work;
- keep real dependency, shared-surface, and authority edges serial.

## Non-goals

- no Paseo product or profile mutation;
- no fixed provider, model, profile, price, quota, or thread-count table;
- no silent promotion from an ordinary worker to a frontier worker;
- no automatic replacement or migration of an already-running agent;
- no weakening of worktree, handoff, review, merge, or same-repo ordering rules.

## Execution Plan

Card `g02.044/112` owns one bounded propagation lane across live protocol,
doctrine, skill, copy-ready contracts, operator guidance, deterministic checks,
distribution parity, and closeout. Spec 026 contains the settled meaning. The
worker does not choose scheduler policy or local profile names.

## Acceptance Criteria

- no reusable surface treats a provider/profile refusal as global capacity;
- every safe ready lane is attempted without waiting for another worker to end;
- a matching alternative route is tried without changing worker class;
- no-fit provider state pauses only the affected lane and leaves its handoff and
  workspace reusable;
- ambiguous workspace/agent creation preserves returned identities and avoids a
  duplicate retry while unrelated unambiguous launches continue;
- dependency, shared-surface, authority, and same-repo merge edges stay serial;
- manual dispatch publishes every ready handoff path together;
- source/install parity and repository QA pass.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| No global slots. | Two independent safe lanes are ready and no adapter limit is declared. | Launch both; do not queue one or wait for a finish event. | Positive dispatch scenario and old-wording negative check. |
| Provider failure is route-local. | Lane A hits a monthly spend limit while lane B uses an unrelated available route. | Pause or reroute A and still launch B. | Provider-refusal scenario. |
| Alternatives preserve role. | A day-to-day route is unavailable but another day-to-day profile fits. | Retry through the matching alternative; do not promote frontier. | Alternative-profile scenario. |
| No fit pauses one lane. | A lane has no suitable available profile. | Preserve its handoff/workspace, report the gap, and continue unrelated lanes. | No-fit scenario. |
| Ambiguous creation does not duplicate. | Workspace or agent creation returns an identity and then reports an ambiguous failure. | Retain the identity, stop retrying that lane, and continue clear lanes. | Identity-preservation scenario. |
| Real serial edges remain. | Lane B consumes lane A's harness evidence or both own one front door. | Keep only that edge serial and name it. | Dependency/shared-surface scenario. |
| Merge ordering is unchanged. | Two same-repo PRs finish together. | Merge one, refresh the other, and re-review a changed head. | Same-repo merge-order scenario. |

## Stop Conditions

- implementation requires a change to Paseo or a configured profile;
- correct behavior would silently weaken worker capability or review rigor;
- a transport retry cannot distinguish a new worker from an existing identity;
- the change invents mid-run worker migration;
- validation reveals contradictory source/install behavior.

## Next Task

Continue the passive live-orchestrator dogfood window. Judge the correction
against later provider-limit observations when they arrive; do not manufacture
a recovery run.
