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

specs/          (consequence-triggered provisional planning)
  └─ provisional planning, then promoted out

roadmaps/
  ├─ g01/       generation of milestones
  │   └─ batch-cards/  execution cards (when batch-card detail is needed)
  ├─ g02/
  │   └─ batch-cards/  execution cards (when batch-card detail is needed)
  ├─ backlog/   deferred work
  └─ generation-index.md

logs/
  └─ YYYY-MM/   dated evidence per batch

handoffs/
  └─ YYYYMMDD-HHMMSS-<slug>.md   friendly fresh-thread notes

triage/
  └─ YYYYMMDD-HHMMSS-<slug>.md   temporary conversational capture notes

PAPERCUTS.md
  └─ agent-observed friction, triaged later into the docs spine
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

Unresolved conversation threads → triage (capture) → canonical docs or removal
```

## Operating Model: Compact Lifecycle

```
Northstar Project
  │
  ├─ Standard Core Spine
  │     └─ vision, architecture, contracts, roadmaps, logs, handoffs, triage
  │
  ├─ Consequence-Triggered Modules
  │     ├─ specs (provisional planning before promotion)
  │     ├─ product-guardrails & repo-authority-map (execution bounds & multi-repo)
  │     └─ research (comparative/source-backed learning)
  │
  └─ Incremental Adoption
        └─ Bounded migration into the compact lifecycle in explicit tranches
```

## Workflow: Healthy Active Repo

```
1. Open docs/README.md
2. Check generation-index.md for active generation
3. Open active milestone in gNN/
4. Read latest log in logs/YYYY-MM/
5. Execute next batch
6. Append any solvable execution friction to root PAPERCUTS.md
7. Closeout: update card → milestone → front doors → log
```

## Workflow: Drifted or New Repo

```
1. Run sweep pack (8 sweeps)
2. Invoke the `northstar` skill; open [`skills/northstar/references/router.md`](../skills/northstar/references/router.md) and pick one mode.
3. Repair/complete planning or normalize docs lifecycle as needed.
4. Compile roadmap.
5. Execute batch → log → handoff (handoff mode only when explicitly requested).
```

## Skill Surface

One distributable package with **`northstar`** as its front door. Thin named
adapters make explicit commands activatable; canonical modes remain internal:

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
