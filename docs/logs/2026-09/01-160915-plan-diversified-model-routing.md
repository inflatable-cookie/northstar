# Plan Diversified Model Routing

Date: 2026-09-01
Status: planning complete; card 115 ready
Roadmap: `g02.047`
Card: `g02.047/115`

## Outcome

PR 19 passed exact-head review and merged at `b99d19c`, completing fresh
orchestrator continuation. Operator feedback then corrected the remaining model
routing flaw: selecting one best-fit default concentrates spend even when the
selected profile is economical in isolation.

The promoted boundary treats configured profiles as a portfolio. Each dispatch
builds an adequate pool, prefers the cheapest adequate tier, and varies recent
provider/model use. Adapter-visible history is optional; current-run memory is
the fallback. The rule applies to workers, planning delegates, rare frontier
workers, and fresh orchestrators. Review strength remains in planning, review
oracles, exact-head review, and repository-owned validation rather than worker
price.

The source triage note was removed after promotion. Northstar stores no local
profile/model names and owns no durable billing or usage ledger.

## Readiness

Card 115 is ready with ten adversarial routing scenarios. Its implementation is
serial after card 114 because both own orchestrator mode, doctrine, copy-ready
working rules, assertions, and front-door closeout.

## Validation

- `effigy qa:docs`
- `git diff --check`

## Next

Commit and push this planning state, then create one worker handoff and dispatch
an adequate economical profile not used for card 114. The worker does not merge.
