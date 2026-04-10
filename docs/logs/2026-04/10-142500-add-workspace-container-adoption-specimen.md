# Add Workspace-Container Adoption Specimen

Date: 2026-04-10
Roadmap refs: g02.018
Spec refs: docs/specs/021-workspace-container-adoption-specimen.md

## Summary

Added a concrete workspace-container specimen to the `northstar-setup`
surface so thin root plus nested docs-authority migrations no longer depend on
doctrine text alone.

## Evidence

- added `skills/northstar-setup/references/workspace-container-example.md`
- wired `adoption-modes.md`, `SKILL.md`, and template-selection guidance to
  point at the specimen
- kept the nested docs-authority lane and specimen lane coherent in Northstar's
  own planning spine

## Validation

- `effigy qa`
- `effigy qa:docs`

## Next Task

Use the new workspace-container specimen in the next multi-repo Northstar
migration and watch whether any remaining friction still needs package work.
