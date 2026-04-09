# 040 - Run Consumer-Repo Autonomy Proof

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md
Roadmap refs: g02.009 batch 9.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md
Auto-start next card: yes, if the consolidation batch is explicit

## Objective

Run the combined autonomy model against a real active consumer-repo lane.

## Scope

- choose the active target lane deliberately
- inspect how the continuation and lane-budget model behaves in that repo
- record the bounded failures that still matter

## Steps

1. Select the active consumer repo and live lane.
2. Re-run the relevant operator/agent path through its Northstar surfaces.
3. Record what still breaks and what already works.

## Acceptance Criteria

- a real external proof run is completed
- the consolidation batch is explicit and ready

## Evidence Required

- external-proof log
- explicit next consolidation step

## Stop Conditions

- the target repo or lane is not actually active
- the proof starts mutating the consumer repo without justification

## Completion Notes

Ran the proof against Signal's active `g09` lane and kept the consumer repo
read-only. The useful result is not that the model failed outright, but that
it is only partially expressible there because Signal is still using a lighter
roadmap-and-log shape without `specs/` and batch cards. Currentness inside
Signal is also split: `docs/roadmaps/g09/README.md` and the latest log clearly
point at `g09.005`, while `docs/README.md` and `docs/logs/README.md` remain
too generic or stale to carry the same autonomy state cleanly.

## Next Task

Start `g02.009` batch `9.3` by applying only the bounded findings that
materially improve the autonomy model.
