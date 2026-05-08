# 014 - Select Consumer-Repo Pilot Target

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md
Roadmap refs: g02.001 batch 1.1
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/maintenance/operator-workflow-drill.md, bundle-docs/maintenance/operator-pilot-record-template.md
Auto-start next card: yes, if the pilot target and evidence contract are explicit

## Objective

Choose a real consumer repo for the first pilot and make the pilot evidence
contract explicit enough that the run will produce useful consolidation
decisions.

## Scope

- define the target-repo selection criteria
- tighten the pilot evidence expectations if needed
- leave one explicit pilot target or target-decision path

## Steps

1. Define the minimum traits a useful pilot repo must have.
2. Tighten the workflow drill and pilot-record expectations where they are too
   vague.
3. Record the target repo or the exact target-selection step as the next action.

## Acceptance Criteria

- the pilot target is explicit or the target-selection step is explicit enough
  to act on immediately
- the pilot evidence expectations are concrete enough to drive pruning
  decisions
- the next card can run a real pilot without reopening planning

## Evidence Required

- updated operator pilot surfaces if needed
- explicit target-selection outcome in the live planning state

## Stop Conditions

- the pilot target is still fuzzy enough to defer the real decision
- the evidence contract still would not support concrete pruning decisions

## Completion Notes

Selected `~/Dev/projects/signal` as the first external
pilot target because it has a live Northstar docs spine, an Effigy-first
operator loop, an active roadmap generation, and a real current execution lane
in `g09.003` around VST3 support. The earlier `monkey` candidate was dropped
once it became clear there was no live work there to route. The pilot evidence
contract now also requires ordered page-open traces, time to a valid next
batch, and false-start capture so consolidation decisions can be concrete.

## Next Task

Run the first real operator pilot against `signal` and record the actual
decision path.
