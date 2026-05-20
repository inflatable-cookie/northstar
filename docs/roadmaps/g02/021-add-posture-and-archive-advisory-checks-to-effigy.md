# 021 - Add Posture And Archive Advisory Checks To Effigy

Status: complete
Owner: repo maintainers
Created: 2026-05-19
Depends on: g02.019
Vision tags: `effigy`, `validation`, `strict-posture`, `archive`, `automation`
Governing refs: `docs/contracts/001-working-rules.md`,
`bundle-docs/sections/06-planning-and-contract-gates.md`,
`bundle-docs/sections/10-automation-runtime-policy.md`
Planning state: complete

## Problem

Doctrine and working rules describe strict posture, spec lifecycle, archive
behavior, and planning gates, but most drift shows up only when humans notice
it. Lightweight deterministic checks already proved their value for currentness;
the same class of signal is missing for common “declared versus actual” posture
mismatches (for example strict-ish repos missing archive surfaces, generation
index versus active files, batch-card folders when execution claims strict
lanes).

## Goals

- [x] extend the Effigy-facing checker suite with **advisory** (non-blocking or
      clearly labeled) rules for posture and archive consistency
- [x] document which checks exist, what they mean, and how operators should
      triage warnings
- [x] prove at least one check against this repo and one representative consumer
      or fixture path without turning `effigy qa` into noise for baseline repos

## Non-Goals

- [ ] a heavy generic docs linter that models full Northstar semantics
- [ ] blocking CI on advisory findings before operators agree on signal quality

## Execution Plan

### Batch 21.1 - Inventory Check Candidates And Severity Model

- [x] list concrete predicates worth checking (strict + specs implies archive
      README or path, active generation consistency, optional batch-cards path)
- [x] decide advisory versus error per predicate and document the policy in
      automation runtime doctrine or working rules as needed

### Batch 21.2 - Implement Checks And Wire Effigy Tasks

- [x] implement checks in the existing checker implementation used by Effigy
- [x] expose them through `effigy` tasks with predictable names and help text

### Batch 21.3 - Prove Signal Quality

- [x] run checks on northstar and capture false-positive/false-negative notes
- [x] adjust thresholds or messaging until warnings are actionable

## Acceptance Criteria

- [x] new checks run under Effigy with documented semantics
- [x] baseline repos do not inherit punitive noise for posture they do not claim
- [x] at least one check catches a realistic stale or inconsistent state that
      prose-only protocol previously hid

## Evidence

- `docs/logs/2026-05/19-172500-add-posture-advisory-effigy-checks.md`

## Next Task

Run `effigy check:posture-advisory` on downstream strict repos when triaging
drift; open the next `g02` milestone when new contract-backed work is queued.
