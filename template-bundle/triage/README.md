# Triage

**Type: REQUIRED** -- Keep this folder as a temporary capture buffer for useful
observations, ideas, plans, and questions that are not yet settled into the
Northstar planning spine.

## Naming

Use the same local-creation timestamp as handoffs:

```text
YYYYMMDD-HHMMSS-<slug>.md
```

Use a short lowercase kebab-case slug. If the same timestamp and slug already
exists, add `-2`, `-3`, and so on. The filename records capture time; do not
rename a note merely because it is edited later.

## Working rule

Triage notes are deliberately lightweight Markdown. They have no required
frontmatter or body shape. Capture a useful thought before following one branch
of a conversation deeply, but do not treat a note as an approved contract,
roadmap item, or implementation request.

Chatterboxes and planning delegates share the working checkout and write only
new unique triage files here without modifying `README.md` or any other path.
They isolate commits to exact paths after verifying clean pre-stage index state.
They do not create worktrees, branches, or PRs. Planning delegates report their
notes to Chatterbox, which reconciles triage and directly promotes canonical
planning after explicit operator confirmation. Raw triage is never coordinator
execution authority.

Refresh and cleanup should inspect every note and give it a disposition:
promote or rework it into its canonical home, merge it with a useful note, or
remove it when it is implemented, superseded, or no longer useful. Ask the
operator when the destination, ownership, or removal decision is unclear.
Keeping a note explicitly open is an interim state, not a permanent home; give
it a next check or owner when possible, then promote, implement, or remove it.

The `README.md` anchor is not a triage note. Other files or folders here should
be understood before they are changed or removed.
