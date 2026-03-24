---
name: northstar-roadmap-compiler
description: Use when Northstar roadmap milestones need to be generated, laid out, sequenced, or revised from approved contracts. Compiles contract-backed work into batches and refuses to plan against missing contracts or inferred cross-repo behavior.
---

# Northstar Roadmap Compiler

Use this skill when the user asks to:

- generate roadmap milestones from completed Northstar planning
- lay out the next few roadmaps or milestones from completed planning
- sequence the next batches from approved contracts
- revise roadmap batches after contracts or architecture changed
- keep agents from writing speculative roadmap work

## Outcome

Produce roadmap milestones that sequence only contract-approved work.

## Quick Start

Inspect:

```sh
effigy tasks
```

Then read:

- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` when present
- `docs/contracts/contract-index.md`
- the relevant `docs/contracts/*.md`
- `docs/roadmaps/generation-index.md`
- active roadmap milestones in the current generation

## Workflow

1. Confirm the target work is fully represented in architecture, inventory, and
   contracts.
2. If any required contract is missing, stop and surface a planning gap instead
   of drafting speculative batches.
3. Group work into meaningful batches with clear acceptance criteria and
   evidence requirements.
4. Reference governing contract ids directly in each roadmap milestone.
5. Keep planning gaps visible in the milestone until they are closed.
6. Recommend generation rollover only when contract or architecture shifts make
   the current sequencing baseline misleading.

## Required Outputs

- new or updated roadmap milestones under `docs/roadmaps/gNN/`
- direct contract references for each milestone
- explicit planning gap callouts where execution is blocked
- generation-index updates when rollover is required

## Guardrails

- Do not compile roadmap work from intuition or “likely behavior.”
- Do not bury missing dependencies inside risk sections.
- Do not let one repo’s roadmap imply ownership over another repo without an
  authority map and contract support.
- Do not create micro-batches; keep execution grouped into meaningful chunks.

## Next Step

Once a milestone is approved, execute one batch at a time and log completed
evidence before moving to the next compiled batch.
