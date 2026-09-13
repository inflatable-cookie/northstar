# Portable Task Lifecycle

Status: active
Owner: repo maintainers
Governing refs: system architecture, contract 001, bundle section 12

This directory carries the provider-neutral task lifecycle contract: Draft
2020-12 schemas plus the doctrine for the reducer, standalone adapter, and
deterministic Markdown projector implemented in
[`../../scripts/lifecycle-core.ts`](../../scripts/lifecycle-core.ts).

The installed skill runs the whole surface without Paseo, Queue, network
access, a daemon, a database, or the Northstar source checkout. Queue is an
optional driver of the same reducer: its generic repository events reach the
standalone core through the Northstar-owned hook adapter described below.

## Artifact set

Live records use one path per task, and closure uses one explicit record per
generation:

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json            # compaction receipt, written by compact
  generations/gNN.closure.json    # closure authority, written by the rollover
  projection-targets.json         # declared surfaces + active generation
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
| [`generation-closure.schema.json`](./generation-closure.schema.json) | Explicit generation closure authority |
| [`queue-event.schema.json`](./queue-event.schema.json) | Frozen Queue generic event contract (closed mirror) |
| [`queue-result.schema.json`](./queue-result.schema.json) | Frozen Queue hook-result contract (closed mirror) |
| [`queue-control.schema.json`](./queue-control.schema.json) | Frozen Queue control-manifest contract (closed mirror) |

## Status and stage

Status answers whether a task may or did proceed:

`planned`, `ready`, `active`, `blocked`, `complete`, `cancelled`, `superseded`.

Stage locates active or blocked work:

`none`, `dispatch`, `implementation`, `review`, `merge`, `closeout`.

Terminal statuses use `none`. A blocked record keeps its prior status, prior
stage, typed reason, and explicit resume target. Adapter phases and Queue
terminology never become a second Northstar status.

## Generation disposition and runway state

Generation state has two separate axes, and they never collapse into each
other:

- **Disposition** is `open` or `closed`. It changes only when a closure record
  is committed at `generations/gNN.closure.json`; absence of the record is the
  open disposition. `complete` is never a generation disposition.
- **Runway state** is derived mechanically from the generation's task records:
  `active`, `ready`, `blocked`, `planned`, or `planning_required`. Precedence
  is exactly that order — live work outranks dispatchable work, which outranks
  a declared blocker, which outranks unstarted plans. `planning_required` is
  the exhausted state: no nonterminal approved work remains. It keeps the same
  generation open and asks planning to extend it or make a reasoned rollover
  decision; it never implies completion, closure, or a next generation.

An open generation whose records are all terminal projects
`planning_required`. Nonterminal records never collapse into it: mixed ready,
active, blocked, and planned work stays visible under the bounded vocabulary.
Planning a new task into the same generation moves the runway out of
`planning_required` through the normal lifecycle path — no hand-edited status
mirror exists. A closure record seals its generation: every transition against
that generation's tasks refuses, and compaction refuses an open generation.

Generated projections carry both axes: the block names the declared active
generation, its disposition, and its runway state above the canonical task
table, and the source digest binds the state and entries together. The active
generation comes from `projection-targets.json` (schema
`northstar.lifecycle.projection-targets.v2`); rollover updates that declaration
explicitly.

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
evidence. Synchronized main must contain the merge commit in its ancestry:
main may lawfully advance between merge and closeout (interleaved
publications, closeout Markdown), so ancestry — not equality — is the durable
local proof, verified by Git when the entry is `locally_verified`.
Standard delivery also requires a PR and an accepted review at the
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

`frontier` reports the active generation's derived runway state plus the
eligible `ready` tasks. It never picks priority or invents work;
`planning_required` means no nonterminal approved work remains — a planning
decision is requested, not a rollover.

Compaction is destructive lifecycle maintenance, so terminal records are
necessary but never sufficient. `compact` requires the generation's committed
closure record and refuses missing, open, stale, mismatched, or ambiguous
authority before producing a receipt: the record must name the generation, say
`closed`, and pin the exact terminal task set via `tasks_digest` (printed by
`tasks-digest`). The receipt records the closure digest as provenance. Rollover
authors the closure record only after the preservation oracle passes; it is a
human-owned sequencing decision, never a reducer transition.

## Generic Queue hook adapter

Queue integration is live behind the frozen generic contracts at Queue
`2c528543b00147556acd4a5ed74b3784d0fee056` (contract 005, spec 001): schemas
`paseo.queue.control.v1`, `paseo.queue.event.v1`, and
`paseo.queue.hook-result.v1`; events `task.pre_dispatch`, `task.blocked`,
`task.cancelled`, and `task.closeout`. Queue stays document-system agnostic —
it never learns Northstar paths, task IDs, commands, or Markdown.

The installed adapter is [`../../scripts/lifecycle-queue-hook.ts`](../../scripts/lifecycle-queue-hook.ts).
It reads one closed event on stdin, reconstructs the exact Northstar task and
planning identity from the committed handoff and task history, maps the event
to the same canonical transition envelopes the standalone adapter submits,
pre-passes the whole chain through the pure reducer before touching a byte,
and returns one closed hook result. Committed contract mirrors live beside
the lifecycle schemas: `queue-event.schema.json`, `queue-result.schema.json`,
and `queue-control.schema.json`.

