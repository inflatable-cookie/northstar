# Define Currentness Curation Rules

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.004 batch 4.1
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/007-currentness-curation-and-evidence-window.md

## Summary

Defined the human-facing curation policy that remains after the lightweight
currentness checks. This batch does not try to automate those choices away. It
defines how the front doors should present the active lane, how much recent
evidence belongs in `docs/logs/README.md`, and when a dedicated
currentness-triage log is actually warranted.

## Findings

The remaining currentness friction is narrow enough to handle with a small set
of curation rules:

- front-door docs should name one active milestone and only one active spec,
  and only when that spec still governs the current lane
- `docs/logs/README.md` should show a bounded recent-evidence window rather
  than an ever-growing month list
- dedicated currentness-triage logs are for currentness-cleanup batches or
  multi-surface drift, not ordinary roadmap progress

## Files Changed

- updated `bundle-docs/sections/03-roadmaps.md`
- updated `bundle-docs/sections/04-logs.md`
- updated `template-bundle/roadmaps/README.md`
- updated `template-bundle/logs/README.md`
- updated `docs/contracts/001-working-rules.md`
- updated `docs/roadmaps/g02/batch-cards/024-define-currentness-curation-rules.md`
- updated `docs/roadmaps/g02/004-define-currentness-curation-and-evidence-window.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the curation rule is now explicit in doctrine, the bundle, and the live repo
- the evidence-window rule is now explicit instead of ad hoc
- the dedicated currentness-triage log has a clear trigger

## Unresolved

- the live repo front doors and `docs/logs/README.md` still need to be updated
  to follow the new curation rule
- the front-door path still needs one more proof pass after that application

## Next Task

Start `g02.004` batch `4.2` by applying the curation rule to the live repo's
front doors and `docs/logs/README.md`.
