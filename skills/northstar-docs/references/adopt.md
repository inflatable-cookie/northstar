# Adopt

## Start a new knowledge base

1. Use `template/AGENTS.md` and `template/docs/` as the starter. Copy
   missing files and merge useful guidance into existing files. Keep the
   project's root README.
2. Fill in `AGENTS.md` and `docs/knowledge/vision.md`. Keep other files short
   until there is something current to record. Omit empty folders and index
   rows, such as `domain/`, when they do not apply.
3. Include `docs/knowledge/contracts/release.md` and its index entries if the
   project releases software. Omit the file and links otherwise.
4. Adapt the validation and guardrail sections of `AGENTS.md` to the project.
   Its task tracking and delivery process belong to the project's own tools and
   conventions.

The template is a minimum, not a maximum. Keep hard-won project lessons, and
split `architecture.md` into an `architecture/` folder when it outgrows a
page.

## Migrate an existing knowledge base

Make the change in a deliberate pass:

1. Identify current facts, durable rules, domain vocabulary, useful product
   documentation, and historical material.
2. Move current project truth into `docs/knowledge/`, with one owning file per
   topic. Keep product documentation where its readers expect it and link to
   it from the knowledge index.
3. Remove concepts that no longer apply, and update live references in the
   same change.
4. Remove duplicate summaries, status, progress, and lists that mirror the
   code. Status and process records belong in the project's own planning
   system.
5. Turn `docs/README.md` into an entry point to the docs, if it isn't one.
6. Update the index and run the documentation checks listed by the project.

Preserve detailed system design and evidence that current decisions rely on.
Git history is the home for obsolete facts and completed work narratives.

## Record unreleased changes as fragments

A repository that keeps a `CHANGELOG.md` records unreleased changes as
fragments: one small file under `changelog.d/` per change, named
`<task-or-pr-reference>-<short-slug>.<type>.md` so parallel branches never
collide. The type is one of `added`, `changed`, `fixed`, `removed`,
`security`. Write one entry per fragment without a list marker. Add the
fragment with the change and leave `[Unreleased]` empty.

To adopt, create `changelog.d/` and track an empty `.gitkeep` in it. Ensure
`CHANGELOG.md` has a literal `## [Unreleased]` heading. Move its current
entries into fragments and leave the section empty. Run the script's
`check` alongside the docs checks:
it refuses a malformed fragment with the file and reason, and fails when
`[Unreleased]` is edited directly.

When a release is cut, run
`python3 "<skill-dir>/scripts/changelog.py" fold --version <x.y.z>` from the
repository root or use the project's equivalent task. The command inserts a
`## [version] - date` heading in a stable order (by type, then name), deletes
the folded fragments, and refuses malformed ones. The skill catalog exposes
it as `changelog`.
