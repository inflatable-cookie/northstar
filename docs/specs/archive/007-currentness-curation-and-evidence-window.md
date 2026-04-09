# 007 - Currentness Curation And Evidence Window

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.004

## Problem

The currentness checker now catches the most predictable stale states, but the
proof pass showed that several important currentness decisions still depend on
human judgment. Northstar still needs a clearer rule for what the front doors
should surface, how much recent evidence belongs there, and when currentness
triage deserves its own explicit log.

## Target Operating Model

Northstar should narrow the remaining human judgment without trying to automate
it away completely.

That means:

- front-door docs have a clearer curation rule for which active spec and
  milestone to surface
- `docs/logs/README.md` has an explicit evidence-window rule instead of an
  ad hoc list that grows without guidance
- currentness-triage logs have a clearer trigger so they are used deliberately
  rather than rarely or inconsistently
- the lightweight checker stays bounded and does not expand into a generic
  curation engine

## Goals

- Define currentness curation rules for the main docs front doors.
- Define an evidence-window rule for recent logs.
- Clarify when a dedicated currentness-triage log should be written.
- Keep `g02` open with another substantive currentness-focused lane.

## Non-Goals

- Building a ranking engine for docs surfaces.
- Checking subjective curation choices mechanically.
- Replacing the existing lightweight checker with a larger linter.

## Artifact Set

- `bundle-docs/sections/03-roadmaps.md`
- `bundle-docs/sections/04-logs.md`
- `template-bundle/roadmaps/README.md`
- `template-bundle/logs/README.md`
- `docs/contracts/001-working-rules.md`
- `docs/roadmaps/g02/004-define-currentness-curation-and-evidence-window.md`

## Phased Delivery

### Phase 1

Define the curation rules and evidence-window policy in doctrine, bundle, and
the live working rules.

### Phase 2

Apply the curation rules to the live repo's currentness surfaces.

### Phase 3

Run the front-door path again and record whether the remaining ambiguity is now
small enough to live with.

## Acceptance Criteria

- Northstar doctrine defines currentness curation rather than only alignment.
- The bundle gives downstream repos a clear evidence-window rule.
- The live repo has a dedicated lane for applying and re-proving that rule.
- The next batch is explicit and ready.

## Completion Notes

This spec delivered the currentness curation rule, the bounded evidence-window
rule for live log front doors, and the re-proof that the resulting front-door
path is now acceptable without another currentness-focused follow-on slice.

## Stop Conditions

- the lane turns into prose-only restatement of the currentness rule
- the work tries to make subjective curation fully automatic
- the lane expands beyond bounded front-door and evidence-window guidance

## Next Task

Start `g02.005` batch `5.1` by defining the spec lifecycle and archive rule in
doctrine, the bundle, and the live working rules.
