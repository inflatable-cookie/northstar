# 04 Roadmap and Backlog Sweep

## Goal

Ensure roadmap execution model is aligned: one clear active queue, proper generation handling, and backlog discipline.

## Rules

- Active roadmap sequence lives under `docs/roadmaps/gNN/`.
- Generation rollover is manual-only and reasoned in `docs/roadmaps/generation-index.md`.
- Deferred work belongs only in `docs/roadmaps/backlog/`.
- Backlog items require promotion criteria.

## Drift Patterns

- Multiple competing active queues
- Backlog items in random folders
- Missing generation rollover rationale
- Global phase-number assumptions that bypass `gNN.NNN`

## Fix Rules

- Consolidate active queue and mark stale branches as backlog/deferred.
- Move stray backlog docs into canonical backlog folder.
- Add or update generation index entries for rollover reasons.
- Normalize all roadmap references to `gNN.NNN`.

## Fast Checks

```bash
find docs/roadmaps -maxdepth 3 -type f | sort
rg -n "backlog|g[0-9]{2}\.[0-9]{3}|generation" docs/roadmaps
```

## Completion Criteria

- One clear active queue remains.
- Backlog is centralized and reference-safe.
