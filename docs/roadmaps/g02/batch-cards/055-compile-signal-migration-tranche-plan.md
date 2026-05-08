# 055 - Compile Signal Migration Tranche Plan

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/017-signal-strict-compliance-migration-proof.md
Roadmap refs: g02.014 batch 14.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/017-signal-strict-compliance-migration-proof.md
Auto-start next card: yes, if the application/proof batch is explicit

## Objective

Compile the first strict-compliance migration tranche plan for Signal.

## Scope

- define the minimum lane-first stricter-adoption pack Signal needs first
- keep the tranche bounded to the active `g09` queue
- leave the application/proof batch explicit and ready

## Steps

1. Turn the audited gaps into one bounded migration tranche.
2. Name the exact docs surfaces Signal needs first.
3. Leave the next application/proof batch explicit and ready.

## Acceptance Criteria

- the first Signal migration tranche is explicit
- the tranche is bounded enough to apply without fresh doctrine work
- the next batch is ready

## Evidence Required

- tranche-planning log
- updated roadmap/spec state

## Stop Conditions

- the tranche broadens into full repo migration in one jump

## Completion Notes

- The first Signal migration tranche is now explicit and lane-first rather than
  repo-wide.
- The minimum pack is: `product-guardrails`, `001-working-rules`,
  `docs/specs/README.md`, `docs/roadmaps/g02/batch-cards/README.md`, one active
  Signal spec, and one bounded card chain attached to the live `g09` queue.
- The tranche is anchored to `g09.005` with an explicit boundary into
  `g09.006`; historical backfill and full strict compliance remain deliberately
  deferred.

## Next Task

Start `g02.014` batch `14.3` by applying the tranche-planning findings and
deciding whether Northstar or Signal should own the next execution move.
