---
name: northstar-handoff
description: Use when a Northstar repo needs a fresh-thread handoff, continuation brief, or execution-ready coordination artifact. Produces a strict handoff brief that stays aligned with vision, roadmap, and log surfaces.
---

# Northstar Handoff

Use this skill when the user asks to:

- create a handoff file for another agent thread
- produce a continuation brief or spin-off prompt
- turn active Northstar planning state into an execution-ready brief

## Outcome

Produce a handoff artifact that another agent can execute with minimal
follow-up and without losing the repo's Northstar context.

## Quick Start

Before writing the handoff, inspect the live planning spine:

```sh
effigy tasks
effigy doctor
```

Then read the relevant front doors and active planning surfaces:

- `README.md`
- `AGENTS.md`
- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

If there is an active milestone or recent log chain, read that too before
writing the brief.

## Workflow

1. Inspect the active Northstar context: current vision, active roadmap
   milestone, latest relevant log, and repo instructions.
2. Use the contract in
   [`references/handoff-contract.md`](./references/handoff-contract.md).
3. Start from the template in
   [`assets/templates/northstar-handoff.md.template`](./assets/templates/northstar-handoff.md.template).
4. Fill the handoff with concrete paths, boundaries, and validation criteria.
5. Default the handoff location to the current month log directory unless the
   user asks for another explicit path.
6. Leave one explicit next task in the handoff and make the completion
   protocol point back to the right roadmap/log surfaces.

## Required Output

The handoff should include these sections in this order:

1. `## Objective`
2. `## Scope`
3. `## Inputs`
4. `## Constraints`
5. `## Deliverables`
6. `## Acceptance Criteria`
7. `## Notes`
8. `## Completion Protocol`

## References

- [`references/handoff-contract.md`](./references/handoff-contract.md):
  required structure and rules
- [`assets/templates/northstar-handoff.md.template`](./assets/templates/northstar-handoff.md.template):
  starter handoff brief

## Guardrails

- Do not widen scope beyond the current roadmap/log context.
- Do not produce a vague “summary”; produce an executable brief.
- Do not omit explicit out-of-scope boundaries.
- Do not use relative file paths when the handoff depends on local files.
- Do not lose the active roadmap/log linkage when handing work to another
  thread.

## Next Step

After creating the handoff, either execute from it immediately in a fresh
thread or index it in the current log flow so the continuation path is visible
to the next operator.
