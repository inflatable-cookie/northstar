# Adopt

## Start a new knowledge base

1. Copy the contents of `template/` into the repository root.
2. Fill in `AGENTS.md` and `docs/knowledge/vision.md`. Keep other files short
   until there is something current to record. Omit empty folders and index
   rows, such as `domain/`, when they do not apply.
3. Write `docs/knowledge/contracts/release.md` if the project releases
   software, even if it only records that the first release has not happened.
4. Adapt the validation and guardrail sections of `AGENTS.md` to the project.
   Its task tracking and delivery process belong to the project's own tools and
   conventions.

The template is a minimum, not a maximum. Keep hard-won project lessons, and
split `architecture.md` into an `architecture/` folder when it outgrows a
page.

## Migrate an existing knowledge base

Make the change in a deliberate pass:

1. Identify current facts, durable rules, domain vocabulary, open questions,
   useful product documentation, and historical material.
2. Move current project truth into `docs/knowledge/`, with one owning file per
   topic. Keep product documentation where its readers expect it and link to
   it from the knowledge index.
3. Put unresolved questions that matter to future work in `questions.md`.
   Record answers in the owning knowledge file and link to them from the
   question entry.
4. Record concepts that no longer apply in `retired.toml`, and update live
   references in the same change.
5. Remove duplicate summaries, stale status, and process records that have a
   better home in the project's own task or delivery system.
6. Update the index and run the documentation checks listed by the project.

Preserve detailed system design and evidence that current decisions rely on.
Git history is the home for obsolete facts and completed work narratives.

## Record unreleased changes as fragments

A repository that keeps a `CHANGELOG.md` records unreleased changes as
fragments: one small file under `changelog.d/` per change, named
`<task-or-pr-reference>-<short-slug>.<type>.md` so parallel branches never
collide. The type is one of `added`, `changed`, `fixed`, `removed`,
`security`; the body is one entry of a line or two. Add a fragment with the
change and leave `[Unreleased]` empty; never edit the section directly.

To adopt, move the current `[Unreleased]` entries into fragments once and
leave the section empty. Run the script's `check` alongside the docs checks:
it refuses a malformed fragment with the file and reason, and fails when
`[Unreleased]` is edited directly.

When a release is cut, fold the fragments in through the repository's task
runner: `changelog.py fold --version <x.y.z> [--date YYYY-MM-DD]` inserts a
`## [version] - date` heading in a stable order (by type, then name), deletes
the folded fragments, and refuses malformed ones. The skill catalog exposes
it as `changelog`.
