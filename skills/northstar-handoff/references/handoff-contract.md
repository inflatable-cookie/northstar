# Handoff Contract

Use this contract when a Northstar repo needs a fresh-thread brief or
continuation artifact.

## Required Sections

Every handoff must include these sections in this order:

1. `## Objective`
2. `## Scope`
3. `## Inputs`
4. `## Constraints`
5. `## Deliverables`
6. `## Acceptance Criteria`
7. `## Notes`
8. `## Completion Protocol`

## Rules

- `Objective` is one sentence and outcome-oriented.
- `Scope` must include at least one explicit out-of-scope boundary.
- `Inputs` and `Deliverables` must use absolute paths for local files.
- `Acceptance Criteria` must be concrete and testable.
- `Notes` should capture:
  - current roadmap/log context
  - non-obvious decisions or user preferences
  - relevant repo constraints from `AGENTS.md`
  - one concrete next move if execution is still exploratory
- `Completion Protocol` should point back to the repo's Northstar surfaces:
  update the relevant log, leave the next task clear, and call out unresolved
  risks.

## Placement Rule

Default placement is the current month log directory:

- `docs/logs/YYYY-MM/DD-HHMMSS-<slug>-handoff.md`

If the user gives a different destination, use that path instead.

## Northstar Alignment

A Northstar handoff should preserve:

- vision context: what long-horizon outcome the work serves
- roadmap context: which milestone or batch the work belongs to
- log context: what evidence or decision chain the next thread should continue

Do not reduce the handoff to a generic todo list with no planning lineage.
