# 01 Structure Sweep

## Goal

Ensure required Northstar docs structure exists and deprecated top-level patterns are not used as canonical sources.

## Required Core Folders

- `docs/vision/`
- `docs/architecture/`
- `docs/contracts/`
- `docs/roadmaps/`
- `docs/roadmaps/backlog/`
- `docs/logs/`
- `docs/logs/templates/`

## Optional Add-On Folders (Not Required by Default)

- `docs/schemas/`
- `docs/templates/`
- `docs/diagrams/`
- `docs/specs/`

Note: this applies to top-level `docs/templates/` only.
Section-local folders such as `docs/roadmaps/templates/` and `docs/logs/templates/` are part of the core structure.

## Required Anchor Files

- `docs/vision/README.md`
- `docs/architecture/README.md`
- `docs/contracts/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

## Drift Patterns

- Missing core folders or anchor files
- Backlog outside `docs/roadmaps/backlog/`
- Optional add-on folders auto-seeded with no project-specific need
- Canonical docs stored in deprecated areas (`docs/meta/`, root `backlog/`, root `decisions/`)

## Fix Rules

- Create missing required folders/files.
- Move backlog content into `docs/roadmaps/backlog/`.
- Do not create optional add-on folders unless project scope requires them.
- Remove empty/unused optional add-on folders created by default scaffolding.
- Do clean moves only: update references and remove legacy folders in the same batch.
- Do not leave compatibility shim docs in deprecated folders.

## Fast Checks

```bash
find docs -maxdepth 3 -type d | sort
find docs -maxdepth 3 -type f | sort
```

## Completion Criteria

- All required core folders and anchor files exist.
- Optional add-on folders are present only when justified by actual docs content.
- No canonical content remains in deprecated structure.
