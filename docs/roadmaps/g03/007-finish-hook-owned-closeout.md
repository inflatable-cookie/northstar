# g03.007 Finish Hook-Owned Closeout

Status: ready
Owner: repo maintainers
Created: 2026-09-12
Governing refs: spec 040, system architecture, contract 001
Depends on: `g03.006` complete; Queue g01.010 merged and plugin reloaded
UI classification: none

## Outcome

Finish the mechanical closeout cutover that `g03.006` started. A Northstar task
closed through Queue must reach a clean, current repository state without a
closeout agent: terminal JSON, deterministic front-door projections, and exact
consumed-handoff removal are one required hook publication. Markdown keeps the
semantic plan and stops duplicating mechanical status and delivery evidence.

This task must close itself through that route. The live result is the oracle,
not a mocked claim.

## Ready-State Rubric

- [x] `g03.006` proved the portable reducer, adapter equivalence, and terminal
      lifecycle receipt.
- [x] Queue g01.010 selects a required integration-write `task.closeout` hook
      as the sole closeout authority and retains the agent only when that hook
      is absent.
- [x] Queue main `ba6951c` is installed and running after a clean typecheck.
- [x] The remaining duplicated and stale surfaces are inventoried.
- [x] Scope, self-hosting oracle, fallback boundary, and stop conditions are
      explicit.
- [x] Tom authorized continuation of the bounded live hook proof.
- [x] UI classification is `none`.

## Decisions

- Lifecycle JSON owns mechanical task status and delivery evidence after
  adoption. Task Markdown owns the approved outcome, decisions, scope,
  acceptance, limits, and semantic continuation. New lifecycle-managed task
  templates must not require a hand-maintained status or closeout evidence
  rewrite.
- Generated lifecycle blocks own repository and roadmap currentness. The
  active generation README joins the declared projection targets. Human prose
  outside those blocks must not repeat active task, ready frontier, or latest
  delivery status in a form that becomes stale at closeout.
- The submitted handoff is an exact pinned instruction artifact, not permanent
  evidence. After deriving the terminal receipt, the hook removes that exact
  current path in its isolated checkout. Git and the record's handoff identity
  retain provenance. A changed, missing-at-base, ambiguous, or differently
  pinned handoff fails closed or is treated only by an explicit idempotent rule;
  the hook never deletes a guessed path.
- Routine hook closeout does not create a prose log. Exceptional semantic
  decisions may still warrant one. Queue's no-hook fallback remains unchanged.
- Spec 040 is implementation-complete. Promote any unique durable meaning to
  architecture, contract 001, reusable section 12, and lifecycle reference,
  then remove the spec and its active-planning pointers.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one self-hosting lane,
  no concurrent sibling and no automatic successor.
- **Completion:** implementation and independent exact-head review pass; PR
  merges; Queue emits the required closeout hook from synchronized main; one
  hook integration commit creates `.northstar/lifecycle/v1/tasks/g03.007.json`,
  updates every declared projection, removes the consumed handoff, and reaches
  `done` with zero closeout runs and zero closeout workspaces.
- **Owned mutable paths:** lifecycle core, Queue adapter, schemas/references,
  focused fixtures and checks under `skills/northstar/**`; matching reusable
  doctrine and templates under `bundle-docs/**` and `template-bundle/**`;
  `.paseo/queue.json`; lifecycle projection-target configuration; architecture,
  contract 001/index, spec 040/index, and active roadmap/front-door planning.
- **Reserved closeout surfaces:** `.northstar/lifecycle/v1/tasks/g03.007.json`,
  lifecycle generated blocks, and deletion of this task's exact submitted
  handoff belong exclusively to the required Queue hook after merge.
- **Worker:** automatic adequate complex implementation pool; reviewer must use
  an independent provider/model identity.
- **Serial edges:** this is the only Northstar writer lane. Do not dispatch a
  successor until the live hook result is reconciled.
