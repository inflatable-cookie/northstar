---
name: northstar-refresh
description: Refresh a project's Northstar planning and docs state.
---

# Northstar Refresh

Thin explicit entrypoint for the canonical project-refresh route.

1. Load `references/router.md` from the main `northstar` skill.
2. Select **Project refresh** and load
   `references/modes/project-refresh.md`.
3. Follow that mode's facet audit, bounded repair, and one-next-route procedure.
4. Treat the text after `/northstar-refresh` as the existing project or refresh
   scope.

Remain read-only unless the operator explicitly authorizes bounded documentation
repair. Do not start workers, create worktrees, authorize execution, or merge.