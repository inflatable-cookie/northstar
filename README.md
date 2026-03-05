# Northstar

A reusable documentation system for projects.

## Repo layout

- `template-bundle/` contains the template artifact that gets copied into projects.
- `bundle-docs/` contains documentation about how to use, evolve, and maintain the bundle.
- `scripts/` contains automation helpers for bootstrap and upgrades.

Section examples should live inside `template-bundle/` alongside the section they demonstrate.

## Start here

1. Define template scope section-by-section in `bundle-docs/sections/` (`01-vision.md` through `04-reports.md`).
2. Implement approved sections inside `template-bundle/`.
3. Keep `bundle-docs/` in sync with any template changes.

## Current baseline focus

The initial template pass is anchored on four core sections:

- `vision`
- `architecture`
- `roadmaps` (generation-keyed with `roadmaps/backlog/`)
- `reports` (month-segmented)

Plus supported optional folders for implementation depth:

- `schemas`
- `templates`
- `contracts`
- `diagrams`
- `specs`

See `bundle-docs/jetstream-baseline.md` for source-pattern notes from Jetstream and Northstar-specific changes.

## Default posture

Northstar is intentionally lean by default:
- report by batch/update cycle, not by individual task
- prefer manual evidence before introducing automation/checker scripts
- keep one active roadmap queue and move deferred work into backlog
- treat `meta/` as deprecated and extract useful content into core/support docs
