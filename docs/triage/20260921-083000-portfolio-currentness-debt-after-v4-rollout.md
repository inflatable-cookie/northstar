# Currentness debt across the portfolio after the v4 rollout

Status: open
Owner: operator + Northstar Chatterbox
Updated: 2026-09-21
Source: full read-only sweep of `~/Dev/projects` after the prospective-merge rollout

## What is true

Thirty-one Northstar-adopted checkouts all declare
`paseo.queue.control.v4` with the pre-merge hook at `prospective_merge` and
resolve one shared installed adapter; every installed copy reports parity, and
no consumer carries a copied lifecycle runtime. `projection-targets` is v2
everywhere. The protocol/adapter layer is uniform and current.

The content layer is not. Eight of the thirty-one carry `audit-currentness`
findings, twenty-four in total:

| Repository | Findings | Composition |
| --- | --- | --- |
| effigy | 8 | 6 duplicate-status-header, 2 stale-frontier |
| paseo-northstar-queue | 4 | 4 stale-frontier |
| poodle | 4 | 1 duplicate-status-header, 3 stale-frontier |
| underlay | 4 | 3 duplicate-status-header, 1 stale-frontier |
| nightfire | 1 | stale-frontier |
| bughunt | 1 | stale-frontier |
| monkey | 1 | stale-frontier |
| poodle-lab | 1 | stale-frontier |

A red repository holds closeout for every lane in it, so these block work in the
same way the incident blockages did. The findings in task files or declared
projection targets block; the rest are front-door prose.

## Three of them are the rollout's own side effect

`bughunt` g01.004, `monkey` g14.003 and `poodle-lab` g02.003 are the migration
lanes this rollout added and closed. Closing them made the front-door prose that
named them stale, and the closeout hook regenerates only the generated block,
never human prose. The same class was repaired deliberately in acowtancy,
figmatic and swallowtail; these three were missed because their lanes had already
closed before that batch was planned.

The other five repositories were already on v4 before the rollout and were never
inside its census, so their debt predates it.

## Proposed route

One bounded repair lane per repository, using the shape that just cleared
acowtancy, figmatic and swallowtail: the audit's exact inventory in Evidence,
header removal only, frontier values replaced with task-free sequencing intent,
and `audit-currentness` clean as the oracle. Ten header removals and fourteen
frontier values in total.

## Not authorized

Nothing here is dispatched. The operator holds all pending work and has asked
that it stay held until their instruction; this note records the lead so it does
not have to be rediscovered.
