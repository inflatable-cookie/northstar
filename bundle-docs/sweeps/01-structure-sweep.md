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
- `docs/triage/`

## Optional Add-On Folders (Not Required by Default)

- `docs/schemas/`
- `docs/templates/`
- `docs/diagrams/`
- `docs/specs/`
- `docs/research/`

Note: this applies to top-level `docs/templates/` only.
Section-local folders such as `docs/roadmaps/templates/` and `docs/logs/templates/` are part of the core structure.
If `docs/research/` exists, it should also own its own internal templates and anchor files.

## Required Anchor Files

- `docs/vision/README.md`
- `docs/architecture/README.md`
- `docs/contracts/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`
- `docs/research/README.md` (when `docs/research/` exists)
- `docs/triage/README.md`

## Planning Gate Files

Require these when the project is using strict planning or active multi-repo
delivery:

- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/contracts/contract-index.md`
- `docs/architecture/repo-authority-map.md` when more than one repo or
  authoritative deployable surface exists

## Drift Patterns

- Missing core folders or anchor files
- Strict-planning repos missing system inventory, contract index, or repo authority map
- Backlog outside `docs/roadmaps/backlog/`
- Optional add-on folders auto-seeded with no project-specific need
- Untracked or malformed `docs/triage/` notes and non-Markdown entries
- Canonical docs stored in deprecated areas (`docs/meta/`, root `backlog/`, root `decisions/`)

## Fix Rules

- Create missing required folders/files.
- Create missing planning gate files when the project claims strict planning or
  multi-repo execution readiness.
- Move backlog content into `docs/roadmaps/backlog/`.
- Do not create optional add-on folders unless project scope requires them.
- Remove empty/unused optional add-on folders created by default scaffolding.
- If `docs/research/` is a real project section, keep it and normalize it to the Northstar research layout.
- Keep `docs/triage/` as a lightweight capture buffer. Inspect every note and
  disposition it during refresh or cleanup; do not purge it by filename or age.
- Do clean moves only: update references and remove legacy folders in the same batch.
- Do not leave compatibility shim docs in deprecated folders.

## Fast Checks

```bash
find docs -maxdepth 3 -type d | sort
find docs -maxdepth 3 -type f | sort
```

## Completion Criteria

- All required core folders and anchor files exist.
- Projects using strict planning have the minimum planning gate files in place.
- Optional add-on folders are present only when justified by actual docs content.
- Optional `docs/research/` includes its own anchor file when present.
- No canonical content remains in deprecated structure.
