# Run Signal Consumer Autonomy Proof

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/009-prove-combined-autonomy-model-in-consumer-repo.md
Batch refs: docs/specs/batch-cards/040-run-consumer-repo-autonomy-proof.md

## Summary

Ran the combined autonomy model against Signal as the active consumer-repo
proof target, using Signal's live `g09` lane as a read-only operator proof.

## Proof Target

- Repo: `/Users/betterthanclay/Dev/projects/signal`
- Active generation: `g09`
- Active lane used for proof: `g09.005`
- Key proof surfaces:
  - `/Users/betterthanclay/Dev/projects/signal/docs/roadmaps/g09/README.md`
  - `/Users/betterthanclay/Dev/projects/signal/docs/roadmaps/g09/005-real-lv2-discovery-extension-negotiation-and-linux-proof.md`
  - `/Users/betterthanclay/Dev/projects/signal/docs/logs/2026-04/09-200000-g09-005-lv2-manifest-discovery-tranche.md`

## Findings

- Signal is a valid active proof target. The current live lane is `g09.005`,
  not `g09.003`.
- The roadmap surfaces inside Signal do give a clear active queue and next
  batch. `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, and
  `docs/roadmaps/g09/README.md` all route to the real current lane cleanly.
- The combined autonomy model is only partially expressible there because
  Signal intentionally does not use top-level `docs/specs/` right now, so
  there is no batch-card surface to carry continuation-envelope or lane-budget
  state explicitly.
- Signal's top-level `docs/README.md` and `docs/logs/README.md` are too generic
  or stale to carry the same autonomy state cleanly. The real currentness lives
  deeper in the roadmap lane and latest tranche log.
- That means the next useful Northstar adjustment is not more internal
  autonomy doctrine. It is clearer adoption guidance about when a repo must
  install the stricter `specs/` and batch-card layer if it wants the full
  autonomy model to be usable in practice.

## What This Proved

- The combined autonomy model is viable in a real repo that already uses a
  stricter planning surface.
- In a lighter roadmap-only repo, the model degrades gracefully to partial
  routing guidance, but it cannot fully express continuation-envelope and
  lane-budget state.

## What This Did Not Prove

- It did not prove the full autonomy model inside Signal itself, because the
  required `specs/` and batch-card surfaces are intentionally absent there.
- It did not require mutating Signal to gather the evidence.

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

The external proof run is complete and the consolidation batch is now the live
next step. The bounded proof-backed finding is clear: Northstar should explain
more sharply when a repo must move from roadmap-only mode to the stricter
specs-plus-batch-card mode if longer autonomous runs are a goal.

## Next Task

Start `g02.009` batch `9.3` by applying only the bounded findings that
materially improve the autonomy model after the consumer-repo proof.
