# Tighten Chatterbox Triage and Coordinator Routing

Date: 2026-09-04
Status: complete

## Trigger

A live Chatterbox created a one-line note to deprecate one statement in an
existing triage note. The active mode still described triage capture as
new-file-only. The same review found two remaining coordinator ambiguities:
initial triage scanning and documentation-heavy implementation routing through
mechanical audit profiles.

## Changes

- Made triage explicitly mutable. A new issue gets one file; later changes to
  that issue update the same file without correction-note chains.
- Made promotion prune triage in the same coherent commit. Full promotion
  deletes the note; partial promotion leaves only unresolved meaning.
- Removed open-triage loading and planning-branch selection from the
  coordinator fast path. Coordination observations return to Chatterbox as
  typed recommendations or context-complete escalations.
- Made worker selection role-first. Audit, documentation-grind, review,
  planning, and coordinator profiles cannot author implementation lanes merely
  because the work is broad or documentation-heavy.
- Added executable Git lifecycle coverage and structural/routing assertions for
  all three boundaries.

## Evidence

- `effigy check:chatterbox-git` — passed, 20 assertions.
- `effigy check:command-skills` — passed.
- `effigy check:model-routing` — passed, 11 routing oracle rows.
- `effigy qa:docs` — passed.
- `effigy qa` — passed.
- Installed Northstar copies under `.agents` and `.claude` match the tracked
  source payload exactly.

## Current state

The planning-to-promotion protocol no longer needs append-only triage behavior,
coordinator triage interpretation, or semantic profile inference from file
count. Card 126 remains a passive observation lane and does not block unrelated
work.
