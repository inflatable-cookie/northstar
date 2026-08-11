# Northstar

Northstar is a reusable documentation system for software projects.
It standardizes how teams define direction, translate it into execution, and keep evidence of progress.

**New here?** Start with the [visual map](bundle-docs/visual-map.md), the [protocol kernel](bundle-docs/protocol-kernel.md), the [glossary](bundle-docs/glossary.md), then the [cheat sheet](bundle-docs/cheat-sheet.md).

## What Northstar Is For

Use Northstar to keep project docs consistent across repositories without adding heavy process overhead.

Core flow:
1. Define long-term intent in `vision`.
2. Translate intent into system boundaries and full system coverage in `architecture`.
3. Lock execution-relevant behavior in explicit `contracts`.
4. When external comparison matters, synthesize it in `research` before locking new bets.
5. Execute short-term work in generation-keyed `roadmaps` only after planning gates are satisfied.
6. Record outcomes in month-segmented `logs`.

## What You Get In This Repo

- [`template-bundle/`](./template-bundle/) is the thing you copy into a
  project's `docs/` directory.
- [`bundle-docs/`](./bundle-docs/) explains how the system is meant to work.
- [`docs/`](./docs/) is the live Northstar planning spine for building and
  extending Northstar itself.
- [`skills/northstar/`](./skills/northstar/) -- single installable agent skill;
  routes internally to plan, research, recovery, docs normalization, and
  explicit handoff modes (see [`references/router.md`](./skills/northstar/references/router.md)).
- [`bundle-docs/skills/README.md`](./bundle-docs/skills/README.md) describes
  skill architecture.
- [`PAPERCUTS.md`](./PAPERCUTS.md) is the live agent-observed friction queue;
  consumer projects seed the same root file from the skill templates.
- [`scripts/`](./scripts/) contains repo maintenance helpers when needed.

If you're trying to understand the human workflow rather than the bundle
structure, start with [`bundle-docs/operators/README.md`](./bundle-docs/operators/README.md).
If you're maintaining the operator stack itself after a pilot, use
[`bundle-docs/maintenance/README.md`](./bundle-docs/maintenance/README.md).

## Effigy-First Loop

Use Effigy as the default repo command surface:

```bash
effigy tasks
effigy doctor
effigy qa
```

`doctor` is orientation (built-ins + cheap `tasks.health`); `qa` is the full
board. Never map `health` to `qa`.

The current repo baseline is bundle integrity and documentation structure validation:

```bash
effigy check:bundle
effigy qa:docs
effigy check:posture-advisory
```

First-time bring-up from another directory:

```bash
effigy bootstrap git@github.com:inflatable-cookie/northstar.git
```

Use `--repo <PATH>` only when you intentionally want to target a different
repository.

## Quick Start (New Project)

### Choose your starting posture

