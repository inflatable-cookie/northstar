# g03.017 — Reject transient handoff backlinks before merge

Owner: repo maintainers
Created: 2026-09-15
Governing refs: contract 001, lifecycle reference, Queue Spec 007
Depends on: `g03.016` complete; Queue task `a1571254-17e5-414c-9bc0-d80146c6288c` done
UI classification: none

## Outcome

A worker PR that leaves a tracked durable Markdown link to its transient
submitted handoff returns to the retained worker before merge. Hook-owned
closeout keeps the same atomic guard as defence in depth but no longer
discovers this routine worker defect first.

## Ready-State Rubric

- [x] Repeated closeout escalations identify one precise timing flaw.
- [x] The transient-handoff rule and exact-link oracle are canonical.
- [x] Queue froze a generic, read-only, reviewed-head event contract.
- [x] Failure routing uses the ordinary retained-worker revision loop.
- [x] Existing closeout atomicity remains unchanged.
- [x] UI classification is `none`.

## Decisions

- Adopt Queue control manifest `paseo.queue.control.v3`, event envelope
  `paseo.queue.event.v2`, and the required `task.pre_merge` event targeted at
  `reviewed_head`. Existing event and result versions remain compatible;
  results stay `paseo.queue.hook-result.v1`.
- Bind Northstar's bounded exact-backlink resolver to the pre-merge event. Run
  it in Queue's retained clean workspace at the accepted exact PR head against
  the instruction artifact pinned to the task.
- Extract the resolver into one import-safe skill module used by pre-merge and
  closeout. The gates must not carry independent parsing or bounds.
- Keep the pre-merge hook read-only. It returns a blocking result naming every
  tracked durable Markdown backlink. Queue returns the same PR and workspace to
  the retained worker through its normal semantic revision path.
- Keep `task.closeout` refusal unchanged as the final atomic publication guard.
- Preserve repositories without the new event binding. Queue's event extension
  is backward-compatible; Northstar's starter and self-hosting manifests adopt
  it when this task lands.
- Do not notify Chatterbox for an ordinary failed gate. Escalate only after the
  semantic revision budget is exhausted or a real planning decision appears.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready; waits on the Queue task declared above.
- **Owned mutable paths:** Northstar lifecycle adapter and shared resolver under
  `skills/northstar/**`; frozen Queue schema mirrors and lifecycle reference;
  `.paseo/queue.json`; `template-bundle/lifecycle/queue.json`; focused fixtures
  and structural checks; this task and g03 indexes.
- **Reserved closeout surfaces:** g03.017 lifecycle record, declared generated
  projections, and deletion of the submitted handoff belong to the repository
  hook.
- **Worker:** automatic general pool; independent exact-head review required.
- **Oracle gate:** not required — Queue has frozen the generic event, exact-head
  target, failure routing, and compatibility boundary. Northstar owns a
  mechanical adoption with exact positive and negative fixtures.
- **Serial edges:** Queue task `a1571254-17e5-414c-9bc0-d80146c6288c`, planned
  at `7b562d47836178a035443f0577a043d91acc987d`, must reach done before dispatch.
- **Excluded:** Queue source, consumer rollout, Markdown policy beyond exact
  submitted-handoff links, weaker scan bounds, CI or release changes, and any
  thread or workspace disposition.

## Work

1. Mirror Queue's v3 control and v2 event contracts in Northstar's frozen
   schemas and reference text.
2. Extract the exact bounded backlink resolver into one import-safe module.
3. Handle `task.pre_merge` read-only at `reviewed_head`, using the task's pinned
   instruction path and digest.
4. Bind the new event in Northstar's self-hosting and starter manifests.
5. Add focused tests for a durable exact backlink, clean durable targets,
   identical pre-merge and closeout results, read-only behavior, old-manifest
   compatibility, and the ordinary revision-routing contract.
6. Run lifecycle checks, docs QA, full QA, skill validation, installed parity,
   and `git diff --check`.

## Acceptance and review oracle

- A clean accepted PR head with a tracked Markdown link to its pinned worker
  handoff fails before merge and names the linking path.
- Links to the canonical task, PR, commit, contract, or durable log pass.
- Pre-merge and closeout call the same resolver with the same file, listing,
  aggregate, and per-file bounds.
- The pre-merge hook changes no Git bytes, index state, HEAD, or lifecycle
  record.
- Queue routes the failed required gate to the retained worker's existing PR
  and semantic revision budget; it creates no closeout incident or early
  Chatterbox notice.
- A v1/v2 manifest or v3 manifest without `task.pre_merge` remains valid and
  follows its prior lifecycle behavior.
- Closeout still refuses atomically if a backlink reaches publication despite
  the earlier gate.

## Stop conditions

Stop if the change needs a second parser, weakens closeout, scans untracked or
non-Markdown content, guesses the submitted handoff, writes during pre-merge,
changes Queue source, requires consumer rollout, or disposes of a thread or
workspace.

## Evidence

Multiple otherwise successful tasks reached post-merge closeout with a durable
Markdown backlink to their transient worker handoff. The worker contract now
names the prohibition, but instruction alone cannot prove it. The existing
closeout resolver already proves the exact invariant; running that proof
against the reviewed head moves correction into the ordinary PR loop.

Queue froze the generic provider contract in Spec 007 and task g01.020 at
planning commit `7b562d47836178a035443f0577a043d91acc987d`. Its implementation
task is `a1571254-17e5-414c-9bc0-d80146c6288c`.

## Next task

After closeout, observe natural Queue lanes. Consumer adoption is a separate
operator decision; no automatic rollout is approved.
