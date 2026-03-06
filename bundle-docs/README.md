# Bundle Docs

This directory explains how Northstar works.

It should document:

- adoption flow for new and existing projects
- customization boundaries
- maintenance and upgrade policy
- contributor guidance for changing the bundle safely

Current spec work lives in `bundle-docs/sections/` (`01-vision.md` through `04-logs.md`).

## Effigy-First Loop

From the repo root:

```bash
effigy tasks --repo .
effigy health --repo .
effigy validate --repo .
```

Northstar is a docs/template repo, so the default Effigy surface is bundle-integrity validation rather than runtime build orchestration.

Default bundle policy:
- include only core folders by default
- add `schemas/`, `templates/`, `diagrams/`, and `specs/` only when project needs justify them

Agent sweep pack for drift detection and repair:
- `bundle-docs/sweeps/README.md`

Additional migration guidance:
- `meta-folder-migration.md` for deprecating project-level `meta/`

## Governance posture

Northstar intentionally favors lean governance over heavy operational overhead.
Use scripts/checkers selectively, and default to concise batch-level logs with concrete evidence.
