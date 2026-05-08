# 061 - Apply Remaining Underlay Consumer Strict Passes

Status: complete
Owner: repo maintainers
Completed: 2026-04-10
Roadmap: g02.016
Spec: docs/specs/019-underlay-consumer-cohort-and-underlay-reference-strict-pass.md
Governing refs: docs/contracts/001-working-rules.md

## Objective

Install the same full stricter Northstar paused posture in the remaining
Underlay consumer cohort repos after `underlay-reference` proved the pattern.

## Scope

- complete the pending strict installs in `contact-patch`, `songsprout`,
  `acowtancy`, `compli-me`, and `loophole/composer`
- adapt the strict posture to each repo's existing local docs authority
- leave dirty live implementation files untouched

## Out of Scope

- changing consumer implementation code
- forcing every repo into the same docs-root shape
- deciding the next product execution wave inside each consumer repo

## Steps

- [x] install a paused strict planning gate in `contact-patch/cp-docs`
- [x] install a paused strict planning gate in `songsprout/trellis`
- [x] install a paused strict planning gate in `acowtancy/ledger`
- [x] install a paused strict planning gate in `compli-me/docs`
- [x] install a paused strict planning gate in `loophole/composer/composer-docs`
- [x] validate the docs/currentness surfaces for the upgraded cohort

## Acceptance Criteria

- [x] all six Underlay consumer cohort repos now have a strict posture available
- [x] each upgraded repo points at one honest paused planning gate or ready card
- [x] dirty live implementation files in `underlay-reference` and `loophole/composer` remain untouched

## Validation

- [x] `git -C ~/Dev/projects/contact-patch diff --check`
- [x] `effigy cp-docs/qa:docs --repo ~/Dev/projects/contact-patch`
- [x] `effigy cp-docs/qa:northstar --repo ~/Dev/projects/contact-patch`
- [x] `git -C ~/Dev/projects/compli-me diff --check`
- [x] `effigy qa:northstar --repo ~/Dev/projects/compli-me/docs`
- [x] `git -C ~/Dev/projects/songsprout diff --check`
- [x] `effigy qa:docs --repo ~/Dev/projects/songsprout/trellis`
- [x] `effigy qa:northstar --repo ~/Dev/projects/songsprout/trellis`
- [x] `git -C ~/Dev/projects/acowtancy diff --check`
- [x] `effigy qa:docs --repo ~/Dev/projects/acowtancy/ledger`
- [x] `effigy qa:northstar --repo ~/Dev/projects/acowtancy/ledger`
- [x] `git -C ~/Dev/projects/loophole/composer diff --check`
- [x] `effigy qa:docs --repo ~/Dev/projects/loophole/composer/composer-docs`
- [x] `effigy qa:northstar --repo ~/Dev/projects/loophole/composer/composer-docs`

## Notes

- `effigy qa:docs --repo ~/Dev/projects/compli-me/docs` still fails on a pre-existing missing Underlay file in the repo's own rollout audit, not on the strict posture install.
- `effigy qa --repo ~/Dev/projects/loophole/composer/composer-docs` still fails on a pre-existing reorder-conflict rollout check in app code, not on the strict posture install.

## Next Task

Have each upgraded consumer thread re-anchor on its new strict planning gate before resuming work.
