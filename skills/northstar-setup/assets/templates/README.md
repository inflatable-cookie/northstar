# Template Selection

Use the Northstar `template-bundle/` for the docs skeleton.

Use native Effigy templates by default. Reach for the compatibility template
only when the installed binary really cannot support the docs or release
surface the repo needs.

Use these top-level repo templates from this skill for the non-docs surfaces:

- `AGENTS.md`
- `CHANGELOG.md`
- `README.md.template`
- `docs.README.md.template`
- `effigy.native.toml.template`
- `effigy.compat.toml.template`

Template rule:

- single repo or docs-authority repo: use the full template set
- thin workspace root: use only the orchestration parts you need; do not copy
  `CHANGELOG.md`, release config, or full docs-policy blocks there unless that
  root is actually the repo that owns them

Choose the Effigy template by installed surface:

- native mode:
  `effigy docs --help` and `effigy release --help` both resolve and the repo
  can rely on consumer-side `docs_policy` / release config
- compatibility mode:
  either command family is missing, manifest support is absent, or the wrong
  binary is first on `PATH`

Native template note:

- `effigy.native.toml.template` now carries the starter
  `[docs_policy.indexes.vision]` and `[docs_policy.next_actions.vision]`
  blocks plus a task-composed `qa:northstar` bundle with root/front-door/
  docs-spine drift checks
- that starter assumes the repo also creates
  `docs/policy/vision-next-task-verbs.txt`
- `README.md.template` and `docs.README.md.template` provide the front-door
  links that the starter `qa:northstar` bundle now validates

Boundary rule:

- this skill/template layer decides repo shape and starter files
- Effigy provides the reusable validators and release/runtime surfaces

Also confirm task-spawned subprocesses resolve the same `effigy` binary as the
interactive shell before you rely on native nested `effigy ...` task commands.
