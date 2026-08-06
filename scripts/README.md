# Scripts

Place repo-owned helper logic here when Effigy does not already cover the job.

Use Effigy from the repo root for the default maintenance loop:

```bash
effigy tasks
effigy doctor
effigy qa
```

## Runtime Policy

- prefer `effigy` when it already covers the operation
- when repo-owned script logic is still needed, default to `TypeScript` run
  with `bun`
- use `bash` only for thin glue or compatibility boundaries
- use `python` or another runtime only with a concrete technical reason

## Working Rule

Scripts remain implementation detail until the helper flow is stable enough to
expose as a first-class Effigy task.

## Installed skill parity

After a published Northstar skill change, update the configured global install
with the Skills CLI:

```bash
npx skills update northstar -g -y
npx skills list -g --json
effigy check:skill-install /path/to/installed/northstar
```

`npx skills update` follows the configured published source. It cannot see
uncommitted or unpushed changes in this checkout. During local skill
development, a direct sync is appropriate; keep it out of the published
operator path:

```bash
rsync -a --delete skills/northstar/ /path/to/installed/northstar/
```

Restart agent sessions after updating an installed skill so they reload the
new instructions.

The parity checker is an Effigy-native Rhai task. The repo-contract checker and
shared `scripts/lib/checks.ts` stay TypeScript for now because they perform the
largest static contract scan. The smaller bundle and posture checks are
possible future Rhai candidates, but do not need a forced migration in this
batch.

## Repo contract (`qa:docs`)

`check:repo-contract` validates required Northstar surfaces and the installable
skill boundary. Every local Markdown link under `skills/northstar/` must resolve
inside that folder; escaping or missing targets fail QA.

## Posture advisory (`check:posture-advisory`)

Non-blocking checks for common **declared vs actual** drift in Northstar-shaped
`docs/` trees (active generation paths, specs archive surface, empty batch-card
folders). Always exits `0`; warnings print as `[northstar:advisory] …`.

```bash
effigy check:posture-advisory
# or target another repo root:
bun run ./scripts/check-northstar-posture-advisory.ts /path/to/project
bun run ./scripts/check-northstar-posture-advisory.ts --repo /path/to/project
```

Smoke examples (expect one advisory line each):

- point `docs/roadmaps/generation-index.md` at a generation folder that does not
  exist
- add `docs/specs/001-any.md` without `docs/specs/archive/README.md`

This task is **not** part of `effigy qa` / `effigy qa:docs` so baseline repos stay
quiet until operators opt in.
