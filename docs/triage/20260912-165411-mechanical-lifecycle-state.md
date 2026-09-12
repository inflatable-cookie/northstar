# Mechanical lifecycle state

Status: open; design exploration
Owner: Northstar Chatterbox
Source: operator discussion, 2026-09-12

## Problem

Northstar still spends capable-agent effort rewriting lifecycle facts across a
task, generation runway, front doors, evidence text, handoff disposition, and
spec state. Closeout is the clearest example. Most facts already exist in Git,
the provider, validation output, or the queue; prose projection adds cost,
latency, and drift.

The replacement must preserve semantic planning, portable operation, exact-head
evidence, and safe generation compaction. It must also let independent PR lanes
merge without sharing a bookkeeping file.

## Boundary

Keep human-authored Markdown for meaning:

- outcome and user value;
- architecture and contracts;
- task scope, decisions, acceptance, stop conditions, and UI brief;
- operator-owned priority and semantic next-task choices;
- material limitations that need judgment.

Move deterministic lifecycle facts to structured state:

- task state and transition time;
- dependencies and approved frontier membership;
- dispatch, worker, workspace, PR, review, exact-head, merge, and sync identity;
- validation receipts;
- block, pause, retry, supersession, and cancellation disposition;
- handoff consumption;
- closeout completeness and eligible next tasks;
- generation closure and compaction eligibility.

A tool may compute eligible work. It must not invent priority, architecture, a
next semantic lane, or whether unique meaning is safe to discard.

## Storage options

### One repository ledger

One JSON file is easy to query and validate, but every task and merge edits the
same path. It creates a permanent merge hotspot, makes stale writes easy, and
couples unrelated generations. Reject as the canonical write model.

### One mutable state file per task

`gNN.NNN` gets one JSON state file. Different tasks do not conflict, and a
compare-and-swap version can reject stale writes to the same task. Git history
provides an audit trail. This is the simplest viable model, but concurrent
writes from separate checkouts can still fork from the same version and are
detected only when they meet.

### Immutable transition fragments

Each accepted transition writes a uniquely named JSON fragment. Independent
tasks and independent events merge cleanly. A deterministic reducer builds the
current task and generation view. This preserves provenance and makes retry
idempotency explicit, but increases file count and requires fork/conflict
validation plus generation compaction.

### Queue-backed live state

Northstar Queue already implements most of the required live lifecycle engine:
versioned tasks, dependencies, role runs, coordinator generations, callbacks,
idempotent receipts, exact-head review, merge reconciliation, retries,
supersession, and closeout. Its SQLite store gives the transactional behavior
that a Git-backed script would otherwise have to rebuild badly.

Queue state cannot be Northstar's only authority. It belongs to one Paseo
installation, contains operational detail that should not be copied into Git,
and is unavailable to manual or alternative orchestrators. Queue must remain an
optional adapter to a provider-neutral Northstar lifecycle core.

## Tentative recommendation

Use three layers rather than a second lifecycle engine:

1. Northstar owns the state machine, schemas, transition validation, portable
   task receipts, and deterministic repository projections.
2. A bundled standalone adapter applies those transitions directly to
   per-task repository state with atomic writes and compare-and-swap checks.
3. Queue optionally owns richer live transactional execution and emits generic
   repository events to repository-declared hooks. A Northstar hook maps those
   events onto the same Northstar transitions and receipts.

Northstar must be complete without Queue. A repository with Effigy and the
installed Northstar skill can create, inspect, advance, close, and compact task
state. The standalone path may be less convenient and offer fewer centralized
operations, but it must preserve the same lifecycle invariants and final
evidence.

Queue must not define Northstar lifecycle semantics or know Northstar's document
layout. It may add leases, callbacks, retries, provider routing, role runs,
notifications, recovery, queryable history, and generic repository hooks. At
durable boundaries it emits a Queue event. The repository's declared Northstar
hook converts that event to the transition envelope the standalone adapter uses
and returns the accepted receipt version and digest. Queue-specific IDs remain
additive metadata.

For a Northstar repository, the hook binds each Queue task to a canonical
Northstar task ID and path. Do not infer `gNN.NNN` from the handoff name,
branch, workspace, or prompt. A non-Northstar repository may return a different
opaque canonical identity or none. At authority-changing points, the hook
passes a versioned payload to the Northstar lifecycle command. The happy-path
closeout payload records accepted implementation and review heads, merge and
synchronized-main identities, validation, handoff disposition, and final task
state.

