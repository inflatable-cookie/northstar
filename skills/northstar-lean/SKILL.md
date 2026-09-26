---
name: northstar-lean
description: Keep a project's knowledge current and its work well-aimed. Use for planning, writing a task brief, reviewing a PR, recording an operator ruling, retiring a concept, or orienting in a Northstar repository.
---

# Northstar

Northstar keeps a repository's knowledge current and its plan legible, so any
agent can pick up work without reconstructing intent from conversation.

The repository holds **knowledge and code**. The orchestrator (the Paseo Queue
plugin today, Nucleus later) holds **process**: tasks, briefs, status, review,
closeout and outcomes. Never write process state into the repository.

## Repository shape

| Surface | Holds |
| --- | --- |
| `AGENTS.md` | Orientation: what this is, the doc map, guardrails, the validation command |
| `docs/README.md` | What is true now, in a page, with links by topic |
| `docs/knowledge/` | Current truth, one owner per fact: vision, architecture, contracts, domain |
| `docs/knowledge/retired.toml` | Concepts that no longer exist, and what replaced them |
| `docs/knowledge/questions.md` | Open questions, and where each answer now lives |
| `docs/knowledge/contracts/release.md` | How this project releases, step by step. Every project has one |
| `docs/plan.md` | What matters next and why |
| `docs/triage/` | Unresolved leads; never authority |
| `PAPERCUTS.md` | Small recurring friction |

There are no task cards, roadmaps, generations, handoff files, lifecycle
records or delivery logs. Git history and the orchestrator's outcome records
are the history.

## Orient

Read `AGENTS.md`, then `docs/README.md`, then only the knowledge files your task
touches. Before planning against a concept, check `retired.toml`. Before asking
the operator something, check `questions.md` and the owning knowledge file.
Asking a settled question again costs more than looking it up.

## How work moves

1. **Plan.** Intent goes into `docs/plan.md` as a short prioritised list. A
   plan item being worked can own a Queue lane; the lane's aim restates the
   item and grants no authority. See [plan](references/plan.md).
2. **Brief.** Each task gets a brief held by Queue, not committed: outcome,
   context links, constraints, acceptance, and when to stop. See
   [brief](references/brief.md).
3. **Dispatch.** Submit the brief with the operator's approval. Queue runs the
   worker, review, merge and closeout, and keeps the outcome.
4. **Review.** An independent reviewer checks the exact head against the brief.
   See [review](references/review.md).
5. **Keep knowledge current.** When work changes what is true, the same PR
   updates the owning knowledge file. See [knowledge](references/knowledge.md).

## Rules that matter

- **One home per fact.** Link to the owner; don't restate it. A copy is a
  future contradiction.
- **Rulings land before you hand off.** An operator answer given in
  conversation goes into its owning knowledge file, or closes a question in
  `questions.md`, before the thread ends or hands over.
- **Retirements name what they retire.** Retiring a concept adds an entry to
  `retired.toml` that lists the terms, paths and config keys it covers, and the
  same change removes or fixes the live references.
- **No status mirrors.** Never write "done", "merged" or "in review" into the
  repository. Queue owns status.
- **Write for the next reader.** Keep only what someone will need later.
  Short, plain, and with the reasoning that makes a decision understandable.
- **Break things honestly.** When a change breaks callers or contracts, say so
  and update them together. No shims that hide a decision.

## Ask the operator when

- the plan doesn't settle what to do next;
- a choice is breaking, irreversible, security-sensitive, or changes product
  direction;
- validation fails in a way that changes the plan.

Otherwise act. Asking again for authority that is already settled is a cost.

## Roles

- **Planner** (a Chatterbox thread): owns `docs/plan.md`, knowledge upkeep,
  briefs and dispatch approval requests. Does not implement or merge.
- **Worker:** implements one brief in the worktree Queue gives it, runs the
  repository's validation, opens one PR, and reports through Queue.
- **Reviewer:** checks the exact head independently and reports findings.

Coordination (recovery, review routing, merge, closeout) is Queue's job, not a
thread's.

## Adopting or migrating a repository

Use [adopt](references/adopt.md) and the starter in
[template/](template/README.md). A repository on the older Northstar shape
migrates in one deliberate cut, after its Queue manifest moves to v5.

## Optional modules

UI design delivery and language quality packages are separate modules. Load one
only when the repository has opted in.
