# 001 - Enact Northstar On Northstar

Status: complete
Owner: repo maintainers
Created: 2026-04-08
Depends on: none
Vision tags: `delivery-layer`, `autonomy`, `repo-discipline`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/archive/001-northstar-delivery-layer.md`
Planning state: complete

## Problem

Northstar cannot credibly define a stricter delivery framework for other repos
while this repo still develops itself without a live Northstar planning spine.

## Goals

- [x] Establish a real `docs/` spine for this repo.
- [x] Capture the delivery-layer doctrine as active Northstar artifacts.
- [x] Promote the live repo delivery layer into the reusable template bundle.
- [x] Update the installable skills so they rely on the stronger execution
      grammar by default.
- [x] Prove a longer autonomous lane against ready batch cards.

## Non-Goals

- [ ] Turning the template bundle into a bloated copy of this repo's internal
      planning state.
- [ ] Adding more public skills before the delivery layer proves itself.

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 1.1 - Establish live docs spine and doctrine

- [x] Add the live `docs/` spine for this repo.
- [x] Add the delivery/autonomy doctrine to `bundle-docs/sections/`.
- [x] Add the first master spec, batch card, and batch log.
- [x] Update repo references and validation so the live docs spine is enforced.

### Batch 1.2 - Promote delivery artifacts into the template bundle

- [x] Decide which delivery-layer artifacts become canonical bundle surfaces.
- [x] Add the minimum viable delivery-layer artifacts to `template-bundle/`
      without making the bundle noisy or repo-specific.
- [x] Add copy-ready specs templates and document the promotion rule.
- [x] Update bundle docs to explain the new copy-ready delivery surfaces.

### Batch 1.3 - Update installable skills for the delivery layer

- [x] Update `northstar-setup` so stricter projects install the guardrail pack.
- [x] Update `northstar-plan` so it emits master specs and batch cards by
      default for material work and promotes settled outcomes before execution.
- [x] Update `northstar-recover` and `northstar-handoff` so they preserve the
      active spec lane, canonical refs, and autonomy envelope.

### Batch 1.4 - Pilot longer autonomous execution

- [x] Card 006 - standardize the stricter docs spine in the bundle and doctrine.
- [x] Card 007 - align `northstar-setup` and setup templates with that docs spine.
- [x] Card 008 - tighten repo checks, run validation, and log the autonomy pilot.
- [x] Record what still causes premature stops or unsafe continuation.

## Acceptance Criteria

- [x] The repo has a standard Northstar `docs/` structure.
- [x] The delivery-layer doctrine is written in `bundle-docs/sections/`.
- [x] The repo has active working rules, a master spec, a batch card, and a batch
      log for the new framework.
- [x] The template bundle exposes the reusable delivery-layer surfaces.
- [x] The installable skills default to the stronger execution grammar where
      appropriate across the full five-skill surface.
- [x] One longer live multi-card lane has been executed and assessed against
      the written autonomy policy.

## Risks and Mitigations

- Risk: the repo adds process without enough real constraint.
- Mitigation: keep the live repo pilot concrete and require evidence/logging.
- Risk: the bundle becomes cluttered by repo-specific delivery artifacts.
- Mitigation: promote only the minimum reusable surfaces into `template-bundle/`.

## Planning Gaps

- No active planning gaps remain inside `g01.001`.
- Follow-on work should focus on reducing ready-state and closeout friction
  rather than adding more doctrine without a live use case.

## Evidence Requirements

- [x] One batch log per completed batch/update cycle.
- [x] Manual validation checks and commands actually run.
- [x] Follow-on log for bundle promotion and `northstar-plan` alignment.
- [x] Follow-on log for recover/handoff alignment.
- [x] Follow-on log for remaining skill updates.
- [x] Follow-on log for the autonomy pilot lane.

## Next Task

Compile `g01.002` from the autonomy-pilot findings so the next live batch
tightens ready-state selection and closeout mechanics for longer hands-off
execution.
