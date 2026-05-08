# 026 - Re-Prove Front-Door Path After Curation

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/007-currentness-curation-and-evidence-window.md
Roadmap refs: g02.004 batch 4.3
Governing refs: docs/contracts/001-working-rules.md, docs/README.md, docs/logs/README.md
Auto-start next card: yes, if the next slice is explicit

## Objective

Run the front-door path again after the curation update and record whether the
remaining ambiguity is now small enough to live with.

## Scope

- re-run the live front-door path through docs, roadmap, and log surfaces
- record what ambiguity still remains acceptable after the curation update
- compile the next `g02` slice from that evidence

## Steps

1. Run the front-door path through the live repo surfaces.
2. Record any remaining acceptable ambiguity.
3. Compile the next improvement slice if another one is warranted.

## Acceptance Criteria

- the front-door path is re-proved after the curation update
- any remaining ambiguity is explicit and bounded
- the next slice is either explicit or the lane can close cleanly

## Evidence Required

- re-proof batch log
- updated roadmap/spec state if another slice is opened

## Stop Conditions

- the re-proof turns into another doctrine-writing batch
- remaining ambiguity is still broad enough to need another curation rewrite

## Completion Notes

The re-proof showed that the front-door path is now materially easier to trust
and that the remaining ambiguity is acceptable. The next bounded issue is no
longer front-door curation but the lifecycle of closed planning artifacts in
`docs/specs/`, so the next lane moves there instead of extending the
currentness work.

## Next Task

Start `g02.005` batch `5.1` by defining the spec lifecycle and archive rule in
doctrine, the bundle, and the live working rules.
