# Triage

**Type: REQUIRED** -- Keep this folder as the temporary capture buffer for
observations, ideas, plans, and questions that are useful but not yet settled
into the Northstar planning spine.

## Naming

Use the same local-creation timestamp as handoffs:

```text
YYYYMMDD-HHMMSS-<slug>.md
```

Use a short lowercase kebab-case slug. If the same timestamp and slug already
exists, add `-2`, `-3`, and so on. The filename records when the note was
captured; do not rename it just because the note is edited later.

## What belongs here

Triage notes are deliberately lightweight Markdown. There is no required
frontmatter or body shape. Capture the useful thought before following one
branch of a conversation deeply. A note may contain several related threads,
tentative interpretations, links, or a possible canonical destination.

Triage is an intake buffer, not an execution authority. Do not treat an idea in
this folder as an approved contract, roadmap item, or implementation request.

Chatterboxes share the working checkout and write only new unique triage files
here without modifying `README.md` or any other path. They commit with
`git add -- <exact-file>`. They do not create worktrees, branches, or PRs, and
do not acquire promotion or execution authority.

## Lifecycle

Every note needs a disposition over time:

1. inspect it during refresh, cleanup, or another relevant Northstar run;
2. promote or rework useful content into its canonical home;
3. merge duplicates or remove notes that are implemented, superseded, or no
   longer useful.

Keeping a note explicitly open is an interim state, not a permanent home. Give
an open note a next check or owner when possible, and eventually promote,
implement, or remove it.

If the destination, ownership, or removal decision is unclear, ask the operator
before changing or deleting the note. Once a note has been promoted, remove the
scratch copy; keep a link from a log only when the capture itself matters as
evidence.

The `README.md` anchor is not a triage note. Other files or folders here should
be treated as cleanup findings until they are understood.
