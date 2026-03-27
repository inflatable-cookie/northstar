---
name: northstar-research
description: Use when research should shape Northstar decisions. Handles research intake, synthesis, and promotion into architecture and contracts so evidence does not get stranded in notes or inferred later in roadmap work.
---

# Northstar Research

Use this skill when the user asks to:

- run research that should shape architecture or execution
- take rough notes, links, transcripts, or findings and turn them into usable project decisions
- convert external evidence into explicit Northstar contracts
- turn research into architecture and contracts
- translate a memo into project-facing contract decisions
- stop research-backed decisions from getting lost between memos and roadmaps

## Outcome

Leave research-backed decisions promoted into usable Northstar surfaces rather
than stranded in raw notes or inferred later in roadmap work.

## Quick Start

Read:

- `docs/research/master-index.md` when present
- relevant `docs/research/specimen-dossiers/` or other intake notes when present
- relevant `docs/research/value-tracks/` when present
- relevant `docs/research/translation-memos/`
- `docs/research/research-to-implementation-playbook.md`
- `docs/architecture/system-architecture.md`
- `docs/contracts/contract-index.md`

## Workflow

1. Identify the project problem and the relevant research inputs: rough notes,
   dossiers, value tracks, translation memos, or other evidence artifacts.
2. Synthesize the recommendation, accepted tradeoffs, open questions, and
   validation needs.
3. Write or update the translation memo when the research is still too raw to
   promote directly.
4. Update architecture if the research changes system shape or invariants.
5. Create or update contracts when the finding defines execution-relevant
   behavior, interfaces, policies, or failure semantics.
6. Record any remaining unknowns as research or planning gaps instead of
   letting roadmap work absorb them implicitly.
7. Hand off to `northstar-plan` only after the contract surfaces exist.

## Required Outputs

- updated research translation memo, decision record, or other synthesis
  artifact when needed
- updated `system-architecture.md` when the recommendation changes architecture
- updated `contract-index.md`
- new or updated contract files for research-driven boundaries

## Guardrails

- Do not promote raw research directly into a roadmap batch.
- Do not treat rough notes as if they were already a stable planning decision.
- Do not skip contract creation when the research implies a concrete boundary.
- Do not hide missing evidence inside implementation notes; record the gap
  explicitly.

## Next Step

After promotion, hand work to `northstar-plan` so execution follows the
research-backed planning surface instead of ad hoc interpretation.
