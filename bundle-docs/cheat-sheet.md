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
| Triage notes | `YYYYMMDD-HHMMSS-<slug>.md` | `20260819-084500-capture-open-question.md` |

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
│   │   └── batch-cards/  (execution detail)
│   ├── g02/
│   │   └── batch-cards/  (execution detail)
│   ├── backlog/
│   └── generation-index.md
├── logs/
│   └── YYYY-MM/
├── triage/           (temporary capture notes)
├── policy/
├── research/          (optional)
├── schemas/           (optional)
├── templates/         (optional)
├── diagrams/          (optional)
└── specs/             (provisional planning)
```

## Compact Lifecycle Quick Pick

| Situation | Start With |
|-----------|-----------|
| Standard project | Core standard spine (`vision/`, `architecture/`, `contracts/`, `roadmaps/`, `logs/`, `handoffs/`, `triage/`) |
| Provisional design shaping | Add `specs/` (promoted into architecture/contracts before execution) |
| Multi-repo / execution constraints | Add `repo-authority-map.md`, `product-guardrails.md`, contract index |
| Existing mature repo | Incremental adoption in bounded tranches |

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
10. Triage notes are temporary: promote, merge, or remove them during refresh or cleanup

## Papercuts

- Every repository keeps a root `PAPERCUTS.md` queue (seed on adopt/upgrade,
  before exact-SHA / clean-tree release prep).
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
| `northstar` | All Northstar work: refresh, plan, normalize/migrate docs, recover, research; handoff only when explicitly requested (see skill router) |

## Next Steps

- New user: [Visual Map](visual-map.md) → [Protocol kernel](protocol-kernel.md) → [Glossary](glossary.md) → [Template Bundle](../template-bundle/)
- Existing user: [Operator Quick Start](operators/operator-quick-start.md)
- Migrating: [Sweep Pack](sweeps/README.md)
