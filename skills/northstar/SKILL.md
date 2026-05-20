---
name: northstar
description: Use for Northstar docs-spine work in this repo or a consumer project—planning, specs, contracts, roadmaps, research promotion, recovery after drift, and ongoing normalization of docs posture. Invoke automatically for plan, roadmap, contract, spec, research, recover, refocus, sweep, or normalize/migrate/setup language. Handoff or continuation brief only when the user explicitly asks for a handoff, fresh thread, or spin-off—not for bare continue or context limits alone.
---

# Northstar

Single entry for the Northstar planning and docs system. **Do not** load every
mode up front.

## First step (required)

Open [`references/router.md`](./references/router.md), classify intent, then
open **one** [`references/modes/`](./references/modes/) file and follow it.

| Mode | When |
| --- | --- |
| Handoff | User explicitly wants a continuation brief / fresh thread |
| Normalize docs | Bootstrap, migrate, or keep docs spine healthy over time |
| Research | Evidence → architecture/contracts |
| Recovery | Drifted or changed planning state |
| Planning | Default: plan, promote, compile roadmaps (sub-modes in router) |

Doctrine map: [`bundle-docs/protocol-kernel.md`](../../bundle-docs/protocol-kernel.md).

## Outcomes by mode

- **Planning:** coherent architecture/contracts/roadmaps; no invented system
  behavior; ready cards only when rubric satisfied.
- **Research:** promoted decisions in architecture/contracts, not stranded memos.
- **Recovery:** trustworthy planning surfaces and canonical refs restored.
- **Normalize:** baseline or strict spine installed/maintained; Effigy-first QA.
- **Handoff:** seven-section brief for another thread; not a substitute for
  log/roadmap closeout.

## Operator summary (all modes)

Lead with what changed, lane state, next move. Validation only if it failed or
matters. Glue-light internal prose unless the task is public-facing.

## Refactoring posture

When work touches code or automation: no pre-1.0 compat shims; ask the operator
on breaking changes; from v1.0 preserve expected stable behavior. See
[`bundle-docs/sections/07-delivery-framework-and-autonomy.md`](../../bundle-docs/sections/07-delivery-framework-and-autonomy.md)
and repo `docs/contracts/001-working-rules.md` when present.

## Assets

- Setup/templates: [`assets/templates/`](./assets/templates/)
- Handoff template: [`assets/templates/northstar-handoff.md.template`](./assets/templates/northstar-handoff.md.template)
- Handoff contract: [`references/handoff-contract.md`](./references/handoff-contract.md)

## Do not

- Skip the router.
- Use handoff mode for compaction-only or ordinary `continue`.
- Start roadmap execution to discover missing contracts.
- Mirror Effigy tasks into `package.json` scripts.
