# Release

Northstar has no tagged releases yet. It ships by installing
`skills/northstar/` from `main` onto the operator's machine. `VERSION` stays
at `0.1.0` and unreleased changes wait as fragments in `changelog.d/` until
the first tagged release. Tagging needs the operator's decision on versioning.

Northstar records unreleased changes as changelog fragments; the convention
and adoption steps are the skill's
([references/adopt.md](../../../skills/northstar/references/adopt.md)). Each
change adds one file under `changelog.d/` and `[Unreleased]` stays empty.
`effigy qa:docs` runs `check:changelog`, which fails on malformed fragments
and on direct edits to `[Unreleased]`.

Before 1.0, a breaking change updates its callers and removes the superseded
surface in the same change; no shims or aliases. After 1.0, stable
user-visible contracts are preserved by default.

## Steps

1. Merge to `main` with `effigy qa` passing.
2. Cut the changelog when a version ships:
   `effigy changelog:fold --version <x.y.z> --date <YYYY-MM-DD>`, then commit
   `CHANGELOG.md` together with the removed fragments.
3. Sync the installed copy:
   `rsync -a --delete skills/northstar/ ~/.agents/skills/northstar/`.
   Other harness skill locations may link to it.

## Verify

- `effigy check:skill-install ~/.agents/skills/northstar` reports exact parity.
- `effigy skill run northstar/retired-concepts` succeeds from a consumer
  repository.
- `effigy check:changelog` passes on a fresh checkout.

## Roll back

Check out the previous `main` commit's `skills/northstar/` and sync it again.
