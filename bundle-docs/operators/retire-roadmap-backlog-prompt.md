# Retire Roadmap Backlog Prompt

Use this once for an existing Northstar project that still carries a
`docs/roadmaps/backlog/` folder or live backlog doctrine. Give it to the
project's current orchestrator after any migration that already owns the same
roadmap paths has merged and closed.

The prompt removes the duplicate intake layer. Roadmaps retain promoted,
executable tasks; triage owns unresolved or deferred candidates until
promotion.

## Copy/paste prompt

```text
Run the one-time Northstar roadmap-backlog retirement for this project.

This message authorizes bounded documentation, planning, instruction-surface,
template, fixture, and local-checker repair needed for the cleanup. It
authorizes deletion of `docs/roadmaps/backlog/` after every item has a truthful
disposition. It does not authorize product code, release work, a new product
lane, task execution, abandonment of queued work, or a generation rollover.

Use the currently installed Northstar skill. The governing model is:

- roadmaps contain promoted executable Northstar tasks;
- `docs/triage/` is the temporary, non-authoritative home for unresolved or
  deferred candidates;
- triage notes are promoted, merged, or removed during refresh and cleanup;
- no `docs/roadmaps/backlog/` surface or backlog-item template remains.

Safe boundary

1. Record repository, integration branch, exact head, worktree state, active
   generation, current frontier, and the installed Northstar skill identity.
2. Inspect the project queue plus active workers, reviewers, PRs, handoffs, and
   worktrees. If an unfinished migration owns `docs/roadmaps/`, `docs/triage/`,
   or the live doctrine/checkers this cleanup would change, let it merge and
   close before starting. Do not cancel, abandon, supersede, or edit around it.
3. Start mutation only from a clean, synchronized integration checkout. Respect
   repository-specific mutation and approval rules.
4. Do not archive, delete, rename, detach, stop, or otherwise modify any
   pre-existing Paseo workspace or agent. A queue may retire only the cleanup
   workspace and agents it created.

Inventory and classify

Inventory:

- `docs/roadmaps/backlog/` and any other backlog directories;
- every file and inbound link under those directories;
- live docs, instructions, templates, fixtures, checkers, and unsubmitted
  handoffs that teach or require a roadmap backlog;
- current triage notes and active roadmap tasks that might already own the same
  meaning.

Freeze a disposition manifest before deletion. Classify every backlog item:

- unresolved or deferred candidate: move its current meaning into one unique
  timestamped triage note, preserving scope, source references, constraints,
  open questions, promotion condition, and any named owner or next check;
- approved executable work: merge it into the existing owning `gNN.NNN` task,
  or create a top-level task only when current planning authority already
  approves that work and its generation, ordering, dependencies, and frontier
  placement are unambiguous;
- durable rule or accepted design: promote it to its owning contract,
  architecture, policy, or other canonical surface;
- implemented, superseded, duplicate, or no longer useful: remove it and record
  that disposition without creating a placeholder note.

Do not turn every backlog file into a task. Do not treat migration as approval.
Stop for an operator ruling when ownership, promotion, task ordering, or removal
is ambiguous. Leave the source intact until that decision is settled.

Apply the clean cutover

- Move or merge current meaning according to the manifest.
- Delete `docs/roadmaps/backlog/`, backlog-item templates, and other live
  backlog scaffolding.
- Rewrite current roadmap doctrine, front doors, visual maps, glossaries,
  starter templates, agent instructions, local fixtures, checkers, and
  unsubmitted handoffs so they agree: roadmaps hold promoted executable tasks;
  triage holds unresolved or deferred candidates until promotion.
- Update cleanup and migration checks to flag any retained backlog directory as
  deprecated input that must be dispositioned and removed.
- Keep clearly historical logs, archived roll-ups, closed handoffs, immutable
  queue records, and quoted evidence unchanged unless they contain a current
  broken link. Historical references may name the former path as provenance;
  they must not become live authority.
- Do not leave aliases, moved-to stubs, compatibility folders, empty backlog
  directories, or dual terminology.

Prove and land

- Confirm every removed backlog item appears in the disposition manifest and
  its current meaning is either reachable at one canonical destination or
  deliberately removed.
- Confirm no current executable surface, starter template, agent instruction,
  or checker requires a roadmap backlog.
- Confirm `find docs -type d -name backlog -print` returns nothing, unless a
  repository-specific non-Northstar path is explicitly classified and retained.
- Confirm triage remains non-authoritative and roadmap tasks remain the only
  executable planning units.
- Run repository-native docs checks, normal QA required for documentation
  changes, and `git diff --check`.
- Open one PR, obtain independent exact-head review, then merge, synchronize
  the integration checkout, and publish normal closeout evidence.

Return one final report with the disposition manifest, exact files changed and
deleted, validation and review evidence, retained historical exceptions, and
the current approved frontier. Keep operator notifications to one
decision-changing blocker or this final report; omit routine progress.
```

## Completion boundary

The cleanup is complete when no live Northstar backlog surface remains, every
former backlog item has a truthful disposition, triage owns unresolved or
deferred candidates without becoming execution authority, and the integration
branch is synchronized after normal review and closeout.
