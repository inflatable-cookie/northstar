# g03.008 Pin Queue Hook Runtime

Owner: repo maintainers
Created: 2026-09-13
Governing refs: system architecture, contract 001, bundle section 12
Depends on: `g03.007` terminal publication at `a402dbd`
UI classification: none

## Outcome

Make Queue execute a complete Northstar lifecycle runtime from the synchronized
repository commit it is publishing. Remove the mutable installed-skill
indirection that let `g03.007` run old adapter code, reconcile that task's
stranded handoff honestly, and repeat the live proof with this task: terminal
record, deterministic projections, and exact handoff consumption in one hook
publication with no closeout agent or closeout workspace.

## Ready-State Rubric

- [x] The `g03.007` hook event is terminal and immutable; Queue correctly will
      not rerun a published effect.
- [x] The missed acceptance row and execution mismatch are reproduced from
      committed evidence.
- [x] The repository adapter contains exact handoff cleanup, while the launcher
      resolves an older global installation.
- [x] Scope, portability boundary, live oracle, and stop conditions are fixed.
- [x] This is corrective continuation of the operator-authorized `g03.007`
      objective, not a new product lane.
- [x] UI classification is `none`.

## Decisions

- Queue's pinned executable must close over repository-committed runtime and
  schema bytes. It must not resolve implementation code through `$HOME`, a
  globally installed skill, `PATH`, the Northstar source checkout outside the
  integration clone, or another mutable location.
- The copy-ready starter must carry or deterministically install the complete
  transitive hook runtime into the adopting repository. Northstar remains
  usable without Queue; Queue remains unaware of Northstar's document model.
- Source, starter payload, and dogfood runtime may be generated copies, but one
  deterministic parity check must reject drift. Do not create hand-maintained
  lifecycle implementations.
- Preserve `g03.007`'s published record and hook receipt. Record the failed
  handoff-consumption claim as a live limitation. Remove its known stranded
  handoff in the implementation PR as explicit corrective cleanup; do not
  pretend a later manual deletion was part of the published `g03.007` effect.
- This task's own closeout is the fresh oracle. Its required hook must consume
  only this task's exact submitted handoff after merge.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one corrective
  self-hosting lane, no concurrent sibling and no automatic successor.
- **Completion:** implementation and independent exact-head review pass; PR
  merges; Queue runs the repository-committed runtime from synchronized main;
  one hook publication creates the terminal `g03.008` record, refreshes every
  declared projection, consumes this task's exact handoff, and reaches `done`
  with zero closeout runs and zero closeout workspaces.
- **Owned mutable paths:** `.paseo/hooks/**`, lifecycle scripts, schemas,
  references, focused fixtures and checks under `skills/northstar/**`; matching
  doctrine and copy-ready payload under `bundle-docs/**` and
  `template-bundle/**`; `.paseo/queue.json`; lifecycle projection
  configuration; this task and the narrow `g03.007` evidence correction;
  deletion of the known stranded `g03.007` handoff.
- **Reserved closeout surfaces:** `.northstar/lifecycle/v1/tasks/g03.008.json`,
  declared lifecycle generated blocks, and deletion of this task's exact
  submitted handoff belong exclusively to the required Queue hook after merge.
- **Worker:** automatic adequate complex implementation pool; reviewer must use
  an independent provider/model identity.
- **Serial edges:** this is the only Northstar writer lane. Do not dispatch a
  successor until the live result is reconciled.
- **Excluded:** Queue source or database changes; mutation or replay of the
  published `g03.007` event/record; global skill installation as the execution
  fix; a second lifecycle implementation; consumer rollout; UI, CI, release,
  or destructive thread/workspace changes.
- **Escalation:** Chatterbox owns any packaging or evidence-honesty decision.
  Queue recovery owns mechanical hook reconciliation.

## Work

1. Replace the live launcher's global installed-skill lookup with a
   repository-contained runtime closure. Inventory every imported module,
   schema, executable, and data file used after launch and keep each inside the
   synchronized integration checkout.
2. Make the starter copy-ready for the same boundary. An adopting repository
   must commit all hook runtime bytes it will execute; installation may copy or
   generate them, but normal Queue execution must not fetch or resolve mutable
   external implementation code.
3. Add one deterministic source-to-runtime build or parity oracle. It must fail
   when the committed dogfood or starter payload differs from its canonical
   lifecycle source and cover transitive code and schemas, not only the shell
   launcher.
4. Preserve standalone installed-skill lifecycle behavior and adapter
   equivalence. Keep Queue's manifest/event/result contracts generic and make
   no Queue repository change.
5. Amend `g03.007`'s semantic evidence to state exactly what published and what
   did not. Delete its stranded handoff as named corrective repository cleanup;
   do not alter its lifecycle JSON or Queue receipt.
6. Prove isolated execution from the exact repository tree with an adversarial
   stale global installation. The result must use the repository adapter and
   consume the correct handoff; external source removal or mismatch must not
   change behavior.
7. Prepare this task for self-hosted closeout. After the reviewed PR merges,
   make no manual integration edit: inspect Queue's hook, Git, lifecycle,
   projection, handoff, run, and workspace evidence.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| Executed bytes are pinned | The committed launcher is unchanged while `$HOME/.agents/skills/northstar` silently changes behavior | Isolated fixture with a stale or hostile global install proves all executed implementation and schema bytes come from the checked-out commit |
| Starter is complete | A consumer copies the advertised starter but still needs the author's Northstar checkout or global implementation at hook time | Copy-only consumer fixture enumerates and executes the complete committed runtime payload |
| One implementation | Source and copied runtime drift independently | Deterministic generation or byte-parity check fails on code or schema drift |
| Standalone remains portable | Pinning Queue execution makes ordinary lifecycle commands require Paseo | Installed-consumer standalone suite passes with no Queue, Paseo, network, or source checkout |
| History stays honest | A manual deletion is reported as part of the published `g03.007` hook | Preserved record/event plus explicit limitation and corrective deletion provenance |
| Queue remains generic | Queue learns a Northstar path, command, record, or schema | Queue source diff is empty; all document knowledge remains in committed repository hooks |
| Fresh live proof passes | `g03.008` reaches done while its handoff remains or a closeout agent writes the projections | Queue detail, Git tree, hook record, run list, and workspace list prove one hook publication and no closeout agent/workspace |

## Stop conditions

Stop if the repair requires Queue source changes, rewriting a published event
or lifecycle record, runtime code outside the synchronized repository checkout,
manual integration edits after the proof PR merges, weakened handoff identity,
or a second hand-maintained implementation. Keep a failed required hook visible
and repair that same event; do not launch a closeout agent.

## Evidence

`g03.007` published its terminal record and projections in `a402dbd`, with no
closeout agent or workspace. Its hook changed-path receipt omitted
`docs/handoffs/20260912-235520-finish-hook-owned-closeout.md`, which remains in
the tree. The committed adapter is SHA-256
`e8ae1037dcd17f2497318853f665e913207af3e2f47463e3874dc139147a5f6d`;
the globally installed adapter that the committed launcher executed is
`7893b8f1a8916ad0de23e9fc4622272878f5aa98e1eafa078dcd4c7af4c54cab`
and matches the pre-implementation installation. Queue's published-event retry
returns the stored result, so correction requires a new live event.

## Next task

None. After the live proof passes, return to Chatterbox and sequence the
remaining protocol-reduction goal.
