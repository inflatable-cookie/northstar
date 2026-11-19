# Release

A release is an annotated Git tag, `v<x.y.z>`, on a `main` commit whose
`VERSION` and `CHANGELOG.md` name that version. Versions follow semantic
versioning. Northstar has no CI and nothing to publish, so it doesn't use
Effigy's release pipeline. Between releases, skills install from `main`.

Northstar records unreleased changes as changelog fragments; the convention
and adoption steps are the skill's
([references/adopt.md](../../../skills/northstar-docs/references/adopt.md)). Each
change adds one file under `changelog.d/` and `[Unreleased]` stays empty.
`effigy qa:docs` runs `check:changelog`, which fails on malformed fragments
and on direct edits to `[Unreleased]`.

Before 1.0, a breaking change updates its callers and removes the superseded
surface in the same change; no shims or aliases. After 1.0, stable
user-visible contracts are preserved by default.

## Steps

1. Merge to `main` with `effigy qa` passing.
2. In a release PR, set `VERSION` and fold the changelog:
   `effigy changelog:fold --version <x.y.z> --date <YYYY-MM-DD>`, committing
   `CHANGELOG.md` together with the removed fragments.
3. After it merges, tag the merge commit and push the tag:
   `git tag -a v<x.y.z> -m "Northstar <x.y.z>"`, then
   `git push origin v<x.y.z>`. Create a GitHub release from the tag with the
   version's changelog section as its notes.
4. Sync the installed copies:
   `rsync -a --delete skills/<skill>/ ~/.agents/skills/<skill>/` for each
   skill. Other harness skill locations may link to them.

## Verify

- `effigy check:skill-install` reports exact parity for every skill.
- `effigy skill run northstar-docs/check-links` succeeds from a consumer
  repository.
- `effigy check:changelog` passes on a fresh checkout.

## Roll back

Check out the previous tag's `skills/` and sync again. Never move a
published tag; a fix ships as the next patch.
