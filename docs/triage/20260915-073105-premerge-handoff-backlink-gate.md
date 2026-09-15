# Pre-merge handoff backlink gate

Created: 2026-09-15
Status: open
Owner: Northstar Chatterbox

## Issue

Lifecycle closeout correctly refuses to delete a submitted worker handoff while
tracked durable Markdown links to it. The refusal currently happens after the
implementation PR has merged. Queue then needs closeout recovery or Chatterbox
attention for a defect the worker could have prevented before review.

The reusable doctrine already says durable files never link to the transient
handoff, but the worker contract did not state that prohibition at the point
where workers create evidence and falsify their diff. The 2026-09-15
Chatterbox-refresh change adds that explicit instruction. It reduces likely
violations but does not mechanically prove the invariant before merge.

## Direction

Add a read-only pre-review or pre-merge proof that runs the same exact,
bounded Markdown backlink resolver used by `task.closeout` against the submitted
handoff pinned to the Queue task. A found backlink must return the existing PR
to its retained worker before merge. The closeout guard remains the final atomic
safety check.

Keep the check repository- and docs-structure-agnostic. Do not scan by prose,
guess the active handoff, weaken closeout deletion, or create another agent role.

## Open design points

- Whether Queue should expose a generic `task.pre_merge` repository-hook event,
  or run a Queue-owned verification command bound to the pinned instruction.
- Whether the shared resolver should move into a small import-safe module so
  pre-merge and closeout cannot drift.
- How to preserve compatibility for repositories without hooks while still
  improving the agent-closeout fallback prompt.

## Acceptance shape

- A worker PR adding a durable link to its submitted handoff is rejected before
  merge and returned through the ordinary revision loop.
- A link to the canonical task, PR, commit, contract, or durable log passes.
- Closeout retains its existing atomic refusal as defence in depth.
- No Chatterbox notice is emitted unless the ordinary revision path exhausts or
  a real planning decision is required.
