# 12 - Portable Task Lifecycle

Status: active
Updated: 2026-09-13

## Purpose

Give mechanical task state one portable home so closeout stops rewriting facts
that Git, review systems, validation, and orchestration already know. The
contract must work with only the installed skill present.

## Boundary

Semantic planning stays in Markdown: outcome, scope, decisions, acceptance,
stop conditions, execution policy, and UI brief. A versioned per-task JSON
record owns portable mechanical state and delivery evidence. Generated Markdown
blocks are derived views. JSON is canonical when the two disagree.

The lifecycle core is provider-neutral. The standalone adapter drives it
directly, and a repository-declared Queue hook drives it through the same
envelopes. Equivalent facts must
reduce to the same terminal receipt in both modes. The core does not schedule,
dispatch, review, merge, or choose work.

## State model

Task status is one of `planned`, `ready`, `active`, `blocked`, `complete`,
`cancelled`, or `superseded`. Execution stage is `none`, `dispatch`,
`implementation`, `review`, `merge`, or `closeout`. Status answers whether a
task may or did proceed. Stage locates active or blocked work. Terminal
statuses use `none`. Adapter phrases never become a second status vocabulary.

Generation state is a separate axis and never borrows task words. Disposition
is `open` or `closed` and changes only when a closure record is committed at
`generations/gNN.closure.json`; absence of the record is open. Runway state is
mechanically derived from the generation's task records as `active`, `ready`,
`blocked`, `planned`, or `planning_required`, in that precedence order.
`planning_required` is the exhausted state of an open generation whose records
are all terminal: it keeps the same generation open and routes the next
move to planning. Nonterminal records never collapse into it, and `complete`
is never a generation disposition.

## Artifact set

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json            # compaction receipt, written by compact
  generations/gNN.closure.json    # closure authority, written by the rollover
  projection-targets.json         # declared surfaces + active generation set
