# 023 - Prove Currentness Path And Compile Next Slice

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/006-currentness-surfaces-and-lightweight-alignment.md
Roadmap refs: g02.003 batch 3.3
Governing refs: docs/contracts/001-working-rules.md, docs/roadmaps/generation-index.md, docs/logs/README.md
Auto-start next card: yes, if the next currentness-curation lane is explicit

## Objective

Run the currentness path again after the new checks, record what still depends
on human judgment, and compile the next `g02` slice from that evidence.

## Scope

- prove the updated currentness path on the live repo
- identify the still-manual currentness decisions
- open the next lane around currentness curation instead of overgrowing the
  checker

## Steps

1. Run the currentness path through the live front doors and checked surfaces.
2. Record which decisions still require human judgment.
3. Compile the next `g02` slice from those findings.

## Acceptance Criteria

- the proof pass is recorded in a batch log
- the still-manual currentness decisions are explicit
- the next `g02` lane is open and aligned to the new finding

## Evidence Required

- proof-pass log with the manual-judgment findings
- next active milestone and spec chain

## Stop Conditions

- the work reopens checker scope instead of recording the remaining human
  judgment cleanly
- the next lane is not explicit enough to act on immediately

## Completion Notes

The proof pass showed that the lightweight checks are sufficient for the
deterministic stale states, but several currentness choices still need human
judgment:

- which active spec belongs on the main docs front door
- how much of the recent evidence chain should be surfaced in `docs/logs/README.md`
- when to use a dedicated currentness-triage log versus ordinary batch logs
- when an active milestone is important enough to surface prominently in
  multiple readmes

That points to a curation problem rather than a larger checker problem, so the
next lane focuses on currentness curation rules and evidence-window guidance.

## Next Task

Start `g02.004` batch `4.1` by defining currentness curation rules and the
evidence-window policy for live front doors.
