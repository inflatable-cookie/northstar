# Adoption Modes

This skill supports three modes, but only one fallback.

## 1. Native Surface

Use this mode when the installed Effigy supports consumer-side docs and release
features such as:

- `effigy docs ...` commands
- consumer-side docs policy configuration
- consumer-side release configuration

In this mode:

- prefer native `effigy docs` validation commands in `effigy.toml`
- prefer native release posture in `effigy.toml`
- keep repo-owned scripts only for checks that are still genuinely repo-specific

This is the default target for current adoption work.

## 2. Compatibility Mode

Use this mode only when the installed Effigy cannot yet support those
consumer-side features or the wrong binary is first on `PATH`.

In this mode:

- keep the Effigy-first operator loop
- expose repo-owned validation scripts through `qa:docs` and `qa:northstar`
- keep release readiness explicit through changelog plus QA until native release
  support is available

## 3. Workspace Container + Docs Authority Repo

Use this mode when the workspace root mainly orchestrates child repos and one
nested repo is already the documentation authority.

In this mode:

- keep the workspace root focused on orchestration guidance and routing
- put the real Northstar docs skeleton, `qa:docs`, `qa:northstar`, and docs
  policy in the nested docs-authority repo
- route the workspace root through that nested repo's `qa` surface instead of
  duplicating the docs contract at the top level
- add release posture only where a repo is actually releasable
- treat a docs-only authority repo as a planning/control surface, not as a
  fake release target

Use [`workspace-container-example.md`](./workspace-container-example.md) as the
concrete specimen for this mode.

## Selection Rule

First decide whether the repo is a single repo or a workspace container. Then
pick native or compatibility behavior for the repo that actually owns the docs
contract. If the installed Effigy rejects the manifest keys or command family
you need, switch to compatibility mode rather than leaving a broken repo state.

Native is preferred. Compatibility is a fallback, not a peer default.

## PATH Check

Before choosing native mode, verify that `effigy` on `PATH` is actually the
current binary you expect:

```sh
effigy docs --help
effigy release --help
```

If those command families do not resolve, either:

- fix `PATH` so the intended Effigy binary is first, or
- use compatibility mode until the correct binary is the default

Also verify the nested shell environment used by Effigy task execution, not
just the parent interactive shell. A workspace root can resolve the right
binary while task-spawned `effigy ...` calls still hit an older installation if
`PATH` ordering differs inside subprocesses.
