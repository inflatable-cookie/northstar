# Architecture

**Type: REQUIRED** -- Every Northstar project needs this folder.

Architecture docs define the system shape and invariants derived from vision.
They set the realized constraints roadmap batches must honor.

## Files

- `system-architecture.md`
- `system-inventory.md`
- `repo-authority-map.md`
- `product-guardrails.md`
- `example-system-architecture.md`
- `example-system-inventory.md`
- `example-repo-authority-map.md`
- `docs/contracts/001-<slug>.md` and `docs/contracts/00n-<slug>.md`

## Writing rules

- Link architecture updates to current vision artifact(s).
- Promote durable structural decisions out of specs into architecture before
  roadmap execution relies on them.
- Keep `system-inventory.md` current so roadmap work only starts against
  explicitly planned system elements.
- Use `repo-authority-map.md` whenever more than one repo or authoritative
  deployable surface is in play.
- Keep milestone execution lists in roadmap files, not architecture files.
- Use contract docs for explicit technical boundaries that need validation and migration notes.
