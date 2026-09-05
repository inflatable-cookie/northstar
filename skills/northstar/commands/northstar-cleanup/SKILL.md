---
name: northstar-cleanup
description: Inspect and safely rework docs drift.
---

# Northstar Cleanup

Thin explicit entrypoint for the canonical docs-cleanup route.

1. Load `references/router.md` from the main `northstar` skill.
2. Select **Docs cleanup** and load
   `references/modes/cleanup-docs.md`.
3. Follow that mode's inventory, classification, bounded-repair, and triage
   disposition procedure. Report proposed closed-generation compaction; remain
   read-only until repair is already allowed.
4. Treat the text after `/northstar-cleanup` as the docs tree or cleanup
   question to inspect.

Remain read-only unless the operator explicitly authorizes bounded docs repair.
Do not blindly delete files, start workers, create worktrees, authorize
execution, or merge anything.
