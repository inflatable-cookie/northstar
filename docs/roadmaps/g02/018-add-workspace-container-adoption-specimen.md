# 018 - Add Workspace-Container Adoption Specimen

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.017
Vision tags: `setup`, `workspace-container`, `docs-authority`, `effigy`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/021-workspace-container-adoption-specimen.md`
Planning state: complete

## Problem

Northstar now supports nested docs-authority repos as a first-class mode, but
the reusable package still lacks one concrete specimen for thin workspace roots
that delegate into a nested authority repo.

## Goals

- [x] decide that a specimen is warranted
- [x] add one concrete workspace-container adoption specimen
- [x] wire setup docs and templates to point at that specimen

## Execution Plan

### Batch 18.1 - Add Workspace-Container Adoption Specimen

- [x] close the nested-authority setup lane
- [x] add the specimen reference
- [x] update setup and template-selection guidance

## Acceptance Criteria

- [x] one concrete workspace-container specimen exists in setup references
- [x] setup docs point at that specimen when this mode is selected
- [x] multi-repo adoption no longer depends only on abstract prose

## Next Task

Open the follow-on posture-classification lane so the core skills can classify
repo state more mechanically instead of relying on operator interpretation.
