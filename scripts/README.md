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
