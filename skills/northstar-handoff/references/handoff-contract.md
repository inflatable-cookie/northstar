# Handoff Contract

Use this contract when a Northstar repo needs a fresh-thread brief or
continuation artifact.

## Required Sections

Every handoff must include these sections in this order:

1. `## What This Thread Was Doing`
2. `## Why It Matters`
3. `## Current State`
4. `## Boundaries`
5. `## Important Context`
6. `## Suggested Next Move`
7. `## Completion Protocol`

## Rules

- `What This Thread Was Doing` should explain the actual arc of the current
  thread in plain language, not just name a task.
- `Why It Matters` should connect the immediate work to the larger product,
  roadmap, or planning goal.
- `Current State` must capture:
  - where the work stands now
  - what is finished vs still open
  - the active spec lane when one is still shaping the work
  - the canonical promoted refs the next thread should trust for execution
  - the remaining continuation envelope, if another ready card is still
    in-bounds
  - the lane budget or explicit pause signal when the run did not simply
    continue
  - the key files or artifacts involved, using absolute paths for local files
- `Boundaries` must include at least one explicit out-of-scope boundary and any
  hard constraints the next thread must respect.
- `Important Context` should capture:
  - current roadmap/log lineage
  - how the spec lane relates to the canonical architecture/contracts
  - non-obvious decisions or user preferences
  - relevant repo constraints from `AGENTS.md`
  - open questions, tensions, or judgment calls that could change the approach
- `Suggested Next Move` should tell the next thread how to re-enter the work
  without pretending the rest of the plan is already settled.
- `Completion Protocol` should point back to the repo's Northstar surfaces:
  the batch card and roadmap state should already reflect the stopping point,
  any front-door currentness surfaces that name the active lane or ready card
  should already reflect the stopping point, the relevant log should already
  exist or be part of the same closeout step,
  any remaining continuation envelope should be named explicitly, any pause
  signal should be named explicitly, the next task should be clear, and
  unresolved risks should be called out.

## Placement Rule

Default placement is the current month log directory:

- `docs/logs/YYYY-MM/DD-HHMMSS-<slug>-handoff.md`

If the user gives a different destination, use that path instead.

## Northstar Alignment

A Northstar handoff should preserve:

- vision context: what long-horizon outcome the work serves
- roadmap context: which milestone or batch the work belongs to
- spec context: which provisional planning lane is still active, if any
- canonical context: which promoted architecture/contracts now govern execution
- log context: what evidence or decision chain the next thread should continue
- thread context: what the current thread was really trying to figure out,
  protect, or improve

Do not reduce the handoff to a generic todo list with no planning lineage or
continuity of thought.
Do not use it as a substitute for proper closeout in the live planning spine.
