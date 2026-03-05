# 02 Naming and Keys Sweep

## Goal

Normalize file naming and key formats so sorting and cross-reference behavior are deterministic.

## Naming Rules

- Vision docs: `docs/vision/NNN-<kebab-slug>.md`
- Contract docs (if sequential): `docs/contracts/NNN-<kebab-slug>.md`
- Roadmap docs: `docs/roadmaps/gNN/NNN-<kebab-slug>.md`
- Roadmap references: `gNN.NNN`
- Log folders: `docs/logs/YYYY-MM/`
- Log files: `DD-HHMMSS-<slug>.md`

## Drift Patterns

- `gen1`/`gen2` folders instead of `g01`/`g02`
- Non-zero-padded keys (`g2.001`, `g1`)
- Log filenames missing day-time prefix
- Root-level logs outside month segments

## Fix Rules

- Convert generation keys to zero-padded `gNN`.
- Normalize roadmap IDs and references to `gNN.NNN`.
- Move/rename logs into `YYYY-MM/DD-HHMMSS-...` format.
- Preserve historical chronology where needed, but remove stale active guidance.

## Fast Checks

```bash
rg -n "\bg[0-9]\.\d{3}\b|\bgen[0-9]+\b|logs/gen[0-9]+" docs
find docs/logs -maxdepth 2 -type f -name '*.md' | sort
```

## Completion Criteria

- Zero `gen*` roadmap key drift in canonical docs.
- Zero non-conforming roadmap/log filename patterns.
