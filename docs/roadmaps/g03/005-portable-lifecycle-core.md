# g03.005 Portable Lifecycle Core

Status: complete
Owner: repo maintainers
Created: 2026-09-12
Governing refs: system architecture, contract 001, bundle section 12
Depends on: `g03.004` complete
UI classification: none

## Outcome

Ship the provider-neutral task-lifecycle schemas, reducer, standalone adapter,
and deterministic Markdown renderer of the portable task lifecycle. Prove the core works
without Paseo or Queue. Do not migrate live Northstar task authority or edit the
Queue plugin in this lane.

## Ready-State Rubric

- [x] Objective is bounded enough to finish without fresh planning decisions.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope, acceptance, validation, evidence, and stop conditions are explicit.
- [x] Review oracle covers universal state, identity, concurrency, and rendering claims.
- [x] Continuation stops at a planning checkpoint; no automatic successor is enabled.
- [x] UI classification is `none`.
- [x] No unresolved planning gap or operator intent checkpoint remains.

## Decisions

- Northstar owns one portable lifecycle core and standalone adapter.
- Task status and execution stage are separate axes.
- One current record exists per task; its compact durable event list supports
  idempotency without copying runtime history.
- JSON is canonical. Markdown is a deterministic checked-in projection.
- Queue integration uses generic repository hooks later and is outside this
  task.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one lane, no concurrent
  siblings, no automatic successor.
- **Completion:** schemas, state reducer, standalone command, deterministic
  renderer, fixtures, source/install parity, reusable doctrine, and focused
  checks satisfy the portable lifecycle contract; independent review accepts the exact PR head; PR
  merges; local `main` is synchronized; ordinary manual closeout records this
  task because live authority has not migrated yet.
- **Owned mutable paths:** new lifecycle schemas/references/scripts/fixtures
  under `skills/northstar/**`; matching reusable doctrine and copy-ready
  templates under `bundle-docs/**` and `template-bundle/**`; necessary
  `effigy.toml` and `scripts/**` validation wiring; and its eventual worker
  handoff.
- **Reserved closeout surfaces:** system architecture, contract 001,
  this task, `docs/roadmaps/g03/README.md`,
  `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`,
  `docs/README.md`, `docs/specs/README.md`, and any justified compact
  evidence record.
- **Worker:** automatic adequate complex implementation pool; reviewer must use
  an independent provider/model identity.
- **Excluded:** Queue repository changes, `.paseo/queue.json` rollout, live
  project migration, automatic Git commits or pushes, remote webhooks,
  generation roll-up, `.github/workflows/`, releases, and unrelated protocol
  cleanup.
- **Escalation:** Chatterbox owns state-model, authority, trust, portability,
  and compatibility decisions. Stop rather than create an alternate state
  vocabulary or Queue-specific branch.

## Work

1. Add Draft 2020-12 schemas for transition envelopes, task records, compact
   evidence, and deterministic projection metadata. Freeze canonical digest
   framing, path grammar, status/stage vocabulary, and transition requirements.
   Preserve locally verified, adapter-attested, and operator-authorized evidence
   levels without upgrading their claims.
2. Implement one provider-neutral lifecycle core in the installed skill. It
   validates and reduces envelopes, maintains compact durable event IDs,
   performs canonical JSON serialization, and returns machine-readable results.
3. Implement the standalone write protocol: repository discovery, exact task
   and planning identity, Git-common-directory lock, revision/digest CAS,
   temporary-file flush and atomic rename, dirty-owned-path rejection, and
   read-only verify/status modes.
4. Implement byte-stable Markdown projections with versioned sentinels, source
   digest, fixed grammar, canonical ordering, human-owned text preservation,
   drift detection, and repeat-render no-op behavior. Keep projections on
   fixtures; do not switch this repository's live status authority.
5. Expose the installed command through the skill's Effigy catalogue and a
   direct installed-skill fallback. It may return changed paths and required
   commit action but must not stage, commit, push, merge, dispatch, or choose a
   next task.
