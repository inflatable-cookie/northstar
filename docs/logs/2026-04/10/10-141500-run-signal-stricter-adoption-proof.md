# 10 141500 - Run Signal Stricter Adoption Proof

## Summary

Ran `g02.010` batch `10.2` as a read-only proof against Signal's active
`g09.005` LV2 lane.

The result is a sharper adoption threshold than a binary repo-wide choice:

- Signal should remain a baseline roadmap-mode repo at whole-repo scope
- its active plugin-realization lane is deep enough that longer autonomous runs
  would benefit from stricter execution state
- the right next shape is lane-first stricter adoption inside a mature baseline
  repo, not a full repo-wide rewrite

## Evidence

- Signal's top-level docs intentionally omit `docs/specs/`, confirming the repo
  is currently operating in baseline mode
- `docs/roadmaps/g09/005-real-lv2-discovery-extension-negotiation-and-linux-proof.md`
  already carries detailed bounded execution sequencing and tranche outcomes
- the latest `g09.005` logs show healthy active-lane continuity, but they do
  not carry explicit continuation-envelope, lane-budget, or pause-signal state
- the missing state is lane-local, not evidence that the entire repo needs a
  stricter rewrite

## Decision

Treat Signal as the proof that Northstar should support lane-first stricter
adoption:

- keep the repo baseline where that remains sufficient
- add the stricter `specs/` plus batch-card layer only when one active lane
  needs fuller execution state for longer hands-off runs
- prefer the minimum active-lane surface over backfilling old history

## Validation

- read-only proof batch; no Signal-side edits
- `effigy qa`
- `effigy qa:docs`

## Continuation Note

- Remaining continuation envelope: the next bounded card is `g02.010` batch
  `10.3`
- Lane budget / pause signal: `handoff-required`

## Next Task

Start `g02.010` batch `10.3` by applying the bounded proof-backed finding that
stricter delivery-layer adoption should be possible lane-first inside a mature
baseline repo.
