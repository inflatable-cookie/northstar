# Refresh TypeScript Package Canary Readiness

Date: 2026-09-02
Roadmap: `g02.048`
Card: `g02.048/118`
Result: ready; external execution not started

## Outcome

PR 22 merged card 117's generic package lifecycle at `75db6f5`. A strict
readiness review then settled card 118's two missing operator choices:

- use one public shared source repository,
  `inflatable-cookie/northstar-language-packs`;
- use Jetstream as the first real-consumer canary.

The first package is `@northstar/typescript-quality` `0.1.0` at
`packages/typescript`, compatible with core `>=0.2.0 <1.0.0`. It exposes only
`explicit_audit_repair` and owns the `base`, `svelte`, and `sveltekit` overlays.

## Inventory

The embedded extraction boundary is 17 files: three templates, the command
skill and agent metadata, eight reference files, one mode, and three Rhai
scripts. Their aggregate source-list digest is
`7e3ff26cd9319743fee5b0433d79b0cea6515347aa5780f68f2fcbb6eb664d26`.
The prior 93-file parity number describes the whole installed Northstar skill;
it is not the extraction inventory.

The initial external package is 20 files: those 17 relocated surfaces plus
`northstar-package.json`, package-local `effigy.toml`, and executable
`scripts/self-check.sh`. Effigy and `sh` are declared package capabilities.
Package Rhai resolves assets from the task-source/catalog context while
`repo_root` remains the consumer target.

## Consumer Canary

Jetstream was clean at `ab6d2e6c82b54732c6bea4a61569c14a2a9a2991`.
Its TypeScript profile digest was
`9fcb6b8dd99ce09864a725a71167d63323cb495551e6e76f5c89dcf9113b2c7b`
and its empty deviations digest was
`131c912ee29ebf7811fcd3773b6575ee3f3aa62b87ae477a4985844d8572d445`.
It owns one independent `editor-ui` package and resolves `base` plus `svelte`.
The previous ignored audit ledger is absent, so card 118 requires a fresh
installed-package audit.

## Sequencing

The card is ready but serial:

1. create the shared public repository and deliver the package source PR;
2. merge an accepted immutable source candidate;
3. pin and route that candidate from Northstar;
4. merge the accepted registry/routing PR;
5. run and review the fresh Jetstream canary;
6. reconcile the overlap and stop before Rust extraction.

Repository creation, publication, registry merge, and consumer merge remain
orchestrator-owned. This planning batch performed none of those mutations and
dispatched no worker.

## Validation

- `effigy check:typescript-quality` passed during readiness inventory;
- `effigy qa:docs` passed on the final planning tree;
- `effigy qa` passed on the final planning tree;
- `git diff --check` was clean.

## Next Move

Create the public shared source repository, install its Northstar/Paseo project
surfaces, then dispatch only card 118's package-source worker.
