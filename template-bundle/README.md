# Template Bundle

This directory is the product artifact.

The folders here are intended to be copied into a target project's `docs/` directory.

## Core structure

- `vision/`
- `architecture/`
- `contracts/`
- `roadmaps/`
- `logs/`

## Optional add-on folders (not included by default)

Create these only if the project actually needs them:

- `schemas/`
- `templates/`
- `diagrams/`
- `specs/`

`templates/` here means top-level `docs/templates/`.
Section-local template folders such as `docs/roadmaps/templates/` and `docs/logs/templates/` remain part of the core bundle.

## Folder policy

- Keep `roadmaps/backlog/` as the only backlog pattern.
- Prefer decision logs over a separate `decisions/` folder.
- Enforce clean migrations: no compatibility shim files in deprecated folders; update references and remove legacy files in the same batch.
- Treat per-project `meta/` docs as deprecated; extract useful content and link to Northstar docs.

Examples should be seeded inside the relevant section content rather than in a separate top-level examples directory.

## Operating posture

Northstar defaults to lean governance:
- batch-based logging, not per-task logging
- manual-first evidence, automation only when recurring pain justifies it
- clear active queue + backlog separation to prevent roadmap sprawl
