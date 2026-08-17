# Planning Readiness Recovery Sweep

Date: 2026-08-17 07:50 BST
Status: planning drift repaired; operator feedback intake remains pending
Related routes: `northstar planning readiness review`, `sweep-audit-repair`
Related commits: `5457af9` architecture-refocus loop; current recovery sweep

## Scope

This sweep repaired Northstar's own planning state after the refresh and
architecture-refocus routes were implemented. It covered the active `g02`
roadmap, pre-execution-discovery spec and milestone, instruction-surface spec and
card, contract index, system inventory, generation front doors, and the current
operator-feedback boundary.

No worker, worktree, consumer-repository edit, production-code edit, or roadmap
execution was started.

## Drift found

- The architecture-refocus route existed in the installed skill but remained
  unchecked/future in the active discovery spec and roadmap.
- The active `g02` milestone still said its Batch 26.3 planning checkpoint was
  pending even though the checkpoint and cards 075–077 were complete.
- The system inventory and instruction-surface closeout still reported historical
  32-file/34-file parity, while the current installed copies proved 38 files.
- The contract index retained an older `g02.025` readiness paragraph and old
  dogfood-card references.
- Active Northstar surfaces treated a Northstar-managed Poodle dogfood target as
  pending. The operator clarified that live dogfooding happens outside the
  Northstar execution loop and that feedback supplied here is the evidence.
- The graph index was stale after the new route commits.

Historical logs and handoffs that accurately describe their earlier planning
state were not rewritten. Current front doors now distinguish historical
`g15.006` example material from operator-provided live feedback.

## Repairs

- Marked the architecture-refocus portion of Batch 26.4 complete while leaving
  reframe and operator feedback intake pending.
- Reconciled `g02.026`, Batch 26.3, card 078, and `g02.027/079` status across
  specs, milestones, generation front doors, and the contract index.
- Updated the inventory and instruction-surface records to current 38-file
  installed-skill parity.
- Preserved Poodle `g15.006` as a historical worked example only; live consumer
  execution remains outside Northstar's loop.
- Changed live dogfood guidance to consume operator-provided feedback rather than
  selecting a Poodle/Figmatic destination or preparing a handoff.
- Refreshed the derived Effigy graph index.

## Remaining state

- Card `g02.026/078` is ready but deferred.
- Operator-provided live dogfood feedback remains the next evidence input;
  Northstar does not select or dispatch the consumer run.
- The non-mutating reframe route remains unimplemented.
- Template-bundle promotion, reframe, and feedback intake remain pending.

## Validation

- `git diff --check` — passed during the sweep.
- `effigy check:repo-contract` — passed during the sweep.
- `effigy check:readiness-map` — passed; 0 live maps and all 5 fixtures passed.
- `effigy qa:docs` — passed during the sweep.
- `effigy graph status --refresh` — graph current; 449 files, 4,503 symbols,
  5,114 edges, stale 0.
- `effigy doctor` — passed after graph refresh; 19 OK, 0 warnings, 0 errors.
- Poodle evidence inspected from its current generation index, `g15/README.md`,
  `g15.005` closeout log, and current release-baseline front doors.

## Next task

Bring live dogfood feedback into Northstar when useful, then promote it through
the normal research, papercut, contract, spec, or roadmap surfaces. Do not
create a consumer dogfood handoff or start Figmatic work from Northstar.
