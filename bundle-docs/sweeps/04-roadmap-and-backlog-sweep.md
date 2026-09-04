# 04 Roadmap and Backlog Sweep

## Goal

Ensure roadmap execution model is aligned: clear active queue(s), proper
generation handling, backlog discipline, and contract-backed execution
readiness.

## Rules

- Active roadmap sequence lives under `docs/roadmaps/gNN/`.
- Generation rollover is manual-only and reasoned in `docs/roadmaps/generation-index.md`.
- In sequential mode, only one generation is active at a time.
- In parallel mode, each active generation operates as its own queue.
- Deferred work belongs only in `docs/roadmaps/backlog/`.
- Backlog items require promotion criteria.
- Active roadmap milestones should reference governing contracts directly.
- Roadmap batches must stop on planning gaps rather than imply missing repo or
  interface behavior.

## Drift Patterns

- Roadmaps sized to one agent turn or one batch card instead of a multi-batch
  milestone runway
- New roadmap files created per thread instead of updating the active milestone
  and batch cards
- `## Execution Plan` with only one micro-batch or prose bullets instead of
  checkbox task lists
- Multiple competing active queues within one generation
- Backlog items in random folders
- Missing generation rollover rationale
- Global phase-number assumptions that bypass `gNN.NNN`
- Milestones marked ready even though contract refs or planning state are missing
- Roadmap text that assumes behavior from unplanned repos or undeclared seams
- Parallel mode enabled without clear lane separation between generations

## Fix Rules

- Expand thin roadmaps into multi-batch milestones; move step detail into batch
  cards where batch cards are used
- Merge per-thread roadmap scratchpads into the active milestone; retire
  duplicate milestone files
- Convert execution-plan prose bullets to checkbox tasks where progress should
  be scannable
- Consolidate competing queues within a generation and mark stale branches as
  backlog/deferred.
- In parallel mode, ensure each generation's queue is clearly separated and
  front doors name all active generations.
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

- In sequential mode, one clear active queue remains.
- In parallel mode, each active generation has a clear queue and front doors
  accurately name all active generations.
- Backlog is centralized and reference-safe.
- Active roadmap work is visibly contract-backed or explicitly blocked on
  planning.
