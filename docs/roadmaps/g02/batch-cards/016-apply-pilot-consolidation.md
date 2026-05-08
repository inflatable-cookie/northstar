# 016 - Apply Pilot Consolidation

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md
Roadmap refs: g02.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/maintenance/operator-doc-pruning-rubric.md
Auto-start next card: no

## Objective

Apply the concrete consolidation and routing fixes justified by the first real
consumer-repo pilot, then close the generation cleanly.

## Scope

- trim or merge low-value operator surfaces
- tighten the surviving docs/prompts/skill wording where the pilot found
  ambiguity
- validate and log the result

## Steps

1. Apply the consolidation decisions backed by the pilot record.
2. Update the affected docs, prompts, or skills.
3. Validate, close the generation state, and write the follow-on log.

## Acceptance Criteria

- at least one evidence-backed consolidation or trim lands
- the surviving surfaces reflect the pilot findings clearly
- validation passes after the consolidation

## Evidence Required

- updated docs/skills/prompt surfaces
- validation commands recorded in the batch log
- generation closeout reflected in roadmap state

## Stop Conditions

- the batch adds new docs instead of consolidating the existing ones
- the changes are no longer directly justified by the pilot evidence

## Completion Notes

Moved the pilot-maintenance pages out of `bundle-docs/operators/` and into
`bundle-docs/maintenance/` so the normal operator front door stays focused on
day-to-day repo routing rather than Northstar self-maintenance. Tightened
`operators/README.md` and `operator-quick-start.md` around the two states the
Signal pilot surfaced most clearly:

- healthy active repo -> repo docs, generation index, active milestone, latest
  log, then governing contracts only when needed
- unclear or drifted repo -> sweep plus recovery path

This trimmed the visible operator cluster without removing the maintenance
surfaces Northstar still needs for future pilots.

## Next Task

Continue `g02` with the execution-guardrails and longer-autonomy lane now that
the first external pilot and consolidation pass are complete.
