# Cross-model PR review

Status: open queue item

## Issue

The coordinator must not assign PR review to the same underlying model that
authored the change. A different profile name, reasoning level, or agent thread
does not provide independent review when the provider/model identity is the
same. Reusing it risks correlated omissions and self-confirming review.

## Operator-confirmed direction

- The PR reviewer uses a different underlying model from the implementation
  worker.
- The coordinator remains responsible for mechanical reviewer selection and
  review-loop management.
- This note queues a protocol tweak; it does not interrupt or authorize changes
  to the active implementation lane.

## Proposed canonical destinations

- Chatterbox/coordinator doctrine: add author/reviewer model separation to the
  reviewer-dispatch contract.
- PR-review and orchestrator modes/templates: carry the author's provider/model
  identity in the review handoff and reject an identical reviewer identity.
- Machine checks/fixtures: prove that renamed profiles and changed reasoning
  levels do not satisfy the separation rule.

## Non-goals

- Chatterbox does not choose the individual reviewer for each PR.
- The rule does not require a separate review workspace.
- The rule does not require a different provider when a different underlying
  model is available and otherwise qualified.
- The rule does not weaken capability, exact-head, clean-worktree, or
  independence requirements already applied to review.

## Sequencing and fallback

Promote this before the coordinator next dispatches a PR reviewer. At review
dispatch, it first filters for qualified reviewer profiles, then excludes the
author's exact provider/model identity. If no qualified distinct model is
available, review fails closed and the coordinator sends the operator a
context-complete escalation rather than silently reusing the author model.

## Acceptance evidence

- Doctrine and current orchestration/review surfaces state the exact identity
  rule consistently.
- Reviewer handoff records author and reviewer provider/model identities.
- A positive fixture accepts a qualified different model.
- Negative fixtures reject the author's model behind another profile name and
  reject the same model at another reasoning level.
- Existing worker-workspace placement and serial exact-head lease behavior stay
  intact.

## Unresolved questions

None. Exact model identity is the minimum confirmed boundary; provider diversity
is not required by this decision.