6. Add positive and adversarial fixtures for the full transition matrix,
   identity, idempotency, concurrency, interrupted writes, exact-head evidence,
   blocks and terminal dispositions, independent-task ordering, deterministic
   rendering, and absence of Paseo/Queue/network/source checkout.
7. Add reusable doctrine and starter guidance for the portable core boundary.
   Keep `.paseo/queue.json` and Queue event contracts explicitly deferred to the
   later integration lane.
8. Verify focused lifecycle fixtures, source/install parity, `effigy qa:docs`,
   `effigy qa`, and `git diff --check` on the complete change.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| Standalone is complete | Command imports Paseo, Queue, a daemon, network state, or the Northstar source checkout | Installed-skill fixture runs the legal lifecycle offline in an isolated consumer |
| State semantics are singular | Adapter invents Queue phases as Northstar statuses or accepts an undefined transition | Exhaustive positive/negative status-stage matrix |
| Writes are safe | A stale writer, held lock, interrupted write, dirty owned path, or path escape mutates the record | CAS, lock, atomicity, dirty-state, and containment fixtures preserve prior bytes on failure |
| Events are idempotent | A repeated event advances twice, or one event ID accepts different content | Identical retry returns the recorded revision/digest; conflicting reuse fails |
| Evidence binds to delivery | Completion accepts review for another head, a merge without authority, or validation from an unrelated head | Exact-head, authorization, merge ancestry, and validation negative fixtures |
| Parallel tasks do not share state | Two tasks must edit one canonical ledger or receipt path | Two-task either-order fixture changes separate record paths and yields the same projection |
| Markdown is deterministic | Re-render changes bytes, reorders tasks, or overwrites narrative outside its block | Golden render, repeat no-op, drift rejection, and human-text preservation fixtures |
| Automation cannot invent intent | Empty runway causes the core to select work or semantic text is discarded during rendering | `planning_required` and preservation negatives fail closed |
| Distribution stays coherent | Source-only success hides a broken installed command or starter | Exact parity plus installed consumer fixture and full QA |

## Stop conditions

Stop if the core needs Queue data to execute, if the schema cannot represent a
manual provider-neutral closeout, if external evidence would be presented as
cryptographically verified without such proof, if safe writes require a global
task ledger, or if the renderer cannot preserve human-owned Markdown exactly.

## Evidence

The completion evidence is recorded in the Closeout below. This lane still
uses the existing manual Northstar closeout procedure.

## Closeout

- The provider-neutral lifecycle core is shipped in the installed Northstar
  skill: Draft 2020-12 schemas, reducer, standalone adapter, canonical JSON,
  safe CAS and atomic writes, deterministic Markdown projections, focused
  adversarial fixtures, installed-consumer proof, reusable doctrine, and
  copy-ready starter guidance.
- PR [#44](https://github.com/inflatable-cookie/northstar/pull/44) was accepted
  at exact head `7c9025f7487e5f28781821f748e09a246cb152db` by the independent
  review in [comment 5647337751](https://github.com/inflatable-cookie/northstar/pull/44#issuecomment-5647337751)
  and merged as `f7ef37084649f1ccb4194661de7c5bd522160b97`.
- The accepted review recorded `check:lifecycle-core` passing 52/52 from both
  source and the isolated installed consumer, source/install parity for 123
  files, `effigy qa` (including `qa:docs`), and `git diff --check` on the exact
  head. The integration checkout was clean and synchronized with `origin/main`
  at the merge commit before this closeout.
- No acceptance failure remains. Queue hooks, `.paseo/queue.json`, live
  Northstar status-authority migration, and generation roll-up remain deferred
  to their separately owned lanes. The review's non-blocking notes remain
  limits for later hardening: explicit-path `render`/`compact` do not yet
  re-check containment, and closeout commits necessarily follow the
  merge-time synchronized-main evidence.

## Next task

Return to Chatterbox after merge. Compile the standalone adoption task and send
the frozen generic hook boundary to the Queue project's planning authority; do
not dispatch either automatically.
