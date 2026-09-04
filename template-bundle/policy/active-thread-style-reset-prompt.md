# Active Thread Style Reset Prompt

**Type: OPTIONAL** -- Copy into your project's policy/ if you want this prompt available.

Status: active
Audience: operators

Use this when an already-running thread has not picked up the repo-local
internal writing style yet.

## Prompt

```text
Small style reset.

Use the repo-local internal writing style from now on:
- read the internal writing style reference linked in AGENTS/CLAUDE
- natural, human, conversational wording
- concise without becoming telegraphic or bureaucratic
- keep useful recommendations and next steps
- no full outcome/state/validation/next structure on every message
- use that structure only for end-of-turn closeout or meaningful checkpoint replies
- mention validation only if it failed or materially affects confidence
- in orchestrator threads, stay direct, human, and easy to redirect

Do not change the work or plan. Only change the response style.
```

## Next Task

Point `AGENTS.md` and `CLAUDE.md` at `internal-writing-style.md` for the rule,
and use this prompt only as a one-shot re-anchor for already-running threads.
