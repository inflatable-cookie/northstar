# Apply Archive-Aware Skill Alignment

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/006-align-archive-aware-skill-and-setup-surfaces.md
Batch refs: docs/specs/batch-cards/031-apply-archive-aware-skill-alignment.md

## Summary

Applied the archive-aware contract to the reusable skills, stricter setup
guidance, and bundle defaults so downstream repos inherit the archive posture
without extra operator explanation.

## Findings

- `northstar-setup` now treats `docs/specs/archive/README.md` as part of the
  stricter delivery surface instead of only implying archive behavior.
- `northstar-plan` now reads the archive surface when present and treats spec
  lifecycle decisions as part of normal closeout rather than a separate cleanup
  project.
- `northstar-recover` now inspects archive posture explicitly when repairing
  stale planning state.
- The bundle now makes it clear that stricter repos can seed
  `docs/specs/archive/README.md` from the start.
- The contract remains intentionally light: Northstar explains and enforces the
  posture, but it does not auto-archive artifacts behind the operator's back.

## Files Changed

- skills/northstar-setup/SKILL.md
- skills/northstar-plan/SKILL.md
- skills/northstar-recover/SKILL.md
- skills/northstar-setup/references/delivery-layer-adoption.md
- template-bundle/specs/README.md
- template-bundle/specs/archive/README.md
- docs/specs/batch-cards/031-apply-archive-aware-skill-alignment.md
- docs/specs/batch-cards/032-reprove-archive-aware-surface.md
- docs/roadmaps/g02/006-align-archive-aware-skill-and-setup-surfaces.md
- docs/README.md
- docs/specs/README.md
- docs/roadmaps/README.md
- docs/roadmaps/g02/README.md
- docs/roadmaps/generation-index.md
- docs/contracts/contract-index.md
- docs/logs/README.md
- scripts/check-northstar-repo-contract.ts

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

The archive-aware behavior is now explicit in routine setup, planning, and
recovery surfaces, and the bundle matches that posture without introducing
heavy automation.

## Next Task

Start `g02.006` batch `6.3` by re-proving the reusable archive-aware surface
and recording whether any bounded ambiguity still remains.
