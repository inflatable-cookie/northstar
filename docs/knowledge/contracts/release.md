# Release

Northstar has no tagged releases yet. It ships by installing
`skills/northstar/` from `main` onto the operator's machine. `VERSION` stays at
`0.1.0` and `CHANGELOG.md` records notable changes under `Unreleased` until
the first tagged release. Tagging needs the operator's decision on versioning.

Before 1.0, a breaking change updates its callers and removes the superseded
surface in the same change; no shims or aliases. After 1.0, stable
user-visible contracts are preserved by default.

## Steps

1. Merge to `main` with `effigy qa` passing.
2. Sync the installed copy:
   `rsync -a --delete skills/northstar/ ~/.agents/skills/northstar/`.
   Other harness skill locations may link to it.
3. Add a `CHANGELOG.md` entry for anything a consumer notices.

## Verify

- `effigy check:skill-install ~/.agents/skills/northstar` reports exact parity.
- `effigy skill run northstar/retired-concepts` succeeds from a consumer
  repository.

## Roll back

Check out the previous `main` commit's `skills/northstar/` and sync it again.
