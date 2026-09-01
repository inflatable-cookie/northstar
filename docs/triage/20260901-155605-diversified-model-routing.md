# Diversified model routing across runs

Status: open; promote after `g02.046/114`
Owner: Northstar orchestrator
Source: operator correction after concentrated Opus and Grok usage

The economical-routing rule still concentrates work. It chooses one best-fit
profile repeatedly and treats other profiles mainly as failure fallbacks. This
first exhausted Opus usage, then shifted the same concentration onto Grok.
Cheaper capable routes such as Cursor Auto and GLM 5.3 Flash are underused.

The next routing correction should treat configured profiles as a portfolio,
not a ranked single default.

## Settled direction

- Vary provider/model selection across worker runs and fresh orchestrator runs.
- Prefer the cheapest adequate profiles for most implementation work, including
  many materially consequential lanes when planning and the review oracle are
  already strong.
- Keep worker cost separate from review strength. Exact-head orchestrator
  review, counterexamples, and repository-owned validation remain the risk
  controls.
- Do not send every frontier-classified lane to the same frontier model. A
  frontier worker becomes an explicit exception for reasoning that cannot be
  bounded adequately before dispatch, not the automatic consequence of risk or
  priority.
- Operator-selected profiles still override automatic routing.
- Provider-neutral Northstar policy must not encode local model names, prices,
  balances, or allowances.

## Candidate routing rule

At each dispatch, read current profile notes and build the set of profiles that
can perform the lane. Prefer the lowest-cost adequate tier, then choose a
different provider/model from recent eligible dispatches when possible. Use
adapter-visible recent-agent evidence when available; otherwise keep a small
orchestrator-local recent-route record. Do not repeat a route merely because it
worked last time, and do not wait for quota failure before rotating.

For a fresh orchestrator continuation, apply the same diversification across
eligible orchestrator profiles. The current thread's model does not force the
successor's model.

Fallback remains lane-local: mark a refused route unavailable for that attempt,
preserve workspace identity, and try another eligible route. Rotation is not a
global capacity limit and must not serialize unrelated lanes.

## Planning questions

- What bounded recent-use window is stable enough to avoid concentration
  without creating durable usage accounting inside Northstar?
- Should cost-tier preference come only from profile notes, or may an adapter
  expose explicit cost/allowance metadata when available?
- What minimum evidence justifies the rare explicit frontier-worker exception?
- Which deterministic routing scenarios prove diversity without hard-coding a
  local profile inventory?

Promote this into spec 026, working rules, orchestrator model routing, handoff
guidance, doctrine, copy-ready surfaces, and deterministic contract assertions.
Keep it serial behind card 114 because both lanes own those surfaces.
