# Northstar Visual Map

Text-based overview of how Northstar pieces fit together.

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
  ├─ g02/
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
2. Choose entry point:
   - No planning yet          → northstar-plan
   - Plan exists, needs work  → northstar-plan
   - Plan drifted             → northstar-recover
   - Research → decisions     → northstar-research
   - Thread handoff needed    → northstar-handoff
3. Repair/complete planning
4. Compile roadmap
5. Execute batch → log → handoff
```

## Skill Surface

Five public skills. Each routes to internal modes:

| Skill | Use when |
|-------|----------|
| `northstar-setup` | Bootstrapping or migrating a repo |
| `northstar-plan` | Planning from scratch or compiling roadmaps |
| `northstar-recover` | Drifted plans, replanning, sweeps |
| `northstar-research` | Research intake and promotion |
| `northstar-handoff` | Thread continuation briefs |

## Quick Links

- [Glossary](glossary.md) -- terminology reference
- [Cheat Sheet](cheat-sheet.md) -- naming and formats
- [Template Bundle](../template-bundle/README.md) -- copy-ready files
- [Operator Quick Start](operators/operator-quick-start.md) -- day-to-day workflow
