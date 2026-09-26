# Knowledge

`docs/knowledge/` is the repository's current truth. It is what agents most
often need and most often get wrong, so it is the one surface Northstar
actively maintains.

## Layout

```text
docs/knowledge/
  README.md        # index: topic → owning file, one line each
  vision.md        # what the project is for, and what it is not
  architecture.md  # system shape; split into architecture/ when it grows
  contracts/       # durable rules and interfaces, one file per contract
  domain/          # domain concepts, vocabulary, business rules
  retired.toml     # concepts that no longer exist
  questions.md     # open questions and their resolutions
```

Split a file when a topic outgrows it, and update the index. The index is the
map: every topic has exactly one owning file.

## Owning a fact

- Each fact lives in one file. Other files link to it rather than restating it.
- Write the current truth, not how it came to be. Git holds the history. Add a
  dated line only when the date matters to the rule.
- Detail is not bloat. A complex system keeps its detailed design documents;
  what goes is status, process and history.
- When work changes what is true, the PR that changes the code also changes the
  owning file.
- If two files disagree, the owner in the index wins; fix the other one.

## Operator rulings

A ruling is an answer from the operator. Land it where it changes the truth:

1. Update the owning knowledge file.
2. If it answers an entry in `questions.md`, close that entry with a pointer to
   where the answer now lives.
3. Do this before the thread ends or hands over. A ruling that exists only in
   conversation will be asked for again.

Don't keep a separate decisions log. A decision is history; the owning file is
the truth.

## Open questions

`questions.md` holds questions that block or shape work:

```markdown
## Q-012 — Do mock exams allow pausing?

Status: answered 2026-09-25
Answer: no. A fixed timer; see [assessment contract](contracts/assessment.md#mock-exams).
```

- Give every question an ID, and reference the ID from plans and briefs instead
  of restating the question.
- An answered question keeps only its pointer. Delete it once no plan or brief
  references it.
- When an answer settles most of a question but leaves a narrower case open,
  mark the original answered and open a new, narrower question for the rest,
  rather than keeping the broad one open or asking again.
- Before asking the operator, search here and in the owning file.

## Retired concepts

`retired.toml` records concepts that no longer exist, so neither code nor agents
bring them back:

```toml
[[retired]]
id = "seed-bundles-as-content"
retired = "2026-08-21"
replacement = "Content comes from Bovine publishing; seed bundles carry initial user data only."
owner = "docs/knowledge/contracts/legacy-coexistence.md"
terms = ["spine seed bundle", "canonical spine bundle"]
paths = ["state/legacy/dist/seed-bundles/spine"]
config_keys = ["canonical-spine-bundle"]  # literal text, not a dotted TOML path
```

- The retiring change removes or fixes every live reference in the same PR.
  What it can't remove yet becomes a task, not a note.
- The retired-concepts check fails on any listed term, path or config key found
  in the working tree as it is (tracked and new files; ignored files and
  unstaged deletions don't count), matching case-insensitively. Staging first
  makes no difference. The owner file, `retired.toml`
  and anything under `allow` are exempt, and so is Git history.
- A path ending in `/` names a directory and covers everything under it; a path
  without one names a single file. The same goes for `allow`, where `*` matches
  within one path segment (`scripts/*-census/`) and `**` across segments
  (`syllabus/**/calibration/`).
- Fix live references rather than widening `allow`. The exception is immutable
  artefacts, which can't change without a new release: released suites and
  generated mirrors, vendored copies, fixtures, digested receipts, and applied
  database migrations, whose checksums break if even a comment changes. List
  those in `allow` permanently.
- For a retired process or convention, `owner` is the file that describes what
  replaced it, often `AGENTS.md`.
- Run it from the repository root with
  `effigy skill run northstar-lean/retired-concepts`. Add `-- --json` for
  machine output, or `-- --retired <file>` to audit against a list that isn't
  in the repository yet, while preparing a migration. The check lives in the
  skill; repositories don't copy it.
