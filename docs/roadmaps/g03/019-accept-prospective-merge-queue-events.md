# g03.019 — Accept prospective-merge Queue events

Owner: repo maintainers
Created: 2026-09-15
Governing refs: contract 001, lifecycle reference, Queue Spec 015
Depends on: `g03.018` complete at `c74cbdd`; Queue g01.031 accepted at `4443185`
UI classification: none

## Outcome

Northstar's canonical and installed lifecycle hook strictly accept Queue event
schema `paseo.queue.event.v3` for a required read-only `task.pre_merge` run at
`prospective_merge`, prove the declared candidate identity locally, and apply
the existing backlink policy to that candidate tree. Event v1/v2 and reviewed
head behavior remain byte-compatible.

## Ready-State Rubric

- [x] Queue's additive event and target contracts are accepted and pinned at
  Queue main `4443185`.
- [x] The first live consumer failure identifies the exact unsupported schema,
  with no active Bovine run or merge intent.
- [x] Candidate, integration-base, reviewed-head, and tree identities are all
  present in the closed v3 payload.
- [x] Northstar owns the schema mirror, parser, policy adapter, fixtures, and
  installed-skill parity.
- [x] UI classification is `none`.

## Decisions

- Add frozen strict mirrors for `paseo.queue.event.v3` and its corresponding
  `paseo.queue.control.v4` manifest grammar from Queue `4443185`. The control
  mirror is required because accepting the event only to reject its binding is
  not compatibility.
- Accept event v3 only for `task.pre_merge`, repository target
  `prospective_merge`, and a closed `mergeCandidate` containing 40-hex
  `integrationBase`, `reviewedHead`, `commit`, and `tree` identities. Reject
  missing, extra, cross-version, or misplaced fields.
- Accept `prospective_merge` only from a v4 hook binding whose sole event is
  `task.pre_merge`, mode is `read_only`, delivery is `required`, allowed paths
  are empty, and commit subject is null. Preserve every v1-v3 binding rule.
- Split pre-merge identity checks by target. The existing `reviewed_head` path
  stays unchanged. For `prospective_merge`, require the execution checkout HEAD
  and tree to equal the candidate commit and tree, require repository
  `baseCommit` to equal `integrationBase`, require delivery head to equal
  `reviewedHead`, and locally verify the candidate's two parents in base/head
  order before scanning.
- Reuse the existing instruction reconstruction and exact backlink resolver on
  the candidate checkout. Do not add a second Markdown parser, a Bovine path
  exception, or a weaker policy result.
- Return the same read-only hook-result contract and lifecycle semantics. Add
  target and candidate identity only as bounded result metadata where useful;
  create no lifecycle task-record transition during pre-merge.
- After merge, refresh the global Northstar skill and prove source/installed
  parity before retrying the exact retained Bovine task. Do not edit Bovine or
  replace its task, worker, PR, reviewed head, or Queue history.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready and prioritized; urgent compatibility dependency for retained
  Bovine Queue task `4e30ee69-fd4f-4e84-a94e-3cc9a7beff6f`, PR #840 at reviewed
  head `a7cf961b880282626fd8c3738ebefcb5d1ffbf30`.
- **Owned mutable paths:** Queue event/control schema mirrors, lifecycle hook
  parser and target checks, lifecycle reference, focused adoption/hook fixtures,
  this task and g03 indexes under the Northstar repository.
- **Reserved closeout surfaces:** g03.019 lifecycle record, declared generated
  projections, and submitted-handoff deletion belong to the repository hook.
- **Worker:** automatic general pool; independent exact-head review required.
- **Oracle gate:** not required. Queue froze the additive protocol and Tom
  explicitly authorized this smallest Northstar compatibility adoption.
- **Excluded:** Queue or Bovine source changes, Bovine task/PR/thread/workspace
  mutation before installed parity, policy exceptions, lifecycle transition
  changes, broad v4 feature work, release/CI changes, and any thread or
  workspace disposition.

## Work

1. Mirror Queue's exact event-v3 and control-v4 closed schemas at `4443185` and
   add them to the adapter's version selection without modifying old mirrors.
2. Extend manifest binding validation for `prospective_merge` while preserving
   all v1-v3 correlation and reserved-path rules.
3. Extend the shared pre-merge handler with target-specific local candidate
   identity proofs and reuse the existing instruction/backlink checks.
4. Add focused positive and negative fixtures for schema strictness, candidate
   identity, target/binding correlation, read-only behavior, and v1/v2 byte
   compatibility.
5. Run lifecycle adoption/core checks, docs QA, full QA, skill validation,
   source/installed parity evidence, and `git diff --check`.

## Acceptance and review oracle

- Queue's accepted v3 prospective-merge event shape parses and a clean exact
  candidate tree returns the ordinary successful read-only result.
- The live Bovine-shaped payload reaches Northstar backlink evaluation instead
  of `unsupported schema`, without changing candidate, worker, or integration
  checkout bytes.
- Wrong schema/target pair, v3 on another event, missing or extra candidate
  fields, malformed IDs, base/integration mismatch, delivery/reviewed-head
  mismatch, HEAD/commit mismatch, tree mismatch, and parent-order mismatch each
  fail closed before scanning or mutation.
- A real transient-handoff backlink in the prospective tree still blocks by
  the same resolver and result semantics used at `reviewed_head`.
- Existing event-v1/v2 and control-v1/v2/v3 fixtures produce byte-identical
  accepted results and refusals. Closeout and lifecycle records are unchanged.
- The installed global skill matches the merged source and accepts the same v3
  fixture before the retained Bovine task is retried.

## Stop conditions

Stop if compatibility requires editing Queue or Bovine, weakening backlink
policy, trusting conflicting candidate identities, mutating a pre-merge
checkout, changing old schema bytes or lifecycle transitions, bypassing
independent review, or replacing any retained Bovine identity.

## Evidence

Queue g01.031 is landed and its accepted contract at `4443185` emits
`paseo.queue.event.v3` when a v4 manifest selects `prospective_merge`. Bovine
main adopted that binding at `19d0ce699`. Its first live run on retained task
g03.029 failed before policy evaluation because Northstar's current event map
contains only v1 and v2; the manifest map and binding type also stop at v3 and
`reviewed_head`.

The Bovine task remains `needs_attention` with no active run or merge intent.
PR #840 is accepted at exact head
`a7cf961b880282626fd8c3738ebefcb5d1ffbf30`. That stable task is the post-merge
canary; it is not an implementation surface for this repair.

## Next task

After Northstar merge and installed parity, retry the exact held Bovine hook and
let its existing Queue lifecycle continue. Then return to Chatterbox; no
automatic Northstar successor is approved.
