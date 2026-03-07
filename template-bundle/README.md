# Template Bundle

This directory is the product artifact.

The folders here are intended to be copied into a target project's `docs/` directory.

## Core structure

- `vision/`
- `architecture/`
- `contracts/`
- `roadmaps/`
- `logs/`

## Optional add-on folders

Create these only if the project actually needs them.
Delete unused add-ons after copying the bundle.
`research/` ships as a starter pack because the workflow benefits from concrete templates.

- `research/`
- `schemas/`
- `templates/`
- `diagrams/`
- `specs/`

`templates/` here means top-level `docs/templates/`.
Section-local template folders such as `docs/roadmaps/templates/`, `docs/logs/templates/`, and `docs/research/templates/` remain part of the core bundle when those sections exist.

## Folder policy

- Keep `roadmaps/backlog/` as the only backlog pattern.
- Prefer decision logs over a separate `decisions/` folder.
- Keep research comparative, source-backed, and separate from architecture/roadmaps until translation memos are explicit.
- Enforce clean migrations: no compatibility shim files in deprecated folders; update references and remove legacy files in the same batch.
- Treat per-project `meta/` docs as deprecated; extract useful content and link to Northstar docs.

Examples should be seeded inside the relevant section content rather than in a separate top-level examples directory.

## Operating posture

Northstar defaults to lean governance:
- batch-based logging, not per-task logging
- problem-led research, not collection-building for its own sake
- manual-first evidence, automation only when recurring pain justifies it
- clear active queue + backlog separation to prevent roadmap sprawl
