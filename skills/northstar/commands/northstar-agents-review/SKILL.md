---
name: northstar-agents-review
description: Review a Northstar AGENTS instruction surface.
---

# Northstar AGENTS Review

Thin explicit entrypoint for the canonical agent-instruction review route.

1. Load `references/router.md` from the main `northstar` skill.
2. Select **Agent instruction review** and load
   `references/modes/agent-instruction-review.md`.
3. Follow that mode's target-repository-aware audit procedure.
4. Treat the text after `/northstar-agents-review` as the review target or
   question.

Remain read-only unless the operator explicitly authorizes a bounded repair. Do
not start workers, create worktrees, authorize execution, or merge anything.