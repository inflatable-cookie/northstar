# AGENTS

Scope: whole `northstar/` repository.

## Hard Rules

- Treat this repo as the authority for the reusable Northstar documentation system.
- Keep `template-bundle/` lean and copy-ready; do not add project-specific examples outside clearly marked templates.
- Keep `bundle-docs/` focused on doctrine, migration guidance, and maintenance policy for the bundle itself.
- Prefer clean migrations and direct reference updates over compatibility shims.
- Keep AGENTS content lean: scope, hard rules, validation, links.

## Effigy-First Execution

- Start with `effigy tasks`.
- Run `effigy doctor` when task discovery or environment state is uncertain.
- Prefer `effigy qa` for the default validation baseline.
- Use `--repo <PATH>` only when intentionally targeting a different repo.
- Fall back to raw shell commands only when Effigy does not yet cover the needed repo operation.
- Do not add `package.json` scripts that re-export Effigy tasks; run
  `effigy <task>` directly and keep package scripts package-native.

For first-time local bring-up from outside this repo:
- use `effigy bootstrap git@github.com:inflatable-cookie/northstar.git`

## Validate

- `effigy qa`
- `effigy qa:docs`

## References

- `README.md`
- `docs/README.md`
- `bundle-docs/README.md`
- `template-bundle/README.md`
- `bundle-docs/sweeps/README.md`
- `skills/northstar-setup/SKILL.md`

## Internal Writing Style

Use the repo-local style reference for internal work and normal replies:

- `docs/policy/internal-writing-style.md`

<!-- BEGIN EFFIGY AGENT CONTRACT -->
## Effigy Agent Contract

Use Effigy as the default command surface for supported project work.

Default entry sequence:
1. Run `effigy doctor`.
2. Run `effigy tasks`.
3. Run `effigy test --plan`.

Use `effigy graph` when the job is code understanding: ownership, flow,
implementation, or changed-file impact. Do not insert graph into unrelated
deployment, state, docs, release, or direct task-execution work.

Prefer `effigy <task>`, `effigy test`, and the matching built-in surface over
raw package-manager or shell commands when Effigy covers the path. Use
`effigy --json <command>` whenever another agent or tool will consume output.

This repo's local `.agents/skills/effigy` copy is authoritative for this
project. When an agent supports both project-local and global skills, prefer
the project-local copy over any globally installed Effigy skill.

Do not add `--repo .` while already inside the target repo. Do not edit
`.github/workflows/` or run release mutations unless the user explicitly asks.

Reference docs:
- Effigy agent adoption: `docs/guides/047-agent-and-cross-repo-adoption.md`
- Graph workflows: `docs/guides/076-code-graph-and-agent-workflows.md`
- JSON contracts: `docs/guides/017-json-output-contracts.md`
<!-- END EFFIGY AGENT CONTRACT -->
