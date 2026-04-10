# 062 - Promote Nested Docs-Authority Support Into Setup

Status: complete
Owner: repo maintainers
Completed: 2026-04-10
Roadmap: g02.017
Spec: docs/specs/020-formalize-nested-docs-authority-setup.md
Governing refs: docs/contracts/001-working-rules.md

## Objective

Turn nested docs-authority repos into a first-class Northstar setup mode in
the reusable doctrine, setup guidance, and templates.

## Scope

- close the consumer-cohort lane with the setup lesson captured
- update doctrine and bundle guidance to explain nested docs-authority repos
- update `northstar-setup` guidance and templates so native Effigy validation
  works cleanly for nested authority roots

## Out of Scope

- changing existing consumer repo work beyond the already-installed strict posture
- redesigning Effigy itself
- reworking the baseline vs strict doctrine outside the nested-authority gap

## Steps

- [x] close the completed Underlay consumer cohort lane and open the nested-authority improvement lane
- [x] update package/doctrine text to make nested docs-authority repos an explicit supported mode
- [x] update setup guidance and add a copy-ready nested-authority native Effigy template
- [x] log the improvement and refresh Northstar front doors/currentness

## Acceptance Criteria

- [x] Northstar no longer describes nested docs-authority repos like bespoke exceptions
- [x] `northstar-setup` has clear guidance for nested authority roots and native Effigy docs checks
- [x] a copy-ready template exists for nested docs-authority native Effigy config

## Validation

- [ ] `effigy qa`
- [ ] `effigy qa:docs`

## Next Task

Decide whether the next recurring setup gap warrants a dedicated
workspace-container adoption specimen or whether the new nested-authority
guidance is sufficient.
