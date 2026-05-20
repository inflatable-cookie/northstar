---
name: northstar-handoff
description: Use when a Northstar repo needs a fresh-thread handoff, continuation brief, spin-off prompt, or execution-ready coordination artifact. Produces a continuation brief that preserves thread intent, planning lineage, the active spec lane, and the canonical promoted refs behind the current work.
---

# Northstar Handoff

Use this skill when the user asks to:

- create a handoff file for another agent thread
- produce a continuation brief or spin-off prompt
- create a Northstar handoff for the next thread
- turn the current planning and log state into an execution-ready handoff
- turn active Northstar planning state into an execution-ready brief
- create a genuine fresh-thread boundary because the same thread should not
  keep going

## Outcome

Produce a handoff artifact that another agent can pick up quickly without
losing the thread's longer-running intent, reasoning, and Northstar context.
Do not use this skill just because the current thread is nearing context
compaction. If the same thread can continue after compaction, prefer normal
closeout and let it continue.

## Quick Start

Before writing the handoff, inspect the live planning spine:

```sh
effigy tasks
effigy doctor
```

Then read the relevant front doors and active planning surfaces:

- `README.md`
- `AGENTS.md`
- `bundle-docs/protocol-kernel.md` when the brief should cite canonical protocol homes
- `docs/README.md`
- `docs/vision/README.md`
- `docs/specs/README.md` when present
- `docs/roadmaps/gNN/batch-cards/` when present
- `docs/architecture/`
- `docs/contracts/`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

If there is an active milestone or recent log chain, read that too before
writing the brief.

## Workflow

1. Inspect the active Northstar context: current vision, active spec lane when
   present, active roadmap milestone, canonical promoted refs, latest relevant
   log, and repo instructions.
2. Use the contract in
   [`references/handoff-contract.md`](./references/handoff-contract.md).
3. Start from the template in
   [`assets/templates/northstar-handoff.md.template`](./assets/templates/northstar-handoff.md.template).
4. Fill the handoff with the thread story first, then the concrete canonical
   refs, active spec lane, continuation envelope, lane budget or pause signal,
   boundaries, and validation criteria needed to continue safely.
5. Default the handoff location to the current month log directory unless the
   user asks for another explicit path.
6. Treat handoff as the fourth closeout step, not the first: batch card,
   roadmap, currentness surfaces, and log state should already reflect the
   stopping point unless the user explicitly asks for a handoff-first artifact.
7. Leave one explicit next task in the handoff and make the completion
   protocol point back to the right roadmap/log surfaces.
8. If the only pressure is low context or impending compaction, do not create a
   handoff. Keep the thread open, complete normal closeout, and rely on the
   prior `Next Task` plus the current ready card after compaction.
9. In the operator-facing message that accompanies the handoff, lead with why
   the handoff exists, the current lane state, and the next move. Mention
   validation only if it failed or materially affects confidence. Keep
   protocol detail concise.
10. Use glue-light, compressed writing for the handoff and its surrounding chat
    message unless the user explicitly wants richer explanatory prose.

## Required Output

The handoff should include these sections in this order:

1. `## What This Thread Was Doing`
2. `## Why It Matters`
3. `## Current State`
4. `## Boundaries`
5. `## Important Context`
6. `## Suggested Next Move`
7. `## Completion Protocol`

## References

- [`references/handoff-contract.md`](./references/handoff-contract.md):
  required structure and rules
- [`assets/templates/northstar-handoff.md.template`](./assets/templates/northstar-handoff.md.template):
  starter handoff brief

## Guardrails

- Do not widen scope beyond the current roadmap/log context.
- Do not collapse the handoff into a sterile task list with no explanation of
  why the work matters.
- Do not produce a vague summary; the next thread should still know what to do
  first.
- Do not omit explicit out-of-scope boundaries.
- Do not use relative file paths when the handoff depends on local files.
- Do not lose the active roadmap/log linkage when handing work to another
  thread.
- Do not use a handoff as a substitute for the batch log or roadmap update.
- Do not create a handoff merely because context is low or compaction is near;
  that is a normal runtime event, not a completion signal or a fresh-thread
  requirement.
- Do not hand off from stale front-door state; if currentness surfaces still
  advertise the wrong active card or lane state, fix that first unless the
  user explicitly wants a temporary handoff before closeout.
- Do not hand off only the provisional planning surface when canonical
  architecture/contracts already govern the work.
- Auto-continuation is the default when the continuation envelope is explicit
  and the next card is ready. Only signal a pause when there is a specific
  reason to stop.
- Do not declare the lane or thread complete solely because context budget is
  low; if the lane is still active, keep the normal closeout state honest and
  let the same thread continue after compaction when possible.
- Do not hide whether the run paused because budget was exhausted, a stop
  signal fired, the lane ended, or a handoff is genuinely required.
- Do not let the operator-facing summary read like a protocol dump with the
  real thread state buried underneath.
- Do not waste tokens on filler or ceremonial phrasing in the handoff when a
  denser operator-facing brief would do the job.
- Carry forward the user's preferences, non-obvious judgments, and unresolved
  tensions if they are shaping the work.

## Next Step

After creating the handoff, either execute from it immediately in a fresh
thread or index it in the current log flow so the continuation path is visible
to the next operator.
