# 063 - Add Workspace-Container Adoption Specimen

Status: complete
Owner: repo maintainers
Completed: 2026-04-10
Roadmap: g02.018
Spec: docs/specs/021-workspace-container-adoption-specimen.md
Governing refs: docs/contracts/001-working-rules.md

## Objective

Add one concrete workspace-container adoption specimen to the reusable
Northstar package so multi-repo setup does not depend on doctrine alone.

## Scope

- close the nested docs-authority setup lane
- add one specimen/reference for thin workspace root plus nested authority repo
- point setup docs and template-selection guidance at that specimen

## Out of Scope

- redesigning the broader setup workflow
- adding multiple overlapping specimens
- changing consumer repos again

## Steps

- [x] close `g02.017` and open the specimen lane
- [x] add one workspace-container specimen to `northstar-setup` references
- [x] update setup/adoption/template guidance to point at the specimen
- [x] log the change and refresh Northstar front doors

## Acceptance Criteria

- [x] setup has one concrete workspace-container specimen
- [x] the specimen shows the contract split between thin root and nested docs authority
- [x] future multi-repo migrations can reference one concrete example instead of abstract prose alone

## Validation

- [ ] `effigy qa`
- [ ] `effigy qa:docs`

## Next Task

Watch the next real multi-repo setup or migration and decide whether the setup
package now has enough concrete adoption examples or whether a further mode
still needs its own specimen.
