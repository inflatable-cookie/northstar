# Select Signal Pilot Target

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.001 batch 1.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md

## Summary

Selected `signal` as the first real consumer-repo pilot target and tightened
the pilot evidence contract so the run should yield concrete consolidation
decisions rather than vague impressions instead of another structurally valid
but inactive specimen-style pass.

## Files Changed

- updated `bundle-docs/maintenance/operator-workflow-drill.md`
- updated `bundle-docs/maintenance/operator-pilot-record-template.md`
- updated the live spec, batch-card, roadmap, and next-task chains to name
  `signal` as the target repo

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the first external pilot target is now explicit:
  `~/Dev/projects/signal`
- the target was chosen because it has a live Northstar docs spine, an
  Effigy-first operator loop, an active roadmap generation, and a real current
  execution lane in `g09.003` around VST3 support
- the pilot record now requires ordered page-open traces, time to a valid next
  batch, and false-start capture so pruning decisions can be evidence-backed

## Unresolved

- the pilot itself still needs to be run
- the resulting consolidation decisions are still unknown until the external
  run happens

## Next Task

Start batch 1.2 by running the first real operator pilot against `signal` and
recording the actual decision path.
