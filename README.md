# Northstar

A small stack of agent skills for working on software with coding agents
without explaining the same things every session. Every piece is opt-in, the
skills work in any harness that loads `SKILL.md` folders, and their scripts
need only Python 3.8+ and Git.

## The skills

- [`level-up`](skills/level-up/SKILL.md) — chain `hill-climb`, `red-pen`,
  `prune-tests`, `zoom-out`, and installed language/domain quality skills into
  repeatable level-up rounds.
- [`hill-climb`](skills/hill-climb/SKILL.md) — assess quality or improve a
  codebase, crate, or docs set to a target score.
- [`red-pen`](skills/red-pen/SKILL.md) — review a product or tool for
  overbuilding and recommend what to keep, simplify, or remove.
- [`zoom-out`](skills/zoom-out/SKILL.md) — find and fix narrow fixes and
  workarounds at the constraint they bend around, in triage, change review,
  or an audit.
- [`take-stock`](skills/take-stock/SKILL.md) — audit what a project holds,
  what's stale, and what depends on it before deciding what to change.
- [`repo-sweep`](skills/repo-sweep/SKILL.md) — make one mechanical change
  across many repositories, one PR each.
- [`milestone-qa`](skills/milestone-qa/SKILL.md) — run and qualify
  milestone QA against a pinned default-branch SHA from an isolated checkout.
- [`prune-tests`](skills/prune-tests/SKILL.md) — keep only tests anchored to
  intended behaviour.
- [`atlas`](skills/atlas/SKILL.md) — step back and shape a project's
  long-horizon direction.
- [`northstar-docs`](skills/northstar-docs/SKILL.md) — a lightweight, static
  documentation structure with one owning file per fact, plus link and
  changelog-fragment checks.

## Install

Install with the [`skills` CLI](https://skills.sh):

```bash
npx skills add inflatable-cookie/northstar
```

This walks you through picking which skills to install, which harnesses to
wire them into, and whether to install globally or in the current project.

Useful flags:

```bash
# Install a single skill globally
npx skills add inflatable-cookie/northstar --skill red-pen -g

# List available skills without installing
npx skills add inflatable-cookie/northstar --list

# Update installed skills later
npx skills update
```

Without `npx`, copy any folder from `skills/` into `~/.agents/skills/` (or
your harness's skills directory).

## Harness snippet

[`harness/snippet.md`](harness/snippet.md) is opt-in guidance on writing
style and work rhythm. It's a global instructions snippet rather than a skill
because agents need it in context from the first message — copy it into your
harness's global instructions file (`~/.claude/CLAUDE.md`,
`~/.codex/AGENTS.md`, or equivalent).

## More

- [Documentation](docs/README.md) — entry point to the repository docs
- [Vision](docs/knowledge/vision.md) — why Northstar exists and what belongs
- [Architecture](docs/knowledge/architecture.md) — how the repository and
  skills are structured
- [Changelog](CHANGELOG.md) — release history

## License

See [LICENSE](LICENSE).
