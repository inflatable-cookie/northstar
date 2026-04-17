# Compile Roadmaps Mode

Use this mode when architecture, inventory, authority, and contracts already
exist and the user wants the next milestones or batches.

## Goal

Produce roadmap milestones that sequence only contract-approved work and leave
a bounded execution runway rather than one-card-at-a-time improvisation.

## Steps

1. Confirm the target work is fully represented in architecture, inventory, and
   contracts.
2. Classify the active repo posture before compiling anything:
   - `baseline-routing`
   - `strict-ready`
   - `strict-paused`
   - `migration`
   - `drifted`
3. If there is a spec for this lane, confirm its durable outcomes have already
   been promoted into the canonical surfaces the roadmap will reference.
4. If any required contract is missing, stop and surface a planning gap instead
   of drafting speculative batches.
5. Group work into meaningful batches with clear acceptance criteria and
   evidence requirements.
6. Make the lane runway explicit:
   - the higher-level owner of the lane
   - the immediate ready card or paused gate
   - the next few meaningful batches or milestone transitions beyond it
   - the next planning checkpoint where strategy or intent may need review
7. Apply the repo's readiness rubric before marking a card or short chain
   `ready`:
   - the work is bounded enough to execute without fresh planning decisions
   - the governing refs are current and canonical
   - acceptance criteria, validation, evidence requirements, and stop
     conditions are explicit
   - no unresolved planning gap still governs the work
   - any auto-continuation transition is already represented in file state
8. If the posture is `strict-paused`, compile toward a paused planning gate or
   intent checkpoint instead of pretending the lane is ready for execution.
9. Reference governing contract ids directly in each roadmap milestone.
10. Keep planning gaps visible in the milestone until they are closed.
11. Recommend generation rollover only when contract or architecture shifts make
   the current sequencing baseline misleading, the generation has had a
   substantial run already, and the repo is ready to close that generation
   cleanly rather than escaping local cleanup.
12. Before recommending rollover, confirm all current-generation milestones can
   be marked closed, superseded, or rehomed and that stale specs or batch cards
   from that generation can be archived or removed from `docs/specs/`.
13. Treat any remaining spec for the lane as context only; do not let it outrank
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
- Do not leave execution with only one visible next card when the lane clearly
  needs a broader runway or an explicit planning checkpoint.
- Do not suggest rollover after only a handful of milestones. Expect something
  closer to a 20-to-40-milestone generation unless a real sequencing reset
  clearly justifies earlier closure.
- Do not open a new generation while the current one still has live milestones
  or stale specs that should have been cleaned up first.
