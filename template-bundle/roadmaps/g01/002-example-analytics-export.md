# 002 - Example Analytics Export Refocus

**Type: EXAMPLE** -- Illustrates a blocked milestone and planning gap. Remove from your project after reading.

Status: blocked
Owner: Core Team
Created: YYYY-MM-DD
Depends on: g01.001
Vision tags: `ALIGN`, `RELIABILITY`, `OPS`
Contract refs: `003-analytics-export-contract.md`
Planning state: blocked on planning

## Problem

The product needs downstream analytics export, but execution drifted ahead of
planning and the seam now crosses an unresolved repo boundary.

## Goals

- [ ] Confirm the authoritative owner of the analytics export seam.
- [ ] Convert the seam into an explicit contract before implementation starts.
- [ ] Recompile this milestone once the seam is contract-backed.

## Non-Goals

- [ ] No export implementation work while seam ownership is unresolved.
- [ ] No worker or API-side guesswork about the downstream sink contract.

## Contract Coverage

- [ ] This milestone remains blocked until `003-analytics-export-contract.md`
      exists.
- [ ] The source and consumer repos must be listed in
      `repo-authority-map.md`.
- [ ] Any research-driven export decisions must be promoted before the milestone
      becomes ready.

## Execution Plan

### Batch 2.1 - Planning repair and seam ownership

- [ ] Audit current export assumptions in architecture, contracts, and roadmap
      files.
- [ ] Resolve whether `analytics-export` is first-party, vendor-owned, or out
      of scope.
- [ ] Create the seam contract or defer the export work from active scope.

### Batch 2.2 - Recompile and execute the first contract-valid export slice

- [ ] Recompile this milestone with the new contract refs and evidence
      requirements.
- [ ] Execute the first implementation batch only after planning state becomes
      `ready`.

## Acceptance Criteria

- [ ] Repo ownership for analytics export is explicit.
- [ ] The seam is covered by an active contract.
- [ ] This milestone is either recompiled as `ready` or explicitly deferred.

## Risks and Mitigations

- Risk: roadmap prose hides a missing cross-repo contract.
- Mitigation: keep milestone blocked until authority and contract coverage are
  explicit.

## Planning Gaps

- `analytics-export` ownership unresolved
- `003-analytics-export-contract.md` missing

## Evidence Requirements

- [ ] log showing the planning gap discovery for `g01.002`
- [ ] contract-delta log showing the seam contract was created or approved
- [ ] roadmap recompile log showing the milestone was updated from blocked to
      ready or deferred

## Next Task

Close the analytics seam planning gap and either create
`003-analytics-export-contract.md` or remove export work from the active queue.
