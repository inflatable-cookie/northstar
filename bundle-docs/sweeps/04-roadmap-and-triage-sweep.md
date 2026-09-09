# 04 Roadmap and Triage Sweep

## Goal

Ensure roadmap execution model is aligned: clear active queue(s), proper
generation handling, triage discipline, and contract-backed execution
readiness.

## Rules

- Active roadmap sequence lives under `docs/roadmaps/gNN/`.
- Generation rollover is manual-only and reasoned in `docs/roadmaps/generation-index.md`.
- In sequential mode, only one generation is active at a time.
- In parallel mode, each active generation operates as its own queue.
- Unresolved or deferred candidates belong in `docs/triage/` until promotion.
- Triage candidates need an explicit promotion condition before roadmap entry.
- Active roadmap tasks should reference governing contracts directly.
- Roadmap tasks must stop on planning gaps rather than imply missing repo or
  interface behavior.

## Drift Patterns

- Roadmaps sized to one agent turn or one vague bucket instead of a
  dependency-linked task runway
- New roadmap files created per thread instead of updating the active task
- `## Work` with only one vague step or prose bullets instead of
  checkbox task lists
- Multiple competing active queues within one generation
- Deferred candidates stored as roadmap tasks without approval
- A retained `docs/roadmaps/backlog/` or other backlog folder
- Missing generation rollover rationale
- Global phase-number assumptions that bypass `gNN.NNN`
- Tasks marked ready even though contract refs or planning state are missing
- Roadmap text that assumes behavior from unplanned repos or undeclared seams
- Parallel mode enabled without clear lane separation between generations

## Fix Rules

- Expand thin roadmaps into dependency-linked tasks with ordered steps
- Merge per-thread roadmap scratchpads into the active task; retire
  duplicate task files
- Convert execution-plan prose bullets to checkbox tasks where progress should
  be scannable
- Consolidate competing queues within a generation and move unresolved or
  deferred candidates to triage.
- In parallel mode, ensure each generation's queue is clearly separated and
  front doors name all active generations.
- Move unresolved backlog content into triage; promote approved executable work
  into top-level generation tasks.
- Add or update generation index entries for rollover reasons.
- Normalize all roadmap references to `gNN.NNN`.
- Backfill contract refs and planning state where execution readiness exists.
- If the needed contract or authority map does not exist, mark the task
  blocked and repair planning instead of guessing.

## Fast Checks

```bash
find docs/roadmaps -maxdepth 3 -type f | sort
rg -n "g[0-9]{2}\.[0-9]{3}|generation|Contract refs|Planning state|Planning Gaps" docs/roadmaps
find docs -type d -name backlog -print
```

## Completion Criteria

- In sequential mode, one clear active queue remains.
- In parallel mode, each active generation has a clear queue and front doors
  accurately name all active generations.
- Triage owns unresolved or deferred candidates and roadmaps contain only
  promoted executable work.
- Active roadmap work is visibly contract-backed or explicitly blocked on
  planning.