Canonical source lives in this skill. A repository that declares the hook
commits a byte-identical copy of the whole runtime closure under its own hooks
directory: the launcher, the adapter, the reducer, and every
`references/lifecycle/*.schema.json`. The committed launcher resolves only those
bytes — never `$HOME`, a globally installed skill, `PATH`, the network, or the
Northstar source checkout — so a stale or hostile installation cannot change
what Queue executes. The launcher template is
[`../../assets/templates/lifecycle-hook-launcher.sh`](../../assets/templates/lifecycle-hook-launcher.sh)
and [`../../scripts/lifecycle-runtime.ts`](../../scripts/lifecycle-runtime.ts)
is the one deterministic build and parity oracle: `copy` writes or refreshes
the payload, and `check` fails on any missing, extra, or differing byte in
code, schema, launcher bytes, or the executable bit. Copies are generated,
never hand-maintained; the closure is derived, so every committed schema joins
it automatically.

Event mapping:

- `task.pre_dispatch` (read-only gate): verifies the instruction artifact
  digest and that the planning identity reconstructed from committed task
  history matches any existing record. Never writes.
- `task.blocked` / `task.cancelled` (integration-write): applies a durable
  `block` or `cancel` transition when a record exists; returns `ok` with an
  explicit skip reason when no record exists yet — the durable state then
  lives in Queue only, and the repository record never fabricates one.
- `task.closeout` (integration-write): the cutover path. When no record
  exists (the bootstrap case), it deterministically reduces the canonical
  sequence from the reconstructed ready planning identity to a terminal
  receipt using derived stable event IDs (`queue-<hash>-<seq>-<transition>`).
  It never fabricates transient observations or claims earlier live tracking.
  A repeated event is a no-diff replay; a completed record is never rewritten.

Evidence levels are preserved, never upgraded: PR, review, and validation
facts arrive through Queue's delivery object and are recorded
`adapter_attested`; merge ancestry, synchronized main, and the instruction
blob digest are locally verified Git facts recorded `locally_verified`. A
delivery whose merge commit does not contain the reviewed head (a squash or
rebase merge) is refused rather than fabricated.

Writes are bounded twice: the adapter checks its computed changed paths
against the manifest `allowedPaths` before writing, and Queue independently
validates, stages, commits, and pushes exactly those paths. Projection
targets come from the repository-declared
`.northstar/lifecycle/v1/projection-targets.json`; a task file opts into
currentness by already carrying a generated block. Declare every currentness
view — the root front door, the roadmaps front door, and the active
generation README — and change the declared targets explicitly when a
generation rolls over.

Closeout consumes the instruction handoff. The `task.closeout` publication is
one integration commit: the terminal record, the regenerated declared
projections, and the removal of the exact submitted handoff. The hook deletes
only the exact committed path whose working-tree bytes still hash to the
pinned blob digest, and only after the terminal receipt exists. A changed,
missing (non-terminal record), symlinked, or otherwise ambiguous handoff
fails closed before any byte changes; when the record is already terminal, a
still-present exact handoff is consumed as an idempotent no-diff cleanup and
an absent one is the normal replay shape. The manifest must declare the
handoff directory in the closeout hook's `allowedPaths` for the cleanup to
publish. Git retains the blob; the record's `evidence.handoff` entry retains
its identity. `task.blocked` and `task.cancelled` never touch the handoff:
the task may resume and the instruction stays authoritative.

## Commands

From the Northstar source checkout:

```bash
effigy lifecycle:run oracle
effigy lifecycle:run status --repo /path/to/repo
effigy lifecycle:run frontier --repo /path/to/repo
effigy lifecycle:run apply --repo /path/to/repo --envelope envelope.json [--target docs/roadmaps/gNN/README.md]...
effigy lifecycle:run render --repo /path/to/repo --records .northstar/lifecycle/v1/tasks --target docs/roadmaps/gNN/README.md
effigy lifecycle:run tasks-digest --repo /path/to/repo --records .northstar/lifecycle/v1/tasks --generation gNN
effigy lifecycle:run compact --repo /path/to/repo --records .northstar/lifecycle/v1/tasks --generation gNN --out .northstar/lifecycle/v1/generations/gNN.json
effigy check:lifecycle-core
effigy check:lifecycle-adoption
```

`apply` accepts repeatable `--target` flags; every target is
containment- and symlink-checked before any mutation, regenerated inside the
record write lock, and reported in the exact changed-path list. Rendering a
projection requires `projection-targets.json` to declare the active
generation. Explicit-path `render`, `tasks-digest`, and `compact` re-check
containment for the records directory and the output path and refuse escaping,
absolute-outside, or symlinked paths. The command returns changed paths, the
new revision and digest, and the required commit action. It never stages,
commits, pushes, merges, dispatches, or selects the next task.

From an installed skill, the same command resolves as
`northstar/lifecycle:run` or directly as
`bun run <installed>/scripts/lifecycle-core.ts <verb>`.

Install or verify the committed Queue hook runtime from an installed skill:

```bash
bun run <installed-northstar>/scripts/lifecycle-runtime.ts copy [--hooks .paseo/hooks]
bun run <installed-northstar>/scripts/lifecycle-runtime.ts check [--hooks .paseo/hooks]
bun run <installed-northstar>/scripts/lifecycle-runtime.ts closure
```

`copy` defaults to `.paseo/hooks` relative to the working directory and is the
only supported way to write the payload. Commit the result and re-run `copy`
after the installed skill changes; `check` drives the drift gate.
