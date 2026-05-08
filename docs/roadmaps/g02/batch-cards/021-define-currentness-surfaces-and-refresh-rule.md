# 021 - Define Currentness Surfaces And Refresh Rule

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md
Roadmap refs: g02.003 batch 3.1
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/sections/03-roadmaps.md, bundle-docs/sections/04-logs.md
Auto-start next card: yes, if the lightweight check scope is explicit

## Objective

Define the repo's currentness surfaces and the rule for when they must be
refreshed, then open the next `g02` lane around that discipline.

## Scope

- name the canonical currentness surfaces in doctrine and the live working
  rules
- promote the same rule into the bundle readmes
- open `g02.003` and leave the lightweight-check batch explicit

## Steps

1. Define the currentness surfaces in the roadmap and log doctrine.
2. Add the same rule to the live working rules and bundle surfaces.
3. Open `g02.003` with an explicit next batch for lightweight enforcement.

## Acceptance Criteria

- the currentness surfaces are explicit in doctrine and live working rules
- the bundle tells downstream repos which front doors must stay aligned
- `g02.003` exists and the next batch is explicit

## Evidence Required

- updated doctrine, bundle, and live planning surfaces
- batch log recording the new lane and rule

## Stop Conditions

- the currentness rule stays vague enough that operators still cannot tell which
  pages are meant to stay aligned
- the new lane opens without a concrete enforcement batch

## Completion Notes

Defined the currentness surfaces and refresh rule across doctrine, bundle, and
live working rules, then opened `g02.003` so the next batch can add bounded
alignment enforcement rather than more prose-only reminders.

## Next Task

Start batch 3.2 by adding lightweight deterministic checks for the most
predictable currentness surfaces in the live Northstar repo.
