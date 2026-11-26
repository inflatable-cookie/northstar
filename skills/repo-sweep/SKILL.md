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
- Name the repository inventory you searched and its limits. Record any
  exclusions or repositories you couldn't inspect.
- Find candidates on the fetched default branch, or the local default branch
  for a repository without a remote. Search file names and content.
- Change live references, including fixtures that exercise the current
  contract. Leave history and frozen artefacts intact and report them.
- Find who calls the thing being changed: task runner selectors, CI, vendored
  copies, other repositories' instructions. A caller you miss breaks after
  merge.
- Check for an open PR that already makes this change before starting one.
- Unless the operator already authorised the sweep, show the candidate
  repositories, exclusions and merge order before editing.

## 2. Order

Nothing may break between merges.

- **Removing** something: consumers drop their use first, the source removes
  it last.
- **Adding or changing compatibly**: the source ships first, then consumers
  adopt it.
- **Changing incompatibly**: plan a transition allowed by the source's
  compatibility rules, or a cutover that cannot expose a mixed state to
  callers. If neither is available, report the blocker before making changes.

## 3. Apply

- Work in a fresh worktree per repository, branched from the revision you
  searched, under a scratch directory.
- Re-run discovery and check each worktree against its completion criteria.
  For a retirement or rename, check that no obsolete live references remain.
- Keep each repository's conventions: its changelog fragment naming, commit
  style and validation selectors.

## 4. Validate

- Run each repository's own targeted check for what changed (docs, lint,
  tests for touched code). Record which repositories have no such check.
- Run broader checks where the project's requirements or impact call for them.
  Limit concurrent builds and tests when validating many repositories.

## 5. Land

- When authorised to open PRs, use one per repository with the same title.
  Explain the change, link the source PR and list the validation.
- Merge when authorised by the operator or their standing policy, after
  required checks and reviews pass.
- Hand a PR to the repository's owner only when the change touches that
  project's product direction.
- Remove each worktree once its branch is pushed, and delete local branches
  after merge.

## Report

Give the operator a table of repository, PR and state. Include search
coverage and exclusions, history hits left alone, missing checks and open
decisions.
