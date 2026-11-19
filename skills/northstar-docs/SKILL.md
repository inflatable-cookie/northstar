---
name: northstar-docs
description: Give a project's documentation a lightweight, static structure, with one owning file per fact, that doesn't go stale. Use for adopting the starter, deciding where a fact belongs, reviewing documentation changes, or checking links and changelog fragments.
---

# Northstar docs

An opt-in part of the Northstar stack. It gives a project's documentation a
small, static foundation: the reasons and depth behind the code, written so
that it stays true until a decision changes.

## What goes where

| Surface | Holds |
| --- | --- |
| `README.md` | The pitch and getting started: what the project is, how to install, build or use it |
| `AGENTS.md` | Agent orientation: where things live, commands, product rules, guardrails, validation |
| `docs/README.md` | The entry point to the full docs. Each project decides what it needs to point readers at |
| `docs/knowledge/` | The why and the depth, with one owning file per topic, indexed in `docs/knowledge/README.md` |
| `changelog.d/` | Unreleased changes as fragments, folded into `CHANGELOG.md` at release |

Typical knowledge files are `vision.md` (purpose and non-goals),
`architecture.md` (system shape), `contracts/` (durable rules and interfaces,
including `release.md`) and `domain/` (concepts and vocabulary). Add a file
when it has something durable to say; omit empty ones. Split a file into a
folder when it outgrows a page, and update the index.

Product documentation for users (guides, API references) stays where its
readers expect it and is listed in the knowledge index.

## Keep it static

Docs are foundations, like the code: they change when a decision changes,
not as work progresses.

- Write durable facts and the reasons behind them: purpose, shape,
  boundaries, rules, trade-offs.
- Don't mirror the code. Lists of files, functions, flags, counts or versions
  go stale; describe the shape and point at the code.
- Don't record status, progress, plans or task lists. They belong to the
  project's planning surface. Git holds the history.
- Give each fact one owning file. Link to it rather than restating it; if two
  files disagree, the index says which one owns the fact.
- When a change alters a durable fact, update its owner in the same change.
  When it removes a concept, remove its live references too.

## Use the docs

Read `AGENTS.md`, then `docs/README.md`, then the knowledge relevant to the
work. Check the owning file before asking a question the project already
answers.

## Adopt and review

- Adopting or migrating a repository: [adopt](references/adopt.md), with the
  copy-ready starter in [template/](template/README.md). The starter is a
  minimum, not a schema.
- Reviewing a documentation change: [review](references/review.md).

## Scripts

Python 3.8+ and Git, no other dependencies. Run them from the repository root.

- `scripts/check-links.py` — broken Markdown links and anchors.
- `scripts/changelog.py check|fold` — changelog fragments.

`effigy.toml` wraps the same scripts for projects that use Effigy
(`effigy skill run northstar-docs/<task>`).
