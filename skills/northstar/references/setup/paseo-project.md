# Paseo project setup

Use this optional adapter when a Northstar repo is registered as a Paseo
project. Paseo owns `paseo.json`; Northstar supplies copy-ready defaults and a
safe worktree helper. Merge with an existing file instead of replacing project
settings.

## Prerequisites

The helper targets Paseo's Unix-host worktree flow and needs an Effigy build
with `deps link` plus the Rhai `fs::create_symlink` and `effigy::run_json`
surfaces. Check before installing it:

```sh
effigy deps --help
effigy rhai surface --json
```

If those surfaces are missing, update Effigy or keep explicit project-specific
Paseo hooks. Do not install a lifecycle command that the active binary cannot
run.

## Install

Copy:

- `assets/templates/paseo.json.template` to project-root `paseo.json`;
- `assets/templates/scripts/paseo-worktree.rhai` to
  `scripts/paseo-worktree.rhai`.

Add the local Effigy task:

```toml
[tasks]
"paseo:worktree" = [{ rhai = "scripts/paseo-worktree.rhai" }]
```

The default lifecycle is:

```text
prepare siblings -> project bootstrap -> replay Effigy links
unlink Effigy links -> Paseo removes the worktree
```

Keep those phases in that order. Replace `effigy bootstrap` with the repo's
real setup command when bootstrap does not own dependency installation. Bun
links must be replayed after install because installs can replace them.

## Sibling repos

`prepare` reads the primary checkout's ignored
`.effigy/local/dependency-links.json`. For every library previously selected by
`effigy deps link`, it creates a same-named symlink beside the Paseo worktree.
It reuses an already-correct symlink and stops on a mismatched symlink, file, or
directory. It never deletes or replaces an existing path.

Add repos that are not in the Effigy ledger as arguments. Relative paths are
resolved from the primary checkout, not the generated worktree:

```json
{
  "worktree": {
    "setup": "effigy paseo:worktree prepare ../signal ../poodle=ui-kit && effigy bootstrap && effigy paseo:worktree link",
    "teardown": "effigy paseo:worktree unlink"
  }
}
```

Use `SOURCE=LINK` only when the desired sibling name differs from the source
checkout basename. Keep machine-specific absolute paths out of tracked
`paseo.json`; prefer stable paths relative to the primary checkout.

`link` replays the primary checkout's Cargo and Bun Effigy links in the new
worktree. `unlink` releases only links recorded in that worktree before Paseo
archives it. Sibling symlinks are deliberately retained because several Paseo
worktrees may share their parent directory. Remove stale links manually only
after confirming no workspace uses them.

## Other project settings

The starter exposes `effigy qa` and `effigy qa:docs` as Paseo scripts and gives
metadata generation short Northstar-shaped defaults. Rename, add, or remove
scripts freely. Service scripts can use `$PASEO_PORT` and a declared fallback
port. Rewrite metadata instructions to match the repository's real branch,
commit, and pull-request contract; the starter wording is not a global
Northstar convention.

Review every lifecycle command before committing it. Paseo runs these commands
on the host when it creates or removes a managed worktree.
