---
name: repo-sweep
description: Make one change across many repositories, such as retiring a convention, renaming a shared surface, or updating a common config. Use when the operator asks to apply something "everywhere" or across every repository that uses X.
---

# Repo sweep

One change, many repositories, one PR each. The sweep stays mechanical:
anything that needs a product decision in a repository is reported, not
decided.

## 1. Scope

- Say the change in one sentence, plus what "done" means for each repository.
- Find every candidate from the fetched default branch (`git grep` against
  `origin/<default>`), not from local checkouts, which may be stale or
  mid-task. Search file names as well as content.
- Classify each hit as **live** (code, config, current docs, agent
  instructions) or **history** (changelogs, fixtures, research notes,
  released or frozen artefacts). Change live hits only; list history hits as
  left alone, with the reason.
- Find who calls the thing being changed: task runner selectors, CI, vendored
  copies, other repositories' instructions. A caller you miss breaks after
  merge.
- On a loaded machine, check the load first and sweep in smaller batches.

## 2. Order

Nothing may break between merges.

- **Removing** something: consumers drop their use first, the source removes
  it last.
- **Adding or changing** something: the source ships first, then consumers
  adopt it.
- If one side can't land without the other, say so before starting.

## 3. Apply

- Work in a fresh worktree per repository, branched from the fetched default
  branch, under a scratch directory. Never edit the operator's checkouts.
- Run multi-repository loops in `bash`, not `zsh`: `zsh` doesn't split an
  unquoted list into words, so a loop runs once over the whole string.
- Do the mechanical part with one script across every worktree, then the
  hand edits each repository needs. Read the context before each hand edit.
- Re-run the discovery search in every worktree until no live hit is left.
- Keep each repository's conventions: its changelog fragment naming, commit
  style and validation selectors.

## 4. Validate

- Run each repository's own targeted check for what changed (docs, lint,
  tests for touched code). Record which repositories have no such check.
- Don't run full suites across every repository; one round of targeted checks is
  enough for a mechanical change.

## 5. Land

- One PR per repository, with the same title. The body says what changed,
  why, links the source PR, and lists the validation that ran.
- Follow the operator's merge policy. Without one, merge once checks pass;
  wait for pending CI instead of merging over it.
- Hand a PR to the repository's owner only when the change touches that
  project's product direction.
- Remove the worktrees and delete merged local branches afterwards.

## Report

Give the operator a table of repository, PR and state; the history hits left
alone; repositories without a check; and anything that still needs a
decision.
