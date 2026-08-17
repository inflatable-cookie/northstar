---
name: northstar-reframe
description: Reframe a Northstar request without changing scope.
---

# Northstar Reframe

Thin explicit entrypoint for the canonical Northstar reframe route.

1. Load `references/router.md` from the main `northstar` skill.
2. Select the **Reframe** route and load
   `references/modes/pre-execution-discovery.md`.
3. Follow that mode's reframe procedure exactly.
4. Treat the text after `/northstar-reframe` as the request to restate.

Remain read-only. Do not create a plan, change repository state, authorize
execution, start a worker, create a worktree, or merge anything.