# AGENTS

Scope: whole `northstar/` repository.

## Hard Rules

- Treat this repo as the authority for the reusable Northstar documentation system.
- Keep `template-bundle/` lean and copy-ready; do not add project-specific examples outside clearly marked templates.
- Keep `bundle-docs/` focused on doctrine, migration guidance, and maintenance policy for the bundle itself.
- Prefer clean migrations and direct reference updates over compatibility shims.
- Keep AGENTS content lean: scope, hard rules, validation, links.

## Effigy-First Execution

- Start with `effigy tasks`.
- Run `effigy doctor` when task discovery or environment state is uncertain.
- Prefer `effigy qa` for the default validation baseline.
- Use `--repo <PATH>` only when intentionally targeting a different repo.
- Fall back to raw shell commands only when Effigy does not yet cover the needed repo operation.

## Validate

- `effigy qa`
- `effigy qa:docs`

## References

- `README.md`
- `bundle-docs/README.md`
- `template-bundle/README.md`
- `bundle-docs/sweeps/README.md`
- `skills/northstar-effigy/SKILL.md`
