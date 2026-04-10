# 060 - Open Underlay Consumer Cohort And Install Underlay-Reference Strict Pass

Status: complete
Owner: repo maintainers
Completed: 2026-04-10
Roadmap: g02.016
Spec: docs/specs/019-underlay-consumer-cohort-and-underlay-reference-strict-pass.md
Governing refs: docs/contracts/001-working-rules.md

## Objective

Turn the Underlay consumer app set into an explicit Northstar cohort and apply
the first concrete strict pass to `underlay-reference` without touching its
live dirty app worktree.

## Scope

- open the cohort lane in Northstar with an explicit app order
- install a full strict wrapper around the honest live owner in
  `underlay-reference`
- update Northstar and `underlay-reference` front doors/currentness surfaces

## Out of Scope

- changing live implementation code in `underlay-reference`
- picking the second consumer app from intuition alone
- forcing a new docs-root shape on `underlay-reference`

## Steps

- [x] record the six-app Underlay consumer cohort and migration order in
      Northstar
- [x] open `underlay-reference` as the first concrete app-level pass
- [x] install strict guardrails, working rules, specs, and a ready card around
      `acme-docs/roadmaps/g01/007-retained-underlay-surface-formalization.md`
- [x] refresh Northstar and `underlay-reference` front doors/currentness
      surfaces

## Acceptance Criteria

- [x] Northstar has one explicit active lane for the Underlay consumer cohort
- [x] `underlay-reference` has a strict wrapper around `g01.007`
- [x] `underlay-reference` currentness surfaces point at the new ready card
- [x] the live dirty app file in `underlay-reference` remains untouched

## Validation

- [x] `effigy qa`
- [x] `effigy qa:docs`
- [x] `git -C /Users/betterthanclay/Dev/projects/underlay-reference diff --check`
- [x] `effigy acme-docs/qa:docs --repo /Users/betterthanclay/Dev/projects/underlay-reference`
- [x] `effigy acme-docs/qa:northstar --repo /Users/betterthanclay/Dev/projects/underlay-reference`

## Evidence

- new Northstar cohort spec and roadmap milestone
- strict-lane install in `underlay-reference/acme-docs/`
- install log in each repo's active log shard

## Stop Conditions

- the strict install requires edits to unrelated consumer implementation code
- repo-local authority in `underlay-reference` proves too incoherent to wrap

## Next Task

Have the `underlay-reference` thread re-anchor on the new strict lane around
`g01.007`, then use that proof to choose whether `contact-patch` or
`songsprout` should be the next concrete consumer pass.
