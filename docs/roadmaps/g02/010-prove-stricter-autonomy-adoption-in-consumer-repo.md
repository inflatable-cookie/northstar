# 010 - Prove Stricter Autonomy Adoption In Consumer Repo

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.009
Vision tags: `autonomy`, `adoption`, `external-proof`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/013-stricter-consumer-repo-autonomy-adoption.md`
Planning state: ready

## Problem

Northstar now knows that the combined autonomy model needs the stricter
`specs/` plus batch-card layer when a repo wants longer autonomous runs. The
next real question is how to prove that adoption threshold against a real
active consumer repo instead of leaving it as doctrine.

## Goals

- [x] define the stricter-adoption proof lane
- [x] test the adoption threshold against a real active consumer repo
- [x] apply only the bounded findings that external proof justifies

## Non-Goals

- [ ] forcing every consumer repo onto the stricter layer
- [ ] treating baseline roadmap mode as invalid
- [ ] opening another internal-only doctrine lane before external proof

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 10.1 - Define Stricter Adoption Proof Lane

- [x] define the valid external-proof target and evidence contract
- [x] leave the external proof batch explicit and ready

### Batch 10.2 - Run Stricter Consumer-Repo Adoption Proof

- [x] choose the active target lane deliberately
- [x] test whether roadmap-only mode is still the right posture
- [x] leave the consolidation batch explicit and ready

### Batch 10.3 - Apply Stricter Adoption Findings

- [x] apply only the bounded findings that materially improve setup and
      planning guidance
- [x] refresh currentness/check surfaces affected by those changes
- [x] open another slice only if a bounded problem remains

## Acceptance Criteria

- [x] The stricter-adoption proof lane is explicit.
- [x] A real external adoption-proof run is completed.
- [x] Only bounded proof-backed changes are applied back into Northstar.

## Risks and Mitigations

- Risk: the lane treats stricter adoption as predetermined instead of proving
  it.
- Mitigation: require the proof to decide whether baseline or stricter posture
  is actually warranted in the target repo.

- Risk: the lane reintroduces internal doctrine churn without new evidence.
- Mitigation: allow only proof-backed changes from the external run.

## Planning Gaps

- none

## Evidence Requirements

- [x] definition log for the stricter-adoption proof lane
- [x] external-proof log for the consumer repo
- [x] consolidation log for proof-backed improvements

## Batch 10.2 Outcome

Signal is the right proof target because it is active, already uses Northstar
surfaces, and is carrying a deep real implementation lane under `g09.005`.

The proof result is not "convert Signal wholesale" and it is not "baseline is
always enough." The sharper conclusion is:

- Signal's repo-wide baseline roadmap mode is still valid
- the active plugin-realization lane is deep enough that longer autonomous runs
  would benefit from stricter execution state
- the right adoption shape is lane-first stricter mode inside a mature baseline
  repo, not an all-at-once repo rewrite

That means the next Northstar change should be bounded: teach setup and
template guidance how to support lane-first stricter adoption cleanly.

## Completion Notes

This lane proved and promoted a useful middle posture:

- baseline roadmap mode remains valid
- full stricter-mode conversion is not the only upgrade path
- mature baseline repos can adopt the stricter `specs/` plus batch-card layer
  lane-first when one active lane needs fuller execution state

The next useful improvement is practical: make that lane-first adoption path
easier to seed through a minimal starter pack and migration sequence.

## Next Task

Start `g02.011` batch `11.1` by defining the minimal lane-first stricter
adoption starter pack and migration sequence for mature baseline repos.
