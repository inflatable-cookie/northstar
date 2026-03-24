# Project Refocus Starter Prompt

Use this prompt when a project already has Northstar docs or partial planning,
but execution has drifted and the system needs to be reorganized around strict
planning, contracts, and clear ownership.

Use this prompt when you do not trust the current planning or roadmap state.
If the plan is still coherent and you only need the next milestones, use the
roadmap compiler path instead.
If the plan is coherent but changed in a bounded way, use the replan path
instead.

## Copy/Paste Prompt

```text
Refocus this project using Northstar strict planning. Assume the current docs,
roadmaps, and execution state may be partially stale. Do not preserve a broken
plan just because it exists.

Northstar refocus source of truth:
- README.md
- bundle-docs/operators/README.md
- bundle-docs/sections/02-architecture.md
- bundle-docs/sections/03-roadmaps.md
- bundle-docs/sections/05-research.md
- bundle-docs/sections/06-planning-and-contract-gates.md
- bundle-docs/sweeps/README.md
- bundle-docs/sweeps/08-planning-gate-sweep.md
- bundle-docs/operators/strict-planning-starter-prompt.md

Execution requirements:
1. Audit the current planning and execution surfaces first: architecture,
   contracts, research, roadmaps, logs, and active repo boundaries.
   If the roadmap and planning surfaces are already coherent, stop and route to
   roadmap compilation instead of running a refocus pass.
2. Identify drift explicitly: stale milestones, missing contracts, unclear repo
   ownership, untracked research-driven bets, and fake or inferred behavior.
3. Rebuild planning coverage using `system-architecture.md`,
   `system-inventory.md`, `repo-authority-map.md`, and `contract-index.md`.
4. Mark stale roadmap milestones blocked or superseded rather than patching over
   them silently.
5. Convert real missing boundaries into contracts or explicit planning gaps.
6. If the sequencing baseline is no longer trustworthy, roll over to a new
   roadmap generation and record why.
7. Resume roadmap compilation only after the refocused planning surfaces are
   coherent.
8. Work in meaningful batches and leave one explicit next task.

Output requirements:
- files changed
- drift or planning gaps found
- planning surfaces repaired
- milestones blocked, superseded, or recompiled
- validation checks run
- next task
```

## Next task

Use this prompt with a dedicated refocus skill so agents handling recovery work
follow a repeatable repair flow instead of ad hoc cleanup.
