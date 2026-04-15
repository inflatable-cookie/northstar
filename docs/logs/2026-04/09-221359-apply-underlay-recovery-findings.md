# Apply Underlay Recovery Findings

Date: 2026-04-09
Roadmap: `g02.015`

## Summary

- completed the Underlay recovery audit
- confirmed that Underlay’s main drift was stale planning/currentness, not a
  missing Northstar docs spine
- applied a narrow Underlay recovery batch that opens `g01.098` as the live
  planning/control lane for the broader shared-surface overhaul

## Why this batch mattered

Underlay’s repo shape and validation were already stronger than Loophole’s.
The actual failure mode was that the docs still advertised the completed
Poodle-contraction stop point while the real work had moved into a broader
shared-surface normalization wave across multiple consuming apps. Installing a
strict execution lane before fixing that queue would have been premature.

## Evidence

- Underlay now has an explicit active roadmap again at
  `docs/roadmaps/g01/098-poodle-era-consumer-normalization-and-overhaul-recovery.md`.
- The roadmap and log front doors no longer claim there is no active roadmap.
- The Underlay recovery batch stayed on disjoint planning/currentness surfaces
  and left the already-dirty `docs/guides/110-admin.md` file untouched.

## Validation

- `effigy qa:docs --repo ~/Dev/projects/underlay`
- `effigy qa:northstar --repo ~/Dev/projects/underlay`
- `effigy qa`
- `effigy qa:docs`

## Next Task

Let Underlay execute `g01.098` Batch 98.2, then reassess from that audit
whether Northstar should stay at planning-layer recovery there or open a
stricter execution-lane proof.
