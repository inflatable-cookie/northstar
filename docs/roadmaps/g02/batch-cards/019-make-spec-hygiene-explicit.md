# 019 - Make Spec Hygiene Explicit

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md
Roadmap refs: g02.002 batch 2.3
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/sections/08-specs-and-promotion.md, template-bundle/specs/README.md
Auto-start next card: yes, if the longer autonomy lane is now explicit

## Objective

Make regular spec hygiene an explicit part of the Northstar protocol so
`docs/specs/` stays focused on active planning instead of swelling into a
second archive of stale plans.

## Scope

- update the published doctrine to require regular spec hygiene
- update the live working rules and bundle surfaces to match
- shift the live milestone so the longer autonomy lane follows this cleanup
  rule explicitly

## Steps

1. Add an explicit spec-hygiene rule to the published specs doctrine.
2. Add the same rule to the live working rules and copy-ready bundle surfaces.
3. Update the live milestone so the next batch is the longer autonomy lane.

## Acceptance Criteria

- the protocol explicitly says specs should be tidied regularly
- the bundle and live repo both define that specs should mostly reflect active
  planning
- the next batch for the longer autonomy lane is explicit

## Evidence Required

- updated doctrine, bundle, and live planning surfaces
- batch log recording the protocol change

## Stop Conditions

- the change only tweaks wording without making spec hygiene operational
- the protocol implies specs must always be deleted instead of tidied

## Completion Notes

Made regular spec hygiene explicit across doctrine, live working rules, bundle
surfaces, and the active `g02.002` lane. The rule is now clear: keep active or
still-useful specs, and archive or remove stale ones so the folder mostly
reflects live planning.

## Next Task

Start batch 2.4 by running a longer live Northstar lane under the tightened
guardrails and the new spec-hygiene rule.
