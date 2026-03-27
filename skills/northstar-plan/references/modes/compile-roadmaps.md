# Compile Roadmaps Mode

Use this mode when architecture, inventory, authority, and contracts already
exist and the user wants the next milestones or batches.

## Goal

Produce roadmap milestones that sequence only contract-approved work.

## Steps

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

## Guardrails

- Do not compile roadmap work from intuition or likely behavior.
- Do not bury missing dependencies inside risk sections.
- Do not let one repo's roadmap imply ownership over another repo without an
  authority map and contract support.
- Do not create micro-batches; keep execution grouped into meaningful chunks.