Store one compact receipt per task rather than copying Queue's complete event
stream into Git:

```text
.northstar/lifecycle/v1/
  tasks/g03.004.json
  generations/g03.json       # optional derived projection
```

The task receipt should carry:

- schema version, canonical task ID and path;
- receipt version, state, actor, and source (`manual`, Queue, provider, CI);
- planning authority commit;
- implementation, review, merge, and synchronized-main identities;
- idempotency key and creation time;
- validation evidence and handoff disposition;
- durable limitation, block, cancellation, or supersession when applicable.

Queue keeps high-volume operational events in its live store. Git keeps the
portable facts needed to understand and verify the result after Queue is gone.
Optional transition receipts may preserve durable nonterminal dispositions or
support manual operation, but they are not the default write shape.

The Northstar command rejects stale receipt versions, duplicate idempotency
keys with different content, illegal transitions, review/head mismatch, merge
without accepted exact-head review, and closeout without merge and validation
evidence. A manual adapter must emit the same payload as Queue.

## Authority and runtime split

Keep four roles distinct:

- the task Markdown owns semantic intent, scope, acceptance, stop conditions,
  and approved execution policy;
- the per-task lifecycle record owns portable mechanical state and evidence;
- Queue owns its richer live operational state when installed;
- front doors and generation summaries are derived projections.

Queue's database is authoritative for an in-flight Queue run. Repository hooks
use a transactional outbox: Queue stores the generic event intent in the same
transaction, invokes the pinned repository hook idempotently, then marks the
delivery accepted. A crash may leave a pending delivery but must not lose or
duplicate the event. Northstar's hook performs the Northstar transition; Queue
does not understand the resulting repository files.

The repository remains conservatively recoverable if Queue disappears. The
last accepted checkpoint may lag transient runtime activity, but it must never
claim review, merge, or completion that was not durably proved. Queue may expose
the fresher live view while connected.

## Generic Queue control manifest

Queue should discover an optional, versioned repository control manifest. The
exact path is unsettled; a dedicated `.paseo/queue.json` avoids coupling the
plugin's schema evolution to the host `paseo.json` schema. Northstar's starter
would install the standard Northstar hook declaration. Other repositories could
declare different commands or no lifecycle hooks.

The manifest describes generic Queue behavior only:

- a committed instruction-artifact contract;
- hooks bound to named Queue events;
- hook mode: read-only gate or integration write;
- required versus advisory delivery;
- executable and fixed arguments;
- working tree and base-commit requirements;
- timeout and output limits;
- allowed output paths for a write hook; and
- static or bounded commit-message policy.

Illustrative shape:

```json
{
  "schema": "paseo.queue.control.v1",
  "instruction_artifact": {
    "kind": "committed_file"
  },
  "hooks": [
    {
      "on": "submission.validate",
      "mode": "gate",
      "required": true,
      "command": ["effigy", "skill", "run", "--path", "...", "queue:preflight"]
    },
    {
      "on": "integration.synchronized",
      "mode": "integration_write",
      "required": true,
      "command": ["effigy", "skill", "run", "--path", "...", "queue:closeout"],
      "allowed_paths": [".northstar/lifecycle/**", "docs/**"]
    }
  ]
}
```

Names and broad illustrative paths above are not frozen. The Northstar starter
should use narrower generated-path ownership wherever possible.

Queue sends a generic `paseo.queue.event.v1` JSON document on standard input.
It contains stable task/event IDs, event type and time, repository and base
identity, committed instruction artifact, Queue version, current phase,
dependencies, actor/run identities, PR/review/merge facts, and synchronized-main
identity when available. Values are data; Queue never interpolates them into a
shell command.

The hook returns `paseo.queue.hook-result.v1` with an event ID, outcome
(`accepted`, `blocked`, `failed`, or `no_change`), bounded summary, opaque
repository metadata, changed paths, and optional requested commit subject.
Northstar metadata may include canonical task ID, lifecycle revision, and
receipt digest, but Queue stores it opaquely.

For an integration-write hook, Queue:

1. verifies clean synchronized `main` and pins the manifest commit and blob;
2. invokes the fixed command with a minimal environment and bounded resources;
3. validates the result schema and event identity;
4. verifies the actual diff is confined to the manifest's allowed paths;
5. stages only those paths, commits, pushes, and verifies remote identity; and
6. records the hook result and published commit before advancing the task.

