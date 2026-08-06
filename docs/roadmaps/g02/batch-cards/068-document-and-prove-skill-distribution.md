# 068 - Document And Prove Skill Distribution

Status: complete
Owner: repo maintainers
Updated: 2026-08-06
Master spec refs: `docs/specs/025-skill-distribution-and-consumer-papercut-proof.md`
Governing refs: `bundle-docs/skills/README.md`, `scripts/README.md`
Auto-start next card: no

## Objective

Make published skill propagation canonical and provide a deterministic source
checkout parity check for one installed `northstar` skill folder.

## Scope

- document Skills CLI update and inspection commands
- separate local development sync from published propagation
- compare source and installed skill trees without network access
- add source QA coverage

## Acceptance criteria

- `npx skills update northstar -g -y` is documented
- `npx skills list -g --json` is documented
- the parity checker reports missing, unexpected, or differing files
- the current global install matches the source tree

## Evidence

- `scripts/check-northstar-skill-install.rhai`
- `effigy check:skill-install /Users/tom/.agents/skills/northstar`
- `effigy qa:docs`

## Closeout

Published and local-development paths are explicit. The checker remains a
source-repository tool rather than an installed skill dependency.
