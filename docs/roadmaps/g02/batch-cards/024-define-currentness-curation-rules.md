# 024 - Define Currentness Curation Rules

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/007-currentness-curation-and-evidence-window.md
Roadmap refs: g02.004 batch 4.1
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/sections/03-roadmaps.md, bundle-docs/sections/04-logs.md
Auto-start next card: yes, if the application batch is explicit

## Objective

Define the currentness curation rules for front doors and the evidence-window
policy for recent logs.

## Scope

- clarify which active spec and milestone belong on the main docs front door
- define how much recent evidence belongs in `docs/logs/README.md`
- define when a currentness-triage log should be used explicitly

## Steps

1. Define the curation rule for front-door docs.
2. Define the evidence-window rule for recent logs.
3. Define the trigger for currentness-triage logs.

## Acceptance Criteria

- the curation rule narrows the remaining human judgment materially
- the evidence-window rule is explicit enough to apply in the live repo
- the next application batch is explicit

## Evidence Required

- updated doctrine, bundle, and live working-rules surfaces
- next active application batch

## Stop Conditions

- the curation rule stays so vague that it cannot guide a real repo
- the work tries to encode subjective judgment as hard automation

## Completion Notes

Recorded three explicit rules across doctrine, bundle guidance, and the live
working rules:

- front-door docs should name one active milestone and only surface one active
  spec when it still governs the current lane
- `docs/logs/README.md` should keep a bounded recent-evidence window, usually
  the latest 5 active-lane logs plus any still-governing rollover or decision
  log
- a dedicated currentness-triage log is for currentness-cleanup batches or
  multi-surface drift that ordinary closeout would not capture cleanly

## Next Task

Start `g02.004` batch `4.2` by applying the curation rule to the live repo's
front doors and `docs/logs/README.md`.
