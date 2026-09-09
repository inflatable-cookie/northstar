# 001 - Example Foundation Task

**Type: EXAMPLE** -- Shows what a completed task looks like. Remove from your project after reading.

Status: draft
Owner: Core Team
Created: YYYY-MM-DD
Governing refs: `001-session-and-role-contract.md`, `002-job-dispatch-contract.md`
Depends on: none

## Outcome

Teams get a repeatable execution model that keeps roadmap work focused, traceable, and lightweight.

## Decisions

None.

## Dispatch manifest

- **State:** draft; single task, no siblings
- **Completion:** first task file traceable from vision and architecture, with one task log carrying explicit validation evidence
- **Owned mutable paths:** `docs/roadmaps/g01/001-<slug>.md`, `docs/logs/YYYY-MM/`
- **Reserved closeout surfaces:** none
- **Worker:** day-to-day implementation pool
- **Excluded:** full automation checker suite; framework-specific tooling mandates
- **Escalation:** repo maintainers for scope or contract questions

## Work

1. Finalize planning gate artifacts and confirm no active scope relies on pending contracts.
2. Execute a small but meaningful contract-backed change against the defined criteria.
3. Publish a task log in `docs/logs/YYYY-MM/` with validation actually run.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| First task file is traceable from vision and architecture | A goal has no vision or contract parent | Link check from task to governing surfaces |
| One task log exists with validation recorded | Completion claimed without run commands | Log with `Validation Performed` completed |
| Next action is explicit and execution-ready | Closeout ends with no named next move | `Next task` names the follow-up |

## Stop conditions

- Stop when a planning gap, contract contradiction, or failed evidence gate changes the plan.

## Evidence

None yet; record PR, head, validation, and limits on completion.

## Next task

Execute the work steps above and publish the first log for `g01.001`.