A blocked or failed hook leaves no partial tracked mutation and prevents the
required transition. The hook must be idempotent by Queue event ID. Queue
reconciles an uncertain commit or push before retrying; it never runs the same
write blindly.

The manifest is trusted local executable configuration, like existing Paseo
worktree hooks. Queue loads it only from the exact clean base used for the
event, never from a worker callback, prompt, uncommitted file, or arbitrary PR
branch. Version 1 should support local commands only; remote webhooks add secret,
authentication, and delivery policy without helping the first use case.

## Queue core decoupling

The hook boundary exposes two current Queue assumptions that should become
adapters:

- Core submission should carry a generic committed instruction artifact
  (`path`, commit, blob digest, media type) rather than a Northstar
  `handoffPath`. The existing Northstar handoff command resolves and submits
  that artifact.
- Core closeout should emit `integration.synchronized` and run the declared
  hook. The current Northstar-specific coordinator prompt and hard-coded docs
  write allowlist become the legacy Northstar adapter until the hook path has
  parity.

Queue may keep its current product name. Its engine and persisted contracts
should no longer require Northstar documents to operate.

## Portable state model

Use two axes. Do not copy Queue's complete phase vocabulary into Northstar.

Task status:

- `planned`: shaped but not approved for execution;
- `ready`: approved and eligible when dependencies allow;
- `active`: execution owns the task;
- `blocked`: progress stopped, with a typed reason and resumption target;
- `complete`: accepted delivery and closeout are durable;
- `cancelled`: stopped without replacement;
- `superseded`: replaced by named authority.

Execution stage:

- `none`, `dispatch`, `implementation`, `review`, `merge`, or `closeout`.

Status answers whether the task may or did proceed. Stage answers where active
or blocked work stopped. `complete`, `cancelled`, and `superseded` always use
`none`. A blocked record preserves its prior status and stage so resumption is
explicit.

The core transition set should stay small:

```text
plan -> ready -> start -> advance-stage -> complete
                    \-> block -> resume --/
planned|ready|active|blocked -> cancel|supersede
```

Review revision moves from `review` back to `implementation`; it does not need a
new task status. Provider failure, missing authority, and ordinary worker
failure all use `blocked` with different reason codes.

## Queue mapping and gaps

The current Queue model maps cleanly in most places:

| Northstar field | Current Queue source |
| --- | --- |
| Planning identity | `planningCommit`, `handoffPath`, `planningBase` |
| Live version | task `version`, `coordinatorGeneration` |
| Runtime state | `phase`, `reason`, held state, role runs |
| Implementation | `prUrl`, `prHead`, worker completion |
| Review | `resolution.review`, reviewer run and published comment |
| Verification | `resolution.verification` |
| Merge | `mergeHead`, `mergeBase`, `mergedCommit`, `externalMerge` |
| Main synchronization | `syncedCommit` |
| Closeout | closeout run completion and `closeoutCommit` |
| Runtime provenance | task, run, workspace, agent, and profile identities |

The first adapter needs to close these gaps:

1. Queue submission has no explicit canonical `gNN.NNN` task ID and task path.
2. Queue dependencies use Queue UUIDs, not portable Northstar task references.
3. Validation is mostly prose in completion summaries rather than typed
   command, result, head, and artifact receipts.
4. Review evidence needs a portable reviewer identity and independence result,
   not only Queue run metadata.
5. Pre-closeout synchronized main and the final closeout commit need distinct
   fields; `syncedCommit` currently serves both moments.
6. Review-skip and other exceptional authority need an exact durable
   authorization reference.
7. Handoff consumption, retained limitations, and next-task disposition are
   not structured Queue results.

Queue phases map to the portable axes as follows:

| Queue phases | Portable status | Portable stage |
| --- | --- | --- |
| `queued` | `ready` | `none` |
| `dispatching`, `working` | `active` | `dispatch` or `implementation` |
| `awaiting_review`, `reviewing`, `changes_requested`, `verifying` | `active` | `review` or `implementation` |
| `merging` | `active` | `merge` |
| `syncing`, `closing` | `active` | `closeout` |
| `blocked`, `error`, `needs_attention` | `blocked` | preserve current stage |
| `cancelled` | `cancelled` | `none` |
| `done` | `complete` | `none` |

Held and paused are scheduling controls, not Northstar task statuses. They stay
in Queue unless they create a durable semantic block.

