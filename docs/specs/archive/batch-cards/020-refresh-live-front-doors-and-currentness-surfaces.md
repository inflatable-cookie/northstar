# 020 - Refresh Live Front Doors And Currentness Surfaces

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md
Roadmap refs: g02.002 batch 2.4
Governing refs: docs/contracts/001-working-rules.md, docs/roadmaps/generation-index.md, docs/logs/README.md
Auto-start next card: no

## Objective

Run a longer live Northstar lane under the tightened guardrails by refreshing
the repo's stale front doors and currentness surfaces so they point at the real
active generation, milestone, and current evidence chain.

## Scope

- refresh stale live entry points in `docs/README.md`, `docs/roadmaps/README.md`,
  `docs/roadmaps/g02/README.md`, and `docs/roadmaps/generation-index.md`
- refresh `docs/contracts/contract-index.md` so it reflects the current lane
- refresh `docs/logs/README.md` so the current month and next task match the
  real evidence chain

## Steps

1. Update the live docs front doors so they point at `g02` and `g02.002`
   rather than older `g01` or `g02.001` state.
2. Refresh the contract and log indexes so they reflect the current lane and
   recent evidence chain.
3. Record the autonomy findings from the run and close the batch cleanly.

## Acceptance Criteria

- the main live repo front doors point at the active generation and milestone
- contract and log currentness surfaces match the real lane state
- the autonomy findings are captured in a batch log

## Evidence Required

- updated live README/currentness surfaces
- batch log recording the run and its findings

## Stop Conditions

- the batch only updates prose without improving the live navigation path
- the currentness surfaces still point at stale lanes after the pass

## Completion Notes

Completed one uninterrupted live lane across the repo's stale currentness
surfaces. The main finding is that front doors and indexes drift faster than
core doctrine because they are easy to leave behind after milestone churn. The
active generation and current evidence chain now point at `g02.002`, and the
next improvement slice should build on this currentness finding rather than
assuming the front doors stay aligned on their own.

## Next Task

Decide the next `g02` improvement slice from the autonomy findings now that
`g02.002` is complete.
