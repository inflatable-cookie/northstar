# Changelog

All notable changes to Northstar are documented here. Unreleased changes are
fragments in `changelog.d/`, folded into this file when a release is cut.

## [Unreleased]

## [0.1.0] - 2026-11-19

### Added
- Added changelog fragments as a canonical feature: each change drops one `<reference>.<type>.md` file in `changelog.d/`, `check:changelog` guards the format and keeps `[Unreleased]` empty, and `effigy changelog:fold` folds the fragments into `CHANGELOG.md` when a release is cut.
- `atlas`, a standalone skill for shaping a project's long-horizon direction with the operator. It records into `docs/knowledge/` and leaves planning to the project's own system.
- `harness/snippet.md`, the opt-in snippet for a harness's global instructions file; it carries the writing style, which moves out of `docs/knowledge/contracts/internal-writing-style.md`.
- The harness snippet gains a work-rhythm section (act rather than report, batch with targeted checks, step back from churn, name the next step or say the work is finished) and a writing rule to keep document and UI text short; it now explains importing it from Claude Code's `CLAUDE.md`.
- `hill-climb`, a skill for raising quality at least one level per run: a fixed rubric rated out of 10 per part plus integration, unanchored independent reads, verification before acting, correctness-first batches, and the rubric kept afterwards as a standing gate for workers and reviewers.
- `prune-tests`, adapted from caldoai/skills (MIT): keep only tests anchored to intended behaviour, with guardrails for the source of intent, which duplicate survives, a commit before deleting, and a coverage comparison after.
- `repo-sweep`, a skill for making one change across many repositories: scope from the fetched default branch, order so nothing breaks between merges, isolated worktrees, targeted checks, one PR per repository.
- `take-stock`, a read-only audit skill: inventory from the fetched default branch, live/stale/dead/unknown with evidence, dependents, and a short report that ends with the operator's decisions.

### Changed
- `atlas` no longer assumes `northstar-docs`: it reads whatever states a project's purpose, and records direction into the knowledge files when the project uses them, otherwise into its planning surface, and asks the operator when neither exists.
- `check-links` is its own script, `scripts/check-links.py`, with its own self-test; the `cut` migration helper and the `cut` catalog task are removed, since no repository still has the layouts it migrated.
- Northstar is a small knowledge-structure skill with a copy-ready `template/`, the link check and changelog fragments. Planning, briefs, papercuts and task state belong to each project's own task system.
- Renamed the docs skill from `northstar` to `northstar-docs` (folder, `name`, and the Effigy catalog alias, now `effigy skill run northstar-docs/<task>`); Northstar itself is the stack.
- `northstar-docs` treats docs as static foundations: `docs/README.md` is the entry point to the docs rather than a current-state page, and knowledge records durable facts and reasons, never status or lists that mirror the code. `references/knowledge.md` is folded into `SKILL.md`.
- The skill's scripts all run on Python 3.8+ with no dependencies. The Effigy catalog is an optional wrapper: every script runs directly.

### Removed
- `bundle-docs/`, `template-bundle/`, the router and modes, the command skills, the working-rules contract, roadmaps, logs, handoffs, lifecycle records, `PAPERCUTS.md`, and the checks that served them. Git keeps them.
- `agents/openai.yaml` from the docs skill; `SKILL.md` frontmatter covers every harness.
- `docs/knowledge/questions.md` from the starter and the skill. Open questions belong in the project's planning system; durable answers go straight into the owning knowledge file.
- Retired concepts: `docs/knowledge/retired.toml`, the `retired-concepts` check and its catalog task. Agents reimplementing retired ideas proved rare enough not to justify the check. `check-links` takes frozen paths from `--frozen` only.
- The `northstar-ui` module and its build, review, brief and design-guidance references. Use a maintained design skill, such as Impeccable.
- Language-quality packages (2026-11-18): the package host, lifecycle, registry, schemas, fixtures, route checks and the `language-quality-pack` contract. Consumer repositories drop their quality profiles and `northstar:*-quality` AGENTS.md blocks. Use a maintained language skill instead, such as BeautifulRust for Rust.

