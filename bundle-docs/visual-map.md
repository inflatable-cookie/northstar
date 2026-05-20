# Northstar Visual Map

Text-based overview of how Northstar pieces fit together.

## Protocol kernel

Normative **detail** for batch cards, ready-state, closeout, and autonomy lives
in [`sections/07-delivery-framework-and-autonomy.md`](./sections/07-delivery-framework-and-autonomy.md).
Before agents or tools re-embed those lists, read the one-page map:
[`protocol-kernel.md`](./protocol-kernel.md).

## Doc Hierarchy

```
vision/
  └─ sets long-term direction and constraints

architecture/
  └─ defines system shape, inventory, boundaries

contracts/
  └─ locks behavior rules and interfaces

    ↑ promotion happens here ↑

specs/          (strict posture only)
  └─ provisional planning, then promoted out

roadmaps/
  ├─ g01/       generation of milestones
  │   └─ batch-cards/  execution cards (strict posture)
  ├─ g02/
  │   └─ batch-cards/  execution cards (strict posture)
  ├─ backlog/   deferred work
  └─ generation-index.md

logs/
  └─ YYYY-MM/   dated evidence per batch
```

## Core Flow

```
vision
  ↓
architecture
  ↓
contracts
  ↓        (optional: research → specs → promotion)
roadmaps
  ↓
logs (evidence)
```

## Decision: Baseline or Strict?

```
Starting a new project?
  │
  ├─ Simple? One repo? Low coordination risk?
  │     └─ Baseline posture
  │        (vision, architecture, contracts, roadmaps, logs)
  │
  └─ Complex? Multiple repos? High-risk boundaries?
  │     └─ Strict posture
  │        (baseline + product-guardrails, contract-index,
  │         working-rules, specs, lane budgets, stop/pause signals)
  │
  └─ Already using baseline and need tighter guardrails?
        └─ Lane-first adoption
           (adopt strict for one active lane, expand gradually)
```

## Workflow: Healthy Active Repo

```
1. Open docs/README.md
2. Check generation-index.md for active generation
3. Open active milestone in gNN/
4. Read latest log in logs/YYYY-MM/
5. Execute next batch
6. Closeout: update card → milestone → front doors → log
```

## Workflow: Drifted or New Repo

```
1. Run sweep pack (8 sweeps)
2. Invoke the `northstar` skill; open [`skills/northstar/references/router.md`](../skills/northstar/references/router.md) and pick one mode.
3. Repair/complete planning or normalize docs posture as needed.
4. Compile roadmap.
5. Execute batch → log → handoff (handoff mode only when explicitly requested).
```

## Skill Surface

One installable skill: **`northstar`**. Internal modes (not separate installs):

| Mode | Use when |
|------|----------|
| Normalize docs | Bootstrap, migrate, or keep docs spine healthy |
| Planning sub-modes | Plan, promote specs, compile roadmaps |
| Recovery sub-modes | Replan, refocus, sweep |
| Research | Promote evidence into architecture/contracts |
| Handoff | User explicitly asks for a continuation brief / fresh thread |

## Quick Links

- [Protocol kernel](protocol-kernel.md) -- where each protocol topic is authoritative
- [Glossary](glossary.md) -- terminology reference
- [Cheat Sheet](cheat-sheet.md) -- naming and formats
- [Template Bundle](../template-bundle/README.md) -- copy-ready files
- [Operator Quick Start](operators/operator-quick-start.md) -- day-to-day workflow
