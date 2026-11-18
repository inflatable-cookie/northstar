# Architecture

Northstar is a repository of independent skills plus one harness snippet.
Each skill is a folder under `skills/` with a `SKILL.md`; none depends on
another.

## Repository shape

| Surface | Purpose |
| --- | --- |
| `skills/<skill>/` | One installable skill each |
| `harness/snippet.md` | Opt-in guidance for a harness's global instructions file |
| `scripts/` | Repository checks, such as installed-copy parity |
| `docs/knowledge/` | Northstar's own knowledge, in the `northstar-docs` shape |
| `changelog.d/` | Unreleased changes as fragments |

## The skills

| Skill | Shape |
| --- | --- |
| `hill-climb` | `SKILL.md` only |
| `take-stock` | `SKILL.md` only; read-only |
| `fleet-sweep` | `SKILL.md` only |
| `prune-tests` | `SKILL.md` only |
| `atlas` | `SKILL.md` only |
| `northstar-docs` | `SKILL.md`, `references/` (adopt, knowledge, review), `template/` (the copy-ready starter) and `scripts/` (`check-links.py`, `changelog.py`, each with a self-test) |

Skill scripts are dependency-free Python 3.8+. A skill may carry an
`effigy.toml` catalog so Effigy users can run its scripts as
`effigy skill run <skill>/<task>`; nothing requires Effigy.

`hill-climb` keeps its scorecard in the project's planning surface. `atlas`
records direction into the knowledge files today; its planned rewrite makes
`northstar-docs` optional (see [vision.md](vision.md)).

## Installed copies

Installed copies live under `~/.agents/skills/<skill>`, and harness skill
folders link to them. See [contracts/release.md](contracts/release.md).
