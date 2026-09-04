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

Triage notes are mutable. Chatterboxes create a unique file for a new issue and
update that file when later conversation corrects or develops the issue. They do
not create correction, addendum, or deprecation notes for content that belongs
in an existing note. The original filename remains stable. Planning delegates
may update the note for their current bounded issue; Chatterbox owns wider
reconciliation.

Chatterboxes and planning delegates share the working checkout and isolate
triage-only commits to exact note paths after verifying clean pre-stage index
state. They do not modify this `README.md`, create worktrees, branches, or PRs.
Planning delegates report their notes to Chatterbox, which reconciles triage and
directly promotes canonical planning after explicit operator confirmation. Raw
triage is never coordinator execution authority.

Refresh and cleanup should inspect every note and give it a disposition:
promote or rework it into its canonical home, merge it with a useful note, or
remove it when it is implemented, superseded, or no longer useful. Full
promotion deletes the source note in the same coherent commit. Partial
promotion edits it down to only unresolved meaning. Ask the operator when the
destination, ownership, or removal decision is unclear. Keeping a note open is
an interim state, not a permanent home. The directory holds unresolved current
meaning; Git history and logs preserve provenance.

The `README.md` anchor is not a triage note. Other files or folders here should
be understood before they are changed or removed.
