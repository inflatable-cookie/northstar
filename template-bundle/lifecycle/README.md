# Portable Lifecycle Starter

Status: deferred starter
Owner: repo maintainers
Governing refs: bundle-docs/sections/12-portable-task-lifecycle.md

This folder is the copy-ready pointer for a repository that adopts the portable
task lifecycle. It carries guidance only; the installed Northstar skill owns the
schemas, reducer, standalone adapter, and renderer.

## Artifact set

```text
.northstar/lifecycle/v1/
  tasks/gNN.NNN.json
  generations/gNN.json        # derived only when a generation is closed
```

Commit the per-task JSON records. Do not hand-edit them and do not let a worker
or reviewer write them. One integration owner or declared hook applies
transitions through the core, then commits the changed paths it returns.

Task Markdown keeps outcome, scope, decisions, acceptance, stop conditions,
policy, and UI brief. A generated block between stable sentinels projects the
record. Leave everything outside the sentinels alone.

## Commands

```bash
bun run <installed-northstar>/scripts/lifecycle-core.ts oracle
bun run <installed-northstar>/scripts/lifecycle-core.ts status --repo .
bun run <installed-northstar>/scripts/lifecycle-core.ts frontier --repo .
bun run <installed-northstar>/scripts/lifecycle-core.ts apply --repo . --envelope envelope.json
bun run <installed-northstar>/scripts/lifecycle-core.ts render --records .northstar/lifecycle/v1/tasks --target docs/roadmaps/README.md
```

The command returns changed paths, the new revision and digest, and the required
commit action. It never stages, commits, pushes, merges, dispatches, or selects
the next task.

## Deferred: orchestration hooks

`.paseo/queue.json`, generic event/result contracts, and automated projection
writes are not part of this starter. They arrive in a later integration lane.
Until then, run the standalone adapter and commit its returned paths by hand.

## Do not

- copy runtime heartbeats, retries, or notifications into Git;
- edit a generated block by hand;
- let automation choose priority, invent a next task, or retire a spec;
- add a repository-wide mutable task ledger.
