# Apply Continuation Envelope Contract

Date: 2026-04-10
Roadmap refs: docs/roadmaps/g02/007-define-continuation-envelope-and-stop-signal-contract.md
Batch refs: docs/specs/batch-cards/034-apply-continuation-envelope-contract.md

## Summary

Applied the continuation-envelope and stop-signal contract to the live working
rules, reusable batch-card and log templates, and the planning/handoff
surfaces that need to carry bounded continuation state.

## Findings

- the working rules now distinguish a bounded continuation envelope from a
  generic auto-start flag
- closeout now explicitly records whether continuation remains in-bounds or a
  stop signal exhausted it
- batch-card and handoff templates now preserve the remaining continuation
  state instead of reducing context to only the current card
- the contract remains intentionally compact and file-state driven, not an
  orchestration subsystem

## Files Changed

- docs/contracts/001-working-rules.md
- template-bundle/specs/templates/batch-card-template.md
- template-bundle/logs/README.md
- template-bundle/logs/templates/thread-handoff-template.md
- skills/northstar-plan/SKILL.md
- skills/northstar-handoff/SKILL.md
- skills/northstar-handoff/references/handoff-contract.md
- skills/northstar-handoff/assets/templates/northstar-handoff.md.template
- docs/specs/010-continuation-envelope-and-stop-signal-contract.md
- docs/specs/batch-cards/034-apply-continuation-envelope-contract.md
- docs/specs/batch-cards/035-reprove-continuation-envelope-contract.md
- docs/roadmaps/g02/007-define-continuation-envelope-and-stop-signal-contract.md
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

The continuation model is now explicit in the reusable doctrine, templates,
and handoff/planning surfaces. The next step is to re-prove it against a
longer autonomous lane.

## Next Task

Start `g02.007` batch `7.3` by re-proving the continuation-envelope contract
against a longer autonomous lane.