- **Excluded:** Queue source or live database changes; Queue fallback changes;
  synthetic records for `g03.001`–`g03.005`; semantic priority automation;
  generation rollover/compaction; consumer rollout; UI, CI, or release edits;
  manual post-merge closeout commits; destructive thread/workspace cleanup.
- **Escalation:** Chatterbox owns any semantic-currentness, spec-retirement, or
  authority decision. Queue recovery owns mechanical hook reconciliation.

## Work

1. Remove mutable lifecycle status and delivery-evidence instructions from the
   lifecycle-managed task template and reusable doctrine. Keep semantic task
   content stable and preserve a clear pre-adoption/standalone path.
2. Make all required currentness views deterministic projections, including
   the active generation README. Remove or rewrite human text that duplicates
   the projected active task, ready frontier, or completion state. Update
   starter targets and rollover/adoption instructions so the active generation
   target changes explicitly when generations change.
3. Extend the Northstar closeout adapter to remove only the exact submitted
   handoff after its pinned blob has supplied terminal evidence. Update the
   manifest allow-list and closed schemas without broadening Queue's generic
   contract. Prove containment, symlink, mismatch, missing, replay, and
   interrupted-publication behavior.
4. Keep semantic outcome, acceptance, limitations, and continuation in task
   Markdown. Ensure ordinary closeout needs no task-status edit, evidence prose,
   roadmap pointer edit, front-door edit, or prose log.
5. Promote the surviving lifecycle contract from spec 040 into its durable
   owners. Update stale `g03.005`/`g03.006` readiness references, remove spec
   040, and leave the specs front door truthful.
6. Add installed-consumer and repository fixtures proving standalone use, the
   Queue hook route, deterministic repeat output, active-generation target
   changes, exact handoff deletion, and no mutation outside declared paths.
7. Prepare this task's implementation state for self-hosted closeout: after the
   reviewed PR merges, do not edit integration main manually. Let the installed
   Queue invoke the exact hook from merged main and inspect the resulting task,
   hook, Git, record, projection, and workspace evidence.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| One mechanical authority | Task/header prose and JSON claim different terminal states | Lifecycle-managed template plus currentness checks find no hand-maintained mechanical duplicate |
| Current front doors | Hook closes the record while g03 or a root front door still names the task as ready | Exact hook publication updates all three declared projection targets and currentness checks pass |
| Exact transient cleanup | Hook removes a similarly named or changed handoff | Real-Git fixtures pin the submitted blob/path and reject mismatch, escape, symlink, and ambiguity |
| Idempotent publication | Retry deletes more files or creates a second terminal commit | Same event/occurrence reconciliation produces the same terminal tree and one published effect |
| Standalone portability | Cleanup or projection needs Queue state or its database | Installed consumer completes the same lifecycle with no Paseo, Queue, network, or source checkout |
| Queue remains generic | Northstar paths or commands enter Queue code | Queue source diff is empty; repository manifest and hook own all Northstar knowledge |
| Hook-only live closeout | A closeout coordinator edits Markdown after merge | Queue detail shows no closeout run/workspace and one required published hook event at the terminal integration commit |
| Durable planning survives | Removing spec 040 loses a unique contract or oracle | Exact reference inventory maps every surviving obligation to architecture, contract 001, reusable section 12, or lifecycle reference before deletion |

## Stop conditions

Stop if completion needs Queue source changes, a public Queue schema revision,
manual integration edits after merge, automatic semantic priority, deletion of
an unpinned path, weakened lifecycle evidence, synthetic historic records, or a
second closeout authority. A hook failure stays visible and is repaired through
the same task/event; do not launch a closeout agent.

## Evidence

Mechanical delivery evidence will live in
`.northstar/lifecycle/v1/tasks/g03.007.json` after the required hook closes this
task. The submitted handoff remains recoverable from its pinned planning commit
after its live path is consumed.

## Next task

None. After the live hook result passes, return to Chatterbox to decide whether
repository adoption tooling or the remaining g03 protocol-reduction goal is
the next priority.
