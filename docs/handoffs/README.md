# Handoffs

This directory holds the short notes that let another person or agent take over
without reconstructing the originating conversation.

## When to write one

Create a handoff only when another thread genuinely needs to take over or the
operator explicitly asks for one. A long thread, low context, or ordinary
compaction is not enough if the same thread can continue from the live `Next Task`.

Before writing a handoff, complete the honest closeout that belongs in the
planning spine: update the current card, roadmap/currentness surfaces, and log
when the work reached a meaningful stopping point.

## Naming

Every handoff uses the local creation time and this filename shape:

```text
YYYYMMDD-HHMMSS-<slug>.md
```

For example:

```text
20260816-143500-soundcheck-api-review.md
```

Use a short lowercase kebab-case slug. If the same timestamp and slug already
exists, add `-2`, `-3`, and so on after the slug.

## What belongs here

Handoffs are coordination notes, not batch evidence. Each file uses the
Northstar handoff contract's seven core sections:

1. What This Thread Was Doing
2. Why It Matters
3. Current State
4. Boundaries
5. Important Context
6. Suggested Next Move
7. Completion Protocol

The generic handoff should be a friendly, timestamped note written like a
thoughtful teammate: clear, warm, plain-spoken, and honest about uncertainty.
Worker handoffs use the same seven sections and add their worktree, runway,
reporting, validation, PR flow, and startup worktree-safety/fallback instructions
inside `Completion Protocol`. Their frontmatter must explicitly declare
`handoff_mode: worker-pr-loop`, `worker_mode: implementation`, and
`dispatch_authority: orchestrator`. Those fields activate worker mode; normal
agents do not perform the worktree preflight.

## Relationship to logs

- `docs/logs/` records evidence and decisions from work that happened.
- `docs/handoffs/` explains how the next thread should pick the work up.
- A handoff may link to a log, but it does not replace one.

The handoff skill always writes the concrete file here and reports its absolute
path to the operator.
