---
name: northstar-docs
description: Give a project's documentation a lightweight, static structure, with one owning file per fact, that doesn't go stale. Use when adopting this structure, or, in a repository that uses it, when deciding where a fact belongs, reviewing documentation changes, or checking links and changelog fragments.
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
  copy-ready starter in [template/](template/). The starter is a
  minimum, not a schema.
- Reviewing a documentation change: [review](references/review.md).

## Scripts

Python 3.8+ and Git, no other dependencies. From the project root, use the
path to your copy of the skill:

```bash
python3 "<skill-dir>/scripts/check-links.py"
python3 "<skill-dir>/scripts/changelog.py" check
python3 "<skill-dir>/scripts/changelog.py" fold --version <x.y.z>
```

A changelog fragment is one file per change under `changelog.d/`, named
`<task-or-pr-reference>-<short-slug>.<type>.md`; the
[adoption guide](references/adopt.md#record-unreleased-changes-as-fragments)
has the full rules.

`effigy.toml` wraps the same scripts for projects that use Effigy
(`effigy skill run northstar-docs/<task>`).
