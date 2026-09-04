# Handoff: <Topic>

**Type: TEMPLATE** -- New handoffs are written under `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md`.

Status: active
Created: YYYY-MM-DD
Roadmap: <gNN.NNN or none>
Governing refs: <card or contract refs>

## 1. What This Thread Was Doing

State the bounded task this thread was executing.

## 2. Why It Matters

Explain the goal served and the impact of the work.

## 3. Current State

- Progress: <what was completed>
- Working tree: <clean / dirty / branch name>
- Validation: <checks run and result>

## 4. Boundaries

- In scope: <task list>
- Out of scope: <explicit non-goals>

## 5. Important Context

- Non-obvious decisions, risks, or key paths.
- Link canonical cards and contracts rather than duplicating steps or doctrine.

## 6. Suggested Next Move

One concrete next action for the incoming thread.

## 7. Completion Protocol and Artifact Lifecycle

- Worker handoffs: confirm worktree, branch, PR contract, and clean head before reporting.
- Orchestrator handoffs: reconcile stopping state, push branch, and pass absolute path.
- Disposition trigger: transient transport; delete after promotion, merge, consumption, abandonment, or ownership transfer. Do not retain as routine history.
