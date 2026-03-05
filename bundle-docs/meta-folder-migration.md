# Meta Folder Migration Playbook

Status: active
Updated: 2026-03-05

## Purpose

Migrate legacy per-project `meta/` folders into Northstar-aligned docs without losing useful operating knowledge.

## Policy

- `meta/` is deprecated as a default project docs folder.
- Extract useful patterns into project docs under core/support folders.
- Link back to Northstar docs for shared workflow guidance.

## Keep vs deprecate

Keep as supported docs folders:
- `vision`, `architecture`, `roadmaps`, `reports`
- `schemas`, `templates`, `contracts`, `diagrams`, `specs`

Deprecate as default folders:
- `meta`
- `decisions` (replace with decision reports)

## Extraction mapping

Map common `meta` content into Northstar-aligned locations:

- workflow guides -> `reports/` (dated updates) or `roadmaps/` (execution rules)
- guardrails/checklists -> `roadmaps/` milestone acceptance/evidence sections
- glossary/terminology -> `architecture/` or `specs/` where term ownership is explicit
- architecture inbox/backlog notes -> `roadmaps/backlog/`
- one-off audits -> dated `reports/YYYY-MM/`
- long-lived contracts/policies -> `contracts/` or `schemas/`

## Migration steps

1. Inventory all files in project `meta/`.
2. Classify each file as keep/extract/archive.
3. Move extracted content into target folder with updated links.
4. Replace `meta/` references in active docs with new paths.
5. Add one migration report documenting what moved and why.
6. Remove or archive `meta/` once references are clean.

## Notes from current scans

Observed reusable `meta` patterns worth keeping (from Chorus/Ledger/Underlay scans):
- collaboration role clarity and workflow boundaries
- reporting generation/naming policies
- guardrails for large-file decomposition and architectural hygiene
- runbook-style operational checklists

Observed patterns to avoid carrying forward verbatim:
- tool-specific procedural noise
- excessive checker scripts without clear run cadence/ownership

## Next task

Run this playbook on one existing project and publish a migration report listing extracted docs and removed `meta` files.
