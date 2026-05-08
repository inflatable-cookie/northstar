# Batch Card Relocation Guide

Status: active
Updated: 2026-05-08

## Purpose

Migrate batch cards from `docs/specs/batch-cards/` into generation-scoped folders at `docs/roadmaps/gNN/batch-cards/`.

This enables:
- per-generation batch card numbering (no conflicts across parallel generations)
- parallel generation threads with independent card sequences
- no need to archive batch cards on generation rollover — they stay with their generation

## What moves

**Move:**
- Active batch cards: `docs/specs/batch-cards/NNN-<slug>.md`
- Archived batch cards: `docs/specs/archive/batch-cards/NNN-<slug>.md`

**Stays:**
- Master specs remain in `docs/specs/`
- Spec archive remains for master specs only

## Migration steps

### 1. Inventory existing batch cards

```bash
find docs/specs/batch-cards -name "*.md" | sort
find docs/specs/archive/batch-cards -name "*.md" 2>/dev/null | sort
```

### 2. Determine card ownership

Read each batch card and identify its generation by checking:
- `gNN` references in the card text
- Associated milestone refs (`g03.105`, `g04.002`, etc.)
- Log references or closeout context

If a card spans generations, assign it to the generation where it was created or where its primary milestone lives.

### 3. Create generation-scoped folders

For each generation that owns batch cards:

```bash
mkdir -p docs/roadmaps/gNN/batch-cards
```

Copy `template-bundle/roadmaps/g01/batch-cards/README.md` into the folder if it does not exist.

### 4. Move active batch cards

Move each card from `docs/specs/batch-cards/NNN-<slug>.md` to `docs/roadmaps/gNN/batch-cards/NNN-<slug>.md`.

Keep the same filename — numbering is now per-generation.

### 5. Move archived batch cards

Move each archived card from `docs/specs/archive/batch-cards/NNN-<slug>.md` to `docs/roadmaps/gNN/batch-cards/NNN-<slug>.md`.

If the card is closed/archived, update its status header to `archived` after moving.

### 6. Update references

Search and replace across the repo:

```bash
rg -n "docs/specs/batch-cards/" docs/
```

Update:
- `docs/specs/README.md` — remove batch-cards from artifact types
- `docs/specs/archive/README.md` — remove batch-cards from archive scope
- `docs/roadmaps/README.md` — add batch cards location
- `docs/roadmaps/generation-index.md` — remove batch card purge instructions
- Any milestone files or logs referencing old batch card paths

### 7. Clean up

```bash
rm -rf docs/specs/batch-cards/
rm -rf docs/specs/archive/batch-cards/
```

If `docs/specs/archive/` is now empty, remove it.

### 8. Update generation READMEs

For each generation with batch cards, update `docs/roadmaps/gNN/README.md` to mention the `batch-cards/` folder.

### 9. Validate

```bash
effigy qa:docs
```

Confirm no broken references to `docs/specs/batch-cards/`.

## Post-migration state

- Master specs live in `docs/specs/`
- Batch cards live in `docs/roadmaps/gNN/batch-cards/`
- Each generation has independent card numbering
- Parallel generations can run without card numbering conflicts
- Generation rollover only requires purging stale specs from `docs/specs/`

## Next task

Run this guide on one active project and log the migration.