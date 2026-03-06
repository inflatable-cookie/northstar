# AGENTS

Scope: whole `northstar/` repository.

## Hard Rules

- Treat this repo as the authority for the reusable Northstar documentation system.
- Keep `template-bundle/` lean and copy-ready; do not add project-specific examples outside clearly marked templates.
- Keep `bundle-docs/` focused on doctrine, migration guidance, and maintenance policy for the bundle itself.
- Prefer clean migrations and direct reference updates over compatibility shims.
- Keep AGENTS content lean: scope, hard rules, validation, links.

## Effigy-First Execution

- Start with `effigy tasks --repo .`.
- Run `effigy doctor --repo .` when task discovery or environment state is uncertain.
- Prefer `effigy health --repo .` for the default baseline.
- Prefer `effigy validate --repo .` before publishing bundle or doctrine changes.
- Fall back to raw shell commands only when Effigy does not yet cover the needed repo operation.

## Validate

- `effigy health --repo .`
- `effigy validate --repo .`

## References

- `README.md`
- `bundle-docs/README.md`
- `template-bundle/README.md`
- `bundle-docs/sweeps/README.md`
