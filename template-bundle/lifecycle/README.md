# Portable Lifecycle Starter

Status: adoption starter
Owner: repo maintainers
Governing refs: bundle-docs/sections/12-portable-task-lifecycle.md

This folder is the copy-ready starter for a repository adopting the portable
task lifecycle. It carries guidance plus the complete committed hook runtime,
so a copy-only consumer needs nothing from the author's checkout; the installed
Northstar skill is the source you copy or generate the runtime from, not an
execution dependency.

## Artifact set

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json        # derived only when a generation is closed
  projection-targets.json     # declared projection surfaces

.paseo/
  queue.json
  hooks/northstar-lifecycle
  hooks/northstar-lifecycle.runtime/**   # complete committed runtime payload
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

To let Queue drive the same lifecycle, copy four things:

1. `queue.json` → `.paseo/queue.json` (the control manifest);
2. `hooks/northstar-lifecycle` → `.paseo/hooks/northstar-lifecycle`
   (committed, executable, `chmod +x`);
3. `hooks/northstar-lifecycle.runtime/` → `.paseo/hooks/northstar-lifecycle.runtime/`
   (the complete committed runtime payload: launcher, adapter, reducer, and
   every lifecycle schema);
4. `projection-targets.json` → `.northstar/lifecycle/v1/projection-targets.json`
   (then edit the target list to your front doors, including the active
   generation README).

The committed runtime is the only implementation Queue executes. The launcher
resolves `northstar-lifecycle.runtime/` beside itself and never `$HOME`, a
globally installed skill, `PATH`, the network, or the Northstar source
checkout, so a stale or hostile installation cannot change what runs. Copy the
payload by hand, or generate it from the installed skill with
`bun run <installed-northstar>/scripts/lifecycle-runtime.ts copy` and commit
the result. Never hand-edit a copied runtime file: `lifecycle-runtime.ts copy`
is the only supported way to rewrite the payload, and `lifecycle-runtime.ts
check` is the parity oracle that fails on any missing, extra, or differing
code, schema, launcher, or executable-bit byte. The closure is derived, so a
new lifecycle schema is picked up automatically.

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
staging, commit, push, and reconciliation. The adapter runs from the committed
runtime payload, so normal hook execution depends on no Paseo, Queue, network,
global install, or Northstar source checkout.

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
- hand-edit a copied runtime file or its launcher instead of re-running the
  generator;
- edit a generated block, a record, or the manifest's executable by hand;
- let automation choose priority, invent a next task, or retire a spec;
- add a repository-wide mutable task ledger;
- declare Queue paths, statuses, or commands inside `.northstar/` artifacts —
  Queue metadata stays opaque and additive in Northstar receipts.
