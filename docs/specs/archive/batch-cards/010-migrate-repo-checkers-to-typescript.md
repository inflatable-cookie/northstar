# 010 - Migrate Repo Checkers To TypeScript

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/002-automation-runtime-policy.md
Roadmap refs: g01.002 batch 2.2
Governing refs: docs/contracts/001-working-rules.md, effigy.toml, scripts/README.md
Auto-start next card: no

## Objective

Apply the automation runtime policy to Northstar itself by migrating the main
repo checker scripts to TypeScript run with Bun and updating the Effigy tasks
that own them.

## Scope

- replace the Bash checker scripts with TypeScript+Bun equivalents
- update Effigy task wiring
- tighten repo checks around the runtime policy
- sync the updated setup skill into Codex and Claude
- validate and log the batch

## Steps

1. Build a shared TypeScript checker utility for repo assertions.
2. Port the bundle and repo-contract checkers from Bash to TypeScript.
3. Update `effigy.toml` and repo checks to enforce the new runtime policy.
4. Sync the updated `northstar-setup` skill into the installed homes.
5. Run validation, update roadmap/spec state, and write the batch log.

## Acceptance Criteria

- the main checker scripts run via `bun`
- no Bash version of the migrated checkers remains in the live repo path
- repo docs and checks reflect the runtime policy
- Codex and Claude have the updated `northstar-setup` skill installed
- `effigy qa`
- `effigy qa:docs`

## Evidence Required

- new TypeScript checker files under `scripts/`
- updated `effigy.toml`
- synced skill installs in both tool homes
- validation commands recorded in the batch log

## Stop Conditions

- the migrated checker logic becomes less readable than the shell it replaces
- the repo ends up with parallel Bash and TypeScript checkers for the same task
- the migration weakens the Effigy-first maintenance loop

## Completion Notes

The live checker lane now runs through Bun-executed TypeScript and the Bash
versions have been removed. The updated `northstar-setup` skill has also been
synced into both installed homes, so the policy is now real in both the repo
and the install surface.

## Next Task

Compile the next live milestone around ready-state and closeout mechanics.
