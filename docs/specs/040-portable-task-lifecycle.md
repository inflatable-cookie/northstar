# 040 - Portable Task Lifecycle

Status: active
Owner: repo maintainers
Created: 2026-09-12
Governing refs: system architecture, contract 001
Execution: `g03.005` complete; Queue generic hooks next; `g03.006` adoption after

## Problem

Northstar still asks agents to rewrite mechanical lifecycle facts across task
files, generation runways, front doors, evidence, handoffs, and spec state.
Closeout is slow, repetitive, and prone to drift. A single repository JSON
ledger would replace prose churn with a merge hotspot. Requiring Paseo Queue
would make Northstar non-portable, while rebuilding Queue's transactional engine
inside Northstar would duplicate working infrastructure.

## Confirmed operating model

Northstar owns a provider-neutral lifecycle core. It defines task states,
transition envelopes, canonical receipts, validation, compaction input, and
deterministic Markdown projections. It ships with a standalone adapter and is
complete without Paseo or Queue.

Queue remains an optional live orchestration runtime. It owns scheduling,
leases, callbacks, retries, recovery, agents, provider interaction, and rich
queryable history. Queue emits generic repository events to hooks declared by
the repository. It does not import Northstar, parse Northstar documents, or
know Northstar commands and paths.

A Northstar repository installs a Queue control manifest whose hooks translate
generic Queue events into the same Northstar transition envelopes used by the
standalone adapter. Equivalent facts must produce the same terminal Northstar
receipt in both modes.

## Authority boundaries

- Task Markdown owns outcome, scope, decisions, acceptance, stop conditions,
  execution policy, and UI brief.
- Per-task JSON owns portable mechanical state and evidence.
- Queue's database owns fresher in-flight Queue runtime state.
- Generated Markdown blocks expose deterministic human-readable projections.
- Generation runway intent remains human-authored. A projector may update task
  state and frontier views but cannot choose priority, invent a semantic next
  task, retire a spec, or discard unique meaning.
- Workers and reviewers never edit lifecycle records or shared projections.
  The standalone integration owner or Queue integration hook applies them.

## Portable state model

Task status is one of:

- `planned`
- `ready`
- `active`
- `blocked`
- `complete`
- `cancelled`
- `superseded`

Execution stage is one of:

- `none`
- `dispatch`
- `implementation`
- `review`
- `merge`
- `closeout`

Status answers whether the task may or did proceed. Stage locates active or
blocked work. Terminal statuses use `none`. A blocked record carries its prior
status, stage, typed reason, and explicit resume target.

The core transition vocabulary is `plan`, `ready`, `start`, `advance_stage`,
`block`, `resume`, `complete`, `cancel`, and `supersede`. Review revision moves
from `review` to `implementation` without inventing a new task status.

