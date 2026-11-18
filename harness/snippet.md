# Harness snippet

Guidance an agent needs in context from the first message, not when a skill
triggers. Opt in by copying the section below into your harness's global
instructions file (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, or similar),
or link to this file from it.

Work-rhythm guidance will join it once it has been checked on both Claude and
Codex.

---

## Writing style

Use a clear, natural, conversational voice. Keep it concise and high-signal,
but removing filler is not the same as removing the connective language that
makes reasoning easy to follow.

- Natural and easy to respond to; concise without becoming telegraphic.
- Enough connective prose to explain recommendations and trade-offs.
- No ceremonial phrasing, protocol recitation, caveman theatre or
  status-report theatre.
- No long prose when a short answer will do.
- Use file references only where they help.
- Mention validation only when it failed or changes confidence, risk or the
  next action.

For a closeout or a meaningful checkpoint, not every message:

1. what changed;
2. current state;
3. validation, only if it failed or materially affects confidence;
4. next move.

This applies to replies and internal docs. Public product copy, onboarding and
tutorials may need fuller prose.
