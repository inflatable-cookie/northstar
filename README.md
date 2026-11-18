# Northstar

Northstar keeps a software project's knowledge current and easy to use, so
readers can find the facts they need without reconstructing intent from
conversation.

## What's here

- [`skills/northstar/`](skills/northstar/SKILL.md): the installable skill for
  knowledge structure and upkeep.
- [`skills/atlas/`](skills/atlas/SKILL.md): long-horizon direction with the
  operator.
- [`skills/fleet-sweep/`](skills/fleet-sweep/SKILL.md): one change across many
  repositories.
- [`skills/northstar/template/`](skills/northstar/template/README.md): the
  copy-ready starter for a project.
- [`skills/northstar/references/adopt.md`](skills/northstar/references/adopt.md):
  adopting Northstar's documentation structure.
- [`docs/`](docs/README.md): Northstar's own knowledge, using the same shape
  it offers other projects.

## Install

```bash
rsync -a --delete skills/northstar/ ~/.agents/skills/northstar/
rsync -a --delete skills/atlas/ ~/.agents/skills/atlas/
rsync -a --delete skills/fleet-sweep/ ~/.agents/skills/fleet-sweep/
```

Point your harness's skill folder at those copies. The scripts need Python
3.8+ and Git.

## License

See [LICENSE](LICENSE).
