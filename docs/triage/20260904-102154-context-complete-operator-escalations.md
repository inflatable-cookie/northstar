# Context-complete operator escalations

Status: decision-ready; operator-confirmed
Disposition: promote with the economical-coordinator contract changes

## Issue

During a live PR review loop, the Northstar coordinator asked the operator an
obscure question without enough context to answer it. The operator had to find
and read the review thread's blocker-log document before understanding the
issue.

This violates the purpose of an operator-facing coordinator. The operator may
return after a long-running worker or reviewer finishes and should not be
expected to remember lane internals, decode finding IDs, or inspect linked
artifacts merely to understand why a question exists.

The fix must not turn the economical coordinator into a semantic reviewer. The
agent that discovers a blocker owns the contextual explanation. The coordinator
checks that explanation for completeness, adds current transport state, and
relays a clear question.

## Operator-confirmed decision

Whenever the coordinator needs operator input, it must explain the issue clearly
and self-containedly because the operator may have no current context. A PR,
review comment, blocker log, handoff, card, or file link may support the request,
but cannot be required reading to understand or answer it.

## Escalation capsule contract

A worker, projection worker, or reviewer that discovers a blocker requiring
operator input must return an **operator escalation capsule** with:

1. **Plain-language headline** — what is blocked, without internal shorthand.
2. **Where we are** — lane, PR number/title, exact head when relevant, and
   current lifecycle state.
3. **What happened** — the observed problem and expected or intended behavior.
4. **Why operator input is required** — the exact authority, intent, access,
   safety, or trade-off boundary that the agents cannot settle.
5. **Practical impact** — what changes, remains blocked, or risks regression.
6. **Options** — normally two or three concrete choices with consequences. Do
   not manufacture alternatives when only one authorized path exists.
7. **Recommendation** — the discovering agent's recommendation and reason when
   evidence supports one; say explicitly when no option can be recommended.
8. **Exact question** — one answerable question, including the expected answer
   shape when useful.
9. **Paused state and next action** — what is paused and what the coordinator
   will do after the answer.
10. **Supporting references** — links or paths after the explanation, never in
    place of it.

Finding classifications such as `planning-change`, `oracle-gap`, or
`integration-drift` may be included as secondary routing metadata. They are not
an operator explanation.

## Coordinator behavior

Before asking the operator, the coordinator checks the capsule mechanically:

- all required fields are present;
- the PR, head, lane, and paused state match current transport evidence;
- the exact question is consistent with the stated options and unblock action;
- internal IDs and jargon are translated or explained;
- links are supporting evidence rather than prerequisites;
- no recommendation is presented as an operator decision already made.

If the capsule is absent, opaque, contradictory, or incomplete, the coordinator
returns it to the discovering child for clarification. It does not forward the
raw blocker, ask the operator to inspect a log, or invent the missing semantic
explanation itself.

When the coordinator discovers the blocker directly — for example an ambiguous
provider state, missing permission, merge pause, or transport collision — it
owns the same complete explanation from the evidence it inspected.

The operator-facing message should lead with the issue and question, not a
protocol recital. A compact normal shape is:

> **What is blocked:** plain-language headline and current PR/lane.
>
> **Why:** observed problem, intended behavior, and why agent authority stops.
>
> **Choices:** options with practical consequences and a recommendation.
>
> **Question:** the exact decision needed.
>
> **After your answer:** paused state and next action.
>
> **Evidence:** optional links and paths.

Use enough prose for the operator to decide from the message alone. Do not force
brevity when it removes the causal explanation.

## Review-loop behavior

- A review child that posts a merge-blocking finding requiring operator input
  includes the capsule in its finish report alongside the durable provider
  verdict.
- The provider review remains the full durable technical record. The capsule is
  a contextual decision interface, not a duplicate review.
- The coordinator verifies the capsule against the exact reviewed head and
  current PR state, then asks the operator in its next bounded turn.
- The worker and workspace lease remain paused until the operator answers.
- The coordinator records the answer in the appropriate authority path, routes
  a planning change back through Chatterbox/promotion when needed, or sends a
  bounded revision instruction to the existing worker.
- The answer, not private thread history, becomes the authority for the next
  action.

## Canonical destination map