## Durable checkpoint policy

Do not commit every Queue heartbeat or stage change. Require repository
checkpoints for:

- planning promotion to `ready`;
- a durable block, cancellation, or supersession;
- accepted terminal closeout to `complete`;
- generation closure and compaction.

`active` stage changes may remain in the runtime store. The standalone adapter
can retain them in local state or commit them when shared visibility matters.
Both modes must produce the same terminal receipt from equivalent evidence.
This equivalence is the portability oracle; identical intermediate commit
history is not required.

## Transition and record contracts

Adapters submit a transition envelope. They do not construct or overwrite the
canonical task record directly. The core validates the transition, merges
evidence, increments the revision, writes canonical JSON, and returns its
digest.

Illustrative transition envelope:

```json
{
  "schema": "northstar.lifecycle.transition.v1",
  "event_id": "adapter-stable-id",
  "task": {
    "id": "g03.005",
    "path": "docs/roadmaps/g03/005-example.md"
  },
  "expected": {
    "revision": 2,
    "digest": "sha256:..."
  },
  "transition": "complete",
  "occurred_at": "2026-09-12T18:00:00Z",
  "actor": {
    "kind": "orchestrator",
    "id": "portable-or-local-identity"
  },
  "evidence": {},
  "source": {
    "adapter": "paseo-northstar-queue",
    "runtime_task_id": "optional"
  }
}
```

The canonical per-task record contains:

- task ID, path, generation, planning commit, and task-blob digest;
- current revision, content digest, status, stage, and resumption target;
- canonical dependency references;
- approved delivery and review policy with authorization references;
- implementation and PR identity when applicable;
- review verdict, exact head, durable review record, reviewer identity, and
  independence result;
- verification identity and result;
- merge head, base, merge commit, and external-merge flag;
- pre-closeout synchronized-main commit and final closeout commit;
- typed validation results bound to a head;
- handoff disposition, limitations, and next-task or `planning_required`
  disposition;
- adapter metadata isolated from portable fields; and
- a compact list of applied durable event IDs and digests.

The applied-event list is not Queue's event history. It exists so a delayed or
repeated outbox delivery remains idempotent even after later transitions. Git
history preserves prior record bodies. Generation compaction may reduce closed
task records into a generation receipt after verifying their digests.

## Standalone write protocol

The bundled adapter should use this sequence for an authority-changing write:

1. Resolve and verify the repository root, integration branch, task path, and
   planning identity.
2. Acquire a repository-wide lifecycle lock under Git's common directory.
3. Reread the task record and verify expected revision and digest.
4. Validate the transition and required evidence without mutating files.
5. Write canonical JSON to a same-directory temporary file, flush it, and
   atomically rename it over the task record.
6. Regenerate any selected derived projection in the same operation.
7. Release the lock and return changed paths, new revision, digest, and the
   commit action still required.

The command must refuse dirty owned paths, stale state, illegal branches,
ambiguous task identity, and contradictory provider evidence. It must not
stage, commit, push, merge, or choose the next task unless the invoking mode
explicitly owns those actions.

Separate task paths remove content conflicts between independent lanes. A
repository-wide lock protects one shared checkout; expected revision and digest
protect against stale writes from separate worktrees or machines. Git push can
still race. The losing integration writer must update, reread, and replay its
unchanged envelope rather than force or synthesize a merge.

Queue's existing per-repository integration turn can serialize this operation
after code merges. Standalone orchestration performs the same short integration
step itself. Workers and reviewers never mutate lifecycle records.

## Concurrency and merge shape

- Workers do not edit global front doors or lifecycle state in their PRs.
- Queue's task version, coordinator generation, callback receipts, and role-run
  ownership protect live execution. Northstar should reuse those guarantees,
  not reproduce them in Rhai.
- Different tasks write different receipt paths. A receipt update uses an
  expected prior version or digest; same-task stale writes fail.
- Code PRs can merge without waiting for prose closeout. The integrator records
  merged facts on synchronized `main`, either after each merge or as one batch
  for several already-merged lanes.
- A global currentness index is generated from task receipts. Workers never edit it.
  Prefer computing it on demand; if a human-readable projection is committed,
  one integration writer regenerates it after merges and it remains derived,
  never canonical.
- Closing a generation reduces its validated receipts into one compact summary
  with source digests under the existing preservation oracle.

