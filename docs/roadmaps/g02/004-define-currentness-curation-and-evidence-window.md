# 004 - Define Currentness Curation And Evidence Window

Status: complete
Owner: repo maintainers
Created: 2026-04-09
Depends on: g02.003
Vision tags: `currentness`, `curation`, `operator-flow`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/archive/007-currentness-curation-and-evidence-window.md`
Planning state: ready

## Problem

The currentness checker now catches deterministic stale states, but the proof
pass showed that the remaining friction is a curation problem: which active
surfaces deserve the front door, how much recent evidence should be surfaced,
and when currentness triage deserves an explicit log.

## Goals

- [x] record what still depends on human judgment after the lightweight checks
- [x] define currentness curation rules for front-door docs
- [x] define an evidence-window rule for recent logs
- [x] clarify the trigger for currentness-triage logs

## Non-Goals

- [ ] building a subjective curation linter
- [ ] expanding the currentness checker into a ranking engine

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 4.1 - Define Currentness Curation Rules

- [x] define the front-door curation rule
- [x] define the evidence-window rule for recent logs
- [x] define the currentness-triage trigger

### Batch 4.2 - Apply The Curation Rule

- [x] apply the curation rule to the live repo's front doors and log README
- [x] update any template or bundle surfaces that should match it
- [x] keep the checker bounded to deterministic alignment only

### Batch 4.3 - Re-Prove The Front-Door Path

- [x] run the front-door path again after applying the curation rule
- [x] record what ambiguity still remains acceptable
- [x] compile the next improvement slice from that evidence

## Acceptance Criteria

- [x] The remaining manual-judgment areas are explicit.
- [x] Currentness curation rules are explicit in doctrine and live working rules.
- [x] The evidence-window rule is explicit and applied to the live repo.
- [x] The front-door path is re-proved after the curation update.

## Risks and Mitigations

- Risk: the lane becomes another prose-only currentness discussion.
- Mitigation: make an application batch and a re-proof batch explicit.

- Risk: the checker expands beyond bounded deterministic alignment.
- Mitigation: keep curation rules human-facing and leave the checker repo-local
  and narrow.

## Planning Gaps

- none

## Evidence Requirements

- [x] proof-pass log for the manual-judgment findings
- [x] doctrine and live-rule updates for the curation batch
- [x] application log for the live curation batch
- [x] re-proof log for the follow-on batch

## Completion Notes

The currentness lane is now complete. The front-door path is short and coherent
enough to live with, so the next bounded improvement area shifts from
currentness to the lifecycle and archive posture of closed planning artifacts
under `docs/specs/`.

## Next Task

Start `g02.005` batch `5.1` by defining the spec lifecycle and archive rule in
doctrine, the bundle, and the live working rules.
