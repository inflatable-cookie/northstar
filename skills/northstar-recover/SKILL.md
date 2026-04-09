---
name: northstar-recover
description: Use when a Northstar project needs recovery work because the live planning state changed, drifted, or became untrustworthy. Handles bounded replanning, broad refocus, and sweep-led audit/repair while preserving the active spec lane and the canonical promoted refs that execution should still trust.
---

# Northstar Recover

Use this skill when the user asks to:

- recover a project whose planning or roadmap state is no longer trustworthy
- replan after requirements, contracts, or repo boundaries changed
- reorganize or refocus a drifting project under Northstar
- audit and repair docs drift before execution continues

## Outcome

Leave the planning surfaces coherent again before execution resumes, with the
active spec lane and canonical promoted refs brought back into alignment.

Use this skill when the work is fundamentally about recovery rather than fresh
planning.
If planning is still missing, route to `northstar-plan`.
If the planning surfaces are coherent and the user only wants the next
milestones, route to `northstar-plan`.

## Quick Start

Inspect:

```sh
effigy tasks
effigy doctor
```

Then read:

- `README.md`
- `AGENTS.md`
- `docs/specs/` when present
- `docs/specs/archive/README.md` when present
- `docs/architecture/`
- `docs/contracts/`
- `docs/roadmaps/`
- `docs/logs/`
- `docs/research/` when present
- `docs/roadmaps/generation-index.md`
- [`references/modes/replan-after-change.md`](./references/modes/replan-after-change.md)
- [`references/modes/refocus-drifted-project.md`](./references/modes/refocus-drifted-project.md)
- [`references/modes/sweep-audit-repair.md`](./references/modes/sweep-audit-repair.md)

## Workflow

1. Diagnose which recovery mode is needed: bounded replan, broad refocus, or
   sweep-led audit/repair.
2. If a previously valid contract or sequencing baseline changed, use
   [`references/modes/replan-after-change.md`](./references/modes/replan-after-change.md).
3. If the planning state is stale, contradictory, or broadly untrustworthy, use
   [`references/modes/refocus-drifted-project.md`](./references/modes/refocus-drifted-project.md).
4. If the repo needs a structured audit-and-repair pass, use
   [`references/modes/sweep-audit-repair.md`](./references/modes/sweep-audit-repair.md).
5. Restore or rewrite the active spec lane when recovery work changes what the
   current realization path should be.
6. Make the canonical promoted refs explicit again so execution and handoff work
   from architecture/contracts instead of stale or provisional planning.
7. Surface what became stale, blocked, or superseded instead of patching around
   it informally.
8. Inspect both the active specs tree and the archive posture when recovery
   work touches planning hygiene or preserved history.
9. Archive, remove, or rewrite stale specs when they no longer help and are
   only acting as shadow authority, while keeping still-useful history
   traceable.
10. Leave one explicit next task pointing to the next valid planning artifact
    or the first newly valid execution batch.

## Required Outputs

Depending on the active mode, leave some or all of these surfaces materially
advanced:

- updated planning artifacts for the changed or drifted boundary
- updated spec lane and/or batch-card chain when the realization path changed
- updated canonical refs in roadmap, spec, or handoff surfaces
- blocked, superseded, or recompiled roadmap milestones
- generation index updates when rollover is required
- visible log evidence showing what changed, what became stale, and why
- sweep findings and repair evidence when running audit mode

## Guardrails

- Do not patch implementation around a broken or missing contract.
- Do not keep executing from a stale roadmap because the next fix looks small.
- Do not preserve drifted roadmap prose just because it already exists.
- Do not let recovery work preserve stale spec references after the canonical
  architecture/contracts have changed.
- Do not keep obsolete specs around if they now only confuse the active
  authority chain.
- Do not treat a swollen stale specs folder as harmless if it is obscuring the
  real active planning lane.
- Do not ignore the archive posture when recovery work needs to separate live
  planning from preserved history.
- Do not collapse recovery work into cosmetic cleanup; it must change planning
  authority or execution readiness.

## Next Step

Once the relevant recovery mode is complete, hand work to `northstar-plan` for
fresh milestone compilation or resume execution from the first contract-valid
batch.
