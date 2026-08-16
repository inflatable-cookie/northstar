# 079 - Audit and Optimize Always-Loaded Agent Instructions

Status: complete
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/028-agent-instruction-surface-optimization.md`
Governing refs: `docs/contracts/003-agent-instruction-surface.md`,
`docs/architecture/system-architecture.md`,
`bundle-docs/research/translation-memos/agent-instruction-surface-optimization.md`
Auto-start next card: no

## Ready-State Checks

- [x] Objective is bounded enough to complete without a fresh product decision.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope, acceptance, validation, and stop conditions are explicit.
- [x] No unresolved intent checkpoint governs the card.
- [x] Consumer repositories are explicitly out of scope.

Implementation and closeout are complete; the later consumer measurement phase
remains in the milestone rather than in this implementation card.

## Objective

Add a deterministic, read-only audit for always-loaded agent instruction files,
then use its report to compact Northstar's source and copy-ready `AGENTS.md`
files without losing safety, authority, compatibility, worktree, or validation
boundaries.

## Scope

- Add `effigy check:agent-instructions` or an equivalent Effigy-native audit
  covering the source file and a supplied template/path.
- Report non-blank lines, bytes, approximate token cost, section inventory,
  duplicate/reference candidates, broken links, command candidates, and soft
  budget warnings.
- Keep the audit advisory and explainable; it must not rewrite or delete files.
- Review the current Northstar `AGENTS.md` and the copy-ready template against
  the content-class contract.
- Move detailed rules to their existing canonical surfaces where possible,
  leaving short pointers in the root files.
- Compact the source and template files and record the before/after evidence.
- Update setup/template guidance so agents know when to use root instructions,
  nested instructions, contracts, guides, and skills.

### Explicitly out of scope

- no Poodle or Figmatic changes;
- no automatic AGENTS rewriting or policy deletion;
- no provider-specific instruction format;
- no migration of every existing consumer repository;
- no removal of safety, authority, compatibility, worktree, or stop boundaries;
- no task-specific current-state or roadmap content in the root file.

## Acceptance criteria

- the audit is deterministic, read-only, and works against both source and
  template instruction files;
- measurements include lines, bytes, and approximate tokens;
- the audit flags likely scoped, procedural, historical, duplicated, or stale
  content without pretending semantic classification is perfect;
- the final root files retain only every-turn content and concise pointers;
- all removed detail has a canonical surviving home or an explicit disposition;
- retained commands are verified or labelled conditional;
- `git diff --check`, `effigy qa`, `effigy qa:docs`, and `effigy doctor` pass;
- both installed Northstar skill parity checks pass;
- no consumer repository files change.

## Evidence required

- before/after line, byte, and approximate-token measurements;
- audit output for the source and template;
- exact changed-file list;
- disposition table for moved, retained, removed, and unresolved content;
- validation and parity output;
- a short manual review against `docs/contracts/003-agent-instruction-surface.md`.

## Stop conditions

- a proposed move has no discoverable canonical destination;
- a safety or authority boundary would become less visible;
- a command or link cannot be verified honestly;
- the compact file causes common agents to perform more archaeology;
- the audit needs provider-specific behavior or network access to remain useful.

## Resolution

Implemented directly on Northstar's source branch:

- added `docs/contracts/003-agent-instruction-surface.md` and its copy-ready
  template;
- added the read-only `effigy check:agent-instructions` Rhai task;
- compacted the source and copy-ready `AGENTS.md` files;
- updated indexes, contract inventories, and setup guidance;
- refreshed both installed skill copies and proved 34-file parity.

The source root fell from 95 to 43 non-blank lines and from 5,690 to 2,619
bytes. The template fell from 100 to 35 non-blank lines and from 5,203 to 1,707
bytes. Full evidence is in
`docs/logs/2026-08/16-233931-optimize-agent-instruction-surface.md`.

## Next task

Use the optimized surface in the later Poodle-first consumer dogfood. Do not
touch Figmatic while its direct interactive bug-fixing work continues.
