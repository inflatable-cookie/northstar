---
name: northstar-recover
description: Use when a Northstar project needs recovery work because the live planning state changed, drifted, or became untrustworthy. Handles bounded replanning, broad refocus, and sweep-led audit/repair as internal modes instead of separate top-level skills.
---

# Northstar Recover

Use this skill when the user asks to:

- recover a project whose planning or roadmap state is no longer trustworthy
- replan after requirements, contracts, or repo boundaries changed
- reorganize or refocus a drifting project under Northstar
- audit and repair docs drift before execution continues

## Outcome

Leave the planning surfaces coherent again before execution resumes.

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
5. Surface what became stale, blocked, or superseded instead of patching around
   it informally.
6. Leave one explicit next task pointing to the next valid planning artifact or
   the first newly valid execution batch.

## Required Outputs

Depending on the active mode, leave some or all of these surfaces materially
advanced:

- updated planning artifacts for the changed or drifted boundary
- blocked, superseded, or recompiled roadmap milestones
- generation index updates when rollover is required
- visible log evidence showing what changed, what became stale, and why
- sweep findings and repair evidence when running audit mode

## Guardrails

- Do not patch implementation around a broken or missing contract.
- Do not keep executing from a stale roadmap because the next fix looks small.
- Do not preserve drifted roadmap prose just because it already exists.
- Do not collapse recovery work into cosmetic cleanup; it must change planning
  authority or execution readiness.

## Next Step

Once the relevant recovery mode is complete, hand work to `northstar-plan` for
fresh milestone compilation or resume execution from the first contract-valid
batch.
