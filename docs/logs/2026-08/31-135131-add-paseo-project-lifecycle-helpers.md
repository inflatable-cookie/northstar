# Add Paseo Project Lifecycle Helpers

Date: 2026-08-31
Status: complete
Governing refs: `docs/architecture/system-architecture.md`,
`skills/northstar/references/setup/paseo-project.md`

## Result

Northstar now ships an optional copy-ready `paseo.json` and an Effigy-backed
worktree lifecycle helper. Northstar also dogfoods the adapter at its project
root with `qa` and docs scripts plus short metadata-generation guidance.

The setup path prepares sibling repos, runs project bootstrap, then replays
machine-local Cargo or Bun links recorded by `effigy deps link` in the primary
checkout. Extra sibling repos can be named relative to the primary checkout.
Preparation creates absent symlinks, reuses exact matches, and stops on any
conflict. Teardown unlinks worktree-local Effigy state and retains sibling
symlinks that other Paseo worktrees may share.

The adapter remains optional. Repositories own their bootstrap command, Paseo
scripts, and branch/commit/PR guidance; the starter does not create new planning
or merge authority.

## Validation

- `jq empty paseo.json skills/northstar/assets/templates/paseo.json.template`
  — pass;
- `effigy test:paseo-worktree` — pass, including primary discovery,
  create/reuse, and conflict refusal;
- skill-creator `quick_validate.py skills/northstar` — pass;
- `git diff --check` — pass;
- `effigy qa` — pass.

## Next

Dogfood the helper in a consumer with live Cargo and Bun link ledgers and two
concurrent Paseo worktrees. Keep changes evidence-led; do not add automatic
sibling-symlink deletion unless shared-worktree ownership can be proven.
