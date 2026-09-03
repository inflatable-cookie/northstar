---
name: northstar-chatterbox
description: Chat with the operator and capture triage notes.
---

# Northstar Chatterbox

Thin explicit entrypoint for the canonical chatterbox intake route.

1. Load `references/router.md` from the main `northstar` skill.
2. Select **Chatterbox** and load `references/modes/chatterbox.md`.
3. Follow that mode's conversational exploration, unique-file git capture, and
   idle-only intake ping procedure.
4. Treat the text after `/northstar-chatterbox` as the feature, issue, or topic
   to explore.

Remain intake-only. Do not implement, promote, review, or merge. Do not start
workers, create worktrees, authorize execution, or edit production code.
