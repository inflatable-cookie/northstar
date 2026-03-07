# Northstar

Northstar is a reusable documentation system for software projects.
It standardizes how teams define direction, translate it into execution, and keep evidence of progress.

## What Northstar Is For

Use Northstar to keep project docs consistent across repositories without adding heavy process overhead.

Core flow:
1. Define long-term intent in `vision`.
2. Translate intent into system boundaries in `architecture`.
3. When external comparison matters, synthesize it in `research` before locking new bets.
4. Execute short-term work in generation-keyed `roadmaps`.
5. Record outcomes in month-segmented `logs`.

## What You Get In This Repo

- [`template-bundle/`](./template-bundle/) - the artifact to copy into a project's `docs/` directory, including the optional research starter pack
- [`bundle-docs/`](./bundle-docs/) - doctrine, usage rules, migration guidance, and maintenance policy
- [`scripts/`](./scripts/) - bootstrap and upgrade helpers (when needed)

Section examples live in the relevant folders inside the template bundle.

## Effigy-First Loop

Use Effigy as the default repo command surface:

```bash
effigy tasks --repo .
effigy doctor --repo .
effigy health --repo .
effigy validate --repo .
```

The current repo baseline is bundle integrity and documentation structure validation:

```bash
effigy check:bundle --repo .
```

## Quick Start (New Project)

1. Copy the bundle into your target project docs folder.

```bash
rsync -a template-bundle/ /path/to/your-project/docs/
```

2. Start with vision first, then architecture. Add `research/` when external comparison or source-backed exploration is needed before committing new bets.
3. Create roadmap milestones under `docs/roadmaps/gNN/` using `NNN-<slug>.md`.
4. Log each completed batch in `docs/logs/YYYY-MM/` using `DD-HHMMSS-<slug>.md`.
5. Delete unused add-on folders after copying the bundle; keep only the ones the project actually needs (`docs/research/`, `docs/schemas/`, `docs/templates/`, `docs/diagrams/`, `docs/specs/`).

## Migrate An Existing Project

1. Run the sweep pack: [`bundle-docs/sweeps/README.md`](./bundle-docs/sweeps/README.md)
2. Use the fresh-thread starter prompt: [`bundle-docs/sweeps/fresh-agent-sweep-prompt.md`](./bundle-docs/sweeps/fresh-agent-sweep-prompt.md)
3. Apply clean migrations only:
- no compatibility shims
- update references in the same batch
- remove deprecated legacy folders after migration

## Key Conventions

- Roadmap folder key format: `gNN` (example: `g01`)
- Roadmap reference format: `gNN.NNN` (example: `g01.105`)
- Roadmap file format: `docs/roadmaps/gNN/NNN-<slug>.md`
- Logs folder format: `docs/logs/YYYY-MM/`
- Logs file format: `docs/logs/YYYY-MM/DD-HHMMSS-<slug>.md`
- Backlog lives only at `docs/roadmaps/backlog/`
- Decision records live in logs by default, not a separate `decisions/` root
- Research promotes through `specimen-dossiers` -> `value-tracks` -> `translation-memos` before architecture or roadmap commitments
- Mature research areas should expose navigation and promotion artifacts such as a master index, research-to-architecture crossref, and implementation gap log
- Optional folders (`research`, `schemas`, `templates`, `diagrams`, `specs`) are add-on only and should be kept only when actively used

## Read Next

- Template bundle guide: [`template-bundle/README.md`](./template-bundle/README.md)
- Bundle docs guide: [`bundle-docs/README.md`](./bundle-docs/README.md)
- Vision spec: [`bundle-docs/sections/01-vision.md`](./bundle-docs/sections/01-vision.md)
- Architecture spec: [`bundle-docs/sections/02-architecture.md`](./bundle-docs/sections/02-architecture.md)
- Roadmaps spec: [`bundle-docs/sections/03-roadmaps.md`](./bundle-docs/sections/03-roadmaps.md)
- Logs spec: [`bundle-docs/sections/04-logs.md`](./bundle-docs/sections/04-logs.md)
- Research spec: [`bundle-docs/sections/05-research.md`](./bundle-docs/sections/05-research.md)
- Baseline mapping notes: [`bundle-docs/baseline-mapping.md`](./bundle-docs/baseline-mapping.md)
- Meta migration guidance: [`bundle-docs/meta-folder-migration.md`](./bundle-docs/meta-folder-migration.md)
- Sweep pack: [`bundle-docs/sweeps/README.md`](./bundle-docs/sweeps/README.md)

## Operating Posture

Northstar is intentionally lean:
- log by update cycle or batch, not every single task
- keep research problem-led and source-backed; do not freeze raw findings directly into architecture or roadmaps
- prefer manual evidence before adding checker scripts
- keep one active roadmap queue and move deferred work into backlog
- treat `meta/` as deprecated and extract useful content into canonical docs
- enforce clean migrations: move, update refs, remove legacy artifacts in one batch

## Next task

Pilot the research add-on in one existing project and tighten the optional-folder guidance based on how much starter scaffolding teams actually keep after adoption.
