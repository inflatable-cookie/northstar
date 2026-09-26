# Northstar

Northstar keeps a software project's knowledge current and its work
well-aimed, so any agent can pick up a task without reconstructing intent from
conversation.

The repository holds **knowledge and code**. The orchestrator (the Paseo Queue
plugin today, Nucleus later) holds **process**: tasks, briefs, status, review,
closeout, outcomes and papercuts.

## What's here

- [`skills/northstar/`](skills/northstar/SKILL.md): the installable skill.
  Planning, briefs, review and knowledge upkeep, plus the migration tools.
- [`skills/northstar/template/`](skills/northstar/template/README.md): the
  copy-ready starter for a project.
- [`skills/northstar/references/adopt.md`](skills/northstar/references/adopt.md):
  adopting Northstar, or migrating from the older shape.
- [`docs/`](docs/README.md): Northstar's own knowledge and plan, in the same
  shape it asks of other projects.

## Install

```bash
rsync -a --delete skills/northstar/ ~/.agents/skills/northstar/
```

Point your harness's skill folder at that copy. The skill's tasks run through
Effigy as `effigy skill run northstar/<task>`.

## License

See [LICENSE](LICENSE).
