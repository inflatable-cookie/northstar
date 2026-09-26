# Vision

Northstar lets operators run software projects with agents that act on current
knowledge and aimed work, without reconstructing intent from conversation
history or babysitting threads.

## What it is

A small skill and a repository shape. The repository holds knowledge and code.
The orchestrator (the Paseo Queue plugin today, Nucleus later) holds process:
tasks, briefs, status, review, closeout, outcomes and papercuts. Northstar's
job is to keep a project's knowledge current and its plan legible, so any agent
can pick up work cold.

## Outcomes

- Agents plan against what is true now, not against retired concepts or
  settled questions they re-ask.
- Operator rulings reach their owning file before the thread that heard them
  ends.
- A brief is enough for a capable worker; nobody restates guardrails in
  conversation.
- Completion rests on merged code and validation, not narrative.
- Adopting Northstar doesn't require language-specific quality tooling a
  project doesn't use.

## Constraints

- The skill stays small. Doctrine a capable agent already follows by default
  is removed, not restated.
- General-purpose across operators, repositories and harnesses. One operator's
  convenience can inform evidence but never becomes a reusable assumption.
- Human-readable and copy-ready: the starter in `skills/northstar/template/`
  works in another project unchanged.
- Northstar runs on its own shape.

## Non-goals

- Recording work for its own sake. A record exists because someone will need
  it later, not because a step happened.
- Task state in Git: status mirrors, handoffs, lifecycle records, delivery
  logs.
- A separate skill for every narrow flow. Specialised flows are optional
  modules.
- Replacing human judgment with automation.
