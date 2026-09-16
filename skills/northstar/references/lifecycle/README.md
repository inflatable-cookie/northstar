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
  tasks/gNN.NNN.json              # per-task records for open/active generations
  generations/gNN.json            # compact receipt; replaces covered task fragments
  generations/gNN.closure.json    # closure authority, written by the rollover
  projection-targets.json         # declared surfaces + active generation set
```

JSON is canonical. The Markdown block inside a task or front-door file is a
derived projection. When the two disagree, the record wins.

Once a generation is closed by committed authority, its compact receipt is the
live machine record: receipt publication consumes exactly the covered task
fragments. Git history keeps every removed detailed record.

## Schemas

| Schema | Owns |
| --- | --- |
| [`transition-envelope.schema.json`](./transition-envelope.schema.json) | Adapter-submitted transition request |
| [`task-record.schema.json`](./task-record.schema.json) | Canonical per-task mechanical state |
| [`evidence.schema.json`](./evidence.schema.json) | One compact evidence entry |
| [`projection.schema.json`](./projection.schema.json) | Generated Markdown block metadata |
| [`generation-closure.schema.json`](./generation-closure.schema.json) | Explicit generation closure authority |
| [`generation-receipt.schema.json`](./generation-receipt.schema.json) | Durable compact receipt for a consumed closed generation |
| [`queue-event.schema.json`](./queue-event.schema.json) | Frozen Queue generic event contract v1 (closed mirror) |
| [`queue-event-v2.schema.json`](./queue-event-v2.schema.json) | Frozen Queue generic event contract v2 with the closed `repository.target` (closed mirror) |
| [`queue-event-v3.schema.json`](./queue-event-v3.schema.json) | Frozen Queue generic event contract v3 with the closed `prospective_merge` target and `mergeCandidate` (closed mirror) |
| [`queue-result.schema.json`](./queue-result.schema.json) | Frozen Queue hook-result contract (closed mirror) |
| [`queue-control.schema.json`](./queue-control.schema.json) | Frozen Queue control-manifest contract v1 (closed mirror) |
| [`queue-control-v2.schema.json`](./queue-control-v2.schema.json) | Frozen Queue control-manifest contract v2 with the trusted-runner program union (closed mirror) |
| [`queue-control-v3.schema.json`](./queue-control-v3.schema.json) | Frozen Queue control-manifest contract v3 with the closed hook `target` (closed mirror) |
| [`queue-control-v4.schema.json`](./queue-control-v4.schema.json) | Frozen Queue control-manifest contract v4 with the closed `prospective_merge` hook target (closed mirror) |

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

Generated projections carry both axes: the block names each declared active
generation, its disposition, and its runway state above the canonical task
table, and the source digest binds the state and entries together. The active
generation set comes from `projection-targets.json` (schema
`northstar.lifecycle.projection-targets.v2`); rollover updates that declaration
explicitly.

## Active-generation declaration

The v2 config declares the active generation set with exactly one of two
exclusive keys; declaring both, neither, or a malformed set fails closed
before any mutation:

- `"active_generation": "gNN"` — the sequential form. One declared active
  generation. The copy-ready starter template uses only this form, and
  sequential consumers never migrate to the plural key.
- `"active_generations": ["gNN", ...]` — the parallel form for repositories
  that legitimately run more than one generation. It must be a non-empty,
  lexically sorted, duplicate-free list; unsorted input is rejected rather
  than silently reordered.

Both forms normalize to one active-generation set internally, and a task
transition is valid only when its generation is in that set: an envelope for
an undeclared generation refuses before any byte changes, with or without
render targets. The plural form records an already-authorized repository
mode; it never grants parallel planning authority by itself — the
repository's own roadmap mode must authorize the declared set, and rollover,
closure, and compaction stay human-owned decisions. Rendering stays
deterministic for both forms: the singular shape renders exactly one
generation row and byte-identical historical output, while the parallel shape
renders one row per active generation in lexical order above one task table
whose entries stay grouped by generation and task id.

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

Publication consumes the fragments the receipt covers, so a closed generation
keeps exactly one live machine representation:

- with the exact full fragment set and no receipt, the canonical receipt is
  written first and then exactly those fragments are deleted;
- with a valid receipt plus remaining exact fragments, only the remainder is
  deleted — the crash-safe catch-up path after an interrupted cleanup;
- with a valid receipt and no fragments, the operation is unchanged and the
  receipt bytes are never rewritten;
- a partial fragment set without a receipt, a nonterminal record, a stale or
  conflicting closure, a malformed receipt, a symlinked fragment, or an
  escaping path refuses before any write or deletion.

`catch-up` discovers every committed closed generation in lexical order and
does the same work for all of them in one locked pass. Open and
`planning_required` generations are outside deletion authority and stay
byte-for-byte untouched. The Queue hook adapter invokes the same catch-up
during `task.closeout`, so a current terminal transition and every eligible
historical generation publish in one integration result with exact
`changed_paths`. Receipts keep the canonical terminal summaries, the source
task-set digest, and the closure digest, so dependency resolution and
currentness audit can still resolve a compacted closed generation without
resurrecting a per-task fragment.

## Generic Queue hook adapter

Queue integration is live behind the frozen generic contracts: schemas
`paseo.queue.control.v1`, `paseo.queue.control.v2`, `paseo.queue.control.v3`,
`paseo.queue.control.v4`, `paseo.queue.event.v1`, `paseo.queue.event.v2`,
`paseo.queue.event.v3`, and
`paseo.queue.hook-result.v1`; events `task.pre_dispatch`, `task.pre_merge`,
`task.blocked`, `task.cancelled`, and `task.closeout`. v1 pins a committed
repository executable; v2 adds a closed program union whose `trusted_runner`
variant names only an operator-approved runner ID with literal arguments; v3
adds one closed `target`, and `task.pre_merge` requires `reviewed_head`; v4
extends that closed target set with `prospective_merge`, which is Northstar's
adopted default and what the dogfood and copy-ready manifests declare, and a v3
event carries the closed `mergeCandidate` (40-hex integration base, reviewed
head, candidate commit, and candidate tree) for that target only. The v3
`reviewed_head` binding stays accepted unchanged for existing consumers; the
bounded migration command below moves a conforming v3 manifest to v4 without
touching any other byte. Queue
stays document-system agnostic — it never learns Northstar paths, task IDs,
commands, or Markdown.

The installed adapter is
[`../../scripts/lifecycle-queue-hook.ts`](../../scripts/lifecycle-queue-hook.ts).
The one manifest parser both the adapter and the migration command use is
[`../../scripts/lifecycle-manifest.ts`](../../scripts/lifecycle-manifest.ts):
the schema name selects the frozen contract mirror and the binding cross-rules
the JSON schema cannot express are enforced exactly once, so the hook and the
migration can never disagree about the accepted shape.
It reads one closed event on stdin, reconstructs the exact Northstar task and
planning identity from the committed handoff and task history, maps the event
to the same canonical transition envelopes the standalone adapter submits,
pre-passes the whole chain through the pure reducer before touching a byte,
and returns one closed hook result. Committed contract mirrors live beside
the lifecycle schemas: `queue-event.schema.json`,
`queue-event-v2.schema.json`, `queue-event-v3.schema.json`, `queue-result.schema.json`,
`queue-control.schema.json`, `queue-control-v2.schema.json`,
`queue-control-v3.schema.json`, and `queue-control-v4.schema.json`. The bounded exact-backlink resolver lives in
[`../../scripts/lifecycle-backlink.ts`](../../scripts/lifecycle-backlink.ts),
an import-safe module both the pre-merge gate and the closeout guard call, so
the transient-handoff invariant has exactly one parser and one set of bounds.

Canonical source lives in this skill, and the skill is the only runtime. The
skill catalog exposes the adapter as the task `northstar/queue:hook`, and the
control manifest selects Queue's trusted runner `effigy` with the frozen
literal argv `["skill", "run", "northstar/queue:hook", "--stdio",
"passthrough"]`. Queue resolves the approved runner artifact on the host,
Effigy resolves the skill from the consumer repository first and then a unique
global install, and the consumer repository stays the execution target and
working directory. Every skill-owned script is anchored with `{skill}`, so no
task resolves implementation code relative to the consumer. No repository
commits a launcher, a copied adapter, or copied schemas, and no host path,
digest, or installation hint enters Git. The trust boundary is the
operator-approved host state: the approved runner artifact and the installed
skill. A missing runner, a missing skill, or an ambiguous global install fails
closed before any process runs; there is no fallback closeout route. The
adapter still accepts v1 manifests so existing repositories keep working until
they migrate, and no program transport detail — runner IDs, argv, digests —
enters lifecycle records or projections.

Event mapping:

- `task.pre_dispatch` (read-only gate): verifies the instruction artifact
  digest and that the planning identity reconstructed from committed task
  history matches any existing record. Never writes.
- `task.pre_merge` (read-only gate at `target: reviewed_head`, the legacy v3
  binding that stays accepted): Queue runs it
  in the retained task workspace at the accepted exact PR head, after the
  reviewer verdict and before merge. It binds the pinned instruction artifact
to that head and runs the shared backlink resolver against the exact submitted
  handoff. A tracked durable Markdown link to that handoff refuses, naming the
  linking path; Queue returns the same PR and workspace to the retained worker
  as the next ordinary semantic revision. The gate changes no bytes, so it
  returns no changed paths and no commit subject. This is the same resolver and
  the same bounds the closeout guard uses, so the routine worker defect is
  corrected before merge rather than after.
- `task.pre_merge` (read-only gate at `target: prospective_merge`, the v4
  default): Queue runs
  it in its own candidate checkout after accepting the candidate, before merge.
  The v3 event carries the closed `mergeCandidate`; the gate proves the checkout
  HEAD and tree equal the candidate commit and tree, the repository base equals
  the integration base, the delivery head equals the reviewed head, and the
  candidate's two parents are base then head — then reuses the same pinned
  instruction proof and shared backlink resolver on the candidate tree. Any
  identity mismatch, wrong schema/target pair, or durable backlink refuses
  read-only with no changed paths and no commit subject.
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
  The same run also catches up every eligible historical closed generation,
  so the terminal transition and the compact receipts and exact fragment
  deletions it authorizes publish in one integration result.

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
`.northstar/lifecycle/v1/projection-targets.json` (which declares the active
generation set with exactly one of `active_generation` or the sorted,
duplicate-free `active_generations` list); a task file opts into
currentness by already carrying a generated block. Declare every currentness
view — the root front door, the roadmaps front door, and each active
generation README — and change the declared targets explicitly when a
generation rolls over.

Closeout consumes the instruction handoff. The `task.closeout` publication is
one integration commit: the terminal record, the regenerated declared
projections, the removal of the exact submitted handoff, and every catch-up
compaction the closure records authorize. The hook deletes
only the exact committed path whose working-tree bytes still hash to the
pinned blob digest, and only after the terminal receipt exists. The same
shared backlink guard the pre-merge gate runs refuses closeout
atomically when durable Markdown still links to that exact handoff: the hook
resolves relative, rooted, and reference-style Markdown links
(through their definitions), ignores external URLs
and the handoff itself, and only an exact local target blocks — so deletion
never strands a backlink. The scan reads the NUL-delimited tracked-file listing
within a finite 4 MiB transport bound, admits at most 25,000 tracked Markdown
files and 64 MiB of aggregate Markdown bytes, then reads one file at a time
within a finite 4 MiB per-file bound. Aggregate sizes are preflighted from
`lstat` before content is read; larger listings fail with bounded process
evidence and larger files or aggregates refuse before any byte changes. A changed,
missing (non-terminal record), symlinked, or otherwise ambiguous handoff
fails closed before any byte changes; when the record is already terminal, a
still-present exact handoff is consumed as an idempotent no-diff cleanup and
an absent one is the normal replay shape. The manifest must declare the
handoff directory in the closeout hook's `allowedPaths` for the cleanup to
publish. Git retains the blob; the record's `evidence.handoff` entry retains
its identity. `task.blocked` and `task.cancelled` never touch the handoff:
the task may resume and the instruction stays authoritative.

## Queue control manifest migration

Northstar's dogfood and copy-ready manifests declare
`paseo.queue.control.v4` with the required read-only `task.pre_merge` hook at
`prospective_merge`. An existing conforming v3 consumer moves to that shape
with one bounded installed-skill command. It is a configuration migration, not
a lifecycle transition: it never stages, commits, pushes, dispatches, or edits
planning.

```bash
# dry run (default): report the exact one-file/two-value edit, write nothing
effigy skill run northstar/lifecycle:migrate-premerge --repo /path/to/consumer

