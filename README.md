# Northstar

A small stack of agent skills for working on software with coding agents
without having to explain the same things every session. Every piece is
opt-in, the skills work in any harness that loads `SKILL.md` folders, and
their scripts need only Python 3.8+ and Git.

## The skills

- [`hill-climb`](skills/hill-climb/SKILL.md): raise quality at least one
  level per run with a rated rubric, then keep the rubric as a gate.
- [`take-stock`](skills/take-stock/SKILL.md): audit what a project holds,
  what's stale and what depends on it.
- [`repo-sweep`](skills/repo-sweep/SKILL.md): make one change across many
  repositories, one PR each.
- [`prune-tests`](skills/prune-tests/SKILL.md): keep only tests anchored to
  intended behaviour.
- [`atlas`](skills/atlas/SKILL.md): shape a project's long-horizon direction
  with the operator.
- [`northstar-docs`](skills/northstar-docs/SKILL.md): a lightweight
  documentation structure with one owning file per fact, plus link and
  changelog-fragment checks.

[`harness/snippet.md`](harness/snippet.md) is guidance for a harness's global
instructions file rather than a skill: it needs to be in context from the
first message.

## Install

Copy the skills you want into your harness's skill folder, for example:

```bash
for s in hill-climb take-stock repo-sweep prune-tests atlas northstar-docs; do
  rsync -a --delete "skills/$s/" "$HOME/.agents/skills/$s/"
done
```

Link `~/.claude/skills/<skill>` (or your harness's equivalent) to those
copies.

## More

- Why it exists and what belongs: [docs/knowledge/vision.md](docs/knowledge/vision.md)
- How the repository is laid out: [docs/knowledge/architecture.md](docs/knowledge/architecture.md)

## License

See [LICENSE](LICENSE).
