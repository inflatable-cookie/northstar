# 2026-04-10 12:05:00 - Open Underlay Consumer Cohort And Install Underlay-Reference Strict Pass

## Summary

Opened a Northstar cohort lane for the six Underlay consumer apps and applied
the first concrete strict pass to `underlay-reference`.

## Completed work

- opened `g02.016` plus the governing spec for the Underlay consumer cohort
- recorded the migration order across:
  - `underlay-reference`
  - `contact-patch`
  - `songsprout`
  - `acowtancy`
  - `compli-me`
  - `loophole/composer`
- installed a strict wrapper in `underlay-reference` around the honest live
  owner `g01.007`
- refreshed Northstar front doors/currentness surfaces to point at the new
  cohort lane

## Underlay-Reference install notes

- adapted the strict install to the repo's existing `acme-docs/` authority
  instead of forcing a generic `docs/` root
- added product guardrails, working rules, specs, a batch-card surface, and a
  strict install log
- left the dirty app file
  `/Users/betterthanclay/Dev/projects/underlay-reference/acme-admin/src/routes/(app)/media/[mediaId]/+page.svelte`
  untouched

## Validation

- `effigy qa`
- `effigy qa:docs`
- `git -C /Users/betterthanclay/Dev/projects/underlay-reference diff --check`
- `effigy acme-docs/qa:docs --repo /Users/betterthanclay/Dev/projects/underlay-reference`
- `effigy acme-docs/qa:northstar --repo /Users/betterthanclay/Dev/projects/underlay-reference`

## Continuation Envelope

- Northstar continuation remains in-bounds for one more planning batch:
  reproving the `underlay-reference` strict pass and using that proof to choose
  the next consumer app

## Lane Budget / Pause Signal

- Lane budget state: one meaningful planning batch remains in-bounds
- Pause signal: `handoff-required`

## Next Task

Have the `underlay-reference` thread re-anchor on the new strict lane around
`g01.007`, then use that proof to choose whether `contact-patch` or
`songsprout` should be the next concrete consumer pass.
