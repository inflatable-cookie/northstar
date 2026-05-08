# 004 - Align Recover And Handoff With Promotion Rule

Status: archived
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, skills/northstar-recover/SKILL.md, skills/northstar-handoff/SKILL.md
Auto-start next card: yes, if validation passes and the next card is ready

## Objective

Update recovery and handoff behavior so continuation work preserves both the
active spec lane and the canonical promoted refs instead of passing forward only
immediate task state.

## Scope

- update `northstar-recover` wording and recovery modes
- update `northstar-handoff` wording, contract, template, and metadata
- keep the live roadmap and log chain aligned with this behavior change

## Steps

1. Update `northstar-recover` to restore active specs and canonical refs during
   replans, refocus passes, and sweeps.
2. Update `northstar-handoff` so handoffs capture the active spec lane and the
   promoted architecture/contracts that now govern execution.
3. Record the work in the roadmap and logs.
4. Re-run validation.

## Acceptance Criteria

- `northstar-recover` explicitly restores the active spec lane and canonical
  promoted refs
- `northstar-handoff` explicitly preserves the active spec lane and canonical
  promoted refs
- `effigy qa`
- `effigy qa:docs`

## Evidence Required

- updated skill files under `skills/northstar-recover/` and
  `skills/northstar-handoff/`
- validation commands recorded in the batch log

## Stop Conditions

- handoffs still leave the next thread relying on stale provisional planning
- recovery still rewrites plans without restoring the canonical refs execution
  should trust

## Completion Notes

This card is complete. Recovery and handoff now preserve both the active spec
lane and the canonical promoted refs that execution should follow.

## Next Task

Update `northstar-setup` so stricter projects install the delivery-layer
guardrails and specs-promotion surfaces by default where appropriate.
