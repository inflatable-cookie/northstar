# g03.020 — Make prospective merge the portable default

Owner: repo maintainers
Created: 2026-09-16
Governing refs: contract 001, lifecycle reference, Queue Spec 015
Depends on: `g03.019` complete at `261a781`; Queue g01.031 accepted at `4443185`
UI classification: none

## Outcome

Northstar's own Queue manifest, copy-ready lifecycle bundle and reusable
doctrine default to `paseo.queue.control.v4` with the required read-only
`task.pre_merge` hook at `prospective_merge`. A bounded installed-skill command
can preflight and apply that exact migration to an existing conforming v3
consumer without changing any other repository bytes.

## Ready-State Rubric

- [x] Queue's v4 manifest and v3 prospective-merge event are accepted.
- [x] Northstar's canonical and installed hook implementations support them.
- [x] Bovine proves the v4 path in live use.
- [x] The portfolio census identifies 30 remaining v3 consumers.
- [x] Tom authorized the producer update and consumer rollout on 2026-09-16.

## Decisions

- Replace the dogfood and template manifest defaults together: schema v4 and
  `prospective_merge` are one contract migration.
- Update reusable doctrine, lifecycle README, script documentation and
  repository-contract assertions so no producer surface continues prescribing
  v3 reviewed-head behavior.
- Add one generic installed-skill migration command under the existing
  lifecycle route. Dry-run is the default. Write mode changes only the schema
  and pre-merge target in `.paseo/queue.json`, atomically.
- Accept only an exact conforming trusted-runner v3 manifest with one required
  read-only `task.pre_merge` binding at `reviewed_head`. Refuse older schemas,
  custom programs, ambiguous hooks, dirty repositories, symlinks, invalid JSON,
  or any shape requiring interpretation.
- Treat an already-conforming v4 manifest as an idempotent no-op. Emit bounded
  machine-readable evidence for both dry-run and write modes.
- The command owns no Git commit, push, Queue submission or cross-repository
  loop. Chatterbox creates separate canonical consumer tasks after this producer
  merges and installed parity is proven.

## Dispatch manifest

- **State:** ready; Tom authorized implementation and the subsequent portfolio
  rollout on 2026-09-16.
- **Owned mutable paths:** `.paseo/queue.json`, lifecycle template and doctrine,
  lifecycle command/runtime and focused fixtures, repository-contract oracle,
  this task and g03 front doors.
- **Reserved closeout surfaces:** g03.020 lifecycle record, generated
  projections and submitted-handoff deletion belong to the repository hook.
- **Worker:** automatic complex-capable pool; independent exact-head review.
- **Excluded:** consumer repository edits, Queue implementation, policy changes,
  provider/limit changes, release or CI mutation, and live task disposition.

## Work

1. Promote v4/prospective-merge into Northstar's dogfood manifest, lifecycle
   template, reusable doctrine and repository-contract assertions.
2. Add the dry-run-first exact-shape migration command to the installed
   lifecycle skill route with atomic write and idempotent v4 handling.
3. Add positive, refusal and byte-isolation fixtures, including a conforming v3
   consumer, an already-v4 consumer, custom hooks, dirty state and symlinks.
4. Update adoption self-tests so starter and dogfood manifests prove v4 while
   old v1-v3 compatibility fixtures remain accepted.
5. Prove source/installed parity and publish the exact consumer invocation and
   result contract for Chatterbox rollout.

## Acceptance and review oracle

- Every copy-ready and dogfood surface names v4 and `prospective_merge`; no
  current producer instruction recommends v3 reviewed-head adoption.
- Dry-run reports the exact one-file/two-value migration without writing.
- Write mode changes no byte outside `.paseo/queue.json`, validates the result
  against the frozen v4 schema and is idempotent on replay.
- Divergent or ambiguous consumers fail before mutation with a precise reason.
- Existing v1-v3 event and manifest compatibility tests remain green.
- Full Northstar QA, lifecycle adoption QA, skill validation and source/installed
  parity pass.

## Stop conditions

Stop if safe migration requires guessing consumer intent, editing consumer
planning, weakening old-version compatibility, changing Queue, accepting dirty
or ambiguous repositories, or giving the command Git/dispatch authority.

## Next task

After merge and installed parity, return to Chatterbox. The authorized follow-on
is the exact census-bound consumer rollout; no unrelated Northstar successor is
approved.
