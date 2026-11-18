# Northstar

Northstar is becoming an opt-in stack of skills: the knowledge-structure skill
and starter, Atlas, and the optional UI module. Direction is in
`docs/knowledge/vision.md`. Task state belongs in each project's own task
system, not in Git.

## Where things live

- Current state: `docs/README.md`
- Knowledge index: `docs/knowledge/README.md`
- Retired concepts: `docs/knowledge/retired.toml`
- Open questions: `docs/knowledge/questions.md`
- Unreleased changes: `changelog.d/`, folded into `CHANGELOG.md` when a
  release is cut
- The skill and copy-ready starter: `skills/northstar/`
- The Atlas skill: `skills/atlas/`

## Commands

- `effigy qa` — full validation: skill self-tests, retired concepts, links and
  changelog fragments.
- `effigy check:skill-install` — installed skills match source.

Effigy wraps the scripts here; each also runs directly with `python3`. Skill
scripts must stay dependency-free Python 3.8+ so adopters need nothing else.

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
