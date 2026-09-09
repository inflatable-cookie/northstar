# Flattened Task Switchover Prompt

Use this once for an existing Northstar project that still has roadmap
milestones and nested batch cards. Give it to the project's current
orchestrator after the installed Northstar skill includes the flattened
generation-plus-task model.

The prompt pauses old-format dispatch, compacts closed generations, migrates
the active generation, and resumes execution only after the new authority
chain is coherent.

## Copy/paste prompt

```text
Run the one-time Northstar flattened-task switchover for this project.

This message authorizes bounded documentation, planning, instruction-surface,
template, and local-checker repair needed for the migration. It authorizes
removal of superseded milestone and batch-card structures after their current
meaning and evidence are preserved. It does not authorize product code,
release work, a new product lane, abandonment of queued work, or a generation
rollover.

Use the currently installed Northstar skill. Confirm that its project-refresh
and lifecycle-maintenance surfaces define the generation-plus-task model:

- the generation README owns the roadmap and approved frontier;
- `docs/roadmaps/gNN/NNN-<slug>.md` is the sole executable planning unit;
- the unit is called a Northstar task and referenced as `gNN.NNN`;
- no active milestone wrapper or nested `batch-cards/` hierarchy is supported.

If the installed skill still teaches the old structure, stop and report that
exact blocker. Do not improvise the migration from memory.

Safe boundary

1. Suspend new old-format dispatches. Record the repository, integration
   branch, exact head, worktree state, active generation, and current frontier.
2. Inspect the project queue plus active workers, reviewers, PRs, handoffs, and
   worktrees. Finish every submitted old-format record through its normal
   accepted merge and closeout before changing its authority path. Do not
   cancel, abandon, silently supersede, or rewrite an unfinished record.
3. If any old-format record cannot close, stop with one decision-changing
   blocker report. Keep the existing planning files intact. Do not dispatch
   the migration around it.
4. Start mutation only from a clean, synchronized integration checkout with no
   unfinished execution tied to paths the migration will remove. Respect any
   repository-specific mutation or approval rule.

Phase 1: compact historic generations

Run Northstar project refresh with documentation repair authorized. Apply the
installed closed-generation lifecycle-maintenance procedure before editing the
active generation.

- Inventory every expanded generation and its inbound links.
- Classify each as active, safely closed, or unresolved from its content and
  front doors. Folder count and a completed task alone do not prove closure.
- Freeze a preservation manifest before deletion: unique authority and its
  destination, open commitments and their active homes, material PR/commit/
  release/validation evidence, current links, and exact paths to remove.
- Promote live rules, rehome open commitments, write non-procedural
  `docs/roadmaps/archive/gNN.md` roll-ups, and rewrite current links.
- Delete only safely closed expanded generation trees named in the manifest.
  Leave unresolved and explicitly parallel-active generations intact and
  report their disposition.

Do not modernize terminology inside roll-ups, logs, closed handoffs, immutable
queue records, or other clearly historical evidence. Git remains the detailed
archive.

Phase 2: flatten the active generation

Inventory the active generation README, milestone files, nested batch cards,
current specs and contracts, front doors, live instructions, local templates
and checkers, unsubmitted handoffs, dependencies, status, ownership, acceptance
criteria, stop gates, and evidence. Freeze an old-path/ID to new-task map before
renaming or deleting anything.

Apply these mapping rules:

- When a milestone already describes one coherent remaining outcome, absorb
  its card detail into that milestone's `gNN.NNN` file and make it the task.
- When a milestone contains several independent ready, blocked, or unresolved
  cards, preserve each as a distinct top-level task. Keep the milestone ID for
  the first task that genuinely owns its outcome; assign the others the next
  unused generation-local IDs in dependency order.
- Collapse wholly completed milestone/card groups into compact completed tasks
  when their durable outcome, material evidence, limitations, and dependencies
  have clear destinations. Do not retain every closed step as live procedure.
- Preserve every ready, blocked, in-flight, or otherwise unresolved unit with
  its governing refs, scope, ordered work, dependencies, dispatch boundaries,
  acceptance oracle, validation, evidence, ownership, and stop conditions.
- Stop for an operator planning ruling if task ownership, ordering, ID choice,
  or evidence destination is ambiguous. Do not create aliases or dual
  authority to avoid the decision.

Then make the generation README the single roadmap and approved-frontier
surface. Make each executable unit one top-level task at
`docs/roadmaps/gNN/NNN-<slug>.md`. Rewrite current front doors, active planning
references, live agent instructions, local templates/checkers, and unsubmitted
handoffs atomically. Remove consumed milestone wrappers, legacy task/card
templates, and the active generation's `batch-cards/` directory.

Use “Northstar task” for the canonical planning unit. Keep “queue task” for a
control-plane execution record and “Effigy task” for a command selector. Those
records and selectors do not become planning authority.

Phase 3: prove and land the migration

- Confirm current front doors name the same active generation, active task or
  explicit absence of one, and approved frontier.
- Confirm every `gNN.NNN` ID is unique and agrees with its filename and live
  references.
- Confirm no active executable surface depends on `batch-cards/`, a milestone
  wrapper, dual status, or an old submitted handoff.
- Confirm every removed path was in the preservation manifest, current links
  resolve, open commitments remain reachable, and material evidence remains
  traceable.
- Run the project's docs checks and normal QA required for documentation
  changes. Run `git diff --check`. Do not invent Northstar-source-only checks
  in a consumer repository.
- Repeat the lifecycle/currentness inventory. The second pass must not
  re-expand generations, recreate compatibility structure, or churn roll-ups.
- Complete the repository's normal review, merge, and closeout flow, then
  synchronize the integration checkout before reopening dispatch.

Return one final report containing:

- historic-generation classifications and preservation manifest;
- old path/ID to new task mapping for the active generation;
- exact files changed and deleted;
- validation and review evidence;
- unresolved blockers or retained historical exceptions;
- the new approved frontier;
- whether normal dispatch has resumed.

Keep operator notifications to a decision-changing blocker or this final
report. Do not send routine progress commentary.
```

## Completion boundary

The switchover is complete when the integration branch contains one active
generation-plus-task hierarchy, historic generations are compact or have an
explicit unresolved disposition, and the orchestrator has resumed from the new
approved frontier. The prompt is migration authority only; later product work
still needs its normal ready task.
