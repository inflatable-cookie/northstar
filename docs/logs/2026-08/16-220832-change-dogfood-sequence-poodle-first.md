# Change Dogfood Sequence to Poodle First

- Date: 2026-08-16
- Milestone: `g02.026`
- Related spec: `docs/specs/027-northstar-native-pre-execution-discovery.md`
- Current next task: Batch 26.3 starter-surface planning checkpoint

## Decision

The dogfood sequence changes from **Figmatic, then Poodle** to **Poodle, then
Figmatic**.

Tom is currently doing direct one-to-one interactive bug fixing in Figmatic, so
Figmatic should remain outside the orchestrator flow temporarily. Poodle is the
next available target and is a strong test of the starter surfaces, cross-runtime
contracts, project vocabulary, and cleared-map promotion path. Figmatic remains
the later test of an actively ambiguous product boundary once its direct fixing
work returns to the orchestrator flow.

## Planning effect

- Batch 26.3 planning now targets Poodle dogfood first;
- the starter-surface planning checkpoint remains the immediate next step;
- no Figmatic or Poodle repository state was changed;
- earlier logs and handoffs retain the sequence that was correct when they were
  written; this log and the active spec/roadmap surfaces supersede that sequence
  for current planning.

## Validation

- Northstar `main` was clean and synchronized before this change;
- the active spec, milestone, roadmap front doors, and card 077 forward pointer
  now consistently name Poodle first;
- no stale current roadmap pointer still names Figmatic as the immediate dogfood
  target.
