# Northstar

A small stack of agent skills for working on software with coding agents
without having to explain the same things every session. Every piece is
opt-in, the skills work in any harness that loads `SKILL.md` folders, and
their scripts need only Python 3.8+ and Git.

## The skills

- [`hill-climb`](skills/hill-climb/SKILL.md): assess quality or improve it
  to a target score.
- [`red-pen`](skills/red-pen/SKILL.md): review feature scope and recommend
  what to keep, simplify, or remove.
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

From the checkout you want to install, copy skills into the shared skills
folder. The example installs the full stack. To opt into a subset, replace
`skills/*/` with the directories you want. Check the destinations before
running it, since the command replaces the contents of existing copies.

```bash
mkdir -p "$HOME/.agents/skills"
for source in skills/*/; do
  [ -f "${source}SKILL.md" ] || continue
  skill=${source%/}
  dest="$HOME/.agents/skills/${skill##*/}"
  if [ -L "$dest" ]; then
    printf 'Skipped symlink: %s\n' "$dest" >&2
    continue
  fi
  rsync -a --delete "$source" "$dest/"
done
```

If your harness uses its own skill directory, link each copy from there.
For example, for Claude Code:

```bash
mkdir -p ~/.claude/skills
link=~/.claude/skills/red-pen
if [ ! -e "$link" ] && [ ! -L "$link" ]; then
  ln -s ~/.agents/skills/red-pen "$link"
fi
```

If the path already exists, check that it points to the intended copy.

## More

- [Documentation entry point](docs/README.md)
- Why it exists and what belongs: [docs/knowledge/vision.md](docs/knowledge/vision.md)
- How the repository is laid out: [docs/knowledge/architecture.md](docs/knowledge/architecture.md)

## License

See [LICENSE](LICENSE).
