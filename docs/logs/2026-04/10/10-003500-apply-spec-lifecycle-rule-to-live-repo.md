# Apply Spec Lifecycle Rule To Live Repo

Status: complete
Owner: repo maintainers
Date: 2026-04-10
Roadmap refs: g02.005 batch 5.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/008-spec-lifecycle-and-archive-mechanics.md

## Summary

Applied the lifecycle and archive rule to Northstar's live specs surface. The
active `docs/specs/` tree now carries only the live lifecycle spec, the active
cleanup card chain, and the archive surfaces needed for preserved history.

## Findings

The main cleanup decision was straightforward:

- closed master specs `001` through `007` no longer belong in the active tree
- completed batch cards `001` through `027` no longer belong in the active
  batch-card lane
- the active tree should now focus on the current lifecycle lane: `008`, `028`,
  and `029`

That materially reduces the active specs surface without losing traceability,
because the closed artifacts now live under `docs/specs/archive/`.

## Files Changed

- moved `docs/specs/archive/001-northstar-delivery-layer.md` through `docs/specs/archive/007-currentness-curation-and-evidence-window.md`
- moved `docs/specs/archive/batch-cards/001-establish-live-northstar-docs-spine.md` through `docs/specs/archive/batch-cards/027-define-spec-lifecycle-and-archive-rule.md`
- updated repo references that still pointed at those archived planning artifacts
- updated `docs/specs/batch-cards/028-apply-spec-lifecycle-rule-to-live-repo.md`
- updated `docs/specs/batch-cards/029-reprove-specs-surface-after-lifecycle-update.md`
- updated `docs/specs/README.md`
- updated `docs/roadmaps/g02/005-tighten-spec-lifecycle-and-archive-mechanics.md`
- updated `docs/logs/README.md`
- updated `scripts/check-northstar-repo-contract.ts`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the live specs surface now mostly reflects active planning
- preserved planning history moved out of the active tree and into the archive
- the re-proof batch is now the next active step

## Unresolved

- the cleaned-up specs surface still needs one re-proof pass

## Next Task

Start `g02.005` batch `5.3` by re-proving the specs surface after the lifecycle
update.