## Artifact set

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json        # derived only when committed
```

Each current task record contains:

- schema version, canonical task ID, task path, generation, planning commit,
  and task-blob digest;
- revision, record digest, status, stage, block/resume data, and canonical
  dependency references;
- approved delivery/review policy and exact exceptional authorization refs;
- implementation, PR, review, verification, merge, integration, validation,
  handoff, limitation, and continuation evidence when applicable;
- source adapter metadata isolated from portable fields; and
- a compact applied-event list for durable idempotency.

Git history preserves prior record bodies. The record does not copy Queue's
heartbeat, notification, retry, or complete event stream. Closed-generation
compaction may reduce verified task receipts into a generation receipt with
source digests.

## Transition envelope

Adapters submit `northstar.lifecycle.transition.v1`. The envelope carries:

- stable event ID;
- canonical task ID and path;
- expected record revision and digest;
- transition, event time, actor, and source adapter;
- planning identity; and
- transition-specific evidence.

Adapters cannot replace the canonical record. The core validates the envelope,
checks the current record, applies one legal transition, emits canonical JSON,
and returns the new revision and digest. A repeated event with identical content
returns the prior result. Reusing an event ID with different content fails.

The core rejects stale revisions, path escapes, task/path mismatch, missing or
changed planning identity, illegal transitions, dependency contradictions,
review/head mismatch, merge without the required accepted exact-head review,
and completion without merge, synchronized-main, validation, and closeout
evidence. A declared direct-delivery or review-skip policy requires an exact
operator authorization reference.

Evidence records distinguish what the core verified locally from what an
adapter or authorized actor attested. The core may verify Git object existence,
ancestry, file identity, and local validation receipts. A provider adapter may
attest PR state, published review identity, checks, and reviewer independence.
An operator may authorize a declared exception. Every record names its source,
actor, method, and verification level. The reducer preserves that level and
never upgrades an attestation into cryptographic or independent proof.

## Standalone adapter

The installed Northstar skill exposes the lifecycle command through Effigy and
a direct installed-skill fallback. It can inspect, verify, apply transitions,
render projections, report the frontier, and compact a closed generation.

Authority-changing writes:

1. verify repo root, integration branch, task path, and planning identity;
2. acquire a lifecycle lock under Git's common directory;
3. reread and compare the expected revision/digest;
4. validate without mutation;
5. write canonical JSON through same-directory temporary file, flush, and
   atomic rename;
6. regenerate selected projections; and
7. return changed paths, revision, digest, and required commit action.

The core does not stage, commit, push, merge, dispatch, review, or select work.
Those actions remain with the invoking Northstar mode. Different task paths
avoid cross-task content conflicts. Digest checks catch same-task stale writes.
A losing Git publisher updates, rereads, and replays the unchanged envelope;
it never force-pushes or merges lifecycle JSON by hand.

## Deterministic Markdown

Repository status remains browseable without tools. Task and front-door
Markdown contains generated blocks with:

- stable start/end sentinels;
- schema version and source digest;
- fixed labels or table columns;
- canonical task ordering;
- normalized line endings and byte-stable rendering.

Narrative outside the sentinels remains human-owned. Editing generated content
by hand fails verification. Rendering the same receipt set twice produces no
diff. JSON remains canonical when Markdown and state disagree.

## Generic Queue hook contract

Queue discovers optional `.paseo/queue.json` from an exact clean repository
commit. The manifest uses the Queue-owned `paseo.queue.control.v1` schema and
declares:

- committed instruction-artifact policy;
- event bindings;
- read-only gate or integration-write mode;
- required or advisory delivery;
- fixed executable and arguments;
- working tree and base requirements;
- time and output limits;
- allowed output paths; and
- bounded commit-message policy.

Queue sends `paseo.queue.event.v1` JSON through standard input. Event values are
never interpolated into commands. Hooks return
`paseo.queue.hook-result.v1`: matching event ID, outcome, bounded summary,
opaque metadata, changed paths, and an optional requested commit subject.

For integration writes, Queue verifies clean synchronized `main`, pins the
manifest commit and blob, runs with a minimal environment, validates output and
actual changed paths, stages only allowed paths, commits, pushes, verifies the
remote, and records the published identity. Required blocked or failed hooks do
not advance the task. Queue stores event intent transactionally before acting
and reconciles uncertain hook commits or pushes before retrying.

Northstar's starter supplies the hook manifest and installed-skill commands.
Other repositories may define different hooks or none. Queue-specific IDs are
opaque additive metadata in Northstar receipts.

Queue core should eventually accept a generic committed instruction artifact
(`path`, commit, blob digest, media type) instead of requiring `handoffPath`.
The Northstar handoff submitter resolves its committed Markdown into that
contract. The current Northstar-specific closeout prompt remains until generic
hooks prove parity, then retires rather than surviving as a second route.

## Durable checkpoints

Do not commit Queue heartbeats or every phase. Repository checkpoints are
required for:

- promotion to `ready`;
- durable block, cancellation, or supersession;
- accepted terminal closeout to `complete`; and
- generation closure and compaction.

Transient `active` stages may stay in Queue or standalone local runtime state.
The last repository checkpoint is conservative: it may lag activity but never
claims review, merge, or completion without durable proof.

## Delivery sequence

1. `g03.005` freezes schemas and implements the core, standalone adapter,
   deterministic renderer, and adversarial fixtures without migrating live
   Northstar status authority.
2. The Queue repository separately freezes and implements its generic control
   manifest, event/result schemas, instruction artifact, transactional hook
   outbox, and integration writer.
3. `g03.006` ships the Northstar hook adapter and starter manifest, adopts
   records and generated blocks in templates, doctrine, skills, and this
   repository, and proves the standalone path before enabling Queue writes.
4. The same task then maps Queue events to Northstar transitions, proves
   standalone/Queue receipt equivalence, and retires agent-written mechanical
   closeout only after one live shadow closeout passes. It may split the live
   cutover into a successor task if the shadow evidence cannot exist before its
   own merge; do not weaken the oracle to preserve a one-task shape.
5. Generation compaction adopts receipt roll-up only after current-generation
   closeout and preservation behavior has passed in both modes.

## Acceptance strategy

Required fixtures cover:

- the full legal transition matrix and every illegal edge;
- canonical JSON and byte-identical repeated Markdown rendering;
- repeated event, conflicting event reuse, stale revision, lock contention,
  interrupted write, and two-worktree same-task races;
- independent tasks completing in either order without shared receipt paths;
- exact-head review, revised head, review skip with authority, external merge,
  dirty integration checkout, and missing provider evidence;
- block/resume, cancellation, supersession, and `planning_required`;
- standalone operation with no Paseo, Queue, network, or source checkout;
- generic Queue events producing the same terminal receipt as equivalent
  standalone transitions; and
- generation receipt roll-up and repeat compaction with no churn.

Deterministic checks prove structure and state invariants. They do not replace
semantic review, establish reviewer independence by themselves, or choose
whether unresolved meaning may be discarded.

## Non-goals

- Making Paseo, Queue, GitHub, Effigy source, a daemon, or a database mandatory.
- Rebuilding Queue scheduling, callbacks, recovery, or provider routing.
- Copying Queue's full operational history into Git.
- A single mutable repository-wide task ledger.
- Remote webhooks, secrets, or hosted lifecycle services in version 1.
- Automatic task prioritization, semantic spec retirement, or generation
  rollover.
- Compatibility aliases after the new authority switches; callers migrate and
  obsolete manual projections retire together.

## Stop conditions

Stop and return to Chatterbox if implementation requires Queue knowledge inside
the Northstar core, Northstar document knowledge inside Queue core, arbitrary
shell interpolation, worker-owned lifecycle files, a shared mutable task ledger,
or a second authoritative status projection. Stop if the terminal-equivalence
oracle cannot be made provider-neutral or if automatic projection would discard
semantic runway or limitation text.
