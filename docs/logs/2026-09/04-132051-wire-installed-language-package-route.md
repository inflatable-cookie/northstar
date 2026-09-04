# Wire the installed language-package route

Date: 2026-09-04
Status: complete

## Change

Removing the former Rust and TypeScript quality skills exposed a real runtime
gap: Northstar could describe and verify package acquisition, but its public
installed-skill surface could not acquire the official Git pins or return a
workflow entrypoint.

The installed skill now exposes `northstar/language:route`. It selects the
official registry entry from explicit workflow intent or an exact activation
marker, fetches the immutable Git commit when needed, verifies the declared
tree and manifest identities, activates it in durable operator-owned state,
and returns the verified `entrypoint_path`. Existing installs route without a
network fetch. Consumer repositories remain unchanged.

The default state root is `$XDG_DATA_HOME/northstar/language-packages`, or
`~/.local/share/northstar/language-packages` when XDG data is unset. An
environment variable and CLI flag provide explicit overrides.

## Evidence

- The two-package route oracle exercises the public installed-skill Effigy
  task against both official package identities.
- It proves independent durable selection and exact `AGENTS.md` marker routing.
- Repo-contract wiring now fixes both source and installed task declarations.
- Operator, router, contract, architecture, and package docs name the same
  command, state root, acquisition boundary, and returned entrypoint.

## Validation

- `python3 /Users/tom/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/northstar` — passed.
- `effigy check:repo-contract-wiring` — passed.
- `effigy check:language-packages` — passed.
- `effigy check:language-package-routes` — passed, including both public
  installed-skill acquisitions and offline marker rerouting.
- `effigy qa:docs` — passed.
- `effigy qa` — passed.
- `git diff --check` — passed.

## State

The removed top-level language skills are no longer required. Language policy
stays outside core; Northstar owns only generic selection, secure acquisition,
durable lifecycle state, and routing to the package-owned entrypoint.
