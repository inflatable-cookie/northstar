# Portable Task Lifecycle

Status: active
Owner: repo maintainers
Governing refs: spec 040, system architecture, contract 001

This directory carries the provider-neutral task lifecycle contract: Draft
2020-12 schemas plus the doctrine for the reducer, standalone adapter, and
deterministic Markdown projector implemented in
[`../../scripts/lifecycle-core.ts`](../../scripts/lifecycle-core.ts).

The installed skill runs the whole surface without Paseo, Queue, network
access, a daemon, a database, or the Northstar source checkout. Queue
repository hooks are deliberately outside this lane; they submit the same
transition envelope later.

## Artifact set

Live records use one path per task:

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json        # derived only when a generation is closed
```

JSON is canonical. The Markdown block inside a task or front-door file is a
derived projection. When the two disagree, the record wins.

## Schemas

| Schema | Owns |
| --- | --- |
| [`transition-envelope.schema.json`](./transition-envelope.schema.json) | Adapter-submitted transition request |
| [`task-record.schema.json`](./task-record.schema.json) | Canonical per-task mechanical state |
| [`evidence.schema.json`](./evidence.schema.json) | One compact evidence entry |
| [`projection.schema.json`](./projection.schema.json) | Generated Markdown block metadata |

## Status and stage

Status answers whether a task may or did proceed:

`planned`, `ready`, `active`, `blocked`, `complete`, `cancelled`, `superseded`.

Stage locates active or blocked work:

`none`, `dispatch`, `implementation`, `review`, `merge`, `closeout`.

Terminal statuses use `none`. A blocked record keeps its prior status, prior
stage, typed reason, and explicit resume target. Adapter phases and Queue
terminology never become a second Northstar status.

## Transitions

The vocabulary is `plan`, `ready`, `start`, `advance_stage`, `block`, `resume`,
`complete`, `cancel`, and `supersede`.

`advance_stage` is the only movement verb. Its legal edges are monotonic:

```text
dispatch -> implementation -> review -> merge -> closeout
```

The one declared exception is the review revision `review -> implementation`.
It requires a reason and clears the review, merge, integration, and validation
evidence that no longer covers the head. It does not create a new status.

## Envelope and digests

Every authority-changing call submits `northstar.lifecycle.transition.v1` with
a stable event ID, exact task and planning identity, expected revision and
digest, transition, event time, actor, source adapter, and transition-specific
evidence.

Frozen framing:

- canonical JSON sorts object keys and preserves array order;
- `sha256:<64 lowercase hex>` is the only digest spelling;
- the record digest covers the canonical record without its `digest` field;
- the portable digest excludes `digest`, `portable_digest`, `adapter`, and
  `applied_events`, so different adapters reduce to the same receipt;
- the task-blob digest is taken over the exact committed task-markdown bytes;
- a repeated event ID with identical content returns the recorded revision and
  digest; reusing it with different content fails.

## Evidence levels

`locally_verified`, `adapter_attested`, and `operator_authorized` are preserved
exactly. The core verifies Git object existence, ancestry, file identity, and
local validation receipts. It cannot verify provider state, so a
`locally_verified` PR or review claim fails closed. Nothing upgrades an
attestation into independent or cryptographic proof.

Completion requires merge, synchronized-main, validation, and closeout handoff
evidence. Standard delivery also requires a PR and an accepted review at the
exact merged head. A declared `direct_delivery` or `review_skip` policy needs an
exact `operator_authorized` authorization reference.

## Standalone write protocol

Authority-changing writes:

1. verify repository root, integration branch, task path, and planning identity;
2. acquire a lock under Git's common directory;
3. reread and compare the expected revision and digest;
4. validate without mutation;
5. write canonical JSON through a same-directory temporary file, flush, and
   atomic rename;
6. regenerate a selected projection inside the same lock when `--target` is
   given;
7. return changed paths, the new revision and digest, and the required commit
   action.

The core never stages, commits, pushes, merges, dispatches, reviews, or selects
work. A losing writer rereads and replays the unchanged envelope; it never
force-pushes or hand-merges lifecycle JSON.

## Deterministic Markdown

Generated blocks use stable sentinels, a schema version, a source digest, fixed
columns, and canonical task ordering. Narrative outside the sentinels is
human-owned and preserved byte-for-byte. Rendering the same receipt set twice
produces no diff, and a hand-edited block fails verification.

## Frontier and compaction

`frontier` returns eligible `ready` tasks only. It never picks priority or
invents work; an empty runway returns `planning_required`. `compact` reduces a
closed generation of terminal records into one generation receipt with source
digests.

## Deferred Queue integration

`.paseo/queue.json`, Queue event/result contracts, generic repository hooks, and
live Northstar status migration are later lanes. The copy-ready starter guidance
ships at `template-bundle/lifecycle/README.md` and is explicitly marked deferred.

## Commands

From the Northstar source checkout:

```bash
effigy lifecycle:run oracle
effigy lifecycle:run status --repo /path/to/repo
effigy lifecycle:run frontier --repo /path/to/repo
effigy lifecycle:run apply --repo /path/to/repo --envelope envelope.json [--target docs/roadmaps/gNN/README.md]
effigy lifecycle:run render --records /path/to/.northstar/lifecycle/v1/tasks --target docs/roadmaps/gNN/README.md
effigy check:lifecycle-core
```

From an installed skill, the same command resolves as
`northstar/lifecycle:run` or directly as
`bun run <installed>/scripts/lifecycle-core.ts <verb>`.
