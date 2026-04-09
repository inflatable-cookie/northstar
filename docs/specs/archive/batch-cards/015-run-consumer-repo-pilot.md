# 015 - Run Consumer-Repo Pilot

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md
Roadmap refs: g02.001 batch 1.2
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/maintenance/operator-workflow-drill.md, bundle-docs/maintenance/operator-pilot-record-template.md
Auto-start next card: yes, if the pilot record is complete and points at clear consolidation decisions

## Objective

Run the first real Northstar operator pilot against a consumer repo and record
what actually helped, what was redundant, and where the operator path still
broke down.

## Scope

- run the workflow drill against the selected consumer repo
- fill the pilot record from real use
- identify the concrete docs/skills/prompts that should be trimmed or tightened

## Steps

1. Run the operator workflow drill against the selected repo.
2. Fill the pilot record from the actual decision path.
3. Extract the concrete consolidation or routing fixes the evidence supports.

## Acceptance Criteria

- one real consumer-repo pilot has been run
- the pilot record is complete enough to support pruning or consolidation
- the next card has concrete changes to apply rather than speculative cleanup

## Evidence Required

- completed pilot record
- follow-on log summarizing the real operator path

## Stop Conditions

- the pilot devolves into a seeded specimen drill again
- the record is too vague to support real consolidation decisions

## Completion Notes

Ran the first real shadow-operator pilot against `/Users/betterthanclay/Dev/projects/signal`
using the active `g09.003` VST3 lane as the target. The decisive path was much
shorter than the current operator doc cluster implies: once the repo and active
lane were explicit, the useful chain was `operator-quick-start -> Signal
generation index -> active roadmap lane -> current tranche log -> governing
contracts`. That was enough to reach a valid next batch without sweep or
refocus work.

The most important mismatch the pilot surfaced is that the current operator
docs are still too recovery-oriented. For a healthy active repo, several pages
in the drill are incidental rather than decisive, and the fastest route to a
valid next batch depends more on the consumer repo's own generation and log
state than on deeper Northstar operator support pages.

## Next Task

Apply the evidence-backed consolidation and tighten the operator front door so
healthy active repos reach a valid next batch with fewer incidental pages.
