# Architecture

Northstar is a repository of skills plus one harness snippet. Each skill is a
folder under `skills/` with a `SKILL.md`. Standalone skills do not depend on
one another; composite skills such as `level-up` compose standalone skills when
installed.

## Repository shape

| Surface | Purpose |
| --- | --- |
| `skills/<skill>/` | One installable skill each |
| `harness/snippet.md` | Opt-in guidance for a harness's global instructions file |
| `scripts/` | Repository checks, such as installed-copy parity |
| `docs/knowledge/` | Northstar's own knowledge, in the `northstar-docs` shape |
| `changelog.d/` | Unreleased changes as fragments |

## The skills

Workflow skills are self-contained `SKILL.md` files, except where one has
separate modes: `pr-etiquette` keeps its review and reply guidance in
`references/`, so each job loads only its own part. The docs skill also
ships references, a copy-ready starter and scripts with self-tests.

A skill's description loads in every session, so it stays short and names
only what triggers the skill.

Skill scripts are dependency-free Python 3.8+. A skill may carry an
`effigy.toml` catalog so Effigy users can run its scripts as
`effigy skill run <skill>/<task>`; nothing requires Effigy.

## Installed copies

Global installs via `npx skills add -g` place copies under
`~/.agents/skills/<skill>` and link each harness's skill folder to them. See
[contracts/release.md](contracts/release.md).
