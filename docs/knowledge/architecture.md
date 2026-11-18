# Architecture

Northstar consists of an installable skill and a copy-ready documentation
starter. The skill source is `skills/northstar/` in this repository.

## Repository shape

| Surface | Purpose |
| --- | --- |
| `AGENTS.md` | Project orientation, documentation map, guardrails and validation command |
| `docs/README.md` | Current state in a page, linked to topic owners |
| `docs/knowledge/` | Current truth, with one owner per topic |
| `docs/knowledge/retired.toml` | Retired concepts, paths and configuration keys |

Product documentation remains where its readers expect it and is linked from
the knowledge index. Detailed design and evidence that current knowledge
relies on remain available. The project's task system owns task state and
workflow; the documentation structure does not prescribe one.

## The skill

`skills/northstar/` contains:

- `SKILL.md`: knowledge structure and maintenance guidance.
- `references/`: adoption, review, knowledge and optional module guidance.
- `template/`: a generic starter for another repository.
- `scripts/`: retired-concept and link checks, changelog fragment folding
  and checks, plus migration tooling. Dependency-free Python 3.8+; the skill's
  Effigy catalog (`northstar`) wraps them for projects that use Effigy.

`skills/atlas/` is a standalone skill for long-horizon direction with the
operator. It records into the knowledge files and leaves planning to the
project's own system.

Installed copies live under `~/.agents/skills/`. Harness skill
folders may link to it. See [contracts/release.md](contracts/release.md).

## Knowledge mechanisms

1. Retired concepts record what no longer applies and are checked against live
   code, configuration and documentation.
