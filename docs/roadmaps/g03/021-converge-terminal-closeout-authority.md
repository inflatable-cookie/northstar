# g03.021 — Converge terminal closeout authority

Owner: repo maintainers
Created: 2026-09-20
Governing refs: contract 001, lifecycle reference, Queue Spec 006, Queue Spec 004; `g03.007`, `g03.010`, `g03.012`
Depends on: none; Queue `g01.019` depends on this lane
UI classification: none

## Outcome

On `task.closeout`, the installed lifecycle adapter publishes one converged
lifecycle authority: it removes the superseded adapter-owned `Status:` marker on
the exact lifecycle-managed task path inside the same publication, and refuses
when the prospective projection is not current. A repository that closes out
through the hook cannot be left with two authorities or a red currentness audit.

## Ready-State Rubric

- [x] Queue diagnosed the defect against an exact consumer fixture (Market
  `g05.064`/`g05.065`) and stated the required adapter interface in Queue Spec
  006 at `759cf2d`.
- [x] The installed audit core already detects the `duplicate-status-header`
  class, and the installed hook never calls it.
- [x] Tom approved `g03.021` as the next `g03` lane and directed dispatch on
  2026-09-20.

## Decisions

- Remove rather than restate. The generated projection is the sole mechanical
  currentness, so the superseded `Status:` line on a lifecycle-managed task path
  is removed instead of being rewritten beside it.
- Convergence happens inside the existing single closeout publication. The task
  path, terminal record, declared projections and handoff consumption land in one
  commit; a partial publication is not an acceptable outcome.
- The adapter owns the marker syntax, the ownership test and the matching rule.
  Queue parses no task Markdown, which is what keeps it document-system
  agnostic. Queue Spec 006's interface list is the contract and is not restated
  here.
- Refusal beats removal. A status-looking line the adapter cannot attribute to
  its own marker class, a symlinked or non-regular task path, an undeclared
  path, or a changed planning blob refuses before any commit intent.
- Replay is byte-stable: the same event on a terminal record is a no-diff
  replay, never a second marker or a second changed path.
- Northstar's own task files carry no `Status:` header and need no migration.
  This capability is consumer-facing.

## Dispatch manifest

- **State:** ready; Chatterbox dispatches it through Northstar Queue, which owns
  worker placement, review and merge.
- **Owned mutable paths:** `skills/northstar/scripts/lifecycle-queue-hook.ts`,
  the marker rule and audit reuse in
  `skills/northstar/scripts/lifecycle-core.ts`,
  `skills/northstar/references/lifecycle/README.md`,
  `scripts/tests/lifecycle-core/self-test.sh`,
  `scripts/tests/lifecycle-adoption/self-test.sh`, the lifecycle templates under
  `skills/northstar/assets/templates/` and `template-bundle/lifecycle/` only
  where the documented closeout contract changes, this task and the `g03` front
  doors.
- **Reserved closeout surfaces:** the `g03.021` lifecycle record, the generated
  projections in `docs/README.md`, `docs/roadmaps/README.md` and
  `docs/roadmaps/g03/README.md`, and submitted-handoff deletion belong to the
  repository hook.
- **Worker:** automatic complex-capable pool with independent exact-head review.
  Frontier-worker justification: none; the work is bounded by Queue Spec 006.
- **Excluded:** Queue implementation, consumer repository edits, generation
  rollover, repair of already-red consumers, release or CI mutation, live task
  disposition, and any Markdown parsing added to Queue.
- **Escalation:** any proposal to reformulate the adapter/Queue ownership
  boundary returns to Chatterbox.

## Work

1. Give the core one shared exported marker rule: the exact `Status:` header
   shape the currentness audit already attributes to a lifecycle-managed task
   path, plus a bounded ownership test that refuses when the line could be human
   prose.
2. Make closeout converge that marker on the exact task path inside the existing
   publication, declare every changed path, and refuse before byte changes or
   commit intent when ownership, path identity or the planning blob is not
   exact.
3. Run the prospective currentness check over the complete prospective
   projection before returning `ok`, and block closeout with the bounded
   file/section/task/reason diagnostics when it is red.
4. Keep replay byte-stable: the same event on a terminal record is a no-diff
   replay with no second marker, block or changed path.
5. Prove the accepted shape with synthetic fixtures: one human body plus one
   adapter-owned pre-terminal marker in, one commit and a clean audit out, two
   sequential closeouts after a repair stay clean, and the refusal set blocks
   publication.
6. Publish the exact consumer invocation and result contract that Queue
   `g01.019` pins.

## Acceptance and review oracle

- A synthetic repository whose task file carries one human body and one
  adapter-owned pre-terminal `Status:` marker closes out to exactly one lifecycle
  authority in one commit, and `lifecycle:run audit-currentness` is clean
  immediately after.
- Replaying the same closeout event changes no bytes and adds no marker.
- Two sequential closeouts after a currentness repair remain clean.
- Ambiguous status-looking prose, an undeclared or symlinked task path, a changed
  planning blob, and an unreported task-file mutation each refuse before
  publication.
- No document-system identifier or Markdown parse enters Queue schemas or server
  code; the adapter/Queue boundary in Queue Spec 006 is unchanged.
- Existing lifecycle-core and lifecycle-adoption self-tests, full `effigy qa`,
  and v1-v3 event and manifest compatibility stay green.
- Source/installed skill parity is republished after merge, because Queue pins
  the accepted revision.

## Stop conditions

- Stop if the convergence cannot be expressed without parsing documents outside
  the adapter, or if the refusal set cannot be distinguished from human prose.
- Stop if a change would weaken exact changed-path or allowed-path publication,
  or reinterpret an in-flight Queue occurrence.
- Stop if any consumer repository would need an edit from this lane.

## Next task

Queue `g01.019` pins this accepted revision and becomes worker-dispatchable; no
further Northstar lane is implied by this one.
