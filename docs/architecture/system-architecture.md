# System Architecture

Status: active
Owner: repo maintainers
Updated: 2026-04-08
Vision refs: docs/vision/001-northstar-delivery-vision.md

## Top-Level Stack

- `bundle-docs/`
  is the doctrine authority for how Northstar is supposed to work
- `template-bundle/`
  is the copy-ready product artifact that downstream repos adopt
- `skills/`
  is the installable behavior surface for agent workflows
- `docs/`
  is the live Northstar planning spine for developing this repo itself
- `scripts/` plus `effigy`
  provide repo validation and maintenance checks

## Data and Authority Flow

- Vision in `docs/vision/` sets the destination for Northstar's next evolution.
- Architecture plus a compact working-rules contract define the rules the repo
  should follow while changing itself.
- Specs and batch cards in `docs/specs/` define the detailed path for material
  changes.
- Roadmaps in `docs/roadmaps/` sequence approved work.
- Logs in `docs/logs/` provide batch-level evidence.
- `bundle-docs/`, `template-bundle/`, and `skills/` should be updated from this
  planning spine rather than by ad hoc repo edits.

## Invariants

- `bundle-docs/` remains the doctrine authority for the reusable system.
- `template-bundle/` remains generic and copy-ready; repo-specific planning
  lives in `docs/`, not in the bundle.
- `docs/` is the authority for Northstar's own development process.
- Material delivery work should flow through contracts, master specs, batch
  cards, roadmaps, and logs rather than jumping straight from idea to edits.
- The public skill surface should remain small and deliberately routed.

## Performance and Reliability Constraints

- Operator-facing docs should stay readable and direct.
- The repo should default to manual, concrete evidence before adding more
  automation.
- Validation should stay cheap enough that batch-level checks remain normal.
- Autonomy should increase only when the repo's planning artifacts make it safe.

## Interfaces With Roadmaps

- `g01.001` uses this architecture to enact Northstar on Northstar and pilot
  the delivery layer inside this repo.

## Next Task

Use the autonomy-pilot findings to tighten Northstar's live execution lane so
status updates and closeout become more mechanical before adding more doctrine.
