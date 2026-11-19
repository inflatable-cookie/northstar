# Northstar

Northstar is the operator's opt-in stack of agent skills. The vision explains
what belongs, and the README lists the skills. Task state belongs in each
project's own task system.

## Where things live

- Docs entry point: `docs/README.md`
- Knowledge index: `docs/knowledge/README.md`
- Unreleased changes: `changelog.d/`, folded into `CHANGELOG.md` when a
  release is cut
- Skills: `skills/<skill>/`; the docs skill and copy-ready starter are
  `skills/northstar-docs/`
- Harness snippet: `harness/snippet.md`

## Commands

- `effigy qa` — full validation: script self-tests, links and changelog
  fragments.
- `effigy check:skill-install` — installed skills match source.

Effigy wraps the scripts here; each also runs directly with `python3`. Skill
scripts must stay dependency-free Python 3.8+ so adopters need nothing else.

## Product rules

- Keep `skills/northstar-docs/template/` copy-ready, with no Northstar-specific
  examples.
- Say a rule once, in the skill. Remove guidance a capable agent follows by
  default instead of repeating it.
- Follow the compatibility rules in `docs/knowledge/contracts/release.md`.
  If a change breaks callers or documented behaviour, stop with a short
  impact summary and options.
- Write in the house style: the writing section of `harness/snippet.md`.

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
