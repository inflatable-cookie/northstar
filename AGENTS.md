# Northstar

Northstar is a small skill and a repository shape for keeping project
knowledge current and easy to use. It must stay focused on documentation
structure and knowledge maintenance. Task state belongs in each project's own
task system, not in Git.

## Where things live

- Current state: `docs/README.md`
- Knowledge index: `docs/knowledge/README.md`
- Retired concepts: `docs/knowledge/retired.toml`
- Open questions: `docs/knowledge/questions.md`
- The skill and copy-ready starter: `skills/northstar/`

## Commands

- `effigy qa` — full validation: skill self-tests, language-package checks,
  retired concepts and links.
- `effigy check:skill-install ~/.agents/skills/northstar` — installed copy
  matches source.
- `effigy skill run --path skills/northstar <task>` — run a skill task from
  source (`retired-concepts`, `cut`, `check-links`).

General Effigy guidance comes from the maintained Effigy skill. These are
Northstar's selectors and guardrails. Install Effigy separately, using its
project documentation.

## Product rules

- Keep `skills/northstar/template/` copy-ready, with no Northstar-specific
  examples.
- Say a rule once, in the skill. Remove guidance a capable agent follows by
  default instead of repeating it.
- Before 1.0, update callers and remove superseded surfaces together; no
  shims. If a change breaks callers or documented behaviour, stop with a
  short impact summary and options.
- Write in the house style:
  `docs/knowledge/contracts/internal-writing-style.md`.

## Guardrails

- Don't edit `.github/workflows/` or sync the installed skill without an
  explicit operator request; both affect every project on the machine.
- When a change alters what is true, update the owning knowledge file in the
  same PR.
- An operator ruling given in conversation goes into its owning file before
  the thread ends.

## Validate

Before a PR, run targeted checks: `effigy qa:docs` for docs, and the self-test
of any skill script you changed. Full `effigy qa` runs at release points.
