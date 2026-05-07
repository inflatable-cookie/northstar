# Policy

**Type: OPTIONAL** -- Add this folder for repo-local rules and style guidance.

Use this folder for small repo-local rules that should be easy for agents and
operators to reference without embedding long instructions in `AGENTS.md` or
`CLAUDE.md`.

Keep it lean:

- short policy files
- stable references from agent instruction files
- internal rules, not public product docs

Recommended starter files:

- `vision-next-task-verbs.txt`
- `internal-writing-style.md`
- `active-thread-style-reset-prompt.md`

## Next Task

Keep agent-facing style and validation allowlists here when a short stable
reference is better than repeating the full rule in multiple instruction files.
