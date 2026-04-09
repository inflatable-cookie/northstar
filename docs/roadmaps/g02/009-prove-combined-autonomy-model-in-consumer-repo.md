# 009 - Prove Combined Autonomy Model In Consumer Repo

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.008
Vision tags: `autonomy`, `external-proof`, `operators`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/012-consumer-repo-autonomy-proof-and-adoption.md`
Planning state: ready

## Problem

Northstar's combined continuation, lane-budget, and pause-signal model now
looks coherent in this repo, but that is still internal proof. The next real
question is whether the model holds up in an active consumer repo where the
work is not self-referential doctrine maintenance.

## Goals

- [x] define the consumer-repo proof lane
- [x] run the combined autonomy model against a real active consumer repo
- [x] apply only the bounded findings that external proof justifies

## Non-Goals

- [ ] opening another internal-only doctrine lane before external proof
- [ ] treating inactive or artificial targets as equivalent proof

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 9.1 - Define Consumer-Repo Autonomy Proof Lane

- [x] define the valid proof target and evidence contract
- [x] leave the external-proof batch explicit and ready

### Batch 9.2 - Run Consumer-Repo Autonomy Proof

- [x] choose the active target lane deliberately
- [x] run the proof against a real consumer repo
- [x] leave the consolidation batch explicit and ready

### Batch 9.3 - Apply Consumer-Repo Autonomy Findings

- [x] apply only the bounded findings that materially improve the model
- [x] refresh currentness/check surfaces affected by those changes
- [x] open another slice only if a bounded problem remains

## Acceptance Criteria

- [x] The consumer-repo proof lane is explicit.
- [x] A real external proof run is completed.
- [x] Only bounded proof-backed changes are applied back into Northstar.

## Risks and Mitigations

- Risk: the lane picks an inactive or low-signal repo and mistakes it for proof.
- Mitigation: require an active repo and live Northstar lane before the proof
  can start.

- Risk: the consolidation batch reintroduces internal churn.
- Mitigation: allow only proof-backed changes from the external run.

## Planning Gaps

- none

## Evidence Requirements

- [x] definition log for the external-proof lane
- [x] external-proof log for the consumer repo
- [x] consolidation log for proof-backed improvements

## Completion Notes

This lane proved the important boundary cleanly:

- the combined autonomy model holds up as a design
- baseline roadmap-only repos can still route real active work well
- the fuller autonomy model needs the stricter `specs/` and batch-card layer if
  it is supposed to remain explicit and portable across threads

The next lane should prove that stricter adoption threshold in a real consumer
repo rather than extending doctrine in the abstract.

## Next Task

Start `g02.010` batch `10.2` by testing the stricter delivery-layer adoption
threshold against a real active consumer-repo lane.
