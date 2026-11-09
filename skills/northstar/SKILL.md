---
name: northstar
description: Keep a project's knowledge current and well organized. Use for establishing documentation structure, maintaining knowledge ownership, adopting the starter, or retiring concepts.
---

# Northstar

Northstar provides a lightweight structure for a project's current knowledge.
It helps readers find what is true, where each fact belongs, and which ideas
or rules have been retired.

## Repository shape

| Surface | Holds |
| --- | --- |
| `AGENTS.md` | Project orientation, documentation map, guardrails and validation command |
| `docs/README.md` | A short account of current state, with links by topic |
| `docs/knowledge/` | Current truth, with one owning file per fact |
| `docs/knowledge/retired.toml` | Concepts that no longer apply and their replacements |
| `docs/knowledge/questions.md` | Open questions and pointers to their answers |
| `changelog.d/` | Unreleased changes as fragments, one file per change, folded into `CHANGELOG.md` when a release is cut |
| `docs/knowledge/contracts/release.md` | How the project releases, if applicable |

The exact structure belongs to each project. Add sections and folders when
they contain useful current information; omit empty ones. Keep project task
tracking in whichever system that project uses.

## Use the knowledge

Read `AGENTS.md`, then `docs/README.md`, then the knowledge files relevant to
the work. Check `retired.toml` before relying on an older concept. Check
`questions.md` and the owning knowledge file before raising a question already
addressed by the project.

## Keep knowledge current

- Give each fact one owning file. Link to it instead of copying it elsewhere.
- Write what is true now; Git history records how it changed.
- Keep detailed design where it helps people understand a complex system.
- When work changes a durable fact, update its owner alongside the change.
- Record an open question when its answer is still unknown and matters to the
  project. Close it with a link to the file that records the answer.
- When retiring a concept, add an entry to `retired.toml` and remove or update
  live references in the same change.
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

## Optional modules

UI design delivery and language quality packages are separate modules. Load
one only when the repository has opted in.

- **UI:** the nested [northstar-ui](ui/SKILL.md) skill guides UI implementation
  and review against a project's approved design guidance.
- **Language packages:** for an explicit Rust or TypeScript/Svelte quality
  audit, follow the [installed-package route](references/packages/installed-package-route.md).
  Everyday authoring is opt-in per repository; a missing or unusable pack
  falls back to the repository's own validation.