| Situation | Start With | Command |
|-----------|-----------|---------|
| Simple project, small team, clear scope | Minimal starter (5 folders, no examples) | `rsync -a template-bundle/minimal/ /path/to/your-project/docs/` |
| Want examples and templates | Full template bundle | `rsync -a template-bundle/ /path/to/your-project/docs/` |
| Existing project, needs audit | Sweep pack | See [Migrate section](#migrate-an-existing-project) |

### Baseline vs Strict

**Baseline posture** -- use for most projects:
- `vision/`, `architecture/`, `contracts/`, `roadmaps/`, `logs/`
- Enough for normal routing and clear active-lane tracking

**Strict posture** -- add when execution spans high-risk boundaries or needs longer autonomous runs:
- Baseline plus `contracts/contract-index.md`, `contracts/001-working-rules-template.md`, `architecture/product-guardrails.md`, `specs/`
- Enables continuation envelopes, lane budgets, pause signals, batch-card-driven autonomy

**Migration path**: baseline → lane-first stricter adoption → expanding strict coverage → full strict compliance

### Steps for any posture

1. Copy the bundle into your target project docs folder.
2. Install the top-level agent starters from `skills/northstar/assets/templates/`,
   including `AGENTS.md` and `PAPERCUTS.md`, before any exact-SHA /
   clean-tree release-candidate prep (do not add `PAPERCUTS.md` during tag
   closeout after CI is already green on a pinned SHA).
3. Start with vision first, then architecture. Add `research/` when external comparison or source-backed exploration is needed before committing new bets.
4. Create roadmap milestones under `docs/roadmaps/gNN/` using `NNN-<slug>.md`.
5. Log each completed batch in `docs/logs/YYYY-MM/` using `DD-HHMMSS-<slug>.md`.
6. Delete unused add-on folders after copying the bundle; keep only the ones the project actually needs (`docs/research/`, `docs/schemas/`, `docs/templates/`, `docs/diagrams/`, `docs/specs/`).

## Migrate An Existing Project

1. Run the sweep pack: [`bundle-docs/sweeps/README.md`](./bundle-docs/sweeps/README.md)
2. Use the fresh-thread starter prompt: [`bundle-docs/sweeps/fresh-agent-sweep-prompt.md`](./bundle-docs/sweeps/fresh-agent-sweep-prompt.md)
3. Apply clean migrations only:
- **pre-1.0:** no compatibility shims, aliases, or silent fallbacks; if a change
  is breaking, decide with the project owner rather than adding a compat layer
  on your own
- **v1.0+:** preserve expected behavior for stable surfaces; breaking changes
  need explicit owner policy, not casual removal
- update references in the same batch
- remove deprecated legacy folders after migration

## Key Conventions

- **Agents refactoring code or automation:** before v1.0, no compatibility shims,
  aliases, or silent fallbacks—clean migrations and owner decisions on breaks.
  From v1.0 onward, preserve expected stable behavior unless policy directs
  otherwise. See [`bundle-docs/sections/07-delivery-framework-and-autonomy.md`](./bundle-docs/sections/07-delivery-framework-and-autonomy.md) and
  [`template-bundle/contracts/001-working-rules-template.md`](./template-bundle/contracts/001-working-rules-template.md).
- Roadmap folder key format: `gNN` (example: `g01`)
- Roadmap reference format: `gNN.NNN` (example: `g01.105`)
- Roadmap file format: `docs/roadmaps/gNN/NNN-<slug>.md`
- Logs folder format: `docs/logs/YYYY-MM/`
- Logs file format: `docs/logs/YYYY-MM/DD-HHMMSS-<slug>.md`
- Backlog lives only at `docs/roadmaps/backlog/`
- Decision records live in logs by default, not a separate `decisions/` root
- Research promotes through `specimen-dossiers` -> `value-tracks` -> `translation-memos` before architecture or roadmap commitments
- Execution must stop when a required repo, interface, or contract surface is unplanned; record a planning gap instead of inferring missing behavior
- Mature research areas should expose navigation and promotion artifacts such as a master index, research-to-architecture crossref, and implementation gap log
- Optional folders (`research`, `schemas`, `templates`, `diagrams`, `specs`) are add-on only and should be kept only when actively used

## Where To Start

- New to Northstar: [`bundle-docs/README.md`](./bundle-docs/README.md)
- Want a quick visual overview: [`bundle-docs/visual-map.md`](./bundle-docs/visual-map.md)
- Want terminology reference: [`bundle-docs/glossary.md`](./bundle-docs/glossary.md)
- Want naming conventions fast: [`bundle-docs/cheat-sheet.md`](./bundle-docs/cheat-sheet.md)
- Want the copy-ready docs bundle: [`template-bundle/README.md`](./template-bundle/README.md)
- Want a minimal starter (5 folders, no examples): [`template-bundle/minimal/README.md`](./template-bundle/minimal/README.md)
- Want Northstar's own live project docs: [`docs/README.md`](./docs/README.md)
- Want the operator workflow: [`bundle-docs/operators/README.md`](./bundle-docs/operators/README.md)
- Migrating or auditing a repo: [`bundle-docs/sweeps/README.md`](./bundle-docs/sweeps/README.md)

Deeper doctrine lives in [`bundle-docs/sections/`](./bundle-docs/sections/).

## Read Next

- Template bundle guide: [`template-bundle/README.md`](./template-bundle/README.md)
- Bundle docs guide: [`bundle-docs/README.md`](./bundle-docs/README.md)
- Live repo docs: [`docs/README.md`](./docs/README.md)
- Operator docs: [`bundle-docs/operators/README.md`](./bundle-docs/operators/README.md)
- Sweep pack: [`bundle-docs/sweeps/README.md`](./bundle-docs/sweeps/README.md)

## Operating Posture

Northstar is intentionally lean:
- log by update cycle or batch, not every single task
- keep research problem-led and source-backed; do not freeze raw findings directly into architecture or roadmaps
- keep planning strict where execution risk is real: no inferred cross-repo behavior, no silent contract gaps, no roadmap work that outruns architecture or contracts
- prefer manual evidence before adding checker scripts
- keep one active roadmap queue and move deferred work into backlog
- treat `meta/` as deprecated and extract useful content into canonical docs
- enforce clean migrations: move, update refs, remove legacy artifacts in one batch
- keep installable skills portable as one folder; push doctrine back into
  `template-bundle/`, `bundle-docs/`, or Effigy product docs instead of letting
  skills sprawl

## Next task

Validate that the new front doors (visual map, glossary, minimal starter, cheat sheet) actually reduce onboarding time. Measure by timing a fresh-user walkthrough from repo clone to minimal bundle copy.
