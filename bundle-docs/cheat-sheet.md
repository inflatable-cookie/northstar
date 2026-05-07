# Northstar Cheat Sheet

One-page reference for naming, formats, and conventions.

## File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Vision | `NNN-<slug>.md` | `001-product-vision.md` |
| Contracts | `NNN-<slug>.md` | `001-api-contract.md` |
| Roadmap | `NNN-<slug>.md` | `001-auth-migration.md` |
| Logs | `DD-HHMMSS-<slug>.md` | `15-143000-auth-batch-1.md` |
| Architecture | `<slug>.md` | `system-architecture.md` |
| Specs | `NNN-<slug>.md` | `012-rate-limiting.md` |
| Batch cards | `NNN-<slug>.md` | `034-apply-contract.md` |

## Reference Keys

| Key | Format | Example |
|-----|--------|---------|
| Generation | `gNN` | `g01`, `g02` |
| Milestone | `gNN.NNN` | `g01.003` |
| Log month | `YYYY-MM` | `2026-04` |
| Log timestamp | `DD-HHMMSS` | `15-143000` |

## Folder Structure

```
docs/
├── vision/
├── architecture/
├── contracts/
├── roadmaps/
│   ├── g01/
│   ├── g02/
│   ├── backlog/
│   └── generation-index.md
├── logs/
│   └── YYYY-MM/
├── policy/
├── research/          (optional)
├── schemas/           (optional)
├── templates/         (optional)
├── diagrams/          (optional)
└── specs/             (strict posture only)
```

## Posture Quick Pick

| Situation | Start With |
|-----------|-----------|
| Single repo, small team, clear scope | Baseline |
| Multi-repo, high-risk boundaries, long autonomous runs | Strict |
| Baseline repo needs tighter guardrails | Lane-first strict adoption |

## Core Rules

1. Create `vision/001` before first roadmap milestone
2. Define architecture before contracts
3. Create contracts before roadmaps
4. Log per batch, not per task
5. Stop on planning gaps -- do not infer missing behavior
6. One active generation, one active milestone
7. Backlog lives only at `roadmaps/backlog/`
8. Clean migrations only: move, update refs, remove legacy in one batch

## Effigy Commands

```bash
effigy tasks          # list available tasks
effigy doctor         # check environment
effigy qa             # run validation
effigy check:bundle   # validate bundle integrity
effigy qa:docs        # validate docs structure
```

## Agent Skills

| Skill | When to Use |
|-------|-------------|
| `northstar-setup` | Bootstrap or migrate a repo |
| `northstar-plan` | Plan from scratch, compile roadmaps |
| `northstar-recover` | Replan, refocus, run sweeps |
| `northstar-research` | Research intake and promotion |
| `northstar-handoff` | Create continuation briefs |

## Next Steps

- New user: [Visual Map](visual-map.md) → [Glossary](glossary.md) → [Template Bundle](../template-bundle/)
- Existing user: [Operator Quick Start](operators/operator-quick-start.md)
- Migrating: [Sweep Pack](sweeps/README.md)
