# Template Bundle

This directory is the product artifact.

The folders here are intended to be copied into a target project's `docs/` directory.

## Core structure

- `vision/`
- `architecture/`
- `roadmaps/`
- `logs/`

## Supported optional folders

- `schemas/`
- `templates/`
- `contracts/`
- `diagrams/`
- `specs/`

## Folder policy

- Keep `roadmaps/backlog/` as the only backlog pattern.
- Prefer decision logs over a separate `decisions/` folder.
- Treat per-project `meta/` docs as deprecated; extract useful content and link to Northstar docs.

Examples should be seeded inside the relevant section content rather than in a separate top-level examples directory.

## Operating posture

Northstar defaults to lean governance:
- batch-based logging, not per-task logging
- manual-first evidence, automation only when recurring pain justifies it
- clear active queue + backlog separation to prevent roadmap sprawl
