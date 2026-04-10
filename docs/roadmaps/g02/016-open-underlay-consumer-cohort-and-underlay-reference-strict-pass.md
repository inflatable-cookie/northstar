# 016 - Open Underlay Consumer Cohort And Underlay-Reference Strict Pass

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.015
Vision tags: `consumer-repos`, `underlay`, `strict-migration`, `cohort`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/019-underlay-consumer-cohort-and-underlay-reference-strict-pass.md`
Planning state: complete

## Problem

Underlay's own recovery lane is back under control, but the broader
Poodle-era normalization wave still spans six consumer apps. Northstar needs
one explicit cohort queue and one concrete first app-level strict pass so the
remaining rollout does not drift back into chat memory.

## Goals

- [x] open an explicit Northstar cohort lane for the six Underlay consumer apps
- [x] name `underlay-reference` as the first concrete app-level strict pass
- [x] install the strict wrapper around the honest live owner in
      `underlay-reference`
- [x] carry that proof through the remaining consumer cohort installs

## Non-Goals

- [x] strict-upgrading all six consumer apps in one batch
- [x] touching unrelated live app implementation in `underlay-reference`
- [x] forcing a generic `docs/` strict shape onto a repo whose authority
      already lives elsewhere

## Execution Plan

### Batch 16.1 - Open Cohort Lane And Install First App Pass

- [x] record the six-app cohort and sequencing logic in Northstar
- [x] install the `underlay-reference` strict wrapper around `g01.007`
- [x] refresh Northstar and `underlay-reference` currentness surfaces

### Batch 16.2 - Install Remaining Consumer Strict Passes

- [x] apply the same paused strict posture to the remaining five consumer repos
- [x] adapt each install to the repo's existing docs authority root
- [x] record residual non-doc validation blockers without conflating them with the docs installs

## Acceptance Criteria

- [x] Northstar has one explicit active lane for the Underlay consumer cohort
- [x] `underlay-reference` is in a usable strict posture around its live owner
- [x] the remaining five consumer repos now have matching strict posture installs

## Next Task

Apply the cohort lessons back into Northstar setup/package doctrine so nested
docs-authority repos become a first-class setup mode instead of a bespoke fix.
