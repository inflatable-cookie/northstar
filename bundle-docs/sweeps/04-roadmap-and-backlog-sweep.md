# 04 Roadmap and Backlog Sweep

## Goal

Ensure roadmap execution model is aligned: one clear active queue, proper
generation handling, backlog discipline, and contract-backed execution
readiness.

## Rules

- Active roadmap sequence lives under `docs/roadmaps/gNN/`.
- Generation rollover is manual-only and reasoned in `docs/roadmaps/generation-index.md`.
- Deferred work belongs only in `docs/roadmaps/backlog/`.
- Backlog items require promotion criteria.
- Active roadmap milestones should reference governing contracts directly.
- Roadmap batches must stop on planning gaps rather than imply missing repo or
  interface behavior.

## Drift Patterns

- Multiple competing active queues
- Backlog items in random folders
- Missing generation rollover rationale
- Global phase-number assumptions that bypass `gNN.NNN`
- Milestones marked ready even though contract refs or planning state are missing
- Roadmap text that assumes behavior from unplanned repos or undeclared seams

## Fix Rules

- Consolidate active queue and mark stale branches as backlog/deferred.
- Move stray backlog docs into canonical backlog folder.
- Add or update generation index entries for rollover reasons.
- Normalize all roadmap references to `gNN.NNN`.
- Backfill contract refs and planning state where execution readiness exists.
- If the needed contract or authority map does not exist, mark the milestone
  blocked and repair planning instead of guessing.

## Fast Checks

```bash
find docs/roadmaps -maxdepth 3 -type f | sort
rg -n "backlog|g[0-9]{2}\.[0-9]{3}|generation|Contract refs|Planning state|Planning Gaps" docs/roadmaps
```

## Completion Criteria

- One clear active queue remains.
- Backlog is centralized and reference-safe.
- Active roadmap work is visibly contract-backed or explicitly blocked on
  planning.
