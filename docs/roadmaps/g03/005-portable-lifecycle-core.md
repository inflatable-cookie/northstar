# g03.005 Portable Lifecycle Core

Status: ready
Owner: repo maintainers
Created: 2026-09-12
Governing refs: spec 040, system architecture, contract 001
Depends on: `g03.004` complete
UI classification: none

## Outcome

Ship the provider-neutral task-lifecycle schemas, reducer, standalone adapter,
and deterministic Markdown renderer defined by spec 040. Prove the core works
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
  checks satisfy spec 040; independent review accepts the exact PR head; PR
  merges; local `main` is synchronized; ordinary manual closeout records this
  task because live authority has not migrated yet.
- **Owned mutable paths:** new lifecycle schemas/references/scripts/fixtures
  under `skills/northstar/**`; matching reusable doctrine and copy-ready
  templates under `bundle-docs/**` and `template-bundle/**`; necessary
  `effigy.toml` and `scripts/**` validation wiring; and its eventual worker
  handoff.
- **Reserved closeout surfaces:** system architecture, contract 001, spec 040,
  this task, `docs/roadmaps/g03/README.md`,
  `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`,
  `docs/README.md`, `docs/specs/README.md`, spec 040, and any justified compact
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

On completion, record outcome, focused and full validation, installed standalone
fixture, PR, independently reviewed exact head, merge commit, and material
limits. This lane still uses the existing manual Northstar closeout procedure.

## Next task

Return to Chatterbox after merge. Compile the standalone adoption task and send
the frozen generic hook boundary to the Queue project's planning authority; do
not dispatch either automatically.