Git provider merges are still serialized at the commit boundary. This design
removes artificial lane serialization caused by shared documentation paths; it
does not pretend simultaneous mutations of `main` exist.

## Lifecycle command surface

An installed Northstar task, invoked through Effigy, should expose a small
adapter and projection surface such as:

```text
northstar/lifecycle status
northstar/lifecycle verify
northstar/lifecycle apply-receipt <payload>
northstar/lifecycle close <payload>
northstar/lifecycle frontier
northstar/lifecycle compact-generation
northstar/lifecycle render
```

Exact command grammar is not settled. Repository wiring may provide a short
`effigy northstar:lifecycle ...` selector; the installed-skill fallback can use
Effigy's existing `--repo` route.

The standalone adapter calls this surface directly. Queue calls the same surface
at durable state boundaries and after merge and synchronized-main verification.
Rhai is suitable for task wiring, validation, and simple projections; a small
portable implementation may still be justified for canonical JSON and atomic
receipt writes. The bundled implementation must own the lifecycle semantics but
must not grow into a parallel scheduler, callback store, or provider runtime.

## Use cases to prove

1. Sequential task from ready through merge and closeout.
2. Two independent ready tasks implemented and reviewed concurrently, merged in
   either order, then closed without a shared-file conflict.
3. Two tasks sharing one reserved integration surface, with explicit serial
   merge or post-merge integration ownership.
4. Worker revision and re-review on a new exact head.
5. Failed validation, blocked worker, resume, and idempotent repeated callback.
6. Abandoned, superseded, and cancelled work with retained provenance.
7. External/manual worker and PR with no Queue installation.
8. External merge observed after stale local state.
9. Stale writer and same-task fork rejection across two worktrees.
10. Chatterbox changes frontier or priority while implementation is active.
11. No next approved task: closeout returns `planning_required` without
    inventing work.
12. Generation closure, preservation check, fragment roll-up, and repeat
    compaction with no churn.
13. Dirty integration checkout, missing provider identity, and partial provider
    outage without silent state advancement.
14. Migration from current Markdown status without losing historical evidence.

## Front-door consequence

If structured state becomes canonical for lifecycle facts, current Markdown
front doors should stop repeating hand-maintained status. Keep their semantic
runway and links, then render clearly marked derived blocks from the lifecycle
index. The operator confirmed that committed Markdown is preferred so long as
its grammar is deterministic and machine-readable.

Generated blocks need stable start/end sentinels, schema version, source digest,
fixed field labels or table columns, canonical task ordering, normalized line
endings, and byte-stable rendering. Human edits inside a generated block fail
verification and are replaced by regeneration. Narrative outside the block
remains human-owned. Rendering the same receipt set twice must produce no diff.

## Adoption path

1. Inventory every current lifecycle write and classify it as semantic,
   mechanical, derived, or exceptional evidence.
2. Map Queue's task, event, review, merge, and closeout fields onto the smallest
   provider-neutral receipt schema.
3. Freeze the receipt schema, actor trust, idempotency, and conflict rules.
4. Build a read-only validator/projector over fixtures and compare its output
   with current Northstar closeouts.
5. Build the bundled standalone adapter and generic Queue hook contract, then
   add the Northstar Queue manifest and hook that produce identical receipts
   from equivalent facts.
6. Shadow one natural task: keep current Markdown authority while generating a
   terminal receipt and comparing the derived result.
7. Run the two-concurrent-PR oracle.
8. Only after parity, switch lifecycle status authority and remove manual
   projections together.
9. Prove generation roll-up before making the mechanism a reusable default.

## Open decisions

- Whether Queue control belongs in a dedicated `.paseo/queue.json` or a
  namespaced extension of `paseo.json`.
- The minimum generic Queue event vocabulary and integration-write result
  contract.
- Whether Queue itself owns the deterministic hook commit or invokes a separate
  generic integration runner while retaining the same verification gates.
- Which durable transitions the standalone adapter commits before terminal
  closeout, and how it behaves when no integration writer is available.
- Which nonterminal dispositions merit portable receipts before final closeout.
- Which actors may assert review, merge, cancellation, and operator decisions.
- Whether the first version supports both sequential and parallel generations.
- How much provider evidence is copied versus linked and hash-bound.
- Whether exceptional human limitations remain in the task Markdown or receive
  a typed annotation fragment.

This note is planning intake only. Do not implement or migrate lifecycle state
until the model and proof plan are confirmed.
