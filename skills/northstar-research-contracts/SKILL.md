---
name: northstar-research-contracts
description: Use when research findings need to be promoted into Northstar architecture and contracts, especially when users ask to turn research, memos, or findings into project-facing contract decisions before roadmap execution begins.
---

# Northstar Research To Contracts

Use this skill when the user asks to:

- run research that should shape architecture or execution
- convert external evidence into explicit Northstar contracts
- turn research into architecture and contracts
- translate a memo into project-facing contract decisions
- stop research-backed decisions from getting lost between memos and roadmaps

## Outcome

Leave research-backed decisions promoted into architecture and contracts rather
than stranded in research notes or inferred later in roadmap work.

## Quick Start

Read:

- `docs/research/master-index.md` when present
- relevant `docs/research/translation-memos/`
- `docs/research/research-to-implementation-playbook.md`
- `docs/architecture/system-architecture.md`
- `docs/contracts/contract-index.md`

## Workflow

1. Identify the project problem and the relevant translation memo.
2. Extract the recommendation, accepted tradeoffs, and validation needs.
3. Update architecture if the research changes system shape or invariants.
4. Create or update contracts when the finding defines execution-relevant
   behavior, interfaces, policies, or failure semantics.
5. Record any remaining unknowns as research or planning gaps instead of
   letting roadmap work absorb them implicitly.
6. Hand off to roadmap generation only after the contract surfaces exist.

## Required Outputs

- updated research translation memo or decision record when needed
- updated `system-architecture.md` when the recommendation changes architecture
- updated `contract-index.md`
- new or updated contract files for research-driven boundaries

## Guardrails

- Do not promote raw research directly into a roadmap batch.
- Do not skip contract creation when the research implies a concrete boundary.
- Do not hide missing evidence inside implementation notes; record the gap
  explicitly.

## Next Step

After promotion, compile the affected roadmap milestones so execution follows
the research-backed contract surface instead of ad hoc interpretation.