# apply the already-proved edit atomically
effigy skill run northstar/lifecycle:migrate-premerge --repo /path/to/consumer -- --write
```

Run it against the consumer root (or pass `--repo`); the consumer repository is
the execution target. Dry run reports the change set without writing. Write
mode replaces only `.paseo/queue.json`, validates the result against the frozen
v4 grammar, re-reads and verifies the written bytes, and returns the changed
path and required commit action; the consumer's own integration owner commits
it. Replay on a conforming v4 manifest is an `unchanged` no-op, including
while that migration commit is still uncommitted.

Accepted input is exactly one committed, conforming v3 manifest: a single
required read-only `task.pre_merge` hook at `reviewed_head`, every hook using
the frozen trusted-runner transport (`effigy` with the literal Queue hook
argv), no reserved path in `allowedPaths`, and the two literal tokens
(`"paseo.queue.control.v3"` and `"reviewed_head"`) each appearing exactly
once. Anything else refuses before any byte changes: an older schema, a custom
or non-Effigy program, several or missing `task.pre_merge` bindings, an invalid
or ambiguous document, a v4 manifest still targeting `reviewed_head`, a
symlinked manifest, a manifest not committed to Git, or a manifest with
uncommitted changes.

The JSON result contract is:

```json
{
  "status": "dry_run | applied | unchanged",
  "command": "lifecycle/migrate-premerge",
  "manifest": ".paseo/queue.json",
  "schema_before": "paseo.queue.control.v3",
  "schema_after": "paseo.queue.control.v4",
  "pre_merge_hook": "repository-pre-merge",
  "pre_merge_target_before": "reviewed_head",
  "pre_merge_target_after": "prospective_merge",
  "changes": [
    { "path": ".paseo/queue.json", "field": "schema", "from": "paseo.queue.control.v3", "to": "paseo.queue.control.v4" },
    { "path": ".paseo/queue.json", "field": "hooks[<hook id>].target", "from": "reviewed_head", "to": "prospective_merge" }
  ],
  "changed_paths": [".paseo/queue.json"],
  "pending_paths": [".paseo/queue.json"],
  "digest_before": "sha256:...",
  "digest_after": "sha256:...",
  "commit_action": { "required": true, "paths": [".paseo/queue.json"] }
}
```

`changed_paths` names what write mode actually wrote and stays empty in dry
run; `pending_paths` names the value awaiting the integration commit.
`unchanged` carries empty change, changed-path, and pending-path lists,
`digest_before` equal to `digest_after`, and `commit_action.required: false`.
A refusal prints `{"status":"error","code":"...","message":"..."}` and
exits non-zero. The command supplies evidence; it owns no Git or planning
authority.

## Commands

From the Northstar source checkout:

```bash
effigy lifecycle:run oracle
effigy lifecycle:run status --repo /path/to/repo
effigy lifecycle:run frontier --repo /path/to/repo
effigy lifecycle:run audit-currentness --repo /path/to/repo
effigy lifecycle:run apply --repo /path/to/repo --envelope envelope.json [--target docs/roadmaps/gNN/README.md]...
effigy lifecycle:run render --repo /path/to/repo --records .northstar/lifecycle/v1/tasks --target docs/roadmaps/gNN/README.md
effigy lifecycle:run tasks-digest --repo /path/to/repo --records .northstar/lifecycle/v1/tasks --generation gNN
effigy lifecycle:run compact --repo /path/to/repo --records .northstar/lifecycle/v1/tasks --generation gNN --out .northstar/lifecycle/v1/generations/gNN.json
effigy lifecycle:run catch-up --repo /path/to/repo
effigy check:lifecycle-core
effigy check:lifecycle-adoption
```

`apply` accepts repeatable `--target` flags; every target is
containment- and symlink-checked before any mutation, regenerated inside the
record write lock, and reported in the exact changed-path list. Rendering a
projection requires `projection-targets.json` to declare the active
generation set (the singular key or the parallel list). Explicit-path
`render`, `tasks-digest`, and `compact` re-check
containment for the records directory and the output path and refuse escaping,
absolute-outside, or symlinked paths. `compact` publishes the canonical
receipt and deletes exactly the fragments it covers, under the lifecycle lock;
`catch-up` does the same for every committed closed generation in lexical
order. `tasks-digest` reads the receipt's source digest once a generation is
already compacted, so closure authoring and later audit stay stable across the
pruning boundary. The command returns changed paths, the
new revision and digest, and the required commit action. It never stages,
commits, pushes, merges, dispatches, or selects the next task.

`audit-currentness` proves the sole-source cutover: it walks lifecycle-record
task paths and declared projection targets outside generated blocks and
reports exact file, section, task, and reason for every hand-maintained
`Status:` header, every live-currentness section or Next-task table column
naming a terminal task, and every record whose task file is missing. Goal
history and retrospective sections stay legal; the adoption self-test holds
the Silo-shaped negatives and the cutover positives.

From an installed skill, the same command resolves through the skill catalog
as `northstar/lifecycle:run` or `northstar/lifecycle:oracle`, and the manifest
migration resolves as `northstar/lifecycle:migrate-premerge`; every
skill-owned script is `{skill}`-anchored, so the consumer repository stays the
runtime target. The Queue hook adapter resolves the same way as
`northstar/queue:hook` and expects the closed event JSON on raw stdin with
Queue's `PASEO_QUEUE_EVENT_ID` and `PASEO_QUEUE_EVENT_SCHEMA` environment
variables set.
