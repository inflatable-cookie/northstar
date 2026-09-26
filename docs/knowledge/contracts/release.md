# Release

Northstar has no tagged releases yet. It ships by installing `skills/northstar/`
from `main` onto the operator's machine, where every project resolves it
through `paseo.json` worktree setup (`paseo:worktree`). A broken install breaks worker worktrees across the
portfolio, so install only from a `main` that passed `effigy qa`.

`VERSION` stays at `0.1.0` and `CHANGELOG.md` records notable changes under
`Unreleased` until the first tagged release. Tagging needs Tom's decision on
versioning.

Before 1.0, a breaking change updates its callers and removes the superseded
surface in the same change; no shims or aliases. After 1.0, stable
user-visible contracts are preserved by default.

## Steps

1. Merge to `main` with `effigy qa` passing.
2. Sync the installed copy:
   `rsync -a --delete skills/northstar/ ~/.agents/skills/northstar/`.
   `~/.claude/skills/northstar` and `~/.pi/agent/skills/northstar` are symlinks
   to it.
3. Add a `CHANGELOG.md` entry for anything a consumer notices.

## Verify

- `effigy check:skill-install ~/.agents/skills/northstar` reports exact parity.
- `effigy skill run northstar/retired-concepts` and
  `effigy skill run northstar/paseo:worktree -- self-test` run from a consumer
  repository.

## Roll back

- Check out the previous `main` commit's `skills/northstar/` and sync it again.
