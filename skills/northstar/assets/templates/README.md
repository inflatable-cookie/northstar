# Template Selection

Use the Northstar `template-bundle/` for the docs skeleton.
Choose explicitly between the baseline docs spine and the stricter docs spine;
do not leave the repo in a half-installed middle state.

Use native Effigy templates by default. Reach for the compatibility template
only when the installed binary really cannot support the docs or release
surface the repo needs.

Use these top-level repo templates from this skill for the non-docs surfaces:

- `AGENTS.md`
- `.agents.local.env.example` (tracked path registry example; the real
  `.agents.local.env` is ignored and created only when local paths are needed)
- `CLAUDE.md.template` (optional)
- `PAPERCUTS.md` (seed on adopt/upgrade before exact-SHA / clean-tree release
  prep; do not introduce it during tag closeout after CI is green on a pinned
  SHA)
- `CHANGELOG.md`
- `README.md.template`
- `scripts.README.md.template`
- `docs.README.md.template`
- `effigy.native.toml.template`
- `effigy.compat.toml.template`

For stricter repos, also copy the bundle's working-rules and specs surfaces:

- `docs/contracts/001-working-rules.md`
- `docs/specs/README.md`
- `docs/specs/templates/master-spec-template.md`
- `docs/specs/templates/batch-card-template.md`
- `docs/roadmaps/g01/batch-cards/README.md`
- `docs/policy/internal-writing-style.md`

Template rule:

- single repo or docs-authority repo: use the full template set
- thin workspace root: use only the orchestration parts you need; do not copy
  `CHANGELOG.md`, release config, or full docs-policy blocks there unless that
  root is actually the repo that owns them

For the thin-root plus nested-authority shape, follow
`references/workspace-container-example.md` instead of inventing the split by
memory.

Choose the Effigy template by installed surface:

- native mode:
  `effigy docs --help` and `effigy release --help` both resolve and the repo
  can rely on consumer-side `docs_policy` / release config
- compatibility mode:
  either command family is missing, manifest support is absent, or the wrong
  binary is first on `PATH`

Native template note:

- `effigy.native.toml.template` now carries the starter
  `[docs_policy.indexes.vision]` block plus a task-composed `qa:northstar`
  bundle with root/front-door/docs-spine drift checks
- active generation READMEs carry the `## Generation Runway`; use that coarse
  goal list to steer new milestones after lanes close
- the roadmap front doors keep the live `## Next Task` pointer; non-roadmap
  front doors should summarize state or dependencies without becoming the live
  thread pointer
- `README.md.template` and `docs.README.md.template` provide the front-door
  links that the starter `qa:northstar` bundle now validates

Boundary rule:

- this skill/template layer decides repo shape and starter files
- Effigy provides the reusable validators and release/runtime surfaces
- if a repo still needs custom scripts after that boundary, prefer
  TypeScript+Bun rather than growing a mixed scripting surface

Also confirm task-spawned subprocesses resolve the same `effigy` binary as the
interactive shell before you rely on native nested `effigy ...` task commands.
