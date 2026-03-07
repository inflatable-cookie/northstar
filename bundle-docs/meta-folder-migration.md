# Meta Folder Migration Playbook

Status: active
Updated: 2026-03-05

## Purpose

Migrate legacy per-project `meta/` folders into Northstar-aligned docs without losing useful operating knowledge.

## Policy

- `meta/` is deprecated as a default project docs folder.
- Extract useful patterns into project docs under core/support folders.
- Link back to Northstar docs for shared workflow guidance.

## Hard migration rule (clean cutover)

- Do not leave compatibility shim/stub files in deprecated folders (`meta/`, `decisions/`).
- Rewrite references in active docs to canonical target paths in the same migration batch.
- Remove deprecated folder files once reference rewrites are complete.
- Keep migration context in a dated log entry, not in compatibility shim documents.

## Keep vs deprecate

Keep as default core docs folders:
- `vision`, `architecture`, `contracts`, `roadmaps`, `logs`

Keep as optional add-on folders (create only when needed):
- `research`, `schemas`, `templates`, `diagrams`, `specs`

Deprecate as default folders:
- `meta`
- `decisions` (replace with decision logs)

## Extraction mapping

Map common `meta` content into Northstar-aligned locations:

- workflow guides -> `logs/` (dated updates) or `roadmaps/` (execution rules)
- guardrails/checklists -> `roadmaps/` milestone acceptance/evidence sections
- glossary/terminology -> `architecture/` or optional `specs/` where term ownership is explicit
- architecture inbox/backlog notes -> `roadmaps/backlog/`
- one-off audits -> dated `logs/YYYY-MM/`
- long-lived contracts/policies -> `contracts/` or optional `schemas/`
- comparative studies, source maps, and competitive teardowns -> `research/`

## Migration steps

1. Inventory all files in project `meta/`.
2. Classify each file as keep/extract/archive.
3. Move extracted content into target folder with updated links.
4. Replace `meta/` references in active docs with new paths.
5. Add one migration log documenting what moved and why.
6. Remove deprecated folder files once references are clean; do not leave shim docs behind.

## Notes from current scans

Observed reusable `meta` patterns worth keeping (from Chorus/Ledger/Underlay scans):
- collaboration role clarity and workflow boundaries
- logging generation/naming policies
- guardrails for large-file decomposition and architectural hygiene
- runbook-style operational checklists

Observed patterns to avoid carrying forward verbatim:
- tool-specific procedural noise
- excessive checker scripts without clear run cadence/ownership

## Next task

Run this playbook on one existing project and publish a migration log listing extracted docs and removed `meta` files.
