---
name: northstar-docs
description: Give a project's documentation a lightweight structure, with one owning file per fact, and keep it accurate. Use for adopting the starter, deciding where a fact belongs, reviewing knowledge changes, or checking links and changelog fragments.
---

# Northstar docs

An opt-in part of the Northstar stack. It provides a lightweight structure for a project's current knowledge.
It helps readers find what is true and where each fact belongs.

## Repository shape

| Surface | Holds |
| --- | --- |
| `AGENTS.md` | Project orientation, documentation map, guardrails and validation command |
| `docs/README.md` | A short account of current state, with links by topic |
| `docs/knowledge/` | Current truth, with one owning file per fact |
| `changelog.d/` | Unreleased changes as fragments, one file per change, folded into `CHANGELOG.md` when a release is cut |
| `docs/knowledge/contracts/release.md` | How the project releases, if applicable |

The exact structure belongs to each project. Add sections and folders when
they contain useful current information; omit empty ones. Keep project task
tracking in whichever system that project uses.

## Use the knowledge

Read `AGENTS.md`, then `docs/README.md`, then the knowledge files relevant to
the work. Check the owning knowledge file before raising a question the
project already answers.

## Keep knowledge current

- Give each fact one owning file. Link to it instead of copying it elsewhere.
- Write what is true now; Git history records how it changed.
- Keep detailed design where it helps people understand a complex system.
- When work changes a durable fact, update its owner alongside the change.
- When removing a concept, update or remove its live references in the same
  change.
- Keep the starter in `template/` generic and ready to copy into another
  project.

## Write clearly

Keep orientation short and link to detailed knowledge. Prefer plain language,
use the project's established terms, and include the reason behind a durable
rule when it will help future readers.

## Adopt the structure

Use [adopt](references/adopt.md) and the copy-ready starter in
[template/](template/README.md). The starter is a starting point, not a fixed
schema; adapt it to the project's needs.

## Scripts

Python 3.8+ and Git, no other dependencies. Run them from the repository root.

- `scripts/check-links.py` — broken Markdown links and anchors.
- `scripts/changelog.py check|fold` — changelog fragments.

`effigy.toml` wraps the same scripts for projects that use Effigy
(`effigy skill run northstar-docs/<task>`).
