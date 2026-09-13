# Portable Lifecycle Starter

Status: adoption starter
Owner: repo maintainers
Governing refs: bundle-docs/sections/12-portable-task-lifecycle.md

This folder is the copy-ready starter for a repository adopting the portable
task lifecycle. It carries configuration and guidance only — no Northstar
executable code. The lifecycle reducer, adapter, and schemas live in the
installed Northstar skill; Queue executes them through the Effigy skill
runner, so a consumer repository never commits or maintains a hook runtime.

## Artifact set

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json            # compaction receipt, written by compact
  generations/gNN.closure.json    # closure authority, written by the rollover
  projection-targets.json         # declared surfaces + active generation set

.paseo/
  queue.json                      # generic Queue control manifest (v2)
```

Commit the per-task JSON records. Do not hand-edit them and do not let a
worker or reviewer write them. The lifecycle command or the declared hook
applies transitions, then the integration owner commits the changed paths it
returns.

Task Markdown keeps outcome, scope, decisions, acceptance, stop conditions,
policy, and UI brief. A generated block between stable sentinels projects the
record and names each declared active generation, its disposition (`open` or
`closed`; never `complete`), and its derived runway state (`active`, `ready`,
`blocked`, `planned`, or `planning_required`). An open generation whose records
are all terminal projects `planning_required`: that asks planning to extend the
same generation or make a reasoned rollover decision, and never implies
closure. Leave everything outside the sentinels alone; a task file opts into
currentness by carrying the block. Lifecycle-managed task files carry no
hand-maintained status line and no closeout evidence rewrite: the record and
the projections own mechanical state.

Generation closure is explicit and separate from an exhausted runway: a
rollover commits `generations/gNN.closure.json` (closed disposition plus the
`tasks_digest` printed by the lifecycle `tasks-digest` command) only after the
preservation oracle passes, and `compact` refuses missing, open, stale, or
mismatched authority. Until that record exists, the generation stays open in
`planning_required`.

## Standalone commands

The lifecycle surface stays first-class without Queue. From an installed
Northstar skill:

```bash
effigy skill run --path <installed-northstar> northstar/lifecycle:oracle
bun run <installed-northstar>/scripts/lifecycle-core.ts status --repo .
bun run <installed-northstar>/scripts/lifecycle-core.ts frontier --repo .
bun run <installed-northstar>/scripts/lifecycle-core.ts apply --repo . --envelope envelope.json
bun run <installed-northstar>/scripts/lifecycle-core.ts render --repo . --records .northstar/lifecycle/v1/tasks --target docs/roadmaps/README.md
```

The command returns changed paths, the new revision and digest, and the
required commit action. It never stages, commits, pushes, merges, dispatches,
or selects the next task. Explicit paths are containment-checked; escaping,
outside, or symlinked paths fail without changing bytes.

## Queue hook adoption

The manifest selects Queue's trusted runner `effigy` with the frozen literal
argv `["skill", "run", "northstar/queue:hook", "--stdio", "passthrough"]`.
Queue resolves that runner ID to an operator-approved host artifact outside
Git; the manifest carries no path, digest, version, or environment. Copy two
things:

1. `queue.json` → `.paseo/queue.json` (the control manifest);
2. `projection-targets.json` → `.northstar/lifecycle/v1/projection-targets.json`
   (then edit the target list to your front doors, including the active
   generation README, and declare your active generation).

The starter declares one active generation with the singular
`active_generation` key. A repository whose roadmap mode already authorizes
parallel generations may instead declare the plural `active_generations`
key: a non-empty, lexically sorted, duplicate-free `gNN` list. The two keys
are mutually exclusive, an undeclared generation refuses every transition,
and the plural form never grants parallel planning authority by itself — the
repository's roadmap mode must authorize the set. Keep the sequential
default unless the repository actually runs generations in parallel.

### External prerequisites

The hook route depends on three host-side facts that no repository file can
supply. Each one fails closed: a missing prerequisite starts no process,
records a visible failure, and never falls back to another closeout route.

1. **Effigy version.** The installed `effigy` must support automatic qualified
   skill resolution and `--stdio passthrough` — the release carrying accepted
   PR #104 (Effigy `4f2b466` or later). Older versions reject the route.
2. **Northstar skill resolution.** `northstar/queue:hook` resolves from the
   consumer repository first: a project-local `.agents/skills/northstar`
   directory wins over every global source. Without a project-local copy,
   exactly one global install across the host's named skill roots
   (`.agents/skills`, `.codex/skills`, `.claude/skills`, `.cursor/skills`)
   must exist; symlinks to the same directory count once, and two distinct
   global installs are ambiguous and fail. The repository stays the execution
   target and working directory; the skill supplies the adapter bytes.
3. **Host runner approval.** The host operator must approve trusted runner
   `effigy` in Queue's trusted-runner registry. Approval is host-local state
   outside Git; a missing, disabled, or revoked runner starts no process.

### What Queue executes

Queue pins the approved `effigy` artifact and spawns it with the literal argv,
no shell, and the event JSON on stdin. Effigy resolves the skill, runs the
`queue:hook` task with the consumer repository as target and working
directory, and forwards raw stdin, stdout, stderr, and the exit status without
an envelope. The adapter reads its schemas from the skill installation, so a
skill upgrade changes what runs — that trust lives in the operator-approved
host state, not in repository bytes. The manifest stays portable across
hosts because it names only a runner ID.

Every declared currentness view belongs in the target list: the repository
root front door, the roadmaps front door, and each active generation's README.
When a generation rolls over, change the target list in the same rollover
step — the outgoing generation README leaves it and the incoming one joins
it — so the projected currentness surface always names exactly the active
generation set.

The manifest binds a read-only `task.pre_dispatch` gate and a required
integration-write hook for `task.blocked`, `task.cancelled`, and
`task.closeout`. Keep the handoff directory (default `docs/handoffs/`) in the
integration-write hook's allowed paths: closeout publishes one integration
commit containing the terminal record, the regenerated projections, and the
removal of the exact consumed instruction handoff. The hook deletes only the
exact committed path whose bytes still hash to the pinned blob digest; a
changed, missing, or ambiguous handoff fails closed. Queue validates the
result and changed paths, and owns staging, commit, push, and reconciliation.

Adoption boundary: records begin with the first task dispatched after the
manifest lands. Earlier closed tasks keep their Git and provider evidence;
the closeout hook never fabricates receipts for them. The standalone adapter
remains first-class and produces the same terminal receipt from equivalent
facts. Once the generated projections carry them, remove hand-maintained
status fields from task headers and front doors in the same cutover; a
routine closeout then edits no prose at all — no task-status edit, no
evidence rewrite, no roadmap pointer edit, no front-door edit, and no prose
log. Exceptional semantic decisions may still warrant a separate human log.

## Do not

- copy Northstar runtime code, launchers, or schemas into the repository;
- put a host path, digest, version, or environment hint into the manifest;
- hand-edit a generated block, a record, or the manifest's program by hand;
- let automation choose priority, invent a next task, or retire a spec;
- add a repository-wide mutable task ledger;
- declare Queue paths, statuses, or commands inside `.northstar/` artifacts —
  Queue metadata stays opaque and additive in Northstar receipts.
