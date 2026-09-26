# Northstar

Northstar is a small skill and a repository shape that keep a project's
knowledge current and its work well-aimed. This repository is the skill's
source and the reference example of the shape. It must never grow back into
process doctrine: task state belongs in Queue, not in Git.

## Where things live

- Current state: `docs/README.md`
- Knowledge (one owner per fact): `docs/knowledge/README.md`
- Retired concepts, which must not come back: `docs/knowledge/retired.toml`
- Open questions: `docs/knowledge/questions.md`
- What's next: `docs/plan.md`
- Unresolved leads: `docs/triage/`
- The skill: `skills/northstar/SKILL.md`; its starter: `skills/northstar/template/`

Tasks, briefs and status live in Queue, never in this repository.

## Commands

- `effigy qa` — full validation: skill self-tests, language-package checks,
  retired concepts and links.
- `effigy check:skill-install ~/.agents/skills/northstar` — installed copy
  matches source.
- `effigy skill run --path skills/northstar <task>` — run a skill task from
  source (`retired-concepts`, `cut`, `check-links`, `paseo:worktree`).

## Product rules

- Keep `skills/northstar/template/` copy-ready: starter material for another
  project, with no Northstar-specific examples.
- Say a rule once, in the skill. Doctrine a capable agent follows by default is
  removed, not restated.
- The `paseo:worktree` selector and the installed path
  `~/.agents/skills/northstar` are relied on by other repositories'
  `paseo.json`. Don't rename either.
- Before 1.0, update callers and remove superseded surfaces together; no shims.
  If a change breaks callers or documented behaviour, stop with a short impact
  summary and options.
- Write in the house style:
  `docs/knowledge/contracts/internal-writing-style.md`.

## Guardrails

- Don't edit `.github/workflows/` or sync the installed skill without an
  explicit operator request; both affect every project on the machine.
- When a change alters what is true, update the owning knowledge file in the
  same PR.
- An operator ruling given in conversation goes into its owning file before
  the thread ends.

## Papercuts

File small, recurring friction in Queue with `papercut.add` (see the
`northstar` skill). There is no `PAPERCUTS.md`.

## Validate

`effigy qa` before opening a PR.
