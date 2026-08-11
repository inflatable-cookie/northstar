# Papercuts Feedback Loop

Status: active  
Updated: 2026-08-06

Papercuts are small, solvable sources of execution friction noticed while an
agent is doing real work: unclear tool usage, repeated file discovery, noisy
output, missing helpers, or confusing instructions. They are a feedback loop
for improving the project and its agent workflow.

## Agent contract

During execution, the agent must append a short entry to `PAPERCUTS.md` at the
root of the repository that owns the work when it hits a papercut. If the file
does not exist, create it and add the entry without asking the operator.

Record the papercut before continuing, but do not stop the current task to fix
it, wait for permission, or turn it into an unplanned work item. Keep the entry
short and actionable:

- what was harder than it should have been
- the repeat cost or failure mode
- the smallest plausible improvement
- the tool, document, script, or workflow involved

Do not record ordinary one-off task failures, intentional exploration, external
blockers, sensitive data, or problems that have no plausible improvement path.
Do not duplicate an existing open entry; add context to it only when the new
observation materially changes the diagnosis.

For nested repositories, write to the root of the repository containing the
changed files. A thin workspace root may keep its own queue for orchestration
friction while each child project owns its implementation queue.

## Entry shape

Use the starter shape in `PAPERCUTS.md`:

```markdown
### [ ] <short title> — YYYY-MM-DD
- Friction: <what happened>
- Impact: <why it is worth fixing>
- Possible fix: <smallest plausible improvement>
- Surface: <tool, doc, script, or workflow>
```

## Triage rule

Papercuts are observations, not automatic roadmap commitments. During normal
maintenance or planning, group duplicates, close entries fixed by other work,
and promote material or repeated items into the appropriate backlog, roadmap,
spec, architecture, contract, or automation change. Keep the queue small enough
to review.

Known adoption footgun: `tasks.health = [{ task = "qa" }]` makes every
`effigy doctor` run the full board. Prefer a cheap health baseline; keep full
validation on `effigy qa`. See the skill repo-contract task ladder.
