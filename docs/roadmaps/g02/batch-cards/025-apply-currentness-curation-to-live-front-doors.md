# 025 - Apply Currentness Curation To Live Front Doors

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/007-currentness-curation-and-evidence-window.md
Roadmap refs: g02.004 batch 4.2
Governing refs: docs/contracts/001-working-rules.md, docs/README.md, docs/logs/README.md
Auto-start next card: yes, if the re-proof batch remains explicit

## Objective

Apply the currentness curation rule to the live repo's front doors and recent
evidence surfaces without expanding the checker beyond deterministic alignment.

## Scope

- apply the one-spec and one-active-milestone rule to the live front doors
- trim `docs/logs/README.md` to a bounded current evidence window
- keep the checker aligned to the bounded live surface rather than historical
  completeness

## Steps

1. Apply the curation rule to the live docs front doors.
2. Trim `docs/logs/README.md` to the bounded current evidence window.
3. Update the repo checker only where deterministic alignment is still clear.

## Acceptance Criteria

- the live front doors match the current curation rule
- `docs/logs/README.md` shows a bounded active-lane evidence window
- the checker remains a bounded alignment check rather than a history linter
- the re-proof batch is explicit and ready

## Evidence Required

- updated live front-door and log README surfaces
- updated bounded checker assertions if needed
- next ready re-proof batch

## Stop Conditions

- the work starts encoding subjective curation choices as hard automation
- the evidence window becomes another growing month dump

## Completion Notes

Applied the curation rule to the live repo by keeping the single active spec
and active milestone on the front doors, restructuring `docs/logs/README.md`
around still-governing context plus a bounded recent active-lane evidence
window, and keeping the checker limited to deterministic alignment around that
live surface.

## Next Task

Start `g02.004` batch `4.3` by re-running the front-door path and recording
what ambiguity still remains acceptable after the curation update.
