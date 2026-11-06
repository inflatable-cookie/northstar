# Northstar

Northstar keeps a software project's knowledge current and easy to use, so
readers can find the facts they need without reconstructing intent from
conversation.

## What's here

- [`skills/northstar/`](skills/northstar/SKILL.md): the installable skill for
  knowledge structure and upkeep.
- [`skills/northstar/template/`](skills/northstar/template/README.md): the
  copy-ready starter for a project.
- [`skills/northstar/references/adopt.md`](skills/northstar/references/adopt.md):
  adopting Northstar's documentation structure.
- [`docs/`](docs/README.md): Northstar's own knowledge, using the same shape
  it offers other projects.

## Install

```bash
rsync -a --delete skills/northstar/ ~/.agents/skills/northstar/
```

Point your harness's skill folder at that copy. Skill tasks run through Effigy
as `effigy skill run northstar/<task>`.

## License

See [LICENSE](LICENSE).
