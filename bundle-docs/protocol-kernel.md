# Northstar Protocol Kernel

Status: active  
Updated: 2026-09-01

One-page map of **what counts as the protocol**, **where normative detail
lives**, and **how surfaces should relate**. Use this before pasting long
excerpts of doctrine into skills, contracts, or operator prompts.

## What the protocol is

Northstar is a **docs spine + execution grammar**: direction in `vision/`,
shape in `architecture/`, durable rules in `contracts/`, time-ordered work in
`roadmaps/`, evidence in `logs/`, and a temporary capture buffer in `triage/`.
Optional `research/` and provisional `specs/` feed promotion into architecture
and contracts before execution bets on them. Triage notes are not execution
authority; they are promoted, merged, or removed during maintenance.

Full picture: [visual-map.md](./visual-map.md) and [glossary.md](./glossary.md).

## Posture (pick deliberately)

| Posture | Spine | Typical use |
| --- | --- | --- |
| **Baseline** | `vision/`, `architecture/`, `contracts/`, `roadmaps/`, `logs/` | Single repo, clear scope, normal routing |
| **Strict** | Baseline + `product-guardrails`, indexed contracts, `specs/`, `roadmaps/gNN/batch-cards/` | High-risk boundaries, longer hands-off runs |

Lane-first strict adoption is the normal migration path, not a permanent
mixed-mode excuse. See [glossary.md](./glossary.md) (*Lane-first adoption*).

## Canonical homes (single owners for enumerations)

Do **not** maintain parallel copies of the same bullet lists across skills,
templates, and doctrine unless a surface is intentionally binding (repo
contracts).

| Topic | Doctrine (authoritative full detail) | Binding in a strict repo |
| --- | --- | --- |
| Planning completeness and execution authority | [sections/06-planning-and-contract-gates.md](./sections/06-planning-and-contract-gates.md) | Same expectations; repo records gaps in its own planning files |
| Batch cards, ready-state, closeout shape, autonomy levels, master specs | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Batch card rule**, **Ready-state rubric**, **Operator-facing summary rule**, **Autonomy support levels** | `docs/contracts/001-working-rules.md` (from [`template-bundle/contracts/001-working-rules-template.md`](../template-bundle/contracts/001-working-rules-template.md)); keep compact, point here for full enumerations |
| Review oracles, worker adversarial pass, review finding codes | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Review oracle rule**, **Worker pre-PR adversarial pass**, **Review finding classification** | Ready card + compact repo working-rules binding |
| Parallel lane scheduling and lane-local provider routing | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Parallel lane scheduling** | `docs/contracts/001-working-rules.md` plus one worker handoff per dispatched lane |
| Economical worker routing (diversified adequate pools, cheapest tier, recent-use rotation) | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Economical worker routing** | `docs/contracts/001-working-rules.md` plus frontier-worker justification on the worker handoff |
| Economical orchestrator coordination (mechanical coordination, dispatch manifest, review child in worker workspace, coordination gate) | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Economical orchestrator coordination** | `docs/contracts/001-working-rules.md` plus the installed orchestrator and PR-review modes |
| Paseo worker parentage and cross-workspace child dispatch | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Parallel lane scheduling** | `docs/contracts/001-working-rules.md` plus the installed orchestrator mode |
| Conversational planning delegation | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Conversational planning delegation** | `docs/contracts/001-working-rules.md` plus the installed chatterbox mode |
| Fresh orchestrator continuation | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Fresh orchestrator continuation** | `docs/contracts/001-working-rules.md` plus the generic seven-section handoff with `orchestrator-continuation` activation |
| Chatterbox planning and promotion | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Chatterbox planning and promotion** | `docs/contracts/001-working-rules.md` plus the installed chatterbox mode |
| Handoff content and compression | [`skills/northstar/references/handoff-contract.md`](../skills/northstar/references/handoff-contract.md) | `docs/handoffs/`; handoff points to cards and contracts instead of copying them |
| Direct PR review and provider record | [sections/07-delivery-framework-and-autonomy.md](./sections/07-delivery-framework-and-autonomy.md) — see **Direct PR review boundary** | `docs/contracts/001-working-rules.md` plus the installed Northstar PR-review mode |
| Spec lifecycle and archive | [sections/08-specs-and-promotion.md](./sections/08-specs-and-promotion.md) + [template-bundle/specs/README.md](../template-bundle/specs/README.md) | `docs/specs/` + `docs/specs/archive/` in the installed repo |
| Automation defaults | [sections/10-automation-runtime-policy.md](./sections/10-automation-runtime-policy.md) | `AGENTS.md` / Effigy config in each repo |
| Agent execution feedback | [papercuts.md](./papercuts.md) | root `PAPERCUTS.md` + agent contract |
| Conversational capture and pruning | [sections/09-standard-docs-spine.md](./sections/09-standard-docs-spine.md) | `docs/triage/README.md` + refresh/cleanup modes |

**Northstar maintainers:** the live repo may tighten wording in
`docs/contracts/001-working-rules.md`, but expanded checklists should stay in
`bundle-docs/sections/07-…` unless the contract intentionally narrows behavior.

## Skills and operators

- **Operators:** [operators/operator-quick-start.md](./operators/operator-quick-start.md)
- **Agent skill (one install):** [`skills/northstar/`](../../skills/northstar/) +
  [skills/README.md](./skills/README.md) — always run
  [`references/router.md`](../../skills/northstar/references/router.md) first.

Skills should **name modes and file paths**, not restate full batch-card field
lists. When an agent needs doctrine depth, prefer this kernel → linked section
→ glossary, in that order.

## Naming and validation

- [cheat-sheet.md](./cheat-sheet.md) — file patterns, `gNN.NNN`, log names
- Repo validation: `effigy qa` / `effigy check:bundle` as wired in each repo
- Optional drift triage: `effigy check:posture-advisory` (non-blocking; see
  [`../scripts/README.md`](../scripts/README.md))
