# Specs Archive

**Type: OPTIONAL** -- Create when you have archived specs to preserve.

Use this folder for closed planning artifacts that should be preserved for
traceability but no longer belong in the active `docs/specs/` surface.

Seed this README when closed artifacts exist or up front so the archive path
is explicit from the beginning.

## Rule

- archive only closed or no-longer-governing specs
- keep the active `docs/specs/` surface focused on live planning
- preserve enough surrounding context that the archived artifact is still
  understandable
- do not treat archived specs as canonical execution authority once
  architecture and contracts carry the truth

## Layout

Keep the archive lean. Mirror only the minimum grouping needed for traceability
in the repo, for example:

- `archive/NNN-<slug>.md`

Do not build a second complex planning tree under `archive/`.
