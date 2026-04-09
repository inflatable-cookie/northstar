# Compile Roadmaps Mode

Use this mode when architecture, inventory, authority, and contracts already
exist and the user wants the next milestones or batches.

## Goal

Produce roadmap milestones that sequence only contract-approved work.

## Steps

1. Confirm the target work is fully represented in architecture, inventory, and
   contracts.
2. If there is a spec for this lane, confirm its durable outcomes have already
   been promoted into the canonical surfaces the roadmap will reference.
3. If any required contract is missing, stop and surface a planning gap instead
   of drafting speculative batches.
4. Group work into meaningful batches with clear acceptance criteria and
   evidence requirements.
5. Apply the repo's readiness rubric before marking a card or short chain
   `ready`:
   - the work is bounded enough to execute without fresh planning decisions
   - the governing refs are current and canonical
   - acceptance criteria, validation, evidence requirements, and stop
     conditions are explicit
   - no unresolved planning gap still governs the work
   - any auto-continuation transition is already represented in file state
6. Reference governing contract ids directly in each roadmap milestone.
7. Keep planning gaps visible in the milestone until they are closed.
8. Recommend generation rollover only when contract or architecture shifts make
   the current sequencing baseline misleading.
9. Treat any remaining spec for the lane as context only; do not let it outrank
   the promoted canonical surfaces.

## Guardrails

- Do not compile roadmap work from intuition or likely behavior.
- Do not compile roadmap work from a provisional spec when the durable outcomes
  have not yet been promoted.
- Do not treat a stale spec as silent permission to outrun the promoted
  architecture and contracts.
- Do not bury missing dependencies inside risk sections.
- Do not let one repo's roadmap imply ownership over another repo without an
  authority map and contract support.
- Do not create micro-batches; keep execution grouped into meaningful chunks.
- Do not mark a batch `ready` just because it is next in sequence.
