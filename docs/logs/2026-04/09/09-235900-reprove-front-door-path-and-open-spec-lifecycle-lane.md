# Re-Prove Front-Door Path And Open Spec Lifecycle Lane

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.004 batch 4.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/007-currentness-curation-and-evidence-window.md

## Summary

Re-ran the live front-door path after the currentness curation update. The path
is now materially easier to trust and the remaining ambiguity is small enough
to live with. The next bounded issue is no longer front-door curation but the
underlying lifecycle of closed planning artifacts in `docs/specs/`.

## Findings

The front-door path is now short and coherent:

- `docs/README.md` surfaces one active spec and one active roadmap
- the roadmap front doors agree on the active generation and milestone
- `docs/logs/README.md` now shows still-governing context plus a bounded recent
  evidence window

The remaining ambiguity is acceptable for currentness purposes. The bigger live
problem is that `docs/specs/` still contains many closed master specs and
batch-card lanes in place, which weakens the protocol's claim that specs are
provisional and regularly reduced.

## Files Changed

- added `docs/specs/008-spec-lifecycle-and-archive-mechanics.md`
- added `docs/roadmaps/g02/batch-cards/027-define-spec-lifecycle-and-archive-rule.md`
- added `docs/roadmaps/g02/batch-cards/028-apply-spec-lifecycle-rule-to-live-repo.md`
- added `docs/roadmaps/g02/batch-cards/029-reprove-specs-surface-after-lifecycle-update.md`
- added `docs/roadmaps/g02/005-tighten-spec-lifecycle-and-archive-mechanics.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- `g02.004` is now complete
- the currentness curation lane does not need another bounded follow-on slice
- `g02.005` is now open around spec lifecycle and archive mechanics

## Unresolved

- the lifecycle rule and archive posture still need to be defined
- the live specs surface still needs to be reduced so it mostly reflects active
  planning

## Next Task

Start `g02.005` batch `5.1` by defining the spec lifecycle and archive rule in
doctrine, the bundle, and the live working rules.
