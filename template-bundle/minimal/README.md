# Minimal Starter Bundle

**Type: PRODUCT ARTIFACT** -- Copy this directory into your project's `docs/`.

This is the smallest viable Northstar setup.

Copy these folders into your project's `docs/` directory and delete anything you do not need.

## What Is Here

Five core folders, no examples, no optional add-ons.

```
docs/
├── vision/
│   ├── README.md
│   └── 001-<your-project>-vision.md      ← create this first
├── architecture/
│   ├── README.md
│   └── system-architecture.md
├── contracts/
│   ├── README.md
│   └── contract-index.md
├── roadmaps/
│   ├── README.md
│   ├── generation-index.md
│   └── g01/
│       └── README.md
└── logs/
    ├── README.md
    └── YYYY-MM/
        └── .gitkeep
```

## How to Use

1. Copy this folder into your project.
2. Delete `minimal/` wrapper; keep the `docs/` contents.
3. Create `docs/vision/001-<your-project>-vision.md` before anything else.
4. Add `docs/architecture/system-architecture.md` before creating roadmaps.
5. Create the first roadmap milestone only after contracts exist.
6. Add logs per completed batch.

## Naming Conventions

- Vision: `docs/vision/NNN-<slug>.md`
- Architecture: `docs/architecture/<slug>.md`
- Contracts: `docs/contracts/NNN-<slug>.md`
- Roadmaps: `docs/roadmaps/gNN/NNN-<slug>.md`
- Logs: `docs/logs/YYYY-MM/DD-HHMMSS-<slug>.md`

## When to Expand

Add optional folders only when your project needs them:

- `research/` -- external comparison or source-backed exploration
- `schemas/` -- data models or API schemas
- `templates/` -- reusable doc templates
- `diagrams/` -- architecture diagrams
- `specs/` -- provisional planning before promotion (strict posture)

## Full Template Bundle

If you want examples, templates, and the complete file set, use the parent [`template-bundle/`](../) instead.

## Next Step

Open `vision/README.md` and write `001-<your-project>-vision.md`.
