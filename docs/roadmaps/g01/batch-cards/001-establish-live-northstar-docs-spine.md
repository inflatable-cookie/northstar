# 001 - Establish Live Northstar Docs Spine

Status: archived
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.1
Governing refs: docs/contracts/001-working-rules.md
Auto-start next card: yes, if validation passes and the next card is ready

## Objective

Create a real `docs/` spine for this repo and capture the delivery-layer
doctrine as active Northstar artifacts rather than leaving it only in chat.

## Scope

- add the live repo `docs/` structure
- write active vision, architecture, contracts, spec, roadmap, and first log
- add the delivery/autonomy doctrine to `bundle-docs/sections/`
- update repo references and validation so the live docs spine is now enforced

## Steps

1. Create the repo-local `docs/` tree with standard Northstar sections.
2. Write the vision, architecture, product guardrails, compact working-rules
   contract, spec, roadmap, and first log.
3. Add the delivery/autonomy doctrine to `bundle-docs/sections/`.
4. Update repo front doors and checks so the live docs spine is part of the
   repo contract.
5. Run validation and record the batch outcome in the log flow.

## Acceptance Criteria

- `docs/README.md` and the core section front doors exist.
- The repo has active working rules for the delivery layer.
- `bundle-docs/sections/07-delivery-framework-and-autonomy.md` exists.
- `docs/roadmaps/g01/001-enact-northstar-on-northstar.md` exists and points to
  clear next batches.
- `effigy qa`
- `effigy qa:docs`

## Evidence Required

- active docs artifacts in this repo
- one batch-level log under `docs/logs/2026-04/`
- validation commands recorded in the log

## Stop Conditions

- the live repo docs spine would diverge from the actual repo contract
- the doctrine cannot be expressed as concrete artifacts yet
- validation fails in a way that requires a planning rewrite

## Completion Notes

This card is complete. The next ready work is promotion of the live repo
delivery layer into the reusable template bundle and then the installable
skills.

## Next Task

Start the next ready batch that promotes the delivery-layer artifacts into the
template bundle without bloating the copy-ready product surface.
