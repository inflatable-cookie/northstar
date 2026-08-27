# 027 - Optimize Always-Loaded Agent Instruction Surfaces

Status: complete
Owner: repo maintainers
Created: 2026-08-16
Depends on: `g02.026` planning surfaces
Vision tags: `agent-efficiency`, `context-budget`, `agents-md`, `instruction-audit`
Master spec refs: `docs/specs/028-agent-instruction-surface-optimization.md`
Governing refs: `docs/contracts/003-agent-instruction-surface.md`,
`bundle-docs/research/translation-memos/agent-instruction-surface-optimization.md`
Planning state: ready for implementation

## Problem

The root instruction file is always-loaded context. Northstar needs to keep it
useful on nearly every turn without turning it into a duplicate handbook or
procedural dump.

## Goals

- [x] research current cross-agent instruction-file guidance;
- [x] define Northstar's always-loaded versus scoped/on-demand content contract;
- [x] add a deterministic read-only instruction-surface audit;
- [x] compact the Northstar source `AGENTS.md` without losing boundaries;
- [x] compact the copy-ready `AGENTS.md` template;
- [x] provide a minimal Claude Code bridge that imports `@AGENTS.md`;
- [x] prove command, link, docs, doctor, and skill-parity validation;
- [x] measure operator-provided live use for context pollution and missed guidance.

## Execution plan

### Batch 27.1 — Research and contract

- [x] write the external-evidence translation memo;
- [x] promote the content-class and root-budget contract;
- [x] define the audit and compaction acceptance criteria.

### Batch 27.2 — Audit and compact

- [x] implement the read-only audit;
- [x] audit the current source and template files;
- [x] move detailed content to canonical references where needed;
- [x] rewrite the source and template root files;
- [x] add and validate the source/template Claude bridges;
- [x] validate the final diff and parity.

### Batch 27.3 — Feedback intake and measure

- [x] consume operator-provided feedback from live use of the optimized surface;
- [x] record repeated questions, missed boundaries, setup failures, and
      unnecessary exploration;
- [x] adjust the contract only from measured evidence.

Batch 27.3 used the operator's T3 Code comparison to correct an over-compact,
classification-led review model. Card 101 and
`docs/logs/2026-08/27-160408-make-agent-instruction-reviews-intentful.md` carry
the implementation and evidence.

Implementation closeout for `g02.027/079`: `docs/logs/2026-08/16-233931-optimize-agent-instruction-surface.md`.

## Acceptance criteria

- root instruction files are high-signal and within the soft review target unless
  a documented exception exists;
- the audit is deterministic, read-only, and explainable;
- the audit never silently deletes instructions or weakens policy;
- source and template files retain discoverable safety, authority, compatibility,
  worktree, and validation rules;
- detailed procedures remain available from canonical on-demand surfaces;
- QA and installed-skill parity pass;
- no Poodle or Figmatic repository files change.

## Next task

No blocking work remains. Accept further operator-provided feedback without
dispatching or managing a consumer run.
