# 006 - Align Archive-Aware Skill And Setup Surfaces

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.005
Vision tags: `skills`, `setup`, `archive`, `planning-hygiene`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/009-archive-aware-skill-and-setup-surfaces.md`
Planning state: ready

## Problem

Northstar now has a cleaner specs lifecycle and archive posture, but the
reusable automation layer still under-expresses that behavior. Setup, planning,
and recovery mention archiving, yet they do not make the archive surface
explicit enough for downstream repos to inherit it automatically.

## Goals

- [x] define the archive-aware contract for setup, planning, and recovery
- [x] apply that alignment to the reusable skills and bundle surfaces
- [ ] re-prove that the resulting reusable surface is explicit enough

## Non-Goals

- [ ] building heavy archive automation
- [ ] reopening the docs-tree cleanup already completed in `g02.005`

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 6.1 - Define Archive-Aware Skill Contract

- [x] define what setup, planning, and recovery should expose about the archive
  posture
- [x] define the corresponding bundle/template expectations
- [x] leave the implementation batch explicit and ready

### Batch 6.2 - Apply Archive-Aware Skill Alignment

- [x] update the reusable skills and references
- [x] update the relevant bundle/template surfaces and checks
- [x] keep the archive posture explicit without over-automating it

### Batch 6.3 - Re-Prove The Archive-Aware Surface

- [x] inspect the resulting reusable surface again
- [x] record what ambiguity still remains acceptable
- [x] compile the next slice only if a bounded problem remains

## Acceptance Criteria

- [x] The archive-aware contract is explicit in the reusable automation layer.
- [x] The bundle reflects the same archive-aware setup posture.
- [x] The resulting reusable surface is re-proved after the alignment work.

## Risks and Mitigations

- Risk: the lane adds more archive machinery than the doctrine needs.
- Mitigation: keep the work focused on explicit setup/planning/recovery
  behavior, not automation for its own sake.

- Risk: the lane duplicates the already-finished docs cleanup.
- Mitigation: treat `g02.005` as complete and work only on reusable surfaces.

## Planning Gaps

- none

## Evidence Requirements

- [x] skill/bundle contract updates for the archive-aware definition batch
- [x] implementation log for the reusable-surface alignment batch
- [x] re-proof log for the aligned reusable surface

## Next Task

Start `g02.007` batch `7.2` by applying the continuation-envelope and
stop-signal contract to the working rules, templates, and handoff/planning
surfaces.
