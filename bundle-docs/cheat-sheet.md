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
│   │   └── batch-cards/  (strict posture)
│   ├── g02/
│   │   └── batch-cards/  (strict posture)
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
5. Roadmaps span multiple batches/cards; batch cards own step detail
6. Stop on planning gaps -- do not infer missing behavior
7. One active generation in sequential mode; parallel mode allows multiple
8. Backlog lives only at `roadmaps/backlog/`
9. Clean migrations only: move, update refs, remove legacy in one batch

## Papercuts

- Every repository may keep a root `PAPERCUTS.md` queue.
- Agents append solvable execution friction when it happens; create the file if
  missing and continue without operator permission.
- Triage later; papercuts are observations, not automatic roadmap work.
- Full rule: [`papercuts.md`](./papercuts.md)

## Protocol kernel

Authoritative **enumerations** (batch-card fields, ready-state checks, closeout
shape) live in [`sections/07-delivery-framework-and-autonomy.md`](./sections/07-delivery-framework-and-autonomy.md). One-page map of surfaces:
[`protocol-kernel.md`](./protocol-kernel.md).

## Effigy Commands

```bash
effigy tasks          # list available tasks
effigy doctor         # orientation: built-ins + cheap tasks.health (not full qa)
effigy qa             # full validation board
effigy check:bundle   # validate bundle integrity
effigy qa:docs        # validate docs structure
effigy check:posture-advisory  # optional non-blocking docs posture warnings
```

Keep `tasks.health` seconds-scale. Never set `health = qa`.

## Agent Skill

| Skill | When to Use |
|-------|-------------|
| `northstar` | All Northstar work: plan, normalize/migrate docs, recover, research; handoff only when explicitly requested (see skill router) |

## Next Steps

- New user: [Visual Map](visual-map.md) → [Protocol kernel](protocol-kernel.md) → [Glossary](glossary.md) → [Template Bundle](../template-bundle/)
- Existing user: [Operator Quick Start](operators/operator-quick-start.md)
- Migrating: [Sweep Pack](sweeps/README.md)
