# Portable Lifecycle Starter

Status: adoption starter
Owner: repo maintainers
Governing refs: bundle-docs/sections/12-portable-task-lifecycle.md

This folder is the copy-ready starter for a repository adopting the portable
task lifecycle. It carries guidance plus the three hook files; the installed
Northstar skill owns the schemas, reducer, adapters, and renderer.

## Artifact set

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json        # derived only when a generation is closed
  projection-targets.json     # declared projection surfaces
```

Commit the per-task JSON records. Do not hand-edit them and do not let a
worker or reviewer write them. The lifecycle command or the declared hook
applies transitions, then the integration owner commits the changed paths it
returns.

Task Markdown keeps outcome, scope, decisions, acceptance, stop conditions,
policy, and UI brief. A generated block between stable sentinels projects the
record. Leave everything outside the sentinels alone; a task file opts into
currentness by carrying the block. Lifecycle-managed task files carry no
hand-maintained status line and no closeout evidence rewrite: the record and
the projections own mechanical state.

## Standalone commands

```bash
bun run <installed-northstar>/scripts/lifecycle-core.ts oracle
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

To let Queue drive the same lifecycle, copy three files:

1. `queue.json` → `.paseo/queue.json` (the control manifest);
2. `hooks/northstar-lifecycle` → `.paseo/hooks/northstar-lifecycle`
   (committed, executable, `chmod +x`);
3. `projection-targets.json` → `.northstar/lifecycle/v1/projection-targets.json`
   (then edit the target list to your front doors, including the active
   generation README).

Every declared currentness view belongs in the target list: the repository
root front door, the roadmaps front door, and the active generation README.
When a generation rolls over, change the target list in the same rollover
step — the outgoing generation README leaves it and the incoming one joins
it — so the projected currentness surface always names exactly the active
generation.

The manifest binds a read-only `task.pre_dispatch` gate and a required
integration-write hook for `task.blocked`, `task.cancelled`, and
`task.closeout`. Keep the handoff directory (default `docs/handoffs/`) in the
integration-write hook's allowed paths: closeout publishes one integration
commit containing the terminal record, the regenerated projections, and the
removal of the exact consumed instruction handoff. The hook deletes only the
exact committed path whose bytes still hash to the pinned blob digest; a
changed, missing, or ambiguous handoff fails closed. Queue executes the
pinned launcher without a shell, validates result and changed paths, and owns
staging, commit, push, and reconciliation. The adapter itself runs from the
installed skill, so the repository depends on no Paseo, Queue, network, or
Northstar source checkout.

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

- copy runtime heartbeats, retries, or notifications into Git;
- edit a generated block, a record, or the manifest's executable by hand;
- let automation choose priority, invent a next task, or retire a spec;
- add a repository-wide mutable task ledger;
- declare Queue paths, statuses, or commands inside `.northstar/` artifacts —
  Queue metadata stays opaque and additive in Northstar receipts.
