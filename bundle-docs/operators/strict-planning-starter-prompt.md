# Strict Planning Starter Prompt

Use this prompt when a fresh agent needs to plan a product or multi-repo program
in Northstar before any execution begins.

Use this prompt only when planning is still missing or incomplete.
If planning is already sound and you want the next milestones, use the roadmap
compiler path instead.
If the existing project state is stale or contradictory, use the refocus path
instead.

## Copy/Paste Prompt

```text
Plan this project in Northstar using strict planning mode. Do not begin
implementation or speculative roadmap execution until the planning gates are
complete.

Northstar planning source of truth:
- README.md
- bundle-docs/operators/README.md
- bundle-docs/sections/02-architecture.md
- bundle-docs/sections/03-roadmaps.md
- bundle-docs/sections/05-research.md
- bundle-docs/sections/06-planning-and-contract-gates.md
- template-bundle/architecture/system-architecture.md
- template-bundle/architecture/system-inventory.md
- template-bundle/architecture/repo-authority-map.md
- template-bundle/contracts/contract-index.md
- template-bundle/contracts/001-contract-template.md
- template-bundle/roadmaps/templates/roadmap-milestone-template.md

Execution requirements:
1. Audit the current planning state first and list exact gaps with file paths.
   If planning already looks coherent enough to compile milestones immediately,
   stop and route to the roadmap-compiler flow instead of redoing planning work.
2. Enumerate every known execution-relevant surface: repos, services, packages,
   interfaces, operators, external dependencies, and validation surfaces.
3. Update or create `system-architecture.md`, `system-inventory.md`, and
   `repo-authority-map.md` when multiple repos or authority boundaries exist.
4. Create or update `contract-index.md` and add contracts for every boundary the
   active roadmap would rely on.
5. If any required surface is still unknown, record it explicitly as a planning
   gap and mark roadmap work blocked.
6. Promote research-backed decisions into architecture and contracts before
   allowing roadmap execution.
7. Only after the planning gates are satisfied, compile roadmap milestones from
   the approved contracts.
8. Work in meaningful batches, not tiny edits, and leave one explicit next task.

Output requirements:
- files changed
- planning gaps closed
- unresolved planning gaps
- validation checks run
- next task
```

## Next task

Pair this starter prompt with a concrete multi-repo specimen so fresh agents can
copy the planning shape instead of inventing their own.
