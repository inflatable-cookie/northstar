# Handoffs

**Type: REQUIRED** -- Northstar projects keep fresh-thread handoffs here.

Handoffs are friendly coordination notes, not batch logs. The installed
Northstar handoff mode writes every concrete handoff into this directory.

## Naming

Use the local creation time:

```text
YYYYMMDD-HHMMSS-<slug>.md
```

Example: `20260816-143500-soundcheck-api-review.md`.

## Contents

Each handoff keeps these seven sections in order:

1. What This Thread Was Doing
2. Why It Matters
3. Current State
4. Boundaries
5. Important Context
6. Suggested Next Move
7. Completion Protocol

Write for a thoughtful teammate. Explain the story, use plain language, and be
honest about what is still uncertain. Worker handoffs use the same seven sections
and add worktree, runway, reporting, validation, PR, and startup worktree-safety
instructions inside the completion protocol.

The handoff does not replace the batch log or roadmap closeout. It points to
those artifacts when the next thread needs them.
