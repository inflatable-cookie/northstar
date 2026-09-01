# 047 - Diversify Model Routing Across Runs

Status: complete; card 115 awaiting exact-head review
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.046`, spec 026
Vision tags: `orchestration`, `cost`, `routing`, `general-purpose`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`

## Problem

Economical routing still chooses one best-fit profile repeatedly and treats
other routes mainly as failure fallbacks. That concentrated expensive Opus
usage first, then moved the same concentration to Grok. The policy optimizes one
dispatch in isolation instead of balancing a portfolio of adequate models.

## Goals

- build an adequate profile pool for every worker, delegate, and fresh
  orchestrator run;
- prefer the cheapest adequate tier indicated by current profile notes or
  explicit adapter metadata;
- vary provider/model identity before reusing a recent adequate route;
- use adapter-visible recent-agent history when available and bounded
  current-run memory otherwise;
- keep worker price separate from review strength;
- make frontier workers a rare residual-reasoning exception and rotate them too;
- preserve operator override, lane-local failure, and provider neutrality.

## Non-Goals

- no durable Northstar usage, billing, quota, or allowance ledger;
- no hard-coded local profile, provider, model, price, or balance;
- no claim that the cheapest model fits every task;
- no weakening of planning, review oracles, exact-head review, validation, or
  merge gates;
- no provider-specific load balancer or automatic account top-up;
- no global worker count or capacity limit.

## Execution Plan

Card `g02.047/115` updates the reusable routing rule, fresh-orchestrator and
planning-delegate selection, handoff guidance, compact doctrine/copy-ready
surfaces, focused assertions, installed parity, and closeout in one lane.

## Acceptance Criteria

- every dispatch builds an adequate pool instead of selecting one remembered
  default;
- the cheapest adequate tier wins before provider/model rotation;
- an adequate alternative is preferred over immediate route reuse;
- adapter history is optional and current-run memory is sufficient fallback;
- fresh orchestrators, planning delegates, ordinary workers, and rare frontier
  workers all participate in diversification;
- a settled material lane may use a small worker while review strength remains
  with the orchestrator and repository evidence;
- explicit operator profile choice still wins;
- refusals remain lane-local and preserve existing workspace/agent identities;
- reusable policy contains no local model names or durable usage accounting;
- source/install parity and full Northstar QA pass.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Adequacy precedes preference. | A cheap profile lacks the role capability while a costlier profile has it. | Exclude the inadequate route; do not rotate blindly. | Adequate-pool assertion. |
| Cheap adequate routes are used. | One cheap and one expensive profile are equally adequate and neither is an override. | Choose the cheap tier. | Cost-tier assertion. |
| Successful routes do not become permanent defaults. | The last route and another same-tier route are both adequate. | Choose the less-recent provider/model. | No-repeat assertion. |
| History is optional. | The adapter exposes profiles but no recent-agent history. | Use current-run route memory; do not stop or invent a ledger. | History-fallback assertion. |
| Orchestrators rotate too. | A fresh successor always copies the same orchestrator profile despite another adequate route. | Apply the same pool and recent-use rule. | Successor-routing assertion. |
| Review strength is not worker price. | A material but fully settled lane has a strong oracle and small adequate worker. | Use the economical pool; keep material orchestrator review. | Risk-separation assertion. |
| Frontier cost is exceptional. | A lane is merely high priority, broad, or security-labelled. | Do not select frontier from that label alone. | Residual-reasoning assertion. |
| Operator intent wins. | The operator explicitly names an adequate profile that rotation would not choose. | Use the named profile. | Override assertion. |
| Route failure stays local. | One provider refuses after returning transport identity. | Preserve identity, remove only that route for the attempt, and continue unrelated lanes. | Failure/fallback assertion. |
| Northstar stays portable. | A checker or instruction names a local model, price, balance, or fixed history window. | Reject the implementation. | Provider-neutral search and parity proof. |

## Stop Conditions

- implementation needs persistent cross-thread accounting owned by Northstar;
- current profile notes cannot establish adequacy or any cost tier and the
  adapter exposes no usable metadata;
- rotation would override an explicit operator selection;
- a proposed simplification weakens review, validation, or lane-local recovery;
- validation changes the plan.

## Next Task

This lane is complete. Orchestrator exact-head review of the card 115 PR is
next; merge is orchestrator-owned. Spec 034 remains a separate not-ready
language-package planning lane.
