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
   Closed-generation compaction is part of that mode's bounded repair; do not
   ask for a second confirmation.
4. Treat the text after `/northstar-refresh` as the existing project or refresh
   scope.

Remain read-only for canonical documentation repair unless the operator
explicitly authorizes it. Creating or updating lightweight `docs/triage/` capture
notes is part of the refresh routine and does not require separate repair
authorization. Do not start workers, create worktrees, authorize execution, or
merge.