| Destination | Required delta |
| --- | --- |
| `docs/specs/036-economical-orchestrator-coordination.md` | Add context-complete operator escalations to the coordinator role without transferring semantic review into coordination. |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | Require the blocker-discovering child to return an escalation capsule and define revision/planning routing after the operator answer. |
| `docs/contracts/001-working-rules.md` | Freeze the rule that operator questions must be understandable and answerable without opening supporting artifacts. |
| `docs/architecture/system-architecture.md` | Add the child-produced capsule and coordinator completeness/relay boundary to the notification-driven review flow. |
| `docs/architecture/system-inventory.md` | Record the escalation capsule as an output of blocker-producing children and an input to coordinator/operator routing. |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Add reusable doctrine for self-contained operator escalations and child-owned explanation. |
| `bundle-docs/operators/operator-quick-start.md` | Set the operator expectation that questions arrive with enough context, options, impact, and next action to answer inline. |
| `template-bundle/contracts/001-working-rules-template.md` | Carry the portable escalation-capsule rule into the copy-ready template. |
| `skills/northstar/SKILL.md` | Summarize the context-complete escalation requirement across coordinator, worker, and review routes. |
| `skills/northstar/references/modes/orchestrator.md` | Validate and relay complete capsules; return opaque child reports for clarification; never send a bare finding ID/path/question to the operator. |
| `skills/northstar/references/modes/pr-review.md` | Require a reviewer that needs operator input to include the capsule with its exact-head provider verdict and finish report. |
| Worker and projection handoff templates under `skills/northstar/assets/templates/` | Require blocker reports that need operator input to include the capsule fields without duplicating normal non-blocking status reports. |
| `docs/roadmaps/g02/batch-cards/126-dogfood-economical-orchestrator-coordination.md` | Record context-free operator questions as coordinator interventions/usability failures during the trial. |
| `docs/README.md` and owned roadmap/front-door indexes | Sequence this adjustment without claiming implementation or trial completion early. |

Exact-token search may find derived source/install parity or validation surfaces.
Any additional semantic destination returns for operator confirmation.

## Non-goals

- no requirement that the operator read a full review, blocker log, or card
  before answering;
- no duplication of the complete technical review in chat;
- no coordinator reinvestigation of findings already owned by a reviewer;
- no coordinator choice of product meaning, acceptance policy, or contract
  trade-offs;
- no hiding uncertainty behind a confident recommendation;
- no escalation capsule for ordinary progress reports or questions already
  settled by canonical authority;
- no weakening of provider verdict, exact-head, worker-revision, promotion, or
  merge gates;
- no reusable dependency on a specific model or provider.

## Sequencing and dependencies

- Promote with the Chatterbox/coordinator and notification-driven turn changes
  already captured in:
  - `docs/triage/20260904-100224-chatterbox-planning-and-private-review-children.md`;
  - `docs/triage/20260904-100548-place-review-child-in-worker-workspace.md`;
  - `docs/triage/20260904-101838-coordinator-dispatch-fast-path-and-yield.md`.
- Update reviewer/worker output requirements before making the coordinator
  reject incomplete capsules.
- Keep capsule validation mechanical. Material `planning-change` answers still
  route through Chatterbox and operator-confirmed promotion.
- Update structural and semantic review scenarios with source/install parity in
  the same delivery batch.

## Acceptance evidence

- A review-blocker fixture produces a capsule that lets an uninformed reader
  identify the PR, problem, intended behavior, impact, options, recommendation,
  exact question, paused state, and next action without opening a link.
- A negative fixture containing only a finding ID and blocker-log path is
  rejected and returned to the reviewer rather than forwarded to the operator.
- A second negative fixture with technically complete evidence but unexplained
  internal jargon is rejected for clarification.
- A coordinator relay preserves the child's meaning, adds verified current PR
  and head state, and does not invent an option or recommendation.
- A directly discovered permission or provider blocker produces the same
  self-contained operator message from coordinator-owned evidence.
- An operator answer routes deterministically to worker revision,
  Chatterbox/promotion, permission handling, or continued pause.
- Dogfood records the observed obscure question as an initial usability failure
  and tracks later context-free escalations.
- Existing exact-head review, durable provider record, finding classification,
  notification, serial workspace lease, revision routing, merge-gate, bundle,
  command/router, and source/install parity checks still pass.
- `git diff --check`, `effigy check:command-skills`,
  `effigy check:repo-contract`, `effigy qa:docs`, and `effigy qa` pass for the
  eventual promotion batch.

## Unresolved questions

None block promotion. The capsule is a completeness contract, not a rigid UI
form; natural prose is preferred when it carries every required element more
clearly.

## Alternatives rejected

- **Send the blocker link and assume the operator will inspect it.** Links are
  evidence, not context.
- **Have Luna reconstruct the technical issue from raw logs.** That moves
  semantic review into the economical coordinator and risks distortion.
- **Paste the entire review into chat.** Volume is not clarity; the operator
  needs the causal decision context and can inspect supporting evidence when
  desired.
- **Ask a bare yes/no question.** Without impact, options, and next action, the
  same words can authorize materially different outcomes.
