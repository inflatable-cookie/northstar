# Template Selection

Use the Northstar `template-bundle/` for the docs skeleton.

Use these top-level repo templates from this skill for the non-docs surfaces:

- `AGENTS.md`
- `CHANGELOG.md`
- `effigy.native.toml.template`
- `effigy.compat.toml.template`

Template rule:

- single repo or docs-authority repo: use the full template set
- thin workspace root: use only the orchestration parts you need; do not copy
  `CHANGELOG.md`, release config, or full docs-policy blocks there unless that
  root is actually the repo that owns them

Choose the Effigy template by installed surface:

- native mode:
  `effigy docs --help` and `effigy release --help` both resolve
- compatibility mode:
  either command family is missing or the wrong binary is first on `PATH`

Also confirm task-spawned subprocesses resolve the same `effigy` binary as the
interactive shell before you rely on native nested `effigy ...` task commands.