```

One record per task. Git history preserves prior bodies. The record keeps a
compact applied-event list for idempotency, not a copy of runtime heartbeats or
retries.

## Writes

Authority-changing transitions use exact task and planning identity, stable
event IDs, revision/digest compare-and-swap, canonical JSON, a Git-common-
directory lock, and atomic replacement. Identical retries are no-ops. Stale,
conflicting, dirty, escaping, or interrupted writes fail without changing prior
bytes. Workers and reviewers never write lifecycle state; an integration owner
or declared hook applies it.

Repository checkpoints are required for promotion to `ready`, durable block,
cancellation, or supersession, accepted terminal closeout, and generation
closure. Closure is its own explicit artifact: the rollover commits the
closure record after the preservation oracle passes, and no reducer transition
or hook event ever infers it from an empty frontier. The last repository
checkpoint is conservative: it may lag live activity, but it never claims
review, merge, or completion without durable proof.

## Rendering

Generated blocks use stable sentinels, a schema version, a source digest, fixed
columns, and canonical ordering. Human text outside the sentinels is preserved
exactly. Re-rendering an unchanged receipt set produces no diff.

Every declared currentness view is a projection, not a hand-maintained mirror:
the repository root front door, the roadmaps front door, and each active
generation README belong in `projection-targets.json` once the lifecycle is
adopted. The projection block names each declared active generation, its
disposition, and its derived runway state above the canonical task table, and
binds state and entries into one source digest, so an exhausted runway renders
as `planning_required` — never as completion. Human prose outside the blocks
keeps semantic meaning but must not restate the active task, ready frontier,
runway state, or latest delivery status in a form that goes stale at closeout.
Rollover updates the declared targets and the active generation explicitly:
when a generation closes, the outgoing generation README leaves the target list
and the incoming one joins it in the same adoption step.

## Active-generation set

`projection-targets.json` declares the active generation set with exactly one
of two exclusive keys; declaring both, neither, or a malformed set fails
closed before any mutation:

- `"active_generation": "gNN"` — the sequential form. One declared active
  generation. Copy-ready starter material uses only this form, and sequential
  consumers never migrate to the plural key.
- `"active_generations": ["gNN", ...]` — the parallel form for repositories
  that legitimately run more than one generation. It must be a non-empty,
  lexically sorted, duplicate-free `gNN` list; unsorted input is rejected
  rather than silently reordered.

Both forms normalize to one active-generation set internally, and a task
transition is valid only when its generation is in that set: an envelope for
an undeclared generation refuses before any byte changes, with or without
render targets. The plural form records an already-authorized repository
mode; it never grants parallel planning authority by itself — the
repository's own roadmap mode must authorize the declared set, and rollover,
closure, and compaction stay human-owned. Rendering stays deterministic for
both forms: the singular shape renders exactly one generation row and
byte-identical historical output, while the parallel shape renders one row
per active generation in lexical order above one task table whose entries
stay grouped by generation and task id.

## Adoption

Adopt records and generated blocks only after the standalone core passes its
own oracle. Keep semantic priority human-owned. Return `planning_required` when
authority does not settle the next move instead of selecting work.

Records begin at the adoption boundary; earlier closed tasks keep their Git
and provider evidence, and no adapter fabricates receipts for them. The
cutover removes duplicate mechanical Markdown state in the same step:
lifecycle-managed task files carry no hand-maintained `Status:` header, and
no declared front door keeps a live-currentness section or Next-task column
naming a lifecycle-managed task. Goal history and retrospective sections stay
legal. Prove it with `lifecycle:run audit-currentness`, which reports exact
file, section, task, and reason. Compaction is destructive lifecycle
maintenance: it requires the generation's committed
closure record — closed disposition, exact generation, and a `tasks_digest`
that still covers the terminal record set — and refuses missing, open, stale,
mismatched, or ambiguous authority before producing a receipt or deleting
expanded sources.

## Optional Queue driver

A repository may declare `.paseo/queue.json` using Queue's frozen generic
contracts so Queue events drive the same reducer through the installed
Northstar skill. Queue stays document-system agnostic: it transports opaque
events, resolves an operator-approved trusted runner to an immutable host
artifact, executes it without a shell, validates the closed result, and owns
staging, commit, push, and uncertain-effect reconciliation. It never learns
Northstar paths, task IDs, commands, or Markdown.

The runtime is the installed skill, not repository bytes. A v2 manifest binds
the trusted runner `effigy` with the frozen literal argv
`["skill", "run", "northstar/queue:hook", "--stdio", "passthrough"]`: Queue
spawns the approved artifact, Effigy resolves the `northstar/queue:hook` task
from the consumer repository's project-local skill first and then a unique
global install, and the consumer repository stays the execution target. Skill
scripts are `{skill}`-anchored, so no task resolves code relative to the
consumer. Repositories commit configuration and generated state only — no
launcher, no copied adapter, no copied schemas, and no host path, digest, or
installation hint in Git. The trust boundary is operator-approved host state:
the approved runner artifact and the installed skill. A missing or revoked
runner, a missing skill, or an ambiguous global install fails closed before
any process runs; no alternative closeout route exists. v1 manifests remain
valid for repositories that still pin a committed repository executable, and
no program transport detail enters lifecycle records or projections.

The hook adapter translates generic events into the same canonical
transition envelopes the standalone adapter submits, preserves evidence
levels exactly (provider facts attested, Git facts locally verified), and
reduces a terminal receipt equivalent to the standalone path from equivalent
facts. A repeated event is a no-diff replay. Required hooks that fail or
diverge hold the transition visibly instead of silently degrading.

Hook-owned closeout is the mechanical closeout authority. One required
integration commit publishes the terminal record, regenerates every declared
projection target, and removes the exact submitted instruction handoff. The
handoff is a pinned transport artifact, not permanent evidence: the hook
deletes only the exact committed path whose bytes still hash to the pinned
blob digest, and only after the terminal receipt exists. Tracked durable
Markdown that still links to that exact handoff refuses the same way — the
hook resolves relative and rooted links, ignores external URLs and the
handoff itself, and only an exact local target blocks — so deletion never
strands a backlink. The scan reads one tracked Markdown file at a time within
a finite 4 MiB per-file bound; larger files refuse before any byte changes. A
changed, missing,
symlinked, or otherwise ambiguous handoff fails closed before any byte
changes; a repeated event replays without diff. Git retains the blob and the
prose log and needs no task-status edit, evidence rewrite, roadmap pointer
edit, or front-door edit; a semantic decision may still warrant a separate
human log. Repository manifests must declare the handoff directory in the
closeout hook's allowed paths for the cleanup to publish.

Equivalent standalone and hook executions must produce the same portable
digest. Two permanent closeout routes are forbidden: hand-maintained status
fields retire together with their callers once generated projections carry
them. Lifecycle-managed task templates ship no hand-maintained status line and
no closeout evidence rewrite; standalone and pre-adoption repositories keep
both and record delivery identities on the task by hand. Queue-side, the
repository's Northstar-specific closeout prompt retires once generic hooks
prove parity; it must not survive as a second permanent route.
