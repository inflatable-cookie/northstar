# 103 - Add Review Oracles and Compact Handoffs

Status: complete
Owner: repo maintainers
Updated: 2026-08-30
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`, `g02.035`
Auto-start next card: no

## Objective

Reduce avoidable worker revision rounds without adding more handoff prose.

## Scope

- add review oracles, a worker adversarial pass, and finding reason codes;
- tighten risk-based worker routing;
- compress the worker handoff into a dispatch overlay;
- update copy-ready and skill-shipped templates together;
- close the roadmap and evidence chain.

## Ready-State Checks

- [x] Operator supplied live-use evidence from active code repositories.
- [x] Existing delivery doctrine and orchestrator spec own the behavior.
- [x] The change does not require consumer-repo mutation.
- [x] The review oracle specifies behavior, not implementation.

## Acceptance criteria

- high-risk and universal claims have falsifiable counterexamples and proof;
- pre-PR worker review covers initial delivery and requested revisions;
- review findings distinguish execution misses from planning and oracle gaps;
- handoffs remain self-contained through resolvable refs without copying cards;
- high-risk cards get frontier/high worker routing;
- copy-ready template parity and repo QA pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Shorter handoffs stay complete. | Remove copied card/doctrine prose. | Worker still resolves committed card, oracle, runtime boundary, and PR contract. | Template and contract inspection; docs QA. |
| Risky acceptance is reviewable before implementation. | Criterion says `all`, `never`, or `exact` without a counterexample. | Card remains unready. | Ready rubric and batch template checks. |
| Review evidence diagnoses cause. | A second review cycle has only a count. | Reviewer records a reason code before revision. | Spec, contract, and mode inspection. |

## Evidence Required

- `git diff --check`
- `effigy qa:docs`
- `effigy qa`
- source/install parity where the distribution workflow requires it

## Stop Conditions

- shortening removes a required worktree, branch, authority, or PR safeguard;
- the oracle starts prescribing implementation instead of acceptance;
- validation fails in a way that changes the plan.

## Resolution

- promoted the oracle, adversarial-pass, finding-code, and risk-routing rules;
- changed handoff guidance and the worker template to reference authority;
- updated copy-ready, source-skill, roadmap, and evidence surfaces together.

## Next task

No blocking follow-up. Gather coded review-cycle evidence from future runs.
