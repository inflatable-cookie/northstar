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
   `effigy changelog:fold --version <x.y.z> --date <YYYY-MM-DD>`. Commit
   `VERSION`, `CHANGELOG.md` and the removed fragments together.
3. On the merged `main` commit, verify that `VERSION` and the new changelog
   heading agree. Tag that commit and push the tag:
   `git tag -a v<x.y.z> <verified-commit> -m "Northstar <x.y.z>"`, then
   `git push origin v<x.y.z>`. Create a GitHub release from the tag with the
   version's changelog section as its notes.
4. From a checkout of the new tag, sync the skills you use with the
   [guarded install procedure](../../../README.md#install). Remove Northstar
   copies and harness links for skills retired by the release. Preserve
   unrelated installs.

## Verify

- For an installation of the full stack, `effigy check:skill-install`
  verifies shared-copy file contents, executable bits and symlinks within
  each skill. It skips `.effigy/` scratch directories. Check separately
  that any harness links resolve to the intended copies.
- `effigy skill run northstar-docs/check-links` succeeds from a consumer
  repository.
- `effigy check:changelog` passes on a fresh checkout.

## Roll back

From a checkout of the previous tag, use the same guarded install procedure.
Remove copies and harness links for Northstar skills introduced after that
tag, and restore any retired skills you still use. Never move a published
tag. A fix ships as the next patch.
